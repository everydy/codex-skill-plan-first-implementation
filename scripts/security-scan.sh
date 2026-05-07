#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

status=0

run_scan() {
  local label="$1"
  local pattern="$2"

  echo "== ${label} =="
  if rg -n -i --hidden --glob '!.git/**' --glob '!scripts/security-scan.sh' -- "$pattern" .; then
    echo "FAIL: ${label} found matches"
    status=1
  else
    echo "PASS: ${label}"
  fi
  echo
}

run_scan "private local paths" '(/Users/moonsoo|/Users/[^[:space:]`"'"'"'<>]+|codex-skills-user|Obsidian Vault)'
run_scan "GitHub/OpenAI-style tokens" '(gho_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,})'
run_scan "private key blocks" '-----BEGIN (RSA |OPENSSH |)?PRIVATE KEY-----'
run_scan "secret assignments" '(password|token|secret|api[_-]?key)[[:space:]]*[:=][[:space:]]*["'"'"'`][^"'"'"'`]{6,}["'"'"'`]'

if command -v gitleaks >/dev/null 2>&1; then
  echo "== gitleaks history scan =="
  if gitleaks detect --source . --no-banner --redact --verbose; then
    echo "PASS: gitleaks"
  else
    echo "FAIL: gitleaks found findings"
    status=1
  fi
  echo
else
  echo "SKIP: gitleaks is not installed"
  echo
fi

if command -v trufflehog >/dev/null 2>&1; then
  echo "== trufflehog filesystem scan =="
  if trufflehog filesystem . --no-update --fail --exclude-paths <(printf '^\\.git/\n') 2>/dev/null; then
    echo "PASS: trufflehog"
  else
    echo "FAIL: trufflehog found findings"
    status=1
  fi
  echo
fi

exit "$status"
