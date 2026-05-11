import uuid
import webbrowser
import os
import re

from pathlib import Path
from time import time
from typing import Dict
import subprocess


def build_selector(key: str, *params) -> str:
    return key % params


def generate_unique_email(email_address: str) -> str:
    unique_str = str(uuid.uuid4()).replace("-", "")[:12]

    if "%s" in email_address:
        return email_address.replace("%s", unique_str)
    else:
        return email_address.replace("@", unique_str + "@");


def open_report(file_path: str):
    filename = f"file://{file_path}"
    webbrowser.open_new_tab(filename)


def get_git_root(path: Path | None = None) -> Path:
    """Find git-root for given path."""
    path = path or Path(__file__).resolve()
    try:
        git_root = subprocess.check_output(
            ["git", "-C", str(path.parent), "rev-parse", "--show-toplevel"],
            text=True
        ).strip()
        return Path(git_root)
    except subprocess.CalledProcessError:
        # Fallback: search for .git
        for parent in [path] + list(path.parents):
            if (parent / ".git").exists():
                return parent
         
        raise RuntimeError("No git repository found.")


