#!/bin/bash
# Build the upload zip for Claude Desktop / claude.ai (Settings → Capabilities → Skills → replace "faceless-shorts").
#   bash scripts/package.sh            → dist/faceless-shorts.zip (one top-level folder faceless-shorts/, SKILL.md inside)
# Leaves out machine junk and test output: .DS_Store, dist/, review/, renders/, node_modules/, data/narration.wav, data/mix.wav.
set -euo pipefail
SKILL="$(cd "$(dirname "$0")/.." && pwd)"; NAME="$(sed -n 's/^name: *//p' "$SKILL/SKILL.md" | head -1)"
[ -n "$NAME" ] || { echo "SKILL.md has no name:" >&2; exit 1; }
OUT="$SKILL/dist/$NAME.zip"; TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
mkdir -p "$SKILL/dist" "$TMP/$NAME"
rsync -a --exclude .DS_Store --exclude dist --exclude .git --exclude review --exclude renders --exclude node_modules \
  --exclude 'data/narration.wav' --exclude 'data/mix.wav' "$SKILL/" "$TMP/$NAME/"
rm -f "$OUT"; (cd "$TMP" && zip -qr -X "$OUT" "$NAME")
VER="$(git -C "$SKILL" describe --tags --always 2>/dev/null || echo unknown)"
echo "$OUT  ($(du -h "$OUT" | cut -f1), $(unzip -l "$OUT" | tail -1 | awk '{print $2}') files, version $VER)"
git -C "$SKILL" diff --quiet HEAD -- . 2>/dev/null || echo "WARNING: uncommitted changes are in this zip. Commit first so you can roll back."
