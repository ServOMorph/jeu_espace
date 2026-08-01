# Signals — design   (MAJ 2026-08-01)

## Actions ouvertes
- [P2|ouvert] Phase D5 (passe visuelle finale) : attendre le retour de `dev` sur le rendu en situation (exposition, contraste Terre/espace, halo atmosphérique) avant de pouvoir juger/corriger les assets.
  fait quand: `dev` a livré un rendu intégré (phase 6 polish) et signalé les assets insuffisants, ou confirmé qu'aucun ne l'est.
  réf: DESIGN/roadmap_design.md (Phase D5)

## Dernière session (2026-08-01)
# Session du 2026-08-01

## Décisions prises
- Correction du statut de `DESIGN/vaisseau/proportions.md` (§ Statut) : validation utilisateur du 2026-07-31 non reflétée, corrigé.
- Phase D3 close : intérieur sous coupole (sol/structure/mobilier) et volet blindé (fermé/ouvert) livrés, palette chiffrée dans `charte.md`.
- Phase D4 close : set d'instruments limité à un minimal générique (écran central + 2 cadrans + bandeau de voyants) — décision de session, aucune fonction pilotée au MVP.
- Phase D5 non démarrée : phase d'appui dépendant d'un rendu `dev` en situation, indisponible côté zone design.

## Livrables produits ou modifiés
- DESIGN/vaisseau/proportions.md : § Statut corrigé
- DESIGN/interieur/notes.md, vue_plan.svg, vue_coupe.svg, volet_ferme.svg, volet_ouvert.svg : créés (D3)
- DESIGN/instruments/notes.md, vue_console.svg, instrument_ecran.svg, instrument_cadran.svg : créés (D4)
- DESIGN/charte.md : palette intérieure (D3) et instruments cockpit (D4) ajoutées
- DESIGN/MANIFEST.md : mis à jour (lignes D3 et D4)
- DESIGN/_handoff.md : réécrit deux fois, handoffs D3 et D4 envoyés vers `dev` via tools/handoff.py

## Hypothèses validées / invalidées
- VALIDE : palette intérieure (sombre volet fermé, révélation à l'ouverture) validée par l'utilisateur
- VALIDE : set d'instruments minimal générique retenu par l'utilisateur
- EN ATTENTE : retour de `dev` sur l'intégration des handoffs D3 et D4 (phases 4 et 5)

## Prochaine étape exacte
Phase D5 (passe visuelle finale) bloquée tant que `dev` n'a pas produit de rendu en situation à juger.

## Question bloquante pour la session suivante
Aucune
