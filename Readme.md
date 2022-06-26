# MyDailyLog

## Introduction
<img src="https://github.com/steveshi0/MyDailyLog/blob/main/MyDailyLogIcon.png" width="200">

<img src="https://github.com/steveshi0/MyDailyLog/blob/main/screenshots/all-ex.png" height="500">

A blogging iOS app written in Swift where users can log their daily day to day activies. The apps offers functionalities such as account creation, log creation, log list view and browse their profile where they can sign out and view the total amount of logs posted in the account lifetime.

## Implementation

The apps was written in Swift with the SwiftUI framework, following the MVVM app architecture. Utilizing FireBase for the backend functionalities. Authentification was done via FireBaseAuth. Each Blog object, which contains the body-text, image-caption, actual image and the timestamp was recorded using Firebase FireStore and Storage.

## Want to try it out?

To run the project, you can simply use the FireBase instance currently in the app. Or I recommend creating an project within FireBase and upload the GoogleService-Info.pList where you can access the database and see first hand how data is being stored. The is all free and shouldn't take too long.
