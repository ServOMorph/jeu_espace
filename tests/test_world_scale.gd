extends GdUnitTestSuite

const EPSILON := 0.0001


func test_conversion_aller_retour_km() -> void:
	for km in [0.0, 1.0, 6371.0, 384400.0, -250.0]:
		assert_float(WorldScale.unites_vers_km(WorldScale.km_vers_unites(km))).is_equal_approx(km, EPSILON)


func test_conversion_aller_retour_unites() -> void:
	for unites in [0.0, 0.5, 63.71, 3844.0, -2.5]:
		assert_float(WorldScale.km_vers_unites(WorldScale.unites_vers_km(unites))).is_equal_approx(unites, EPSILON)


func test_zero_est_invariant() -> void:
	assert_float(WorldScale.km_vers_unites(0.0)).is_equal(0.0)
	assert_float(WorldScale.unites_vers_km(0.0)).is_equal(0.0)


func test_conversion_est_lineaire() -> void:
	assert_float(WorldScale.km_vers_unites(2.0 * WorldScale.KM_PAR_UNITE)).is_equal_approx(2.0, EPSILON)
	assert_float(WorldScale.km_vers_unites(WorldScale.KM_PAR_UNITE)).is_equal_approx(1.0, EPSILON)


func test_rayon_terre() -> void:
	assert_float(WorldScale.rayon_terre_unites()).is_equal_approx(63.71, EPSILON)


func test_orbite_est_au_dessus_de_la_surface() -> void:
	var orbite := WorldScale.rayon_orbite_unites()
	assert_float(orbite).is_greater(WorldScale.rayon_terre_unites())
	assert_float(WorldScale.unites_vers_km(orbite - WorldScale.rayon_terre_unites())).is_equal_approx(
		WorldScale.ALTITUDE_ORBITE_KM, 0.001
	)


func test_orbite_altitude_parametrable() -> void:
	assert_float(WorldScale.rayon_orbite_unites(0.0)).is_equal_approx(WorldScale.rayon_terre_unites(), EPSILON)
	var haute := WorldScale.rayon_orbite_unites(35786.0)
	assert_float(haute).is_greater(WorldScale.rayon_orbite_unites(400.0))


func test_nuages_au_dessus_de_la_surface() -> void:
	var nuages := WorldScale.rayon_nuages_unites()
	assert_float(nuages).is_greater(WorldScale.rayon_terre_unites())
	assert_float(WorldScale.unites_vers_km(nuages - WorldScale.rayon_terre_unites())).is_equal_approx(
		WorldScale.ALTITUDE_NUAGES_KM, 0.001
	)


func test_nuages_sous_l_orbite_basse() -> void:
	assert_float(WorldScale.rayon_nuages_unites()).is_less(WorldScale.rayon_orbite_unites())


func test_lune_hors_de_l_orbite_basse() -> void:
	assert_float(WorldScale.distance_lune_unites()).is_greater(WorldScale.rayon_orbite_unites())
	assert_float(WorldScale.rayon_lune_unites()).is_less(WorldScale.rayon_terre_unites())


func test_diametre_apparent_reciproque_du_rayon() -> void:
	var distance := 1000.0
	for angle in [0.1, 0.533, 5.0, 45.0]:
		var rayon := WorldScale.rayon_pour_diametre_apparent(distance, angle)
		assert_float(WorldScale.diametre_apparent_deg(rayon, distance)).is_equal_approx(angle, 0.001)


func test_diametre_apparent_distance_nulle() -> void:
	assert_float(WorldScale.diametre_apparent_deg(10.0, 0.0)).is_equal(0.0)
	assert_float(WorldScale.diametre_apparent_deg(10.0, -5.0)).is_equal(0.0)


func test_soleil_conserve_son_diametre_apparent() -> void:
	assert_float(
		WorldScale.diametre_apparent_deg(WorldScale.rayon_soleil_unites(), WorldScale.SOLEIL_DISTANCE_UNITES)
	).is_equal_approx(WorldScale.SOLEIL_DIAMETRE_APPARENT_DEG, 0.001)


## La Lune est placee a son echelle reelle : son diametre apparent doit tomber
## sur la valeur observee depuis la Terre, proche de celle du Soleil.
func test_lune_a_un_diametre_apparent_realiste() -> void:
	var apparent := WorldScale.diametre_apparent_deg(
		WorldScale.rayon_lune_unites(), WorldScale.distance_lune_unites()
	)
	assert_float(apparent).is_between(0.48, 0.58)


func test_soleil_plus_loin_que_la_lune() -> void:
	assert_float(WorldScale.SOLEIL_DISTANCE_UNITES).is_greater(WorldScale.distance_lune_unites())
