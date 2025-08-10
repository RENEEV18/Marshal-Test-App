# Flutter Recipe App Assignment

[![Flutter](https://img.shields.io/badge/Flutter-2.10-blue.svg)](https://flutter.dev)  
[![Platform](https://img.shields.io/badge/Platform-Android-green.svg)]()  
[![Dart](https://img.shields.io/badge/Dart-2.19-blue.svg)](https://dart.dev)  
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)  

---

## Overview

This Flutter Android app demonstrates:

- User authentication with email/password and session persistence.
- Profile display of logged-in user.
- Device & app information including live battery status overlay.
- Image picker with gallery access, image display, and clearing option.
- Recipe management with search, filters, pagination, create/update/delete functionality.

The app strictly uses only these packages:

- [`provider`](https://pub.dev/packages/provider)
- [`http`](https://pub.dev/packages/http)
- [`shared_preferences`](https://pub.dev/packages/shared_preferences)

---

## Features

### 1. Authentication & Profile

- Login via email and password.
- Persistent login using shared preferences.
- Profile page showing user data from API.

### 2. Device & App Info

- Device model and Android OS version display.
- App version info.
- Live battery percentage overlay visible on all screens, updated in real-time.

### 3. Image Picker

- Select image from gallery.
- Show selected image on the same page.
- Clear and update image functionality.

### 4. Recipes

- List all recipes with:
  - Search bar
  - Multi-select tags and meal type filters
  - Scroll pagination to load more recipes
- Recipe cards include:
  - Recipe name
  - Ingredients list
  - Delete button with confirmation dialog
- Recipe details page with:
  - View and edit toggle mode
  - Editable fields and update on saving
- Create and delete recipes.

---

## App Flow

1. Login screen on app start.
2. After login, main screen with a drawer menu:
   - Profile (default)
   - Device & App Info
   - Image Picker
   - Recipes
   - Logout
3. Bottom overlay shows live battery percentage globally.

---

## Screenshots

<!-- Replace with your screenshots -->
| Login | Profile | Device Info |
|-------|---------|-------------|
| ![login](screenshots/login.png) | ![profile](screenshots/profile.png) | ![device_info](screenshots/device_info.png) |

| Image Picker | Recipes List | Recipe Details |
|--------------|--------------|----------------|
| ![image_picker](screenshots/image_picker.png) | ![recipes](screenshots/recipes.png) | ![recipe_details](screenshots/recipe_details.png) |

---

## Getting Started

### Prerequisites

- Flutter SDK installed ([installation guide](https://flutter.dev/docs/get-started/install))
- Android device or emulator set up

### Installation

```bash
git clone https://github.com/RENEEV18/Marshal-Test-App.git
flutter pub get
flutter run
