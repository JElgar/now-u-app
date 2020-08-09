import 'package:app/assets/StyleFrom.dart';
import 'package:app/assets/components/darkButton.dart';
import 'package:app/routes.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

void customLaunch(
  BuildContext context,
  String url,
  {
    String title,
    String description,
    String buttonText, 
    String closeButtonText,
    Function extraOnConfirmFunction,
    bool isExternal,
  }
) {
  if (isExternal ?? false) {
    customLaunchExternal(
      context,
      url,
      title: title,
      description: description,
      buttonText: buttonText,
      closeButtonText: closeButtonText,
      extraOnConfirmFunction: extraOnConfirmFunction,
    );
  }
  else {
    Navigator.of(context).pushNamed(Routes.webview, arguments: url);
  }
}

void customLaunchExternal(
  BuildContext context,
  String url,
  {
    String title,
    String description,
    String buttonText, 
    String closeButtonText,
    Function extraOnConfirmFunction,
  }
) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            content: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    title ?? "You're about to leave",
                    textAlign: TextAlign.center,
                    style: textStyleFrom(
                      Theme.of(context).primaryTextTheme.headline2,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      description ?? "This link will take you out of the app. Are you sure you want to go?",
                      style: textStyleFrom(
                        Theme.of(context).primaryTextTheme.bodyText1,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    child:
                      DarkButton(
                        buttonText ?? "Let's go",
                        onPressed: () {
                          if (extraOnConfirmFunction != null) {
                            extraOnConfirmFunction();
                          }
                          launch(url);
                        }
                      ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child:
                      DarkButton(
                        closeButtonText ?? "Close",
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        inverted: true
                      ),
                  ),
                  SizedBox(height: 20),
                ],
              )
            ),
          ));
}
