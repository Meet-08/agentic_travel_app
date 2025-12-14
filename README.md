# Travel App

An agentic AI-powered travel planning Flutter application built with Firebase and GenUI.

## Features

- AI-powered travel planning with generative UI
- Interactive travel itinerary generation
- Hotel listings and booking service
- Multiple filter options for customizing travel preferences
- Cross-platform support (Android, iOS)

## Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.10.1 or higher)
- [Dart SDK](https://dart.dev/get-dart) (comes with Flutter)
- [Firebase CLI](https://firebase.google.com/docs/cli#install_the_firebase_cli)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)

## Firebase Configuration

### 1. Install Firebase CLI

```bash
# Using npm
npm install -g firebase-tools

# Or using curl (macOS/Linux)
curl -sL https://firebase.tools | bash
```

### 2. Login to Firebase

```bash
firebase login
```

### 3. Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

Make sure you have the Dart SDK bin directory in your PATH:

- **Windows**: `%LOCALAPPDATA%\Pub\Cache\bin`
- **macOS/Linux**: `$HOME/.pub-cache/bin`

### 4. Configure Firebase for your Flutter app

Navigate to your project directory and run:

```bash
flutterfire configure
```

This command will:

1. Prompt you to select a Firebase project (or create a new one)
2. Ask which platforms you want to configure (Android, iOS, Web, macOS, Windows, Linux)
3. Automatically generate the `lib/firebase_options.dart` file
4. Set up platform-specific configuration files:
   - **Android**: `android/app/google-services.json`
   - **iOS**: `ios/Runner/GoogleService-Info.plist`
   - **Web**: Configuration in `firebase_options.dart`

### 5. Enable Required Firebase Services

In the [Firebase Console](https://console.firebase.google.com/), enable the following services for your project:

1. **Firebase AI (Vertex AI for Firebase)** - Required for GenUI AI features

   - Go to Build > AI (Vertex AI)
   - Enable the API

2. **Firebase App Check** (Optional but recommended)
   - Go to App Check
   - Register your app platforms

### 6. Reconfigure (if needed)

If you need to reconfigure Firebase (e.g., add a new platform or change project):

```bash
flutterfire configure --project=your-project-id
```

To configure specific platforms only:

```bash
flutterfire configure --platforms=android,ios,web
```

## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd travel_app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Follow the [Firebase Configuration](#firebase-configuration) section above.

### 4. Run the app

```bash
# Run on default device
flutter run

# Run on specific platform
flutter run -d chrome     # Web
flutter run -d windows    # Windows
flutter run -d macos      # macOS
flutter run -d android    # Android emulator/device
flutter run -d ios        # iOS simulator/device
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration (auto-generated)
└── src/
    ├── catalog.dart          # GenUI catalog definition
    ├── constants.dart        # App constants and prompts
    ├── common.dart           # Common utilities
    ├── utils.dart            # Helper functions
    ├── catalog/              # UI component catalog
    │   ├── checkbox_filter_chips/
    │   ├── date_input/
    │   ├── information_card/
    │   ├── input_group/
    │   ├── itinerary/
    │   ├── listings_booker/
    │   ├── option_filter_chip/
    │   ├── tabbed_sections/
    │   ├── text_input_chip/
    │   ├── trailhead/
    │   └── travel_carousel/
    ├── models/               # Data models
    ├── screens/              # App screens
    ├── services/             # Business logic and API services
    └── widgets/              # Reusable widgets
```

## Dependencies

Key packages used in this project:

- `firebase_core` - Firebase core functionality
- `genui` - Generative UI framework
- `genui_firebase_ai` - Firebase AI integration for GenUI
- `json_schema_builder` - JSON schema utilities
- `logging` - Logging utilities

## Troubleshooting

### FlutterFire CLI not found

If you get a "command not found" error after installing FlutterFire CLI:

```bash
# Verify installation
dart pub global list

# Run with full path
dart pub global run flutterfire_cli:flutterfire configure
```

### Firebase configuration issues

1. Ensure you're logged into Firebase: `firebase login`
2. Check your Firebase project exists: `firebase projects:list`
3. Regenerate configuration: `flutterfire configure --force`

### Build errors after Firebase setup

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [FlutterFire CLI Documentation](https://firebase.flutter.dev/docs/cli/)
- [Firebase Console](https://console.firebase.google.com/)

## License

This project is private and not published to pub.dev.
