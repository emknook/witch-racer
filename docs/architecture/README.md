# Technical architecture

**Target:** Godot latest stable release, verified against official release notes before engine setup or upgrades. Do not assume a specific version without checking.

See [module boundaries and TDD workflow](tdd-and-module-boundaries.md) for responsibilities, incremental migration, testing standards and definition of done.

## Owner-approved baseline constraints (2026-11-16)

- **Track-bound hover movement:** The authoritative simulation follows defined racing courses. Track geometry, elevation and banking may influence movement, but player-controlled unrestricted flight is out of baseline scope. Keep hover/grounding and airborne steering policy isolated for testing and later tuning.
- **Equal desktop platform support:** Windows and Linux are both baseline targets, not primary/secondary. Keyboard and gamepad input must map into the same racer-intent commands, with device-specific handling outside the simulation.
- **CI evidence:** Maintain Windows and Linux automated project-import/smoke and deterministic rule checks. Verify platform-specific builds and actual keyboard/gamepad behavior separately; CI success alone is not a hardware acceptance test.

See the [one-year roadmap](../game-design/one-year-roadmap.md) for milestone acceptance criteria.

## Principles
- **Race simulation** owns racer movement, checkpoints, lap progression and standings.
- **Input sources** (human local controller, AI, future network command stream) express racer intentions through a common interface.
- **Presentation** (camera, split-screen viewports, UI, effects, audio) observes race state rather than owning game rules.
- **Authority** is explicit: local play can run one authoritative simulation; future online play can use a host/server authority and replicated snapshots or commands.
- Gameplay must be bit-identical for the same rules version, initial state and tick-indexed inputs. Built-in Godot physics is excluded from authoritative gameplay. See the [simulation contract](deterministic-simulation.md).
- Keep racer cosmetic definitions data-driven and independent of controller assignment.

## Proposed vertical slice
1. Basic flight controller and camera on one test track.
2. Checkpoints and lap timing.
3. Input routing for two local controllers and split-screen cameras.
4. AI using the same racing intent model.
5. Profile and performance testing, then expand the roster.

## Quality bar
Intention-revealing names, cohesive scripts, explicit responsibilities, minimal redundant comments, tests for pure rules where feasible, and documented architectural decisions.
