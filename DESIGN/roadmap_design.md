# Roadmap DESIGN — direction artistique et assets

Déclinaison de `roadmap_mvp.md` limitée au périmètre `design` : **écriture dans `DESIGN/`
uniquement**. Aucun fichier Godot, aucun script, aucune écriture à la racine.

Lire `CONVENTIONS.md` une fois en début de session (périmètres, économie de tokens, passation,
nommage). Ne pas le relire ensuite.

## Position dans le planning
`design` livre **avant** que `dev` intègre. Une phase `dev` ne démarre pas sans sa dépendance.
Concrètement, `design` a une phase d'avance sur `dev` presque tout le long du projet.

| Livraison design | Débloque |
|---|---|
| Phase D1 — textures spatiales | dev phase 1 (environnement) |
| Phase D2 — forme du vaisseau | dev phase 3 (mesh) |
| Phase D3 — intérieur + volet | dev phase 4 (centre de commande) |
| Phase D4 — instruments 2D | dev phase 5 (cockpit) |
| Phase D5 — passe visuelle | dev phase 6 (polish) |

Chaque fin de phase se termine par une passation vers `dev` (§4 de `CONVENTIONS.md`) : écrire
le prompt dans `DESIGN/_handoff.md`, lancer `python tools/handoff.py --to dev --file
DESIGN/_handoff.md`, puis annoncer **📋 ✅ Prompt copié dans le presse-papier** en dernière ligne.

---

## Phase D0 — Structure et charte  [FAIT]

- Arborescence de `DESIGN/` :
  ```
  DESIGN/
    textures/       terre, lune, ciel
    vaisseau/       planches de forme, proportions
    interieur/      centre de commande, cockpit
    instruments/    planches 2D Codex
    charte.md       palette, échelle, style
    SOURCES.md      provenance et licence de chaque asset externe
    MANIFEST.md     inventaire livré, une ligne par fichier
  ```
- `charte.md` — décisions visuelles verrouillées : palette de la coque, niveau de low poly
  (ordre de grandeur en triangles pour le vaisseau), traitement de la coupole, contraste
  intérieur/extérieur. Court : une page, pas de moodboard verbeux.
- `SOURCES.md` — **fichier lu par `tools/fetch_textures.py`, le format est imposé** :
  ```
  | fichier | url | sha256 | licence | date |
  |---|---|---|---|---|
  | terre_albedo_16k.jpg | https://... | - | NASA public domain | 2026-07-31 |
  ```
  Mettre `-` en sha256, le script l'inscrit lui-même via `--record`. Un asset externe sans
  ligne dans `SOURCES.md` n'existe pas : il ne sera pas reconstruit sur une autre machine.
- `MANIFEST.md` — inventaire : nom, résolution, format, phase de destination, statut
  (`livré` / `placeholder`). C'est ce fichier que `dev` lit, pas l'arborescence.

**Gate** : les trois fichiers existent, l'arborescence est créée, `MANIFEST.md` est vide mais
formaté. Aucun asset requis à ce stade.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase D1 — Textures spatiales  [FAIT]

Phase la plus lourde du projet côté design. L'orbite basse (~400 km) est impitoyable : le sol
est vu de près, toute résolution insuffisante se voit immédiatement.

- **Terre** — textures NASA (Visible Earth / Blue Marble), pas de génération IA :
  - albédo jour — **16k minimum**, contrainte directe de l'altitude
  - lumières nocturnes (Black Marble)
  - relief (normal ou bump)
  - couche nuageuse avec alpha
