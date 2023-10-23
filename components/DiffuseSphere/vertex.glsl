varying vec2 vUv;
varying vec2 vUv2;
varying vec3 vWorldPosition;

uniform sampler2D t_DisplacementMap;
uniform float u_Displacement;

void main() {
  #include <uv_vertex>

  #include <begin_vertex>

  transformed *= 1.0 - texture2D(t_DisplacementMap, uv * 2.0).xyz * u_Displacement;

  #include <project_vertex>

  vUv = uv * 2.0;
  vUv2 = uv2 * 2.0;

  vWorldPosition = (modelMatrix * vec4(transformed, 1.0)).xyz;
}
