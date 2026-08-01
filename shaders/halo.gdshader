shader_type spatial;
render_mode blend_add, depth_draw_never, cull_front, unshaded;

// Halo atmospherique : sphere legerement plus grande que la Terre, glow de bord
// (Fresnel) pour rendre l'epaisseur d'atmosphere visible par la tranche. cull_front
// laisse voir la face interne de la sphere : le halo reste visible en silhouette
// complete depuis l'exterieur, sans que l'hemisphere proche de la camera ne le masque.

uniform vec3 couleur_halo : source_color = vec3(0.4, 0.6, 1.0);
uniform float intensite : hint_range(0.0, 4.0, 0.05) = 1.5;
uniform float exposant_fresnel : hint_range(0.5, 8.0, 0.1) = 3.0;

varying vec3 normale_monde;
varying vec3 direction_vue_monde;

void vertex() {
	normale_monde = normalize(mat3(MODEL_MATRIX) * NORMAL);
	direction_vue_monde = normalize((MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz - CAMERA_POSITION_WORLD);
}

void fragment() {
	float fresnel = pow(1.0 - abs(dot(normalize(normale_monde), -normalize(direction_vue_monde))), exposant_fresnel);
	ALBEDO = couleur_halo;
	EMISSION = couleur_halo * intensite * fresnel;
	ALPHA = fresnel;
}
