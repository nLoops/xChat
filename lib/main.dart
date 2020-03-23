import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xchat/blocs/authentication/auth_bloc.dart';
import 'package:xchat/blocs/authentication/auth_event.dart';
import 'package:xchat/blocs/authentication/auth_state.dart';
import 'package:xchat/data/repos/storage_repo.dart';
import 'package:xchat/ui/chat_list_widget.dart';
import 'package:xchat/ui/register_widget.dart';
import 'package:xchat/values/colors.dart';

import 'data/repos/auth_repo.dart';
import 'data/repos/user_repo.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => AuthBloc(
        authenticationRepository: AuthenticationRepository(),
        userDataRepository: UserDataRepository(),
        storageRepository: StorageRepository())
      ..add(AppLaunched()),
    child: App(),
  ));
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'xChat',
        theme: ThemeData(
            primaryColor: Palette.primaryColor,
            primaryColorDark: Palette.primaryDark,
            accentColor: Palette.secondaryColor),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is UnAuthenticated) {
              return RegisterWidget();
            } else if (state is ProfileUpdated) {
              return ChatList();
            } else {
              return RegisterWidget();
            }
          },
        ));
  }
}
