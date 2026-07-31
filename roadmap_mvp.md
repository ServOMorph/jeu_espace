# Roadmap MVP — jeu spatial orbital

## Cible MVP
Le joueur est à bord d'un vaisseau en orbite terrestre basse. Il bascule entre deux points de
vue : le cockpit (instruments + espace devant, vaisseau invisible) et le centre de commande
sous coupole de verre (vue 360°, vaisseau visible, volet blindé qu'il peut ouvrir). L'orbite
défile automatiquement, à vitesse réglable. Terre, Soleil et Lune sont rendus de façon
réaliste. Vaisseau low poly. 1920x1080 fenêtré, caméra à la souris.

## Décisions cadrantes (2026-07-31)
- Pilotage : aucun. Orbite automatique, le joueur ne fait que regarder et changer de lieu.
- Simulation : trajectoire sur rail paramétrée, monde à échelle réduite (pas de mécanique
  képlerienne, pas d'échelle 1:1 — évite le problème de précision flottante).
- Transition cockpit / centre de commande : bascule instantanée par touche, pas de déplacement
  à pied, pas d'intérieur de vaisseau à modéliser entre les deux salles.
- Orbite : basse, ~400 km (type ISS). La Terre remplit la majeure partie du champ de vision,
  le globe entier n'est jamais visible. Conséquence directe : textures au sol haute résolution
  obligatoires, et courbure marquée.
- Temps : multiplicateur réglable au clavier (x1 / x10 / x60), temps réel par défaut.
- Coupole : volet blindé rétractable, actionné par le joueur. Mécanique interactive du MVP.
- Terre : textures NASA réelles (Visible Earth / Blue Marble), pas de génération IA.
- Assets : stockés dans `DESIGN/`, importés directement par Godot (`res://DESIGN/...`).
  Pas de dossier `assets/` à la racine, pas de recopie.
- Environnement technique : Godot 4.5 stable, `D:\Godot\godot.exe`.
- Mesh du vaisseau : produit par l'agent, pas par un outil externe ni un asset tiers.

## Répartition par agent (créés le 2026-07-31)
- `orchestrateur` (racine) — roadmap, arbitrages, contexte projet.
- `dev` (`DEV/`) — scripts, scènes, mécaniques. Écrit dans `DEV/`, `scripts/`, `scenes/`,
  `project.godot`.
- `design` (`DESIGN/`) — direction artistique, assets 2D Codex, low poly. **Écrit uniquement
  dans `DESIGN/`.**

| Phase | Agent porteur | Appui |
|---|---|---|
| 0 Fondations | dev | — |
| 1 Environnement spatial | design (assets) | dev (intégration, shaders) |
| 2 Orbite | dev | — |
| 3 Vaisseau | design (forme) | dev (mesh, matériaux) |
| 4 Centre de commande + volet | dev | design (intérieur, volet) |
| 5 Cockpit | design (instruments 2D) | dev (intégration) |
| 6 Bascule et polish | dev | design (passe visuelle) |

### Friction de périmètre restante
**Qui produit le mesh du vaisseau.** `design` tient la direction visuelle mais ne peut pas
écrire dans `scenes/`. Recommandation : `design` fixe la forme et les proportions dans
`DESIGN/`, `dev` produit le mesh effectif. Si la voie `.obj` est retenue en phase 3, le
fichier vit dans `DESIGN/` ; si c'est un `.tscn` d'assemblage, il vit dans `scenes/`.
À arbitrer en ouverture de phase 3, non bloquant avant.

---

## Phase 0 — Fondations du projet Godot  [EN COURS]

Créer le projet Godot et son squelette, aujourd'hui inexistants.

- Créer `project.godot` (Godot 4.5, renderer Forward+).
- Configurer la fenêtre : 1920x1080, mode fenêtré, ratio verrouillé.
- Arborescence : `scenes/`, `scripts/`. Aucun dossier `assets/` — les assets vivent dans
  `DESIGN/`, créé et alimenté par l'agent `design`.
- `.gitignore` Godot (`.godot/`, `.import/`, exports).
- Input map : axe caméra souris, touche de bascule de lieu, touche volet de coupole,
  touches de multiplicateur de temps, touche quitter.
- Scène racine minimale qui se lance sans erreur.

**Gate** : `godot --headless --quit` sur le projet retourne 0 sans erreur ; la fenêtre se lance
à la bonne résolution. Contrôle visuel ajouté à `tests_manuels.md`.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 1 — Environnement spatial extérieur  [TODO]

Produire le décor. C'est la phase qui porte l'essentiel du réalisme attendu. L'orbite basse
à 400 km est exigeante : le sol est vu de près, toute texture insuffisante se verra.

- Acquisition des textures NASA : albédo jour, faces nocturnes (lumières urbaines), relief
  (normal/bump), nuages, texture lunaire. Résolution 16k minimum pour l'albédo au vu de
  l'altitude retenue. Vérifier les licences et archiver les sources. Livrées dans `DESIGN/`.
- Définir et documenter l'échelle du monde (facteur km → unité Godot) une fois pour toutes.
- Terre : sphère haute résolution, matériau multi-couches (jour/nuit selon l'incidence,
  couche nuageuse séparée, halo atmosphérique). La courbure et l'épaisseur de l'atmosphère
  vue par la tranche sont les deux marqueurs de crédibilité en orbite basse.
- Soleil : `DirectionalLight3D` + disque visible, éclairage cohérent avec la position Terre.
- Lune : sphère texturée, distance et taille apparente crédibles.
- Fond étoilé : skybox / `Sky` procédural avec champ d'étoiles.

**Gate** : scène de test à caméra libre. Terre reconnaissable, terminateur jour/nuit net,
Lune et Soleil correctement placés. Contrôle visuel dans `tests_manuels.md`.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 2 — Mouvement orbital sur rail  [TODO]

- Script d'orbite paramétrable : altitude (400 km par défaut), période (~90 min à cette
  altitude), inclinaison, phase de départ.
- Rotation propre de la Terre sur son axe.
- Position du Soleil cohérente avec le temps simulé — le défilement jour/nuit doit être
  visible pendant une orbite.
- Horloge de simulation découplée du temps réel, avec multiplicateur x1 / x10 / x60 changé
  au clavier. Toute la phase 2 en dépend, y compris pour être testable : à x1 une orbite dure
  90 minutes et la nuit 45.
- Choisir l'instant de départ de la simulation de sorte que le joueur commence de jour.

**Gate** : tests unitaires sur les fonctions de position orbitale (entrée temps → position
attendue, périodicité, inclinaison) et sur l'horloge (le multiplicateur ne doit pas introduire
de dérive cumulative). Plus une observation manuelle d'une orbite complète en accéléré.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 3 — Vaisseau low poly  [TODO]

