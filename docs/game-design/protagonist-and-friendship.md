# Protagonist and friendship arc

**Status:** Proposal for review. This develops the [campaign opening](campaign-progression.md) and [engineer friend](engineer-friend.md), not new canon or gameplay requirements.

## Established constraints

The protagonist is a female amateur witch, separate from the eight established racers. She wants to race her broom and experiments in her shed, potentially with a friend. The opening is friendly and self-motivated, not a school or club enrollment. Her sporting career grows toward international competition; the hidden purpose of the championships emerges around 70–80% of story-track progression. Her name, appearance, background, selection rules and exact finale role remain open.

## Proposed character direction

**Core desire:** Become a better racer because flying fast is exhilarating. She seeks the next challenge before she seeks fame.

**Strength:** Enthusiasm becomes action. She is willing to try a new line, enter an unfamiliar race and learn from someone faster.

**Growth edge:** She sometimes confuses going faster with racing better. She can learn patience, preparation and trust without losing her exuberance. Avoid making her recklessness a mandatory player mistake or treating her friend as a permanently responsible babysitter.

**Relationship:** Both friends are energetic enthusiasts. The protagonist loves the experience of flight; the engineer loves discovering how magical mechanisms work. Each has expertise the other values. Their friendship should survive disagreement and have moments unrelated to winning.

### Alternative emphasis (not mutually exclusive)

| Direction | Dramatic strength | Risk |
| --- | --- | --- |
| Playful experimenter | Naturally motivates shed and practice scenes | Too similar to engineer if both care primarily about mechanisms |
| Ambitious sports enthusiast | Strong reason to enter competitions and follow rivals | Can make early friendship feel instrumental |
| Improvisational pilot | Distinctive relationship to racing lines and unexpected challenges | Can imply unapproved risky mechanics or forced failures |

**Recommendation:** Combine the sports enthusiast's ambition with the improvisational pilot's curiosity. Let the engineer lead technical discoveries; let the protagonist lead decisions about racing. No new stats, abilities or character-specific physics follow from this proposal.

## Proposed relationship beats

| Campaign moment | Protagonist choice | Friend's independent contribution | What the player sees |
| --- | --- | --- | --- |
| Shed and first practice | Volunteers to test an idea | Suggests a specific experiment and what to observe | Short exchange, then playable race |
| First local event | Decides to enter even without a perfect broom | Helps prepare and chooses to attend or pursue her own work | Optional pre-race scene |
| Regional challenge | Asks for advice after encountering a stronger field | Explains a trade-off, not a guaranteed upgrade | Brief post-event conversation; retry remains available |
| National competition | Takes a rival seriously and changes her approach | Pursues an engineering question of her own | Workshop callback or optional dialogue |
| International championship | Recognizes that preparation and cooperation matter as much as speed | Shares a discovery or celebrates a craft achievement | A payoff to the early experiment, without mandatory equipment progression |
| Late reveal | Decides how to respond to the championships' hidden purpose | Reacts as a person with her own concerns and choices | Short scene after the authored reveal milestone |

These beats are candidates, not a fixed scene list or required race outcomes. The engineer's racing status and involvement in the finale are unresolved. Do not imply that she builds the seal, knows the secret early, or must be present in every event.

## Mentor and rival boundaries

A coach/scout may notice the protagonist in practice or at a local competition. Their role is to offer sporting insight or an opportunity, not to supply her ambition. An established racer could become a recurring rival through repeated encounters; the rival should have an independent goal rather than exist solely to lose to the protagonist.

Keep three voices distinct: the protagonist asks what she can do on the track, the engineer asks how the broom works, and the mentor asks how to race effectively against a field. No permanent mentor, named rival or specific roster assignment is approved.

## Scene sketches — original examples, not final dialogue

**Before practice:**  
Protagonist: "I think I can take that bend without slowing down."  
Engineer: "I think the binding can take it. Those are two very different experiments."  
Protagonist: "Excellent. Two experiments!"

**After a difficult race:**  
Protagonist: "She was already turning before I even thought about it."  
Engineer: "So it wasn't the broom?"  
Protagonist: "Not this time. I want another go."

The second exchange illustrates learning without requiring a scripted defeat. Use neutral alternatives when the player wins; narrative should not contradict actual race results.

## Scope and implementation guardrails

- First narrative prototype: one short shed exchange, one practice race and one optional post-race exchange. Reuse the proposed solo time-trial vertical slice; do not add a walkable hub, crafting system, upgrade economy or AI race just to demonstrate friendship.
- Keep narrative identity, cosmetic racer identity and controller assignment distinct. A story protagonist is not automatically a ninth selectable racer or ninth finale participant.
- Narrative eligibility observes validated campaign outcomes. Dialogue, animation and scene transitions cannot mutate authoritative race state or alter deterministic replay inputs.
- Use stable scene/event identifiers and explicit eligibility rules only when implementation is approved. Avoid introducing a general dialogue engine before the first authored scene demonstrates a need.
- Future TDD examples: an abandoned practice does not unlock a completion-only scene; replaying an already completed milestone does not duplicate a one-time scene; optional dialogue cannot advance the reveal; a win does not trigger dialogue that asserts a loss. Test eligibility as pure policy before scene integration.
- Manual review: the protagonist initiates the first race, both friends have recognizable interests, the coach does not replace their agency, and the opening does not reveal Walpurgisnacht's secret.

See [campaign policy and acceptance examples](campaign-progression.md), [product vision](product-vision.md), and [simulation architecture](../architecture/deterministic-simulation.md). No code or tests are implemented by this proposal.

## Decisions still open

1. Fixed authored protagonist or player-customizable identity; name, appearance and voice.
2. Whether the engineer is a fellow racer, dedicated mechanic or both, and what independent ambition she pursues.
3. Which mentor introduction and recurring rival relationship best fit the opening.
4. Whether the protagonist's growth emphasizes technique, confidence, teamwork or a combination.
5. How the separate protagonist participates in the final sealing race while preserving all eight established witches' involvement.

See [first rival and established racers](first-rival-and-established-racers.md) for candidate competitive relationships, gradual roster introductions and result-aware encounter tests.
