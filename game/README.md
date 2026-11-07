# Handling prototype 0.1

Target: **Godot 4.7.2 stable**, confirmed against https://godotengine.org/download/archive/ on 2026-11-07 (4.8 is beta).

## Run
1. Install Godot 4.7.2 stable.
2. Import `game/project.godot` in Godot Project Manager.
3. Press F5 to launch the project.
4. W/Up accelerates, S/Down brakes, A/D or Left/Right steers. Gamepad: left stick and A/B (experimental).

## Included
Procedurally generated figure-eight track spanning approximately 220 by 144 metres, with a raised crossover, colored boundary markers, roadside rocks and distinct stone landmarks inside each loop. The broom follows the road elevation automatically. Includes a blue capsule/pill witch on a stick broom, acceleration, steering, braking, chase camera and speed indicator.

## Not yet included
Collisions, track confinement, banking, laps, AI, split-screen, real models, networking.

**Validation status:** Godot 4.7.2 headless startup and a 120-frame smoke check pass on Windows. Interactive handling and visual presentation still need playtesting.
