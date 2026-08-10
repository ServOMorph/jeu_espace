extends Camera3D

## Camera libre du monde lointain (echelle planetaire, WorldScale : 1 unite = 100 km),
## reservee a scenes/test_env.tscn. Independante du vaisseau : explore Terre/Lune/Soleil
## sans etre liee a l'orbite ni synchronisee par vue_orbitale.gd. Vit dans LointainViewport
## (World3D propre a ce sous-viewport), rendue plein ecran via FondLointain des lors
## qu'aucune camera du monde proche n'est active (cf. selecteur_camera.gd).
##
## Pas de _input() ici : LointainViewport n'a pas de SubViewportContainer qui lui
## relaie les evenements (handle_input_locally = false, delibere pour un simple
## rendu hors-ecran compose manuellement) — un _input() sur un noeud qui y vit
## n'est donc jamais appele. Le clavier fonctionne quand meme (_process interroge
## Input.is_key_pressed en polling, hors circuit d'evenements), mais la souris a
## besoin d'un relais explicite : selecteur_camera.gd, qui vit dans l'arbre
## principal, transmet les evenements via appliquer_delta_souris/gerer_clic.

@export var vitesse := 15.0
@export var vitesse_rapide := 150.0
@export var sensibilite := 0.003
## Desactive quand une scene externe pilote l'activation (cf. selecteur_camera.gd).
@export var actif_au_demarrage := true

var _vol: VolLibre
var _capture := false
var _actif := false


func _ready() -> void:
	near = 0.1
	far = 12000.0
	_vol = VolLibre.new(vitesse, vitesse_rapide)
	var rayon := WorldScale.rayon_terre_unites()
	position = Vector3(rayon * 2.2, rayon * 1.1, rayon * 2.2)
	look_at(Vector3.ZERO, Vector3.UP)
	if actif_au_demarrage:
		activer()


func activer() -> void:
	_actif = true
	current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_capture = true


func desactiver() -> void:
	_actif = false
	_capture = false
	current = false


func appliquer_delta_souris(relative: Vector2) -> void:
	if not _actif or not _capture:
		return
	rotate_y(-relative.x * sensibilite)
	rotate_object_local(Vector3.RIGHT, -relative.y * sensibilite)


func gerer_clic_recapture() -> void:
	if _actif and not _capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_capture = true


func gerer_relachement_capture() -> void:
	if _actif and _capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		_capture = false


func _process(delta: float) -> void:
	if not _actif:
		return
	var direction := Vector3.ZERO
	if Input.is_key_pressed(KEY_Z) or Input.is_key_pressed(KEY_W):
		direction -= basis.z
	if Input.is_key_pressed(KEY_S):
		direction += basis.z
	if Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_A):
		direction -= basis.x
	if Input.is_key_pressed(KEY_D):
		direction += basis.x
	if Input.is_key_pressed(KEY_SPACE):
		direction += Vector3.UP
	if Input.is_key_pressed(KEY_CTRL):
		direction -= Vector3.UP

	position += _vol.deplacement(direction, Input.is_key_pressed(KEY_SHIFT), delta)
