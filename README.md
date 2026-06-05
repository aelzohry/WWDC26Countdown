# WWDC26 Countdown

A playful SwiftUI macOS countdown for WWDC26. It has a glowing animated window and a Menu Bar Extra for quick glances.

The countdown targets Apple’s WWDC26 keynote: Monday, June 8, 2026 at 10:00 a.m. PT.

## Run

```sh
swift run WWDC26Countdown
```

Or open the native project in Xcode:

```sh
open WWDC26Countdown.xcodeproj
```

Select the `WWDC26Countdown` scheme and run it. The Xcode target uses local signing, so it should build and debug on this Mac without a developer team.

## Build

```sh
swift build -c release
```

## Bundle as an app

```sh
./Scripts/build-app.sh
open .build/release/WWDC26Countdown.app
```

The bundle script also generates a local `.icns` icon, so the release app is self-contained.
