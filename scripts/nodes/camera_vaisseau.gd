extends Camera3D

## Camera d'exploration reservee a scenes/test_env.tscn, exclue du build final. Orbite
## autour du vaisseau (souris) avec zoom/dezoom (molette) — scripts/core/camera_orbite.gd.
## Opere dans le repere metrique du vaisseau (1 unite = 1 m, cf. RepereVaisseau), vaisseau
## fixe a l'origine locale : la cible de l'orbite est donc Vector3.ZERO.

## Dans le repere du vaisseau, +Y est l'avant et +Z le dorsal (cf. RepereVaisseau).
const AVANT := Vector3(0.0, 1.0, 0.0)
const DORSAL := Vector3(0.0, 0.0, 1.0)

@export var distance_defaut := 120.0
@export var distance_min := 20.0
@export var distance_max := 600.0
@export var sensibilite := 0.003
@export var facteur_zoom := 0.9
## Desactive quand une scene externe pilote l'activation (cf. selecteur_camera.gd) :
## la camera existe mais ne capture ni les entrees ni le rendu tant qu'activer() n'a
## pas ete appele.
@export var actif_au_demarrage := true

var _orbite: CameraOrbite
var _capture := false
var _actif := false


func _ready() -> void:
	near = 0.1
	far = 5000.0
	_orbite = CameraOrbite.new(
		distance_defaut, distance_min, distance_max, sensibilite, facteur_zoom,
		CameraOrbite.PITCH_MIN_DEFAUT, CameraOrbite.PITCH_MAX_DEFAUT,
		Vector3.ZERO, AVANT, DORSAL
	)
	if actif_au_demarrage:
		activer()


func activer() -> void:
	_actif = true
	current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_capture = true
	_appliquer()


func desactiver() -> void:
	_actif = false
	_capture = false
	current = false


func _input(event: InputEvent) -> void:
	if not _actif:
		return
	if event is InputEventMouseMotion and _capture:
		_orbite.appliquer_delta_souris(event.relative)
		_appliquer()
	elif event is InputEventMouseButton and not _capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_capture = true
	elif event is InputEventMouseButton and _capture:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_orbite.appliquer_zoom(1.0)
			_appliquer()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_orbite.appliquer_zoom(-1.0)
			_appliquer()
	elif event.is_action_pressed("quit") and _capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		_capture = false


func _appliquer() -> void:
	position = _orbite.position()
	transform.basis = _orbite.basis()
