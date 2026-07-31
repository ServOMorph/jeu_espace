# Signals — orchestrateur   (MAJ 2026-07-31)

## Actions ouvertes
- [P1|ouvert] Lancer /start dev pour démarrer la phase 0 (fondations projet Godot)
  fait quand: project.godot créé, fenêtre 1920x1080, scène racine qui se lance sans erreur
  réf: roadmap_mvp.md (Phase 0)
- [P2|ouvert] Trancher qui produit le mesh du vaisseau (dev ou design) et sous quelle forme (.tscn ou .obj)
  fait quand: décision actée dans roadmap_mvp.md avant ouverture de la phase 3
  réf: roadmap_mvp.md (section "Friction de périmètre restante")

## Dernière session (2026-07-31)
<!-- Écrasé intégralement par /close. Synthèse < 25 lignes. -->
# Session du 2026-07-31

## Décisions prises
- Roadmap MVP créée : 7 phases (fondations, environnement spatial, orbite, vaisseau, centre de commande, cockpit, bascule/polish).
- Pas de pilotage au MVP, orbite sur rail à échelle réduite, altitude basse ~400 km (type ISS).
- Temps de simulation découplé, multiplicateur x1/x10/x60 réglable au clavier.
- Coupole du centre de commande dotée d'un volet blindé rétractable (mécanique interactive MVP).
- Terre en textures NASA réelles (pas de génération IA), assets stockés dans DESIGN/ et importés directement (pas de dossier assets/ à la racine).
- Mesh du vaisseau produit par un agent (dev ou design à trancher en phase 3), jamais par outil externe.
- Répartition des phases entre agents dev/design actée dans la roadmap.

## Livrables produits ou modifiés
- roadmap_mvp.md : créé, 7 phases + décisions cadrantes + répartition agents.
- .claude/zones.md : modifié (ajout alias dev, design).
- DEV/, DESIGN/ : zones agents créées hors session (agent_role.md + _contexte), non committées avant cette clôture.

## Hypothèses validées / invalidées
- VALIDE : orbite basse 400 km, volet rétractable, temps réglable, assets dans DESIGN/.
- EN ATTENTE : production du mesh du vaisseau (dev vs design), arbitrage repoussé à l'ouverture de la phase 3.

## Prochaine étape exacte
Lancer /start dev pour démarrer la phase 0 (fondations du projet Godot) selon roadmap_mvp.md.

## Question bloquante pour la session suivante
Aucune
