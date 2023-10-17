varying vec3 vWorldPosition;
varying vec2 vUv;

uniform vec3 u_LightPosition;
uniform float u_LightIntensity;
uniform sampler2D t_Map;
uniform sampler2D t_NormalMap;
uniform vec3 u_WorldPosition;

#define LIGHT_COLOR vec3(1.0)

void main() {
  vec3 color = texture2D(t_Map, vUv).rgb;
  vec3 normal = texture2D(t_NormalMap, vUv).rgb;
  normal = normal * 2.0 - 1.0;

  float l = max(0.0, dot(normal, normalize(u_LightPosition - u_WorldPosition)));
  l *= u_LightIntensity * max(0.0, smoothstep(3.0, 0.5, length(u_LightPosition - vWorldPosition)));

  gl_FragColor = vec4(color + LIGHT_COLOR * l, 1.0);
}
