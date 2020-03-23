

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xchat/data/providers/auth_provider.dart';

import '../mocks/firebase.dart';

/// the purpose of unit test is test my units not the dependencies so we mock the dependencies
/// because already Google and Firebase tested their dependencies.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthenticationProvider', () {
    //Mock and inject the basic dependencies in the AuthenticationProvider
    FirebaseAuthMock firebaseAuth = FirebaseAuthMock();
    GoogleSignInMock googleSignIn = GoogleSignInMock();

    // construct our class/unit.
    AuthenticationProvider authenticationProvider = AuthenticationProvider(
        firebaseAuth: firebaseAuth, googleSignIn: googleSignIn);

    //Mock rest of the objects needed to replicate the AuthenticationProvider functions
    final GoogleSignInAccountMock googleSignInAccount =
    GoogleSignInAccountMock();
    final GoogleSignInAuthenticationMock googleSignInAuthentication =
    GoogleSignInAuthenticationMock();
    final FirebaseUserMock firebaseUser = FirebaseUserMock();

    test('signInWithGoogle returns a Firebase user', () async {
      //mock the method calls
      when(googleSignIn.signIn()).thenAnswer(
              (_) => Future<GoogleSignInAccountMock>.value(googleSignInAccount));

      when(googleSignInAccount.authentication).thenAnswer((_) =>
      Future<GoogleSignInAuthenticationMock>.value(
          googleSignInAuthentication));

      when(firebaseAuth.currentUser())
          .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUser));

      //call the method and expect the Firebase user as return
      expect(await authenticationProvider.signInWithGoogle(), firebaseUser);
      verify(googleSignIn.signIn()).called(1);
      verify(googleSignInAccount.authentication).called(1);
    });
  });
}