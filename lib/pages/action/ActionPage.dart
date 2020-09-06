import 'package:app/assets/components/darkButton.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:app/routes.dart';

import 'package:app/models/Campaign.dart';
import 'package:app/models/Action.dart';

import 'package:app/assets/StyleFrom.dart';
import 'package:app/assets/components/selectionItem.dart';
import 'package:app/assets/components/campaignTile.dart';
import 'package:app/assets/components/selectionPill.dart';
import 'package:app/assets/components/header.dart';
import 'package:app/assets/components/viewCampaigns.dart';
import 'package:app/assets/components/smoothPageIndicatorEffect.dart';

import 'package:stacked/stacked.dart';
import 'package:app/viewmodels/action_model.dart';

const double CAMPAIGN_SELECT_HEIGHT = 110;
final _controller = PageController(
  initialPage: 0,
  viewportFraction: 0.93,
);
const PageStorageKey campaignPageKey = PageStorageKey("campaingKey");

const curve = Curves.ease;
const duration = Duration(milliseconds: 500);

class ActionPage extends StatefulWidget {
  @override
  _ActionPageState createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  Campaign campaign;
  List<CampaignAction> actions = [];
  Map<String, Map> selections = {
    "times": {},
    "campaigns": {},
    "categories": {},
    "extras": {
      "todo": true,
      "completed": false,
      "rejected": false,
      "starred": true,
    }
  };

