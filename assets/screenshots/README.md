# Screenshots

Official iPad screenshots of Time Flies: Living Clock™ will be published here once the final scenery is in place.

## Before adding a screenshot

- [ ] Captured from a **release or TestFlight build** on a real iPad or the iPad simulator.
- [ ] Debug-only screens, test menus, and developer overlays are **not** visible.
- [ ] No personal data, such as a real home ZIP code, notifications, or account names.
- [ ] Scenery shown is the **final, licensed** artwork.
- [ ] Status bar is clean (full battery, no carrier text, time shown as 9:41).

## Naming

`ipad-<orientation>-<subject>.png`, for example:

- `ipad-landscape-clock.png`
- `ipad-landscape-framed-window.png`
- `ipad-landscape-nightstand.png`
- `ipad-landscape-rain.png`, `-snow`, `-thunderstorm`, `-moonlight`, `-sunset`, `-sunny`
- `ipad-portrait-clock.png`

To use a screenshot on the website, replace the matching `placeholder` block in `website/index.html` with
`<img src="assets/screenshots/<file>" alt="…">`, and add the file to `PUBLIC_RELEASE_AUDIT.md`.
