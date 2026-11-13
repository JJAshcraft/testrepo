# Spiteful

An iPhone app that turns spite into motivation for ADHD brains. Swipe through friends who
opted in, send over-the-top (but loving) ribbing about their projects, and follow up until
the thing actually gets done.

## Run it

```
brew install xcodegen
xcodegen generate
open Spiteful.xcodeproj
```

Needs Xcode 15+ (iOS 17).

## How it works

- **Swipe**: right to spite, left to pass.
- **Compose**: pick intensity (Playful, Theatrical, Operatic), generate or write the ribbing, pick a follow up time.
- **Duels**: every active ribbing has rounds. Local notifications nudge you to follow up.
- **Guardrails**: ribbing targets the work, never the person. Rivals must be marked as opted in, and a word filter blocks personal attacks.

## Not built yet

- Real accounts and syncing (CloudKit is the likely path). Right now opt in is a checkbox on your side, so the real mutual opt in handshake is the first thing to build.
- Sending ribbing to the other person's phone.
- Streaks and a "spite score".
- An LLM powered roast generator in place of the templates.

Note: this was scaffolded without a Swift compiler, so expect a small round of compile fixes on first build.
