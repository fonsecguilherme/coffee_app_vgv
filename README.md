
---

# Coffee App - VGV Challenge

This project was developed as part of the **VGV technical challenge**, and it’s an application focused on displaying coffee pictures.
The app is structured around two main tabs: a home view for fetching images and a favorites view for managing saved ones.

---

## Table of Contents

1. [Installation & Setup](#installation--setup)
2. [App Overview](#app-overview)
3. [Project Architecture](#project-architecture)
4. [Technologies & Packages](#technologies--packages)
5. [BLoC](#bloc)
6. [Tests](#tests)
7. [Demo](#demo)
8. [Screenshots](#screenshots)
9. [Future Improvements](#future-improvements)

---

## Installation & Setup

This project uses **Flutter 3.35.5** and **Dart 3.9.2**.

To run it locally:

### Clone the repository

**Using SSH**

```bash
git clone git@github.com:fonsecguilherme/coffee_app_vgv.git
```

**Using HTTPS**

```bash
git clone https://github.com/fonsecguilherme/coffee_app_vgv.git
```

Then, inside the project folder:

```bash
flutter pub get
flutter run
```

---

## App Overview

### Navigation

The app uses a tab-based navigation with two main views:

* **Home View**
  Displays a random coffee image fetched from an endpoint.
  Features:

  * Fetch a new image.
  * Favorite the displayed image.
  * Show a local notification with a random favorite (extra).

* **Favorites View**
  Displays a grid of favorited images.
  Features:

  * View all favorited images.
  * Delete all favorites (extra).
  * Tap an image to expand it (extra).
  * Long press to share the picture (extra).

---

## Project Architecture

* **core/** → Essential utilities and base services.
* **data/** → Data layer: repositories, data sources, and models.
* **domain/** → Abstract entities and business logic.
* **presentation/** → UI layer with Cubits and Views.

This layered structure follows **Clean Architecture principles**, promoting testability and separation of concerns.

---

## Technologies & Packages

### Dart and Flutter Packages

| Category                   | Packages                                                                                                                                                                  |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **State Management**       | [bloc](https://pub.dev/packages/bloc), [flutter_bloc](https://pub.dev/packages/flutter_bloc), [equatable](https://pub.dev/packages/equatable)                             |
| **Networking**             | [http](https://pub.dev/packages/http)                                                                                                                                     |
| **Functional Programming** | [dartz](https://pub.dev/packages/dartz)                                                                                                                                   |
| **Local Storage**          | [path_provider](https://pub.dev/packages/path_provider)                                                                                                                   |
| **Notifications**          | [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)                                                                                       |
| **Sharing & Media**        | [share_plus](https://pub.dev/packages/share_plus), [pinch_zoom](https://pub.dev/packages/pinch_zoom)                                                                      |
| **Testing**                | [mocktail](https://pub.dev/packages/mocktail), [bloc_test](https://pub.dev/packages/bloc_test), [mocktail_image_network](https://pub.dev/packages/mocktail_image_network) |



### Practices

* **State management** handled via Cubits.
* **Dependency injection** through `BlocProvider + RepositoryProvider`.
* **Functional error handling** via `Dartz`.
* **Local caching** of images using `Path Provider`.
* **Automated testing** with `mocktail` and `bloc_test`.

---

## BLoC

This project uses **Cubits** for state management.
Reasons for choosing Cubit:

* Simplicity and clarity in small flows.
* High testability.
* Well-defined and documented pattern.
* Easy integration with `flutter_bloc` UI layer.

---

## Tests

Tests cover:

* **Views:** Home and Favorites.
* **Cubits:** Home and Favorites.
* **Data Layer:** LocalCoffeeDataSource and CoffeeRepository.

---

## Demo

* [Full demonstration](https://drive.google.com/file/d/14wAt8XIOlp4sN22y7fbVX-TOqmD1Uxoy/view?usp=share_link)
* [Offline mode demonstration](https://drive.google.com/file/d/1DzCi59lqBeWRISuIGJLgLWOOhukdLgqC/view?usp=share_link)

---

## Screenshots

### Home Screen (Android / iOS)

<p float="left">
  <img src="https://github.com/user-attachments/assets/86e7fe8c-b158-4448-8f4f-182596ff20b2" width="350" />
  <img src="https://github.com/user-attachments/assets/4e052aba-b993-4798-898f-2d17e3ca4a37" width="350" />
</p>

### Favorites Screen

<p float="left">
  <img src="https://github.com/user-attachments/assets/ef5d4678-9e01-4bc2-afeb-6a3db8d08e86" width="350" />
  <img src="https://github.com/user-attachments/assets/a2693c05-d4d2-4877-b60f-d5f928bf8fc5" width="350" />
</p>

### Expanded Picture

<p float="left">
  <img src="https://github.com/user-attachments/assets/0fc6213d-d272-45af-9937-a7c17efad49e" width="350" />
  <img src="https://github.com/user-attachments/assets/0b9f44d6-476c-4e54-bcc4-42acf216e066" width="350" />
</p>

---

## Future Improvements

* Implement schedule notifications.
* Add internationalization (i18n) support.
* Create integration tests for navigation flow.

---
