import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:app/models/Action.dart';
import 'package:app/models/Campaign.dart';
import 'package:app/routes.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:app/assets/StyleFrom.dart';
import 'package:app/assets/components/selectionItem.dart';
import 'package:app/assets/components/darkButton.dart';
import 'package:app/assets/components/textButton.dart';
import 'package:app/assets/components/customAppBar.dart';
import 'package:app/assets/icons/customIcons.dart';

import 'package:stacked/stacked.dart';
import 'package:app/viewmodels/action_info_model.dart';

final double theHeaderHeight = 200;
final double hPadding = 10;

class ActionInfoArguments {
  final ListCauseAction action;

  ActionInfoArguments({
    required this.action,
  });
}

class ActionInfo extends StatefulWidget {
  final ActionInfoArguments args;
  ActionInfo(this.args);
  @override
  _ActionInfoState createState() => _ActionInfoState();
}

class _ActionInfoState extends State<ActionInfo> with WidgetsBindingObserver {
  final double expandedHeight = 400.0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActionInfoViewModel>.reactive(
        viewModelBuilder: () => ActionInfoViewModel(),
        onModelReady: (model) => model.fetchAction(widget.args.action),
        builder: (context, model, child) {
          return Scaffold(
              appBar: customAppBar(
                text: model.isLoading
                    ? "Loading..."
                    : model.action!.superType.name,
                backButtonText: "Actions",
                context: context,
              ),
              key: scaffoldKey,
              body: model.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Stack(children: [
                      ListView(
                        children: [
                          Container(
                            width: double.infinity,
                            color: model.action!.secondaryColor,
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                child: Text(model.action!.title)),
                          ),
                          Container(
                            height: model.action!.isCompleted ? null : 10,
                            color: model.action!.primaryColor,
                            child: model.action!.isCompleted
                                ? Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CustomIcons.ic_check,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 7),
                                      Text(
                                        "Done",
                                        style: textStyleFrom(
                                          Theme.of(context)
                                              .primaryTextTheme
                                              .bodyText1,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        model.action!.icon,
                                        color: model.action!.primaryColor,
                                      ),
                                      SizedBox(width: 6),
                                      Icon(FontAwesomeIcons.clock, size: 12),
                                      SizedBox(width: 3),
                                      Text(model.action!.timeText),
                                    ],
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        // TODO This must go to the causes info page
                                        Navigator.of(context).pushNamed(
                                            Routes.home,
                                            arguments: model.action!.cause!.id);
                                      },
                                      child: Container(
                                        height: 20,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            "See the campaign",
                                            style: textStyleFrom(
                                              Theme.of(context)
                                                  .primaryTextTheme
                                                  .headline4,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              )),

                          SizedBox(height: 15),

                          // Text
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: hPadding, vertical: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("What should I do?",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline4),
                                SizedBox(height: 10),
                                Text(model.action!.whatDescription ?? "",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText1),
                              ],
                            ),
                          ),

                          // Buttons
                          SizedBox(height: 20),

                          // First
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                "First",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline2,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: DarkButton(
                              "Take action",
                              size: DarkButtonSize.Large,
                              style: DarkButtonStyle.Secondary,
                              onPressed: () {
                                model.launchAction();
                              },
                            ),
                          ),

                          !model.action!.isCompleted
                              ?
                              // If not completed show the then button
                              Column(
                                  children: [
                                    //Dividor
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 20),
                                        child: Container(
                                          width: double.infinity,
                                          color:
                                              Color.fromRGBO(222, 223, 232, 1),
                                          height: 1,
                                        )),

                                    // Then
                                    Center(
                                        child: Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Text(
                                        "Then",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline2,
                                      ),
                                    )),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: DarkButton("Mark as done",
                                          size: DarkButtonSize.Large,
                                          style: DarkButtonStyle.Secondary,
                                          onPressed: () {
                                        setState(() {
                                          model.completeAction();
                                        });
                                      }),
                                    ),
                                  ],
                                )
                              : // Otherwise show the youre great thing
                              Padding(
                                  padding: EdgeInsets.only(top: 20, bottom: 10),
                                  child: Container(
                                      color: model.action!.secondaryColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Many small actions have a big impact",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .headline2,
                                            ),
                                            SizedBox(height: 10),
                                            RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .bodyText1,
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "You have completed this action and contributed to the goals of the ",
                                                  ),
                                                  // TODO What is happening to this?
                                                  // TextSpan(
                                                  //     text: _campaign!.title,
                                                  //     style: textStyleFrom(
                                                  //       Theme.of(context)
                                                  //           .primaryTextTheme
                                                  //           .bodyText1,
                                                  //       color: Theme.of(context)
                                                  //           .buttonColor,
                                                  //     ),
                                                  //     recognizer:
                                                  //         TapGestureRecognizer()
                                                  //           ..onTap = () {
                                                  //             Navigator.of(context)
                                                  //                 .pushNamed(
                                                  //                     Routes
                                                  //                         .campaignInfo,
                                                  //                     arguments:
                                                  //                         _campaign!
                                                  //                             .id);
                                                  //           }),
                                                  // TextSpan(
                                                  //   text: " campaign.",
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            Icon(FontAwesomeIcons.calendar,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 60),
                                            SizedBox(height: 20),
                                          ],
                                        ),
                                      ))),

                          SizedBox(height: 30),

                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: hPadding, vertical: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Why is this useful?",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline4),
                                SizedBox(height: 10),
                                Text(model.action!.whyDescription ?? "",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText1),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                model.action!.isCompleted
                                    ? CustomTextButton("Mark as not done",
                                        fontSize: 14, onClick: () {
                                        model.removeActionStatus();
                                      })
                                    : Container(),
                                //TextButton("Hide this action", fontSize: 14,
                                //    onClick: () {
                                //  showDialog(
                                //    context: context,
                                //    barrierDismissible: true,
                                //    builder: (_) =>
                                //        RejectDialogue(_action, viewModel),
                                //  );
                                //}),

                                SizedBox(width: 10),
                              ]),
                          SizedBox(height: 15),
                          !model.action!.isCompleted
                              ? Container()
                              : Container(
                                  height: 65,
                                  color: Color.fromRGBO(155, 159, 177, 1),
                                  child: Center(
                                    child: Text(
                                      "You completed this action",
                                      style: textStyleFrom(
                                        Theme.of(context)
                                            .primaryTextTheme
                                            .bodyText1,
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: model.action!.isCompleted ? 0 : 70,
                          ),
                        ],
                      ),
                      AnimatedPositioned(
                        bottom: model.action!.isCompleted ? -100 : 0,
                        left: 0,
                        duration: Duration(milliseconds: 300),
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: model.action!.isCompleted ? 45 : 60,
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  model.action!.isStarred
                                      ? CustomIcons.ic_todo_remove
                                      : CustomIcons.ic_todo_add,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                SizedBox(width: 12),
                                model.action!.isCompleted
                                    ? Text(
                                        "You completed this action",
                                        style: textStyleFrom(
                                            Theme.of(context)
                                                .primaryTextTheme
                                                .button,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                            color: Colors.white),
                                      )
                                    : Text(
                                        model.action!.isStarred
                                            ? "Remove from To-Dos"
                                            : "Add to my to-do list",
                                        style: textStyleFrom(
                                            Theme.of(context)
                                                .primaryTextTheme
                                                .button,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                            color: Colors.white),
                                      ),
                              ],
                            )),
                          ),
                          onPressed: () {
                            model.action!.isStarred
                                ? model.removeActionStatus()
                                : model.starAction();
                          },
                          color: model.action!.isCompleted
                              ? Color.fromRGBO(155, 159, 177, 1)
                              : Theme.of(context).primaryColor,
                        ),
                      )
                    ]));
        });
  }
}

class RejectDialogue extends StatefulWidget {
  final CampaignAction action;
  RejectDialogue(this.action);
  @override
  _RejectDialougeState createState() => _RejectDialougeState();
}

class _RejectDialougeState extends State<RejectDialogue> {
  String selectedReason = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    padding: EdgeInsets.all(10),
                    icon: Icon(
                      Icons.close,
                      color: Color.fromRGBO(136, 136, 136, 1),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              Container(
                  child: Text("Let us know why this action is not for you")),
              Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: rejectionReasons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxSelectionItem(
                          title: rejectionReasons[index],
                          onChanged: (_) {
                            setState(() {
                              selectedReason = rejectionReasons[index];
                            });
                          },
                          value: selectedReason == rejectionReasons[index]);
                    }),
              ),
              SizedBox(height: 20),
              //Align(
              //  alignment: Alignment.center,
              //  child: DarkButton(
              //    "Hide action",
              //    onPressed: selectedReason == ""
              //        ? null
              //        : () {
              //            widget.model
              //                .onRejectAction(widget.action, selectedReason);
              //            Navigator.of(context).pushNamed(Routes.actions);
              //          },
              //  ),
              //),
              //SizedBox(height: 20),
            ],
          ),
        ));
  }
}
