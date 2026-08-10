extends CanvasLayer

## Menu de selection de la camera active au lancement de scenes/test_env.tscn, plus un
## bouton de retour visible dans chacune des vues. Outil de test : evite d'editer
## VueOrbitale.camera_locale_path a la main pour changer de point de vue. La bascule
## reelle en jeu (clavier, 2 lieux) reste celle de la phase 6 (lieu_manager), hors
## perimetre de ce script.
##
## Chaque choix desactive systematiquement les quatre controleurs avant d'activer le
## sien : desactiver() met aussi `Camera3D.current = false`, indispensable ici car le
## Drone vit dans un World3D separe (LointainViewport) de celui du vaisseau — rendre une
## camera "current" dans un monde ne demote pas automatiquement celle restee "current"
## dans l'autre. Sans ce nettoyage systematique, la derniere vue du monde proche (ex.
## Cockpit) continue de se rendre par-dessus le fond compose quand on passe au Drone.
## Le Drone rendu "current" reprend aussi la main sur camera_lointaine_path (normalement
## pilotee par VueOrbitale) : choisir une autre vue la reactive explicitement.

@export var vue_orbitale_path: NodePath
@export var camera_lointaine_path: NodePath

@export var fond_path: NodePath
@export var barre_retour_path: NodePath
@export var indice_observatoire_path: NodePath

@export var bouton_vaisseau_path: NodePath
@export var bouton_observatoire_path: NodePath
@export var bouton_cockpit_path: NodePath
@export var bouton_drone_path: NodePath
@export var bouton_retour_path: NodePath

@export var camera_vaisseau_path: NodePath
@export var controleur_vaisseau_path: NodePath

@export var camera_observatoire_path: NodePath
@export var controleur_observatoire_path: NodePath

@export var camera_cockpit_path: NodePath
@export var controleur_cockpit_path: NodePath

@export var camera_drone_path: NodePath
@export var controleur_drone_path: NodePath


func _ready() -> void:
	_desactiver_tous()
	_afficher_selection()
	(get_node(bouton_vaisseau_path) as Button).pressed.connect(
		_choisir.bind(controleur_vaisseau_path, camera_vaisseau_path)
	)
	(get_node(bouton_observatoire_path) as Button).pressed.connect(
		_choisir.bind(controleur_observatoire_path, camera_observatoire_path)
	)
	(get_node(bouton_cockpit_path) as Button).pressed.connect(
		_choisir.bind(controleur_cockpit_path, camera_cockpit_path)
	)
	(get_node(bouton_drone_path) as Button).pressed.connect(
		_choisir.bind(controleur_drone_path, camera_drone_path)
	)
	(get_node(bouton_retour_path) as Button).pressed.connect(_retour_menu)


## F1 ramene au menu depuis n'importe quelle vue, meme souris capturee (pas besoin
## d'Echap prealable ni de clic — un raccourci clavier n'est pas affecte par le mode
## de la souris).
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F1:
		_retour_menu()


func _desactiver_tous() -> void:
	for chemin in [
		controleur_vaisseau_path, controleur_observatoire_path,
		controleur_cockpit_path, controleur_drone_path
	]:
		var controleur := get_node_or_null(chemin)
		if controleur != null:
			controleur.desactiver()


func _choisir(controleur_path: NodePath, camera_path: NodePath) -> void:
	_desactiver_tous()
	var vue_orbitale := get_node_or_null(vue_orbitale_path)
	if vue_orbitale != null:
		vue_orbitale.camera_locale_path = camera_path
	# Rend la main a camera_lointaine_path : le Drone (s'il etait actif) l'avait remplacee
	# comme camera "current" du monde lointain. Sans reset, le fond composite resterait
	# fige sur le dernier point de vue du Drone au lieu de suivre a nouveau l'orbite.
	var cam_lointaine := get_node_or_null(camera_lointaine_path) as Camera3D
	if cam_lointaine != null:
		cam_lointaine.current = true
	var controleur := get_node_or_null(controleur_path)
	if controleur != null:
		controleur.activer()
	get_node(indice_observatoire_path).visible = controleur_path == controleur_observatoire_path
	_afficher_jeu()


func _retour_menu() -> void:
	_desactiver_tous()
	_afficher_selection()


func _afficher_selection() -> void:
	get_node(fond_path).visible = true
	get_node(barre_retour_path).visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _afficher_jeu() -> void:
	get_node(fond_path).visible = false
	get_node(barre_retour_path).visible = true
