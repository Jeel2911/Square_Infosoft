# ⚔️ Star Wars Characters App

A clean, minimal Flutter app that lists all Star Wars characters using the [SWAPI](https://swapi.dev) public API — built as part of a Flutter REST API integration exercise.

---

## ✨ Features

- 🔍 Browse all Star Wars characters from the SWAPI API
- 📄 Pagination — navigate through all pages of characters
- 🃏 Character cards with staggered entrance animation
- 💥 Pulse ring animation on card tap
- 📋 Character detail modal with:
  - Name
  - Height (in meters)
  - Mass (in kg)
  - Birth year
  - Date added (dd-MM-yyyy)
  - Number of film appearances
- ⚠️ Error state with retry button
- ⏳ Loading state with spinner

---

## 🛠 Tech Stack

| Layer | Tool |
|---|---|
| Framework | Flutter |
| State Management | Provider |
| HTTP Client | http |
| Date Formatting | intl |
| API | [SWAPI](https://swapi.dev/api) |

---

## 📁 Project Structure

```
lib/
├── main.dart
├── models/
│   ├── character.dart        # Character data model
│   └── api_response.dart     # Paginated API response model
├── services/
│   └── api_service.dart      # HTTP calls to SWAPI
├── providers/
│   └── character_provider.dart  # Characters state
├── screens/
│   └── home_screen.dart      # Main screen
└── widgets/
    ├── character_card.dart   # Individual character card
    └── character_modal.dart  # Character detail bottom sheet
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio / VS Code
- A connected device or emulator

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/star_wars_app.git

# 2. Navigate into the project
cd star_wars_app

# 3. Install dependencies
flutter pub get

# 4. Run the app
flutter run
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.1
  provider: ^6.1.2
  intl: ^0.19.0
```

---

## 🌐 API Reference

Base URL: `https://swapi.dev/api`

| Endpoint | Description |
|---|---|
| `GET /people/` | List all characters (page 1) |
| `GET /people/?page=2` | List characters (page 2, 3...) |

---

## 🏗 Build APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📐 Architecture

The app follows a clean separation of concerns:

- **Models** — Pure data classes with no logic except simple transformations (e.g. cm → meters)
- **Services** — Handles all API calls and error handling in one place
- **Providers** — Manages state and exposes it to the UI via `ChangeNotifier`
- **Widgets** — Purely presentational, receive data as props

---

## 👤 Author

**Jeel Patel**
- GitHub: [@Jeel2911](https://github.com/Jeel2911)

---

