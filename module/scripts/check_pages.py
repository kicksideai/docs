#!/usr/bin/env python3
"""Check the JSON-compatible YAML page catalog against the Markdown source."""

from collections import Counter
import json
from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parents[2]
SECTIONS = {
    "getting-started": "guide",
    "using": "guide",
    "building-modules": "handbook",
    "reference": "reference",
}


def check(root):
    source = json.loads((root / "_index.yaml").read_text(encoding="utf-8"))
    failures = []
    paths = {"index.md"}
    for section in SECTIONS:
        paths.update(path.relative_to(root).as_posix() for path in (root / section).rglob("*.md"))

    declared = []
    ids = []
    navigation = []
    for entry in source["entries"]:
        meta_type = entry.get("meta", {}).get("type")
        if meta_type == "wippy.documentation.navigation":
            navigation.append(entry)
        if meta_type != "wippy.documentation.page":
            continue
        data = entry["data"]
        path = data["path"]
        declared.append(path)
        ids.append(f"{source['namespace']}:{entry['name']}")
        if path not in paths or not (root / path).is_file():
            failures.append(f"page points at a missing or non-page file: {path}")
            continue
        expected_name = "pages." + path.removesuffix(".md").replace("/", ".")
        if entry["name"] != expected_name or data["content"] != f"file://{path}":
            failures.append(f"path, name and content disagree: {path}")
        heading = re.search(r"^# (.+)$", (root / path).read_text(encoding="utf-8"), re.MULTILINE)
        if not heading or data["title"] != heading.group(1):
            failures.append(f"title differs from the first H1: {path}")
        kind = "guide" if path == "index.md" else SECTIONS[path.split("/", 1)[0]]
        if data["document_kind"] != kind or data["status"] != "stable":
            failures.append(f"document kind or status differs: {path}")

    for path in sorted(paths - set(declared)):
        failures.append(f"page has no entry: {path}")
    for path, count in Counter(declared).items():
        if count != 1:
            failures.append(f"page has {count} entries: {path}")
    if len(set(ids)) != len(ids):
        failures.append("page registry ids repeat")

    references = []

    def walk(items):
        for item in items:
            if "document" in item:
                references.append(item["document"])
            walk(item.get("items", []))

    if len(navigation) != 1:
        failures.append("catalog must declare exactly one navigation entry")
    for entry in navigation:
        walk(entry["data"]["items"])
    for reference in sorted(set(references) - set(ids)):
        failures.append(f"navigation references an unknown id: {reference}")
    for page_id in sorted(set(ids) - set(references)):
        failures.append(f"navigation omits a page: {page_id}")
    for reference, count in Counter(references).items():
        if count != 1:
            failures.append(f"navigation repeats a page: {reference}")
    return failures, len(declared), len(references)


def main():
    failures, pages, references = check(ROOT)
    if failures:
        for failure in failures:
            print(failure, file=sys.stderr)
        return 1
    print(f"Checked {pages} pages and {references} navigation references.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
