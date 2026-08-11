extends GdUnitTestSuite

const EPSILON := 0.0001


func test_direction_vers_est_unitaire() -> void:
	var direction := CockpitMap.direction_vers(Vector3(1.0, 2.0, 3.0), Vector3(10.0, -4.0, 7.0))
	assert_float(direction.length()).is_equal_approx(1.0, EPSILON)


func test_direction_vers_pointe_correctement() -> void:
	var direction := CockpitMap.direction_vers(Vector3.ZERO, Vector3(0.0, 5.0, 0.0))
	assert_float(direction.distance_to(Vector3.UP)).is_less(EPSILON)


func test_projeter_avant_est_au_centre() -> void:
	var repere := Transform3D.IDENTITY
	var point := CockpitMap.projeter(repere.basis.y, repere)
	assert_float(point.length()).is_equal_approx(0.0, EPSILON)


func test_projeter_arriere_est_au_bord() -> void:
	var repere := Transform3D.IDENTITY
	var point := CockpitMap.projeter(-repere.basis.y, repere)
	assert_float(point.length()).is_equal_approx(1.0, EPSILON)


func test_projeter_dorsal_est_en_haut_de_la_carte() -> void:
	var repere := Transform3D.IDENTITY
	var point := CockpitMap.projeter(repere.basis.z, repere)
	assert_float(point.x).is_equal_approx(0.0, EPSILON)
	assert_float(point.y).is_less(0.0)


func test_projeter_reste_dans_le_disque_unite() -> void:
	var repere := Transform3D.IDENTITY
	for direction in [
		Vector3(1.0, 0.3, 0.2), Vector3(-0.5, -1.0, 0.7), Vector3(0.1, 0.0, -1.0)
	]:
		var point := CockpitMap.projeter(direction.normalized(), repere)
		assert_float(point.length()).is_less_equal(1.0001)


func test_projeter_suit_la_rotation_du_repere() -> void:
	var orbite := Orbit.new(67.71, 5400.0, deg_to_rad(51.6), 0.4)
	var repere := orbite.frame_at(1800.0)
	var point := CockpitMap.projeter(repere.basis.y, repere)
	assert_float(point.length()).is_equal_approx(0.0, EPSILON)


func test_positions_carte_retourne_les_trois_corps() -> void:
	var repere := Transform3D(Basis.IDENTITY, Vector3(0.0, -67.71, 0.0))
	var positions := CockpitMap.positions_carte(repere, Vector3(3844.0, 0.0, 0.0), Vector3(1.0, 0.0, 0.0))
	assert_dict(positions).contains_keys(["terre", "lune", "soleil"])


func test_positions_carte_terre_devant_quand_vaisseau_regarde_vers_elle() -> void:
	var repere := Transform3D(Basis.IDENTITY, Vector3(0.0, -67.71, 0.0))
	var positions: Dictionary = CockpitMap.positions_carte(
		repere, Vector3(3844.0, 0.0, 0.0), Vector3(1.0, 0.0, 0.0)
	)
	var terre: Vector2 = positions["terre"]
	assert_float(terre.length()).is_equal_approx(0.0, EPSILON)
