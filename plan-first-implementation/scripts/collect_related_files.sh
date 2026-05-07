#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  collect_related_files.sh [--cwd PATH] [--max-files N] [--max-matches N] [--hidden] [--glob PATTERN]... TERM [TERM...]

Description:
  Read-only helper that searches the current repo for filename and content matches,
  then prints a ranked seed list of related files plus a few matching lines.

Notes:
  - Output goes to stdout only.
  - The ranking is a heuristic: filename match x5 + content hit x1.
  - Review the output manually before updating a plan document.
EOF
}

escape_regex() {
  printf '%s' "$1" | sed -e 's/[][(){}.^$*+?|\\/]/\\&/g'
}

require_positive_int() {
  local value="$1"
  local label="$2"

  if [[ ! "$value" =~ ^[0-9]+$ ]] || (( value < 1 )); then
    printf 'error: %s must be a positive integer\n' "$label" >&2
    exit 1
  fi
}

SEARCH_ROOT="."
MAX_FILES=25
MAX_MATCHES=40
INCLUDE_HIDDEN=0
GLOBS=()
HAS_GLOBS=0
TERMS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --cwd)
      SEARCH_ROOT="${2:-}"
      shift 2
      ;;
    --max-files)
      MAX_FILES="${2:-}"
      shift 2
      ;;
    --max-matches)
      MAX_MATCHES="${2:-}"
      shift 2
      ;;
    --hidden)
      INCLUDE_HIDDEN=1
      shift
      ;;
    --glob)
      GLOBS+=("${2:-}")
      HAS_GLOBS=1
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      TERMS+=("$@")
      break
      ;;
    -*)
      printf 'error: unknown option %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
    *)
      TERMS+=("$1")
      shift
      ;;
  esac
done

require_positive_int "$MAX_FILES" "--max-files"
require_positive_int "$MAX_MATCHES" "--max-matches"

if [[ ${#TERMS[@]} -eq 0 ]]; then
  printf 'error: provide at least one search term\n' >&2
  usage >&2
  exit 1
fi

if [[ ! -d "$SEARCH_ROOT" ]]; then
  printf 'error: search root not found: %s\n' "$SEARCH_ROOT" >&2
  exit 1
fi

SEARCH_ROOT="$(cd "$SEARCH_ROOT" && pwd)"

TERM_REGEX=""
for term in "${TERMS[@]}"; do
  escaped="$(escape_regex "$term")"
  if [[ -z "$TERM_REGEX" ]]; then
    TERM_REGEX="$escaped"
  else
    TERM_REGEX="${TERM_REGEX}|${escaped}"
  fi
done

FILENAME_TMP="$(mktemp)"
CONTENT_TMP="$(mktemp)"
SUMMARY_TMP="$(mktemp)"
trap 'rm -f "$FILENAME_TMP" "$CONTENT_TMP" "$SUMMARY_TMP"' EXIT

if command -v rg >/dev/null 2>&1; then
  (
    cd "$SEARCH_ROOT"

    FILE_CMD=(rg --files)
    CONTENT_CMD=(rg -n --color never -S "$TERM_REGEX" .)

    if (( INCLUDE_HIDDEN )); then
      FILE_CMD+=(--hidden)
      CONTENT_CMD+=(--hidden)
    fi

    if (( HAS_GLOBS )); then
      for glob in "${GLOBS[@]}"; do
        FILE_CMD+=(--glob "$glob")
        CONTENT_CMD+=(--glob "$glob")
      done
    fi

    "${FILE_CMD[@]}" | rg --color never -S "$TERM_REGEX" > "$FILENAME_TMP" || true
    "${CONTENT_CMD[@]}" > "$CONTENT_TMP" || true
  )
else
  if (( HAS_GLOBS )); then
    printf 'warning: --glob is ignored because rg is not available\n' >&2
  fi

  (
    cd "$SEARCH_ROOT"

    find . \
      -path './.git' -prune -o \
      -path './node_modules' -prune -o \
      -type f -print \
      | sed 's#^./##' \
      | grep -Ei "$TERM_REGEX" > "$FILENAME_TMP" || true

    grep -RInE --binary-files=without-match \
      --exclude-dir=.git \
      --exclude-dir=node_modules \
      "$TERM_REGEX" . \
      | sed 's#^\./##' > "$CONTENT_TMP" || true
  )
fi

TAB=$'\t'
awk -F: '
  FNR == NR {
    path = $0
    if (path == "") {
      next
    }
    sub(/^\.\//, "", path)
    filename_hits[path] += 1
    score[path] += 5
    next
  }
  {
    path = $1
    if (path == "") {
      next
    }
    sub(/^\.\//, "", path)
    content_hits[path] += 1
    score[path] += 1
  }
  END {
    for (path in score) {
      printf "%d\t%d\t%d\t%s\n", score[path], filename_hits[path] + 0, content_hits[path] + 0, path
    }
  }
' "$FILENAME_TMP" "$CONTENT_TMP" \
  | LC_ALL=C sort -t "$TAB" -k1,1nr -k4,4 \
  | head -n "$MAX_FILES" > "$SUMMARY_TMP"

printf '# Related File Seed\n'
printf 'search root: %s\n' "$SEARCH_ROOT"
printf 'terms: %s\n' "${TERMS[*]}"
printf 'scoring: filename match x5 + content hit x1\n'
printf '\n'

if [[ ! -s "$SUMMARY_TMP" ]]; then
  printf 'No filename or content matches found.\n'
  exit 0
fi

printf 'Top candidate files:\n'

rank=0
printed_matches=0

while IFS=$'\t' read -r score filename_hits content_hits path; do
  rank=$((rank + 1))
  printf '%d. %s (score=%s, filename=%s, content=%s)\n' \
    "$rank" "$path" "$score" "$filename_hits" "$content_hits"

  if (( printed_matches >= MAX_MATCHES )); then
    continue
  fi

  remaining=$((MAX_MATCHES - printed_matches))
  per_file_limit=3
  if (( remaining < per_file_limit )); then
    per_file_limit=$remaining
  fi

  sample="$(
    awk -F: -v target="$path" -v limit="$per_file_limit" '
      {
        file = $1
        sub(/^\.\//, "", file)
      }
      file == target {
        text = $0
        sub(/^[^:]+:[0-9]+:/, "", text)
        gsub(/\t/, " ", text)
        sub(/^ /, "", text)
        printf "   L%s: %s\n", $2, text
        count += 1
        if (count >= limit) {
          exit
        }
      }
    ' "$CONTENT_TMP"
  )"

  if [[ -n "$sample" ]]; then
    printf '%s\n' "$sample"
    sample_count="$(printf '%s' "$sample" | awk 'NF { count += 1 } END { print count + 0 }')"
    printed_matches=$((printed_matches + sample_count))
  else
    printf '   (filename-only hit)\n'
  fi
done < "$SUMMARY_TMP"

if (( printed_matches >= MAX_MATCHES )); then
  printf '\nSample limit reached at %d matching lines.\n' "$MAX_MATCHES"
fi
