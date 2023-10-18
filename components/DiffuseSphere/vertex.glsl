varying vec2 vUv;
varying vec3 vWorldPosition;

uniform sampler2D t_DisplacementMap;

void main() {
  #include <uv_vertex>

  #include <begin_vertex>

  transformed *= 1.0 - texture2D(t_DisplacementMap, uv * 2.0).xyz * 0.06;

  #include <project_vertex>

  vUv = uv * 2.0;
  vWorldPosition = (modelMatrix * vec4(transformed, 1.0)).xyz;
}
