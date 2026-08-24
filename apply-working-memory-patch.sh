#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-$HOME/.hermes/hermes-agent}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PATCH_FILE="$SCRIPT_DIR/hermes-working-memory.patch"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
BACKUP_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/hermes-working-memory-patch/backups/$STAMP"

FILES=(
  "agent/context_engine.py"
  "agent/conversation_loop.py"
  "plugins/context_engine/working-memory/.gitignore"
  "plugins/context_engine/working-memory/__init__.py"
  "plugins/context_engine/working-memory/plugin.yaml"
  "plugins/context_engine/working-memory/state_extractor.py"
)

if [[ ! -d "$TARGET_DIR/.git" ]]; then
  echo "Error: target is not a Git checkout: $TARGET_DIR" >&2
  exit 1
fi
if [[ ! -f "$PATCH_FILE" ]]; then
  echo "Error: patch file is missing: $PATCH_FILE" >&2
  exit 1
fi

cd "$TARGET_DIR"

if git apply --reverse --check "$PATCH_FILE" >/dev/null 2>&1; then
  echo "Working-memory patch is already applied."
  exit 0
fi

git apply --check "$PATCH_FILE"

mkdir -p "$BACKUP_ROOT"
for path in "${FILES[@]}"; do
  if [[ -f "$path" ]]; then
    mkdir -p "$BACKUP_ROOT/$(dirname "$path")"
    cp -p -- "$path" "$BACKUP_ROOT/$path"
  fi
done

git apply "$PATCH_FILE"

python_bin=""
if [[ -x "$TARGET_DIR/.venv/bin/python" ]]; then
  python_bin="$TARGET_DIR/.venv/bin/python"
elif [[ -x "$TARGET_DIR/venv/bin/python" ]]; then
  python_bin="$TARGET_DIR/venv/bin/python"
else
  python_bin="$(command -v python3 || true)"
fi

if [[ -n "$python_bin" ]]; then
  "$python_bin" -m py_compile \
    agent/context_engine.py \
    agent/conversation_loop.py \
    plugins/context_engine/working-memory/__init__.py \
    plugins/context_engine/working-memory/state_extractor.py
fi

echo "Working-memory patch applied successfully."
echo "Backup: $BACKUP_ROOT"
echo "Restart Hermes manually after reviewing the changes."

