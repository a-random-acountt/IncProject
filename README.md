# Void

The most useless app possible, built to genuinely shippable quality.

Void is an iOS SwiftUI app whose only real feature is a button that
does nothing. Everything else — streaks, achievements, analytics
charts, a changelog, a ⌘K command palette, sound effects, haptics,
confetti — exists purely to dress that button up as a real, polished
product. It's dark-only by design, navigated with a floating iOS 26
Liquid Glass tab bar, fully usable, has an actual test suite, and takes
itself completely seriously.

## What it does

Five tabs on a Liquid Glass bottom bar:

| Tab | What's there |
|---|---|
| **Home** | The Do Nothing button, live stats (total clicks, streaks, "global rank"), a rotating quote of the day |
| **Analytics** | A flat "productivity" line chart, a real per-day bar chart of clicks, and a "where your nothing went" donut broken down by time of day |
| **Achievements** | Click- and streak-based badges with progress bars |
| **History** | A day-grouped log of every click, timestamped |
| **Settings** | Sound toggle, keyboard shortcuts, reset progress, and a Changelog page one tap deeper |

Tap the magnifying-glass icon (or press **⌘K** with a hardware
keyboard) to open the command palette and jump to any tab or log a
click without touching the tab bar.

## Architecture

The app is split in two so the important logic can actually be tested,
independent of any Apple-only UI framework:

- **`VoidCore`** (`Sources/VoidCore`) — a pure Swift/Foundation package
  with zero SwiftUI/AppKit/UIKit imports: streak math, achievement
  unlocking, quote/changelog content, number formatting, and the
  `@Observable` `NothingStore` that holds it all together. It builds
  and tests on **any** platform Swift runs on.
- **`Void`** (`Sources/Void`) — the SwiftUI app itself (views, theming,
  sound/haptics, persistence), built as an Xcode app target via
  [XcodeGen](https://github.com/yonaskolb/XcodeGen) so the project file
  isn't hand-maintained.

```
Package.swift            <- VoidCore package manifest
Sources/VoidCore/        <- pure logic (Linux/macOS/CI testable)
Tests/VoidCoreTests/     <- 28 tests covering streaks, achievements, stats, formatting
project.yml              <- XcodeGen manifest for the iOS app
Sources/Void/             <- SwiftUI views, models, support code
Resources/Assets.xcassets <- app icon + dark-only color assets
```

`VoidCore` was written and verified with a real Swift 6.3 toolchain
(`swift test`, all 28 tests green) in an environment without Xcode. The
SwiftUI layer was authored to the same standard but, since SwiftUI only
exists on Apple platforms, its first real build/run needs to happen in
Xcode — see below.

## Running the tests

No Xcode required:

```sh
swift test
```

## Running the app

You'll need a Mac with **Xcode 26+** (for Liquid Glass and the `Tab`/
`.glassEffect()` APIs the UI uses — the project targets iOS 26).

1. Install [XcodeGen](https://github.com/yonaskolb/XcodeGen) if you don't have it:
   ```sh
   brew install xcodegen
   ```
2. Generate the Xcode project:
   ```sh
   xcodegen generate
   ```
3. Open `Void.xcodeproj`, pick the **Void** scheme, select a run
   destination (an iOS 26 simulator, or a device), and hit Run. The
   first time, Xcode will ask you to pick a signing team for
   "Automatically manage signing" — any personal team works for local
   development.
4. Xcode will resolve the three package dependencies
   ([ConfettiSwiftUI](https://github.com/simibac/ConfettiSwiftUI),
   [Shimmer](https://github.com/markiv/SwiftUI-Shimmer),
   [Pow](https://github.com/EmergeTools/Pow)) automatically on first
   build.

The app forces dark mode (`UIUserInterfaceStyle: Dark` +
`.preferredColorScheme(.dark)`) — there's no light theme, by design.

If Xcode flags a minor API mismatch on one of those three packages (the
UI layer couldn't be compiled outside Xcode to verify against their
exact current versions), the integration points are intentionally
isolated to one line each — `NothingButton.swift` (Pow),
`LaunchSplashView.swift` (Shimmer), and `DashboardView.swift`
(ConfettiSwiftUI) — so a fix is a one-line change, not a rewrite.

## Regenerating the app icon

`Resources/Assets.xcassets/AppIcon.appiconset/icon-1024.png` is
generated, not hand-drawn:

```sh
pip install Pillow
python3 Scripts/generate_app_icon.py
```

Tweak the colors/radii in that script to change the mark, or just
replace the PNG directly — either way, re-run `xcodegen generate`
afterward.
