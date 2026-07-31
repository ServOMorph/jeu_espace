# Demande dev -> orchestrateur — corrections de protocole (issues de la phase 0)

Deux défauts bloquants découverts en clôturant la phase 0 dev. Les deux corrections sont hors
périmètre dev (`tools/`, `CONVENTIONS.md`, `.claude/CLAUDE.md`). Arbitrage déjà validé par
l'utilisateur le 2026-07-31 : appliquer les deux solutions ci-dessous telles quelles.

Côté dev, ce qui relevait de mon périmètre est déjà fait : `tests_manuels.md` a été déplacé en
`DEV/tests_manuels.md` et les six références de `roadmap_dev.md` ont été requalifiées.

---

## 1. `check_scope.py` — inutilisable dès que deux zones travaillent en parallèle

Défaut : le script lit `git status --porcelain` (ligne 24), donc tout l'arbre de travail. Les
fichiers non commités d'une autre zone font échouer le gate. Constaté en phase 0 : trois fichiers
`DESIGN/*.md` non commités faisaient échouer `check_scope.py dev` alors que dev n'y avait pas
touché. Le blocage est symétrique et se produit dans le cas nominal du projet.

Correction retenue — vérifier l'index seul, ce qui correspond à la sémantique annoncée du script
(« à lancer avant tout commit ») :

- remplacer `git status --porcelain` par `git diff --cached --name-only` ;
- si l'index est vide, retourner un code non nul avec un message explicite (« rien de stagé :
  lancer `git add` avant »). Sans cela le script retourne un faux vert sur index vide, ce qui est
  pire que le défaut actuel ;
- adapter le parsing : `--name-only` sort des chemins bruts, sans les trois caractères de statut
  que découpe `line[3:]`.

Flux résultant à documenter dans `CONVENTIONS.md` §3 :
```
git add <fichiers de la zone>
python tools/check_scope.py <zone>
git commit
```

## 2. `tests_manuels.md` — un fichier par zone

Contradiction : `.claude/CLAUDE.md` (section « Tests manuels ») impose la racine du projet, alors
que `CONVENTIONS.md` §1 et `SCOPES` dans `check_scope.py:18` ne placent pas ce fichier dans le
périmètre dev. Aucune zone ne peut donc satisfaire le gate sans violer son périmètre.

Correction retenue — `DEV/tests_manuels.md` et `DESIGN/tests_manuels.md`, chacun dans le périmètre
de sa zone. Motif : `CONVENTIONS.md` §5 renvoie aussi `design` vers ce fichier pour les contrôles
de lisibilité d'asset ; un fichier unique écrit par deux agents qui ne communiquent pas est un
point de collision au `/close`. Aucune modification de `SCOPES` n'est nécessaire.

À amender :
- `.claude/CLAUDE.md`, section « Tests manuels » : « racine du projet » -> « racine de la zone
  (`DEV/tests_manuels.md`, `DESIGN/tests_manuels.md`) ».
- `CONVENTIONS.md` §5, sous-section « Ce qui n'est pas testable unitairement » : préciser que
  chaque zone tient sa propre file, dans son dossier.
- `roadmap_mvp.md` : requalifier les références à `tests_manuels.md` si elles existent.
