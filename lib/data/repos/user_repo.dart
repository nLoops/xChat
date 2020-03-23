import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xchat/data/models/user.dart';
import 'package:xchat/data/providers/base_provider.dart';
import 'package:xchat/data/providers/user_provider.dart';

class UserDataRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider(fireStoreDb: Firestore.instance);

  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user) =>
      userDataProvider.saveDetailsFromGoogleAuth(user);

  Future<User> saveProfileDetails(
      String uid, String profileImageUrl, int age, String username) =>
      userDataProvider.saveProfileDetails(uid, profileImageUrl, age, username);

  Future<bool> isProfileComplete(String uid) =>
      userDataProvider.isProfileComplete(uid);
}