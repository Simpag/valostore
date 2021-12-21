import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:valstore/api/api_models.dart';
import 'package:valstore/api/valo_api.dart';
import 'package:valstore/constants.dart';

import '../main.dart';
import 'general/custom_button.dart';

/*
    SET UP IOS BACKGROUND FETCH
    https://github.com/transistorsoft/flutter_background_fetch/blob/master/help/INSTALL-IOS.md 
*/

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => new _SignInState();
}

class _SignInState extends State<SignIn> {
  late TapGestureRecognizer _tosRecognizer;

  final _formKey = new GlobalKey<FormState>();
  bool _termsChecked = false;
  bool _rememberMeChecked = false;
  bool wrongPassword = false;
  String? username = "";
  String? password = "";

  @override
  void initState() {
    _tosRecognizer = TapGestureRecognizer()
      ..onTap = () => _launchURL(CustomUrls.TermsAndConditions);
    // If there already exists a user id then the user have accepted the terms before
    if (myAccount.user_id != "") _termsChecked = true;
    super.initState();
  }

  @override
  void dispose() {
    _tosRecognizer.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> keepAuthenticated() async {
    print("Keep authenticated!");
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: true,
            enableHeadless: false,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY), (String taskId) async {
      // <-- Event handler
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      try {
        myAccount = await ValoApi.reauth(myAccount);
      } catch (e) {
        print("Coult not reauth!");
      }
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: myAccount.loadLocally(),
      builder: (BuildContext _context, AsyncSnapshot<bool> snapshot) {
        Scaffold page;

        if (snapshot.hasData) {
          page = _signInPage();
        } else if (snapshot.hasError) {
          page = _errorPage(snapshot);
        } else {
          page = _loadingPage(snapshot);
        }
        return page;
      },
    );
  }

  Scaffold _errorPage(AsyncSnapshot<bool> snapshot) {
    HapticFeedback.vibrate();

    return new Scaffold(
      backgroundColor: CustomColors.Blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ],
        ),
      ),
    );
  }

  Scaffold _loadingPage(AsyncSnapshot<bool> snapshot) {
    return new Scaffold(
      backgroundColor: CustomColors.Blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text("Awaiting result..."),
            )
          ],
        ),
      ),
    );
  }

  Scaffold _signInPage() {
    return new Scaffold(
      backgroundColor: CustomColors.Blue,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                _buildLogo(),
                _buildUserName(),
                _buildPassword(),
                _buildRememberMe(),
                SizedBox(height: 10.0),
                _termsAndConditions(),
                SizedBox(height: 30.0),
                CustomButton(
                  title: "Sign In",
                  onPressed: _onSignInPressed,
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, String iconPath) {
    return InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: CustomColors.BorderGrey)),
        labelText: hint,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: CustomColors.BorderGrey)),
        labelStyle: TextStyle(color: CustomColors.BorderGrey),
        prefixIcon: iconPath != '' ? Image.asset(iconPath) : null,
        errorStyle: TextStyle(color: CustomColors.ErrorRed),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: CustomColors.ErrorRed)),
        focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: CustomColors.ErrorRed)));
  }

  Widget _buildLogo() {
    return Container(
      padding: EdgeInsets.only(bottom: 15.0),
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.longestSide / 3),
      child: Container(
        constraints: BoxConstraints(maxHeight: 10000),
        child: Image.asset(
          "assets/images/logo.png",
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildUserName() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: TextFormField(
        validator: (value) => isName(value),
        style: TextStyle(
          color: CustomColors.BorderGrey,
        ),
        decoration: _buildInputDecoration("Username", ""),
        onSaved: (val) => this.username = val,
        initialValue: "",
        onFieldSubmitted: (s) => _onSignInPressed(),
      ),
    );
  }

  Widget _buildPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        validator: (value) => isPassword(value),
        style: TextStyle(
          color: CustomColors.BorderGrey,
        ),
        decoration: _buildInputDecoration("Password", ''),
        obscureText: true,
        onSaved: (val) => this.password = val,
        initialValue: "",
        onFieldSubmitted: (s) => _onSignInPressed(),
      ),
    );
  }

  Widget _buildRememberMe() {
    return Container(
      padding: EdgeInsets.only(
        left: 15.0,
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Checkbox(
            value: _rememberMeChecked,
            activeColor: const Color(0xffFE424F),
            onChanged: (val) {
              setState(() => _rememberMeChecked = val!);
            },
          ),
          Text(
            "Remember me",
            style: new TextStyle(color: CustomColors.BorderGrey),
          ),
        ],
      ),
    );
  }

  String? isName(String? value) {
    if (value == null || value.isEmpty) {
      return "Username can't be empty!";
    } else if (wrongPassword) {
      return "Wrong password or username!";
    }

    return null;
  }

  String? isPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password can't be empty!";
    } else if (wrongPassword) {
      return "Wrong password or username!";
    }

    return null;
  }

  _termsAndConditions() {
    return Container(
      child: Row(
        children: [
          Checkbox(
            value: _termsChecked,
            activeColor: const Color(0xffFE424F),
            onChanged: (val) => setState(() => _termsChecked = val!),
          ),
          Flexible(
            child: _termsAndConditionsText(),
          ),
        ],
      ),
    );
  }

  _termsAndConditionsCheckText() {
    return Align(
      alignment: Alignment.center,
      child: !_termsChecked
          ? Padding(
              padding: EdgeInsets.fromLTRB(0, 5.0, 0, 0),
              child: Text(
                "Required",
                style: TextStyle(color: CustomColors.ErrorRed, fontSize: 12),
              ),
            )
          : Container(),
    );
  }

  _termsAndConditionsText() {
    return new RichText(
      text: new TextSpan(
        children: [
          new TextSpan(
            text: 'I agree with the ',
            style: new TextStyle(color: CustomColors.BorderGrey),
          ),
          new TextSpan(
            text: 'Terms and Conditions',
            style: new TextStyle(color: CustomColors.DarkerBlue),
            recognizer: _tosRecognizer,
          ),
          new TextSpan(
            text: ' and the ',
            style: new TextStyle(color: CustomColors.BorderGrey),
          ),
          new TextSpan(
            text: 'Privacy Policy.',
            style: new TextStyle(color: CustomColors.DarkerBlue),
            recognizer: _tosRecognizer,
          ),
          !_termsChecked
              ? TextSpan(
                  text: '\nRequired',
                  style: TextStyle(color: CustomColors.ErrorRed, fontSize: 12),
                )
              : TextSpan(),
        ],
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: true,
      );
    } else {
      print('Could not launch $url');
    }
  }

  Future<void> _onSignInPressed() async {
    wrongPassword = false;
    if (_validateInput()) {
      if (await _signIn()) {
        myAccount.rememberMe = _rememberMeChecked;
        print(myAccount.rememberMe);
        if (myAccount.rememberMe) await keepAuthenticated();
        _saveLocally();
        _nextPage();
      } else {
        wrongPassword = true;
        _validateInput(); // Show the user that the password is incorrect
      }
    }
  }

  Future<bool> _signIn() async {
    AccountData _myAccount;
    try {
      _myAccount = await ValoApi.auth(
        username!,
        password!,
      );
    } catch (e) {
      return false;
    }

    myAccount = _myAccount;
    return true;
  }

  _nextPage() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, StoreRoute);
  }

  bool _validateInput() {
    final FormState? _state = _formKey.currentState;
    if (_state == null) return false;

    if (_state.validate() && _termsChecked) {
      _state.save();
      return true;
    } else {
      return false;
    }
  }

  _saveLocally() {
    myAccount.saveLocally();
  }
}
