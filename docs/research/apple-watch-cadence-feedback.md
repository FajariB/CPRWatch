# Apple Watch Feedback Options for CPRWatch

Research date: 2026-07-19

## Scope

This note covers Apple-supported watchOS feedback and interaction mechanisms relevant to a CPR cadence assistant. It uses Apple primary sources only. API availability does not establish clinical suitability, timing accuracy, or safe emergency use; those require device testing and clinical validation.

## Platform-supported facts

### Haptics

- `WKInterfaceDevice.current().play(_:)` plays one of watchOS's defined `WKHapticType` patterns. Apple says to use each pattern for its intended meaning; the available meanings include notification, direction, success/failure, retry, start, stop, and click.[^haptic-api][^haptic-hig]
- The ordinary `play(_:)` call has no effect while the app is inactive or in the background. Apple documents an active workout session as the exception.[^haptic-api]
- Apple warns against repeated calls in quick succession. If a haptic is already playing, watchOS stops it and imposes at least a 100 ms delay before starting another. Haptics also consume battery and can degrade the experience when overused.[^haptic-api][^haptic-hig]
- Apple says engaging the haptic engine pauses HealthKit heart-rate collection until the haptic finishes.[^haptic-api]
- Apple Watch's built-in haptic patterns can be accompanied by an audible tone, so a system haptic should not be assumed to be silent.[^haptic-hig]

### Audio and spoken prompts

- watchOS supports audio playback through `AVAudioSession`. Apple provides an asynchronous activation API on watchOS, and the background-audio mode can keep extended audio playing after the app leaves the foreground.[^audio-session][^background-sessions]
- `AVSpeechSynthesizer` can speak text supplied in an `AVSpeechUtterance`, with an optional selected voice.[^speech]
- Audio sessions can be interrupted by system events, so an app needs to observe and handle interruptions rather than assume continuous playback.[^audio-interruptions]

### Visual feedback and accessibility

- SwiftUI's `TimelineView` redraws content on a schedule and can drive timers or time-based visuals. The system may reduce the actual display cadence on watchOS, especially when the wrist is lowered.[^timeline-view]
- Apple documents timelines for Always On updates, but examples reduce detail and replace animation when the update cadence drops. This means an always-visible display is not a guarantee of beat-level animation at 100–120 updates per minute.[^timeline-updates]
- Apple recommends pairing audio cues with haptics and augmenting audio instructions with visual cues. Crucial information should not depend on one sensory channel.[^accessibility]
- watchOS controls should normally be 44 × 44 points and no smaller than 28 × 28 points. Apple also recommends simple gestures, alternatives to gestures, and appropriate accessibility labels for assistive technologies.[^accessibility]
- Apple advises responding to Reduce Motion and being cautious with fast, repetitive, or blinking animation.[^accessibility]

### Digital Crown

- SwiftUI's `digitalCrownRotation` modifiers can bind Crown rotation to a bounded value, select sensitivity and continuous behavior, enable or disable Crown haptic feedback, and receive change/idle callbacks.[^digital-crown]
- Crown rotation is an input mechanism, not a cadence-output channel. Pressing the Crown can also leave a frontmost extended-runtime app and end that kind of session.[^extended-runtime]

### Runtime and background constraints

- A watchOS app normally moves to the background and is suspended when the user lowers their wrist. Ordinary scheduled background tasks are system-controlled and may be throttled or delivered late, so they are not a dependable beat timer.[^extended-runtime][^background-tasks]
- Apple offers background sessions for workouts, location, and audio, plus `WKExtendedRuntimeSession` types for self care, mindfulness, physical therapy, and smart alarm. Apple explicitly says to select a session type by the activity's intended use, not by desirable runtime features.[^extended-runtime]
- Extended runtime sessions can process data and play sound or haptics after the screen turns off, but their behavior and limits depend on the declared type: Apple currently documents 10 minutes for frontmost self care, 1 hour for frontmost mindfulness, 1 hour for background physical therapy, and 30 minutes for background smart alarm.[^extended-runtime]
- Sustained high CPU use can cause watchOS to cancel an extended runtime session.[^extended-runtime]

