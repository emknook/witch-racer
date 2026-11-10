# Architecture and test-driven development

## Purpose

Organize Witch Racer by **reason to change**, not by arbitrary file size. Preserve the existing deterministic gameplay contract while improving boundaries incrementally. This is a proposed architecture, not an instruction to move all files immediately.

## Current responsibilities

| Current code | Responsibility | Direction |
| --- | --- | --- |
| `game/simulation/race_simulation.gd` | Authoritative integer simulation, track mathematics and snapshots | Keep deterministic; extract cohesive rules only with golden and targeted tests |
| `game/race_prototype.gd` | Input adaptation, scene construction, camera and HUD | Thin composition root; separate input, world construction and presentation |
| `game/tests/test_determinism.gd` | Simulation regression and golden replay | Split into focused test cases and a small test runner without losing coverage |
| `game/tests/replay.sha256` | Golden deterministic replay fixture | Never regenerate automatically in CI |

## Intended component boundaries

- **Simulation:** Race rules, track projection, boundaries, checkpoints, laps, gameplay clock and authoritative state.
- **Input:** Convert keyboard/gamepad/AI/future network commands into the same tick-indexed racer intent.
- **World construction:** Generate Godot meshes, rails and scenery from simulation-defined track data. No gameplay decisions.
- **Presentation:** Racer model, camera, HUD, effects and audio; read state, never author it.
- **Replay:** Capture and replay tick-indexed commands for deterministic verification; separately record timestamped transforms for visual ghosts where needed.
- **Story encounters:** Walpurgis pursuit rules and last-grasp boost timing, using deterministic state. Animations and sound remain presentation.

## Dependencies

Input -> simulation <- race rules. Presentation and world builders may read simulation state/track definitions; simulation must not depend on scene nodes, physics queries, UI or rendering. Replay and tests depend on the simulation's public contract.

Keep each module's public API narrow. Prefer passing explicit data over reaching through a scene tree. Avoid introducing interfaces and inheritance without a second concrete need.

## Test-driven workflow

1. **Specify:** Write a short behavior statement and acceptance criteria, including edge cases.
2. **Red:** Add a focused test that fails because the behavior is missing. Distinguish expected assertion failure from a syntax/import error.
3. **Green:** Implement the smallest deterministic rule change that makes the test pass.
4. **Refactor:** Improve names, cohesion and file boundaries without changing observable behavior.
5. **Verify:** Run focused tests, the golden replay and Windows/Linux headless CI; review resulting diffs.

For pure refactoring, begin with characterization tests and keep the existing golden hash unchanged. For deliberate rule changes, bump the rules version and review a new golden hash explicitly.

## Clean Code policy

- Aim for approximately **five lines per function**, counting executable statements as a practical guide rather than a brittle hard limit.
- Each function does one thing at one level of abstraction and has an intention-revealing name.
- Extract functions when doing so clarifies meaning; do not create meaningless one-line forwarding chains.
- Prefer explicit state and simple control flow; keep comments for rationale and non-obvious invariants.
- A file has one primary reason to change. Avoid turning the composition root into a utility collection.
- Every extracted component needs a clear owner, contract and test seam.

## First migration sequence

1. **Baseline:** Ensure PR #12 test fixes and current Windows/Linux validation are green; record baseline golden digest.
2. **Test organization:** Separate deterministic test cases by concern, retaining a small entry-point runner and unchanged assertions.
3. **Presentation:** Extract camera and HUD from the prototype scene controller; compare visuals and run smoke tests.
4. **World:** Extract track and scenery mesh construction; preserve geometry and seeded placement.
5. **Gameplay:** Write failing tests for track confinement, then implement the rule in simulation.
6. **Progression:** Add checkpoint ordering and lap timing through TDD, followed by ghost recording.

Do not merge broad file moves and new gameplay rules into the same PR. Small, reviewable steps make failures easier to diagnose.

## Definition of done

- Behavior and acceptance criteria documented.
- Relevant tests demonstrate the new behavior and edge cases.
- Golden replay unchanged for refactors, or intentionally versioned for rule changes.
- Windows and Linux headless checks pass.
- Files, names and documentation reflect ownership.
- Gameplay feel changes receive interactive playtesting, not only CI.
