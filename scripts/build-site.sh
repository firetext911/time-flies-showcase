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
# The custom domain must survive every build (line endings ignored).
domain=$(tr -d '\r\n' < _site/CNAME 2>/dev/null || true)
if [ "$domain" != "timeflies.live" ]; then
  echo "ERROR: _site/CNAME is missing or wrong (expected timeflies.live)" >&2
  exit 1
fi
echo "Built _site/ ($(find _site -type f | wc -l | tr -d ' ') files)"
