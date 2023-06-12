# Reddit Challenge

This repository contains an iOS app that uses the following API:

https://www.reddit.com/r/chile

## Installation
 ```
 git clone https://github.com/AgustinGarciaDev/Challenge-Ionix.git
 cd Challenge-Ionix
 open Reddit.xcodeproj
 ```
## Running the Project

1. Open Reddit.xcodeproj in Xcode.
2. Select the target device or simulator.
3. Build and run the project by clicking the "Run" button or using the shortcut Cmd + R.

# Implementation details:
* Xcode 14.3 / iOS 14
* No external library
* Supports iPhone
* Unit tests XCTest

## Architecture and patterns used:
* Clean Architecture https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
* Advanced iOS App Architecture https://www.raywenderlich.com/8477-introducing-advanced-ios-app-architecture
* MVVM
* Observable
* Dependency Injection
* Flow Coordinator
* UIKit Views in code
* Error handling
* CI GitHub actions + Fastlane
* Test Given-When-Then
