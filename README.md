# Campus Notice Board

**Topic:** College notice board (Flutter Application Development Programme, group project)

## Description
Important college announcements get lost in chat groups. Campus Notice Board lets
staff or student coordinators post notices through a validated form, and lets everyone
browse them, filter by department and open a notice for the full details. All data is
saved on the device, so it survives a restart and works without internet.

## Screenshots
Add at least three screenshots here after running the app:

1. `screenshots/list.png` - notice list with department filter
2. `screenshots/form.png` - post notice form with a validation error
3. `screenshots/departments.png` - departments screen

## Data source
User-created data saved on the device with `shared_preferences` (JSON). No API and no key.

## Team and ownership
| Member | Parts built |
|---|---|
| NAME 1 | e.g. Post notice form and validation |
| NAME 2 | e.g. Data service, Provider store |
| NAME 3 | e.g. List, detail and departments screens, theme |

## Project structure
```
lib/
  models/     notice.dart
  services/   notice_service.dart (device storage), notice_store.dart (Provider)
  screens/    list, detail, form, departments
  widgets/    notice_card, state_views, formatters
  theme/      app_theme.dart (single seed colour)
```

## Run the project
Requires Flutter 3.35+ (stable), JDK 17, Android Studio.

```bash
git clone <your-repo-url>
cd notice_board
flutter create . --platforms=android --project-name notice_board   # generates the android/ folder
flutter pub get
flutter run
flutter test
```

## App name and icon
1. Edit `android/app/src/main/AndroidManifest.xml` and set `android:label="Campus Notice Board"`.
2. Put a 1024x1024 PNG at `assets/icon.png`, then run `dart run flutter_launcher_icons`.

## Build the release APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`.
