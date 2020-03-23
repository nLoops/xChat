import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:xchat/data/models/user.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState ([List props = const <dynamic>[]]) : super(props);
}

class Uninitialized extends AuthState{
  @override
  String toString() => 'Uninitialized';
}

class AuthInProgress extends AuthState{
  @override
  String toString() => 'AuthInProgress';
}

class Authenticated extends AuthState{
  final FirebaseUser user;
  Authenticated(this.user);
  @override
  String toString() => 'Authenticated';
}

class PreFillData extends AuthState{
  final User user;
  PreFillData(this.user);
  @override
  String toString() => 'PreFillData';
}

class UnAuthenticated extends AuthState{
  @override
  String toString() => 'UnAuthenticated';
}

class ReceivedProfilePicture extends AuthState{
  final File file;
  ReceivedProfilePicture(this.file);
  @override toString() => 'ReceivedProfilePicture';
}

class ProfileUpdateInProgress extends AuthState{
  @override
  String toString() => 'ProfileUpdateInProgress';
}

class ProfileUpdated extends AuthState{
  @override
  String toString() => 'ProfileComplete';
}