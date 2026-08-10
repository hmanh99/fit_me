# FitMe

**FitMe** is a feature-rich, cross-platform mobile application built with Flutter designed to help users track workouts, manage meal plans, monitor daily fitness schedules, and achieve personal health goals. 

Engineered with **Clean Architecture**, **BLoC Pattern**, and powered by **Supabase** backend services, FitMe offers real-time synchronization, modular design, multi-language support, and smooth user experiences.

---

## Features

### Workout & Session Tracking
- **Workout Plans**: Explore pre-designed or custom workout plans tailored for various fitness levels.
- **Active Workout Sessions**: Execute workouts set-by-set with live duration counters, rep tracking, and rest timers.
- **Exercise Library**: Browse a rich database of exercises categorized by muscle groups, equipment requirements, and difficulty with detailed instructions.

### Meal & Nutrition Planner
- **Nutrition Guide**: Discover healthy recipes and meal plans tailored to fitness objectives.
- **Meal Details**: Deep dive into nutritional breakdowns (calories, protein, carbs, fat), ingredients, and prep steps.

### Interactive Schedule & Calendar
- **Monthly Planner**: Integrated calendar powered by `table_calendar` to schedule workouts and fitness activities.
- **Real-Time Sync**: Live updates on workout schedules using Supabase Postgres real-time channels.
- **Activity Management**: Seamlessly add, edit, or delete scheduled workouts.

### Profile & Activity History
- **Personalized Profile**: Update user stats (height, weight, avatar) and monitor fitness metrics.
- **Activity Log**: Detailed activity history tracking completed sessions and physical milestones over time.

### Multi-Language & Modern UI
- **Localization**: Built-in support for **English (`en`)**, **Spanish (`es`)**, and **Vietnamese (`vi`)** powered by `easy_localization`.
- **Shell Navigation**: Smooth tab switching and nested routing using `go_router` shell routes.
- **Shimmer & Pagination**: Enhanced UI performance with skeleton loaders (`shimmer`) and infinite scroll pagination (`infinite_scroll_pagination`).

---

## Architecture & Project Structure

The codebase strictly enforces **Clean Architecture** principles, separating code into **Domain**, **Data**, and **Presentation** layers across feature modules:

```text
lib/
├── core/                       # Shared core infrastructure & utilities
│   ├── config/                 # Application configuration & env keys
│   ├── constants/              # Application constants & assets
│   ├── di/                     # Service Locator / Dependency Injection (GetIt)
│   ├── error/                  # Custom exceptions and failures
│   ├── helper/                 # Utility functions and extensions
│   ├── l10n/                   # Localization setup
│   ├── router/                 # GoRouter configuration, route guards & redirects
│   ├── services/               # Core services (e.g., ExerciseServices)
│   ├── theme/                  # Light and Dark App Theme tokens
│   └── usecase/                # Base UseCase contract interface
│
├── features/                   # Feature-first modular organization
│   ├── auth/                   # Authentication (Login, Register, Forgot Password)
│   ├── dashboard/              # Home Summary & Dashboard metrics
│   ├── exercise/               # Exercise catalog & detail screens
│   ├── meal/                   # Meal planner & nutrition details
│   ├── onboard/                # User onboarding & goal selection flow
│   ├── profile/                # Profile management & activity history
│   ├── schedule/               # Calendar scheduler & real-time sync
│   ├── settings/               # App preferences & language switcher
│   └── workout/                # Workout plans, sessions & set execution
│
├── shared/                     # Reusable cross-feature UI components & Shells
│   └── widgets/                # MainShellScreen, navigation bars, cards
│
└── main.dart                   # Application entry point & provider bootstrapping
```

---

## Tech Stack & Packages

| Category | Package / Technology | Description |
| :--- | :--- | :--- |
| **Framework** | Flutter (Dart SDK `>=3.11.1`) | Cross-platform UI toolkit |
| **Backend / DB** | [`supabase_flutter`](https://pub.dev/packages/supabase_flutter) (`^2.12.4`) | Supabase Auth, Database, Storage & Real-Time |
| **State Management** | [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) (`^9.1.1`), [`bloc`](https://pub.dev/packages/bloc) (`^9.2.0`) | Predictable state management |
| **Dependency Injection**| [`get_it`](https://pub.dev/packages/get_it) (`^8.0.3`) | Service locator pattern |
| **Routing** | [`go_router`](https://pub.dev/packages/go_router) (`^17.2.3`) | Declarative navigation with shell support |
| **Localization** | [`easy_localization`](https://pub.dev/packages/easy_localization) (`^3.0.7`) | Multi-language internationalization |
| **Functional Error** | [`fpdart`](https://pub.dev/packages/fpdart) (`^1.2.0`) | Functional programming & `Either<Failure, Success>` |
| **UI Components** | [`table_calendar`](https://pub.dev/packages/table_calendar), [`shimmer`](https://pub.dev/packages/shimmer), [`infinite_scroll_pagination`](https://pub.dev/packages/infinite_scroll_pagination) | Calendar UI, Skeleton loading, and Infinite lists |
| **Local Storage** | [`shared_preferences`](https://pub.dev/packages/shared_preferences) (`^2.5.2`) | Local settings persistence |

---

## Supabase Database Schema Overview

FitMe integrates with a Supabase PostgreSQL backend containing the following key tables:

- **`exercises`**: Stores exercise names, descriptions, muscle groups, equipment, and media links.
- **`workout_plans` & `plan_exercises`**: Defines curated workout routines and mapped exercises.
- **`workout_sessions` & `set_sessions`**: Records logged workout sessions, timestamps, reps, and weight lifted.
- **`workout_schedules`**: Stores planned workout dates, times, and completion statuses.
- **`user_profiles` & `activity_histories`**: Manages user biometrics, avatars, and timeline logs.
- **`meals`**: Catalog of nutrition plans, recipes, and dietary breakdown.

---

## Getting Started

### Prerequisites
- **Flutter SDK**: `>=3.11.1`
- **Dart SDK**: Compatible with Flutter SDK
- **Supabase Account**: An active Supabase project instance

### 1. Repository Setup
Clone the repository:
```bash
git clone https://github.com/your-username/fit_me.git
cd fit_me
```

### 2. Configure Backend Credentials
Set up your Supabase project URL and Anonymous API Key in `lib/core/config/app_config.dart`:
```dart
class AppConfig {
  static const supabaseUrl = "YOUR_SUPABASE_URL";
  static const supabaseAnonKey = "YOUR_SUPABASE_ANON_KEY";
}
```

### 3. Install Dependencies
Run:
```bash
flutter pub get
```

### 4. Run the Application
Start the development server on your preferred device/emulator:
```bash
flutter run
```

---

## Internationalization (i18n)

Translation assets are located in `assets/translations/`:
- `en.json` - English (Default)
- `es.json` - Spanish
- `vi.json` - Vietnamese

To change language dynamically at runtime, use the settings page or call:
```dart
context.setLocale(const Locale('vi')); // Switch to Vietnamese
```

---

## 📄 License

This project is proprietary and intended for personal/internal use.
