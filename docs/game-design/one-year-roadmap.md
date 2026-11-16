# Witch Racer — 12-month playable-baseline roadmap

**Period:** November 2026–November 2027  
**Status:** Planning baseline approved by owner on 2026-11-16: a **complete racing game loop**, at **4–6 hours/week**. The sequencing, estimates, feature allocation and dates below are **proposals** to validate through actual development, not promises.

See [product vision](product-vision.md), [game-design index](README.md), [architecture](../architecture/README.md) and [decision log](../decisions/README.md).

## Destination: a playable racing baseline

By November 2027, another person should be able to launch a build, select a playable witch, race a complete marked circuit alone or against basic AI, finish and see results, retry, and play a local two-player race with independent controls and readable views. The game should feel responsive and recognizable as a PSX-inspired broom racer, not just a technical sandbox.

**Baseline acceptance checklist**
- [ ] Launchable and reproducible desktop build on an agreed primary platform; documented controls and setup.
- [ ] One finished, readable track with start, ordered checkpoints, laps, boundaries and clear race completion.
- [ ] Responsive broom handling and camera, tuned through human playtests; keyboard and controllers supported as agreed.
- [ ] Solo time trial with valid timing, HUD, finish/results and restart/retry.
- [ ] At least one basic AI opponent completes the same track using the same racing rules and can be raced against.
- [ ] Two-player local multiplayer with separate input mappings, split-screen/readable cameras and race results.
- [ ] Representative low-poly witch, broom, course visuals, simple effects and essential audio feedback.
- [ ] Automated tests for deterministic rules (checkpoint order, lap validity, race state, timing, restart and AI/input invariants where feasible); repeatable CI on supported platforms.
- [ ] Manual smoke and playtest checklist completed, with no known baseline-blocking bugs.

**Explicitly not required for November 2027:** Eight polished racers, a full championship campaign, shed cinematics, multiple production-quality tracks, online multiplayer, elaborate character customization or the complete Walpurgisnacht ritual. These remain product-vision directions, not abandoned features.

**Ghost replay:** A confirmed game feature, targeted as a **stretch goal** after the complete solo/AI/local racing loop is reliable. Deterministic replay infrastructure may be developed earlier as an engineering aid. If progress is ahead of schedule, promote a visible non-colliding ghost into the baseline after playtesting.

## Capacity and planning rules

- 52 weeks × 4–6 hours = **208–312 nominal hours**.
- Plan around **200 productive hours** over the year; keep the difference for study/work interruptions, debugging, upgrades and playtesting. This is an estimate, not measured availability.
- Prefer tasks that fit **1–3 sessions**, with one demonstrable result per milestone. Use vertical slices rather than accumulating unfinished systems.
- Every development cycle starts with **exactly two high-leverage questions**; **wait for answers to both and explicit approval** before any repository work. Do not treat a scheduled run or silence as authorization.
- For each authorized change, branch from the **last active working branch**, open a focused **stacked draft PR targeting that parent branch**, and never merge without owner approval. When the parent is merged, reconcile the downstream base.
- TDD for new rules: focused failing test → minimal implementation → refactor; verify Godot import, replay/golden fixtures and CI rather than claiming unrun tests passed.
- Monthly review: actual hours spent, demo achieved, risks, and whether to cut or move scope. Reforecast instead of hiding delays.

## Milestones and exit criteria

| Window | Focus | Demonstrable exit | Budget (planning estimate) |
| --- | --- | --- | ---: |
| Nov–Dec 2026 | Stabilize foundation and handling | Reproducible Godot project; one controllable broom on test circuit; baseline input/simulation and smoke tests documented | 25 h |
| Jan–Feb 2027 | Complete solo lap loop | Ordered checkpoints, valid laps, timer, finish/results, restart; playable end-to-end time trial | 35 h |
| Mar–Apr 2027 | Handling, track and presentation | Tuned steering/camera; one coherent track with readable signage, HUD and representative low-poly art | 35 h |
| May–Jun 2027 | AI competition | At least one opponent drives valid laps; start/finish positions and results are consistent | 35 h |
| Jul–Aug 2027 | Local multiplayer | Two players with independent controls and readable views finish the same race; basic performance check | 35 h |
| Sep–Oct 2027 | Reliability and release path | Input/controller testing, race edge cases, basic sound, build packaging, automated + manual checks | 25 h |
| Nov 2027 | Baseline validation | Fresh-user playtest, blockers fixed, milestone build and documented known limitations | 10 h |
| **Total** | | | **200 h** |

**Milestone gates:** Do not start major new feature systems until the previous milestone has a demonstrable playthrough or a documented decision to defer its unmet criteria. Parallel art/documentation is fine when it supports the active gate.

## Recommended order within milestones

1. **Simulation before spectacle:** Checkpoints, lap timing and race lifecycle must be authoritative and deterministic; visuals react to rule events.
2. **Playable before polished:** A complete greybox solo race precedes detailed scenery and character art.
3. **One track, several modes:** Reuse the same course for solo, AI and split-screen rather than producing several incomplete tracks.
4. **Shared racer intent:** Human input and AI produce the same kind of race commands. Keep local multiplayer independent of scene-specific assumptions so future online play remains feasible.
5. **Vertical integration:** Menus, HUD, results, retry, camera and controller mapping should be exercised end-to-end before declaring the baseline done.

## Risks and scope controls

| Risk | Mitigation |
| --- | --- |
| Limited weekly hours and competing commitments | Track actual effort monthly; defer cosmetics/content before core race completion |
| Handling does not feel enjoyable despite passing tests | Short hands-on playtests every milestone; tune using observations, not only CI |
| AI pathing takes longer than expected | Begin with simple waypoint/track-following AI and one opponent; avoid advanced tactics |
| Split-screen performance or camera readability | Prototype two viewports early; define minimum hardware/platform before polishing |
| Story/art scope expands beyond baseline | Use one representative witch and one track; retain shed and Walpurgis work as post-baseline |
| Determinism or engine upgrades break replay | Version race rules and fixtures; verify latest stable Godot compatibility before upgrading |
| Stacked PR chain becomes hard to review | Small branches, clear parent links and regular base reconciliation after merges |

## Stretch goals (only after the baseline gates are secure)

1. Visible personal ghost replay with record/save/replay and non-colliding rendering.
2. Additional racer cosmetic variants or a second track.
3. Shed-based playable opening and friend/engineer interaction.
4. Early championship progression UI and narrative scenes.
5. Walpurgis chase prototype, separate from the full sealing finale.

## Next two owner decisions

1. **Handling:** For the first racing prototype, should the broom behave like a track-bound hover racer with banking and jumps, or allow more active vertical flight while still following a defined course? Recommend track-bound hover handling initially to control camera and collision complexity.
2. **Initial platform and controls:** Should the November 2027 baseline prioritize Windows + gamepads, Linux + keyboard/gamepads, or equal Windows/Linux desktop support from the start? Recommend selecting one primary playtest platform and maintaining automated smoke coverage on both.

These are unresolved and should be asked before starting the next implementation cycle.
