extends GdUnitTestSuite

const EPSILON := 0.0001


func test_deplacement_nul_sans_direction() -> void:
	var vol := VolLibre.new(25.0, 250.0)
	assert_vector(vol.deplacement(Vector3.ZERO, false, 1.0)).is_equal_approx(Vector3.ZERO, Vector3.ONE * EPSILON)


func test_deplacement_vitesse_normale() -> void:
	var vol := VolLibre.new(25.0, 250.0)
	var d := vol.deplacement(Vector3(0.0, 0.0, -1.0), false, 2.0)
	assert_float(d.length()).is_equal_approx(50.0, EPSILON)


func test_deplacement_vitesse_rapide() -> void:
	var vol := VolLibre.new(25.0, 250.0)
	var d := vol.deplacement(Vector3(0.0, 0.0, -1.0), true, 2.0)
	assert_float(d.length()).is_equal_approx(500.0, EPSILON)


func test_deplacement_direction_non_normalisee() -> void:
	var vol := VolLibre.new(10.0, 100.0)
	var d := vol.deplacement(Vector3(3.0, 0.0, 4.0), false, 1.0)
	assert_float(d.length()).is_equal_approx(10.0, EPSILON)


func test_deplacement_suit_la_direction() -> void:
	var vol := VolLibre.new(10.0, 100.0)
	var direction := Vector3(1.0, 0.0, 0.0)
	var d := vol.deplacement(direction, false, 1.0)
	assert_float(d.normalized().distance_to(direction)).is_less(EPSILON)
