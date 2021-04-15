import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:running_society/supabase/config.dart';
import 'package:running_society/theme.dart';
import 'package:running_society/widgets/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeName = FocusNode();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    focusNodePassword.dispose();
    focusNodeConfirmPassword.dispose();
    focusNodeEmail.dispose();
    focusNodeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[
                      CustomTheme.loginGradientStart,
                      CustomTheme.loginGradientEnd
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 1.0),
                    stops: <double>[0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 75.0),
                    child: Image(
                        height:
                        MediaQuery.of(context).size.height > 800 ? 191.0 : 150,
                        fit: BoxFit.fill,
                        image: const AssetImage('assets/img/login_logo.png')),
                  ),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Card(
                        elevation: 2.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
                          width: 300.0,
                          height: 360.0,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, bottom: 5, left: 25.0, right: 25.0),
                                child: TextField(
                                  focusNode: focusNodeName,
                                  controller: signupNameController,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.words,
                                  autocorrect: false,
                                  style: const TextStyle(
                                      fontFamily: 'WorkSansSemiBold',
                                      fontSize: 16.0,
                                      color: Colors.black),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      FontAwesomeIcons.user,
                                      color: Colors.black,
                                    ),
                                    hintText: 'Name',
                                    hintStyle: TextStyle(
                                        fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
                                  ),
                                  onSubmitted: (_) {
                                    focusNodeEmail.requestFocus();
                                  },
                                ),
                              ),
                              Container(
                                width: 250.0,
                                height: 1.0,
                                color: Colors.grey[400],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, bottom: 5, left: 25.0, right: 25.0),
                                child: TextField(
                                  focusNode: focusNodeEmail,
                                  controller: signupEmailController,
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  style: const TextStyle(
                                      fontFamily: 'WorkSansSemiBold',
                                      fontSize: 16.0,
                                      color: Colors.black),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      FontAwesomeIcons.envelope,
                                      color: Colors.black,
                                    ),
                                    hintText: 'Email Address',
                                    hintStyle: TextStyle(
                                        fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
                                  ),
                                  onSubmitted: (_) {
                                    focusNodePassword.requestFocus();
                                  },
                                ),
                              ),
                              Container(
                                width: 250.0,
                                height: 1.0,
                                color: Colors.grey[400],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, bottom: 5, left: 25.0, right: 25.0),
                                child: TextField(
                                  focusNode: focusNodePassword,
                                  controller: signupPasswordController,
                                  obscureText: _obscureTextPassword,
                                  autocorrect: false,
                                  style: const TextStyle(
                                      fontFamily: 'WorkSansSemiBold',
                                      fontSize: 16.0,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: const Icon(
                                      FontAwesomeIcons.lock,
                                      color: Colors.black,
                                    ),
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(
                                        fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
                                    suffixIcon: GestureDetector(
                                      onTap: _toggleSignup,
                                      child: Icon(
                                        _obscureTextPassword
                                            ? FontAwesomeIcons.eye
                                            : FontAwesomeIcons.eyeSlash,
                                        size: 15.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  onSubmitted: (_) {
                                    focusNodeConfirmPassword.requestFocus();
                                  },
                                ),
                              ),
                              Container(
                                width: 250.0,
                                height: 1.0,
                                color: Colors.grey[400],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, bottom: 5.0, left: 25.0, right: 25.0),
                                child: TextField(
                                  focusNode: focusNodeConfirmPassword,
                                  controller: signupConfirmPasswordController,
                                  obscureText: _obscureTextConfirmPassword,
                                  autocorrect: false,
                                  style: const TextStyle(
                                      fontFamily: 'WorkSansSemiBold',
                                      fontSize: 16.0,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: const Icon(
                                      FontAwesomeIcons.lock,
                                      color: Colors.black,
                                    ),
                                    hintText: 'Confirm Password',
                                    hintStyle: const TextStyle(
                                        fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
                                    suffixIcon: GestureDetector(
                                      onTap: _toggleSignupConfirm,
                                      child: Icon(
                                        _obscureTextConfirmPassword
                                            ? FontAwesomeIcons.eye
                                            : FontAwesomeIcons.eyeSlash,
                                        size: 15.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  onSubmitted: (_) {
                                    _toggleSignUpButton();
                                  },
                                  textInputAction: TextInputAction.go,
                                ),
                              ),
                              Container(
                                width: 250.0,
                                height: 1.0,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 340.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: CustomTheme.loginGradientStart,
                              offset: Offset(1.0, 6.0),
                              blurRadius: 20.0,
                            ),
                            BoxShadow(
                              color: CustomTheme.loginGradientEnd,
                              offset: Offset(1.0, 6.0),
                              blurRadius: 20.0,
                            ),
                          ],
                          gradient: LinearGradient(
                              colors: <Color>[
                                Colors.deepOrangeAccent,
                                Colors.orangeAccent,
                              ],
                              begin: FractionalOffset(0.2, 0.2),
                              end: FractionalOffset(1.0, 1.0),
                              stops: <double>[0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: MaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.deepOrangeAccent,
                          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          child: const Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontFamily: 'WorkSansBold'),
                            ),
                          ),
                          onPressed: () => _toggleSignUpButton(),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextButton(
                        onPressed: () => Navigator.of(context).pop<void>(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: 'WorkSansMedium'),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _toggleSignUpButton() async {
    final response = await gotrueClient.signUp(signupEmailController.text, signupPasswordController.text);
    if (response.error != null) {
      CustomSnackBar(context, Text('Sign Up Failed'));
      signupPasswordController.clear();
      signupConfirmPasswordController.clear();
    } else if (response.data == null && response.user == null) {
      CustomSnackBar(context, Text('Email Verification Required'));
    } else {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString(PERSIST_SESSION_KEY, response.data!.persistSessionString);
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (context) {
            return LoginPage();
          },
        ),
      );
    }
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }
}
