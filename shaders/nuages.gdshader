shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_disabled;

// Le masque livre par design est un jpg en niveaux de gris (pas de canal alpha
// reel) : le canal rouge sert de couverture nuageuse.
uniform sampler2D masque_nuages : source_color, filter_linear_mipmap_anisotropic;

void fragment() {
	float couverture = texture(masque_nuages, UV).r;
	ALBEDO = vec3(1.0);
	METALLIC = 0.0;
	ROUGHNESS = 1.0;
	ALPHA = couverture;
}
