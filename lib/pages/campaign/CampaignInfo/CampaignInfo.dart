import 'package:app/assets/components/darkButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:share/share.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:app/models/Campaign.dart';
import 'package:app/models/Organisation.dart';
import 'package:app/models/SDG.dart';
import 'package:app/models/ViewModel.dart';
import 'package:app/models/State.dart';


import 'package:app/services/api.dart';
import 'package:app/locator.dart';
import 'package:app/routes.dart';

import 'package:app/assets/icons/customIcons.dart';
import 'package:app/assets/components/joinedIndicator.dart';
import 'package:app/assets/StyleFrom.dart';
import 'package:app/assets/components/customAppBar.dart';
import 'package:app/assets/components/customTile.dart';
import 'package:app/assets/components/organisationTile.dart';
import 'package:app/assets/components/textButton.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

const double H_PADDING = 20;

class CampaignInfo extends StatelessWidget {
  final Campaign campaign;
  final int campaignId;

  CampaignInfo({this.campaign, this.campaignId})
      : assert(campaign != null || campaignId != null);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.create(store),
        builder: (BuildContext context, ViewModel viewModel) {
          return CampaignModelInfo(
              campaign: campaign, campaignId: campaignId, model: viewModel);
        });
  }
}

class CampaignModelInfo extends StatefulWidget {
  final Campaign campaign;
  final int campaignId;
  final ViewModel model;

  CampaignModelInfo({@required this.model, this.campaign, this.campaignId})
      : assert(campaign != null || campaignId != null);

  @override
  _CampaignInfoModelState createState() => _CampaignInfoModelState();
}

class _CampaignInfoModelState extends State<CampaignModelInfo>
    with WidgetsBindingObserver {
  Api api = locator<Api>();
  Future<Campaign> futureCampaign;
  Campaign campaign;

  void didChangeAppLifecycleState(AppLifecycleState state) {
    //setState(() { _notification = state });
    print("The state is");
    print(state);
  }

  @override
  void dispose() {
    print("Campaign info model state disposed");
    super.dispose();
  }

  void initState() {
    // if give campaing use that
    if (widget.campaign != null) {
      print("Campaign does not equal null");
      this.campaign = widget.campaign;
    }
    // check if we already have the campaign id they want
    else {
      Campaign c = widget.model.campaigns.getActiveCampaigns().firstWhere(
          (camp) => camp.getId() == widget.campaignId,
          orElse: () => null);
      // if so use that
      if (c != null) {
        print("We have the campaign");
        this.campaign = c;
      }
      // otherwise have a look online
      else {
        print("Were gonna go have a look online");
        //this.futureCampaign = api.getCampaign(widget.campaignId);
        //// If that doesnt work then show the campaign not found page
        //if (this.futureCampaign == null) {
        //  // TODO implement campaign not found page
        //}
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Building Info Page");
    print(this.campaign);
    return this.campaign != null
        ? CampaignInfoContent(
            campaign: this.campaign,
            model: widget.model,
          )
        : FutureBuilder<Campaign>(
            //future: this.futureCampaign,
            future: api.getCampaign(widget.campaignId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  print("has data!");
                  return CampaignInfoContent(
                      campaign: snapshot.data, model: widget.model);
                } else if (snapshot.hasError) {
                  // TODO implement campaign not found page
                  print("There was an error with get campaign request");
                  return null;
                }
              } else if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.data == null) {
                print("ConnectionState is super none");
              } else if (snapshot.connectionState == ConnectionState.none) {
                print("ConnectionState is none");
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                print("ConnectionState is waiting");
              }
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            });
  }
}

class CampaignInfoContent extends StatefulWidget {
  final Campaign campaign;
  final ViewModel model;
  CampaignInfoContent({
    @required this.campaign,
    @required this.model,
  });

  @override
  _CampaignInfoContentState createState() => _CampaignInfoContentState();
}