- **Lune** — texture d'albédo, 4k suffisant (vue de loin).
- **Fond étoilé** — champ d'étoiles, panorama ou cubemap.
- Format : privilégier un format que Godot importe sans conversion (`.jpg` pour l'albédo,
  `.png` là où l'alpha est nécessaire). Ne pas livrer de `.tif` ni de `.exr`.
### Les textures ne sont pas committées
`DESIGN/textures/` est dans `.gitignore`. Le livrable versionné de cette phase est
**`SOURCES.md`**, pas les fichiers. Procédure :
1. Trouver l'URL directe de chaque texture sur le site NASA, la renseigner dans `SOURCES.md`
   avec `-` en sha256.
2. `python tools/fetch_textures.py --record` — télécharge et inscrit les sommes de contrôle.
3. Vérifier la résolution réelle des fichiers obtenus (pas celle annoncée sur la page).
4. Renseigner `MANIFEST.md`.

Ne jamais committer un fichier de `DESIGN/textures/`, ni forcer l'ajout avec `git add -f`.

**Gate**
1. `python tools/fetch_textures.py` sur un dossier `DESIGN/textures/` vidé reconstruit tout et
   retourne 0. C'est le seul test qui prouve que `SOURCES.md` est complet.
2. Résolutions réelles vérifiées et notées dans `MANIFEST.md`.
3. Licence de chaque source vérifiée sur la page d'origine, pas supposée.
4. `DESIGN/tests_manuels.md` : « l'albédo jour ouvert à 100 % reste net, aucun flou de
   suréchantillonnage ».

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase D2 — Forme du vaisseau  [FAIT]

`design` fixe la forme, `dev` produit le mesh. La frontière est ici : **aucun fichier `.tscn`,
aucun script de génération côté design.**

- Planches de forme dans `DESIGN/vaisseau/` : vues de face, de côté, de dessus. Générées via
  ChatGPT/Codex ou tracées, peu importe — ce qui compte est qu'elles soient dimensionnées.
- `DESIGN/vaisseau/proportions.md` — **le livrable qui compte réellement pour `dev`** :
  dimensions relatives chiffrées (longueur coque, diamètre coupole, position et taille de la
  section cockpit, hauteur des structures externes), exprimées en unités relatives à la
  longueur totale. Sans ce fichier, `dev` ne peut pas modéliser.
- Depuis le cockpit, voir une partie de la coque est **acceptable** : ne pas contraindre la
  forme pour l'éviter. Décision du 2026-07-31, elle assouplit la formulation d'origine.
- Contrainte réelle, celle-ci à tenir : depuis le centre de commande sous coupole, la coque et
  les structures externes doivent être visibles et lisibles.
- Coupole : livrer l'**armature** (montants, cerclage) comme élément de forme à part entière.
  Le verre n'est pas modélisé côté intérieur (cf. D3) — c'est l'armature qui porte la lecture
  visuelle de la coupole.

**Gate** : `proportions.md` complet et chiffré, planches cohérentes entre elles, armature de
coupole définie. Passation vers `dev`.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase D3 — Intérieur du centre de commande et volet  [FAIT]

- Planches de l'intérieur sous coupole : sol, structure porteuse, mobilier minimal low poly.
  Volume simple — l'intérêt visuel est dehors, pas dedans.
- **Pas de surface de verre vue de l'intérieur** (décision du 2026-07-31, motif technique :
  tri de rendu). Ce que le joueur voit de la coupole, c'est l'armature opaque et le vide entre
  les montants. Concevoir l'armature en conséquence : c'est elle qui doit donner la sensation
  d'être sous une bulle. Le verre n'existe que sur la vue extérieure du vaisseau.
- Volet blindé rétractable : définir le découpage des panneaux, le sens d'ouverture et l'aspect
  (blindé, non transparent). Livrer une planche du volet fermé et du volet ouvert.
- Palette intérieure : suffisamment sombre pour que l'ouverture du volet fasse effet de
  révélation, suffisamment claire pour que la salle reste lisible volet fermé. Cet arbitrage
  est le vrai enjeu de la phase.
- Textures d'intérieur si nécessaires, sinon couleurs unies documentées dans `charte.md`.

**Gate** : planches volet ouvert / volet fermé livrées, découpage des panneaux explicite,
valeurs de palette chiffrées dans `charte.md`. Passation vers `dev`.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase D4 — Instruments 2D du cockpit  [FAIT]

- Planches d'instruments générées via ChatGPT/Codex, dans `DESIGN/instruments/`.
- **Statiques** : aucune donnée live au MVP, puisqu'il n'y a pas de pilotage. Ne pas concevoir
  de jauges supposant une valeur variable.
- Contrainte de lisibilité : cible 1920x1080, l'instrument est vu de face à courte distance.
  Livrer à une résolution au moins double de la taille d'affichage prévue.
- Livrer avec fond transparent (`.png`) si destiné à un overlay, opaque si destiné à une texture
  de console. Indiquer lequel dans `MANIFEST.md` — `dev` ne doit pas avoir à deviner.
- Planche d'intérieur cockpit : console, baie vitrée, même traitement que D3.

**Gate** : instruments lisibles à taille d'affichage réelle (vérifier en réduisant la planche à
sa taille cible, pas en la regardant à 100 %). Passation vers `dev`.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase D5 — Passe visuelle finale  [TODO]

Phase d'appui : `dev` pilote, `design` juge et corrige les assets.

- Revue du rendu en situation : exposition, contraste Terre/espace, lisibilité de la nuit,
  halo atmosphérique par la tranche.
- Corriger les assets qui ne tiennent pas en situation (re-livraison dans `DESIGN/`), plutôt
  que de demander des compensations dans le shader — un asset faible ne se rattrape pas au
  post-traitement.
- Mettre `charte.md` à jour avec les valeurs finalement retenues.

**Gate** : `MANIFEST.md` sans aucune ligne `placeholder`, `charte.md` à jour, aucun asset
signalé comme insuffisant par `dev`.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Hors périmètre design
Scènes et scripts Godot, shaders, matériaux, mesh, import dans le moteur, `project.godot`,
écriture à la racine du projet. Toute demande dans ce domaine passe par une passation vers `dev`.
