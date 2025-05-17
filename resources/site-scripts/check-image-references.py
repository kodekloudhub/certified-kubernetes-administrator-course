#!/usr/bin/env python3
#
# - Scan all image files and markdown files in repo
# - Determine if each image file is referenced by any of the markdown
# - Report all that have no references

import os
from pathlib import Path
import re
from typing import List, Set

# File extensions to consider as images
IMAGE_EXTENSIONS = {'.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.svg'}
MARKDOWN_EXTENSION = '.md'

def repo_root() -> Path:
    """
    Determine root directory of this git repo
    """
    dir = Path(__file__).resolve().parent
    root = Path.cwd().root
    while True:
        if (dir / ".git").exists():
            break
        dir = dir.parent
        if dir == root:
            raise Exception("Project root (directory containing .git) not found!")
    return dir

def find_files(root_dir: Path, extensions: List[str]) -> List[str]:
    """Find files in the directory tree with specific extensions."""
    matched_files = []
    for root, _, files in os.walk(root_dir):
        for file in files:
            ext = os.path.splitext(file)[1].lower()
            if ext in extensions:
                file_path = Path(root, file).resolve().relative_to(root_dir.resolve()).as_posix()
                matched_files.append(file_path)
    return matched_files

def extract_image_references_from_markdown(md_file_path: Path, repo_root: Path) -> Set[str]:
    """
    Extract and resolve image references in a markdown file.
    """
    references = set()
    with open(md_file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Markdown syntax ![alt](path)
    md_links = re.findall(r'!\[[^\]]*\]\(([^)]+)\)', content)
    # HTML syntax <img src="...">
    html_links = re.findall(r'<img[^>]+src=["\']([^"\']+)["\']', content)

    all_links = md_links + html_links
    md_dir = md_file_path.parent

    for link in all_links:
        if re.match(r'^(http|https|data):', link):
            continue  # skip external URLs or base64 images
        resolved_path = (md_dir / link).resolve()
        try:
            rel_path = resolved_path.relative_to(repo_root.resolve())
            references.add(rel_path.as_posix().lower())
        except ValueError:
            # The reference is outside the repo root — ignore
            pass

    return references

def main():
    base_dir = repo_root()

    # Step 1: Find image and markdown files
    image_files = find_files(base_dir, IMAGE_EXTENSIONS)
    markdown_files = find_files(base_dir, {MARKDOWN_EXTENSION})

    # Step 2: Find all image references in markdown
    referenced_images = set()
    for md_file in markdown_files:
        md_path = base_dir / md_file
        references = extract_image_references_from_markdown(md_path, base_dir)
        referenced_images.update(references)

    # Step 3: Report unreferenced images
    unreferenced_images = []
    for image in image_files:
        if image.lower() not in referenced_images:
            unreferenced_images.append(image)

    # Output the result
    if unreferenced_images:
        print("Unreferenced image files:")
        for img in unreferenced_images:
            print(img)
    else:
        print("All images are referenced in markdown files.")


if __name__ == "__main__":
    main()
