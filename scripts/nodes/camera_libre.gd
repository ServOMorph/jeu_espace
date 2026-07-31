extends Camera3D

## Camera de debug reservee a scenes/test_env.tscn, exclue du build final.
## La camera de jeu est scripts/core/camera_rig.gd (phase 4) : ne pas reprendre ce code.

@export var vitesse := 20.0
@export var vitesse_rapide := 200.0
@export var sensibilite := 0.003

var _capture := false


func _ready() -> void:
	position = Vector3(0.0, 0.0, WorldScale.rayon_orbite_unites())
	near = 0.05
	far = WorldScale.SOLEIL_DISTANCE_UNITES * 1.5
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
		direction += Vector3.UP
	if Input.is_key_pressed(KEY_CTRL):
		direction -= Vector3.UP

	if direction != Vector3.ZERO:
		var v := vitesse_rapide if Input.is_key_pressed(KEY_SHIFT) else vitesse
		position += direction.normalized() * v * delta
