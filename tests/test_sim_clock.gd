extends GdUnitTestSuite

const EPSILON := 0.0001


func test_multiplicateur_par_defaut_est_x1() -> void:
	var horloge := SimClock.new()
	assert_float(horloge.multiplicateur).is_equal_approx(SimClock.MULTIPLICATEUR_X1, EPSILON)


func test_avance_proportionnellement_au_multiplicateur() -> void:
	var horloge := SimClock.new()
	horloge.definir_multiplicateur(SimClock.MULTIPLICATEUR_X10)
	horloge.avancer(2.0)
	assert_float(horloge.temps_simule).is_equal_approx(20.0, EPSILON)


func test_delta_nul_ne_change_rien() -> void:
	var horloge := SimClock.new()
	horloge.avancer(5.0)
	var avant := horloge.temps_simule
	horloge.avancer(0.0)
	assert_float(horloge.temps_simule).is_equal_approx(avant, EPSILON)


func test_changement_multiplicateur_ne_provoque_pas_de_saut() -> void:
	var horloge := SimClock.new()
	horloge.avancer(1.0)
	var avant := horloge.temps_simule
	horloge.definir_multiplicateur(SimClock.MULTIPLICATEUR_X60)
	assert_float(horloge.temps_simule).is_equal_approx(avant, EPSILON)


func test_monotonie_apres_n_changements_de_multiplicateur() -> void:
	var horloge := SimClock.new()
	var multiplicateurs := [
		SimClock.MULTIPLICATEUR_X1, SimClock.MULTIPLICATEUR_X60,
		SimClock.MULTIPLICATEUR_X10, SimClock.MULTIPLICATEUR_X1
	]
	var precedent := horloge.temps_simule
	for m in multiplicateurs:
		horloge.definir_multiplicateur(m)
		horloge.avancer(0.5)
		assert_float(horloge.temps_simule).is_greater(precedent)
		precedent = horloge.temps_simule


func test_absence_de_derive_sur_accumulation_repetee() -> void:
	var horloge := SimClock.new()
	horloge.definir_multiplicateur(SimClock.MULTIPLICATEUR_X60)
	for i in range(600):
		horloge.avancer(1.0 / 60.0)
	assert_float(horloge.temps_simule).is_equal_approx(600.0, 0.01)
