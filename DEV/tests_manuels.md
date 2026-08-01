# Tests manuels en attente

## Phase 5 — Lisibilité des instruments de la console avant

Origine : handoff design D4.

Critère observable :
- Les instruments de la console avant (écran central, 2 cadrans, bandeau de voyants) sont
  lisibles à taille d'affichage réelle en 1920x1080, vue de face à courte distance — et pas
  seulement à 100 % dans un éditeur d'image.
- Pas d'artefact de bloc sur les traits fins cyan (`#4FD8E0`, 3 à 5 px dans le SVG source) :
  `project.godot` force `compress/mode=2` (BPTC) sur toutes les textures. Si des artefacts
  apparaissent, passer les trois SVG de `DESIGN/instruments/` en `compress/mode=0` — cela
  relève du périmètre `design`, donc par passation.

## Phase 5 — Visibilité de la coque depuis le cockpit  [CRITÈRE À TRANCHER]

Origine : handoff design D4, qui demande « aucun élément de coque visible dans tout le
débattement de la caméra cockpit ».

Ce critère contredit `DEV/roadmap_dev.md` phase 5, qui acte l'inverse le 2026-07-31 : « Voir une
partie de la coque depuis le cockpit est acceptable : ne pas tordre le cadrage ni la géométrie
pour l'éviter, et ne pas ajouter de masquage de calque de rendu. »

Trancher avant d'ouvrir la phase 5, puis ne garder qu'une seule des deux formulations :
- version stricte (design D4, `proportions.md`, `contexte.md`) : aucun élément de coque visible
  sur tout le débattement ;
- version assouplie (roadmap dev) : coque partiellement visible tolérée, débattement et
  géométrie non contraints pour l'éviter.

## Phase 4 — Centre de commande, lisibilité entre montants de coupole

Origine : handoff design D2 (armature 12 montants espacés de 30°, 3 cerclages).

Critère observable :
- Depuis le centre de commande sous coupole, la coque et les structures externes sont visibles
  et lisibles entre les montants de l'armature.
