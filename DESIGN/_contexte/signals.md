# Signals — design   (MAJ 2026-08-11)

## Actions ouvertes
- [P2|ouvert] Phase D5 (passe visuelle finale) : retour `dev` reçu (exposition, contraste
  Terre/espace, lisibilité nuit jugés ok ; halo atmosphérique jugé trop uniforme, corrigé cette
  session). Reste à vérifier si d'autres aspects du gate D5 sont à traiter, puis mettre à jour
  `charte.md` avec les valeurs finalement retenues pour le halo.
  fait quand: `charte.md` à jour + aucun autre défaut visuel signalé + `MANIFEST.md` sans ligne
  `placeholder`.
  réf: DESIGN/roadmap_design.md (Phase D5), shaders/halo.gdshader

## Dernière session (2026-08-11)
# Session du 2026-08-11

## Décisions prises
- Halo atmosphérique jugé trop uniforme (pas de dégradé, aussi visible jour que nuit) lors de la
  revue en situation (phase D5). Exception explicite : correction effectuée directement dans
  `shaders/halo.gdshader` depuis la session `design`, hors périmètre normal de la zone (shader/code
  applicatif), sur autorisation explicite de l'utilisateur plutôt que passation vers `dev`.
- Exposition, contraste Terre/espace, lisibilité nuit : jugés ok par l'utilisateur, aucune
  correction requise.

## Livrables produits ou modifiés
- shaders/halo.gdshader : `exposant_fresnel_diffus` 1.4→2.2 (resserre le dégradé du halo diffus),
  `intensite_nuit_min` 0.12→0.0 (supprime le halo résiduel côté nuit sans soleil), smoothstep du
  terminateur -0.3/0.3→-0.15/0.15 (transition jour/nuit plus marquée). Validé par l'utilisateur
  ("halo ok").

## Hypothèses validées / invalidées
- VALIDE : aucun asset DESIGN n'existe pour le halo (absent de `MANIFEST.md`) — c'est un effet
  procédural pur (shader Fresnel), la consigne du gate D5 "corriger les assets" ne s'applique pas.
- VALIDE : correction shader suffisante pour lever le défaut signalé.

## Prochaine étape exacte
Vérifier s'il reste d'autres défauts à traiter pour la phase D5 ; sinon mettre à jour `charte.md`
avec les valeurs de halo retenues et clore la phase.

## Question bloquante pour la session suivante
Aucune
