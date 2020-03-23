import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xchat/data/models/user.dart';
import 'package:xchat/data/repos/auth_repo.dart';
import 'package:xchat/data/repos/storage_repo.dart';
import 'package:xchat/data/repos/user_repo.dart';
import 'package:xchat/values/paths.dart';

import './Bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final AuthenticationRepository authenticationRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;

  AuthBloc(
      {this.authenticationRepository,
        this.userDataRepository,
        this.storageRepository})
      : assert(authenticationRepository != null),
        assert(userDataRepository != null),
        assert(storageRepository != null);

  @override
  AuthState get initialState => Uninitialized();

  @override
  Stream<AuthState> mapEventToState(
      AuthEvent event,
      ) async* {
    print(event);
    if (event is AppLaunched) {
      yield* mapAppLaunchedToState();
    }
    if (event is ClickedGoogleLogin) {
      yield* mapClickedGoogleLoginToState();
    }
    if (event is LoggedIn) {
      yield* mapLoggedInToState(event.user);
    }
    if (event is PickedProfilePicture) {
      yield ReceivedProfilePicture(event.file);
    }
    if (event is SaveProfile) {
      yield* mapSaveProfileToState(
          event.profileImage, event.age, event.username);
    }
    if (event is ClickedLogout) {
      yield* mapLoggedOutToState();
    }
  }

  Stream<AuthState> mapAppLaunchedToState() async* {
    try {
      yield AuthInProgress(); //show the progress bar
      final isSignedIn = await authenticationRepository.isLoggedIn(); // check if user is signed in
      if (isSignedIn) {
        final user = await authenticationRepository.getCurrentUser();
        bool isProfileComplete =
        await userDataRepository.isProfileComplete(user.uid); // if he is signed in then check if his profile is complete
        print(isProfileComplete);
        if (isProfileComplete) {      //if profile is complete then redirect to the home page
          yield ProfileUpdated();
        } else {
          yield Authenticated(user); // else yield the authenticated state and redirect to profile page to complete profile.
          add(LoggedIn(user)); // also disptach a login event so that the data from gauth can be prefilled
        }
      } else {
        yield UnAuthenticated(); // is not signed in then show the home page
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      yield UnAuthenticated();
    }
  }

  Stream<AuthState> mapClickedGoogleLoginToState() async* {
    yield AuthInProgress();  //show progress bar
    try {
      FirebaseUser firebaseUser =
      await authenticationRepository.signInWithGoogle(); // show the google auth prompt and wait for user selection, retrieve the selected account
      bool isProfileComplete =
      await userDataRepository.isProfileComplete(firebaseUser.uid); // check if the user's profile is complete
      print('isProfileComplete $isProfileComplete');
      if (isProfileComplete) {
        yield ProfileUpdated(); //if profile is complete go to home page
      } else {
        yield Authenticated(firebaseUser); // else yield the authenticated state and redirect to profile page to complete profile.
        add(LoggedIn(firebaseUser)); // also dispatch a login event so that the data from gauth can be prefilled
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      yield UnAuthenticated(); // in case of error go back to first registration page
    }
  }

  Stream<AuthState> mapLoggedInToState(
      FirebaseUser firebaseUser) async* {
    yield ProfileUpdateInProgress(); // shows progress bar
    User user =
    await userDataRepository.saveDetailsFromGoogleAuth(firebaseUser); // save the gAuth details to firestore database
    yield PreFillData(user); // prefill the gauth data in the form
  }

  Stream<AuthState> mapSaveProfileToState(
      File profileImage, int age, String username) async* {
    yield ProfileUpdateInProgress(); // shows progress bar
    String profilePictureUrl = await storageRepository.uploadImage(
        profileImage, Paths.profilePicturePath); // upload image to firebase storage
    FirebaseUser user = await authenticationRepository.getCurrentUser(); // retrieve user from firebase
    await userDataRepository.saveProfileDetails(
        user.uid, profilePictureUrl, age, username); // save profile details to firestore
    yield ProfileUpdated(); //redirect to home page
  }

  Stream<AuthState> mapLoggedOutToState() async* {
    yield UnAuthenticated(); // redirect to login page
    authenticationRepository.signOutUser(); // terminate session
  }

}
