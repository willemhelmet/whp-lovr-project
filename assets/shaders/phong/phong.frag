# define MAX_LIGHTS 16

uniform float specularStrength;
uniform int metallic;
uniform vec4 ambientColor;
uniform vec4 diffuseColor;
uniform vec4 specularColor;
layout(scalar) uniform Lights {
  vec4 positions[MAX_LIGHTS];   // x, y, z, lightType
  vec4 directions[MAX_LIGHTS];  // ax, ay, az, 0
  vec4 colors[MAX_LIGHTS];      // r, g, b, intensity
  vec4 attenuations[MAX_LIGHTS]; // constant, linear, quadratic, 0
};

vec4 lovrmain() {
  vec4 baseColor = DefaultColor * diffuseColor;
  vec4 result = ambientColor * baseColor;
  
  // Debug - uncomment to see specific light info 
  // return vec4(positions[0].x, 0.0, 0.0, 1.0);  // Should show light position as RGB
  // return vec4(colors[0].x, 0.0, 0.0, 1.0);       // Should show light color and intensity
  // return vec4(directions[0].x, 0.0, 0.0, 1.0);
  
  for (int i = 0; i < MAX_LIGHTS; i++) {
    vec3 norm = normalize(Normal);
    vec3 lightColor = colors[i].rgb;
    float lightIntensity = colors[i].a;

    // Check what type of light to calculate
    // 0.0 - inactive
    // 1.0 - point light
    // 2.0 - directional light
    // 3.0 - spot light
    float lightType = positions[i].w;
    if (lightType == 1.0 || lightType == 3.0) { // point light or spot light
      vec3 lightPos = positions[i].xyz;
      vec3 lightDir = normalize(lightPos - PositionWorld);
      // Distance and attenuation
      float dist = length(lightPos - PositionWorld);
      float att = 1.0 / (
        attenuations[i].x + 
        attenuations[i].y * dist + 
        attenuations[i].z * (dist * dist)
      );

      // Diffuse
      // float diff = max(dot(norm, lightDir), 0.0); // -1 to 1 lambert, old school
      float diff = 0.5 + dot(norm, lightDir) * 0.5; // "half lambert", courtesy of valve
      vec4 diffuse = diff * vec4(lightColor, 1.0) * att * lightIntensity;

      // Specular
      vec3 viewDir = normalize(CameraPositionWorld - PositionWorld);
      vec3 reflectDir = reflect(-lightDir, norm);
      float spec = pow(max(dot(viewDir, reflectDir), 0.0), metallic);
      vec4 specular = specularStrength *
        spec *
        vec4(lightColor, 1.0) *
        att *
        lightIntensity *
        specularColor;

      if (lightType == 3.0) { // handle spot light
        // Get the spotlight direction (points FROM the light source)
        vec3 spotDirection = normalize(directions[i].xyz); 
        // Get the cosine of the angle between the light direction vector
        // and the vector from the light to the fragment
        float theta = dot(lightDir, -spotDirection);

        // Retrieve the cosine of the inner and outer cutoff angles
        // We'll store cos(cutOff) in attenuation.w and cos(outerCutOff) in directions.w
        float cosCutOff = directions[i].w;      // Cosine of the inner cone angle
        float cosOuterCutOff = attenuations[i].w;  // Cosine of the outer cone angle

        // Calculate the spotlight intensity factor
        float epsilon = cosCutOff - cosOuterCutOff;
        // Avoid division by zero or negative numbers if cutoffs are equal or reversed
        epsilon = max(epsilon, 0.001); 
        // Smoothly interpolate intensity between the inner and outer cone angles
        float spotIntensity = clamp((theta - cosOuterCutOff) / epsilon, 0.0, 1.0);

        // Apply the spotlight effect
        diffuse  *= spotIntensity;
        specular *= spotIntensity;
      }

      result += (diffuse + specular) * baseColor;
    } else if (lightType == 2.0) { // directional light
      // diffuse
      vec3 lightDir = normalize(-directions[i].xyz);
      float diff = max(dot(norm, lightDir), 0.0);
      vec4 diffuse = diff * vec4(lightColor, 1.0) * lightIntensity;

      // specular
      vec3 viewDir = normalize(CameraPositionWorld - PositionWorld);
      vec3 reflectDir = reflect(-lightDir, norm);
      float spec = pow(max(dot(viewDir, reflectDir), 0.0), metallic);
      vec4 specular = specularStrength *
        spec *
        vec4(lightColor, 1.0) *
        lightIntensity *
        specularColor;

      result += (diffuse + specular) * baseColor;
    } else {
      continue;
    }
  }
 
  // gamma correction
  result = vec4(pow(result.xyz, vec3(1.0/2.2)), 1.0);

  return result;
}
