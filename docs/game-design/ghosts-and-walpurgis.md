# Ghost racing and Walpurgis encounters

## Confirmed direction (2026-11-07)
- Players should be able to record and race against a **ghost** of a previous run.
- **Walpurgis appears primarily in special story sequences and special races**, not as a permanent pursuer in ordinary races.
- Walpurgis's speed and racing route may reuse recorded player ghost data, including runs the player could realistically complete.
- **Confirmed encounter behavior:** In special races, Walpurgis pursues racers from behind; being caught is the danger. She is not a head-to-head finish-line rival.

## Proposed design

### Ghost capture
Record a completed run on a fixed simulation-time sampling cadence. Each sample contains timestamp, transform (position and rotation) and optional visual state. Store lap/checkpoint events separately. Do not assume a replay of input commands will reproduce identical Godot physics across machines.

### Data format
Use a versioned ghost format with track ID, track layout revision/hash, game version, sample interval, finish time, checkpoint splits and samples. Save personal best separately from last completed run. Reject incompatible track versions gracefully. Apply compression only after profiling.

### Playback
Render a non-colliding translucent racer with interpolated transforms. Playback uses race elapsed time, not render-frame counts. The ghost should never influence authoritative race results.

### Walpurgis special races
Start with authored, validated ghost trajectories chosen to match target difficulty. Walpurgis starts behind the racers and follows the course; the encounter controller detects when she closes the gap enough to catch a racer. Design clear audiovisual distance warnings and a fair, telegraphed catch threshold. Apply a distinct Walpurgis visual and audio presentation. A separate encounter controller handles proximity warnings, scripted events and fail conditions. Do not directly treat a ghost as an AI with dynamic collision responses.

### Difficulty and fairness
Consider selecting among recorded clean runs by finish time and checkpoint splits; test that the player has a reasonable chance to win. If using the player's own personal best, avoid making victory mathematically impossible through an arbitrary head start or unfair speed multiplier. Provide accessible difficulty options.

### Multiplayer and privacy
Each local racer may record a separate run, keyed to a local profile. Ghost playback is presentation-only. Online sharing is out of scope for now; never upload recordings without user consent.

## Implementation order
1. Add a stable race clock, track ID, checkpoint/lap validation.
2. Record timestamped transforms during one clean lap.
3. Persist and load versioned runs.
4. Render a non-colliding interpolated ghost.
5. Select recorded runs for a Walpurgis encounter and add story presentation.
6. Test edge cases: pause, restart, shortcuts, track revisions, local multiplayer.

## Open questions
- Should ghosts be personal-best only, last run, or selectable?
- What happens when Walpurgis catches a racer: immediate failure, a recoverable penalty, or a short escape opportunity?
- How much head start should the player receive, and how should the gap adapt to difficulty?
- Can players share ghost files manually before online multiplayer exists?
