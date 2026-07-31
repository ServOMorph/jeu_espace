# Conventions partagées — jeu_espace

Ce fichier est la référence commune aux zones `dev` et `design`. Les roadmaps de zone n'y
reviennent pas : elles y renvoient. **Le lire une fois en début de session, pas à chaque tâche.**

---

## 1. Périmètres d'écriture (strict)

| Zone | Peut écrire dans |
|---|---|
| orchestrateur | racine, `_contexte/`, `tools/`, `CONVENTIONS.md`, `roadmap_mvp.md` |
| dev | `DEV/`, `scripts/`, `scenes/`, `tests/`, `addons/`, `project.godot`, `.gitignore` |
| design | `DESIGN/` uniquement |

Une zone qui a besoin d'un fichier hors de son périmètre **ne l'écrit pas** : elle envoie une
demande à l'orchestrateur (§4). Aucune exception, même pour une ligne.

---

## 2. Économie de tokens (règles mécaniques)

Ces règles existent parce que relire des fichiers entiers à chaque tour est le premier poste de
gaspillage. Elles sont contraignantes, pas indicatives.

- **Ne lire que la phase en cours** de la roadmap de zone, jamais le fichier entier. Les phases
  sont séparées par `---` et titrées `## Phase N` : lire de ce titre au `---` suivant.
- **Ne jamais relire un fichier écrit dans le même tour.** L'outil d'écriture a déjà confirmé.
- **Ne pas relire `roadmap_mvp.md`** (zone orchestrateur) : la roadmap de zone contient déjà tout
  ce qui concerne la zone. La consulter uniquement si une contradiction apparaît.
- **Un seul `Read` par fichier et par session**, sauf si le fichier a été modifié entre-temps.
- **Lectures partielles** : sur un fichier > 300 lignes, utiliser `offset`/`limit` plutôt que de
  tout charger.
- **Pas de récapitulatif de ce qui vient d'être fait.** L'utilisateur voit les appels d'outils.
- **Pas de tableau comparatif d'options non retenues.** Recommander, ne pas exposer.
- **Grep avant Glob avant lecture.** Chercher le symbole, pas parcourir l'arborescence.

Signal d'alerte à s'appliquer soi-même : si une réponse dépasse ~30 lignes sans produire de
fichier ni de décision, c'est du remplissage. S'arrêter et agir.

---

## 3. Scripts Python outillés (`tools/`)

Ne jamais réimplémenter à la main ce que ces scripts font déjà. Ils sont écrits et maintenus par
l'orchestrateur ; les zones les **exécutent** sans les modifier.

| Script | Rôle | Appel |
|---|---|---|
| `tools/handoff.py` | Copie un prompt de passation dans le presse-papier | `python tools/handoff.py --to <zone> --file <fichier>` |
| `tools/coverage_check.py` | Mesure la couverture de tests GDScript | `python tools/coverage_check.py` |
| `tools/check_scope.py` | Vérifie qu'aucun fichier modifié ne sort du périmètre de la zone | `python tools/check_scope.py <zone>` |
| `tools/fetch_textures.py` | Reconstruit `DESIGN/textures/` depuis `DESIGN/SOURCES.md` | `python tools/fetch_textures.py [--record]` |

Nouveau besoin répétitif (renommage en masse, génération de manifeste, conversion de textures,
vérification de nommage) : **demander un script à l'orchestrateur** plutôt que de le faire à la
main tour après tour. Une tâche répétée trois fois est une tâche à scripter.

---

## 4. Passation entre agents — protocole obligatoire

Un agent ne peut pas parler à un autre agent. Toute demande transite par l'utilisateur.

Quand une zone a besoin de quelque chose d'une autre zone (asset manquant, fichier hors
périmètre, arbitrage), elle **doit** :

1. Écrire le prompt destiné à l'autre zone dans un fichier de son propre périmètre
   (ex. `DEV/_handoff.md`, `DESIGN/_handoff.md`).
2. Lancer :
   ```
   python tools/handoff.py --to <zone_cible> --file <chemin_du_fichier>
   ```
3. Dire explicitement à l'utilisateur, en clair et en dernière ligne de la réponse :

   > **📋 ✅ Prompt copié dans le presse-papier.** Colle-le dans une session `/start <zone_cible>`.

Les deux smileys 📋 et ✅ ne s'affichent que si le script a retourné 0. S'il a échoué, afficher
le prompt en bloc de code et le dire — ne jamais prétendre que la copie a eu lieu.

**Interdit** : décrire vaguement « il faudrait que design fournisse une texture » sans produire
le prompt et sans lancer le script. La demande n'existe que si elle est dans le presse-papier.

---

## 5. Tests — objectif 85 %

### Ce qui est mesurable, et ce qui ne l'est pas
GDScript n'a pas d'outil de couverture de lignes fiable. L'objectif de 85 % porte donc sur la
**couverture fonctionnelle** : proportion des fonctions publiques de `scripts/core/` couvertes par
au moins un test. C'est ce que mesure `tools/coverage_check.py`. Dire « 85 % de couverture de
lignes » serait faux ; ne pas l'écrire.

### Conséquence sur l'architecture (contrainte, pas suggestion)
Toute logique testable vit dans `scripts/core/`, en classes `RefCounted` **sans dépendance au
`SceneTree`, aux nœuds, ni à `_process`**. Les scripts de nœuds (`scripts/nodes/`) ne contiennent
que du câblage : lire une entrée, appeler `core`, appliquer le résultat sur un nœud. Ils ne sont
pas comptés dans la couverture, et ne doivent donc contenir aucune décision.

Si une logique est difficile à tester, c'est qu'elle est au mauvais endroit. Déplacer, ne pas
contourner.

### Exécution
- Framework : GdUnit4, tests dans `tests/`, un fichier `test_<module>.gd` par module de `core/`.
- Lancement headless obligatoire avant toute clôture de phase.
- `python tools/coverage_check.py` retourne un code non nul sous 85 % : c'est un gate bloquant.

### Ce qui n'est pas testable unitairement
Rendu, shaders, transparence, cadrage caméra, lisibilité d'un asset. Ces points passent par
`tests_manuels.md` avec un critère observable en une ligne — jamais « vérifier que c'est joli ».

---

## 6. Nommage et format

- Fichiers et dossiers : `snake_case`, sans accent, sans espace.
- Scènes `.tscn` : nom du contenu (`terre.tscn`, `cockpit.tscn`), pas de préfixe de type.
- Scripts GDScript : `snake_case.gd`, classe `PascalCase` via `class_name`.
- Textures : `<sujet>_<couche>_<resolution>.<ext>` — ex. `terre_albedo_16k.jpg`.
- Aucun emoji dans le code, les noms de fichiers ou les commentaires.
- Aucun commentaire décoratif ou de séparation.

---

## 7. Checkpoints

Chaque phase de roadmap se termine par un bloc `⏸ Checkpoint`. Il n'est ni négociable ni
supprimable : demander `/compact` à l'utilisateur, attendre sa réponse écrite, ne pas enchaîner.
Un agent qui enchaîne deux phases sans checkpoint produit du travail non relu.
