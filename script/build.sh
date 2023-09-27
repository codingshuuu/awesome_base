#! /bin/bash
flutter clean
flutter build apk --profile --target-platform=android-arm64

sleep 1

open build/app/outputs/flutter-apk