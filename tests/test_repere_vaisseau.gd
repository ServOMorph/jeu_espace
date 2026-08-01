extends GdUnitTestSuite

const EPSILON := 0.0001


func test_echelle_modele_en_metres() -> void:
	assert_float(RepereVaisseau.echelle_modele_metres()).is_equal_approx(
		RepereVaisseau.LONGUEUR_VAISSEAU_M, EPSILON
	)


func test_metres_par_unite_planetaire_derive_de_world_scale() -> void:
	assert_float(RepereVaisseau.metres_par_unite_planetaire()).is_equal_approx(
		WorldScale.KM_PAR_UNITE * 1000.0, EPSILON
	)


func test_conversion_aller_retour_metres() -> void:
	for metres in [0.0, 1.0, 60.0, 400000.0, -250.0]:
		var retour := RepereVaisseau.unites_planetaires_vers_metres(
			RepereVaisseau.metres_vers_unites_planetaires(metres)
		)
		assert_float(retour).is_equal_approx(metres, EPSILON)


func test_une_unite_planetaire_vaut_l_altitude_en_metres() -> void:
	var metres := RepereVaisseau.unites_planetaires_vers_metres(1.0)
	assert_float(metres).is_equal_approx(WorldScale.KM_PAR_UNITE * 1000.0, EPSILON)


## Le vaisseau est minuscule a l'echelle planetaire : c'est la raison d'etre du repere.
func test_vaisseau_negligeable_en_unites_planetaires() -> void:
	var longueur := RepereVaisseau.metres_vers_unites_planetaires(
		RepereVaisseau.echelle_modele_metres()
	)
	assert_float(longueur).is_less(WorldScale.rayon_orbite_unites() * 0.001)


func test_camera_a_l_origine_locale_est_sur_le_vaisseau() -> void:
	var orbite := Orbit.new(67.71, 5400.0, deg_to_rad(51.6))
	var repere := orbite.frame_at(1234.0)
	var lointaine := RepereVaisseau.transform_camera_lointaine(repere, Transform3D.IDENTITY)
	assert_float(lointaine.origin.distance_to(repere.origin)).is_less(EPSILON)


func test_decalage_local_converti_en_unites_planetaires() -> void:
	var repere := Transform3D.IDENTITY
	var metres := RepereVaisseau.metres_par_unite_planetaire()
	var cam := Transform3D(Basis.IDENTITY, Vector3(metres, 0.0, 0.0))
	var lointaine := RepereVaisseau.transform_camera_lointaine(repere, cam)
	assert_float(lointaine.origin.distance_to(Vector3(1.0, 0.0, 0.0))).is_less(EPSILON)


## Le decalage local doit etre exprime dans les axes du vaisseau, pas dans ceux du monde.
func test_decalage_suit_l_orientation_du_vaisseau() -> void:
	var orbite := Orbit.new(67.71, 5400.0, deg_to_rad(51.6), 0.9)
	var repere := orbite.frame_at(600.0)
	var avance := RepereVaisseau.metres_par_unite_planetaire()
	var cam := Transform3D(Basis.IDENTITY, Vector3(0.0, avance, 0.0))
	var lointaine := RepereVaisseau.transform_camera_lointaine(repere, cam)
	var attendu := repere.origin + repere.basis.y
	assert_float(lointaine.origin.distance_to(attendu)).is_less(EPSILON)


func test_orientation_composee_avec_celle_du_vaisseau() -> void:
	var orbite := Orbit.new(67.71, 5400.0, deg_to_rad(30.0))
	var repere := orbite.frame_at(2000.0)
	var rotation := Basis(Vector3.UP, deg_to_rad(40.0))
	var lointaine := RepereVaisseau.transform_camera_lointaine(
		repere, Transform3D(rotation, Vector3.ZERO)
	)
	var attendu := repere.basis * rotation
	assert_float(lointaine.basis.x.distance_to(attendu.x)).is_less(EPSILON)
	assert_float(lointaine.basis.y.distance_to(attendu.y)).is_less(EPSILON)
	assert_float(lointaine.basis.z.distance_to(attendu.z)).is_less(EPSILON)


func test_direction_soleil_locale_est_unitaire() -> void:
	var orbite := Orbit.new(67.71, 5400.0, deg_to_rad(51.6))
	for t in [0.0, 900.0, 2700.0, 5000.0]:
		var direction := RepereVaisseau.direction_soleil_locale(
			orbite.frame_at(t), Vector3(1.0, 0.0, 0.0)
		)
		assert_float(direction.length()).is_equal_approx(1.0, EPSILON)


func test_direction_soleil_locale_identite_sans_rotation() -> void:
	var direction := RepereVaisseau.direction_soleil_locale(
		Transform3D.IDENTITY, Vector3(0.0, 0.0, 3.0)
	)
	assert_float(direction.distance_to(Vector3(0.0, 0.0, 1.0))).is_less(EPSILON)


## Passer du repere monde au repere vaisseau ne doit pas changer l'angle entre le Soleil
## et un axe du vaisseau : sinon l'eclairage du vaisseau derive de celui de la Terre.
func test_direction_soleil_locale_conserve_l_angle_a_l_axe_avant() -> void:
	var orbite := Orbit.new(67.71, 5400.0, deg_to_rad(51.6), 0.4)
	var soleil_monde := Vector3(1.0, 0.0, 0.0)
	for t in [0.0, 700.0, 1800.0, 4100.0]:
		var repere := orbite.frame_at(t)
		var angle_monde := repere.basis.y.dot(soleil_monde.normalized())
		var locale := RepereVaisseau.direction_soleil_locale(repere, soleil_monde)
		assert_float(Vector3.UP.dot(locale)).is_equal_approx(angle_monde, EPSILON)
