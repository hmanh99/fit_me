# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

```bash
flutter pub get
flutter run                    # run on connected device/emulator
flutter build apk              # build release APK
flutter build ios               # build release IPA (macOS only)
```

## Code Quality

```bash
flutter analyze                # run Dart analyzer
dart format lib/ test/         # format all Dart files
dart fix --dry-run             # see lint auto-fixes
dart fix --apply               # apply lint auto-fixes
```

## Tests

```bash
flutter test                   # run all tests
flutter test test/widget_test.dart  # single test file
```

## Architecture

**Clean Architecture + BLoC pattern**, feature-first folder layout. Each feature has domain → data → presentation layers:

### Layer structure per feature
```
lib/features/<name>/
  domain/
    entities/<name>_entity.dart      # pure Dart business objects
    repositories/<name>_repository.dart  # abstract repo interface
  data/
    models/<name>_model.dart         # fromJSON/toJSON mappers
    repositories/<name>_repository_impl.dart  # impl calls datasource → maps to entity
    datasource/<name>_remote_data_source.dart  # Supabase/Firebase raw calls
  presentation/
    bloc/<name>_bloc.dart            # BLoC: event in → state out
    bloc/<name>_event.dart
    bloc/<name>_state.dart
    screens/                           # full-page widgets
    widgets/                           # reusable widgets for the feature
```

### State management
- **BLoC** (`flutter_bloc` 9.x) for all async state. Each feature has its own Bloc.
- Events dispatched from widgets, Bloc calls repository, emits new state.
- States follow: `Loading` → `Loaded` / `Empty` / `Error`.

### Routing
- **GoRouter** (`go_router` 17.x) with `StatefulShellRoute` for bottom tab persistence.
- Auth guard via `auth_redirect.dart` + `GoRouterRefreshStream` — redirects unauthenticated users to sign-in, authenticated users away from auth screens.
- Route names and paths centralized in `AppRouteNames` / `AppRoutePaths`.
- Router factory `createAppRouter(authBloc)` in `lib/core/router/app_router.dart`.

### Navigation shell
- `MainShellScreen` in `lib/shared/main_shell.dart` — `NavigationBar` with 5 tabs: Home, Workouts, Calendar, Meal, Profile.

### Backend
- **Supabase** for auth + database (initialized in `main.dart`).
- **Firebase Auth** dependency present but Supabase is the active backend.
- Local storage via `sqflite`.

### Auth flow
- `AuthBloc` listens to auth state changes.
- On app start: `AuthSessionRestoreRequested` checks saved session.
- States: `AuthUnknownState` (loading), `AuthInitialState` (guest), `AuthSignInState` / `AuthSignUpState` (authenticated), `AuthErrorState`.
- Authenticated states extend `AuthAuthenticatedState` for redirect logic.

### Theme
- Custom color constants in `lib/core/const/color_constants.dart`.
- Poppins font from `assets/fonts/`.
- Material 3 `ColorScheme.fromSeed`.

## Key Dependencies (pubspec.yaml)

| Package | Use |
|---|---|
| `supabase_flutter` | Auth + database backend |
| `flutter_bloc` | State management |
| `go_router` | Declarative routing + deep links |
| `equatable` | Value equality for entities/states |
| `intl` | Date formatting |
| `sqflite` | Local SQLite storage |
| `table_calendar` | Schedule calendar UI |
| `youtube_player_iframe` | Exercise video playback |
| `share_plus` | Share workout plans |
| `cloud_firestore` | (present but Supabase is active) |

## Current State

- Test coverage is minimal (one empty widget test).
- Docker/setup instructions not documented — add when onboarding new devs.
- Profile feature recently added (bloc, repository, datasource).
