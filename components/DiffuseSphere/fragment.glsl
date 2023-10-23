varying vec3 vWorldPosition;
varying vec2 vUv;
varying vec2 vUv2;

uniform vec3 u_PointLightPosition;
uniform float u_PointLightIntensity;
uniform vec3 u_PointLightColor;

uniform sampler2D t_Map;
uniform sampler2D t_NormalMap;
uniform vec3 u_WorldPosition;

uniform vec3 u_EnvLight;
uniform float u_EnvLightIntensity;

uniform sampler2D t_AoMap;
uniform float u_AoMapIntensity;

vec3 LambertShading(vec3 normal, vec3 lightDir, vec3 lightColor, float lightInt) {
  float l = max(0.0, dot(normal, lightDir));
  return lightColor * l * lightInt;
}

void main() {
  vec3 color = texture2D(t_Map, vUv).rgb;

  vec3 normal = texture2D(t_NormalMap, vUv).rgb;
  normal = normal * 2.0 - 1.0;

  vec3 lightDir = normalize(u_PointLightPosition - u_WorldPosition);

  vec3 diffuse = LambertShading(normal, lightDir, u_PointLightColor, u_PointLightIntensity);
  color *= diffuse;

  // AO
  float ambientOcclusion = (texture2D( t_AoMap, vUv2 ).r - 1.0) * u_AoMapIntensity + 1.0;
  color *= ambientOcclusion;

  // Env light
  color += u_EnvLight * u_EnvLightIntensity;

  // Point light
  float l = max(0.0, dot(normal, lightDir));
  l *= max(0.0, smoothstep(3.0, 0.5, length(u_PointLightPosition - vWorldPosition)));

  vec3 pointLight = u_PointLightColor * u_PointLightIntensity * l;

  color += pointLight;

  gl_FragColor = vec4(color, 1.0);
}
