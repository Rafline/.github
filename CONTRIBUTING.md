# Contributing

These rules apply to every repository in this organization unless a repository says otherwise.

## Branches

- `main` is always deployable. Nobody pushes to it directly.
- Work on a short-lived branch named after the kind of change:
  - `feat/…` for new behaviour
  - `fix/…` for bug fixes
  - `chore/…` for tooling, dependencies, docs and everything else
- Run `scripts/install-hooks.sh` once after cloning, where a repository has one. It installs a hook that stops direct pushes to `main`.

## Pull requests

- Every change reaches `main` through a pull request.
- Every pull request needs an approval from the other developer before it is merged.
- Pull requests are squash merged. The pull request title becomes the commit message on `main`.
- Pull request titles follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):
  - `feat: add a health check endpoint`
  - `fix(api): return 404 for a missing record`
  - `chore: bump typescript to 5.6`
- Fill in the pull request template, including the Notion epic ID when there is one.
- Keep pull requests small enough to review in one sitting.

## Code written with an AI agent

Code written with an AI agent is reviewed like any other code. The author is responsible for every line: read it, run it, and be ready to explain it in review.

## Secrets

- No secrets in git: no tokens, passwords, keys or `.env` files, not even in a commit you later revert.
- Commit a `.env.example` that lists variable names with empty or placeholder values.
- If a secret is committed by mistake, tell the other developer and rotate the secret immediately. Removing it from the history is not enough.

## Shared code

Changes to shared code (packages and contracts used by more than one repository) are additive:

- Add new fields, functions and types. Do not rename or remove existing ones in the same change.
- New fields are optional or have a default.
- Remove something only after every repository that uses it has stopped using it, in a separate pull request.

## Database changes

Every migration is checked against the database checklist in the pull request template: additive, has a default where needed, reversible, and run on staging before it reaches production.
