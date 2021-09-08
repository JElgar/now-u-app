import 'package:app/assets/components/causeOnboardingClipper.dart';
import 'package:app/viewmodels/causes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:app/assets/components/causeTile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app/assets/components/buttons/customWidthButton.dart';
import 'package:stacked/stacked.dart';

class CausePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ViewModelBuilder<CausesViewModel>.reactive(
            viewModelBuilder: () => CausesViewModel(),
            onModelReady: (model) => model.fetchCauses(),
            builder: (context, model, child) {
              return Stack(
                children: [
                  ClipPath(
                      clipper: CauseBackgroundClipper(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0XFF011A43), Color(0XFF012B93)],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            )),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: Text(
                                        'Welcome to now-u',
                                        style: TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Expanded(flex: 3, child: SizedBox())
                                  ],
                                ),
                                Text(
                                  'Take action and selected the causes which are important to you',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CauseTile(
                                      gestureFunction: () =>
                                          model.toggleSelection(causeIndex: 0),
                                      cause: model.causesList[0],
                                      causeIcon: FontAwesomeIcons.leaf,
                                      isSelected: model.causesSelectedList[0],
                                  getInfoFunction: () => model.getCausePopup(causeIndex: 0),),
                                  CauseTile(
                                      gestureFunction: () =>
                                          model.toggleSelection(causeIndex: 1),
                                      cause: model.causesList[1],
                                      causeIcon: FontAwesomeIcons.heart,
                                      isSelected: model.causesSelectedList[1],
                                    getInfoFunction: () => model.getCausePopup(causeIndex: 1),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CauseTile(
                                      gestureFunction: () =>
                                          model.toggleSelection(causeIndex: 2),
                                      cause: model.causesList[2],
                                      causeIcon: FontAwesomeIcons.balanceScale,
                                      isSelected: model.causesSelectedList[2],
                                    getInfoFunction: () => model.getCausePopup(causeIndex: 2),),
                                  CauseTile(
                                      gestureFunction: () =>
                                          model.toggleSelection(causeIndex: 3),
                                      cause: model.causesList[3],
                                      causeIcon: FontAwesomeIcons.graduationCap,
                                      isSelected: model.causesSelectedList[3],
                                    getInfoFunction: () => model.getCausePopup(causeIndex: 3),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CauseTile(
                                      gestureFunction: () =>
                                          model.toggleSelection(causeIndex: 4),
                                      cause: model.causesList[4],
                                      causeIcon: FontAwesomeIcons.handHoldingUsd,
                                      isSelected: model.causesSelectedList[4],
                                    getInfoFunction: () => model.getCausePopup(causeIndex: 4),),
                                  CauseTile(
                                      gestureFunction: () =>
                                          model.toggleSelection(causeIndex: 5),
                                      cause: model.causesList[5],
                                      causeIcon: FontAwesomeIcons.home,
                                      isSelected: model.causesSelectedList[5],
                                    getInfoFunction: () => model.getCausePopup(causeIndex: 5),),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomWidthButton('Get started',
                                  onPressed: model.isButtonDisabled
                                      ? () {
                                          return null;
                                        }
                                      : () {
                                          model.getCausePopup();
                                        },
                                  backgroundColor: model.isButtonDisabled
                                      ? Colors.grey
                                      : Theme.of(context).primaryColor,
                                  size: ButtonSize.Medium,
                                  fontSize: 20.0,
                                  buttonWidthProportion: 0.6),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }));
  }
}
