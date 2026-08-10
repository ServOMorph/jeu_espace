"""Lance le projet Godot en mode fenetre.

Usage:
    python run.py                lancement normal (scenes/test_env.tscn, menu de camera)
    python run.py --headless      lancement headless (--quit apres chargement, scene principale)
"""

import argparse
import subprocess
import sys
from pathlib import Path

GODOT = Path(r"D:\Godot\godot.exe")
PROJECT = Path(__file__).resolve().parent
SCENE_JEU = PROJECT / "scenes" / "test_env.tscn"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--headless", action="store_true")
    args = parser.parse_args()

    if not GODOT.is_file():
        sys.stderr.write("Godot introuvable : {}\n".format(GODOT))
        return 1

    cmd = [str(GODOT), "--path", str(PROJECT)]
    if args.headless:
        cmd += ["--headless", "--quit"]
    else:
        cmd += [str(SCENE_JEU)]

    return subprocess.run(cmd).returncode


if __name__ == "__main__":
    sys.exit(main())
