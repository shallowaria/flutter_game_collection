# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Flutter mobile game application** with multiple mini-games/interactive features. The app currently includes:

- **Muyu Game** (main feature): A digital Buddhist meditation beads game where users tap a wooden pestle image to earn "功德" (virtue/merit points) with animated feedback and audio effects
- **Guess Number Game**: A number guessing game where users guess a random number 0-99 with dynamic feedback
- **Counter**: A deprecated template widget (not actively used)

The project targets Android and iOS platforms with Flutter 3.x stable channel and Dart 3.10.7+.

## Technology Stack

- **Framework**: Flutter 3.x (Dart SDK ^3.10.7)
- **Audio**: flame_audio 2.11.13 (for sound effects via AudioPool)
- **UI**: Material Design with custom widgets
- **Testing**: flutter_test (Flutter testing framework)
- **Linting**: flutter_lints 6.0.0
- **Build System**: Gradle (Kotlin DSL) for Android

## Code Architecture

### Feature-Based Module Structure

The app is organized into self-contained feature modules under `lib/`:

```
lib/
├── main.dart           # Entry point (launches MuyuPage as home)
├── counter/            # Counter module (deprecated template)
├── guess/              # Number guessing game module
│   ├── guess_page.dart         # Main game widget & logic
│   ├── guess_app_bar.dart      # Custom AppBar with number input field
│   └── result_notice.dart      # Animated notification for feedback
└── muyu/               # Buddhist meditation beads game module
    ├── muyu_page.dart          # Main game widget & logic
    ├── muyu_app_bar.dart       # Custom AppBar with history button
    ├── muyu_image.dart         # Interactive wooden pestle image
    ├── count_panel.dart        # Score display + control buttons
    └── animate_text.dart       # Floating animated text for score feedback
```

**Key Pattern**: Each game is a self-contained Dart module with a `*_page.dart` StatefulWidget as the main component, supported by specialized sub-widgets for specific concerns (app bars, animations, inputs).

### Critical Components & Patterns

1. **Animation System**
   - Uses `AnimationController` with custom `Tweens` for transitions
   - Common patterns: `FadeTransition`, `ScaleTransition`, `SlideTransition`
   - `didUpdateWidget()` lifecycle hook used to re-trigger animations on state changes
   - `SingleTickerProviderStateMixin` for animation tick management

2. **Audio Implementation (Muyu Game)**
   - `flame_audio` package provides `AudioPool` for sound effect management
   - Async initialization in `initState()` required for AudioPool setup
   - Pool-based playback allows multiple overlapping sound effects
   - Three sound variants (muyu_1.mp3, muyu_2.mp3, muyu_3.mp3) for variety
   - Random sound selection on each tap

3. **User Input Handling**
   - `GestureDetector` for tap/click detection
   - `TextEditingController` for text input (Guess game)
   - Input validation (e.g., integer-only parsing in Guess game)
   - Button state management during gameplay

4. **State Management**
   - Uses Flutter's built-in StatefulWidget + setState() pattern
   - No external state management library (Redux, BLoC, Riverpod)
   - Parent page widgets hold game state; child widgets receive state via constructor

## Common Development Tasks

### Running the App

```bash
# Run on connected device/emulator (debug mode)
flutter run

# Run in release mode (optimized)
flutter run --release
```

### Building for Deployment

```bash
# Build Android APK
flutter build apk

# Build Android App Bundle (for Google Play Store)
flutter build aab
```

### Testing & Code Quality

```bash
# Run all unit/widget tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Analyze code with linter (flutter_lints)
flutter analyze

# Clean build artifacts
flutter clean
```

### Dependency Management

```bash
# Install/refresh dependencies defined in pubspec.yaml
flutter pub get

# Update to latest compatible versions
flutter pub upgrade

# Update to major versions (breaking changes possible)
flutter pub upgrade --major-versions

# Check Flutter environment setup
flutter doctor
```

### Development Environment

```bash
# Verify Flutter setup and connected devices
flutter doctor -v

# List connected devices
flutter devices
```

## Asset Organization

- **Images**: `assets/images/` (e.g., muyu.png for the wooden pestle)
- **Audio**: `assets/audio/` (sound effects in MP3 format)

Assets must be registered in `pubspec.yaml` under the `assets` section to be included in the build. Current configuration includes both image and audio directories.

## Important Implementation Details

### Muyu Game (Main Feature)

- **Scoring Logic**: Random gain of 1-3 "功德" per tap
- **Animation**: Floating text appears at tap location with fade-out animation
- **Audio**: Uses `AudioPool` from flame_audio; plays random variant of 3 sound effects
- **UI State**: Score displayed in `count_panel.dart`, controlled from `muyu_page.dart`
- **App Bar**: Custom app bar with history button (implementation placeholder exists)

### Guess Number Game

- **Game Logic**: Random number 0-99 generated at start; compares with user input
- **Feedback**: Shows "大了" (too big) or "小了" (too small) in animated `result_notice.dart`
- **Validation**: Only integer inputs accepted; invalid input ignored
- **Input UI**: Number input field in custom `guess_app_bar.dart`
- **Button State**: Guess button disabled during animation/comparison to prevent rapid re-submission

### Deprecated Components

- **Counter Module** (`lib/counter/`): Basic counter from Flutter template; not used in current app flow. Can be removed if no future use planned.
- **Widget Test** (`test/widget_test.dart`): Tests outdated MyHomePage widget; should be updated to test current MuyuPage and other game modules.

## Development Conventions

- **Naming**: PascalCase for classes, snake_case for files; widgets suffixed with purpose (e.g., `_page`, `_app_bar`, `_panel`, `_notice`)
- **File Organization**: One primary widget class per file
- **Imports**: Use relative imports within the same module when possible
- **Lifecycle**: Proper cleanup in `dispose()` method (especially for AnimationControllers and AudioPools)

## Debugging Tips

- Use `flutter run --verbose` to see detailed build and runtime output
- Use `flutter logs` to view real-time app logs
- Use DevTools: `flutter pub global activate devtools && devtools` for widget inspection, profiling
- Check `flutter doctor` if builds fail unexpectedly (often due to SDK/NDK path issues on Android)

## Next Steps for Future Development

- **Testing**: Expand test coverage with unit tests for game logic (score calculation, random generation) and widget tests for UI components
- **State Persistence**: Consider storing high scores or game history with local persistence (e.g., shared_preferences package)
- **Localization**: App uses Chinese text; consider adding l10n support for internationalization
- **Performance**: Profile audio initialization and animation performance on lower-end devices
