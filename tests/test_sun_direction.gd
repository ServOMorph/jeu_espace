extends GdUnitTestSuite

const EPSILON := 0.0001


func test_angle_nul_a_t_zero() -> void:
	assert_float(SunDirection.angle_rotation_terre(0.0)).is_equal_approx(0.0, EPSILON)


func test_angle_periodique() -> void:
	var periode := SunDirection.PERIODE_ROTATION_TERRE_S
	assert_float(SunDirection.angle_rotation_terre(periode)).is_equal_approx(0.0, EPSILON)
	assert_float(SunDirection.angle_rotation_terre(2.0 * periode)).is_equal_approx(0.0, EPSILON)


func test_angle_croissant_dans_la_periode() -> void:
	var periode := SunDirection.PERIODE_ROTATION_TERRE_S
	var precedent := SunDirection.angle_rotation_terre(0.0)
	for fraction in [0.1, 0.3, 0.5, 0.7, 0.9]:
		var angle := SunDirection.angle_rotation_terre(fraction * periode)
		assert_float(angle).is_greater(precedent)
		precedent = angle


func test_rotation_terre_preserve_l_axe_up() -> void:
	var rotation := SunDirection.rotation_terre(1000.0)
	var resultat: Vector3 = rotation * Vector3.UP
	assert_float(resultat.distance_to(Vector3.UP)).is_less(EPSILON)


func test_rotation_terre_periode_complete_revient_a_l_identite() -> void:
	var periode := SunDirection.PERIODE_ROTATION_TERRE_S
	var reference := Vector3.FORWARD
	var au_depart: Vector3 = SunDirection.rotation_terre(0.0) * reference
	var apres_periode: Vector3 = SunDirection.rotation_terre(periode) * reference
	assert_float(au_depart.distance_to(apres_periode)).is_less(EPSILON)


func test_coherence_jour_nuit_sur_une_periode_complete() -> void:
	var periode := SunDirection.PERIODE_ROTATION_TERRE_S
	var direction_soleil := Vector3(1.0, 0.0, 0.0)
	var normale_locale := Vector3(1.0, 0.0, 0.0)
	var max_facteur := 0.0
	var min_facteur := 1.0
	var pas := periode / 20.0
	var t := 0.0
	while t <= periode:
		var rotation := SunDirection.rotation_terre(t)
		var normale_monde: Vector3 = rotation * normale_locale
		var facteur := Eclairage.facteur_jour(normale_monde, direction_soleil)
		max_facteur = maxf(max_facteur, facteur)
		min_facteur = minf(min_facteur, facteur)
		t += pas
	assert_float(max_facteur).is_greater(0.9)
	assert_float(min_facteur).is_less(0.1)
