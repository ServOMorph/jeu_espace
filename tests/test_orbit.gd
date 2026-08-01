extends GdUnitTestSuite

const EPSILON := 0.0001


func test_altitude_constante() -> void:
	var orbite := Orbit.new(100.0, 5400.0, deg_to_rad(30.0), 0.7)
	for t in [0.0, 1000.0, 2700.0, 4000.0, 5400.0, 9000.0]:
		assert_float(orbite.position_at(t).length()).is_equal_approx(100.0, EPSILON)


func test_periodicite() -> void:
	var orbite := Orbit.new(50.0, 3600.0, deg_to_rad(15.0), 1.2)
	for t in [0.0, 500.0, 1800.0, 3000.0]:
		var a := orbite.position_at(t)
		var b := orbite.position_at(t + orbite.periode_s)
		assert_float(a.distance_to(b)).is_less(EPSILON)


func test_sans_inclinaison_le_plan_reste_horizontal() -> void:
	var orbite := Orbit.new(20.0, 1000.0)
	for t in [0.0, 250.0, 800.0]:
		assert_float(orbite.position_at(t).y).is_equal_approx(0.0, EPSILON)


func test_inclinaison_sort_du_plan_horizontal() -> void:
	var orbite := Orbit.new(20.0, 1000.0, deg_to_rad(45.0))
	var point := orbite.position_at(250.0)
	assert_float(absf(point.y)).is_greater(0.1)


func test_phase_depart_deplace_le_point_initial() -> void:
	var sans_phase := Orbit.new(10.0, 100.0)
	var avec_phase := Orbit.new(10.0, 100.0, 0.0, deg_to_rad(90.0))
	assert_float(sans_phase.position_at(0.0).distance_to(avec_phase.position_at(0.0))).is_greater(1.0)
	assert_float(avec_phase.position_at(0.0).length()).is_equal_approx(10.0, EPSILON)


func test_tangente_unitaire() -> void:
	var orbite := Orbit.new(30.0, 2000.0, deg_to_rad(20.0))
	for t in [0.0, 400.0, 1500.0]:
		assert_float(orbite.tangent_at(t).length()).is_equal_approx(1.0, EPSILON)


func test_tangente_orthogonale_au_rayon() -> void:
	var orbite := Orbit.new(30.0, 2000.0, deg_to_rad(20.0), 0.4)
	for t in [0.0, 400.0, 1500.0, 1999.0]:
		var rayon := orbite.position_at(t).normalized()
		var tangente := orbite.tangent_at(t)
		assert_float(rayon.dot(tangente)).is_equal_approx(0.0, EPSILON)


func test_tangente_periodique() -> void:
	var orbite := Orbit.new(30.0, 900.0, deg_to_rad(10.0))
	var a := orbite.tangent_at(123.0)
	var b := orbite.tangent_at(123.0 + orbite.periode_s)
	assert_float(a.distance_to(b)).is_less(EPSILON)


func test_frame_est_pose_sur_l_orbite() -> void:
	var orbite := Orbit.new(67.71, 5400.0, deg_to_rad(51.6), 0.3)
	for t in [0.0, 800.0, 2700.0, 5400.0]:
		assert_float(orbite.frame_at(t).origin.distance_to(orbite.position_at(t))).is_less(EPSILON)


func test_frame_avant_est_la_tangente() -> void:
	var orbite := Orbit.new(67.71, 5400.0, deg_to_rad(51.6), 0.3)
	for t in [0.0, 800.0, 2700.0]:
		assert_float(orbite.frame_at(t).basis.y.distance_to(orbite.tangent_at(t))).is_less(EPSILON)


func test_frame_dorsal_pointe_au_zenith() -> void:
	var orbite := Orbit.new(67.71, 5400.0, deg_to_rad(51.6), 0.3)
	for t in [0.0, 800.0, 2700.0]:
		var zenith := orbite.position_at(t).normalized()
		assert_float(orbite.frame_at(t).basis.z.distance_to(zenith)).is_less(EPSILON)


