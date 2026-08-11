extends Node3D

## Cablage : construit le materiau du quad d'ecran a partir de la texture rendue par le
## SubViewport enfant (contenu dessine par scripts/nodes/carte_contenu.gd, alimente en
## continu par scripts/nodes/carte_map_driver.gd). Aucune decision graphique ici.

@export var taille_quad := Vector2(0.024, 0.016)


func _ready() -> void:
	var viewport := $SubViewport as SubViewport
	var quad := $Quad as MeshInstance3D
	(quad.mesh as QuadMesh).size = taille_quad

	var materiau := StandardMaterial3D.new()
	materiau.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	materiau.albedo_texture = viewport.get_texture()
	materiau.emission_enabled = true
	materiau.emission_texture = viewport.get_texture()
	materiau.emission_energy_multiplier = 1.2
	quad.material_override = materiau
