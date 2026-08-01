extends GdUnitTestSuite


const EPSILON := 0.0001
const LARGEUR := Eclairage.LARGEUR_TERMINATEUR_DEFAUT
const RAYON_TERRE := 63.71
const RAYON_ORBITE := 67.71


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


func test_eclipse_pleine_lumiere_cote_soleil() -> void:
	var soleil := Vector3(0.0, 0.0, 1.0)
	var position := Vector3(0.0, 0.0, RAYON_ORBITE)
	assert_float(Eclairage.facteur_eclipse(position, soleil, RAYON_TERRE)).is_equal_approx(
		1.0, EPSILON
	)


## Meme rasant sous la surface, le cote jour ne doit jamais tomber dans l'ombre.
func test_eclipse_cote_soleil_jamais_dans_l_ombre() -> void:
	var soleil := Vector3(0.0, 0.0, 1.0)
	for hauteur in [0.01, 5.0, 40.0, RAYON_ORBITE]:
		var reste := sqrt(maxf(RAYON_ORBITE * RAYON_ORBITE - hauteur * hauteur, 0.0))
		var position := Vector3(reste, 0.0, hauteur)
		assert_float(Eclairage.facteur_eclipse(position, soleil, RAYON_TERRE)).is_equal_approx(
			1.0, EPSILON
		)


func test_eclipse_totale_dans_l_axe_de_l_ombre() -> void:
	var soleil := Vector3(0.0, 0.0, 1.0)
	var position := Vector3(0.0, 0.0, -RAYON_ORBITE)
	assert_float(Eclairage.facteur_eclipse(position, soleil, RAYON_TERRE)).is_equal_approx(
		0.0, EPSILON
	)


## Derriere la Terre mais hors du cylindre d'ombre : le vaisseau reste eclaire.
func test_eclipse_hors_du_cylindre_reste_eclaire() -> void:
	var soleil := Vector3(0.0, 0.0, 1.0)
	var position := Vector3(RAYON_TERRE + 5.0, 0.0, -30.0)
	assert_float(Eclairage.facteur_eclipse(position, soleil, RAYON_TERRE)).is_equal_approx(
		1.0, EPSILON
	)


func test_eclipse_transition_monotone_sur_le_bord() -> void:
	var soleil := Vector3(0.0, 0.0, 1.0)
	var precedent := -1.0
	for i in range(21):
		var distance := lerpf(RAYON_TERRE - 2.0, RAYON_TERRE + 2.0, float(i) / 20.0)
		var facteur := Eclairage.facteur_eclipse(Vector3(distance, 0.0, -40.0), soleil, RAYON_TERRE)
		assert_float(facteur).is_greater_equal(precedent)
		precedent = facteur


func test_eclipse_penombre_strictement_intermediaire() -> void:
	var soleil := Vector3(0.0, 0.0, 1.0)
	var facteur := Eclairage.facteur_eclipse(Vector3(RAYON_TERRE, 0.0, -40.0), soleil, RAYON_TERRE)
	assert_float(facteur).is_between(0.0 + EPSILON, 1.0 - EPSILON)


func test_eclipse_independante_de_la_norme_du_soleil() -> void:
	var position := Vector3(10.0, 0.0, -RAYON_ORBITE)
	var reference := Eclairage.facteur_eclipse(position, Vector3(0.0, 0.0, 1.0), RAYON_TERRE)
	assert_float(
		Eclairage.facteur_eclipse(position, Vector3(0.0, 0.0, 42.0), RAYON_TERRE)
	).is_equal_approx(reference, EPSILON)


## Exigence du gate phase 3 : sur une orbite complete, le vaisseau doit connaitre une
## portion pleinement eclairee et une portion pleinement dans l'ombre.
func test_eclipse_alterne_sur_une_orbite_complete() -> void:
	var soleil := Vector3(-0.642788, 0.0, 0.766044)
	var inclinaison := deg_to_rad(51.6)
	var orbite := Orbit.new(
		RAYON_ORBITE, 5400.0, inclinaison, Orbit.phase_pour_direction(soleil, inclinaison)
	)
	var maximum := 0.0
	var minimum := 1.0
	for i in 200:
		var facteur := Eclairage.facteur_eclipse(
			orbite.position_at(orbite.periode_s * i / 200.0), soleil, RAYON_TERRE
		)
		maximum = maxf(maximum, facteur)
		minimum = minf(minimum, facteur)
	assert_float(maximum).is_equal_approx(1.0, EPSILON)
	assert_float(minimum).is_equal_approx(0.0, EPSILON)


func test_largeur_par_defaut_utilisee_sans_argument() -> void:
	var normale := Vector3(1.0, 0.0, 0.0)
	var soleil := Vector3(0.0, 0.0, 1.0)
	assert_float(Eclairage.facteur_jour(normale, soleil)).is_equal_approx(
		Eclairage.facteur_jour(normale, soleil, LARGEUR), EPSILON
	)
	assert_float(Eclairage.facteur_nuit(normale, soleil)).is_equal_approx(
		Eclairage.facteur_nuit(normale, soleil, LARGEUR), EPSILON
	)
