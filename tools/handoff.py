"""Copie un prompt de passation inter-agents dans le presse-papier Windows.

Usage:
    python tools/handoff.py --to dev --file DESIGN/_handoff.md
    python tools/handoff.py --to design --text "Texture nuages manquante en 8k"

Code retour 0 = copie effectuee. Tout autre code = echec, ne pas annoncer la copie.
"""

import argparse
import subprocess
import sys
import tempfile
from pathlib import Path

ZONES = ("orchestrateur", "dev", "design")

HEADER = "# Passation vers la zone `{to}`\n\n" \
         "Contexte : lancer `/start {to}` puis coller ce prompt.\n\n---\n\n"


def read_payload(args):
    if args.file:
        path = Path(args.file)
        if not path.is_file():
            sys.stderr.write("Fichier introuvable : {}\n".format(path))
            return None
        return path.read_text(encoding="utf-8")
    return args.text


def copy_to_clipboard(text):
    tmp = Path(tempfile.gettempdir()) / "handoff_payload.txt"
    tmp.write_text(text, encoding="utf-8")
    cmd = [
        "powershell", "-NoProfile", "-NonInteractive", "-Command",
        "Get-Content -Raw -Encoding utf8 '{}' | Set-Clipboard".format(tmp),
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    tmp.unlink(missing_ok=True)
    if result.returncode != 0:
        sys.stderr.write(result.stderr or "Set-Clipboard a echoue\n")
    return result.returncode


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--to", required=True, choices=ZONES)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--file")
    group.add_argument("--text")
    args = parser.parse_args()

    payload = read_payload(args)
    if not payload or not payload.strip():
        sys.stderr.write("Contenu de passation vide.\n")
        return 2

    code = copy_to_clipboard(HEADER.format(to=args.to) + payload.strip() + "\n")
    if code == 0:
        print("Prompt vers '{}' copie dans le presse-papier ({} caracteres).".format(
            args.to, len(payload)))
    return code


if __name__ == "__main__":
    sys.exit(main())
