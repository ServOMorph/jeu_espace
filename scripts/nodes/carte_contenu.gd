extends Control

## Dessin de l'overlay plein cadre MAP : disque radar, marqueur du vaisseau au centre
## (avant fixe, en haut), icones de la Terre, de la Lune et du Soleil aux positions
## fournies par scripts/core/cockpit_map.gd (repere.basis.y = avant du vaisseau, projete
## au centre du disque ; l'arriere est au bord).

const FOND := Color(0.02, 0.03, 0.05, 0.94)
const COULEUR_DISQUE := Color(0.06, 0.09, 0.13, 1.0)
const COULEUR_CADRE := Color(0.30, 0.85, 0.88, 0.7)
const COULEUR_VAISSEAU := Color(0.30, 0.85, 0.88, 1.0)
const RAYON_ICONE := 8.0

const COULEURS := {
	"terre": Color(0.35, 0.62, 0.95),
	"lune": Color(0.78, 0.78, 0.8),
	"soleil": Color(0.96, 0.8, 0.25),
}
const LIBELLES := {"terre": "TERRE", "lune": "LUNE", "soleil": "SOLEIL"}

## Positions [-1,1]x[-1,1], cf. CockpitMap.positions_carte. Vide tant qu'aucune donnee
## n'a ete poussee par carte_overlay.gd.
var positions: Dictionary = {}


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	draw_rect(rect, FOND)
	var centre := size * 0.5
	var rayon_carte := minf(size.x, size.y) * 0.42
	draw_circle(centre, rayon_carte, COULEUR_DISQUE)
	draw_arc(centre, rayon_carte, 0.0, TAU, 96, COULEUR_CADRE, 2.0)
	draw_line(
		centre - Vector2(0.0, rayon_carte), centre - Vector2(0.0, rayon_carte * 1.08),
		COULEUR_CADRE, 2.0
	)
	draw_circle(centre, 5.0, COULEUR_VAISSEAU)
	for cle in positions:
		var p: Vector2 = positions[cle]
		var point := centre + p * rayon_carte
		var couleur: Color = COULEURS.get(cle, Color.WHITE)
		draw_circle(point, RAYON_ICONE, couleur)
		draw_string(
			ThemeDB.fallback_font, point + Vector2(RAYON_ICONE + 6.0, 5.0),
			LIBELLES.get(cle, String(cle).to_upper()), HORIZONTAL_ALIGNMENT_LEFT, -1, 18, couleur
		)
