# define MAX_LIGHTS 16

uniform vec4 ambience;
uniform float specularStrength;
uniform int metallic;
layout(scalar) uniform Lights {
  vec4 positions[MAX_LIGHTS];   // x, y, z, isActive
  vec4 colors[MAX_LIGHTS];      // r, g, b, intensity
  vec4 attenuation[MAX_LIGHTS]; // constant, linear, quadratic, 0
};

vec4 lovrmain() {
  vec4 baseColor = Color * getPixel(ColorTexture, UV);
  vec4 result = ambience * baseColor;
  
  // Debug - uncomment to see specific light info 
  // return vec4(positions[0].x, 0.0, 0.0, 1.0);  // Should show light position as RGB - WAS WORKING NOW BORKED
   //return vec4(colors[0].x, 0.0, 0.0, 1.0);       // Should show light color and intensity - BORKED
  
  for (int i = 0; i < MAX_LIGHTS; i++) {
    // Skip inactive lights (check w component)
    // if (positions[i].w < 0.5) continue;
    
    vec3 lightPos = positions[i].xyz;
    vec3 lightColor = colors[i].rgb;
    float lightIntensity = colors[i].a;
    
    // Calculate light contribution
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(lightPos - PositionWorld);
    
    // Distance and attenuation
    float dist = length(lightPos - PositionWorld);
    float att = 1.0 / (
      attenuation[i].x + 
      attenuation[i].y * dist + 
      attenuation[i].z * (dist * dist)
    );
    
    // Diffuse
    float diff = max(dot(norm, lightDir), 0.0);
    vec4 diffuse = diff * vec4(lightColor, 1.0) * att * lightIntensity;
    
    // Specular
    vec3 viewDir = normalize(CameraPositionWorld - PositionWorld);
    vec3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), metallic);
    vec4 specular = specularStrength * spec * vec4(lightColor, 1.0) * att * lightIntensity;
    
    // Add light contribution
    result += (diffuse + specular) * baseColor;
  }
  
  //return vec4(0.0, 1.0, 0.0, 1.0);
  return result;
}
