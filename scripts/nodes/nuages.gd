extends MeshInstance3D

## Periode de rotation propre de la couche nuageuse, derivee du temps simule
## (meme source que scripts/nodes/terre.gd) : les nuages doivent suivre le
## multiplicateur x1/x10/x60 et les pauses, pas defiler en temps reel.
## Superieure a SunDirection.PERIODE_ROTATION_TERRE_S pour un drift relatif
## lent par rapport au sol, plutot qu'un decalage plaque sur la rotation
## terrestre ou une derive plus rapide qu'elle.
const PERIODE_ROTATION_NUAGES_S := 16200.0

var _horloge: Node


func _ready() -> void:
	var sphere := mesh as SphereMesh
	sphere.radius = WorldScale.rayon_nuages_unites()
	sphere.height = sphere.radius * 2.0


func _process(_delta: float) -> void:
	if _horloge == null:
		_horloge = get_tree().get_first_node_in_group("horloge")
		if _horloge == null:
			return
	basis = SunDirection.rotation_terre(_horloge.temps_simule(), PERIODE_ROTATION_NUAGES_S)
