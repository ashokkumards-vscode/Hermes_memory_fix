# Hermes Working-Memory Patch

Minimal patch bundle extracted from commit
[`e92433e8`](https://github.com/ashokkumards-vscode/hermes-working-memory/commit/e92433e8f5aeb1b5a364041efb267dc7cba3a43c).

## Files changed by the patch

1. `agent/context_engine.py`
2. `agent/conversation_loop.py`
3. `plugins/context_engine/working-memory/.gitignore`
4. `plugins/context_engine/working-memory/__init__.py`
5. `plugins/context_engine/working-memory/plugin.yaml`
6. `plugins/context_engine/working-memory/state_extractor.py`

## Bundle contents

- `hermes-working-memory.patch` — unified patch for the six files.
- `apply-working-memory-patch.sh` — validates, backs up and applies it.
- `README.md` — this manifest.

No API keys, tokens, configuration, session data, generated state or credential
files are included.

## Apply

```bash
chmod +x apply-working-memory-patch.sh
./apply-working-memory-patch.sh ~/.hermes/hermes-agent
```

The installer verifies the target, detects an already-applied patch, runs
`git apply --check`, backs up existing affected files beneath
`~/.local/state/hermes-working-memory-patch/backups/`, applies the patch and
runs Python syntax checks. It does not restart Hermes automatically.

## Compatibility

Created against parent commit
[`86b2057a`](https://github.com/ashokkumards-vscode/hermes-working-memory/commit/86b2057a1b3365b93cedf1ea9b1962dfc6b08170).
If `git apply --check` fails on a newer Hermes release, do not force it;
regenerate or rebase the patch for that release.

