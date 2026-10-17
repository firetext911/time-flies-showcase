# Website Deployment

How the Time Flies website at **https://timeflies.live** is built, previewed, and published.
This repository contains only the public website and product information. The Time Flies app lives in a separate private repository and is never published here.

## How it works

| Piece | Where |
|---|---|
| Website source | `website/` (plain HTML, CSS, and JS; no build tools or paid services) |
| Images | `assets/branding/`, `assets/screenshots/`, `assets/videos/` |
| Build | `scripts/build-site.sh` copies `website/` and `assets/` into `_site/` |
| Safety check | `scripts/public-safety-check.sh` blocks source code, credentials, and secrets |
| Deploy | `.github/workflows/pages.yml`, **manual only** (Actions → Deploy website → Run workflow) |
| Custom domain | `website/CNAME` (`timeflies.live`), plus the domain set in Settings → Pages |

Pushing to `main` does **not** deploy. Every deploy is started by hand, after review.

### Why the CNAME file is kept

This site deploys with GitHub Actions, so GitHub reads the custom domain from the repository's Pages settings. `website/CNAME` is still copied into every build:

- It keeps the domain on record if the Pages source is ever switched to "Deploy from a branch".
- `build-site.sh` **fails the build** if `_site/CNAME` is missing or doesn't say `timeflies.live`, so a deploy can't silently drop the domain.

## Preview locally

You need Python 3, or any static file server.

```bash
sh scripts/build-site.sh
python -m http.server 8080 --directory _site
```

Then open http://localhost:8080. Run `build-site.sh` again after each change.

To check before publishing:

- [ ] Phone width (about 375 px): no sideways scrolling, menu button works
- [ ] Tablet and desktop widths
- [ ] TV size (1920 px and wider): text scales up, and the Tab key shows a clear gold focus ring
- [ ] `sh scripts/public-safety-check.sh` passes

## Publish

1. Commit and push to `main`.
2. Go to **Actions → Deploy website → Run workflow**.
3. Wait for the green check (about a minute), then open https://timeflies.live.

## DNS checklist (GoDaddy)

DNS is managed by hand at the registrar. Nothing here changes DNS automatically.

| Type | Name | Value |
|---|---|---|
| A | `@` | `185.199.108.153` |
| A | `@` | `185.199.109.153` |
| A | `@` | `185.199.110.153` |
| A | `@` | `185.199.111.153` |
| AAAA | `@` | `2606:50c0:8000::153` |
| AAAA | `@` | `2606:50c0:8001::153` |
| AAAA | `@` | `2606:50c0:8002::153` |
| AAAA | `@` | `2606:50c0:8003::153` |
| CNAME | `www` | `firetext911.github.io` |
| TXT | `_github-pages-challenge-firetext911` | the value from GitHub → Settings → Pages (domain verification) |

Keep the TXT record. It proves to GitHub that the domain belongs to this account, which prevents takeover.

### Verify DNS

```bash
nslookup -type=A timeflies.live 8.8.8.8
nslookup -type=AAAA timeflies.live 8.8.8.8
nslookup -type=CNAME www.timeflies.live 8.8.8.8
nslookup -type=TXT _github-pages-challenge-firetext911.timeflies.live 8.8.8.8
```

You should see the four `185.199.x.153` addresses, the four `2606:50c0:…::153` addresses, `firetext911.github.io`, and the verification value.
An online checker such as https://dnschecker.org also works.

### Verify HTTPS

```bash
curl -sI http://timeflies.live/
curl -sI https://timeflies.live/
curl -sI https://www.timeflies.live/
```

Expected:

- `http://timeflies.live/` → `301` to `https://timeflies.live/`
- `https://timeflies.live/` → `200`
- `https://www.timeflies.live/` → `301` to `https://timeflies.live/`

In **Settings → Pages**, "Enforce HTTPS" should be checked. GitHub issues and renews the certificate automatically (free, via Let's Encrypt).

## Troubleshooting

| Symptom | Fix |
|---|---|
| "Domain's DNS record could not be retrieved" | Wait up to an hour for DNS to spread, then re-check the records above |
| Certificate not issued, or "Enforce HTTPS" grayed out | Make sure there are no extra A/AAAA records (such as GoDaddy "Parked"), then remove and re-add the domain in Settings → Pages |
| Site shows a 404 after a deploy | Check that the run succeeded and `_site/index.html` exists in the build log |
| Old content still showing | Hard refresh; GitHub's cache usually clears within 10 minutes |
| Link previews show an old image | Social apps cache previews; use the platform's preview or debug tool to refresh |
