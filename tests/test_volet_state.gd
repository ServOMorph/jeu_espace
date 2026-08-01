extends GdUnitTestSuite

const EPSILON := 0.0001


func test_demarre_ferme() -> void:
	var volet := VoletState.new()
	assert_int(volet.etat).is_equal(VoletState.Etat.FERME)
	assert_float(volet.progression).is_equal_approx(0.0, EPSILON)


func test_toggle_depuis_ferme_lance_l_ouverture() -> void:
	var volet := VoletState.new()
	volet.toggle()
	assert_int(volet.etat).is_equal(VoletState.Etat.EN_OUVERTURE)


func test_ouverture_complete() -> void:
	var volet := VoletState.new(2.0)
	volet.toggle()
	volet.avancer(2.0)
	assert_int(volet.etat).is_equal(VoletState.Etat.OUVERT)
	assert_float(volet.progression).is_equal_approx(1.0, EPSILON)


func test_fermeture_complete_apres_ouverture() -> void:
	var volet := VoletState.new(2.0)
	volet.toggle()
	volet.avancer(2.0)
	volet.toggle()
	volet.avancer(2.0)
	assert_int(volet.etat).is_equal(VoletState.Etat.FERME)
	assert_float(volet.progression).is_equal_approx(0.0, EPSILON)


func test_avancer_ne_fait_rien_a_l_etat_ferme() -> void:
	var volet := VoletState.new()
	volet.avancer(10.0)
	assert_int(volet.etat).is_equal(VoletState.Etat.FERME)
	assert_float(volet.progression).is_equal_approx(0.0, EPSILON)


func test_avancer_ne_fait_rien_a_l_etat_ouvert() -> void:
	var volet := VoletState.new(1.0)
	volet.toggle()
	volet.avancer(1.0)
	volet.avancer(5.0)
	assert_int(volet.etat).is_equal(VoletState.Etat.OUVERT)
	assert_float(volet.progression).is_equal_approx(1.0, EPSILON)


func test_inversion_en_cours_d_ouverture_repart_de_la_progression_courante() -> void:
	var volet := VoletState.new(4.0)
	volet.toggle()
	volet.avancer(1.0)
	var progression_avant := volet.progression
	volet.toggle()
	assert_int(volet.etat).is_equal(VoletState.Etat.EN_FERMETURE)
	assert_float(volet.progression).is_equal_approx(progression_avant, EPSILON)


func test_inversion_en_cours_de_fermeture_repart_de_la_progression_courante() -> void:
	var volet := VoletState.new(2.0)
	volet.toggle()
	volet.avancer(2.0)
	volet.toggle()
	volet.avancer(1.0)
	var progression_avant := volet.progression
	volet.toggle()
	assert_int(volet.etat).is_equal(VoletState.Etat.EN_OUVERTURE)
	assert_float(volet.progression).is_equal_approx(progression_avant, EPSILON)


func test_progression_ne_depasse_jamais_les_bornes() -> void:
	var volet := VoletState.new(1.0)
	volet.toggle()
	volet.avancer(100.0)
	assert_float(volet.progression).is_equal_approx(1.0, EPSILON)


func test_avancer_delta_nul_est_idempotent() -> void:
	var volet := VoletState.new(2.0)
	volet.toggle()
	volet.avancer(1.0)
	var progression_avant := volet.progression
	for i in 5:
		volet.avancer(0.0)
	assert_float(volet.progression).is_equal_approx(progression_avant, EPSILON)
	assert_int(volet.etat).is_equal(VoletState.Etat.EN_OUVERTURE)
