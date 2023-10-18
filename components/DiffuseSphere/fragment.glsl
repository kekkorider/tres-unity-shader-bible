varying vec3 vWorldPosition;
varying vec2 vUv;

uniform vec3 u_PointLightPosition;
uniform float u_PointLightIntensity;
uniform vec3 u_PointLightColor;
uniform sampler2D t_Map;
uniform sampler2D t_NormalMap;
uniform vec3 u_WorldPosition;

uniform vec3 u_EnvLight;
uniform float u_EnvLightIntensity;

void main() {
  vec3 color = texture2D(t_Map, vUv).rgb;
  vec3 normal = texture2D(t_NormalMap, vUv).rgb;
  normal = normal * 2.0 - 1.0;

  color += u_EnvLight * u_EnvLightIntensity;

  float l = max(0.0, dot(normal, normalize(u_PointLightPosition - u_WorldPosition)));
  l *= u_PointLightIntensity * max(0.0, smoothstep(3.0, 0.5, length(u_PointLightPosition - vWorldPosition)));

  gl_FragColor = vec4(color + u_PointLightColor * l, 1.0);
}