Le mesh est produit par l'agent. Deux voies possibles, à arbitrer en ouverture de phase selon
la complexité de forme retenue :
- **Scène Godot d'assemblage** — primitives et `CSG` combinées dans un `.tscn`, éditable
  ensuite à la main dans l'éditeur. Simple, mais limité aux formes que les primitives couvrent.
- **Générateur de mesh scripté** — script qui écrit un `.obj` versionné (sommets et faces
  explicites). Formes libres et reproductibles, coût d'écriture plus élevé.

- Modèle low poly : coque, coupole de verre visible de l'extérieur, section cockpit.
- Matériaux : coque opaque, coupole transparente.
- Hiérarchie de nœuds : le vaisseau est le parent, les deux lieux sont ses enfants — de sorte
  que tout suit l'orbite sans code de synchronisation.
- Attacher le vaisseau au rail orbital de la phase 2, orientation tangente à la trajectoire.

**Gate** : depuis une caméra externe, le vaisseau suit l'orbite, reste éclairé correctement
par le Soleil, et la coupole se distingue de la coque. Contrôle visuel dans `tests_manuels.md`.

> Opportunité de refacto à évaluer à la fin de cette phase : la hiérarchie de nœuds et le
> couplage orbite/vaisseau sont les endroits où la dette structurelle apparaîtra en premier.
> Ne pas ouvrir de phase dédiée par défaut — décider au vu du code réel.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 4 — Centre de commande sous coupole  [TODO]

- Intérieur de la salle : sol, structure, mobilier minimal low poly.
- Coupole de verre vue de l'intérieur, transparente et sans artefact de tri de rendu.
- Caméra 360° pilotée à la souris : rotation horizontale libre, verticale bornée, capture du
  curseur, sensibilité réglable.
- **Volet blindé rétractable** : panneaux occultant la coupole, ouverts et fermés par une
  touche, avec animation. État persistant tant qu'on ne le change pas, y compris après un
  aller-retour vers le cockpit. Le joueur démarre volet fermé pour que l'ouverture serve de
  révélation.
- Vérifier que le vaisseau (coque, structures externes) est bien visible depuis ce point de vue,
  conformément à l'intention d'origine.

**Gate** : rotation fluide sur 360° sans clipping ni disparition de la Terre ; vaisseau et
extérieur visibles simultanément volet ouvert, occultés volet fermé ; l'état du volet survit
à une bascule de lieu. Contrôle visuel dans `tests_manuels.md`.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 5 — Cockpit  [TODO]

- Intérieur du cockpit : console, baie vitrée frontale.
- Caméra à débattement limité (on regarde devant, pas derrière).
- Contrainte forte : le vaisseau ne doit **pas** être visible depuis le cockpit. Le cadrage et
  la géométrie doivent le garantir.
- Instruments : planches 2D générées via ChatGPT/Codex, intégrées en textures ou en overlay.
  Statiques au MVP — aucune donnée live, puisqu'il n'y a pas de pilotage.

**Gate** : aucun élément de coque visible dans tout le débattement caméra ; instruments
lisibles en 1920x1080. Contrôle visuel dans `tests_manuels.md`.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 6 — Bascule des lieux et finalisation  [TODO]

- Gestionnaire de point de vue : une touche bascule entre cockpit et centre de commande,
  active la bonne caméra et désactive l'autre.
- Vérifier qu'aucun état caméra ne fuit d'un lieu à l'autre (orientation conservée par lieu).
- Passe de performance : coût de la Terre haute résolution et de la transparence de coupole.
- Passe de polish : exposition, tonemapping, éventuel bloom sur le Soleil.
- Écran ou message de sortie propre.

**Gate** : parcours MVP complet — lancement, observation d'une orbite, bascule dans les deux
sens plusieurs fois, framerate stable. Contrôle manuel complet dans `tests_manuels.md`.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Hors MVP (explicitement exclu)
Pilotage et poussée, mécanique képlerienne, désorbitation et rentrée atmosphérique, sortie
extravéhiculaire, déplacement à pied dans le vaisseau, instruments fonctionnels, son,
multijoueur, sauvegarde.
