<img src = "images/main_logo@3x.png">

> A clean and simple workout log app created with Swift 5.

## Table of contents
* [General info](#general-info)
* [Screenshots](#screenshots)
* [Technologies](#technologies)
* [Requirements](#requirements)
* [Setup](#setup)
* [Cocoapods](#cocoapods)
* [Features](#features)
* [Status](#status)
* [Inspiration](#inspiration)
* [Contact](#contact)

## General info
The purpose of this project is to build a workout log app with a very minimalistic design in order
to emphasize the most essential components of a workout app, namely the date, the targeted muscle groups,
the exercises, the weight and repetitions for each workout set, as well as a timer to keep track of breaks in between sets. 

As an avid gym goer and fitness enthusiast, I was motivated to build this app when I started looking for workout logging apps 
that were very simple and rudimentary in function and deisgn. Most apps that I would come across would have a myriad of customizable options 
and would have you select from a number of pre-determined workouts or exercises, which was nice but it wasn't quite what I was looking for. 
What I wanted to achieve was the freedom to name my own workouts/muscle groups/exercises without having to choose from a limited list of options. 
I also wanted to avoid cluttering the UI as much as possible, which is why I kept the UI simple and to the point.


## Screenshots
<img src="images/login.png" width=180> <img src="images/workout.png" width=180> <img src="images/exercise.png" width=180> <img src="images/wsr1.png" width=180> <img src="images/wsr3.png" width=180>

## Technologies
* Swift 5
* Firebase SDK
* Cocoapods Version 1.9.3
* DEPENDENCIES:
  - FBSDKCoreKit (7.1.1)
  - FBSDKLoginKit (7.1.1)
  - Firebase/Analytics (6.6.1)
  - Firebase/Auth (6.6.0)
  - Firebase/Core (6.8.0)
  - FirebaseFirestoreSwift (0.3.0)
  - GoogleSignIn (5.0.2)
  - IQKeyboardManagerSwift (6.5.5)
  - RealmSwift (5.2.0)
  
## Requirements
* iOS 13+
* Xcode 11+

## Setup
* Clone and setup the project.
* Open in Xcode: open Effortflex.xcworkspace

## Cocoapods
The app uses some cocoapods. These should not need touching in general as a copy
of the code and project files is included in the repo. Just remember to open the
Effortflex.xcworkspace, not the Effortflex.xcproject.
To update the pods to latest versions matching our version constraints, install
cocoapods (sudo gem install cocoapods) and run pod update.
If you're having build issues due to missing dependencies, you might want to run
pod install and commit the changes to Podfile, Podfile.lock and Pods.

## Features
* Google, Facebook, and Email Authentication.
* Countdown Timer.

To-do list:
* Integrate RealmSwift to offer an client-side database alternative.
* Add a library of exercise images for the end-user to add as an option.

## Status
Project is: _in progress_, _finished_, _no longer continue_ and why?

## Inspiration
Add here credits. Project inspired by..., based on...

## Contact
Created by [](https://www.effortflex.com/) - feel free to contact me!