class _CampaignInfoContentState extends State<CampaignInfoContent> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Campaign campaign;
  ViewModel model;
  double top;
  double currentExtent;
  bool joined;

  //bool _isPlayerReady = false;
  YoutubePlayerController _controller;

  @override
  initState() {
    campaign = widget.campaign;
    model = widget.model;
    joined = widget.model.userModel.user
        .getSelectedCampaigns()
        .contains(campaign.getId());
    top = 0.0;
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(campaign.getVideoLink()),
      flags: YoutubePlayerFlags(
        autoPlay: false,
        //autoPlay: !model.userModel.user
        //    .getSelectedCampaigns()
        //    .contains(campaign.getId()),
        mute: false,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    print("Campaign info state disposed");
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          extraOnTap: () {},
          text: "Campaign",
          context: context,
          actions: [
            IconButton(
              icon: Icon(
                CustomIcons.ic_learning,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                //_controller.dispose();
                Navigator.of(context).pushNamed(Routes.learningSingle, arguments: campaign.getId());
              },
            )
          ]),
      key: scaffoldKey,
      body: Stack(children: [
        ListView(
          children: [
            // Image header
            Container(
              height: 200,
              // Youtube player
              child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    child: YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                      ),
                      builder: (context, player) {
                        return Column(
                          children: [
                            player,
                          ],
                        );
                      },
                    ),
                    //child: Material(
                    //child: VideoPlayer(),
                    //),
                  )),
            ),

            // Title section
            Container(
              color: Color.fromRGBO(222, 224, 232, 1),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.people,
                          color: Color.fromRGBO(69, 69, 69, 1),
                          size: 16,
                        ),
                        SizedBox(width: 2),
                        Text(
                            campaign.getNumberOfCampaigners().toString() +
                                " people have joined",
                            style: textStyleFrom(
                              Theme.of(context).primaryTextTheme.headline5,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(63, 61, 86, 1),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Joined Indicator
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                (joined)
                    ? Padding(
                        padding: EdgeInsets.all(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: JoinedIndicator(),
                        ))
                    : Container(),
              ],
            ),

            SizedBox(height: 18),
            // Campaign
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: H_PADDING,
              ),
              child: Text(
                "Campaign",
                style: textStyleFrom(
                  Theme.of(context).primaryTextTheme.bodyText1,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            //Title
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: H_PADDING,
              ),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    campaign.getTitle(),
                    style: textStyleFrom(
                      Theme.of(context).primaryTextTheme.headline3,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ),

            campaign.getKeyAims() == [] ? Container() :
            // Key aims
            Padding(
              padding: EdgeInsets.all(H_PADDING),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle("Our aims"),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: campaign.getKeyAims().map((t) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              t,
                              style: textStyleFrom(
                                Theme.of(context).primaryTextTheme.bodyText1,
                              ),
                            ),
                          )
                        ],
                      );
                    }).toList()
                  ),
                ]
              )
            ),
          
            SizedBox(height: 18),

            SectionTitle("What is this about?",
                hPadding: H_PADDING),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: H_PADDING,
              ),
              child: Container(
                child: Text(
                  campaign.getDescription(),
                  style: Theme.of(context).primaryTextTheme.bodyText1,
                ),
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomTile(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                  child: Column(
                    children: <Widget>[
                      Text("See what you can do to support this cause today!", 
                        style: textStyleFrom(Theme.of(context).primaryTextTheme.headline4)
                      ),
                      SizedBox(height: 15,),
                      DarkButton("Take action", onPressed: (){
                        if (campaign.isPast()) {
                          Navigator.of(context).pushNamed(Routes.actions);
                        }
                        else {
                          Navigator.of(context).pushNamed(Routes.actions);
                        }
                      })
                    ],
                  ),
                )
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                "Know someone who would be happy to support this cause?",
                textAlign: TextAlign.center,
                style: textStyleFrom(
                  Theme.of(context).primaryTextTheme.headline4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextButton(
                  "Share this campaign",
                  onClick: () async {
                    String text = await campaign.getShareText();
                    Share.share(text);
                  },
                ),
              ],
            ),

            SizedBox(height: 40),
            
            campaign.getGeneralPartners().length == 0 ? Container() :
            Container(
              color: Color.fromRGBO(247,248,252,1),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle("Campaign partners"),
                    SizedBox(width: 10,),
                    Wrap( 
                      children: getOrganistaionTiles(campaign.getGeneralPartners(), context),
                      spacing: 10,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.start,
                    ),
                  ],
                )
              )
            ),

            SizedBox(height: 10),

            // SDGs
            SizedBox(height: 10),
            campaign.getSDGs().isEmpty
                ? Container()
                : SectionTitle("UN Sustainable Development Goals",
                    hPadding: H_PADDING,),
            //SDGReel(campaign.getSDGs()),
            SDGList(campaign.getSDGs()),

            SizedBox(height: 20),
            joined
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    CustomTextButton(
                      "I no longer want to be part of this campaign",
                      fontSize: 14,
                      onClick: () {
                        print("Unjoining campaign");
                        setState(() {
                          joined = false;
                        });
                        model.onUnjoinCampaign(campaign);
                      },
                    )
                  ])
                : Container(),
            //Padding(
            //  padding: const EdgeInsets.all(8.0),
            //  child: DarkButton(
            //    "Actions of this Campaign",
            //    onPressed: () {
            //      if (campaign.isPast()) {
            //        Navigator.pushNamed(context,Routes.pastCampaignActionPage, arguments: campaign);
            //      }
            //      else {
            //        // TODO make this link to specific action
            //        Navigator.pushNamed(context,Routes.actions);
            //      }
            //    },
            //  ),
            //),
            SizedBox(height: joined ? 20 : 70 ),
          ],
        ),
        AnimatedPositioned(
          bottom: joined ? -75 : 0,
          duration: Duration(milliseconds: 500),
          left: 0,
          child: FlatButton(
            padding: EdgeInsets.all(0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: Center(
                  child: Text(
                "Join now",
                style: textStyleFrom(Theme.of(context).primaryTextTheme.button,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white),
              )),
            ),
            onPressed: () {
              setState(() {
                joined = true;
              });
              //joinCampaign(widget.model, context, campaign);
              model.onJoinCampaign(campaign, context);
            },
            color: Theme.of(context).primaryColor,
          ),
        )
      ]),
    );
  }
}

