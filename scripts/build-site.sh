#!/usr/bin/env sh
# Assemble the public website into _site/ (used locally and by the Pages workflow).
# The website references assets/...; the canonical files live in the repo's top-level assets/.
set -eu
cd "$(dirname "$0")/.."
rm -rf _site
mkdir -p _site/assets
cp -R website/. _site/
for d in branding screenshots videos; do
  mkdir -p "_site/assets/$d"
  find "assets/$d" -maxdepth 1 -type f ! -name 'README.md' -exec cp {} "_site/assets/$d/" \;
done
echo "Built _site/ ($(find _site -type f | wc -l | tr -d ' ') files)"
