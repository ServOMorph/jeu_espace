shader_type spatial;

// Melange jour/nuit de la Terre. Le cote eclaire recoit l'albedo diurne et
// l'eclairage direct du DirectionalLight3D ; le cote sombre recoit les lumieres
// urbaines en emission, ponderees par le complement du facteur jour.
// `direction_soleil` est une direction unitaire en espace monde, pointant de la
// Terre vers le Soleil. Elle est poussee par scripts/nodes/terre.gd.

uniform sampler2D albedo_jour : source_color, filter_linear_mipmap_anisotropic;
uniform sampler2D lumieres_nuit : source_color, filter_linear_mipmap_anisotropic;
uniform vec3 direction_soleil = vec3(0.0, 0.0, 1.0);
uniform float largeur_terminateur : hint_range(0.001, 0.5, 0.001) = 0.15;
uniform float intensite_nuit : hint_range(0.0, 4.0, 0.05) = 1.0;

varying vec3 normale_monde;

void vertex() {
	normale_monde = normalize(mat3(MODEL_MATRIX) * NORMAL);
}

void fragment() {
	float incidence = dot(normalize(normale_monde), normalize(direction_soleil));
	float jour = smoothstep(-largeur_terminateur, largeur_terminateur, incidence);

	ALBEDO = texture(albedo_jour, UV).rgb;
	METALLIC = 0.0;
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
	EMISSION = texture(lumieres_nuit, UV).rgb * intensite_nuit * (1.0 - jour);
}
