import os
from pathlib import Path
import re

BEGIN_MARKER = "[//]: # (BEGIN INDEX)"
END_MARKER = "[//]: # (END INDEX)"

NOTE_BASE_URL = "https://notes.kodekloud.com/docs/CKA-Certification-Course-Certified-Kubernetes-Administrator"

def repo_root():
    dir = Path(__file__).resolve().parent
    root = Path.cwd().root
    while True:
        if (dir / ".git").exists():
            break
        dir = dir.parent
        if dir == root:
            raise Exception("Project root (directory containing .git) not found!")
    return dir

def strip_number_prefix(name):
    parts = name.split('-', 1)
    return parts[1] if len(parts) > 1 else name

def format_link_line(index, filename, url, is_external=False):
    """Constructs the full markdown line with optional 🔗 suffix."""
    clean_name = strip_number_prefix(filename)
    title = Path(clean_name).stem.replace('-', ' ')
    link = f"[{index:02d} {title}]({url})"
    if is_external:
        return f"- {link} 🔗"
    return f"- {link}"

def generate_index(docs_path):
    lines = [
        "",
        "🔗 suffix dentoes an external link to [notes.kodekloud.com](https://notes.kodekloud.com/)",
        ""
    ]
    for section_dir in sorted(docs_path.iterdir()):
        if section_dir.is_dir():
            section_files = sorted(section_dir.glob('*.*'))  # include .md and .note
            raw_section_name = section_dir.name
            clean_section_name = strip_number_prefix(raw_section_name).replace(' ', '%20')  # for URL
            pretty_section_title = strip_number_prefix(raw_section_name).replace('-', ' ', 1)

            lines.append(f"<details>")
            lines.append(f"<summary><strong>{pretty_section_title}</strong></summary>\n")
            lines.append("")

            for idx, file in enumerate(section_files, start=1):
                filename = file.name
                ext = file.suffix

                if ext == ".note":
                    clean_filename = strip_number_prefix(filename)
                    stem = Path(clean_filename).stem.replace(' ', '%20')
                    url = f"{NOTE_BASE_URL}/{clean_section_name}/{stem}"
                    link_line = format_link_line(idx, filename, url, is_external=True)
                else:
                    url = f"docs/{raw_section_name}/{filename}"
                    link_line = format_link_line(idx, filename, url)

                lines.append(link_line)

            lines.append("\n</details>\n")

    return "\n".join(lines)

def insert_index_into_readme(readme_path, index_content):
    with open(readme_path, "r", encoding="utf-8") as f:
        readme = f.read()

    pattern = re.compile(
        rf"({re.escape(BEGIN_MARKER)}\n)(.*?)(\n{re.escape(END_MARKER)})",
        re.DOTALL
    )

    new_content = pattern.sub(rf"\1{index_content}\3", readme)

    with open(readme_path, "w", encoding="utf-8") as f:
        f.write(new_content)

if __name__ == "__main__":
    base_dir = repo_root()
    docs_dir = base_dir / "docs"
    readme_path = base_dir / "README.md"

    index_content = generate_index(docs_dir)
    insert_index_into_readme(readme_path, index_content)