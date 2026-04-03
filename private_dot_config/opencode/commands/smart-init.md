---
description: Evidence-guided AGENTS.md generator/updater (fast, low-token)
agent: build
subtask: true
---

You are generating or updating this repository's root `AGENTS.md` to make future coding-agent runs faster and cheaper (reduce exploratory navigation and repeated inference). Optimize for: concise, accurate, actionable, and easy to maintain.

## Research Background

This command implements findings from "On the Impact of AGENTS.md Files on the Efficiency of AI Coding Agents" (Lulla et al., 2026):
- ~28.6% lower median wall-clock time with AGENTS.md present
- ~16.6% lower median output token consumption
- Key mechanism: upfront repo structure/conventions reduce exploratory navigation and re-planning loops

## User Focus (optional)

$ARGUMENTS

## Context Discovery (keep small)

Repo root:
!`git rev-parse --show-toplevel 2>/dev/null || pwd`

Candidate build/config files (if present):
!`ls -1 package.json pnpm-lock.yaml yarn.lock bun.lockb pyproject.toml poetry.lock requirements.txt setup.cfg setup.py go.mod Cargo.toml Makefile Justfile pom.xml build.gradle build.gradle.kts composer.json Gemfile .tool-versions .nvmrc .ruby-version .python-version 2>/dev/null | head -20`

Existing AGENTS.md (if any):
!`head -50 AGENTS.md 2>/dev/null || echo "No existing AGENTS.md"`

## Hard Constraints (token/time hygiene)

- Do NOT paste large lockfiles or massive file trees into the chat.
- Prefer reading a few "source of truth" files over scanning the entire repo.
- Do NOT invent commands. Only document commands you can confirm exist (e.g., from package scripts, Makefile targets, tooling configs) or clearly label as "if applicable".
- Keep the file short enough to be read quickly (aim: 80-180 lines; no giant paragraphs).

## Task

1. Locate the repository root (use the value above) and target `AGENTS.md` at that root.
2. If `AGENTS.md` already exists, UPDATE it (preserve project-specific details; remove duplicates; keep headings stable).
3. Build the document around the highest-impact categories shown to matter in practice:
   - **Project description** (what this repo is, what it's for)
   - **Architecture + project structure** (where to look; key directories; entrypoints)
   - **Conventions + best practices** (style, patterns, do/don't)
   - **Workflow commands** (setup/build/test/lint/format) because they prevent wasted cycles

## Required Output Format (AGENTS.md template)

Use this structure. Keep tight, bullet-first:

```markdown
# AGENTS.md

## Project Overview
<!-- 3-6 lines; no marketing; what this repo is and does -->

## Repo Map
<!-- Key directories/files; 6-12 bullets max; include entrypoints -->
- `src/` - ...
- `tests/` - ...

## Setup
<!-- Exact commands; include version managers if present; note working directory expectations -->
- Prerequisites: ...
- Install: `...`

## Common Commands
<!-- Only verified commands; prefer: install, build, test, lint, typecheck, format -->
<!-- Add "quick" vs "full" if the repo has both -->
| Command | Purpose |
|---------|---------|
| `...`   | ...     |

## Coding Conventions
<!-- Formatters/linters; naming; error handling; patterns to follow/avoid; 6-12 bullets -->
- ...

## Change Workflow
<!-- Small checklist: make change -> run checks -> update tests -> keep diffs small -->
1. Make your change
2. Run `...` to verify
3. Update/add tests
4. Keep diffs small and focused
5. Do NOT commit secrets or credentials

## Gotchas
<!-- Env vars, codegen, migrations, CI quirks; only if real; 3-8 bullets -->
- ...

## When You're Stuck
<!-- Cost-control + alignment rules -->
- Ask 1 targeted question instead of guessing
- If commands fail due to environment/tooling, report the exact error and STOP rather than looping
- Prefer the smallest reproducible check that validates the change
- When uncertain about architectural decisions, ask before implementing
```

## Monorepo Rule

Only if detected as a monorepo:
- Keep root `AGENTS.md` as the "global contract"
- Mention where per-package instructions live (e.g., `packages/*/AGENTS.md`)
- Do NOT create many nested `AGENTS.md` files unless the user focus ($ARGUMENTS) explicitly asks for "split/nested"

## Verification Steps Before Finishing

1. Ensure every command you list is discoverable from repo config (package scripts, Makefile/Justfile targets, documented tool config) or clearly scoped ("if using X...").
2. Ensure the file is short enough to be read quickly (80-180 lines target).
3. Ensure it's internally consistent (one way to run tests, one formatter path, etc.).
4. If updating an existing file, preserve any project-specific details that are still accurate.

## Deliverables

1. Create or update `AGENTS.md` at the repo root.
2. Reply with a brief summary:
   - New file created vs. existing file updated
   - Which sections were added/modified
   - Any sections that need human review (e.g., unverified commands marked with "if applicable")
