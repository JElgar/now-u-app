import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flushbar/flushbar.dart';
import 'dart:math';

import 'package:app/assets/routes/customRoute.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:app/models/Badge.dart';
import 'package:app/models/Campaign.dart';
import 'package:app/models/Action.dart';
import 'package:app/models/ViewModel.dart';
import 'package:app/models/Reward.dart';

import 'package:app/pages/other/RewardComplete.dart';

import 'package:app/routes.dart';

import 'package:app/assets/StyleFrom.dart';
import 'package:app/assets/components/progress.dart';

List<String> actionSuccessTitle = [
  "Amazing work!",
  "Way to go!",
  "Great work!",
  "Keep it up!",
];
List<String> actionSuccessMessages = [
  "Every action you take is a small step towards creating lasting and sustainable change. Thank you for being a part of the now-u community, working together to make a difference!",
];
List<String> campaignSuccessTitle = [
  "Thank you!",
  "Amazing!",
  "Brilliant!",
];
List<String> campaignSuccessMessages = [
  "As part of this now-u community of campaigners, we hope that our combined actions will help make a real difference to this incredibly important issue.",
];

//void joinCampaign(
//    ViewModel viewModel, BuildContext context, Campaign campaign) {
//  if (!viewModel.userModel.user
//      .getSelectedCampaigns()
//      .contains(campaign.getId())) {
//    //viewModel.userModel.user.addSelectedCamaping(campaign.getId());
//    viewModel.onJoinCampaign(campaign,
//        (int points, int userPoints, int nextBadgePoints, bool newBadge) {
//      if (!newBadge) {
//        pointsNotifier(userPoints, points, nextBadgePoints, context)
//          ..show(context);
//      } else {
//        Text("You did not get a new badge");
//        gotBadgeNotifier(
//          badge: getNextBadgeFromInt(userPoints),
//          context: context,
//        );
//      }
//    });
//  }
//}

// WARNING
// This has got terrible out of hand
// This needs to go

//void completeAction(
//    ViewModel viewModel, BuildContext context, CampaignAction action) {
//  print("In complete action function");
//  print(viewModel.userModel.user.getCompletedActions());
//  print(action.getId());
//  if (!viewModel.userModel.user
//      .getCompletedActions()
//      .contains(action.getId())) {
//    print("Calling on complete action");
//    viewModel.onCompleteAction(action,
//        (int userPoints, int points, int nextBadgePoints, bool newBadge) {
//      // If you did not get a new badge
//      if (!newBadge) {
//        List<Reward> newlyCompletedRewards =
//            viewModel.userModel.user.newlyCompletedRewards(action);
//        // If you did get a new reward
//        if (newlyCompletedRewards.length > 0) {
//          Navigator.push(
//              context,
//              CustomRoute(
//                  builder: (context) =>
//                      RewardCompletePage(viewModel, newlyCompletedRewards)));
//        }
//        // Otherwise just shw the popup
//        else {
//          pointsNotifier(userPoints, points, nextBadgePoints, context)
//            ..show(context);
//        }
//      }
//      // If you did get a new badge then show that popup
//      else {
//        Text("You did not get a new badge");
//        gotBadgeNotifier(
//          badge: getNextBadgeFromInt(viewModel.userModel.user.getPoints()),
//          context: context,
//        );
//      }
//    });
//  }
//}

Flushbar pointsNotifier(int userPoints, int earnedPoints, int nextBadgePoints,
    BuildContext context) {
      var rng = new Random();
      int index = rng.nextInt(earnedPoints == 10 ? campaignSuccessTitle.length : actionSuccessTitle.length);
      int index2 = rng.nextInt(earnedPoints == 10 ? campaignSuccessMessages.length : actionSuccessMessages.length);
  return notifier(
      //"Congrats! You just earned ${earnedPoints} points! ${nextBadgePoints - (userPoints)} points till your next badge",
      earnedPoints == 10 ? campaignSuccessTitle[index] : actionSuccessTitle[index],
      earnedPoints == 10 ? campaignSuccessMessages[index2] : actionSuccessMessages[index2],
      userPoints / nextBadgePoints,
      context);
}

Flushbar notifier(String title, String message, double progress, BuildContext context) {
  return Flushbar(
      duration: Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.BOTTOM,
      borderRadius: 10,
      //backgroundColor: Colors.white,
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Theme.of(context).primaryColor, Theme.of(context).errorColor],
      ),
      titleText: Padding(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.checkCircle, color: Colors.white, size: 40),
            SizedBox(width: 10),
            Text(
              title,
              style: textStyleFrom(
                Theme.of(context).primaryTextTheme.headline3,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      messageText: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: textStyleFrom(
                      Theme.of(context).primaryTextTheme.bodyText1,
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: message,
                      ),
                    ]),
              )),
          //Container(
          //  width: double.infinity,
          //  height: 20,
          //  child: Align(
          //    alignment: Alignment.center,
          //    child: ProgressBar(
          //      progress: progress,
          //      widthAsDecimal: 0.9,
          //      doneColor: Color.fromRGBO(255, 176, 58, 1),
          //      toDoColor: colorFrom(
          //        Colors.white,
          //        opacity: 0.3,
          //      ),
          //    ),
          //  ),
          //),
        ],
      ));
}

Function gotBadgeNotifier({
  Badge badge,
  BuildContext context,
}) {
  showDialog( context: context, barrierDismissible: true, builder: (_) => AlertDialog( shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(35),), content: Column( mainAxisSize: MainAxisSize.min, children: <Widget>[ FittedBox( //width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    "Congratulations",
                    style: Theme.of(context).primaryTextTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Text(
                    "You reached a new milestone",
                    style: Theme.of(context).primaryTextTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 120,
                      width: 120,
                      child: Image.asset(badge.getImage()),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    badge.getName(),
                    style: Theme.of(context).primaryTextTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Text(
                    badge.getSuccessMessage(),
                    style: Theme.of(context).primaryTextTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                //Container(
                //  width: MediaQuery.of(context).size.width * 0.65,
                //  child: RichText(
                //    textAlign: TextAlign.center,
                //    text: TextSpan(children: [
                //      TextSpan(
                //          text: "See all your achievements in your ",
                //          style: Theme.of(context).primaryTextTheme.bodyText1),
                //      TextSpan(
                //          text: "profile",
                //          style: textStyleFrom(
                //            Theme.of(context).primaryTextTheme.bodyText1,
                //            color: Theme.of(context).buttonColor,
                //          ),
                //          recognizer: TapGestureRecognizer()
                //            ..onTap = () {
                //              Navigator.pushNamed(context, Routes.profile);
                //            }),
                //      TextSpan(
                //          text: ".",
                //          style: Theme.of(context).primaryTextTheme.bodyText1),
                //    ]),
                //  ),
                //)
              ],
            ),
          ));
}

Function showBage({
  bool locked,
  BuildContext context,
  Badge badge,
}) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 120,
                      width: 120,
                      child: locked
                          ? Icon(Icons.lock,
                              size: 60, color: Theme.of(context).primaryColor)
                          : Image.asset(badge.getImage()),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    locked ? "Locked" : badge.getName(),
                    style: Theme.of(context).primaryTextTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Text(
                    locked
                        ? "You need ${badge.getPoints()} points to unlock this badge"
                        : badge.getSuccessMessage(),
                    style: Theme.of(context).primaryTextTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ));
}
