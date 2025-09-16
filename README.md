# Retro Synthwave

SwiftUI background effect inspired by the classic neon-grid horizon. `RetroSynthwave` exposes
`SynthwaveBackgroundView`, a drop-in view that renders the animated grid, rising sun, and
gradient sky entirely in code—perfect for title screens, looping backgrounds, or ambient
visuals inside your own apps.

## Requirements

- iOS 15.0 or macOS 12.0
- Xcode 14 or newer

## Installation

1. In Xcode, open **File ▸ Add Packages…** and paste this repository URL.
2. Select the **RetroSynthwave** library product and add it to your target.
3. Import the package wherever you need the background:

   ```swift
   import RetroSynthwave
   ```

## Usage

`SynthwaveBackgroundView` fills its container, so combining it with
`.ignoresSafeArea()` keeps the animation edge-to-edge.

```swift
import SwiftUI
import RetroSynthwave

struct ContentView: View {
    var body: some View {
        SynthwaveBackgroundView()
            .overlay(alignment: .center) {
                VStack(spacing: 12) {
                    Text("Welcome to the Grid")
                        .font(.system(size: 42, weight: .heavy))
                        .foregroundColor(.white)
                        .shadow(color: .pink.opacity(0.8), radius: 12)

                    Text("Tap anywhere to begin")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.85))
                }
            }
            .ignoresSafeArea()
    }
}
```

## Customisation

`SynthwaveViewModel` drives the animation and can be tweaked for different looks:

- **columns / rows** – grid resolution. Higher counts produce denser meshes.
- **spacing / depthSpacing** – distance between points along the X and Z axes.
- **focalLength** – adjusts perspective strength; larger values flatten the grid.
- **zSpeed** – scroll speed towards the camera.
- **maxDepth** – how far rows travel before they recycle to the front.

Initialisers expose sensible defaults, so many apps can stick with the provided
`SynthwaveBackgroundView`. For bespoke layouts you can instantiate `SynthwaveViewModel`
directly and pass it into a customised SwiftUI `Canvas`.

## Credits

Ported to SwiftUI from Victor Ribeiro's Retro Synthwave experiment. This branch focuses on
the SwiftUI implementation, while the original JavaScript prototype lives on at
[victorribeiro.com/random4](https://victorribeiro.com/random4).
