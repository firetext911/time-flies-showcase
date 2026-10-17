# Videos

A short demo of Time Flies: Living Clock™ will be published here.

## Planned demo (30–60 seconds)

1. The always-on clock on an iPad in a real setting (nightstand or kitchen)
2. Rain gathering and running down the window glass
3. Weather Preview: switching through Rain, Snow, Thunderstorm, Moonlight, and Sunset
4. Framed and frameless window styles
5. Closing card: logo, *Time Connects Us.*, and "Coming soon to the App Store"

## Requirements

- MP4 (H.264), 1920×1080 or larger, under 25 MB for the website
- A poster image (`demo-poster.jpg`) for the site
- Captions file (`demo.vtt`) for accessibility
- Licensed music only, or no music
- Same screenshot rules as [screenshots](../screenshots/README.md): release build, no debug UI, no personal data

To publish, add `demo.mp4`, `demo-poster.jpg`, and `demo.vtt` here. Then replace the `video__placeholder` block in `website/index.html` with:

```html
<video controls preload="none" poster="assets/videos/demo-poster.jpg">
  <source src="assets/videos/demo.mp4" type="video/mp4">
  <track kind="captions" src="assets/videos/demo.vtt" srclang="en" label="English" default>
</video>
```
