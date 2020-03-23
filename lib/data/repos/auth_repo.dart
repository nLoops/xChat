import 'package:firebase_auth/firebase_auth.dart';
import 'package:xchat/data/providers/auth_provider.dart';
import 'package:xchat/data/providers/base_provider.dart';

class AuthenticationRepository {
  BaseAuthenticationProvider authenticationProvider = AuthenticationProvider();

  Future<FirebaseUser> signInWithGoogle() =>
      authenticationProvider.signInWithGoogle();

  Future<void> signOutUser() => authenticationProvider.signOutUser();

  Future<FirebaseUser> getCurrentUser() =>
      authenticationProvider.getCurrentUser();

  Future<bool> isLoggedIn() => authenticationProvider.isLoggedIn();
}