# Championship culture and the late reveal

**Status:** Design proposal, 2026-11-16. This extends [campaign progression](campaign-progression.md) and [the eight-racer ensemble](eight-racer-ensemble.md). Institutions, customs, clue placement and dialogue are candidates, not canon.

## Confirmed foundation

The protagonist begins racing for enjoyment, experimenting in her shed, potentially with a friend. No compulsory club or school. Her career progresses from grassroots competition toward international championships. The sport is genuinely popular; its organizers secretly cultivate successive generations of skilled racers to survive and recapture Walpurgis. The secret becomes clear around 70–80% of authored story-track progression. All eight established witches participate in the multi-stage seal; the separate protagonist's role and exact participant/controller count remain unresolved.

## Make the sport worth caring about

| Level | Candidate public-facing culture | Narrative function |
| --- | --- | --- |
| Local | Volunteers, handwritten entry boards, families watching a short circuit | Racing is accessible; the protagonist chooses to enter |
| Regional | Recognizable course traditions, local record boards, returning competitors | Build familiarity with the sport and its places |
| National | Formal timing, commentators, technical inspections, established contenders | Demonstrate increasing skill and stakes |
| International | Shared sporting rules, visiting racers, ceremonial opening, public celebration | Make the championship feel like a culmination before the reveal |

These are presentation ideas, not requirements for crowds, simulation of spectators, explorable venues, an economy, or a fixed number of cups. The engineer may notice inspection practices; the mentor may explain technique; rivals care about results. Neither supporting character must know the secret.

## Organizer models — alternatives

| Model | Strength | Risk |
| --- | --- | --- |
| Sporting federation with a small informed inner circle | Ordinary public sport and secrecy can coexist | Must explain who authorizes the hidden preparation |
| Wardens embedded in championship leadership | Connects recovered lore to the modern sport | Risks making every sporting institution feel sinister |
| Independent organizers cooperating with a ritual-keeping group | Distinguishes genuine sporting goals from capture duties | Adds institutions and exposition |

**Recommendation for exploration:** A public sporting organization with a limited informed group, potentially connected to the Wardens. This is not approval of a federation, named leaders, a particular secrecy policy or Warden canon. Most participants can sincerely care about sport. The confirmed motivation is generational preparedness, not deliberate sacrifice or a rigged championship.

## Foreshadowing without spoiling the premise

| Authored campaign window | Candidate clue | Ordinary interpretation | Later meaning |
| --- | --- | --- | --- |
| Opening–local | Repeated geometric course emblem | Regional sporting logo | Echo of sealing geometry |
| Regional | Coach values reliable lines and recovery, not just speed | Good racing instruction | Skills useful during pursuit |
| National | An old record or ceremonial reference to generations of racers | Sporting history | Long-term preparation |
| International, before reveal | Organizers discuss readiness and a rarely used course | Preparation for a prestigious event | Preparation for the capture |
| Around 70–80% | An informed organizer explains the purpose and demonstrates the route's relationship to the seal | Not applicable: explicit reveal | Recontextualizes earlier clues |
| After reveal | Racers apply their familiar skills to outer boundary, inner runes and convergence | Shared challenge | The sport's hidden purpose becomes playable |

Use the authored sequence of mandatory story-track milestones, not raw race attempts, optional events, scene views or elapsed time. Exact milestone count and rounding policy are open. A clue may be missed without making the reveal incomprehensible; the reveal itself should explain the necessary connection. Avoid opening with an escape scene or requiring players to solve a lore puzzle to advance.

### Candidate reveal scene

After a major championship milestone, a short briefing connects a familiar course emblem to the overhead seal schematic. The organizer explains why successive generations have been trained through racing. The protagonist and her peers can react differently; their reactions and the ethics of secrecy are open. The next playable objective demonstrates the connection through racing rather than a long lore lecture. Do not force a championship loss or imply that the protagonist was secretly chosen from birth.

## Scope and technical boundaries

- Keep authored clue and reveal eligibility in campaign/narrative policy, consuming validated progress. Race simulation must not depend on dialogue, ceremony, character knowledge or scene timing.
- A stable milestone identifier and an authored reveal boundary are candidate content contracts. Validate ordering and references before loading campaign content; do not introduce a generic quest engine for this.
- Treat pre-reveal and post-reveal narrative content as explicitly gated. Optional callbacks can remain available if they do not contradict current knowledge.
- Keep the seal HUD driven by authoritative route completion as specified in [final-race design](walpurgisnacht-final-race.md); narrative knowledge does not activate a rune.
- Preserve the existing deterministic simulation contract and golden replay fixtures. No new physics, AI or engine upgrade is required for this proposal.
- A future narrative prototype can demonstrate one public race, one innocuous clue and a separate reveal scene using placeholder content; the full championship is not a vertical-slice dependency.

## Candidate acceptance checks — not executed

| Given | When | Then |
| --- | --- | --- |
| Campaign before the authored reveal | A player repeats an optional race | Reveal remains ineligible |
| A valid result crosses the reveal milestone | Campaign policy evaluates it | Reveal becomes eligible exactly once |
| A player misses every optional clue | The reveal is presented | Required explanation is still available |
| A pre-reveal save is restored | Narrative eligibility is evaluated | No post-reveal scene is selected |
| A reveal has been completed | The same result is submitted again | No duplicate reveal or progression |
| Identical race inputs and rules | Clue text or ceremony changes | Authoritative race result and replay hash are unchanged |
| A reveal scene completes | No validated seal route has been completed | No seal objective is activated |

Test pure eligibility and content validation first, then save/load and presentation integration. Manual review should check that the opening feels like sport, clues are plausible in hindsight, and the reveal does not require optional content. These are proposed specifications, not implemented tests.

## Decisions for owner review

- Who organizes the public sport and who knows its hidden purpose?
- Are Wardens part of the current setting, and what historical details survive from recovered lore?
- How much secrecy is justified, and how do racers react after learning the truth?
- Which recurring sporting custom or symbol best connects ordinary courses to the seal?
- What championship milestone triggers the reveal, and how does the protagonist participate in the finale alongside all eight witches?

See [product vision](product-vision.md), [recovered lore](walpurgisnacht.md), [protagonist and friendship](protagonist-and-friendship.md), and [deterministic simulation](../architecture/deterministic-simulation.md).
