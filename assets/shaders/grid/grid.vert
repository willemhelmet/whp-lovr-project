out vec2 scale;

vec4 lovrmain() {
  scale = vec2(length(Transform[0]), length(Transform[1]));
  return DefaultPosition;
}
