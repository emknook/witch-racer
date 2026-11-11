# Witch Racer — Product vision and release scope

**Status:** Working product brief. Confirmed facts are labeled; suggested release boundaries and unresolved choices are not commitments.

## The end goal

**Confirmed identity:** A fast, responsive, F-Zero-inspired **track-based broom racing game** in Godot, with a PSX-inspired low-poly Blender art style, eight distinct selectable witches, singleplayer and local multiplayer. The codebase must remain adaptable to future online multiplayer. Racing is on defined courses, not unrestricted free flight.

**Proposed player promise:** Learn a magical circuit, improve lines and boost timing, compete with other racers or a personal ghost, and eventually face a frightening pursuit by Walpurgis. The game should feel fast, readable and rewarding to master, even at low rendering resolution.

### Core loop — proposed

1. Choose witch, track and race mode.
2. Race along a clearly marked circuit, navigating turns and elevation changes.
3. Cross checkpoints in order and complete valid laps; receive clear timing and placement feedback.
4. Retry to improve performance, challenge a ghost or progress to another event.
5. In designated story events, escape Walpurgis pursuing from behind.

**Not yet decided:** Boost availability, drifting, collisions, items, hazards, shortcuts, ranking and progression rules. Do not implement these as settled design.

## Player experiences

| Experience | Status | Definition |
| --- | --- | --- |
| Solo time trial | Proposed initial mode | Race against clock; save and compare completed runs |
| Solo race versus AI | Proposed full-game mode | Race other witches on a defined track |
| Local multiplayer | Confirmed requirement | Multiple players race locally; split-screen implementation and player count remain open |
| Ghost race | Confirmed feature direction | Replay a previous recorded run as a non-colliding visual rival |
| Walpurgis pursuit | Confirmed feature direction | Special races where Walpurgis chases from behind, not an ordinary grid competitor |
| Championship/story progression | Open | Cup structure, unlocks and win conditions require owner decisions |
| Online multiplayer | Future-compatible architecture only | Not a launch promise or MVP requirement |

## Story and tone

**Confirmed campaign direction (2026-11-11):** The racing championships are secretly organized to prepare witches for Walpurgisnacht. The story begins by introducing witch racing and championships. Rumours of Walpurgis are sprinkled gradually throughout the competitive progression. Only after approximately **70–80% of story-track progression** does it become clear that the story has been building toward Walpurgisnacht. The late reveal should recontextualize the championship rather than replace racing as the game's identity. These percentages indicate narrative pacing, not a fixed track count.

**Confirmed organizer rationale (2026-11-11):** The organizers conceal the gruesome necessity behind witch racing: speed and racing skill are needed to survive Walpurgis and capture the beast again. They benefit from the public embracing racing as an exciting sport. Competition continually raises the standard of racers, so each generation becomes better prepared than the last for the recurring capture. The championships are therefore both genuine sporting events and long-term preparation for Walpurgisnacht. The player learns their true purpose late in the campaign, around 70–80% of story-track progression.

**Open narrative details:** The organizers' identity, exact methods of capture, what happens to unsuccessful racers, the historical origin of the secrecy, and whether hiding the danger was ethically justified remain undecided. Do not imply that racers are deliberately sacrificed without owner approval.

**Proposed pacing (subject to story design):** Early races establish the racing world and rivals; middle races introduce strange incidents and recurring clues; late championship races connect those clues; the final roughly 20–30% contains the Walpurgisnacht reveal, escalating story events and climactic pursuit. Avoid presenting Walpurgis as the primary antagonist in the opening tutorial.

**Confirmed:** A simple, charming story; Walpurgis features in story sequences and special races. Her chase threatens racers from behind. Recorded runs may inform her route and speed. A precisely timed normal boost during her reaching-arm grab is a proposed escape mechanic requiring validation.

