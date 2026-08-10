extends Camera3D

## Camera libre du monde lointain (echelle planetaire, WorldScale : 1 unite = 100 km),
## reservee a scenes/test_env.tscn. Independante du vaisseau : explore Terre/Lune/Soleil
## sans etre liee a l'orbite ni synchronisee par vue_orbitale.gd. Vit dans LointainViewport
## (World3D propre a ce sous-viewport), rendue plein ecran via FondLointain des lors
## qu'aucune camera du monde proche n'est active (cf. selecteur_camera.gd).

@export var vitesse := 15.0
@export var vitesse_rapide := 150.0
@export var sensibilite := 0.003
## Desactive quand une scene externe pilote l'activation (cf. selecteur_camera.gd).
@export var actif_au_demarrage := true

var _vol: VolLibre
var _capture := false
var _actif := false


func _ready() -> void:
	near = 0.1
	far = 12000.0
	_vol = VolLibre.new(vitesse, vitesse_rapide)
	var rayon := WorldScale.rayon_terre_unites()
	position = Vector3(rayon * 2.2, rayon * 1.1, rayon * 2.2)
	look_at(Vector3.ZERO, Vector3.UP)
	if actif_au_demarrage:
		activer()


func activer() -> void:
	_actif = true
	current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_capture = true


func desactiver() -> void:
	_actif = false
	_capture = false
	current = false


func _input(event: InputEvent) -> void:
	if not _actif:
		return
	if event is InputEventMouseMotion and _capture:
		rotate_y(-event.relative.x * sensibilite)
		rotate_object_local(Vector3.RIGHT, -event.relative.y * sensibilite)
	elif event is InputEventMouseButton and not _capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_capture = true
	elif event.is_action_pressed("quit") and _capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		_capture = false


func _process(delta: float) -> void:
	if not _actif:
		return
	var direction := Vector3.ZERO
	if Input.is_key_pressed(KEY_Z) or Input.is_key_pressed(KEY_W):
		direction -= basis.z
	if Input.is_key_pressed(KEY_S):
		direction += basis.z
	if Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_A):
		direction -= basis.x
	if Input.is_key_pressed(KEY_D):
		direction += basis.x
	if Input.is_key_pressed(KEY_SPACE):
		direction += Vector3.UP
	if Input.is_key_pressed(KEY_CTRL):
		direction -= Vector3.UP

	position += _vol.deplacement(direction, Input.is_key_pressed(KEY_SHIFT), delta)
