extends Control

## Dessin vectoriel d'un ecran holographique de tableau de bord : cadre net, glow, palette
## sombre. Rendu dans un SubViewport (cf. scenes/ecran_holo.tscn), applique en texture sur
## le quad 3D correspondant dans scenes/cockpit.tscn. Contenu statique (dessine une fois),
## conforme a la contrainte d'instruments sans donnee live du reste du cockpit.

const FOND := Color(0.03, 0.045, 0.06, 1.0)
const EPAISSEUR_CADRE := 3.0
const LONGUEUR_COIN := 18.0

@export var libelle := "ECRAN"
@export var couleur_accent := Color(0.30, 0.85, 0.88)


func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	draw_rect(rect, FOND)
	_dessiner_glow(rect)
	draw_rect(rect, couleur_accent, false, EPAISSEUR_CADRE)
	_dessiner_coins(rect)
	_dessiner_libelle(rect)


func _dessiner_glow(rect: Rect2) -> void:
	var couches := 4
	for i in couches:
		var t := float(i) / float(couches)
		var marge := -6.0 - t * 10.0
		var alpha := 0.22 * (1.0 - t)
		draw_rect(rect.grow(marge), Color(couleur_accent, alpha), false, 2.0)


func _dessiner_coins(rect: Rect2) -> void:
	var signes := [Vector2(1, 1), Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1)]
	for signe in signes:
		var coin := Vector2(
			rect.position.x if signe.x < 0.0 else rect.end.x,
			rect.position.y if signe.y < 0.0 else rect.end.y
		)
		draw_line(coin, coin + Vector2(-signe.x * LONGUEUR_COIN, 0.0), couleur_accent, EPAISSEUR_CADRE)
		draw_line(coin, coin + Vector2(0.0, -signe.y * LONGUEUR_COIN), couleur_accent, EPAISSEUR_CADRE)


func _dessiner_libelle(rect: Rect2) -> void:
	var police := ThemeDB.fallback_font
	var taille := 26
	var dimensions := police.get_string_size(libelle, HORIZONTAL_ALIGNMENT_LEFT, -1, taille)
	var origine := rect.get_center() - dimensions * 0.5 + Vector2(0.0, dimensions.y * 0.35)
	draw_string(police, origine, libelle, HORIZONTAL_ALIGNMENT_LEFT, -1, taille, couleur_accent)
