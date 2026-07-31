"""Telecharge les textures externes listees dans DESIGN/SOURCES.md.

Les textures NASA ne sont pas versionnees : DESIGN/textures/ est ignore par git. Ce script
les reconstruit a l'identique a partir des URLs et des sommes de controle de SOURCES.md.

Format attendu dans DESIGN/SOURCES.md, un tableau markdown avec ces colonnes exactes :

    | fichier | url | sha256 | licence | date |
    |---|---|---|---|---|
    | terre_albedo_16k.jpg | https://... | a1b2c3... | NASA public domain | 2026-07-31 |

Mettre `-` dans la colonne sha256 pour un fichier pas encore telecharge, puis lancer
--record pour que le script inscrive la somme reelle.

Usage:
    python tools/fetch_textures.py                 telecharge ce qui manque et verifie
    python tools/fetch_textures.py --record        inscrit les sha256 manquants dans SOURCES.md
    python tools/fetch_textures.py --force         retelecharge tout

Code retour 0 si tout est present et conforme, 1 sinon.
"""

import argparse
import hashlib
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path

SOURCES = Path("DESIGN/SOURCES.md")
DEST = Path("DESIGN/textures")
ROW_RE = re.compile(r"^\s*\|(?P<cells>.+)\|\s*$")
CHUNK = 1 << 20


def parse_rows(text):
    rows = []
    for line in text.splitlines():
        match = ROW_RE.match(line)
        if not match:
            continue
        cells = [c.strip() for c in match.group("cells").split("|")]
        if len(cells) < 3:
            continue
        if cells[0].lower() == "fichier" or set(cells[0]) <= {"-", ":"}:
            continue
        if not cells[1].startswith("http"):
            continue
        rows.append({"line": line, "fichier": cells[0], "url": cells[1], "sha256": cells[2]})
    return rows


def sha256_of(path):
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(CHUNK), b""):
            digest.update(chunk)
    return digest.hexdigest()


def download(url, dest):
    dest.parent.mkdir(parents=True, exist_ok=True)
    tmp = dest.with_suffix(dest.suffix + ".part")
    try:
        with urllib.request.urlopen(url, timeout=60) as response, tmp.open("wb") as out:
            while True:
                chunk = response.read(CHUNK)
                if not chunk:
                    break
                out.write(chunk)
    except (urllib.error.URLError, OSError) as exc:
        tmp.unlink(missing_ok=True)
        sys.stderr.write("Echec du telechargement de {} : {}\n".format(url, exc))
        return False
    tmp.replace(dest)
    return True


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--record", action="store_true")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()

    if not SOURCES.is_file():
        sys.stderr.write("Fichier absent : {}\n".format(SOURCES))
        return 1

    text = SOURCES.read_text(encoding="utf-8")
    rows = parse_rows(text)
    if not rows:
        sys.stderr.write("Aucune ligne exploitable dans {}\n".format(SOURCES))
        return 1

    erreurs = 0
    for row in rows:
        dest = DEST / row["fichier"]
        if args.force or not dest.is_file():
            print("Telechargement : {}".format(row["fichier"]))
            if not download(row["url"], dest):
                erreurs += 1
                continue
        somme = sha256_of(dest)
        attendu = row["sha256"]
        if attendu in ("-", ""):
            if args.record:
                text = text.replace(row["line"], row["line"].replace("| - |", "| {} |".format(somme), 1))
                print("  sha256 inscrit : {}".format(somme[:16]))
            else:
                print("  sha256 absent de SOURCES.md (relancer avec --record) : {}".format(somme[:16]))
        elif somme != attendu:
            sys.stderr.write("  SOMME INVALIDE pour {} : attendu {}, obtenu {}\n".format(
                row["fichier"], attendu[:16], somme[:16]))
            erreurs += 1
        else:
            print("  OK {}".format(row["fichier"]))

    if args.record:
        SOURCES.write_text(text, encoding="utf-8")

    print("{} texture(s), {} erreur(s).".format(len(rows), erreurs))
    return 1 if erreurs else 0


if __name__ == "__main__":
    sys.exit(main())
