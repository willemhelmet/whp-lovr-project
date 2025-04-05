# LOVR-BOY
This is a VR interactive framework built on LOVR. The main goal is to 1) teach me how to build a complex system for VR experiences, and 2) build a VR framework that will allow me to quickly build experiences for a wide range of VR headsets.

## Project Structure
One thing I would really like to do is have an organized and understandable file structure. Below is my first pass
### Core
- Contains the fundamental systems that I will build upon
- Renderer, input handling, physics, etc.
### Entities
- Objects, interactables, and so on
- Probably the player too?
### Components
- modular behaviors
### Systems
- broad, game-wide logic that affects multiple entities

## Considerations
### 3rd party code
- How do I get other people's code into this project? I see something called "luarocks", may have to look into that
#### ECS
- research (tiny-ecs)[https://github.com/bakpakin/tiny-ecs?tab=readme-ov-file]
- would an entity component system benefit me? I feel like it could, but as of 2/15 i feel it is too soon to tell
- would OOP be a better choice?
#### Animations
- I found a tween library for lua. could be helpful
#### Knife
- todo

### Shaders
- I want to use a Phong shading model (maybe Binn-Phong? Need to learn more)
- Using some style tricks from Valve (i.e 1/2 lambert)
- I want to have a maximum number of lights in the scene that I can modify as i see fit. keeping that number low will be a creative restriction but that isn't a bad thing

### Physics
- it would be pretty cool!
