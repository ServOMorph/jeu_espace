"""Couverture fonctionnelle des modules GDScript de scripts/core/.

Mesure la proportion de fonctions publiques de scripts/core/ referencees par au moins un
fichier de tests/. Ce n'est PAS une couverture de lignes : GDScript n'a pas d'outil fiable
pour cela. Ne pas presenter le resultat comme tel.

Usage:
    python tools/coverage_check.py [--seuil 85] [--core scripts/core] [--tests tests]

Code retour 0 si le seuil est atteint, 1 sinon, 2 si aucun module a analyser.
"""

import argparse
import re
import sys
from pathlib import Path

FUNC_RE = re.compile(r"^\s*(?:static\s+)?func\s+([A-Za-z_][A-Za-z0-9_]*)\s*\(", re.MULTILINE)


def public_functions(path):
    src = path.read_text(encoding="utf-8", errors="replace")
    return {name for name in FUNC_RE.findall(src) if not name.startswith("_")}


def collect(core_dir, tests_dir):
    core = {}
    for gd in sorted(core_dir.rglob("*.gd")):
        funcs = public_functions(gd)
        if funcs:
            core[gd] = funcs
    tests_src = "\n".join(
        p.read_text(encoding="utf-8", errors="replace") for p in tests_dir.rglob("*.gd")
    ) if tests_dir.is_dir() else ""
    return core, tests_src


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--seuil", type=float, default=85.0)
    parser.add_argument("--core", default="scripts/core")
    parser.add_argument("--tests", default="tests")
    args = parser.parse_args()

    core_dir = Path(args.core)
    if not core_dir.is_dir():
        sys.stderr.write("Dossier absent : {}\n".format(core_dir))
        return 2

    core, tests_src = collect(core_dir, Path(args.tests))
    if not core:
        sys.stderr.write("Aucune fonction publique trouvee dans {}\n".format(core_dir))
        return 2

    total = 0
    couvert = 0
    manquants = []
    for path, funcs in core.items():
        for name in sorted(funcs):
            total += 1
            if re.search(r"\b{}\s*\(".format(re.escape(name)), tests_src):
                couvert += 1
            else:
                manquants.append("{}::{}".format(path.as_posix(), name))

    taux = 100.0 * couvert / total
    print("Couverture fonctionnelle : {}/{} = {:.1f}% (seuil {:.0f}%)".format(
        couvert, total, taux, args.seuil))
    if manquants:
        print("Fonctions non couvertes :")
        for item in manquants:
            print("  - " + item)

    return 0 if taux >= args.seuil else 1


if __name__ == "__main__":
    sys.exit(main())
