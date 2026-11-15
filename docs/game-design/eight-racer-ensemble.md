# Eight racers — ensemble exploration

**Status:** Proposal for owner review, 2026-11-15. The eight existing working names below are placeholders from [characters](characters.md), not approved identities. These sketches extend [first rival and established racers](first-rival-and-established-racers.md) rather than replacing the roster. No new canon, mechanical classes, race results or finale assignments are established.

## Design constraints

The female amateur protagonist is separate from these eight. Her friendly shed opening and sporting career remain the narrative spine; the engineer and possible mentor retain independent roles. The eight may be at different career stages when introduced; “established” refers to the planned cast, not necessarily professional status at the opening. Their eventual cooperation in the sealing ritual is confirmed, but the protagonist's role, participant count and controller assignments remain unresolved. Do not reveal the championship's secret before the authored 70–80% story-track milestone.

## Candidate ensemble

| Working identity | Sporting ambition and temperament | Candidate introduction | Relationship and growth |
| --- | --- | --- | --- |
| Azure (blue) | Prove that disciplined flying beats flashy magic; observant, dry humor, quietly competitive | Regional precision event; could be a developing peer or experienced visitor | Challenges the protagonist's improvisation; learns that experimentation can complement preparation |
| Sunny (yellow) | Bring a trophy home; outgoing, remembers competitors' names, celebrates small improvements | Local competition; strongest candidate for a recurring peer | Friendly rematches become a shared sporting history; learns to pursue her own goals rather than everyone's approval |
| Moss (green) | Protect a beloved woodland route; patient, practical, dislikes waste | Regional woodland event | Introduces care for the places that host the sport; learns to accept help rather than carrying responsibility alone |
| Ember (red) | Break a legendary course record; intense, direct, privately meticulous | National record attempt or time-trial exhibition | Respects the protagonist's persistence; learns that a personal best and a good competitive result are different achievements |
| Violet (purple) | Understand the tournament's unusual traditions; curious, composed, enjoys puzzles | National event with an odd ceremonial detail | Shares questions rather than secret answers; learns when to trust others with uncertainty |
| Twilight (blue–purple) | Validate a self-built broom; methodical, delighted by unexpected data | Regional or national technical exhibition | Connects with the engineer as a fellow craft enthusiast, but prioritizes testing through racing; learns to distinguish a failed experiment from a failed race |
| Blaze (red–yellow) | Finally beat a familiar rival; theatrical, generous in victory, impatient with herself | National or international rematch | Makes rivalry feel joyful rather than hostile; learns that a rival's success need not diminish her own |
| Prism (multicolor) | Demonstrate that unconventional magic belongs in racing; inventive, socially confident, dislikes rigid assumptions | International event, or earlier as a developing competitor | Broadens the protagonist's view of racing styles; learns that collaboration need not mean conformity |

These are deliberately compact hooks, not eight required character arcs. Career stages, hometowns, relationships, names, pronouns and visual designs need review. No sketch grants a different handling model, magical ability, item, upgrade or AI advantage.

## Relationship structure

A small number of recurring relationships can make the field memorable without requiring every possible pairing.

- **Protagonist ↔ Sunny:** candidate local peer; their first race and rematch establish mutual ambition. If the eight must already be elite, Sunny could instead be a visiting competitor or the local peer could be a separate character.
- **Protagonist ↔ Azure:** contrasting approaches to technique; avoid implying that improvisation is always inferior.
- **Engineer ↔ Twilight:** exchange technical observations; neither replaces the other's independent craft interest. Twilight's focus is testing a broom in competition, the engineer's focus is understanding and making it.
- **Ember ↔ Blaze:** optional contrast between chasing a record and chasing a rival; do not assume they are each other's established rival.
- **Moss ↔ Prism:** optional discussion of how different racing traditions can coexist with care for a course.
- **Violet ↔ ensemble:** notices recurring sporting customs but has no confirmed early knowledge of Walpurgisnacht.

The mentor/scout offers sporting opportunities and advice; none of these eight is automatically the mentor. Avoid mandatory hostility, scripted losses, or dialogue that makes the player responsible for another character's success.

## Introduction budget — proposal

Use one recognizable action or exchange on introduction, one optional callback in a later event, and one cooperative payoff where appropriate. A single scene can introduce two racers if their goals remain legible. The local peer gets the most repeated exposure; other racers can remain lightweight.

Example first encounter (not final dialogue):
> Sunny: “I'm taking a photo of the results board. First proper race!”
>
> Protagonist: “Even if we don't win?”
>
> Sunny: “Especially then. We'll need something to compare it with next time.”

Example technical contrast:
> Twilight: “The broom did exactly what I predicted.”
>
> Engineer: “Then why are you looking at the binding?”
>
> Twilight: “Because I predicted the wrong thing.”

Neither exchange depends on a particular race outcome. Introduce Violet's curiosity through ordinary traditions, never an explicit early explanation of the seal.

## Production and architecture boundaries

- Author stable character identifiers independently of placeholder display names, hair colors, participant slots and controller assignment. A narrative introduction does not imply a playable unlock.
- Keep shared racing physics and deterministic replay inputs unchanged by character dialogue, visual identity or relationship state. Distinct racing philosophies can be expressed through presentation first; AI behavior differences require separate approved design and deterministic tests.
- Use the existing campaign/narrative eligibility proposal, not a new relationship-stat subsystem. No affection meter, branching dialogue engine or eight-character campaign is required.
- For PSX-style readability, evaluate silhouette, value contrast and accessories in actual race-camera and split-screen views; hair color alone is insufficient. Coordinate with [art direction](../art/README.md).
- A first narrative prototype can use the protagonist, engineer and one candidate peer around the solo time trial. The full ensemble is later content, not a vertical-slice prerequisite.

## Candidate acceptance checks (not implemented)

| Given | When | Then |
| --- | --- | --- |
| A character has been introduced | A completed event is retried | One-time introduction is not repeated |
| A character's display name changes | A saved introduction is loaded | Stable identity still resolves |
| A time trial has no placement | A rival callback is selected | No invented win or loss |
| Campaign is before the reveal | Violet's encounter is eligible | No explicit secret or seal explanation |
| A character is introduced in story | Selection menu is opened | No unlock unless approved selection policy grants it |
| Identical race inputs and rules | Cosmetic or dialogue content changes | Authoritative replay outcome remains identical |

Manual review: each racer can be described without reference to hair color; the engineer and Twilight are distinguishable; rivals remain credible after both wins and losses; the player can recognize the ensemble before the finale. These checks are specifications, not executed tests.

## Decisions for owner review

1. Which of the existing eight sketches should survive, change substantially or be replaced?
2. Is Sunny (or another of the eight) the local peer, or should that role be separate?
3. Which racers are already elite, and which grow alongside the protagonist?
4. Is Twilight's craft overlap with the engineer useful, or should one have a different ambition?
5. Which relationships deserve recurring scenes, and which can remain background flavor?
6. How does the separate protagonist participate in the finale while preserving all eight witches' involvement?

See [campaign progression](campaign-progression.md), [protagonist and friendship](protagonist-and-friendship.md), [engineer friend](engineer-friend.md), [finale](walpurgisnacht-final-race.md) and [simulation contract](../architecture/deterministic-simulation.md).
