extends GdUnitTestSuite

const EPSILON := 0.0001


func test_distance_initiale_bornee() -> void:
	var cam := CameraOrbite.new(1000.0, 10.0, 100.0)
	assert_float(cam.distance).is_equal_approx(100.0, EPSILON)


func test_zoom_avant_rapproche() -> void:
	var cam := CameraOrbite.new(100.0, 1.0, 1000.0)
	cam.appliquer_zoom(1.0)
	assert_float(cam.distance).is_less(100.0)


func test_zoom_arriere_eloigne() -> void:
	var cam := CameraOrbite.new(100.0, 1.0, 1000.0)
	cam.appliquer_zoom(-1.0)
	assert_float(cam.distance).is_greater(100.0)


func test_zoom_respecte_la_borne_min() -> void:
	var cam := CameraOrbite.new(10.0, 5.0, 1000.0)
	for i in 50:
		cam.appliquer_zoom(1.0)
	assert_float(cam.distance).is_equal_approx(5.0, EPSILON)


func test_zoom_respecte_la_borne_max() -> void:
	var cam := CameraOrbite.new(10.0, 1.0, 20.0)
	for i in 50:
		cam.appliquer_zoom(-1.0)
	assert_float(cam.distance).is_equal_approx(20.0, EPSILON)


func test_pitch_borne_haute_respectee() -> void:
	var cam := CameraOrbite.new(10.0, 1.0, 100.0, 1.0)
	cam.appliquer_delta_souris(Vector2(0.0, -1000.0))
	assert_float(cam.pitch).is_equal_approx(CameraOrbite.PITCH_MAX_DEFAUT, EPSILON)


func test_pitch_borne_basse_respectee() -> void:
	var cam := CameraOrbite.new(10.0, 1.0, 100.0, 1.0)
	cam.appliquer_delta_souris(Vector2(0.0, 1000.0))
	assert_float(cam.pitch).is_equal_approx(CameraOrbite.PITCH_MIN_DEFAUT, EPSILON)


func test_yaw_reste_dans_moins_pi_pi() -> void:
	var cam := CameraOrbite.new(10.0, 1.0, 100.0, 1.0)
	for i in 20:
		cam.appliquer_delta_souris(Vector2(-1.0, 0.0))
	assert_float(cam.yaw).is_greater_equal(-PI)
	assert_float(cam.yaw).is_less_equal(PI)


func test_position_a_distance_de_la_cible() -> void:
	var cible := Vector3(5.0, 0.0, 0.0)
	var cam := CameraOrbite.new(20.0, 1.0, 100.0, 0.003, 0.9, CameraOrbite.PITCH_MIN_DEFAUT,
		CameraOrbite.PITCH_MAX_DEFAUT, cible)
	cam.appliquer_delta_souris(Vector2(37.0, -12.0))
	assert_float(cam.position().distance_to(cible)).is_equal_approx(20.0, EPSILON)


func test_position_a_l_origine_de_yaw_pitch_est_cible_plus_avant_fois_distance() -> void:
	var avant := Vector3(0.0, 1.0, 0.0)
	var haut := Vector3(0.0, 0.0, 1.0)
	var cam := CameraOrbite.new(15.0, 1.0, 100.0, 0.003, 0.9, CameraOrbite.PITCH_MIN_DEFAUT,
		CameraOrbite.PITCH_MAX_DEFAUT, Vector3.ZERO, avant, haut)
	assert_vector(cam.position()).is_equal_approx(avant * 15.0, Vector3.ONE * EPSILON)


func test_basis_reste_orthonormee() -> void:
	var cam := CameraOrbite.new(10.0, 1.0, 100.0)
	cam.appliquer_delta_souris(Vector2(5.0, -3.0))
	var base := cam.basis()
	assert_float(base.x.length()).is_equal_approx(1.0, EPSILON)
	assert_float(base.y.length()).is_equal_approx(1.0, EPSILON)
	assert_float(base.z.length()).is_equal_approx(1.0, EPSILON)
	assert_float(base.x.dot(base.y)).is_equal_approx(0.0, EPSILON)
	assert_float(base.y.dot(base.z)).is_equal_approx(0.0, EPSILON)


func test_camera_regarde_vers_la_cible() -> void:
	var cible := Vector3(2.0, 0.0, 0.0)
	var cam := CameraOrbite.new(10.0, 1.0, 100.0, 0.003, 0.9, CameraOrbite.PITCH_MIN_DEFAUT,
		CameraOrbite.PITCH_MAX_DEFAUT, cible)
	cam.appliquer_delta_souris(Vector2(20.0, 8.0))
	var direction_regard := -cam.basis().z.normalized()
	var direction_attendue := (cible - cam.position()).normalized()
	assert_float(direction_regard.distance_to(direction_attendue)).is_less(EPSILON)
