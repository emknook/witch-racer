# Handling prototype 0.1

Target: **Godot 4.7.2 stable**, confirmed against https://godotengine.org/download/archive/ on 2026-11-07 (4.8 is beta).

## Run
1. Install Godot 4.7.2 stable.
2. Import `game/project.godot` in Godot Project Manager.
3. Press F5 to launch the project.
4. W/Up accelerates, S/Down brakes, A/D or Left/Right steers. Gamepad: left stick and A/B (experimental).

## Included
Procedurally generated figure-eight track spanning approximately 220 by 144 metres, with a raised crossover, colored boundary markers, roadside rocks and distinct stone landmarks inside each loop. The broom follows the road elevation automatically. Includes a blue capsule/pill witch on a stick broom, acceleration, steering, braking, speed-responsive chase camera with steering anticipation, and speed indicator.

Gameplay movement and track detection use a 60-tick integer simulation, separated from interpolated visuals. See the [determinism contract and replay tests](../docs/architecture/deterministic-simulation.md).

## Not yet included
Collisions, track confinement, banking, laps, AI, split-screen, real models, networking.

**Validation status:** Godot 4.7.2 headless startup and a 120-frame smoke check pass on Windows. Interactive handling and visual presentation still need playtesting.

## Greybox camera evaluation (proposed)

The camera now pulls back and rises slightly with speed, looks ahead along the broom heading, and anticipates steering. Its position uses frame-rate-independent exponential smoothing. This is **presentation only**: authoritative simulation and replay hashes should remain unchanged.

Manual checks on **both Windows and Linux**, with **keyboard and gamepad**:

1. Start from rest and accelerate to maximum speed: camera distance and height should change smoothly, without a jump on the first frame.
2. Steer left and right at low and high speeds: look-ahead should make the next part of the course readable; inspect for oscillation and motion sickness.
3. Brake sharply and reverse steering: camera should settle without sudden snapping or clipping into the track.
4. Cross the elevated figure-eight section: verify the track remains visible and the camera does not pass through geometry.
5. Compare a 30 FPS and 120 FPS render rate: framing and response should be comparable. This is a manual visual check, not a claim of identical rendered frames.
6. Verify headless import/smoke and deterministic replay tests in Windows and Linux CI before merging.

**Known limitation:** This increment improves the existing playable steering/camera greybox but does **not** implement airborne dynamics or a corridor constraint. The approved direction is more manual airborne steering **within** a track corridor. That requires a separately specified, versioned deterministic simulation change and tests; do not approximate it with presentation-only motion.
