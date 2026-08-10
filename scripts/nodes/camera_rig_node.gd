extends Node

## Cablage : lit les deltas souris et les touches de debattement, les passe a CameraRig
## (core), applique le resultat sur la Camera3D. Aucune decision ici.
##
## Le noeud opere dans le repere local du vaisseau (Y = avant, Z = dorsal/haut, cf.
## RepereVaisseau) : yaw pivote autour de DORSAL, pas de Vector3.UP.

const DORSAL := Vector3(0.0, 0.0, 1.0)
const AVANT := Vector3(0.0, 1.0, 0.0)

@export var camera_path: NodePath
@export var sensibilite := 0.003
@export var pitch_min := CameraRig.PITCH_MIN_DEFAUT
@export var pitch_max := CameraRig.PITCH_MAX_DEFAUT
@export var yaw_min := CameraRig.YAW_MIN_DEFAUT
@export var yaw_max := CameraRig.YAW_MAX_DEFAUT
## Desactive quand une scene externe pilote l'activation (cf. selecteur_camera.gd) :
## le rig existe mais ne capture ni les entrees ni le rendu tant qu'activer() n'a
## pas ete appele.
@export var actif_au_demarrage := true

var _rig: CameraRig
var _capture := false
var _actif := false


func _ready() -> void:
	_rig = CameraRig.new(sensibilite, pitch_min, pitch_max, AVANT, DORSAL, yaw_min, yaw_max)
	if actif_au_demarrage:
		activer()


func activer() -> void:
	_actif = true
	var camera := get_node_or_null(camera_path) as Camera3D
	if camera != null:
		camera.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_capture = true
	_appliquer()


func desactiver() -> void:
	_actif = false
	_capture = false
	var camera := get_node_or_null(camera_path) as Camera3D
	if camera != null:
		camera.current = false


func _input(event: InputEvent) -> void:
	if not _actif:
		return
	if event is InputEventMouseMotion and _capture:
		_rig.appliquer_delta_souris(event.relative)
		_appliquer()
	elif event is InputEventMouseButton and not _capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_capture = true
	elif event.is_action_pressed("quit") and _capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		_capture = false


func _appliquer() -> void:
	var camera := get_node_or_null(camera_path) as Camera3D
	if camera != null:
		camera.transform.basis = _rig.basis()
