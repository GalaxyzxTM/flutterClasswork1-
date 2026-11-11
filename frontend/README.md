# flutter_classwork1 frontend

A class grades screen, in Hebrew, laid out right to left.

- The app bar shows the class average, rounded to one decimal (`ממוצע: 66.3`).
- Each row shows the student's name, grade (`ציון: 92`) and a mark: a green check for a pass (55 and up), a red
  cross for a fail.
- The `−` and `+` buttons move a grade by 0.01 point, within 0 to 100; the average, the mark and the order update
  at once. A button is disabled at the limit it would cross.
- The round sort button opens a menu: grade high to low (the default), grade low to high, or by name.

Grades are kept as whole hundredths (92.01 is stored as 9201), so repeated 0.01 steps stay exact.

## Platforms

| Platform | Folder | Notes |
|---|---|---|
| Android | `android/` | main target; Kotlin Gradle scripts, Java 17 bytecode |
| Web | `web/` | for day-to-day development in Chrome |
| Windows | `windows/` | desktop build |

## Layout

| Path | Contents |
|---|---|
| `lib/main.dart` | app entry, theme, right-to-left layout, grades screen |
| `lib/grades.dart` | grade rules: steps, limits, pass mark, average, formatting, sorting |
| `test/grades_test.dart` | unit tests for the grade rules |
| `test/widget_test.dart` | widget tests for the screen |
| `analysis_options.yaml` | lint rules (`flutter_lints`) |

## Commands

```
flutter pub get
flutter analyze
flutter test
flutter run
flutter build apk --debug
```

The application ID `com.example.flutter_classwork1` is a placeholder: app stores reject `com.example.*`, so set a
real one before publishing (`android/app/build.gradle.kts`, and the `MainActivity.kt` package and folder).
