# Technical architecture

**Target:** Godot latest stable release, verified against official release notes before engine setup or upgrades. Do not assume a specific version without checking.

## Principles
- **Race simulation** owns racer movement, checkpoints, lap progression and standings.
- **Input sources** (human local controller, AI, future network command stream) express racer intentions through a common interface.
- **Presentation** (camera, split-screen viewports, UI, effects, audio) observes race state rather than owning game rules.
- **Authority** is explicit: local play can run one authoritative simulation; future online play can use a host/server authority and replicated snapshots or commands.
- Do not promise deterministic Godot physics or build a networking abstraction before requirements justify it.
- Keep racer cosmetic definitions data-driven and independent of controller assignment.

## Proposed vertical slice
1. Basic flight controller and camera on one test track.
2. Checkpoints and lap timing.
3. Input routing for two local controllers and split-screen cameras.
4. AI using the same racing intent model.
5. Profile and performance testing, then expand the roster.

## Quality bar
Intention-revealing names, cohesive scripts, explicit responsibilities, minimal redundant comments, tests for pure rules where feasible, and documented architectural decisions.
