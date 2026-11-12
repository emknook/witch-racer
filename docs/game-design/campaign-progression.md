# Campaign opening and competition progression

**Status:** Design proposal for review. Confirmed constraints are distinguished from candidate scenes, progression rules and technical designs. This document extends the [product vision](product-vision.md) and [engineer friend exploration](engineer-friend.md); it does not establish new canon.

## Confirmed constraints

- The female protagonist is separate from the eight established witches. Her playable status outside the story remains open.
- She begins as an amateur who loves racing her broom and experiments in her shed, potentially with a friend. No mandatory racing school or club.
- Competition grows from grassroots to international championships.
- The secret purpose of the championships is revealed around 70–80% of story-track progression, not during the opening.
- The [final sealing race](walpurgisnacht-final-race.md) involves all eight established witches. How the additional protagonist fits into the previously specified eight-participant format is unresolved.

## Proposed opening: one small experiment

| Beat | Player experience | Narrative purpose |
| --- | --- | --- |
| Shed | Brief interaction or scene around a broom experiment | Establish enthusiasm, friendship and a personal goal |
| Practice | Fly a short marked route, learn steering and acceleration | Let the player experience racing before explaining the sport |
| Retry | Optional repeat with a visible time improvement | Establish mastery and the friend's curiosity |
| Opportunity | A coach notices the run, or a local event offers an entry | Introduce competition without a destiny or institutional obligation |
| First event | Complete a short official race | Give the protagonist a tangible sporting achievement |

The experiment can be represented by dialogue, props and animation. It does not require a crafting system, stat upgrades, a walkable hub or a second flight model. A single authored circuit can support practice and the first event if the presentation distinguishes them.

### Mentor/scout alternatives

| Option | Benefit | Risk |
| --- | --- | --- |
| Coach notices a practice run | Natural discovery, low-pressure start | Coincidence feels contrived unless the coach has a reason to be nearby |
| Coach sees a local competition | Achievement earns attention; sport already feels real | Requires a credible way to enter the first event |
| Experienced racer offers advice | Peer relationship, less formal hierarchy | May blur the role of an established rival |

**Recommendation for review:** Local competition as the first public achievement, with an optional practice encounter introducing the coach earlier. The coach offers advice or an opportunity, not automatic qualification or a permanent club membership. The protagonist chooses to enter.

The friend and coach should not duplicate one another: the friend explores the broom and shares the protagonist's excitement; the coach understands racing lines, competition and sporting expectations. Neither needs to be a mandatory tutorial narrator.

## Proposed campaign ladder

| Phase | Sporting goal | Character opportunity |
| --- | --- | --- |
| Amateur opening | Complete practice and enter a local event | Establish protagonist and friend |
| Local competition | Earn a credible result | Meet first recurring rival or mentor |
| Regional competition | Demonstrate consistency on unfamiliar tracks | Learn that speed alone is insufficient |
| National-level competition | Compete with experienced racers | Introduce more established witches |
| International championship | Race against the strongest field | Rivalries mature into mutual respect |
| Late reveal and finale | Understand the championships' hidden purpose and participate in the sealing event | Sporting skills become meaningful beyond trophies |

These are narrative tiers, not a promise of six cups, six tracks, specific geography, or a fixed number of races. Reuse tracks only where it serves mastery and pacing. The eight established witches can appear gradually; their exact introduction order and relationships remain open.

### Progression policy candidates

- **Completion-based:** finishing a valid event unlocks the next one. Accessible, but may make competitive achievement feel less consequential.
- **Qualification-based:** a placement or time threshold unlocks the next event. Strong sporting stakes, but may frustrate less experienced players.
- **Hybrid:** early events reward completion; later qualification uses forgiving thresholds with retries. Recommended for exploration, not approved.

Avoid assuming a currency economy, equipment gates, branching campaign, mandatory podiums or an upgrade tree. A failed qualification should offer a clear retry rather than erase previous progress.

## Pacing and the reveal

Use a planned sequence of story-track milestones rather than counting retries, practice sessions or optional time trials. The reveal belongs near the 70–80% point of the authored story-track sequence. For example, a hypothetical ten-milestone campaign could reveal the secret around milestone seven or eight; this is illustrative, not a content commitment.

Before the reveal, clues should be compatible with an ordinary sporting world: unusual track markings, organizers discussing preparedness, or a recurring historical symbol. Do not explicitly explain the capture ritual in the tutorial. After the reveal, the [finale](walpurgisnacht-final-race.md) should recontextualize the skills the player has already learned.

## Architecture implications — proposed, not implementation tasks

Separate campaign progression from the authoritative race simulation. A race reports a validated outcome; a campaign policy decides whether that outcome advances an event. Presentation renders the resulting state and plays narrative beats. Do not let dialogue, scene transitions, UI buttons or wall-clock time determine authoritative race completion.

| Responsibility | Candidate contract |
| --- | --- |
| Race simulation | Existing deterministic tick-based race rules; validated result with event identity, completion status and relevant performance data |
| Campaign policy | Pure evaluation of current progress, event definition and validated result; returns next progress and unlocks |
| Campaign persistence | Save versioned progress and stable event identifiers; validate loaded state |
| Presentation | Render unlocked events, show feedback and trigger eligible scenes without changing race rules |

Keep character identity separate from controller assignment and race participation. This avoids encoding the protagonist as a ninth racer or assuming the finale has nine participants before those decisions are made. Local multiplayer campaign ownership and progression are also open.

See [architecture](../architecture/README.md) and [deterministic simulation](../architecture/deterministic-simulation.md). Implement only after the relevant product decisions and vertical-slice priorities are approved.

## Acceptance examples for a future campaign prototype

These are candidate TDD scenarios, not executed tests.

| Given | When | Then |
| --- | --- | --- |
| An unfinished practice event | A player exits early | No completion or unlock is recorded |
| A valid result for the current event | The configured qualification policy is satisfied | The next event becomes available |
| A valid result below the threshold | Qualification is required | The current event remains retryable |
| An already applied result | The same result is submitted again | Progress is unchanged |
| A result for an unknown or locked event | It is submitted to campaign policy | It cannot unlock unrelated content |
| A saved campaign before the reveal | The player repeats practice or optional races | The reveal milestone does not advance |
| A completed milestone | Progress is saved and restored | Unlocks and eligible narrative beats are preserved |
| Identical initial progress and result sequence | The policy is evaluated twice | The resulting progress is identical |

Test pure policy behavior first, then persistence round trips and presentation integration. Existing deterministic replay fixtures should remain unchanged by campaign-only work. Manual acceptance should check that the opening feels friendly, the first race is understandable, and the reveal is not spoiled.

## Decisions for owner review

1. Whether the first public race or a practice encounter introduces the coach.
2. Whether the friend also races, and whether the shed is a recurring scene or interactive space.
3. Whether progression uses completion, qualification or a hybrid.
4. How the protagonist participates in the eight-witch finale and in non-story modes.
5. Whether local multiplayer shares campaign progression or remains a separate mode.

No implementation or final character identity is approved by this proposal.
