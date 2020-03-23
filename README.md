# xChat - A modern messaging app using the power of [Flutter](https://flutter.dev/)

## Features
- Android & IOS.
- Arabic & English.
- Personal & Group chat.
- Share attachments (files - photos - videos etc..)
- Emojis :D
- Google Sign-in.
- Search and send friends requests.
- Stories & camera picks
- filters

## BLoC Pattern

The Business Logic Component (BLoC) pattern is a pattern created by Google,
I used it to separate the business logic out of ui that's make the code base more flexible
in maintenance and also testable.

**Simple Diagram**
![img](https://hagaat.net/uploader/server/php/files/bloc.png)

## TDD - Test Driven Development

for the sake of produce a bug free software following TDD makes the development cycle shorter because of:

- first you write the test that will fail with the requirements in head.
- secondly you keep refactor the code that only pass this test.
- if you made any updates in the future your test cases will guarantee that your logic keep working as expected.

![tdd](https://www.tutorialspoint.com/software_testing_dictionary/images/code_driven_testing.jpg)

## CI/CD

Using GitHub actions and you can follow this [tutorial](https://medium.com/better-programming/ci-cd-for-flutter-apps-using-github-actions-b833f8f7aac)

## Backend - Firebase
Please follow this [code lab](https://codelabs.developers.google.com/codelabs/flutter-firebase/#0) in case you want to setup your database to be ready for Android & IOS.

# Getting Start
- Clone the repo or download it.
- replace add your firebase config files ```google-services.json``` for Android & ```GoogleService-Info.plist``` for IOS
- Enjoy.

** I will make sure to update this file**

For contact: [twitter](https://twitter.com/Elgammal112)
