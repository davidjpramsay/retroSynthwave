# Retro Synthwave

![screenshot](screenshot.png)

[live version](https://victorribeiro.com/random4)
[alternative link](https://victorqribeiro.github.io/retroSynthwave/)

## About

This is a project I've been working on for a while, one hour or less at a time. It involves a simple equation for calculating a perspective of a given point `FOV / (FOV + z)` where FOV is the Field of View and `z` is the z coordinate of a given 3D point `(x, y, z)`.

### Can I use it on my videos?
Yes, set up a record screen software and capture away.
E.g.: [https://www.youtube.com/watch?v=ztv--KzSGDc](https://www.youtube.com/watch?v=ztv--KzSGDc)

### Can I use it as a backgroud?
Yes, press F11 to enter full screen mode, reload the page and take a screen shot.

### Can this be turned into an endless GIF?
Yes, comment out the part where I reset the y position last row of points after they are gone, capture the frames and you're all set.

## Swift Package

The repository also ships a Swift Package that exposes `SynthwaveBackgroundView`, allowing the animated horizon to be embedded directly inside iOS and macOS apps built with SwiftUI.

### Requirements

- iOS 15.0+ or macOS 12.0+
- Xcode 14 or newer

### Getting Started

1. In Xcode, go to **File ▸ Add Packages…** and add this repository URL.
2. Add the **RetroSynthwave** product to your target.
3. Import the package from Swift code:

```swift
import RetroSynthwave
```

### Usage

Embed the view anywhere you need an animated background:

```swift
import SwiftUI
import RetroSynthwave

struct ContentView: View {
    var body: some View {
        SynthwaveBackgroundView()
            .overlay(
                Text("Hello, Neo")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
            )
            .ignoresSafeArea()
    }
}
```

`SynthwaveBackgroundView` renders an animated horizon grid, a glowing sun and the vertical gradient sky. It is designed to cover the entire window, so combining it with `.ignoresSafeArea()` is recommended when using it as a backdrop.

### Implementation Notes

- The 3D projection math mirrors the original web implementation, using the perspective factor `focalLength / (focalLength + z)`.
- Animation timing is driven by `TimelineView`, which keeps the SwiftUI view in sync with the `SynthwaveViewModel` that manages the points in the grid.
- The effect is completely self-contained; no additional assets or shaders are required.

## Credits

This SwiftUI port is based on the JavaScript Retro Synthwave experiment created by Victor Ribeiro. The original JavaScript demo is still available in this repository alongside the SwiftUI package.