## Une base non orthonormee deformerait le vaisseau et fausserait la conversion de repere
## de RepereVaisseau.transform_camera_lointaine.
func test_frame_est_orthonorme() -> void:
	var orbite := Orbit.new(67.71, 5400.0, deg_to_rad(51.6), 0.3)
	for t in [0.0, 800.0, 2700.0, 4900.0]:
		var base := orbite.frame_at(t).basis
		assert_float(base.x.length()).is_equal_approx(1.0, EPSILON)
		assert_float(base.y.length()).is_equal_approx(1.0, EPSILON)
		assert_float(base.z.length()).is_equal_approx(1.0, EPSILON)
		assert_float(base.x.dot(base.y)).is_equal_approx(0.0, EPSILON)
		assert_float(base.y.dot(base.z)).is_equal_approx(0.0, EPSILON)
		assert_float(base.z.dot(base.x)).is_equal_approx(0.0, EPSILON)


## Base directe : une base indirecte retournerait le vaisseau en miroir.
func test_frame_est_directe() -> void:
	var orbite := Orbit.new(67.71, 5400.0, deg_to_rad(51.6), 0.3)
	for t in [0.0, 1300.0, 3600.0]:
		var base := orbite.frame_at(t).basis
		assert_float(base.x.cross(base.y).distance_to(base.z)).is_less(EPSILON)
		assert_float(base.determinant()).is_equal_approx(1.0, EPSILON)


func test_phase_pour_direction_sans_inclinaison() -> void:
	assert_float(Orbit.phase_pour_direction(Vector3(1.0, 0.0, 0.0), 0.0)).is_equal_approx(0.0, EPSILON)
	assert_float(Orbit.phase_pour_direction(Vector3(0.0, 0.0, 1.0), 0.0)).is_equal_approx(
		TAU / 4.0, EPSILON
	)


func test_phase_pour_direction_aligne_le_point_initial() -> void:
	var direction := Vector3(-0.642788, 0.0, 0.766044)
	var phase := Orbit.phase_pour_direction(direction, 0.0)
	var orbite := Orbit.new(10.0, 5400.0, 0.0, phase)
	assert_float(orbite.position_at(0.0).normalized().distance_to(direction.normalized())).is_less(
		EPSILON
	)


## Exigence roadmap phase 2 : le depart doit se faire de jour, cote eclaire.
func test_phase_pour_direction_demarre_de_jour() -> void:
	var direction := Vector3(-0.642788, 0.0, 0.766044)
	for inclinaison_deg in [0.0, 28.5, 51.6, 80.0]:
		var inclinaison := deg_to_rad(inclinaison_deg)
		var orbite := Orbit.new(
			67.71, 5400.0, inclinaison, Orbit.phase_pour_direction(direction, inclinaison)
		)
		var zenith := orbite.position_at(0.0).normalized()
		assert_float(zenith.dot(direction.normalized())).is_greater(0.5)


## Le point initial doit etre le plus eclaire de toute l'orbite, pas seulement eclaire.
func test_phase_pour_direction_maximise_l_ensoleillement() -> void:
	var direction := Vector3(0.3, -0.5, 0.81).normalized()
	var inclinaison := deg_to_rad(51.6)
	var orbite := Orbit.new(
		67.71, 5400.0, inclinaison, Orbit.phase_pour_direction(direction, inclinaison)
	)
	var depart := orbite.position_at(0.0).normalized().dot(direction)
	for i in 64:
		var t := orbite.periode_s * i / 64.0
		assert_float(orbite.position_at(t).normalized().dot(direction)).is_less_equal(
			depart + EPSILON
		)


func test_frame_periodique() -> void:
	var orbite := Orbit.new(67.71, 5400.0, deg_to_rad(51.6), 0.3)
	var a := orbite.frame_at(1500.0)
	var b := orbite.frame_at(1500.0 + orbite.periode_s)
	assert_float(a.origin.distance_to(b.origin)).is_less(EPSILON)
	assert_float(a.basis.y.distance_to(b.basis.y)).is_less(EPSILON)
