# Witch Racer visual plan

**Status:** Working plan, updated 2026-11-16. Confirmed project constraints are separated from proposals; this document is the art-direction source of truth. See [game vision](../game-design/README.md), [racer roster](../game-design/characters.md), [story](../game-design/story.md), and [reference boards](#boards).

## Confirmed foundation

- High-speed arcade track racing inspired by *F-Zero GX*: banked, steep and inverted track sections; chase-camera framing; magical hazards and boosts; limited vertical freedom rather than unrestricted flight.
- Blender-authored low-poly, PSX-inspired 3D assets; eight distinct playable witches; single-player and local multiplayer; special Walpurgis chase races.
- Drummyfish's hand-painted low-poly model is the selected style anchor for environment fillers. It is a reference for craft and readability, not a license to copy its individual designs.

## Visual principles

1. **Read at speed:** communicate route, surface, hazard, boost and opponent with silhouette, value and placement before texture detail.
2. **Make the track dominant:** the racing surface and its edges remain the strongest continuous read. Decoration frames turns and landmarks without crossing the racing line.
3. **Use controlled detail:** simple faceted geometry and restrained hand-painted texture variation; spend detail on close racers, landmarks and interaction cues.
4. **Keep motion legible:** maintain consistent camera-relative cues for banking, elevation, jumps and inversion. Reserve intense motion blur and screen effects for brief, tested moments.
5. **Separate play from spectacle:** effects frame the vehicle and target lane; visual intensity never hides checkpoints, boundaries or hazard timing.
6. **Own the visual system:** use source art as licensed study/reference. Create original Witch Racer silhouettes, symbols and magical motifs; do not lift culturally specific sacred designs.

## Palette and materials — proposal

Use a small per-track palette organized by function: one dominant environment family, a contrasting track value, a high-contrast edge/readability color, and sparse boost/hazard accents. Test night and daylight variants without assuming cyberpunk or early-2000s styling. Materials should stay matte or gently varied by default; use emissive surfaces only for gameplay-significant cues. Exact hues, texture filtering, fog and lighting remain undecided pending in-engine comparisons. [Board 03](palette-material-board-03.md) informs a forest-route test, not a global palette lock.

## Shape language

- **Track:** broad continuous ribbons with visible shoulders, barriers and banking; silhouettes should make the next curve obvious from chase view.
- **Racers:** one distinctive head/hair/hat outline and one secondary outfit or broom cue per witch. Avoid relying on hair color alone.
- **Props:** chunky, low-poly environmental fillers with a few broad planes; use size and placement to create route rhythm.
- **Hazards/boosts:** consistent, distinct shape families with clear approach, active and recovery states. Do not encode meaning by color alone.

## Eight racer differentiation

Keep all eight recognizable in a small split-screen view. Preserve the six established hair-color families (blue, yellow, green, red, purple and mixed) while giving every racer an independent silhouette, outfit value pattern and small icon. Current names and hooks in the [roster](../game-design/characters.md) remain proposals. Cosmetic variation should not obscure broom/pose readability or imply unapproved gameplay advantages.

## Brooms and magical propulsion — proposal

Treat the broom as the vehicle silhouette and animation anchor. Build varied original handle/brush profiles around a shared rider scale, attachment point and readable forward direction. Propulsion should originate consistently behind the rider; boosts can add a short, bright trail with a clear start/end cue. Keep materials and ornamentation original and avoid copying living religious or Indigenous objects.

## Tracks and environment

Compose each route in layers: immediate track and barriers; nearby landmarks that forecast bends; distant low-detail silhouette and sky. Use bank shape, edge treatment, landmark rhythm and perspective to support limited vertical freedom and inversion. Test an unobstructed route in split-screen before filling the margins. Drummyfish-inspired environment fillers can establish a modular kit (ground, tree, rock, sign, landmark); vary placement and silhouette to avoid repetition.

## Effects and hazards

Use a compact effect vocabulary: normal propulsion, boost, collision/damage, collectible or checkpoint, hazard warning, hazard active, and Walpurgis pressure. Each needs distinct silhouette, timing and brightness. Keep particles low-count and short-lived at racing speed. Ensure trails and flashes do not hide the track edge or another racer.

## Walpurgis chase races

Give Walpurgis a readable threat silhouette and persistent rearward presence in chase framing. Escalate with distance, shadow/lighting and audio-linked visual cues while preserving forward route visibility. A catch/failure state and any rare escape boost need clear, fair telegraphing. These are design requirements; the exact character form and folklore treatment remain open and must be original, contextual and non-extractive.

## UI, typography and menus — proposal

Prioritize quick readability in one-player and split-screen: stable placement, large numerals, clear lap/checkpoint state, distinct racer markers, and text paired with icon/shape cues. Avoid a screen-filling HUD; test at actual viewport sizes. Use a compact typographic hierarchy and original symbols. No typeface or menu aesthetic is selected yet.

## Production constraints and validation

- Establish Blender-to-Godot scale, naming, pivots, material count, texture import and animation conventions with a small sample asset before setting budgets.
- Compare low-resolution/texture-filtering options, fog, lighting and polygon density in the actual chase camera and local split-screen.
- Prototype one track section with a banked turn, one inversion/steep segment, one boost, one hazard, two racer silhouettes and a small environment kit.
- Check distance readability, contrast, motion comfort, frame time and asset reuse before expanding. Keep meshes/materials modular and avoid expensive unique details where repeated pieces suffice.
- No final polygon, texture, resolution or performance budgets are approved yet.

## Consistency checklist

- [ ] Track shape and edge remain readable in chase view and split-screen.
- [ ] Banking/inversion reads as track geometry; vertical movement stays bounded.
- [ ] Each witch reads by silhouette and value pattern, not hair hue alone.
- [ ] Broom and propulsion direction are immediately clear.
- [ ] Boost, hazard, checkpoint and Walpurgis cues are distinguishable without color alone.
- [ ] Filler assets frame the route without obscuring racing lines or sightlines.
- [ ] Special chase pressure is legible and fair; forward route remains visible.
- [ ] References have verified reuse terms and creator/source/license links.
- [ ] Sacred or living cultural practices are not copied as decoration.
- [ ] Visual changes are tested at intended camera distance and local-player viewport sizes.

## Boards

- [Reference board 01](reference-board-01.md) — broad environment, track and night-light references.
- [Environment filler board 02](environment-filler-board-02.md) — Drummyfish low-poly props and terrain.
- [Palette and materials board 03](palette-material-board-03.md) — forest environment, ground material and light studies for one route palette.

## Open decisions

Choose the first track's setting; compare day/night presentation; settle final palette and material treatment; decide texture filtering, fog and vertex wobble; confirm UI hierarchy and typography; define Walpurgis' original silhouette and chase cues; establish asset budgets after prototype measurements.
