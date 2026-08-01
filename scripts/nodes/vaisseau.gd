extends Node3D

## Met le modele, construit en unites relatives (L = 1.0), a l'echelle metrique.
## Le vaisseau reste immobile a l'origine du repere local : son deplacement orbital est
## porte par la camera lointaine (cf. scripts/core/repere_vaisseau.gd).


func _ready() -> void:
	scale = Vector3.ONE * RepereVaisseau.echelle_modele_metres()
