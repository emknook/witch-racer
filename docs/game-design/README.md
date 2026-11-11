# Game design

## Start here

- [Product vision and release scope](product-vision.md) — canonical product goals, confirmed campaign direction, proposed milestones and unresolved scope.
- [Story and setting](story.md) — amateur beginnings, championship progression and the Walpurgisnacht reveal.
- [Characters and roster](characters.md) — protagonist versus eight established witches, proposed identities and supporting roles.
- [Walpurgisnacht final race](walpurgisnacht-final-race.md) — multi-stage magical sealing race and overhead spell UI.
- [Walpurgisnacht lore](walpurgisnacht.md) — recovered historical lore; details are not automatically canon.
- [Ghost racing and Walpurgis](ghosts-and-walpurgis.md) — replay and pursuit mechanics, including open tuning questions.
- [Decision log](../decisions/README.md) — confirmed requirements and outstanding choices.

## Core pitch

A high-speed, F-Zero-inspired, track-based broom racing game in Godot with PSX-inspired low-poly Blender art. The campaign follows an amateur witch from experimenting with her broom in a shed to increasingly prestigious championships. The racing world is secretly preparing generations of witches for Walpurgisnacht, revealed late in the story.

## Confirmed foundations

- Singleplayer and local multiplayer; architecture should allow future online play.
- Eight established witch racers are planned, **in addition to** the separate story protagonist. The resulting playable roster and selection rules are not yet settled.
- Fast, responsive racing on defined 3D courses rather than unrestricted free flight.
- A friendly, personal opening; no required racing school or club.
- A late-campaign Walpurgisnacht reveal and multi-stage sealing finale with all eight established witches participating (AI companions in singleplayer).
- A ghost replay feature and special Walpurgis pursuits.
- Clear, maintainable code and structured Markdown documentation.

## Proposed first playable vertical slice

The current [product vision](product-vision.md#stage-2--vertical-slice) proposes one complete solo time-trial race on one track, with checkpoints, timing, finish/retry, HUD and representative art/audio. Ghost replay and split-screen are subsequent scope decisions, not prerequisites for this slice.

## Open decisions

- How the protagonist is selected or customized, and whether she is an additional playable racer outside story mode.
- How the friend, mechanic, coach/scout and eight established racers are introduced.
- Handling, boosts, collisions, drifting and shortcuts.
- Championship progression, AI opponents and unlock conditions.
- Local multiplayer player count and release platforms.

See the [product vision](product-vision.md) for scope boundaries and the [decision log](../decisions/README.md) for approved direction.
