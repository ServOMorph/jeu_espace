# Signals — design   (MAJ 2026-07-31)

## Actions ouvertes
- [P1|ouvert] Démarrer la Phase D2 (forme du vaisseau) : planches + `DESIGN/vaisseau/proportions.md`.
  fait quand: `proportions.md` complet et chiffré, planches cohérentes, armature de coupole définie, handoff envoyé.
  réf: DESIGN/roadmap_design.md (Phase D2)

## Dernière session (2026-07-31)
<!-- Écrasé intégralement par /close. Synthèse < 25 lignes. -->
# Session du 2026-07-31

## Décisions prises
- Phase D0 exécutée : arborescence + charte.md/SOURCES.md/MANIFEST.md créés.
- Phase D1 exécutée : sources Terre/Lune/étoiles trouvées, vérifiées et téléchargées (sha256 enregistrés).
- Relief/normal Terre retiré du périmètre D1 : aucune source NASA en téléchargement direct trouvée.
- Couche nuageuse acceptée en 2048x1024 (résolution NASA max disponible en direct), à utiliser comme masque de gris.
- Correction : `DESIGN/tests_manuels.md` créé (référencé par le roadmap, oublié en cours de session).

## Livrables produits ou modifiés
- DESIGN/charte.md, SOURCES.md, MANIFEST.md, tests_manuels.md, _handoff.md : créés/remplis
- DESIGN/textures/*.jpg (5 fichiers) : téléchargés, non commités (gitignore)
- Handoff Phase D1 envoyé vers `dev` via tools/handoff.py

## Hypothèses validées / invalidées
- VALIDE : sources NASA directes suffisantes pour albédo (21600x10800, >16k), nightlights, clouds
- INVALIDE : relief NASA en téléchargement direct disponible -> retiré du périmètre D1
- EN ATTENTE : retour de `dev` sur l'intégration du handoff D1

## Prochaine étape exacte
Phase D2 — forme du vaisseau : planches + `proportions.md` chiffré. Peut démarrer sans attendre le retour de `dev` (D2 débloque dev phase 3, pas phase 1).

## Question bloquante pour la session suivante
Aucune
