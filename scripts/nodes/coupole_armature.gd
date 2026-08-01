class_name CoupoleArmature
extends Node3D

## Armature de la coupole (montants + cerclages), generee proceduralement depuis les
## proportions de DESIGN/vaisseau/proportions.md. Modelisee comme une demi-sphere vraie :
## equateur (base) a HAUTEUR_SOMMET - RAYON, sommet au pole. Le document source ne chiffre
## pas les trois hauteurs de cerclage independamment du rayon de la coupole ; le cerclage
## "mi-hauteur" est donc interprete comme le point median geometrique de l'arc plutot que
## reproduit litteralement.
##
## RAYON/HAUTEUR_SOMMET/HAUTEUR_BASE/NB_MONTANTS font office de source unique pour toute
## geometrie devant s'aligner sur les baies de la coupole (cf. volet_panneaux.gd).

const RAYON := 0.15
const HAUTEUR_SOMMET := 0.30
const HAUTEUR_BASE := HAUTEUR_SOMMET - RAYON
const NB_MONTANTS := 12
const EPAISSEUR := 0.004

@export var materiau: Material


func _ready() -> void:
	_construire_montants()
	_construire_cerclages()


func _rayon_a_hauteur(hauteur: float) -> float:
	var delta := hauteur - HAUTEUR_BASE
	return sqrt(maxf(RAYON * RAYON - delta * delta, 0.0))


func _construire_cerclages() -> void:
	var hauteur_mi := (HAUTEUR_BASE + HAUTEUR_SOMMET) / 2.0
	for hauteur in [HAUTEUR_BASE, hauteur_mi]:
		var rayon_cercle := _rayon_a_hauteur(hauteur)
		var anneau := MeshInstance3D.new()
		var torus := TorusMesh.new()
		torus.inner_radius = maxf(rayon_cercle - EPAISSEUR, 0.001)
		torus.outer_radius = rayon_cercle + EPAISSEUR
		anneau.mesh = torus
		anneau.position = Vector3(0.0, 0.0, hauteur)
		anneau.rotate_x(PI / 2.0)
		_appliquer_materiau(anneau)
		add_child(anneau)


func _construire_montants() -> void:
	var sommet := Vector3(0.0, 0.0, HAUTEUR_SOMMET)
	for i in NB_MONTANTS:
		var angle := i * TAU / NB_MONTANTS
		var base := Vector3(RAYON * cos(angle), RAYON * sin(angle), HAUTEUR_BASE)
		_placer_segment(base, sommet)


func _placer_segment(a: Vector3, b: Vector3) -> void:
	var segment := MeshInstance3D.new()
	var cylindre := CylinderMesh.new()
	cylindre.top_radius = EPAISSEUR
	cylindre.bottom_radius = EPAISSEUR
	cylindre.height = a.distance_to(b)
	segment.mesh = cylindre
	var milieu := (a + b) / 2.0
	var direction := (b - a).normalized()
	var reference := Vector3.UP if absf(direction.dot(Vector3.UP)) < 0.999 else Vector3.RIGHT
	segment.look_at_from_position(milieu, milieu + direction, reference)
	segment.rotate_object_local(Vector3.RIGHT, PI / 2.0)
	_appliquer_materiau(segment)
	add_child(segment)


func _appliquer_materiau(instance: MeshInstance3D) -> void:
	if materiau != null:
		instance.set_surface_override_material(0, materiau)
