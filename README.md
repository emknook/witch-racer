# Witch Racer

A work-in-progress arcade broom-racing game concept using Godot and PSX-inspired Blender assets.

## Start the game

From the repository root on Windows:

```powershell
.\start
```

On Linux:

```bash
bash scripts/start-game.sh
```

The launcher installs the pinned Godot version if needed (internet required on first run), then starts the game. Both scripts also work from other directories when called by their full path. Extra Godot arguments are forwarded, for example `--headless --quit-after 120` for a smoke check or `--editor` to open the editor.

For installation and CI, see the [developer setup guide](docs/development/README.md). Try the [first handling prototype](game/README.md), or start with the [design documentation](docs/README.md), including the [game vision](docs/game-design/README.md), [eight playable racers](docs/game-design/characters.md), [story](docs/game-design/story.md), [technical architecture](docs/architecture/README.md), and [research backlog](docs/research/README.md).

**Status:** Early design. Proposed character names and story details are not yet approved. The first playable milestone is a focused racing vertical slice.
