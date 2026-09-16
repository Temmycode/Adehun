# Adehun (Flutter app)

Escrow mobile app: fund a wallet, create agreements with conditions, lock
money in escrow, approve deliverables, release or dispute, withdraw to a bank
account. Talks to the Adehun FastAPI backend in `../adehun-api`.

## Stack

Flutter 3.41 / Dart 3.11, Riverpod (generator), Dio + Retrofit, go_router,
Firebase Auth with Google sign-in, Paystack SDK, Cloudinary direct uploads,
`flutter_secure_storage` for tokens.

## Configuration

Build-time values come from `--dart-define-from-file`:

```bash
cp config.example.json config.dev.json    # remote API
cp config.example.json config.local.json  # local API
```

| Key | Meaning |
|---|---|
| `API_BASE_URL` | API origin. iOS simulator to a local API: `http://127.0.0.1:8000`; Android emulator: `http://10.0.2.2:8000`. Defaults to production. |
| `GOOGLE_SERVER_CLIENT_ID` | Web client ID from Firebase (for Google sign-in). |
| `PAYSTACK_PUBLIC_KEY` | `pk_test_...` or `pk_live_...`. Never the secret key. |

Both config files are gitignored. VS Code launch configs are in
`.vscode/launch.json`; a `Makefile` wraps the common commands.

## Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after model/provider changes
flutter run -d "iPhone 17 Pro" --dart-define-from-file=config.local.json
```

## Test and lint

```bash
flutter analyze   # must be clean; avoid_print is an error
flutter test
```

## Architecture

```
screens/       UI (ConsumerWidgets)
controllers/   @riverpod notifiers holding immutable state classes
domain/        repository interfaces, models, states
data/          Retrofit services, repository impls, interceptors, storage
router/        go_router config, redirect guard, AuthRouteNotifier
```

- `AuthRouteNotifier` is seeded from secure storage before the first frame and
  drives the router `redirect`: no token, no private screen.
- `AuthInterceptor` attaches the bearer, refreshes on 401 once per burst, and
  only signs the user out when the refresh is rejected (not on network loss).
- Wallet balances are seeded from `GET /wallet`, then updated by the wallet
  websocket, which reconnects with backoff and refetches on app resume.
- Money on the wire is a decimal string with two places; the websocket sends
  floats. `WalletData` parses both.

## Deep links

- `adehun://open/invite?token=...` (custom scheme, both platforms)
- `https://adehun-api.onrender.com/invite?token=...` (Android App Link; verified
  once the release certificate fingerprint is configured on the API)

Test on the simulator: `xcrun simctl openurl booted "adehun://open/invite?token=x"`.

## Release signing (Android)

```bash
keytool -genkey -v -keystore ~/adehun-release.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias adehun
cp android/key.properties.example android/key.properties   # fill in
flutter build apk --release --dart-define-from-file=config.dev.json
```

A release build fails without `android/key.properties`; it never falls back
to the debug key. R8 minification is on; rules are in
`android/app/proguard-rules.pro`.

## Build note: no spaces in the path

Flutter's Swift Package Manager integration (required by `paystack_flutter_sdk`)
and FlutterFire's package scripts fail when the project path contains a space.
This repo currently lives under `.../code/Adehun Org/Adehun`, which breaks
`flutter build ios` with a "pubspec.yaml couldn't be opened ... Adehun%20Org"
error. Rename the parent folder (for example to `Adehun-Org`) or clone into a
path without spaces before building for iOS.

## Known gaps

- Google is the only sign-in method. Apple Sign-In is required before an App
  Store submission (guideline 4.8).
- No in-app dispute detail screen; disputes are raised in-app and resolved by
  an admin through the API.
