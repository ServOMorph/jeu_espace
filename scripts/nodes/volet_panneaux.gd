extends Node3D

## Cablage + generation procedurale des 12 panneaux du volet blinde (cf.
## DESIGN/interieur/notes.md). Un panneau = une baie de l'armature. Progression 0 = panneau
## couvrant toute la baie (ferme), progression 1 = panneau comprime dans l'anneau de
## logement au niveau du cerclage de base (ouvert). La progression vient de
## scripts/core/volet_state.gd ; aucune decision d'etat ici.

const SEGMENTS_HAUTEUR := 4

@export var materiau: Material

var _etat: VoletState
var _panneaux: Array[MeshInstance3D] = []


func _ready() -> void:
	_etat = VoletState.new()
	for i in CoupoleArmature.NB_MONTANTS:
		var panneau := MeshInstance3D.new()
		if materiau != null:
			panneau.material_override = materiau
		add_child(panneau)
		_panneaux.append(panneau)
	_reconstruire()


func _process(delta: float) -> void:
	if _etat.etat == VoletState.Etat.FERME or _etat.etat == VoletState.Etat.OUVERT:
		return
	_etat.avancer(delta)
	_reconstruire()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_volet"):
		_etat.toggle()


func _rayon_a_hauteur(hauteur: float) -> float:
	var delta := hauteur - CoupoleArmature.HAUTEUR_BASE
	return sqrt(maxf(CoupoleArmature.RAYON * CoupoleArmature.RAYON - delta * delta, 0.0))


func _reconstruire() -> void:
	var etendue := CoupoleArmature.HAUTEUR_SOMMET - CoupoleArmature.HAUTEUR_BASE
	for i in CoupoleArmature.NB_MONTANTS:
		var angle_debut := i * TAU / CoupoleArmature.NB_MONTANTS
		var angle_fin := (i + 1) * TAU / CoupoleArmature.NB_MONTANTS
		_panneaux[i].mesh = _construire_panneau(angle_debut, angle_fin, etendue)


func _construire_panneau(angle_debut: float, angle_fin: float, etendue: float) -> ArrayMesh:
	var outil := SurfaceTool.new()
	outil.begin(Mesh.PRIMITIVE_TRIANGLES)
	var normale := Vector3(
		cos((angle_debut + angle_fin) / 2.0), sin((angle_debut + angle_fin) / 2.0), 0.0
	)
	for s in SEGMENTS_HAUTEUR:
		var f_bas: float = float(s) / float(SEGMENTS_HAUTEUR)
		var f_haut: float = float(s + 1) / float(SEGMENTS_HAUTEUR)
		var reduction := 1.0 - _etat.progression
		var h_bas := CoupoleArmature.HAUTEUR_BASE + f_bas * reduction * etendue
		var h_haut := CoupoleArmature.HAUTEUR_BASE + f_haut * reduction * etendue
		var r_bas := _rayon_a_hauteur(h_bas)
		var r_haut := _rayon_a_hauteur(h_haut)
		var a := Vector3(r_bas * cos(angle_debut), r_bas * sin(angle_debut), h_bas)
		var b := Vector3(r_bas * cos(angle_fin), r_bas * sin(angle_fin), h_bas)
		var c := Vector3(r_haut * cos(angle_fin), r_haut * sin(angle_fin), h_haut)
		var d := Vector3(r_haut * cos(angle_debut), r_haut * sin(angle_debut), h_haut)
		for point in [a, b, c, a, c, d]:
			outil.set_normal(normale)
			outil.add_vertex(point)
	return outil.commit()
