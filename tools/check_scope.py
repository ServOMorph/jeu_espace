"""Verifie qu'aucun fichier modifie ne sort du perimetre d'ecriture de la zone.

A lancer avant tout commit de zone.

Usage:
    python tools/check_scope.py dev
    python tools/check_scope.py design

Code retour 0 si tout est dans le perimetre, 1 s'il y a des violations.
"""

import argparse
import subprocess
import sys

SCOPES = {
    "orchestrateur": None,
    "dev": ("DEV/", "scripts/", "scenes/", "tests/", "addons/", "project.godot", ".gitignore"),
    "design": ("DESIGN/",),
}


def changed_files():
    cmd = ["git", "diff", "--cached", "--name-only"]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        sys.stderr.write(result.stderr)
        return None
    paths = []
    for line in result.stdout.splitlines():
        if not line.strip():
            continue
        paths.append(line.strip().strip('"').replace("\\", "/"))
    return paths


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("zone", choices=sorted(SCOPES))
    args = parser.parse_args()

    scope = SCOPES[args.zone]
    if scope is None:
        print("Zone '{}' : perimetre non restreint.".format(args.zone))
        return 0

    paths = changed_files()
    if paths is None:
        return 1

    if not paths:
        print("Rien de stage : lancer 'git add' avant.")
        return 1

    violations = [p for p in paths if not any(p.startswith(prefix) for prefix in scope)]
    if violations:
        print("Hors perimetre de la zone '{}' :".format(args.zone))
        for path in violations:
            print("  - " + path)
        print("Perimetre autorise : " + ", ".join(scope))
        return 1

    print("{} fichier(s) modifie(s), tous dans le perimetre '{}'.".format(
        len(paths), args.zone))
    return 0


if __name__ == "__main__":
    sys.exit(main())
