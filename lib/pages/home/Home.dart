import 'package:app/assets/StyleFrom.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:app/routes.dart';

import 'package:app/pages/news/NewsPage.dart';
import 'package:app/pages/Tabs.dart';
import 'package:app/pages/campaign/CampaignTile.dart';
import 'package:app/pages/other/InfoPage.dart';
import 'package:intl/intl.dart';
import 'package:app/assets/ClipShadowPath.dart';

import 'package:app/assets/components/selectionItem.dart';
import 'package:app/assets/components/customTile.dart';
import 'package:app/assets/components/darkButton.dart';
import 'package:app/assets/components/customScrollableSheet.dart';
import 'package:app/assets/components/progress.dart';
import 'package:app/assets/components/viewCampaigns.dart';
import 'package:app/assets/components/smoothPageIndicatorEffect.dart';
import 'package:app/assets/routes/customLaunch.dart';

import 'package:app/models/ViewModel.dart';
import 'package:app/models/State.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const double BUTTON_PADDING = 10;

class Home extends StatelessWidget {
  final Function changePage;
  Home(this.changePage);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFrom(
        Theme.of(context).primaryColor,
        opacity: 0.05,
      ),
      body: ScrollableSheetPage(
        header: 
              Container(
                height: MediaQuery.of(context).size.height * (1 - 0.4),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).errorColor,
                      Theme.of(context).errorColor,
                    ]
                  )
                ),
                child: StoreConnector<AppState, ViewModel>(
                  converter: (Store<AppState> store) => ViewModel.create(store),
                  builder: (BuildContext context, ViewModel viewModel) {
                   if (viewModel.loading)  {
                     return CircularProgressIndicator();
                   }
                  return Stack(
                    children: <Widget> [
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                   Text(
                                      "Hello\n${viewModel.userModel.user.getName()}",
                                      style: textStyleFrom(
                                        Theme.of(context).primaryTextTheme.headline2,
                                        color: Colors.white,
                                        height: 0.95,
                                      ),
                                    ),
                                    SizedBox(height: 17),
                                    Text(
                                      "Ready to start making a difference?",
                                      style: textStyleFrom(
                                        Theme.of(context).primaryTextTheme.headline3,
                                        fontSize: 20,
                                        color: Colors.white,
                                        height: 0.95,
                                      )
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                                  ],
                                ),
                        ),
                      ),
                      Positioned(
                        right: -20,
                        //top: actionsHomeTilePadding,
                        bottom: MediaQuery.of(context).size.height * 0.2,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Image(
                            image: AssetImage('assets/imgs/graphics/ilstr_home_1@3x.png'),
                          )
                        )
                      ),
                    ],
                  );
                }
                ),
              ),
              children: <Widget>[
              
               HomeTitle(
                 "${DateFormat("MMMM").format(DateTime.now())}'s campaigns",
                 infoTitle: "Campaigns",
                 infoText: "We run 3 campaigns each month, with one additional campaign for our first month of July. We only select a few causes per month to focus the efforts of as many people as possible on each campaign.\n We aim to tackle a wide range of social and environmental issues and we would love to hear your suggestions for campaigns we could run!\n We select issues based on several factors, including their severity, the ability of our users to tackle them, and the timing of specific events with momentum that could lead to real change. The theme for our July campaigns is: issues exacerbated by the pandemic.\n Once a campaign is over, that of course does not mean the issue has been solved! Whilst we will move onto a new set of issues each month, we will continue to provide users with details of how to stay engaged with other causes, and return to core issues in future campaigns.",
               ),

               CampaignCarosel(),

               Container(
                width: double.infinity,
                 color: Color.fromRGBO(255,243,230,1),
                 child: Padding(
                   padding: EdgeInsets.symmetric(vertical: 35, horizontal: 15),
                   child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                     children: [
                       HomeTitle(
                         "Take action now!",
                         subtitle: "Find out what you can start doing to support your campaigns:",
                         textAlign: TextAlign.center,
                       ),
                       Padding(
                         padding: EdgeInsets.all(15),
                         child: DarkButton(
                           "Go to actions",
                           onPressed: () {
                             Navigator.of(context).pushNamed(Routes.actions);
                           },
                         )
                       )
                     ],
                   )
                 )
               ),
              
               SizedBox(height: 10),

               Container(
                 child: Padding(
                   padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
                   child: Column(
                     children: [
                       Text(
                         "What cause do you want to support next?",
                         textAlign: TextAlign.center,
                         style: textStyleFrom(
                            Theme.of(context).primaryTextTheme.headline4,
                            fontSize: 24,
                          )
                       ),

                       Padding(
                         padding: EdgeInsets.all(15),
                         child: DarkButton(
                           "Suggest a campaign",
                           onPressed: () {
                             customLaunch(
                              context,
                              "https://docs.google.com/forms/d/e/1FAIpQLSfPKOVlzOOV2Bsb1zcdECCuZfjHAlrX6ZZMuK1Kv8eqF85hIA/viewform",
                              description: "To suggest causes for future campaigns, fill in this Google Form",
                              buttonText: "Go"
                             );

                           },
                           inverted: true,
                         ),
                       )
                     ],
                   )
                 ),
               ),

               // Impact Section
               StoreConnector<AppState, ViewModel>(
                 converter: (Store<AppState> store) => ViewModel.create(store),
                 builder: (BuildContext context, ViewModel viewModel) {
                   return Container(
                     child: Padding(
                       padding: EdgeInsets.all(10),
                       child: Column(
                         children: [
                           Stack(
                             children: [
                               //Image.asset(),
                               //BadgeIndicator(),
                               HomeTitle(
                                 "My impact",
                                 infoTitle: "My Impact",
                                 infoText: "The impact of our campaigns is crucial. Our aim is to create campaigns that do as much good as possible, so we’re working hard to design ways to measure the impact that now-u users have through our campaigns.\n We will keep you updated on your personal progress in the app, and share regular now-u community progress updates on our blog, news feed and social media.\n At the end of each campaign you joined, we will give you a quick survey about your experience of the campaign. We will use this data, as well as a wide range of other metrics, to create impact reports to share with you and our charity partners.\n We will try to learn as much as possible from these impact assessments so that we can keep improving our campaigns and helping you to do good!",
                               ),
                             ]
                           ),
                           viewModel.userModel.user.getSelectedCampaigns() == null ? CircularProgressIndicator() : 
                           ImpactTile(
                             viewModel.userModel.user.getSelectedCampaigns().length,
                             "Campaigns joined",
                             route: Routes.campaign,
                           ),
                           SizedBox(height: 10),
                           ImpactTile(
                             viewModel.getActiveCompletedActions().length,
                             "Actions taken",
                             route: Routes.actions,
                           ),
                           SizedBox(height: 10),
                           ImpactTile(
                             viewModel.getActiveStarredActions().length,
                             "Actions in to-do list",
                             route: Routes.actions,
                           )
                         ],
                       ),
                     ),
                   );
                 }
               )
            ]

      )
    );
  }
}
 
