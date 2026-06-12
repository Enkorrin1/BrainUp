# BrainUp Mobile Prototype

Flutter mobile prototype for BrainUp.

This prototype is the BrainUp mobile app: a map-first learning experience with
short logic lessons, XP, streak, hearts, and mistake review.

## First product slice

- renamed Flutter package and mobile runners to BrainUp
- Android/iOS runners configured for the BrainUp app identity
- local family profile persistence through `SharedPreferences`
- EN/RU localization foundation preserved
- focused model and storage tests preserved

## Product Direction

BrainUp should keep its own visual language: neural-route maps, compact thinking
challenges, calm family analytics, and bright habit-forming feedback. It should
not reuse the old hub-first composition or legacy brand identity from the source
project.

## Commands

```powershell
flutter pub get
flutter analyze
flutter test
```

## iOS

The iOS runner uses the BrainUp bundle naming. Final signing should be checked
later on macOS with Xcode.

On macOS with Xcode and CocoaPods installed:

```bash
flutter pub get
cd ios
pod install
cd ..
flutter run -d ios
```

iOS builds cannot be produced on Windows because Apple's toolchain requires
macOS and Xcode.
