varying vec2 vUv;
varying vec3 vPosition;

uniform sampler2D t_DisplacementMap;

void main() {
  #include <uv_vertex>

  #include <begin_vertex>
  // ###### Displacement ######
  transformed *= 1.0 - texture2D(t_DisplacementMap, uv * 2.0).xyz * 0.06;

  #include <project_vertex>

  vUv = uv * 2.0;
  vPosition = transformed;
}