## Product recommendations (inferences, not Apple requirements)

1. Use **multimodal feedback**: a large compression count and phase label, a restrained pulse animation, haptic pacing, and optional audio. Provide independent toggles where operationally safe.
2. Prototype the 100–120/min haptic cadence on physical Watch models before choosing it as the primary channel. A beat every 500–600 ms is theoretically above Apple's documented 100 ms re-engagement delay, but Apple's separate warning against quick repeated calls, battery impact, and haptic duration means API arithmetic alone cannot prove reliable perception or timing.
3. Reserve distinct `start`, `stop`, or notification patterns for phase changes; do not repurpose semantic patterns for every compression. Test which documented generic pattern can pace compressions without obscuring higher-priority cues.
4. Offer short sounds or spoken phase prompts such as “start compressions,” “breaths,” and “switch compressor,” but do not speak every count by default. Speech can mask team communication and audio can be interrupted.
5. Keep timer truth in a monotonic session model derived from elapsed time, not from UI animation callbacks or background-task delivery. Treat visuals as a rendering of session state.
6. Use the Digital Crown only for deliberate setup or training adjustments (for example, selecting a cadence within a clinically approved range). Avoid requiring fine Crown interaction during active emergency CPR; provide large start/pause controls and accessibility alternatives.
7. Do not declare an extended-runtime or workout category merely to obtain background haptics. First determine with Apple and clinical/regulatory review which supported runtime category truthfully matches CPRWatch's intended use. If none does, design the first version around documented foreground behavior and make loss-of-cadence behavior obvious.
8. Validate behavior for wrist-down, Always On, app inactive/background, notification/audio interruption, low battery, silent settings, VoiceOver, Reduce Motion, and accidental Crown presses. The emergency interface should never imply cues are active when the OS has stopped them.

## Open engineering questions

- Which `WKHapticType` remains clearly perceptible at the target cadence on supported Watch hardware without unacceptable battery use or fatigue?
- Does the final intended use qualify for any Apple-supported extended runtime mode, and will Apple accept that entitlement/capability choice?
- Should audio be local to Apple Watch, mirrored from iPhone, or optional on both, given noisy clinical environments and interruption behavior?
- What is the safe degraded state when haptic, audio, or foreground runtime becomes unavailable?

## Primary sources

[^haptic-api]: Apple, [`WKInterfaceDevice.play(_:)`](https://developer.apple.com/documentation/watchkit/wkinterfacedevice/1628128-playhaptic).
[^haptic-hig]: Apple, [Playing haptics — Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/playing-haptics).
[^audio-session]: Apple, [`AVAudioSession`](https://developer.apple.com/documentation/avfaudio/avaudiosession).
[^background-sessions]: Apple, [Enabling Background Sessions](https://developer.apple.com/documentation/watchkit/enabling-background-sessions).
[^speech]: Apple, [`AVSpeechSynthesizer`](https://developer.apple.com/documentation/avfaudio/avspeechsynthesizer).
[^audio-interruptions]: Apple, [Handling audio interruptions](https://developer.apple.com/documentation/avfaudio/handling-audio-interruptions).
[^timeline-view]: Apple, [`TimelineView`](https://developer.apple.com/documentation/swiftui/timelineview).
[^timeline-updates]: Apple, [Updating watchOS apps with timelines](https://developer.apple.com/documentation/watchos-apps/updating-watchos-apps-with-timelines).
[^accessibility]: Apple, [Accessibility — Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/accessibility).
[^digital-crown]: Apple, [SwiftUI input and event modifiers](https://developer.apple.com/documentation/swiftui/view-input-and-events).
[^extended-runtime]: Apple, [Using extended runtime sessions](https://developer.apple.com/documentation/watchkit/using-extended-runtime-sessions).
[^background-tasks]: Apple, [Using background tasks](https://developer.apple.com/documentation/watchkit/using-background-tasks).
