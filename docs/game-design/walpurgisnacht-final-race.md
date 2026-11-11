# Walpurgisnacht — Multi-stage sealing race

**Status:** Owner-directed concept, 2026-11-11. Core stages and overhead spell-progress UI are confirmed directions; geometry, order details, capture rules, timing and implementation remain proposals.

## Premise

The championships secretly train each generation of witches to outrun Walpurgis and capture her again. After the late campaign reveal (roughly 70–80% of story-track progression), the finale demonstrates why racing skill matters: **the witches trace the magical seal by racing its paths**. This is a racing climax, not a conventional combat boss.

## Multi-stage finale

### 1. Great outer lap — establish the boundary

**Owner direction:** A very large lap circles Walpurgis. Completing the route leaves a magical wall or enclosing boundary around her.

**To prototype:** Whether one racer or multiple racers must complete the boundary; whether the wall rises continuously behind racers or activates on lap completion; how Walpurgis can still chase without making the boundary contradictory.

### 2. Inner circuits — inscribe the runes

**Owner direction:** Smaller circular and/or rune-shaped tracks inside the outer boundary form the spell's internal symbols. As each track is completed, its corresponding section of the magical circle lights up.

**To prototype:** Route topology and legibility at racing speeds; ordered versus selectable runes; how racers transition between paths; how to validate each route without requiring pixel-perfect line tracing.

### 3. Convergence — lure Walpurgis to the center

**Owner direction:** A final combined race involving all participating racers draws Walpurgis into the middle of the completed circle, where the capture is triggered.

**To prototype:** Whether the racers approach from separate routes or race together; how the chase remains fair; what explicitly triggers the binding; how solo play presents the other witches; how this scales to local multiplayer.

## Environmental storytelling and transitions

**Owner direction:** Include animations throughout the multi-stage event. Candidate transitions include a wall rising after the great lap, runes illuminating after inner routes, and a final seal activation when Walpurgis reaches the center. Keep animations readable and preserve the pacing of an arcade racing game.

**Not yet confirmed:** Cinematic camera cuts, skippability, playable versus non-playable transitions, and specific visual effects.

## Spell-progress UI

**Owner direction:** Show the magical circle **from above** as a game UI element. Completed tracks light up on the diagram, providing a visual record of how much of the sealing spell has been constructed.

**Proposed behavior:**
- Display the outer circle and rune-route geometry in a compact schematic, not necessarily a geographically exact minimap.
- Inactive paths are dim; validated completed routes glow.
- Use an additional accessible indicator (text, icon or pattern), not color alone.
- Update the display from authoritative completion events, never from visual-only proximity.
- Clearly differentiate progress in the current route from a fully activated rune.
- During convergence, show the remaining center activation and final capture state.

## Race-rule and technical implications

- Model the finale as an explicit sequence of stages and route-completion objectives.
- Keep lap/checkpoint validation and spell-state transitions deterministic at the simulation tick rate.
- Represent each magical stroke as a defined course with ordered checkpoints; visual traces should not be the source of truth.
- Presentation consumes stage and route-completion events to animate walls, rune lighting and HUD.
- Ghost recording and Walpurgis pursuit remain separate from authoritative checkpoint completion.
- Test skipped gates, incorrect route order, restarts, pause/resume, failure/retry, multiple local racers and stage transitions with TDD.
- Keep the final event achievable in singleplayer without assuming eight human players.

## Acceptance criteria for a future vertical prototype

1. Completing the outer course activates exactly one boundary objective.
2. A skipped mandatory checkpoint cannot light a rune.
3. Completing an inner course updates both authoritative spell state and the overhead schematic.
4. Replaying a stage does not double-count a completed rune.
5. Convergence is unavailable until required seal components are active.
6. The game can restart or resume the event without contradictory UI or stage state.

## Decisions still open

1. Must all eight witches participate in the final convergence, including AI companions in singleplayer?
2. Are inner rune routes sequential, branching, or chosen freely?
3. Does the wall merely contain Walpurgis, or progressively restrict her movement?
4. What constitutes success or failure in the final lure, and what happens if a racer is caught?
5. How do we preserve the earlier proposed last-grasp timed boost without forcing it into an unsuitable finale?

See [product vision](product-vision.md), [Walpurgisnacht lore](walpurgisnacht.md) and [ghosts and Walpurgis](ghosts-and-walpurgis.md).
