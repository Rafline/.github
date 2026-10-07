# Contributing

These rules apply to every repository in this organization unless a repository says otherwise.

## Git workflow

We use a three-step workflow:

1. **Every branch starts from `main`:**
   ```sh
   git switch main && git pull --ff-only
   git switch -c <type>/<name>
   ```
   Branch names start with `feat/`, `fix/` or `chore/`. Never start a branch from `test`.
2. **Finished work is merged directly into `test` (code repos only):**
   `test` is our shared test environment. Code repositories have a `test` branch; docs and asset repositories do not. Each repository's README says which kind it is.
   In a code repository, merge finished work into `test` without a pull request. Your local `test` must never hold commits of its own. Check first: `git log origin/test..test` should print nothing. If it prints something, stop and ask.
   ```sh
   git fetch origin
   git switch test && git reset --hard origin/test
   git merge --no-ff <branch>
   git push origin test
   git switch <branch>
   ```
   On a conflict, stop and resolve it on `test` together with the other developer. Never merge `test` into your branch to fix it.
3. **Open a pull request to `main`:**
   `main` is production and is always deployable. Nobody pushes to `main` directly.
   ```sh
   git push -u origin <branch>
   gh pr create --base main --head <branch>
   ```
   Every change reaches `main` through a pull request approved by the other developer. Pull requests are squash merged.

### Resetting `test`

Never merge `test` into anything. An owner may reset `test` to `main`, and should do so when `test` and `main` have identical tree content after a pull request merges (`git diff origin/main origin/test` is empty):
```sh
git push --force-with-lease=test:<sha of origin/test> origin origin/main:test
```
After a reset, merge every branch that has an open pull request into `test` again, and tell the other developer to run `git fetch` before their next merge into `test`.

### Hooks

Run `scripts/install-hooks.sh` once after cloning, where a repository has one. It installs git hooks that refuse direct pushes to `main` and commits made while on `main`.

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
