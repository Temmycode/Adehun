.PHONY: gen analyze test run-ios run-android build-apk build-ipa clean

CONFIG ?= config.dev.json

gen:
	dart run build_runner build --delete-conflicting-outputs

analyze:
	flutter analyze

test:
	flutter test

# Local API on the iOS simulator: config.local.json sets API_BASE_URL to
# http://127.0.0.1:8000 (see config.example.json).
run-ios:
	flutter run -d "iPhone 17 Pro" --dart-define-from-file=$(CONFIG)

# Android emulator reaches the host machine at 10.0.2.2.
run-android:
	flutter run -d emulator-5554 --dart-define-from-file=$(CONFIG)

# Requires android/key.properties (see android/key.properties.example).
build-apk:
	flutter build apk --release --dart-define-from-file=$(CONFIG)

build-ipa:
	flutter build ipa --release --dart-define-from-file=$(CONFIG)

clean:
	flutter clean && flutter pub get
