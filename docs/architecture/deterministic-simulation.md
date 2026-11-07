# Deterministic simulation contract

`game/simulation/race_simulation.gd` owns the current gameplay state. `game/race_prototype.gd` samples player intentions and renders snapshots. Identical rules, initial state and input commands per tick must produce identical integer state on every supported platform.

## Arithmetic and time

- Exactly 60 simulation ticks per second. `step(accelerate, brake, steering)` advances one tick without accepting wall-clock time or a floating-point delta. The project pins its physics tick rate and the adapter rejects a different rate.
- Coordinates are signed int64 millimetres. Speed is millimetres/second multiplied by 60, preserving acceleration fractions. Movement and turning retain integer division remainders in the snapshot.
- Heading wraps at 65536 units per turn. Integer rational sine and integer square root replace platform math libraries. This intentionally approximates the original floating-point handling; it does not reproduce its floating-point results.
- Gameplay positions are bounded to +/-1000 metres horizontally, with hover heights from 1.5 to 13.5 metres. The current constants and bounds keep intermediate products within int64. Reassess these limits before increasing the world size, resolution or speed.
- Integer division truncates toward zero. Array iteration order, nearest-segment tie breaking, rounding, and braking priority are part of the rules.

## Track and state

The 320-segment figure eight and its width offsets are generated entirely with integer math. Presentation uses these same points, converting to metres only for rendering. Surface detection projects onto segments in stable index order and compares squared distances. Height participates in the nearest-segment search so the upper and lower crossover remain separate. The broom follows the selected surface at a fixed integer rate; off-road height returns toward ground level.

Snapshots include the rules version, tick, position, speed, heading, on-track flag, gameplay RNG state and every arithmetic remainder. `restore()` validates a complete snapshot before changing state. `canonical_state()` encodes decimal integers in a fixed order for portable hashes. Snapshots assume the track and constants belonging to that rules version; track changes require a rules version bump too.

`next_random()` supplies a specified 31-bit linear congruential sequence. It is for reproducible gameplay randomness, not security. Future gameplay systems must use this state or explicitly snapshotted independent streams, never Godot's global RNG.

## Input and presentation boundary

Keyboard and controller input becomes two booleans and signed steering in [-127,127] once per tick. Replays and network commands must preserve these values and their tick order. Identical physical key press timings on two machines are not an identical input stream; the recorded commands are the reproducibility boundary.

Rendering interpolates positions and headings between simulation snapshots. Camera smoothing, rider lean, scenery randomness, meshes and UI can use floating point. Their values must never be read by gameplay. Rocks and rails remain decorative, without collision, as in the preceding prototype.

Future collisions, pickups, abilities, AI, checkpoints and lap timing must live in the integer simulation, use stable entity ordering, and extend the snapshot schema. Do not introduce `RigidBody3D`, physics queries, `Vector3` math, floating-point timers, scene transforms or rendering callbacks as sources of authoritative results. General rigid-body collision, networking and replay file UI are not implemented here.

## Verification and changes

Run on Windows:

```powershell
.\start --headless --script res://tests/test_determinism.gd
```

On Linux:

```bash
bash scripts/start-game.sh --headless --script res://tests/test_determinism.gd
```

Tests cover integer math, acceleration/braking limits, steering symmetry, world bounds, crossover selection, off-track detection, snapshot validation and rollback including RNG and fractional remainders. A 3600-tick input sequence hashes every state and every road vertex into one SHA-256 digest. Independent runs and both CI platforms must match the checked-in `game/tests/replay.sha256`.

When changing gameplay rules, review the behavior, bump `RULES_VERSION`, and deliberately update the golden digest. Never automatically regenerate the expected digest in CI. Add targeted tests for the new rule. Passing one replay is regression evidence, not an exhaustive proof of determinism; new features need their own coverage.

Local verification currently covers Windows x64 on Godot 4.7.2. The workflow runs the same golden on Windows and Linux; its new matrix must pass before cross-platform verification is claimed. Additional architectures and engine upgrades require verification too.
