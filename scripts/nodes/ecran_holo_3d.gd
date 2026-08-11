extends Node3D

## Cablage : construit le materiau du quad d'ecran a partir de la texture rendue par le
## SubViewport enfant (contenu dessine par scripts/nodes/ecran_holo.gd). Aucune decision
## graphique ici, seulement la connexion contenu 2D -> texture -> materiau 3D.

@export var libelle := "ECRAN":
	set(value):
		libelle = value
		if _contenu != null:
			_contenu.libelle = value
			_contenu.queue_redraw()

@export var couleur_accent := Color(0.30, 0.85, 0.88):
	set(value):
		couleur_accent = value
		if _contenu != null:
			_contenu.couleur_accent = value
			_contenu.queue_redraw()

@export var taille_quad := Vector2(0.018, 0.014)

var _contenu: Control


func _ready() -> void:
	var viewport := $SubViewport as SubViewport
	_contenu = $SubViewport/Contenu as Control
	_contenu.libelle = libelle
	_contenu.couleur_accent = couleur_accent

	var quad := $Quad as MeshInstance3D
	(quad.mesh as QuadMesh).size = taille_quad

	var materiau := StandardMaterial3D.new()
	materiau.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	materiau.albedo_texture = viewport.get_texture()
	materiau.emission_enabled = true
	materiau.emission_texture = viewport.get_texture()
	materiau.emission_energy_multiplier = 1.2
	quad.material_override = materiau
