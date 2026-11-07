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

[`godot-validation.yml`](../../.github/workflows/godot-validation.yml) runs on pushes to `main`, pull requests and manual dispatch. It downloads the pinned engine on a GitHub-hosted Ubuntu runner, imports the Godot project headlessly, and runs a short scene smoke test.

**Limitations:** These checks are not gameplay tests and do not export distributable builds. They do not validate feel, gamepad input or Windows runtime behavior. CI will only appear after the workflow file is present on GitHub and runs are permitted by repository settings.

## Updating the engine

Update `.godot-version` only after confirming a new **stable** release and testing compatibility. If changing versions, verify both platform-specific asset names and the workflow's expected engine path.

## Known validation gap

These scripts and workflow were authored without executing the GitHub Actions workflow. Verify the first CI run and adjust if it reveals project or runner issues.
