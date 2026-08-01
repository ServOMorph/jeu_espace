extends Camera3D

## Camera de debug reservee a scenes/test_env.tscn, exclue du build final.
## Opere dans le repere metrique du vaisseau (1 unite = 1 m, cf. RepereVaisseau) :
## vitesses et plans de coupure sont exprimes en metres.
## La camera de jeu est scripts/core/camera_rig.gd (phase 4) : ne pas reprendre ce code.

## Dans le repere du vaisseau, +Y est l'avant et +Z le dorsal : Vector3.UP y designe le
## nez, pas le haut. Toute reference verticale passe par cette constante.
const DORSAL := Vector3(0.0, 0.0, 1.0)

@export var vitesse := 25.0
@export var vitesse_rapide := 250.0
@export var sensibilite := 0.003

var _capture := false


func _ready() -> void:
	near = 0.1
	far = 5000.0
	var longueur := RepereVaisseau.echelle_modele_metres()
	position = Vector3(longueur * 1.4, longueur * 1.3, longueur * 0.7)
	look_at(Vector3(0.0, longueur * 0.5, longueur * 0.15), DORSAL)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_capture = true


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and _capture:
		rotate_y(-event.relative.x * sensibilite)
		rotate_object_local(Vector3.RIGHT, -event.relative.y * sensibilite)
	elif event is InputEventMouseButton and not _capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_capture = true
	elif event.is_action_pressed("quit"):
		if _capture:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			_capture = false
		else:
			get_tree().quit()


func _process(delta: float) -> void:
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
		direction += DORSAL
	if Input.is_key_pressed(KEY_CTRL):
		direction -= DORSAL

	if direction != Vector3.ZERO:
		var v := vitesse_rapide if Input.is_key_pressed(KEY_SHIFT) else vitesse
		position += direction.normalized() * v * delta
