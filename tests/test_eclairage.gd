extends GdUnitTestSuite

const EPSILON := 0.0001
const LARGEUR := Eclairage.LARGEUR_TERMINATEUR_DEFAUT


func test_direction_vers_soleil_est_le_z_de_la_base() -> void:
	assert_vector(Eclairage.direction_vers_soleil(Basis.IDENTITY)).is_equal_approx(
		Vector3(0.0, 0.0, 1.0), Vector3.ONE * EPSILON
	)


func test_direction_vers_soleil_suit_la_rotation() -> void:
	var base := Basis(Vector3.UP, PI * 0.5)
	assert_vector(Eclairage.direction_vers_soleil(base)).is_equal_approx(
		Vector3(1.0, 0.0, 0.0), Vector3.ONE * EPSILON
	)


func test_direction_vers_soleil_est_unitaire() -> void:
	var base := Basis(Vector3(0.3, 0.8, -0.5).normalized(), 1.1).scaled(Vector3(3.0, 3.0, 3.0))
	assert_float(Eclairage.direction_vers_soleil(base).length()).is_equal_approx(1.0, EPSILON)


func test_plein_jour_et_pleine_nuit() -> void:
	var soleil := Vector3(0.0, 0.0, 1.0)
	assert_float(Eclairage.facteur_jour(soleil, soleil, LARGEUR)).is_equal_approx(1.0, EPSILON)
	assert_float(Eclairage.facteur_jour(-soleil, soleil, LARGEUR)).is_equal_approx(0.0, EPSILON)


func test_terminateur_a_mi_valeur_a_incidence_nulle() -> void:
	var jour := Eclairage.facteur_jour(Vector3(1.0, 0.0, 0.0), Vector3(0.0, 0.0, 1.0), LARGEUR)
	assert_float(jour).is_equal_approx(0.5, EPSILON)


## La transition doit etre progressive : dans la bande du terminateur, le facteur
## prend des valeurs strictement intermediaires et croissantes avec l'incidence.
func test_transition_monotone_et_progressive() -> void:
	var soleil := Vector3(0.0, 0.0, 1.0)
	var precedent := -1.0
	for i in range(21):
		var incidence := lerpf(-LARGEUR, LARGEUR, float(i) / 20.0)
		var normale := Vector3(sqrt(maxf(0.0, 1.0 - incidence * incidence)), 0.0, incidence)
		var jour := Eclairage.facteur_jour(normale, soleil, LARGEUR)
		assert_float(jour).is_greater_equal(precedent)
		precedent = jour
	var interieur := Eclairage.facteur_jour(
		Vector3(sqrt(1.0 - 0.01 * 0.01), 0.0, 0.01), soleil, LARGEUR
	)
	assert_float(interieur).is_between(0.0 + EPSILON, 1.0 - EPSILON)


## Hors de la bande, le facteur est sature : aucune lumiere nocturne cote jour.
func test_saturation_hors_de_la_bande() -> void:
	var soleil := Vector3(0.0, 0.0, 1.0)
	var au_dela := LARGEUR * 1.5
	var normale_jour := Vector3(sqrt(1.0 - au_dela * au_dela), 0.0, au_dela)
	var normale_nuit := Vector3(sqrt(1.0 - au_dela * au_dela), 0.0, -au_dela)
	assert_float(Eclairage.facteur_jour(normale_jour, soleil, LARGEUR)).is_equal_approx(1.0, EPSILON)
	assert_float(Eclairage.facteur_jour(normale_nuit, soleil, LARGEUR)).is_equal_approx(0.0, EPSILON)


func test_largeur_plus_grande_elargit_la_transition() -> void:
	var soleil := Vector3(0.0, 0.0, 1.0)
	var incidence := 0.2
	var normale := Vector3(sqrt(1.0 - incidence * incidence), 0.0, incidence)
	var etroit := Eclairage.facteur_jour(normale, soleil, 0.1)
	var large := Eclairage.facteur_jour(normale, soleil, 0.4)
	assert_float(etroit).is_equal_approx(1.0, EPSILON)
	assert_float(large).is_less(1.0 - EPSILON)
	assert_float(large).is_greater(0.5)


func test_facteur_independant_de_la_norme_des_vecteurs() -> void:
	var normale := Vector3(0.4, 0.6, 0.7)
	var soleil := Vector3(0.0, 0.1, 1.0)
	var reference := Eclairage.facteur_jour(normale, soleil, LARGEUR)
	assert_float(Eclairage.facteur_jour(normale * 12.0, soleil * 0.03, LARGEUR)).is_equal_approx(
		reference, EPSILON
	)


func test_facteur_nuit_est_le_complement() -> void:
	var soleil := Vector3(0.0, 0.0, 1.0)
	for incidence in [-1.0, -0.1, 0.0, 0.05, 1.0]:
		var normale := Vector3(sqrt(maxf(0.0, 1.0 - incidence * incidence)), 0.0, incidence)
		var somme := (
			Eclairage.facteur_jour(normale, soleil, LARGEUR)
			+ Eclairage.facteur_nuit(normale, soleil, LARGEUR)
		)
		assert_float(somme).is_equal_approx(1.0, EPSILON)


func test_largeur_par_defaut_utilisee_sans_argument() -> void:
	var normale := Vector3(1.0, 0.0, 0.0)
	var soleil := Vector3(0.0, 0.0, 1.0)
	assert_float(Eclairage.facteur_jour(normale, soleil)).is_equal_approx(
		Eclairage.facteur_jour(normale, soleil, LARGEUR), EPSILON
	)
	assert_float(Eclairage.facteur_nuit(normale, soleil)).is_equal_approx(
		Eclairage.facteur_nuit(normale, soleil, LARGEUR), EPSILON
	)
