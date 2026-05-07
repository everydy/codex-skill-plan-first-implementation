#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path


HEADING_RE = re.compile(r"^(#{1,6})\s+(.*?)\s*$")

SECTION_HINTS = {
    "Goal": "State the product or user outcome, not only the code action.",
    "Requested Outcome": "Separate the user's request from your own implementation choices.",
    "Codebase Evidence": "Add confirmed, inferred, and unverified findings tied to real files.",
    "System Visualization": "Add an in-document map of the in-scope elements, their connections, and changed vs preserved nodes.",
    "Related Files": "List the files that currently own the behavior or likely need edits.",
    "Current Behavior": "Summarize the baseline behavior that will anchor the change.",
    "Change Map": "Name the likely edit points, mapped visual nodes, data flow, and remaining narrow unknowns.",
    "Planned Changes": "Describe expected edits plus constraints that must stay unchanged.",
    "Review Notes": "Capture risks, assumptions, and unanswered questions before patching.",
    "Execution Plan": "Reduce the plan to a short patch order plus verification steps.",
    "Validation": "Define manual checks, repo commands, and scenario-to-surface checks for the changed behavior.",
}

SECTION_ALIASES = {
    "Change Map": {"Likely Edit Map"},
}


@dataclass(frozen=True)
class Heading:
    level: int
    title: str
    line_no: int


@dataclass(frozen=True)
class Section:
    title: str
    line_no: int
    body: tuple[str, ...]


def parse_headings(lines: list[str]) -> list[Heading]:
    headings: list[Heading] = []
    for index, line in enumerate(lines, start=1):
        match = HEADING_RE.match(line)
        if match:
            headings.append(
                Heading(
                    level=len(match.group(1)),
                    title=match.group(2).strip(),
                    line_no=index,
                )
            )
    return headings


def extract_sections(lines: list[str], headings: list[Heading], level: int) -> list[Section]:
    sections: list[Section] = []
    relevant = [heading for heading in headings if heading.level == level]

    for heading in relevant:
        end_line = len(lines) + 1
        for later in headings:
            if later.line_no > heading.line_no and later.level <= level:
                end_line = later.line_no
                break
        body = tuple(line.rstrip("\n") for line in lines[heading.line_no:end_line - 1])
        sections.append(Section(title=heading.title, line_no=heading.line_no, body=body))

    return sections


def normalize(text: str) -> str:
    return re.sub(r"\s+", " ", text.strip())


def meaningful_lines(body: tuple[str, ...]) -> list[str]:
    return [line for line in body if normalize(line)]


def template_sections() -> tuple[list[str], dict[str, set[str]]]:
    skill_root = Path(__file__).resolve().parent.parent
    template_path = skill_root / "assets" / "plan-document-template.md"
    lines = template_path.read_text(encoding="utf-8").splitlines()
    headings = parse_headings(lines)
    sections = extract_sections(lines, headings, level=2)

    ordered_titles = [section.title for section in sections]
    placeholder_lines = {
        section.title: {normalize(line) for line in meaningful_lines(section.body)}
        for section in sections
    }
    return ordered_titles, placeholder_lines


def section_strength(section: Section, placeholders: dict[str, set[str]]) -> tuple[int, int]:
    raw_lines = meaningful_lines(section.body)
    placeholder_set = placeholders.get(section.title, set())
    placeholder_hits = sum(1 for line in raw_lines if normalize(line) in placeholder_set)
    effective_lines = max(len(raw_lines) - placeholder_hits, 0)
    return effective_lines, placeholder_hits


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Print a section index and follow-up seed for an existing plan document."
    )
    parser.add_argument("plan_doc", help="Path to the markdown plan document")
    parser.add_argument(
        "--min-lines",
        type=int,
        default=3,
        help="Minimum effective non-empty lines before a section is considered thin (default: 3)",
    )
    args = parser.parse_args()

    if args.min_lines < 1:
        parser.error("--min-lines must be >= 1")

    plan_path = Path(args.plan_doc).expanduser().resolve()
    if not plan_path.is_file():
        print(f"error: plan document not found: {plan_path}", file=sys.stderr)
        return 1

    lines = plan_path.read_text(encoding="utf-8").splitlines()
    headings = parse_headings(lines)
    major_sections = extract_sections(lines, headings, level=2)

    template_titles, placeholder_lines = template_sections()
    present_titles = {section.title for section in major_sections}
    missing_titles = []
    for title in template_titles:
        aliases = SECTION_ALIASES.get(title, set())
        if title in present_titles or aliases.intersection(present_titles):
            continue
        missing_titles.append(title)

    thin_sections: list[tuple[Section, int, int]] = []
    for section in major_sections:
        effective_lines, placeholder_hits = section_strength(section, placeholder_lines)
        if effective_lines < args.min_lines:
            thin_sections.append((section, effective_lines, placeholder_hits))

    title_heading = next((heading for heading in headings if heading.level == 1), None)

    print("# Plan Update Seed")
    print(f"plan doc: {plan_path}")
    if title_heading:
        print(f"title: {title_heading.title}")
    print(f"h2 sections: {len(major_sections)}")
    print()

    print("Section index:")
    if headings:
        for heading in headings:
            print(f"- L{heading.line_no}: H{heading.level} {heading.title}")
    else:
        print("- no headings found")
    print()

    print("Template coverage:")
    print(f"- present: {len(template_titles) - len(missing_titles)}/{len(template_titles)} standard sections")
    if missing_titles:
        for title in missing_titles:
            hint = SECTION_HINTS.get(title, "Add a concrete section body before execution.")
            print(f"- missing: {title} -> {hint}")
    else:
        print("- missing: none")
    print()

    print("Potentially thin sections:")
    if thin_sections:
        for section, effective_lines, placeholder_hits in thin_sections:
            hint = SECTION_HINTS.get(section.title, "Add more concrete, repo-grounded detail.")
            detail = f"effective-lines={effective_lines}"
            if placeholder_hits:
                detail += f", placeholder-lines={placeholder_hits}"
            print(f"- L{section.line_no}: {section.title} ({detail}) -> {hint}")
    else:
        print("- none detected with current threshold")
    print()

    print("Follow-up seed:")
    print("- Preserve existing headings when possible; add only newly verified evidence and remaining work.")
    print("- Avoid duplicate sections; extend the closest existing section first.")

    if missing_titles:
        print()
        print("## Missing Sections To Add")
        for title in missing_titles:
            hint = SECTION_HINTS.get(title, "Add concrete planning detail before execution.")
            print(f"- {title}: {hint}")

    if thin_sections:
        print()
        print("## Existing Sections To Strengthen")
        for section, _, _ in thin_sections:
            hint = SECTION_HINTS.get(section.title, "Add more concrete, repo-grounded detail.")
            print(f"- {section.title}: {hint}")

    if not missing_titles and not thin_sections:
        print()
        print("- No obvious structural gaps detected. Focus on adding only new evidence, risks, or validation changes.")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
