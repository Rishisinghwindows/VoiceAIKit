# VoiceAIKit

A drop-in SwiftUI voice agent SDK powered by [LiveKit](https://livekit.io). Add a fully animated voice conversation UI to any iOS app with just a few lines of code.

## Features

- **One-line integration** — `VoiceAgentView(config: .default)` gives you a complete voice agent UI
- **12-layer animated orb** — Audio-reactive visualization with organic blobs, glow effects, particles, and glass highlights
- **Typewriter text** — Animated taglines with blinking cursor
- **Staggered fade-in** — Elegant sequential animations on session start
- **Multiple agent types** — Built-in configs for MentalHealth, LegalAdviser, FinanceGuru (or define your own)
- **Theming** — Full color customization via `AgentTheme` (purple/teal default, amber/gold legal, or custom)
- **Auto retry** — Configurable connection retry logic
- **Form + Session flow** — User metadata collection (name, subject, language, type) before starting

## Requirements

- iOS 16.0+
- Xcode 15+
- Swift 5.9+

## Installation

### Swift Package Manager

Add VoiceAIKit to your project via Xcode:

1. **File → Add Package Dependencies**
2. Enter the repository URL:
   ```
   https://github.com/Rishisinghwindows/VoiceAIKit.git
   ```
3. Select **Up to Next Major Version** from `1.0.0`

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Rishisinghwindows/VoiceAIKit.git", from: "1.0.0")
]
```

## Quick Start

```swift
import SwiftUI
import VoiceAIKit

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            VoiceAgentView(config: .default)
        }
    }
}
```

### Custom Configuration

```swift
let config = VoiceAgentConfig(
    serverURL: "https://your-server.com",
    livekitURL: "wss://your-livekit.com",
    agentTypes: [.mentalHealth, .legalAdviser, .financeGuru],
    maxRetries: 3
)

VoiceAgentView(config: config)
```

### Open a Specific Agent Type

```swift
VoiceAgentView(config: .default, initialAgentType: "legalAdviser")
```

### Custom Theme

```swift
let myTheme = AgentTheme(
    accentColor: Color.blue,
    speakingAccentColor: Color.orange,
    backgroundColor: Color.black,
    // ... configure all color properties
)

let myAgent = AgentTypeConfig(
    id: "custom",
    displayName: "My Agent",
    title: "Custom Assistant",
    subtitle: "Powered by AI",
    footerText: "© 2024",
    subjectPlaceholder: "What would you like to discuss?",
    taglines: ["Hello!", "How can I help?"],
    theme: myTheme
)

let config = VoiceAgentConfig(
    serverURL: "https://your-server.com",
    livekitURL: "wss://your-livekit.com",
    agentTypes: [myAgent]
)

VoiceAgentView(config: config)
```

## Architecture

```
VoiceAIKit/
├── Models/
│   ├── ConnectionState.swift    # idle, connecting, listening, speaking, disconnected
│   ├── UserInfo.swift           # User metadata (name, subject, language, type)
│   ├── AgentTheme.swift         # Full color theming for orb and UI
│   └── VoiceAgentConfig.swift   # Agent type configs and server settings
├── Internal/
│   └── RGBA.swift               # Color interpolation helper
├── Services/
│   ├── AudioAnalyzer.swift      # Real-time audio level analysis
│   └── TokenService.swift       # LiveKit token fetcher
├── ViewModels/
│   └── VoiceAgentViewModel.swift # LiveKit connection and state management
└── Views/
    ├── VoiceAgentView.swift     # Main drop-in view (form + session)
    ├── OrbView.swift            # 12-layer animated orb visualization
    └── TypewriterText.swift     # Character-by-character text animation
```

## License

MIT
