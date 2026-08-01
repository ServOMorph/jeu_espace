extends Node

## Cablage : lit l'horloge, obtient le repere orbital de Orbit (core), place la camera
## lointaine et oriente la lumiere locale du vaisseau. Aucune decision ici.

@export var camera_locale_path: NodePath
@export var camera_lointaine_path: NodePath
@export var soleil_lointain_path: NodePath
@export var soleil_local_path: NodePath

@export var inclinaison_deg := 51.6
@export var periode_s := 5400.0
@export var energie_soleil := 1.0

var orbite: Orbit
var _horloge: Node


## L'orbite est construite au premier _process et non dans _ready : sa phase de depart
## derive de la direction du Soleil, qui vit dans un autre branche de la scene.
func _construire_orbite() -> void:
	var inclinaison := deg_to_rad(inclinaison_deg)
	var phase := 0.0
	var soleil := get_node_or_null(soleil_lointain_path) as Node3D
	if soleil != null:
		phase = Orbit.phase_pour_direction(
			Eclairage.direction_vers_soleil(soleil.global_transform.basis), inclinaison
		)
	orbite = Orbit.new(WorldScale.rayon_orbite_unites(), periode_s, inclinaison, phase)


func _process(_delta: float) -> void:
	if orbite == null:
		_construire_orbite()
	if _horloge == null:
		_horloge = get_tree().get_first_node_in_group("horloge")
		if _horloge == null:
			return
	var cam_locale := get_node_or_null(camera_locale_path) as Camera3D
	var cam_lointaine := get_node_or_null(camera_lointaine_path) as Camera3D
	if cam_locale == null or cam_lointaine == null:
		return
	var t: float = _horloge.temps_simule()
	var repere := orbite.frame_at(t)
	cam_lointaine.fov = cam_locale.fov
	cam_lointaine.transform = RepereVaisseau.transform_camera_lointaine(
		repere, cam_locale.global_transform.orthonormalized()
	)
	_orienter_soleil_local(repere)


func _orienter_soleil_local(repere: Transform3D) -> void:
	var soleil_lointain := get_node_or_null(soleil_lointain_path) as Node3D
	var soleil_local := get_node_or_null(soleil_local_path) as DirectionalLight3D
	if soleil_lointain == null or soleil_local == null:
		return
	var direction_monde := Eclairage.direction_vers_soleil(soleil_lointain.global_transform.basis)
	var direction_locale := RepereVaisseau.direction_soleil_locale(repere, direction_monde)
	var reference := Vector3.UP if absf(direction_locale.dot(Vector3.UP)) < 0.999 else Vector3.RIGHT
	soleil_local.look_at_from_position(Vector3.ZERO, -direction_locale, reference)
	soleil_local.light_energy = energie_soleil * Eclairage.facteur_eclipse(
		repere.origin, direction_monde, WorldScale.rayon_terre_unites()
	)
