# Retro Synthwave (SwiftUI)

A SwiftUI re-imagining of the original Retro Synthwave background. The project now ships as a Swift Package that exposes a drop-in `SynthwaveBackgroundView`, making it easy to embed the animated grid and sun effect inside your iOS or macOS apps.

## Requirements

- iOS 15.0+ or macOS 12.0+
- Xcode 14 or newer

## Getting Started

1. In Xcode, go to **File ▸ Add Packages…** and add this repository URL.
2. Add the **RetroSynthwave** product to your target.
3. Import the package from Swift code:

```swift
import RetroSynthwave
```

## Usage

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

## Implementation Notes

- The 3D projection math mirrors the original web implementation, using the perspective factor `focalLength / (focalLength + z)`.
- Animation timing is driven by `TimelineView`, which keeps the SwiftUI view in sync with the `SynthwaveViewModel` that manages the points in the grid.
- The effect is completely self-contained; no additional assets or shaders are required.

## Credits

This SwiftUI port is based on the JavaScript Retro Synthwave experiment created by Victor Ribeiro. The original repository has been converted so the effect can be consumed from Swift-based projects.
