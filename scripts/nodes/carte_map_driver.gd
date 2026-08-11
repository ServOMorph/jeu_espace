extends Node

## Cablage : pousse en continu la projection des positions Terre/Lune/Soleil
## (scripts/core/cockpit_map.gd) vers l'ecran 1 du cockpit (Ecran1, contenu dessine par
## scripts/nodes/carte_contenu.gd). Seule donnee live du cockpit, cf. roadmap_dev.md
## Phase 5 (Ajout de perimetre 2026-08-11) : affichage permanent, pas d'overlay ni de clic.

@export var vue_orbitale_path: NodePath
@export var horloge_path: NodePath
@export var lune_path: NodePath
@export var soleil_path: NodePath
@export var contenu_path: NodePath


func _process(_delta: float) -> void:
	var vue := get_node_or_null(vue_orbitale_path)
	var horloge := get_node_or_null(horloge_path)
	var lune := get_node_or_null(lune_path) as Node3D
	var soleil := get_node_or_null(soleil_path) as Node3D
	var contenu := get_node_or_null(contenu_path)
	if vue == null or horloge == null or lune == null or soleil == null or contenu == null:
		return
	if vue.orbite == null:
		return
	var t: float = horloge.temps_simule()
	var repere: Transform3D = vue.orbite.frame_at(t)
	var direction_soleil := Eclairage.direction_vers_soleil(soleil.global_transform.basis)
	contenu.positions = CockpitMap.positions_carte(
		repere, lune.global_transform.origin, direction_soleil
	)
	contenu.queue_redraw()
