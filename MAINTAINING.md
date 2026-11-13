# Maintaining this skill

`main` is what gets released. Every change goes on its own branch and reaches `main` through a pull request.

1. **Branch:** `git checkout main && git pull && git checkout -b <change-name>`
2. **Change:** edit, or add a style. A new style = `styles/<new-style>/` (`style-sheet.png`, `STYLE.md`, `example/` with
   `<script src="tools/scale.js"></script>` after the `#cv` canvas) **plus a row in SKILL.md's style table and its
   "Which style" line**, or Claude won't pick it.
3. **Test:** `bash scripts/selftest.sh` (every style must pass), then make one real short with it in Claude Code
   (`~/.claude/skills/faceless-shorts` links to this folder, so the checked-out branch is what Claude uses).
4. **Commit and push** the branch, open a PR into `main`, review, merge.
5. **Release:** `git checkout main && git pull`, tag it (`git tag v1.x && git push --tags`), then build the upload zip:
   `bash scripts/package.sh` → `dist/faceless-shorts.zip` (not committed; `dist/` is ignored).
6. **Claude Desktop:** Settings → Capabilities → Skills → remove the old `faceless-shorts` → upload the zip → new chat.

Roll back: `git checkout <tag> -- .` (or revert the merge commit).
