# Developer setup and automated validation

The project pins **Godot 4.7.2 stable** in [`.godot-version`](../../.godot-version). The engine is downloaded locally and **not committed to Git**. The download is from the official Godot GitHub release. The scripts currently support Linux x86_64 and Windows x64.

## Linux (Ubuntu)

From the repository root:

```bash
bash scripts/setup-godot.sh
.tools/godot/$(cat .godot-version)/godot --editor --path game
```

Requires `curl` and `unzip`.

## Windows (PowerShell)

From the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/setup-godot.ps1
.\.tools\godot\4.7.2\godot.exe --editor --path game
```

Use `pwsh -File scripts/setup-godot.ps1` if running PowerShell 7. PowerShell's download script requires internet access and Windows x64.

## Continuous integration

[`godot-validation.yml`](../../.github/workflows/godot-validation.yml) runs on pushes to `main`, pull requests and manual dispatch. Its Windows and Ubuntu jobs download the pinned engine, import the Godot project headlessly, smoke-test the main scene and compare the deterministic replay against the same checked-in golden digest.

**Limitations:** Replay tests cover simulation rules, not interactive feel, graphics or gamepad hardware. These checks do not export distributable builds. CI will only appear after the workflow file is present on GitHub and runs are permitted by repository settings. See the [simulation contract and local test commands](../architecture/deterministic-simulation.md).

## Updating the engine

Update `.godot-version` only after confirming a new **stable** release and testing compatibility. If changing versions, verify both platform-specific asset names and the workflow's expected engine path.

## Known validation gap

The original Linux workflow passed on GitHub. The expanded Windows/Linux determinism matrix has not yet run on GitHub; local deterministic replay checks pass on Windows.