**Working lore, not final canon:** The Walpurgisnacht gathering, magical track markings, captured ancient creature, Wardens and thirteen seals are recorded in [Walpurgisnacht lore](walpurgisnacht.md). Avoid silently replacing this with the superseded Grand Broom Prix draft. The exact relationship between regular competitions and the recurring pursuit is unresolved.

## Eight witches

**Confirmed:** Eight selectable witches, with blue, yellow, green, red, purple and mixed-color hair represented. Distinct silhouettes and readable low-resolution designs matter. Names, personalities, stat differences, unlocks and character-specific endings are proposals; see [characters](characters.md).

## Visual and audio direction

**Confirmed visual basis:** Low-poly PSX-inspired 3D assets authored in Blender. **Proposed:** Bold color blocking, strong silhouettes, magical track signage, readable fog/distance cues and an intentionally stylized rather than photorealistic world. Compare actual in-engine references before locking texture or polygon budgets.

**Audio direction — open:** Define racing music energy, broom/boost feedback, environmental sound, Walpurgis warning layers, voice usage and accessibility options through references and prototypes. No specific soundtrack style has been approved.

## Delivery stages — proposed scope, not dates

### Stage 1 — Handling prototype (existing foundation)

A single controllable racer on a representative circuit, camera and deterministic simulation with repeatable headless tests.

**Exit evidence:** Import/smoke/golden replay pass on supported platforms; interactive handling notes are recorded. Passing CI alone does not prove handling quality.

### Stage 2 — Vertical slice

One complete, replayable **solo time trial** on one track with validated checkpoints, lap timing, finish/reset flow, clear HUD, one representative witch, recognizable visual style and basic audio feedback. A recorded visual ghost is a stretch goal, not a blocker.

**Acceptance criteria:** Cannot complete a lap by skipping required checkpoints; pause/restart produces correct timing; player can finish and retry; deterministic test coverage exists for rule boundaries; manual playtest demonstrates understandable controls and track readability.

### Stage 3 — MVP

A small, coherent racing game with a chosen solo competitive mode, local multiplayer, multiple selectable witches/tracks, complete race flow, usable menus and performance validated on target hardware. Exact minimum content counts and AI requirement need approval.

**Acceptance criteria:** Complete a session from menu to results and replay; local players have independent controls and readable views; no unresolved critical crashes; automated tests and manual acceptance checks pass.

### Stage 4 — Full release vision

Eight distinct witches, broader tracks/events, lightweight story progression, polished ghost competition and special Walpurgis pursuits. Content counts, progression and release platforms remain open. Future online play is **not** included unless explicitly approved.

## Engineering principles

- Keep race rules deterministic, integer/tick-based and independent of scene nodes or rendering.
- Inputs, presentation, track visuals, replay and simulation have explicit responsibilities.
- Write acceptance criteria and failing focused tests before new gameplay rules; then Green → Refactor.
- For refactors, preserve existing golden replay hashes; for intentional rule changes, version the rules and review updated fixtures.
- Aim for short, intention-revealing functions (around five lines as a strong guideline), not meaningless wrapper chains.
- Document consequential decisions in the [decision log](../decisions/README.md). See the [simulation contract](../architecture/deterministic-simulation.md).

## Decisions required from the owner (highest leverage first)

1. **Championship-to-Walpurgis transition:** Who are the organizers, what reveals their long-running preparation around 70–80% progression, and how is the beast captured?
2. **Winning and progression:** Are solo races time trials, AI grid races, cups, or a deliberate mix? What unlocks the next event?
3. **Race mechanics:** Which of boost, drift, collision, items and shortcuts are essential versus explicitly out of scope?
4. **Local multiplayer:** Is two-player split-screen sufficient for initial release, or is four-player a requirement?
5. **Walpurgis consequences:** Does capture immediately fail a run, and how forgiving should the last-grasp boost be?
6. **Content/release targets:** Target platforms, number of tracks and minimum witches available at MVP.

Resolve these before expanding implementation; document choices with rationale and consequences.
