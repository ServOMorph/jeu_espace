extends Node

var clock := SimClock.new()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("time_x1"):
		clock.definir_multiplicateur(SimClock.MULTIPLICATEUR_X1)
	elif Input.is_action_just_pressed("time_x10"):
		clock.definir_multiplicateur(SimClock.MULTIPLICATEUR_X10)
	elif Input.is_action_just_pressed("time_x60"):
		clock.definir_multiplicateur(SimClock.MULTIPLICATEUR_X60)
	clock.avancer(delta)


func temps_simule() -> float:
	return clock.temps_simule