Widget sectionTitle(String t, BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(10),
    child:
      Text(t, style: 
        Theme.of(context).primaryTextTheme.headline3,
        textAlign: TextAlign.start,
      ),
  );
}

class HomeActionTile extends StatelessWidget {
  final Function changePage;
  HomeActionTile(this.changePage);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.create(store),
        builder: (BuildContext context, ViewModel viewModel) {
          if (viewModel.userModel.user.getSelectedCampaigns() == null || viewModel.getActiveSelectedCampaings().getActions() == null) {
            return CircularProgressIndicator();
          }
          else if (viewModel.getActiveSelectedCampaings().getActions().length == 0) {
            return Container(
              height: 200,
              child: ViewCampaigns(),
            );
          }
          else {
            return Column(
              children: <Widget>[
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: 
                    (BuildContext context, int index) => 
                      ActionSelectionItem(
                        action: viewModel.campaigns.getActiveCampaigns()[index].getActions()[index],
                        campaign: viewModel.campaigns.getActiveCampaigns()[index],
                        outerHpadding: 10,
                        backgroundColor: Colors.white,
                    ),
                ),
                HomeButton(
                  text: "All actions",
                  changePage: changePage,
                  page: TabPage.Actions,
                )
                //ActionItem(user.getFollowUpAction()),
                //TODO Work ou where follow up actions should be
              ]
            );
          }
        }
      )
            
    );
  }
}


