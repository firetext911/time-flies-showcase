#!/usr/bin/env sh
# Fails if anything that must never be public is present in the showcase.
# Run before every push and deploy (the Pages workflow runs it too).
#
# Optional: PRIVATE_REPO=/path/to/time-flies also fails on any file that is
# byte-identical to a file in the private repository (other than approved brand crops,
# which are new files and never match).
set -eu
cd "$(dirname "$0")/.."

fail=0
report() { echo "BLOCKED: $1"; fail=1; }

files=$(find . -type f ! -path './.git/*' ! -path './_site/*' ! -name 'public-safety-check.sh' ! -name '.public-safety-patterns' ! -name 'PUBLIC_RELEASE_AUDIT.md')

# 1. Forbidden file types (source code, configs, credentials, build artifacts)
for f in $files; do
  case "$f" in
    *.swift|*.m|*.mm|*.h|*.xcodeproj*|*.xcworkspace*|*.xcconfig|*.plist|*.entitlements|*.pbxproj|*.storyboard|*.xib) report "app source/config: $f" ;;
    *.ts|*.tsx|*.mjs|*.cjs|*.sql|*.prisma|*.py) report "backend/source file: $f" ;;
    *.env|*.env.*|*/.env*|*.p8|*.p12|*.pem|*.key|*.cer|*.mobileprovision|*.keystore) report "credential file: $f" ;;
    */node_modules/*|*/package.json|*/package-lock.json) report "package files: $f" ;;
  esac
done

# 2. Forbidden content (secrets, internal identifiers, internal docs)
patterns='BEGIN [A-Z ]*PRIVATE KEY|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{20,}|github_pat_|sk_live_|sk_test_|xox[abp]-|API_KEY *=|SECRET *=|TOKEN *=|PASSWORD *='
# Internal identifiers live in a local, git-ignored file so this public script does not reveal them.
if [ -f .public-safety-patterns ]; then
  extra=$(grep -v '^#' .public-safety-patterns | grep -v '^$' | paste -sd'|' -)
  [ -n "$extra" ] && patterns="$patterns|$extra"
elif [ -n "${PUBLIC_SAFETY_PATTERNS:-}" ]; then
  patterns="$patterns|$PUBLIC_SAFETY_PATTERNS"
else
  echo "NOTE: no internal pattern list (.public-safety-patterns or PUBLIC_SAFETY_PATTERNS); generic checks only."
fi
for f in $files; do
  case "$f" in *.png|*.jpg|*.jpeg|*.gif|*.webp|*.mp4|*.mov) continue ;; esac
  if grep -nEI "$patterns" "$f" >/dev/null 2>&1; then
    grep -nEI "$patterns" "$f" | sed "s|^|BLOCKED: $f:|"
    fail=1
  fi
done

# 3. No copied private-repo history (needs PRIVATE_REPO)
if [ -d .git ] && git rev-parse --verify HEAD >/dev/null 2>&1; then
  if [ -n "${PRIVATE_REPO:-}" ] && [ -d "$PRIVATE_REPO/.git" ]; then
    private_commits=$(git -C "$PRIVATE_REPO" rev-list --all)
    for c in $(git rev-list --all); do
      if echo "$private_commits" | grep -qx "$c"; then report "commit $c comes from the private repo history"; fi
    done
  fi
fi

# 4. Optional: identical-file check against the private repo
if [ -n "${PRIVATE_REPO:-}" ] && [ -d "$PRIVATE_REPO" ]; then
  private_hashes=$(cd "$PRIVATE_REPO" && git ls-files -z | xargs -0 sha256sum 2>/dev/null | cut -d' ' -f1 | sort -u)
  for f in $files; do
    h=$(sha256sum "$f" | cut -d' ' -f1)
    if echo "$private_hashes" | grep -qx "$h"; then report "identical to a private-repo file: $f"; fi
  done
fi

if [ "$fail" -ne 0 ]; then
  echo "Public safety check FAILED."
  exit 1
fi
echo "Public safety check passed ($(echo "$files" | wc -l | tr -d ' ') files scanned)."
