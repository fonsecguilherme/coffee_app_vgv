# Project Documentation 🇺

## Overview

This challenge was proposed by the VGV team, and it’s an application I developed focused on showing coffe pictures. The app features three main screens:

### Navigation View
- **Tab View**: I organized the navigation into two tabs:
  - **Home View**: Displays a coffee imagem fetched from endpoint.
  - **Favorites**: Shows the grid of coffees that user marked as favorites.


### Home View
- It has four main features:
  - **Fetch Image**: When user enter this screen first time it load an image fetched from endpoint
  - **Search another picture button**: Button that let user fetch another image from endpoint.
  - **Favorite button**: Let user favorite that image that is being displayed to been seen later in favorite view
  - **Notification button(extra)**: Created an Notification Service that allow users to show an notification of a random favorited images. If it has none, it only show text. 

### Favorite View
- It has four main features:
- **Grid view of favorited images**: Provides an GridView of images user favorited in Home View.
- **Delete all button(extra)**: Allows the user to delete all favorited pictures.
- **Tap image to expand(extra)**: When user tap a favorited picture, navigates to another screen to show an expanded view of the picture. Also, it allow to delete the photo that is being shown in the screen.
- **Tap and hold image to share(extra)**: When user tap and hold a favorited picture, shows an menu with options to share the picture.

# Project Technical Overview

## Technologies and Packages

### Dart and Flutter Packages

- **[Bloc](https://pub.dev/packages/bloc)**: A library for implementing the BLoC pattern.
- **[Flutter_bloc](https://pub.dev/packages/flutter_bloc)**: Provides integration between Flutter and BLoC for state management.
- **[Equatable](https://pub.dev/packages/equatable)**: Compairson between objects.
- **[Http](https://pub.dev/packages/http)**: HTTP requests.
- **[Dartz](https://pub.dev/packages/dartz)**: A library for functional programming in Dart.
- **[Share plus](https://pub.dev/packages/share_plus)**:share content from your Flutter app via the platform's share dialog.
- **[Pinch zoom](https://pub.dev/packages/pinch_zoom)**:Viewer that makes picture pinch zoom, and return to its initial size and position when released.
- **[Flutter local Notifications](https://pub.dev/packages/flutter_local_notifications)**:A cross platform plugin for displaying local notifications.
- **[Mocktail](https://pub.dev/packages/mocktail)**: A package used for creating mock objects for unit testing.
- **[Mocktail_image_network](https://pub.dev/packages/mocktail_image_network)**: Provides mock image responses for network image testing.
- **[Bloc_test](https://pub.dev/packages/bloc_test)**: A package used for testing BLoC events and states.

- **[Path provider](https://pub.dev/packages/path_provider)**: A Flutter plugin for finding commonly used locations on the filesystem.

### Key Features and Practices

- **State Management**: I utilized BLoC and Flutter BLoC for managing the state of the application.
- **Provider**: Managed through the Provider package through BLoC package for efficient service location and injection.
- **API Requests**: Handled via the HTTP package for network communication.
- **Testing**: Mocktail, Bloc Test, and Mocktail Image Network for comprehensive unit and widget testing.
- **Data Persistence**: Achieved with Path Provider for storing files inside app's folder.
- **Functional Programming**: Leveraged through the Dartz package to incorporate functional programming concepts into the application.

This combination of packages and practices ensures a robust, maintainable, and testable application architecture.

## BLoC

- In this project, I chose to use **cubits** for state management. My choice was motivated by several reasons: cubits is a well-defined pattern, highly testable, widely adopted in the market, and offers flexibility for fine-tuning the user interface.

## Tests

- View tests (home and favorites), cubits (home and favorites), local_coffee_datasource and coffee_repository.

## App Structure

- **Core**: Essential components and features used throughout the app.
- **Data**: Handles communication with external sources and data management.
- **Domain**: Abstractions to be used at data layer
- **Presenter**: Visual representation of app screens, incorporating cubits and states.