class HomeButton extends StatelessWidget {
  final String text;
  final Function changePage;
  final TabPage page;

  HomeButton({
    @required this.text,
    @required this.changePage,
    this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(BUTTON_PADDING),
        child: 
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget> [
            DarkButton(
              text, 
              rightArrow: true,
              onPressed: () {
                changePage(
                  page ?? TabPage.Home
                );
              },
              style: DarkButtonStyles.Small,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeDividor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, 
      height: 2,
      color: Color.fromRGBO(238,238,238, 1),
    );
  }
}

class CampaignCarosel extends StatelessWidget {
  final _controller = PageController(
    initialPage: 0,
    viewportFraction: 0.93,
  );
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      converter: (Store<AppState> store) => ViewModel.create(store),
      builder: (BuildContext context, ViewModel viewModel) {
        if (viewModel.campaigns.getActiveCampaigns() == null) {
          return CircularProgressIndicator();
        } else {
          return Column(
            children: [
              Container(
                height: 280,
                child: PageView.builder(
                    controller: _controller,
                    itemCount: viewModel.campaigns.getActiveCampaigns().length,
                        // If all the active campaigns have been joined
                    //itemCount: viewModel.campaigns.getActiveCampaigns().length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: CampaignTile(
                          viewModel.campaigns.getActiveCampaigns()[index],
                            // Used to only selected campaigns ==> remeber to change count
                        //viewModel
                        //  .userModel.user
                        //  .filterSelectedCampaigns(viewModel.campaigns
                        //      .getActiveCampaigns())[index],
                          hOuterPadding: 4,
                        ),
                      );
                    },
                  ),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: viewModel.campaigns.getActiveCampaigns().length,
                  effect: customSmoothPageInducatorEffect,
                ),
                SizedBox(height: 30),
            ]
          );
        }
      }
    );
  }
}

class HomeTitle extends StatelessWidget {

  final String title;
  final String subtitle;
  final String infoTitle;
  final String infoText;
  final TextAlign textAlign;


  HomeTitle(
    this.title,
    {
      this.subtitle,
      this.infoText,
      this.infoTitle,
      this.textAlign,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: textAlign == TextAlign.center ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).primaryTextTheme.headline3,
                  textAlign: textAlign ?? TextAlign.start,
                ),
                SizedBox(width: 7,),

                infoText == null ? Container() :
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      Routes.info,
                      arguments: InfoPageArgumnets(
                        title: infoTitle, 
                        body: infoText,
                      ),
                    );
                  },
                  child: Icon(
                    FontAwesomeIcons.questionCircle,
                    color: Theme.of(context).primaryColor,
                  ),
                ) 
              ]
            )
          ),

          subtitle == null ? Container() :
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Text(
              subtitle,
              style: Theme.of(context).primaryTextTheme.bodyText1,
              textAlign: textAlign ?? TextAlign.start,
            ),
          ),
          
        ],
      ), 
    );
  }
}

class ImpactTile extends StatelessWidget {
  final int number;
  final String text;
  final String route;
  ImpactTile(this.number, this.text, {this.route});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() {if (route != null) {Navigator.of(context).pushNamed(route);}},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ), 
        child: Row(
          children: [
            SizedBox(width: 20),
            Text(
              number.toString(),
              style: Theme.of(context).primaryTextTheme.headline1,
            ),
            SizedBox(width: 20),
            Text(
              text,
              style: Theme.of(context).primaryTextTheme.headline4,
            ),

          ],
        ),
      ),
    );
  }
}
