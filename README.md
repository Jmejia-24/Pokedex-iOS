# Pokedex-iOS

![Swift Version](https://img.shields.io/badge/Swift-5.0-F16D39.svg?style=flat)
![Platform](https://img.shields.io/badge/Platform-iOS-000000.svg?style=flat)
![Xcode Version](https://img.shields.io/badge/Xcode-14.0.1-blue.svg?style=flat)

## Table of Contents
- [Introduction](#introduction)
- [Architecture](#architecture)
- [Characteristics](#characteristics)
- [Features](#features)
- [Demonstration](#demonstration)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Swift Package Manager (SPM)](#swift-package-manager-spm)

## Introduction
Pokedex-iOS is a comprehensive app for Pokémon enthusiasts, providing an interactive interface to explore regions, discover Pokédexes, and manage Pokémon teams. This project is entirely written in Swift and follows modern best practices and design patterns.

## Architecture
We use MVVM+Router for a clear separation of business logic and UI, improving code maintainability and testing. MVVM facilitates the abstraction of data models from the view controller, while 'Routers' manage navigation and transitions in a centralized and modular way.

## Characteristics
- **100% Swift 5**: Utilizing the latest language capabilities.
- **Combine**: Reactive event and server call management.
- **Image Caching**: Improved efficiency in image loading and display.
- **URLSession**: Robust communication with REST APIs.
- **Firebase Realtime Database**: Real-time data storage and synchronization.
- **Clean Code**: Structured and easy-to-maintain code.
- **Orientation Support**: Functional in landscape and portrait modes.
- **Color Modes**: Compatible with light and dark themes.
- **Error Handling**: Robust strategies for an enhanced UX.
- **Crashlytics**: Error monitoring and application stability.

## Features
- **List of regions**: Explore the various regions of the Pokémon world.
- **List of Pokédexes by region**: Discover the Pokédexes associated with each region.
- **List of Pokémon by region**: Find and learn about the Pokémon in each area.
- **Pokémon Teams**: Create and save custom teams with 3 to 6 Pokémon.
- **Cloud Storage**: Save and synchronize your teams via Firebase.
- **Sidebar Menu**: Intuitive navigation between application modules.

## Demonstration
See how the app works through the following demonstration videos:

[![Pokedex Demo](https://user-images.githubusercontent.com/100188413/212604424-093e38f4-fba0-4b48-9e99-587f32a516d2.mp4)](https://user-images.githubusercontent.com/100188413/212604424-093e38f4-fba0-4b48-9e99-587f32a516d2.mp4)

[![Pokedex Demo](https://user-images.githubusercontent.com/100188413/212605090-66c5a235-7edf-4d56-bd12-8b1516c2fbe1.mp4)](https://user-images.githubusercontent.com/100188413/212605090-66c5a235-7edf-4d56-bd12-8b1516c2fbe1.mp4)

## Prerequisites
- Xcode 14.0.1 or higher.
- iOS 16.0+ SDK.

## Installation
Follow these steps to install and run the project:

```bash
git clone https://github.com/Jmejia-24/Pokedex-iOS.git
cd Pokedex-iOS
open Pokedex-iOS.xcodeproj
# Wait for Xcode to install the necessary SPMs.
```

## Swift Package Manager (SPM)
The project uses SPM to manage dependencies. Here is the list of included packages:

- `Firebase`: Authentication and cloud storage.
- `GoogleSignIn`: Login with Google accounts.
- `CodableFirebase`: Serialization and deserialization of Firebase data.
- `FacebookLogin`: Integration with Facebook login.
- `IQKeyboardManagerSwift`: Automatic keyboard management.

With the project open in Xcode, you can compile and run the app on an iOS simulator or real device by selecting the appropriate scheme and pressing the Run button.