class OrganisationReel extends StatelessWidget {
  final List<Organisation> organisations;
  final YoutubePlayerController controller;
  OrganisationReel(this.organisations, this.controller);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 140,
        //child: Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: organisations.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.all(8),
              child: OrganisationTile(
                organisations[index],
                extraOnTap: () {
                  controller.pause();
                },
              ),
            );
          },
          // )
        ));
  }
}

class SDGList extends StatelessWidget {
  final List<SDG> sdgs;
  SDGList(this.sdgs);
  @override
  Widget build(BuildContext context) {
    return Container(
        //child: Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: sdgs.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: SDGSelectionItem(sdgs[index]),
            );
          },
          // )
        ));
  }
}

class SDGSelectionItem extends StatelessWidget {
  final SDG sdg;
  SDGSelectionItem(this.sdg);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          launch(sdg.getLink());
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 75,
              width: 75,
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Image.asset(
                  sdg.getImage(),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text:
                          "This campaign is working towards the United Nations Sustainable Development Goal ${sdg.getNumber()}. Find out more at ",
                      style: Theme.of(context).primaryTextTheme.bodyText1),
                  TextSpan(
                      text: "sustainabledevelopment.un.org",
                      style: textStyleFrom(
                        Theme.of(context).primaryTextTheme.bodyText1,
                        color: Theme.of(context).buttonColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch("https://sustainabledevelopment.un.org");
                        }),
                ]),
              ),
            ),
          ],
        ));
  }
}

List<Widget> getOrganistaionTiles(List<Organisation> organisations, BuildContext context) {
  List<Widget> orgTiles = [];
  for(final org in organisations) {
    orgTiles.add(
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(Routes.organisationPage, arguments: org);
        },
        child: CustomTile(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Container(
              height: 30,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(org.getLogoLink()),
                  SizedBox(width: 5,),
                  Text(
                    org.getName(),
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
  return orgTiles;
}

class SectionTitle extends StatelessWidget {
  final String text;
  final double hPadding;

  SectionTitle(
    this.text, 
    {
      this.hPadding,
    }
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding ?? 0, vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).primaryTextTheme.headline4,
      ),
    );
  }
}
