# GEMINI.md

Instructions pour Gemini intervenant sur ce projet. Miroir de `AGENTS.md` (instructions
communes aux agents non-Claude) — ce fichier existe séparément car les outils Gemini lisent
`GEMINI.md`, pas `AGENTS.md`. Ce fichier ne duplique pas `.claude/CLAUDE.md` (protocole
vibecoding start/close, réservé à Claude Code) : il ne couvre que ce qui s'applique à tout
agent, indépendamment de l'outil.

## Base de connaissances

Si ce projet dispose d'un dossier `DOCUMENTATION/` à la racine avec un fichier `INDEX.md`, il
centralise la documentation métier du projet, consultable par tout agent quel que soit l'outil
utilisé. Avant d'affirmer un fait métier non disponible dans le contexte immédiat, consulter
`DOCUMENTATION/INDEX.md` (catalogue, une ligne par document) puis n'ouvrir que le(s) document(s)
pertinent(s) — jamais tout le dossier. Absence de `DOCUMENTATION/` : rien à consulter.

## Tests manuels

Utiliser `tests_manuels.md` à la racine de la zone (`DEV/tests_manuels.md`,
`DESIGN/tests_manuels.md`) comme file d'attente exhaustive des contrôles manuels non validés.
Lorsqu'un test manuel reste à effectuer, l'ajouter à ce fichier, même si d'autres tests y sont
déjà en attente. Si le contrôle nécessite de lancer une commande (exécutable, scène, script),
inclure cette commande dans l'entrée. Après validation d'un test, supprimer immédiatement sa
section. Lorsque tous les tests en attente sont validés, vider intégralement le fichier, sans
en conserver le titre ni les consignes.

## Synchronisation CLAUDE.md / AGENTS.md
À chaque modification de ce fichier, proposer à l'utilisateur de reporter le changement dans
`.claude/CLAUDE.md` et dans `AGENTS.md`. Si l'un de ces fichiers n'existe pas, proposer de le
créer plutôt que de le créer directement.
