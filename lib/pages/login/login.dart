import 'package:app/assets/StyleFrom.dart';
import 'package:flutter/gestures.dart';
import 'package:app/assets/components/darkButton.dart';
import 'package:app/assets/components/inputs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:app/viewmodels/login_model.dart';

import 'package:app/services/storage.dart';

import 'package:stacked/stacked.dart';

enum LoginTypes { Login, Signup }

class LoginPageArguments {
  final LoginTypes loginType;

  LoginPageArguments({this.loginType});
}

class LoginPage extends StatefulWidget {
  final LoginPageArguments args;

  LoginPage(this.args);

  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  String _email;
  String _name;
  bool _newsletterSignup = false;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _repositry = SecureStorageService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final email = CustomTextFormField(
      style: CustomFormFieldStyle.Dark,
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      backgroundColor: Colors.white,
      hintTextColor: Colors.grey[400],
      autofocus: false,
      validator: (value) {
        if (value.isEmpty) return "Email cannot be empty";
        if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z-]+")
            .hasMatch(value)) {
          return "Email must be a valid email address";
        }
        return null;
      },
      onSaved: (value) {
        print("Saved");
        _email = value;
        _repositry.setEmail(value);
      },
      hintText: 'e.g. jane.doe@email.com',
    );

    final name = CustomTextFormField(
      style: CustomFormFieldStyle.Dark,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      backgroundColor: Colors.white,
      hintTextColor: Colors.grey[400],
      autofocus: false,
      validator: (value) {
        if (value.isEmpty) return "Name cannot be empty";
        return null;
      },
      onSaved: (value) {
        print("Saved");
        _name = value;
        _repositry.setName(value);
      },
      hintText: 'Jane Doe',
    );

    final acceptTandC = CustomCheckboxFormField(
      title: RichText(
        text: TextSpan(
            style: textStyleFrom(
              Theme.of(context).primaryTextTheme.bodyText1,
              color: Colors.black,
            ),
            children: [
              TextSpan(text: "I agree to the user "),
              TextSpan(
                  text: "Terms & Conditions",
                  style: textStyleFrom(
                    Theme.of(context).primaryTextTheme.bodyText1,
                    color: Theme.of(context).buttonColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch(
                          "https://share.now-u.com/legal/terms_and_conditions.pdf");
                    }),
            ]),
      ),
      validator: (value) {
        if (!value) return "You must accept our terms and conditions";
        return null;
      },
    );

    final newsletterSignup = CustomCheckboxFormField(
      title: RichText(
        text: TextSpan(
            style: textStyleFrom(
              Theme.of(context).primaryTextTheme.bodyText1,
              color: Colors.black,
            ),
            children: [
              TextSpan(text: "I am happy to receive the now-u newsletter"),
            ]),
      ),
      onSaved: (value) {
        _newsletterSignup = value;
      },
    );

    Widget createAccountButton() {
      Future<bool> validateAndSave(LoginViewModel model) async {
        final FormState form = _formKey.currentState;
        if (form.validate()) {
          form.save();
          //if (stagingUsers.contains(_email)) {
          //  model.switchToStagingBranch();
          //}
          model.email(
              email: _email, name: _name, newsletterSignup: _newsletterSignup);
          return true;
        }
        return false;
      }

      return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        builder: (context, model, child) => Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: CustomWidthButton(
            'Create Account',
            backgroundColor: Theme.of(context).primaryColor,
            buttonWidth: 250.0,
            onPressed: () {
              print("Button pressed");
              validateAndSave(model);
            },
            fontSize: 18.0,
            size: DarkButtonSize.Large,
          ),
        ),
      );
    }

    Widget facebookLoginButton() {
      return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        builder: (context, model, child) => Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: CustomWidthButton(
            'Skip',
            backgroundColor: Colors.white,
            textColor: Theme.of(context).primaryColor,
            buttonWidth: 250.0,
            onPressed: () {
              print("Button pressed");
              model.facebookLogin();
            },
            fontSize: 18.0,
            size: DarkButtonSize.Large,
          ),
        ),
      );
    }

    Form loginForm() {
      return Form(
          key: _formKey,
          child: Padding(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: SafeArea(
                child: Column(
                  //shrinkWrap: true,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 60, bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Sign up to now-u",
                                  style: textStyleFrom(
                                      Theme.of(context)
                                          .primaryTextTheme
                                          .headline3,
                                      color: Color(0XFF011A43),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 36.0),
                                ),
                              ),
                              Expanded(child: SizedBox())
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomIconButton(onPressed: (){}, icon: FontAwesomeIcons.google, size: DarkButtonSize.Small),
                          CustomIconButton(onPressed: (){}, icon: FontAwesomeIcons.facebookF, size: DarkButtonSize.Small),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Name",
                            style: textStyleFrom(
                              Theme.of(context).primaryTextTheme.headline5,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 8),
                        name,
                        SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email",
                            style: textStyleFrom(
                              Theme.of(context).primaryTextTheme.headline5,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 8),
                        email,
                        SizedBox(height: 20),
                        acceptTandC,
                        newsletterSignup,
                        createAccountButton(),
                        facebookLoginButton(),
                        SizedBox(height: 10),
                        ViewModelBuilder<LoginViewModel>.reactive(
                            viewModelBuilder: () => LoginViewModel(),
                            builder: (context, model, child) {
                              return RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: "View our privacy policy ",
                                      style: textStyleFrom(
                                        Theme.of(context)
                                            .primaryTextTheme
                                            .bodyText1,
                                        color: Colors.black,
                                      )),
                                  TextSpan(
                                      text: "here",
                                      style: textStyleFrom(
                                        Theme.of(context)
                                            .primaryTextTheme
                                            .bodyText1,
                                        color: Theme.of(context).buttonColor,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          model.launchTandCs();
                                        }),
                                ]),
                              );
                            }),
                        SizedBox(height: 10),
                      ],
                    ),

                    // Uncomment to readd Skip button
                    //skipButton(),
                  ],
                ),
              )));
    }

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color(0XFFE5E5E5),
          body: NotificationListener(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowGlow();
                return null;
              },
              child: ListView(children: [
                loginForm(),
              ])),
        ));
  }
}
