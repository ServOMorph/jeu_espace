extends Node3D

## Le noeud porte l'orientation : la lumiere emet vers -Z local, le disque est place
## en +Z local, c'est-a-dire du cote d'ou vient la lumiere.


func _ready() -> void:
	var disque := $Disque as MeshInstance3D
	var sphere := disque.mesh as SphereMesh
	sphere.radius = WorldScale.rayon_soleil_unites()
	sphere.height = sphere.radius * 2.0
	disque.position = Vector3(0.0, 0.0, WorldScale.SOLEIL_DISTANCE_UNITES)
