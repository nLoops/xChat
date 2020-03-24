import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xchat/blocs/authentication/auth_bloc.dart';
import 'package:xchat/blocs/authentication/auth_event.dart';
import 'package:xchat/blocs/authentication/auth_state.dart';
import 'package:xchat/data/models/user.dart';

import '../mocks/firebase.dart';
import '../mocks/io.dart';
import '../mocks/repos.dart';

void main(){
  AuthBloc authBloc;
  AuthRepoMock authRepoMock;
  UserRepoMock userRepoMock;
  StorageRepoMock storageRepoMock;
  FirebaseUserMock firebaseUserMock;
  User user;
  MockFile file;
  int age;
  String username;
  String profilePictureURL;
  
  setUp((){
    authRepoMock = AuthRepoMock();
    userRepoMock = UserRepoMock();
    storageRepoMock = StorageRepoMock();
    firebaseUserMock = FirebaseUserMock();
    user = User();
    file = MockFile();
    age = 28;
    username = 'Ahmed Ibrahim';
    profilePictureURL = 'https://nloops.github.io';

    authBloc = AuthBloc(authenticationRepository: authRepoMock,
    userDataRepository: userRepoMock, storageRepository: storageRepoMock);
  });
  
  tearDown((){
    authBloc?.close();
  });


  test('initial state is always AuthInProgress', (){
    expect(authBloc.initialState, Uninitialized());
  });

  //test the sequence of event emissions for different conditions
  group('AppLaunched', () {
    test('emits [Uninitialized -> Unauthenticated] when not logged in', () {
      when(authRepoMock.isLoggedIn())
          .thenAnswer((_) => Future.value(false));
      final expectedStates = [
        Uninitialized(),
        AuthInProgress(),
        UnAuthenticated()
      ];
      expectLater(authBloc.state, emitsInOrder(expectedStates));

      authBloc.add(AppLaunched());
    });
    test('emits [Uninitialized -> ProfileUpdated] when user is logged in and profile is complete', () {
      when(authRepoMock.isLoggedIn())
          .thenAnswer((_) => Future.value(true));
      when(authRepoMock.getCurrentUser())
          .thenAnswer((_) => Future.value(FirebaseUserMock()));
      when(userRepoMock.isProfileComplete(any))
          .thenAnswer((_) => Future.value(true));
      final expectedStates = [
        Uninitialized(),
        AuthInProgress(),
        ProfileUpdated()
      ];
      expectLater(authBloc.state, emitsInOrder(expectedStates));

      authBloc.add(AppLaunched());
    });
    test('emits [Uninitialized -> AuthInProgress -> Authenticated -> ProfileUpdateInProgress -> PreFillData] when user is logged in and profile is not complete', () {
      when(authRepoMock.isLoggedIn())
          .thenAnswer((_) => Future.value(true));
      when(authRepoMock.getCurrentUser())
          .thenAnswer((_) => Future.value(firebaseUserMock));
      when(userRepoMock.isProfileComplete(any))
          .thenAnswer((_) => Future.value(false));
      final expectedStates = [
        Uninitialized(),
        AuthInProgress(),
        Authenticated(firebaseUserMock),
        ProfileUpdateInProgress(),
        PreFillData(user)
      ];
      expectLater(authBloc.state, emitsInOrder(expectedStates));

      authBloc.add(AppLaunched());
    });
  });

  group('ClickedGoogleLogin', () {
    test('emits [AuthInProgress -> ProfileUpdated] when the user clicks Google Login button and after login result, the profile is complete', () {
      when(authRepoMock.signInWithGoogle())
          .thenAnswer((_) => Future.value(firebaseUserMock));
      when(userRepoMock.isProfileComplete(any))
          .thenAnswer((_) => Future.value(true));
      final expectedStates = [
        Uninitialized(),
        AuthInProgress(),
        ProfileUpdated()
      ];
      expectLater(authBloc.state, emitsInOrder(expectedStates));
      authBloc.add(ClickedGoogleLogin());
    });

    test('emits [AuthInProgress -> Authenticated -> ProfileUpdateInProgress -> PreFillData] when the user clicks Google Login button and after login result, the profile is found to be incomplete', () {
      when(authRepoMock.signInWithGoogle())
          .thenAnswer((_) => Future.value(firebaseUserMock));
      when(userRepoMock.isProfileComplete(any))
          .thenAnswer((_) => Future.value(false));
      final expectedStates = [
        Uninitialized(),
        AuthInProgress(),
        Authenticated(firebaseUserMock),
        ProfileUpdateInProgress(),
        PreFillData(user)
      ];
      expectLater(authBloc.state, emitsInOrder(expectedStates));
      authBloc.add(ClickedGoogleLogin());
    });
  });

  group('LoggedIn', () {
    test('emits [ProfileUpdateInProgress -> PreFillData] when trigged, this event is trigged once gauth is done and profile is not complete', () {
      when(userRepoMock.saveDetailsFromGoogleAuth(firebaseUserMock))
          .thenAnswer((_) => Future.value(user));
      final expectedStates = [
        Uninitialized(),
        ProfileUpdateInProgress(),
        PreFillData(user)
      ];
      expectLater(authBloc.state, emitsInOrder(expectedStates));

      authBloc.add(LoggedIn(firebaseUserMock));
    });
  });

  group('PickedProfilePicture', () {
    test('emits [ReceivedProfilePicture] everytime', () {
      final expectedStates = [Uninitialized(), ReceivedProfilePicture(file)];
      expectLater(authBloc.state, emitsInOrder(expectedStates));
      authBloc.add(PickedProfilePicture(file));
    });
  });

  group('SaveProfile', () {
    test('emits [ProfileUpdateInProgress -> ProfileUpdated] everytime SaveProfile is dispatched', () {
      when(storageRepoMock.uploadImage(any, any))
          .thenAnswer((_) => Future.value(profilePictureURL));
      when(authRepoMock.getCurrentUser())
          .thenAnswer((_) => Future.value(firebaseUserMock));
      when(userRepoMock.saveProfileDetails(any, any, any, any))
          .thenAnswer((_) => Future.value(user));
      final expectedStates = [
        Uninitialized(),
        ProfileUpdateInProgress(),
        ProfileUpdated()
      ];
      expectLater(authBloc.state, emitsInOrder(expectedStates));
      authBloc.add(SaveProfile(file, age, username));
    });
  });

  group('ClickedLogout', () {
    test('emits [UnAuthenticated] when clicked logout', () {
      final expectedStates = [Uninitialized(), UnAuthenticated()];
      expectLater(authBloc.state, emitsInOrder(expectedStates));
      authBloc.add(ClickedLogout());
    });
  });

  test('emits no states after calling dispose', () {
    expectLater(
      authBloc.state,
      emitsInOrder([]),
    );
    authBloc.close();
  });
}
