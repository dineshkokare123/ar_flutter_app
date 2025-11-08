# ar_flutter_app
AR Flutter App: AR Size Estimator App

📝 Overview
This repository contains the source code for the [Your App Name] mobile application, developed using Flutter. This project utilizes the power of Augmented Reality (AR) to overlay digital content onto the real world using the device's camera.

The primary goal of this application is to [Describe your app's main purpose, e.g., "allow users to visualize 3D furniture models in their living space before purchase," or "provide an interactive educational experience by placing astronomical models"].

✨ Features
Platform Support: Fully cross-platform compatibility for both Android (ARCore) and iOS (ARKit).

Plane Detection: Automatically detects and tracks horizontal and vertical surfaces in the real environment.

3D Object Placement: Enables users to place and anchor [Specify your object type, e.g., "custom 3D assets" or "primitive shapes"] onto detected surfaces via touch interaction.

Object Manipulation: Supports interactive scaling, rotation, and translation of placed AR objects.

Real-time Rendering: Uses the high-performance Impeller rendering backend (Flutter) for smooth AR visualization.

🛠️ Technologies & Dependencies
This project is built using the Flutter framework and relies on several key packages for its AR functionality and core services:

Technology	Purpose
Flutter	Cross-platform mobile application framework.
Dart	Programming Language.
ar_flutter_plugin	Core package for bridging Flutter with native ARCore/ARKit APIs.
permission_handler	Handles required camera, storage, and location permissions reliably.
vector_math	Essential package for matrix and vector calculations needed for 3D graphics.
⚙️ Setup & Installation
To run this project locally, ensure you have the Flutter SDK installed and configured.

Prerequisites

Flutter SDK (v3.19.x or newer recommended)

Android Studio or VS Code with Flutter/Dart plugins.

A Physical Android Device supporting ARCore, or an iOS Device supporting ARKit (AR cannot be tested on standard emulators/simulators).

Steps:

Clone the Repository:
Bash
git clone https://github.com/dineshkokare123/ar_flutter_app
cd ar_flutter_app
Install Dependencies:

Bash
flutter pub get
Clean & Run (Android): A clean build is recommended, especially after resolving native dependency conflicts.

Bash
flutter clean
flutter run
(Note: Ensure your ARCore-compatible device is connected and selected before running.)

💡 Troubleshooting (For Future Developers)
During development, we encountered and resolved persistent native dependency conflicts related to the permission_handler and ar_flutter_plugin. The solution involves using dependency_overrides in pubspec.yaml to force modern package versions compatible with Flutter's v2 embedding API. If you encounter errors like cannot find symbol Registrar, verify the dependency_overrides section is active and correct.

🤝 Contribution
Feel free to fork this repository, submit issues, or contribute pull requests!
B. Surface Detection

The screen should show a live camera view.

The AR system needs to find a flat plane. You must slowly move your device across a textured surface (like a table, carpet, or floor).

The screen will show visual feedback (often a grid, dots, or crosshairs) when a flat surface is successfully detected. If you don't see this feedback, the AR environment hasn't initialized correctly.

C. Object Placement

With a plane detected, tap the screen (or follow your app's specific placement logic).

If your code is correct, a 3D object (cube, sphere, etc.) should appear anchored to the real-world surface.

Move the phone around the object: The object should remain fixed in its real-world position and perspective.

If you can successfully place an object and it stays locked in 3D space as you move the camera, your AR application is working correctly!

Screen Recording:

https://github.com/user-attachments/assets/12029251-c55d-4793-ab09-98bf217c08fe

