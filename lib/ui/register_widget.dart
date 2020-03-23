import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:xchat/blocs/authentication/auth_bloc.dart';
import 'package:xchat/blocs/authentication/bloc.dart';
import 'package:xchat/ui/chat_list_widget.dart';
import 'package:xchat/values/anim.dart';
import 'package:xchat/values/assets.dart';
import 'package:xchat/values/colors.dart';
import 'package:xchat/values/styles.dart';

class RegisterWidget extends StatefulWidget {

  const RegisterWidget();

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int currentPage = 0;
  int age = 18;
  var isKeyboardOpen =
      false; //this variable keeps track of the keyboard, when its shown and when its hidden

  PageController pageController =
      PageController(); // this is the controller of the page. This is used to navigate back and forth between the pages

  //Fields related to animation of the gradient
  Alignment begin = Alignment.center;
  Alignment end = Alignment.bottomRight;

  //Fields related to animating the layout and pushing widgets up when the focus is on the username field
  AnimationController usernameFieldAnimationController;
  Animation profilePicHeightAnimation, usernameAnimation, ageAnimation;
  FocusNode usernameFocusNode = FocusNode();

  //fields for the form
  File profileImageFile;
  ImageProvider profileImage;
  final TextEditingController usernameController = TextEditingController();

  AuthBloc authBloc;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    usernameFieldAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    profilePicHeightAnimation =
        Tween(begin: 100.0, end: 0.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });
    usernameAnimation =
        Tween(begin: 50.0, end: 10.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });
    ageAnimation =
        Tween(begin: 80.0, end: 10.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });
    usernameFocusNode.addListener(() {
      if (usernameFocusNode.hasFocus) {
        usernameFieldAnimationController.forward();
      } else {
        usernameFieldAnimationController.reverse();
      }
    });
    pageController.addListener(() {
      setState(() {
        begin = Alignment(pageController.page, pageController.page);
        end = Alignment(1 - pageController.page, 1 - pageController.page);
      });
    });

    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.listen((state) {
      if (state is Authenticated) {
        updatePageState(1);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop, //user to override the back button press
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          //  avoids the bottom overflow warning when keyboard is shown
          body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: begin, end: end, colors: [
                Palette.gradientStartColor,
                Palette.gradientEndColor
              ])),
              child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    AnimatedContainer(
                        duration: Duration(milliseconds: 1500),
                        child: PageView(
                            controller: pageController,
                            physics: NeverScrollableScrollPhysics(),
                            onPageChanged: (int page) => updatePageState(page),
                            children: <Widget>[
                              buildPageOne(),
                              buildPageTwo()
                            ])),
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _indicators(),
                      ),
                    ),
                    AnimatedOpacity(
                        opacity: currentPage == 1 ? 1.0 : 0.0,
                        //shows only on page 1
                        duration: Duration(milliseconds: 500),
                        child: Container(
                            margin: EdgeInsets.only(right: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                FloatingActionButton(
                                  onPressed: () => navigateToHome(),
                                  elevation: 0,
                                  backgroundColor: Palette.primaryColor,
                                  child: Icon(
                                    Icons.done,
                                    color: Palette.secondaryColor,
                                    size: 36,
                                  ),
                                )
                              ],
                            )))
                  ])),
        ));
  }

  buildHome() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: begin, end: end, colors: [
              Palette.gradientStartColor,
              Palette.gradientEndColor
            ])),
        child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              PageView(
                  controller: pageController,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (int page) => updatePageState(page),
                  children: <Widget>[buildPageOne(), buildPageTwo()]),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _indicators(),
                ),
              ),
              buildUpdateProfileButtonWidget()
            ]));
  }

  buildCircularProgressBarWidget() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: begin, end: end, colors: [
              Palette.gradientStartColor,
              Palette.gradientEndColor
            ])),
        child: Container(
            child: Center(
              child: Column(children: <Widget>[
                buildHeaderSectionWidget(),
                Container(
                  margin: EdgeInsets.only(top: 100),
                  child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Palette.primaryColor)),
                )
              ]),
            )));
  }

  buildPageOne() {
    return Column(
      children: <Widget>[
        buildHeaderSectionWidget(), buildGoogleButtonWidget()
      ],
    );
  }

  buildHeaderSectionWidget() {
    return Column(children: <Widget>[
      Container(
          margin: EdgeInsets.only(top: 250),
          child: Image.asset(Assets.app_icon_fg, height: 100)),
      Container(
          margin: EdgeInsets.only(top: 30),
          child: Text('Messio Messenger',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)))
    ]);
  }

  buildGoogleButtonWidget() {
    return Container(
        margin: EdgeInsets.only(top: 100),
        child: FlatButton.icon(
            onPressed: () => BlocProvider.of<AuthBloc>(context)
                .add(ClickedGoogleLogin()),
            color: Colors.transparent,
            icon: Image.asset(
              Assets.google_button,
              height: 25,
            ),
            label: Text(
              'Sign In with Google',
              style: TextStyle(
                  color: Palette.primaryTextColorLight,
                  fontWeight: FontWeight.w800),
            )));
  }

  buildPageTwo() {
    return InkWell(
      // to dismiss the keyboard when the user tabs out of the TextField
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        }, child: Container(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          profileImage = Image.asset(Assets.AVATAR).image;
          if (state is PreFillData) {
            age = state.user.age != null ? state.user.age : 18;
            profileImage = Image.network(state.user.photoUrl).image;
          } else if (state is ReceivedProfilePicture) {
            profileImageFile = state.file;
            profileImage = Image.file(profileImageFile).image;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: profilePicHeightAnimation.value),
              buildProfilePictureWidget(),
              SizedBox(
                height: ageAnimation.value,
              ),
              Text(
                'How old are you?',
                style: Styles.questionLight,
              ),
              buildAgePickerWidget(),
              SizedBox(
                height: usernameAnimation.value,
              ),
              Text(
                'Choose a username',
                style: Styles.questionLight,
              ),
              buildUsernameWidget()
            ],
          );
        },
      ),
    ));
  }

  buildProfilePictureWidget() {
    return GestureDetector(
      onTap: pickImage,
      child: CircleAvatar(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.camera,
              color: Colors.white,
              size: 15,
            ),
            Text(
              'Set Profile Picture',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            )
          ],
        ),
        backgroundImage: profileImage,
        radius: 60,
      ),
    );
  }

  buildAgePickerWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        NumberPicker.horizontal(
            initialValue: age,
            minValue: 15,
            maxValue: 100,
            highlightSelectedValue: true,
            onChanged: (num value) {
              setState(() {
                age = value;
              });
            }),
        Text('Years', style: Styles.textLight)
      ],
    );
  }

  buildUsernameWidget() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        width: 120,
        child: TextField(
          textAlign: TextAlign.center,
          style: Styles.subHeadingLight,
          focusNode: usernameFocusNode,
          controller: usernameController,
          decoration: InputDecoration(
            hintText: '@username',
            hintStyle: Styles.hintTextLight,
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Palette.primaryColor, width: 0.1),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Palette.primaryColor, width: 0.1),
            ),
          ),
        ));
  }

  Future pickImage() async {
    profileImageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    authBloc.add(PickedProfilePicture(profileImageFile));
  }

  buildUpdateProfileButtonWidget() {
    return AnimatedOpacity(
        opacity: currentPage == 1 ? 1.0 : 0.0,
        //shows only on page 1
        duration: Duration(milliseconds: 500),
        child: Container(
            margin: EdgeInsets.only(right: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () => authBloc.add(SaveProfile(
                      profileImageFile, age, usernameController.text)),
                  elevation: 0,
                  backgroundColor: Palette.primaryColor,
                  child: Icon(
                    Icons.done,
                    color: Palette.secondaryColor,
                  ),
                )
              ],
            )));
  }

  updatePageState(index) {
    if (currentPage == index) return;
    if (index == 1)
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);

    setState(() {
      currentPage = index;
    });
  }

  List<Widget> _indicators() {
    final List<Widget> data = <Widget>[];
    for (int i = 0; i < 2; i++) {
      data.add(CircleIndicator(i == currentPage));
    }

    return data;
  }

  Future<bool> onWillPop() {
    if (currentPage == 1) {
      //go to first page if currently on second page
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    usernameFieldAnimationController.dispose();
    usernameFocusNode.dispose();
    super.dispose();
  }

  ///
  /// This routine is invoked when the window metrics have changed.
  ///
  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;
    if (value > 0) {
      if (isKeyboardOpen) {
        onKeyboardChanged(false);
      }
      isKeyboardOpen = false;
    } else {
      isKeyboardOpen = true;
      onKeyboardChanged(true);
    }
  }

  onKeyboardChanged(bool isVisible) {
    if (!isVisible) {
      FocusScope.of(context).requestFocus(FocusNode());
      usernameFieldAnimationController.reverse();
    }
  }

  navigateToHome() {
    Navigator.push(
      context,
      SlideLeftRoute(page: ChatList()),
    );
  }
}

class CircleIndicator extends StatefulWidget {
  final bool isActive;

  const CircleIndicator(this.isActive);

  @override
  _CircleIndicatorState createState() => _CircleIndicatorState();
}

class _CircleIndicatorState extends State<CircleIndicator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: widget.isActive ? 12 : 8,
      width: widget.isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: widget.isActive
              ? Palette.primaryColor
              : Palette.secondaryTextColorLight,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}
