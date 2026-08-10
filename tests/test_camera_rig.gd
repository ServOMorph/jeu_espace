extends GdUnitTestSuite

const EPSILON := 0.0001


func test_yaw_est_circulaire() -> void:
	var rig := CameraRig.new(1.0)
	rig.appliquer_delta_souris(Vector2(-TAU, 0.0))
	assert_float(rig.yaw).is_equal_approx(0.0, 0.001)


func test_yaw_reste_dans_moins_pi_pi() -> void:
	var rig := CameraRig.new(1.0)
	for i in 20:
		rig.appliquer_delta_souris(Vector2(-1.0, 0.0))
	assert_float(rig.yaw).is_greater_equal(-PI)
	assert_float(rig.yaw).is_less_equal(PI)


func test_pitch_borne_haute_respectee() -> void:
	var rig := CameraRig.new(1.0, deg_to_rad(-45.0), deg_to_rad(45.0))
	rig.appliquer_delta_souris(Vector2(0.0, -1000.0))
	assert_float(rig.pitch).is_equal_approx(deg_to_rad(45.0), EPSILON)


func test_pitch_borne_basse_respectee() -> void:
	var rig := CameraRig.new(1.0, deg_to_rad(-45.0), deg_to_rad(45.0))
	rig.appliquer_delta_souris(Vector2(0.0, 1000.0))
	assert_float(rig.pitch).is_equal_approx(deg_to_rad(-45.0), EPSILON)


func test_sensibilite_multiplie_lineairement_le_delta() -> void:
	var faible := CameraRig.new(0.001)
	var forte := CameraRig.new(0.01)
	faible.appliquer_delta_souris(Vector2(10.0, 0.0))
	forte.appliquer_delta_souris(Vector2(10.0, 0.0))
	assert_float(forte.yaw).is_equal_approx(faible.yaw * 10.0, EPSILON)


func test_direction_a_l_origine_est_l_avant_de_reference() -> void:
	var avant := Vector3(0.0, 1.0, 0.0)
	var haut := Vector3(0.0, 0.0, 1.0)
	var rig := CameraRig.new(1.0, CameraRig.PITCH_MIN_DEFAUT, CameraRig.PITCH_MAX_DEFAUT, avant, haut)
	assert_float(rig.direction().distance_to(avant)).is_less(EPSILON)


func test_direction_reste_unitaire() -> void:
	var rig := CameraRig.new(0.5)
	rig.appliquer_delta_souris(Vector2(3.0, -2.0))
	assert_float(rig.direction().length()).is_equal_approx(1.0, EPSILON)


func test_yaw_illimite_par_defaut_permet_un_tour_complet() -> void:
	var rig := CameraRig.new(1.0)
	assert_float(rig.yaw_max - rig.yaw_min).is_greater_equal(CameraRig.YAW_CERCLE_COMPLET)


func test_yaw_borne_haute_respectee() -> void:
	var rig := CameraRig.new(
		1.0, CameraRig.PITCH_MIN_DEFAUT, CameraRig.PITCH_MAX_DEFAUT,
		Vector3(0.0, 1.0, 0.0), Vector3(0.0, 0.0, 1.0),
		deg_to_rad(-40.0), deg_to_rad(40.0)
	)
	rig.appliquer_delta_souris(Vector2(-1000.0, 0.0))
	assert_float(rig.yaw).is_equal_approx(deg_to_rad(40.0), EPSILON)


func test_yaw_borne_basse_respectee() -> void:
	var rig := CameraRig.new(
		1.0, CameraRig.PITCH_MIN_DEFAUT, CameraRig.PITCH_MAX_DEFAUT,
		Vector3(0.0, 1.0, 0.0), Vector3(0.0, 0.0, 1.0),
		deg_to_rad(-40.0), deg_to_rad(40.0)
	)
	rig.appliquer_delta_souris(Vector2(1000.0, 0.0))
	assert_float(rig.yaw).is_equal_approx(deg_to_rad(-40.0), EPSILON)


func test_cone_avant_cockpit_aucune_valeur_hors_bornes() -> void:
	var rig := CameraRig.new(
		0.003, deg_to_rad(-30.0), deg_to_rad(30.0),
		Vector3(0.0, 1.0, 0.0), Vector3(0.0, 0.0, 1.0),
		deg_to_rad(-45.0), deg_to_rad(45.0)
	)
	for i in 50:
		rig.appliquer_delta_souris(Vector2(2000.0, 2000.0))
	assert_float(rig.yaw).is_less_equal(deg_to_rad(45.0))
	assert_float(rig.yaw).is_greater_equal(deg_to_rad(-45.0))
	assert_float(rig.pitch).is_less_equal(deg_to_rad(30.0))
	assert_float(rig.pitch).is_greater_equal(deg_to_rad(-30.0))


func test_basis_reste_orthonormee() -> void:
	var rig := CameraRig.new(0.5)
	rig.appliquer_delta_souris(Vector2(3.0, -2.0))
	var base := rig.basis()
	assert_float(base.x.length()).is_equal_approx(1.0, EPSILON)
	assert_float(base.y.length()).is_equal_approx(1.0, EPSILON)
	assert_float(base.z.length()).is_equal_approx(1.0, EPSILON)
	assert_float(base.x.dot(base.y)).is_equal_approx(0.0, EPSILON)
	assert_float(base.y.dot(base.z)).is_equal_approx(0.0, EPSILON)
