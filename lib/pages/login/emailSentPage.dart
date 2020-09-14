import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent/android_intent.dart';

import 'package:app/assets/components/darkButton.dart';
import 'package:app/assets/components/textButton.dart';

import 'package:app/viewmodels/login_model.dart';
import 'package:stacked/stacked.dart';

import 'package:app/routes.dart';

import 'package:app/pages/login/login.dart';

class EmailSentPageArguments {
  final String email;
  final String token;
  EmailSentPageArguments({
    @required this.email,
    this.token,
  });
}

class EmailSentPage extends StatefulWidget {
  final EmailSentPageArguments args;
  EmailSentPage(this.args);

  @override
  _EmailSentPageState createState() => _EmailSentPageState();
}

class _EmailSentPageState extends State<EmailSentPage> {
  String token;

  @override
  void initState() {
    token = widget.args.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        onModelReady: (model) {
          if (token != null) {
            if (model.currentUser == null || model.currentUser.token == null) {
              model.login(email: widget.args.email, token: token);
            } else {
              Navigator.of(context).pushNamed(Routes.home);
            }
          }
        },
        builder: (context, model, child) {
          return Stack(children: <Widget>[
            Scaffold(
                body: Container(
                    color: Theme.of(context).primaryColorDark,
                    child: Column(
                      children: <Widget>[
                        SafeArea(
                          child: Container(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                        ),
                        token == null
                            ? Container()
                            : Container(
                                height: 40, child: CircularProgressIndicator()),
                        Expanded(
                          child: Container(
                            //physics: NeverScrollableScrollPhysics(),
                            child: IntroPageSection(
                              "Check your email",
                              "We have just sent an email to ${widget.args.email}",
                              "It has a link that will sign you in to now-u and get you started",
                              AssetImage('assets/imgs/intro/il-mail@4x.png'),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Container(
                                width: double.infinity,
                                child: DarkButton("Open Email", onPressed: () {
                                  // TODO open email
                                  openEmailApp(context);
                                }))),
                        SizedBox(height: 20),
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomTextButton("I did not recieve an email",
                                  onClick: () {
                                Navigator.of(context).pushNamed(Routes.login,
                                    arguments: LoginPageArguments(
                                      retry: true,
                                    ));
                              }),
                            ]),
                        SizedBox(height: 10),
                      ],
                    ))),
          ]);
        });
  }
}

class IntroPageSection extends StatelessWidget {
  final String title;
  final String description1;
  final String description2;
  final AssetImage image;

  IntroPageSection(
      this.title, this.description1, this.description2, this.image);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Image(image: image),
          ),
        ),
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(title,
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).primaryTextTheme.headline1.fontSize,
                    fontWeight:
                        Theme.of(context).primaryTextTheme.headline1.fontWeight,
                    color: Colors.white,
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(description2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1
                            .fontSize,
                        fontWeight: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1
                            .fontWeight,
                        color: Colors.white,
                      ))),
              SizedBox(
                height: 5,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(description1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1
                            .fontSize,
                        fontWeight: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1
                            .fontWeight,
                        color: Colors.white,
                      )))
            ],
          ),
        ),
      ],
    );
  }
}

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(opacity: animation1, child: child);
          },
        );
}

void openEmailApp(BuildContext context) {
  if (Platform.isAndroid) {
    AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.MAIN',
      category: 'android.intent.category.APP_EMAIL',
    );
    intent.launch().catchError((e) {});
  } else if (Platform.isIOS) {
    launch("message://").catchError((e) {});
  }
}
