<!-- Title: Conventional Commits, e.g. "feat(api): add health check". It becomes the squash commit message. -->

## What changed

<!-- A short summary of the change. -->

## Why

<!-- The problem this solves or the goal it serves. Link the issue: "Closes #123". -->

## How it was tested

<!-- Commands you ran, tests you added, and what you checked by hand. -->

## Notion epic ID

<!-- e.g. EPIC-12, or "none" -->

## Database checklist

<!-- Skip this section if the change has no migration. -->

- [ ] Additive: the migration only adds tables, columns or indexes, and does not rename or drop anything still in use
- [ ] Default: every new non-null column has a default, or the migration backfills it
- [ ] Reversible: the down migration works and was tried locally
- [ ] Staging: the migration was run on staging before this is merged

## Before requesting review

- [ ] No secrets, tokens or `.env` files are in this change
- [ ] Shared code changes are additive
- [ ] CI passes