  initState() {
    for (int i = 0; i < timeBrackets.length; i++) {
      selections['times'][timeBrackets[i]['text']] = false;
    }
    for (int i = 0; i < CampaignActionSuperType.values.length; i++) {
      selections['categories'][CampaignActionSuperType.values[i]] = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActionViewModel>.reactive(
      viewModelBuilder: () => ActionViewModel(),
      onModelReady: (model) {
          setState(() {
            if (model.selectedCampaigns.length == 0) {
              campaign = null;
              actions = [];
            }
            else {
              campaign = model.selectedCampaigns[0];
              actions = model.getActions(campaign, selections);
            }
          });
        },
      builder: (context, model, child) {
        //onInit: (Store<AppState> store) {
        //  var campaigns = store.state.userState.user.filterSelectedCampaigns(
        //      store.state.campaigns.getActiveCampaigns());
        //  if (campaigns.length != 0) {
        //    campaign = campaigns[0];

        //    // TODO make this not add all the actions -> only those that are not selected
        //    // actions.addAll(campaign.getActions());
        //  } else {
        //    campaign = null;
        //    actions = [];
        //  }
        //},
          return Scaffold(
              backgroundColor: colorFrom(
                Theme.of(context).primaryColorDark,
                opacity: 0.05,
              ),
              body: 

              model.selectedCampaigns.length == 0 ?

              Column(
                children: [
                  PageHeader(
                    title: "Actions",
                    onTap: () {
                      _navigateAndDisplaySelection(context, model);
                    },
                    icon: Icons.filter_list,
                  ),

                  SizedBox(height: 15),

                  Expanded(
                    child: Image.asset('assets/imgs/graphics/ilstr_empty@3x.png'),
                  ),

                  Text(
                    "No actions yet",
                    style: textStyleFrom(
                      Theme.of(context).primaryTextTheme.headline2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    child: Text(
                      "Join a campaign to see the actions you take to support it!",
                      style: textStyleFrom(
                        Theme.of(context).primaryTextTheme.bodyText1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: DarkButton(
                      "See campaigns",
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.campaign);
                      },
                    )
                  )

                ],
              )

              :

              Column(
                children: <Widget>[
                  PageHeader(
                    title: "Actions",
                    onTap: () {
                      _navigateAndDisplaySelection(context, model);
                    },
                    icon: Icons.filter_list,
                  ),

                  Expanded(
                    child: ListView(
                    children: [
                      // Campaign selection widget
                      Container(
                          height: CAMPAIGN_SELECT_HEIGHT,
                          child: PageView.builder(
                              key: campaignPageKey,
                              controller: _controller,
                              itemCount:
                                  // If all the active campaigns have been joined
                                  model.selectedCampaigns.length == model.campaigns.length 
                                    ? model.selectedCampaigns.length
                                    : model.currentUser
                                              .getSelectedCampaigns().length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                if (index ==
                                    model.currentUser
                                        .getSelectedCampaigns()
                                        .length) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed(Routes.campaign);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: AddCampaignTile(),
                                    )
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.only(bottom:10),
                                  child: CampaignSelectionTile(model
                                    .currentUser
                                    .filterSelectedCampaigns(model.campaigns
                                        )[index],
                                    height: CAMPAIGN_SELECT_HEIGHT,
                                  ),
                                );
                              },
                              onPageChanged: (int pageIndex) {
                                setState(() {
                                  if (pageIndex ==
                                      model.currentUser
                                          .getSelectedCampaigns()
                                          .length) {
                                    campaign = null;
                                    actions = [];
                                  } else {
                                    campaign = model.currentUser
                                        .filterSelectedCampaigns(model.campaigns
                                            )[pageIndex];
                                    actions =
                                        model.getActions(campaign, selections);
                                  }
                                });
                              })),
                      Align(
                        alignment: Alignment.center,
                        child: SmoothPageIndicator(
                          controller: _controller,
                          //count: viewModel.campaigns.getActiveCampaigns().length,
                          count: model.selectedCampaigns.length ==
                                    model.campaigns.length
                              ? model.selectedCampaigns.length
                              : model.currentUser
                                      .getSelectedCampaigns()
                                      .length + 1,
                          effect: customSmoothPageInducatorEffect,
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),

                      // Action list
                      Container(
                          child: campaign == null
                              ? ViewCampaigns()
                              : ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    Row(
                                      children: [
                                        ActiveDoneSelector(
                                          "All",
                                          () {
                                            setState(() {
                                              selections['extras']['starred'] =
                                                  true;
                                              selections['extras']['todo'] = true;
                                              selections['extras']['rejected'] =
                                                  false;
                                              selections['extras']['completed'] =
                                                  false;

                                              actions = model.getActions(
                                                  campaign, selections);
                                            });
                                          },
                                          selections['extras']['todo'] &&
                                              selections['extras']['starred'] &&
                                              !selections['extras']['rejected'] &&
                                              !selections['extras']['completed'],
                                        ),
                                        ActiveDoneSelector(
                                          "To do",
                                          () {
                                            setState(() {
                                              selections['extras']['starred'] =
                                                  true;
                                              selections['extras']['todo'] = false;
                                              selections['extras']['rejected'] =
                                                  false;
                                              selections['extras']['completed'] =
                                                  false;

                                              actions = model.getActions(
                                                  campaign, selections);
                                            });
                                          },
                                          !selections['extras']['todo'] &&
                                              selections['extras']['starred'] &&
                                              !selections['extras']['rejected'] &&
                                              !selections['extras']['completed'],
                                        ),
                                        ActiveDoneSelector(
                                          "Completed",
                                          () {
                                            setState(() {
                                              selections['extras']['starred'] =
                                                  false;
                                              selections['extras']['todo'] = false;
                                              selections['extras']['rejected'] =
                                                  false;
                                              selections['extras']['completed'] =
                                                  true;

                                              actions = model.getActions(
                                                  campaign, selections);
                                            });
                                          },
                                          !selections['extras']['todo'] &&
                                              !selections['extras']['starred'] &&
                                              !selections['extras']['rejected'] &&
                                              selections['extras']['completed'],
                                        ),
                                      ],
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: actions.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 0),
                                              child: ActionSelectionItem(
                                                outerHpadding: 10,
                                                campaign: campaign,
                                                action: actions[index],
                                                backgroundColor: Colors.white,
                                              ));
                                        }),
                                  ],
                                ))
                      ],
                    )
                  ),
                ],
              ));
        });
  }

  _navigateAndDisplaySelection(BuildContext context, ActionViewModel model) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => SortScreen(selections)),
    );
    setState(() {
      selections = result ?? this.selections;
      print("Getting new acitons");
      actions = model.getActions(campaign, selections);
      print("got new acitons");
    });
  }
}

class AddCampaignTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: CAMPAIGN_SELECT_HEIGHT,
                    color: Colors.grey,
                  ),
                  Container(
                      height: CAMPAIGN_SELECT_HEIGHT,
                      color: colorFrom(
                        Colors.black,
                        opacity: 0.4,
                      )),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Icon(
                    Icons.add,
                  ),
                ),
              )
            ])));
  }
}

class SortScreen extends StatefulWidget {
  final Map<String, Map> selections;
  SortScreen(this.selections);
  @override
  _SortScreenState createState() => _SortScreenState();
}

class _SortScreenState extends State<SortScreen> {
  Map<String, Map> selections;
  initState() {
    selections = widget.selections;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        SafeArea(
          child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                  Text(
                    "Filter actions",
                    style: Theme.of(context).primaryTextTheme.headline4,
                  ),
                  SizedBox(width: 30)
                ],
              ),

              SizedBox(height: 20),

              // Times
              SelectionTitle("Time"),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: timeBrackets.length,
                separatorBuilder: (BuildContext context, int index) =>
                    ListDividor(),
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Theme.of(context).primaryColor,
                      title: Text(timeBrackets[index]['text']),
                      value: selections['times'][timeBrackets[index]['text']],
                      onChanged: (bool value) {
                        setState(() {
                          selections['times'][timeBrackets[index]['text']] =
                              value;
                        });
                      });
                  //return Text(timeBrackets[index]['text']);
                },
              ),

              // Categories
              SelectionTitle("Categories"),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: CampaignActionSuperType.values.length,
                separatorBuilder: (BuildContext context, int index) =>
                    ListDividor(),
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxSelectionItem(
                      title: campaignActionSuperTypeData[
                          CampaignActionSuperType.values[index]]['name'],
                      value: selections['categories']
                          [CampaignActionSuperType.values[index]],
                      onChanged: (bool value) {
                        setState(() {
                          selections['categories']
                              [CampaignActionSuperType.values[index]] = value;
                        });
                      });
                  //return Text(timeBrackets[index]['text']);
                },
              ),

              // Extras
              SelectionTitle("Extras"),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  CheckboxSelectionItem(
                      title: "Include completed",
                      value: selections['extras']['completed'],
                      onChanged: (bool value) {
                        setState(() {
                          selections['extras']['completed'] = value;
                        });
                      }),
                  CheckboxSelectionItem(
                      title: "Include rejected",
                      value: selections['extras']['rejected'],
                      onChanged: (bool value) {
                        setState(() {
                          selections['extras']['rejected'] = value;
                        });
                      }),
                ],
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: FlatButton(
            padding: EdgeInsets.all(0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              child: Center(
                  child: Text(
                "Apply",
                style: textStyleFrom(Theme.of(context).primaryTextTheme.button,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: Colors.white),
              )),
            ),
            onPressed: () {
              Navigator.pop(context, selections);
            },
            color: Theme.of(context).primaryColor,
          ),
        )
      ]),
    );
  }
}

class SelectionTitle extends StatelessWidget {
  final String text;
  SelectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            text,
            style: textStyleFrom(
              Theme.of(context).primaryTextTheme.headline3,
              fontWeight: FontWeight.w600,
            ),
          )),
    );
  }
}

class ListDividor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      color: Color.fromRGBO(221, 221, 221, 1),
    );
  }
}

class ActiveDoneSelector extends StatefulWidget {
  String text;
  Function onClick;
  bool selected;
  ActiveDoneSelector(this.text, this.onClick, this.selected);
  @override
  _ActiveDoneSelectorState createState() => _ActiveDoneSelectorState();
}

class _ActiveDoneSelectorState extends State<ActiveDoneSelector> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onClick,
        child: Padding(
          padding: EdgeInsets.only(left: 12, bottom: 10),
          child: SelectionPill(
            widget.text, 
            widget.selected
          ),
        )
    );
  }
}
