uniform vec4 lightColor;
uniform vec3 lightPos;
uniform float attenuation;
uniform vec4 ambience;
uniform float specularStrength;
uniform int metallic;

vec4 lovrmain() {
  // Get distance from the current fragment to the light positions
  float distanceToLight = length(lightPos - PositionWorld);

  // Linear attenuation factor
  float attenuation = 1.0 / (distanceToLight * distanceToLight);
  
  // diffuse
  vec3 norm = normalize(Normal);
  vec3 lightDir = normalize(lightPos - PositionWorld);
  float diff = max(dot(norm, lightDir), 0.0);
  vec4 diffuse = diff * lightColor * attenuation;

  //specular
  vec3 viewDir = normalize(CameraPositionWorld - PositionWorld);
  vec3 reflectDir = reflect(-lightDir, norm);
  float spec = pow(max(dot(viewDir, reflectDir), 0.0), metallic);
  vec4 specular = specularStrength * spec * lightColor;

  vec4 baseColor = Color * getPixel(ColorTexture, UV);
  return baseColor * (ambience + diffuse + specular);
}
