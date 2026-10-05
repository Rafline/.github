#!/usr/bin/env bash
# Apply labels.yml to every repository in the organization, or only to the
# repositories named on the command line.
#
#   scripts/sync-labels.sh                     # every repo in the org
#   scripts/sync-labels.sh rafline-backend     # one repo
#
# Uses `gh label create --force`, which creates a label or updates the color
# and description of an existing label with the same name. It never deletes
# or renames labels, so labels that are not in labels.yml are left alone.
#
# Needs: gh, logged in with access to the repositories.
set -euo pipefail

ORG="${ORG:-Rafline}"
LABELS_FILE="$(cd "$(dirname "$0")/.." && pwd)/labels.yml"

if [ "$#" -gt 0 ]; then
  repos=("$@")
else
  repos=()
  while IFS= read -r r; do repos+=("$r"); done \
    < <(gh repo list "$ORG" --limit 200 --no-archived --json name --jq '.[].name')
fi

# Parse labels.yml into "name<TAB>color<TAB>description" lines.
parse_labels() {
  awk '
    function val(line) { sub(/^[^:]*:[ \t]*/, "", line); gsub(/^"|"$/, "", line); return line }
    /^[ \t]*#/ || /^[ \t]*$/ { next }
    /^- name:/        { if (name != "") print name "\t" color "\t" desc; name = val($0); color = ""; desc = ""; next }
    /^[ \t]+color:/   { color = val($0); next }
    /^[ \t]+description:/ { desc = val($0); next }
    END { if (name != "") print name "\t" color "\t" desc }
  ' "$LABELS_FILE"
}

labels="$(parse_labels)"
count="$(printf '%s\n' "$labels" | grep -c .)"

for repo in "${repos[@]}"; do
  echo "== $ORG/$repo ($count labels)"
  while IFS=$'\t' read -r name color desc; do
    gh label create "$name" --repo "$ORG/$repo" --color "$color" --description "$desc" --force >/dev/null
    echo "   ok  $name"
  done <<< "$labels"
done
