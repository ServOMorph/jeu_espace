shader_type spatial;
render_mode blend_add, depth_draw_never, cull_front, unshaded;

// Halo atmospherique : sphere legerement plus grande que la Terre, glow de bord
// (Fresnel) pour rendre l'epaisseur d'atmosphere visible par la tranche. cull_front
// laisse voir la face interne de la sphere : le halo reste visible en silhouette
// complete depuis l'exterieur, sans que l'hemisphere proche de la camera ne le masque.
//
// Deux termes de Fresnel superposes (liseret net + halo diffus plus large) au lieu
// d'un seul pow() : un vrai limbe atmospherique a un coeur brillant et une extension
// plus faible, pas une seule courbe de decroissance. `direction_soleil` att'enue le
// cote nuit (diffusion Rayleigh alimentee par la lumiere directe, quasi nulle sans
// elle) sans l'eteindre completement (le limbe reste visible en silhouette sur fond
// d'espace). Poussee par scripts/nodes/halo.gd, meme convention que terre.gdshader.

uniform vec3 couleur_halo : source_color = vec3(0.4, 0.6, 1.0);
uniform vec3 couleur_halo_diffus : source_color = vec3(0.3, 0.45, 0.9);
uniform float intensite : hint_range(0.0, 4.0, 0.05) = 1.5;
uniform float exposant_fresnel : hint_range(0.5, 8.0, 0.1) = 4.0;
uniform float exposant_fresnel_diffus : hint_range(0.5, 8.0, 0.1) = 2.2;
uniform vec3 direction_soleil = vec3(0.0, 0.0, 1.0);
uniform float intensite_nuit_min : hint_range(0.0, 1.0, 0.01) = 0.0;

varying vec3 normale_monde;
varying vec3 direction_vue_monde;

void vertex() {
	normale_monde = normalize(mat3(MODEL_MATRIX) * NORMAL);
	direction_vue_monde = normalize((MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz - CAMERA_POSITION_WORLD);
}

void fragment() {
	vec3 normale = normalize(normale_monde);
	float bord = 1.0 - abs(dot(normale, -normalize(direction_vue_monde)));

	float liseret = pow(bord, exposant_fresnel);
	float diffus = pow(bord, exposant_fresnel_diffus);

	float eclairement = dot(normale, normalize(direction_soleil));
	float facteur_jour = smoothstep(-0.15, 0.15, eclairement);
	float facteur_nuit = intensite_nuit_min + (1.0 - intensite_nuit_min) * facteur_jour;

	vec3 couleur = couleur_halo * liseret + couleur_halo_diffus * diffus * 0.5;
	float alpha = clamp(liseret + diffus * 0.5, 0.0, 1.0);

	ALBEDO = couleur;
	EMISSION = couleur * intensite * facteur_nuit;
	ALPHA = alpha * facteur_nuit;
}
