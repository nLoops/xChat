import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent([List props = const <dynamic>[]]) : super(props);
}

class AppLaunched extends AuthEvent {
  @override
  String toString() => 'AppLaunched';
}

class ClickedGoogleLogin extends AuthEvent {
  @override
  String toString() => 'ClickedGoogleLogin';
}

class LoggedIn extends AuthEvent {
  final FirebaseUser user;
  LoggedIn(this.user): super([user]);
  @override
  String toString() => 'LoggedIn';
}

class PickedProfilePicture extends AuthEvent{
  final File file;
  PickedProfilePicture(this.file): super([file]);
  @override
  String toString() => 'PickedProfilePicture';
}

class SaveProfile extends AuthEvent {
  final File profileImage;
  final int age;
  final String username;
  SaveProfile(this.profileImage, this.age, this.username): super([profileImage,age,username]);
  @override
  String toString() => 'SaveProfile';
}

class ClickedLogout extends AuthEvent {
  @override
  String toString() => 'ClickedLogout';
}