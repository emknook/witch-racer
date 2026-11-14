# First rival and established racers

**Status:** Proposal for review, 2026-11-14. Extends [campaign progression](campaign-progression.md) and [protagonist and friendship](protagonist-and-friendship.md). No character assignment, race format, roster size or implementation is approved here.

## Design purpose

The friendly shed opening establishes why the protagonist loves racing. Her first recurring competitor should establish why racing against other people is different from testing a broom alone. The competitor has a sporting goal of her own, can win or lose without losing credibility, and gradually becomes someone the protagonist respects. Cooperation in the finale should feel like an extension of that respect, not a sudden personality change.

Confirmed constraints: the protagonist is separate from the eight established witches; the campaign advances from grassroots to international competition; the secret purpose of the championships is revealed around 70–80% of story-track progression. All eight established witches participate in the final sealing event. The protagonist's exact role and participant count remain unresolved.

## Three candidate first encounters

| Candidate | Independent motivation | Sporting contrast | Trade-off |
| --- | --- | --- | --- |
| Local peer | Earn a first meaningful result for herself or her hometown | Similar experience, different racing habits | Natural recurring friendship; may require a separate supporting character if not one of the eight |
| Visiting experienced racer | Improve a course record or prepare for a higher-level event | Consistency and anticipation versus the protagonist's improvisation | Introduces the wider sport early; needs a credible reason to attend a local event |
| Friendly technical rival | Demonstrate a particular flying technique | Precision versus experimentation | Strong thematic link to the shed; avoid duplicating the engineer's craft interest |

**Recommendation for review:** Start with a local peer, potentially one of the eight established witches at an earlier stage of her career. This preserves the grassroots atmosphere and allows the relationship to grow with the protagonist. If the eight are already elite when the story begins, use a separate local peer or a visiting racer instead. Do not assume either timeline is canon.

The coach/scout can observe the same event and offer advice or an entry opportunity, but the competitor should not become a tutorial narrator. The engineer remains the protagonist's craft-focused friend, not a rival by default.

## First encounter: candidate scene sequence

1. Before the local event, the competitor is preparing for her own run. A short exchange establishes what she hopes to achieve.
2. Both race under the same event rules. The protagonist's result is determined by play, not a mandatory scripted loss.
3. After the event, the competitor acknowledges a specific shared challenge (a difficult bend, timing or course layout). Result-dependent dialogue may add congratulations or encouragement.
4. A later event offers a rematch; the competitor has continued pursuing her own goals in the meantime.

Example neutral exchange, not final dialogue:

> Rival: "That last bend is a nightmare. I keep turning too late."
>
> Protagonist: "I keep turning too early. Want to compare notes?"
>
> Rival: "After the next race. I'm not giving you everything for free."

The exchange works whether the player wins or loses. Do not award a progression unlock through dialogue itself.

## Introducing the eight over time

Use the existing [roster sketches](characters.md) as a pool of proposals, not a finalized cast. Introduce racers in small groups so each has a recognizable sporting interest before the late reveal. The following are possible dramatic functions, not eight assigned characters or distinct mechanical classes.

| Function | Example sporting interest | Payoff before finale |
| --- | --- | --- |
| Recurring peer | Personal improvement and friendly rivalry | Mutual trust built through rematches |
| Technique specialist | Consistency and precise lines | Protagonist learns to observe other approaches |
| Record seeker | Course mastery and personal bests | Respect for preparation and practice |
| Experienced contender | Championship performance | Shows the standard of elite racing |
| Unconventional competitor | Proving an unusual approach can succeed | Broadens the protagonist's understanding of the sport |

These functions can overlap; not every witch needs a separate subplot. Existing working names, hair colors and motivations remain proposals. Do not assign one of the eight to a role without owner review, or introduce character-specific handling, stats, abilities or equipment requirements.

### From competition to cooperation

- Early: establish personal goals and recognizable racing styles through presentation and dialogue, without requiring distinct physics.
- Middle: recurring encounters show respect, disagreements and improvement; competitors remain free to pursue their own results.
- Late: the championship field becomes familiar enough that the hidden purpose matters personally. Foreshadow through ordinary sporting traditions, not explicit knowledge of the seal.
- Finale: the eight established witches contribute to the [multi-stage sealing race](walpurgisnacht-final-race.md). Earlier relationships can explain why cooperation feels earned, but no specific rune assignment or participant count is decided here.

## Scope and technical implications

A first rival can be demonstrated with one authored pre/post-race exchange around the existing time-trial slice. A visible ghost could later represent a benchmark if the replay feature is ready; a ghost is not an AI competitor and must not be presented as one. A true head-to-head event requires approved AI/race-mode scope. Do not add AI, dialogue frameworks or character-specific simulation solely to prototype the relationship.

Keep authored character identity separate from race participant identity, controller assignment and cosmetic selection. A campaign encounter may refer to a character and an event; it should consume validated outcomes through campaign policy rather than reading scene nodes or modifying authoritative simulation. A candidate result-aware dialogue policy can distinguish win, loss, completion without placement, and abandonment only when the corresponding result exists. Missing placement is not a defeat. Use stable identifiers and test pure rules before presentation integration.

### Candidate acceptance scenarios (not implemented)

| Given | When | Then |
| --- | --- | --- |
| A valid first event with a win | Post-event dialogue is selected | No line asserts the protagonist lost |
| A valid event with a loss | Post-event dialogue is selected | The competitor's independent goal remains coherent; retry is available under the configured policy |
| A time trial with no placement | Dialogue is selected | No head-to-head result is fabricated |
| An abandoned event | Completion-only encounter eligibility is evaluated | The encounter remains unavailable |
| A completed encounter | The same event is replayed | One-time introductions are not repeated |
| An optional rival conversation | The player views it | Race results, unlocks and reveal progress are unchanged |
| A pre-reveal campaign state | An encounter is selected | No post-reveal dialogue is eligible |

Manual review: the competitor feels like a person rather than an obstacle; both victory and defeat are narratively credible; the coach, friend and rival have distinct contributions; no early scene spoils Walpurgisnacht. Existing deterministic replay fixtures should remain unchanged by narrative-only work. See [simulation contract](../architecture/deterministic-simulation.md).

## Open decisions

- Are the eight established witches already elite at the opening, or do some advance alongside the protagonist?
- Is the first rival one of those eight, a separate local peer, or a visiting experienced racer?
- Which existing roster sketches should be developed into recurring characters, and which should remain optional?
- Does the first public event use time trial, qualification or an AI field?
- How does the separate protagonist participate in the finale without displacing any of the eight?

No new canon, gameplay code or executed tests result from this proposal.
