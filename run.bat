@echo off
flutter run -d 8e39c743 --release --target-platform android-arm64 --dart-define-from-file=.env %*
