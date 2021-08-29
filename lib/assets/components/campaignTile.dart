import 'package:flutter/material.dart';

import 'package:app/models/Campaign.dart';

import 'package:app/assets/components/joinedIndicator.dart';
import 'package:app/assets/components/customTile.dart';
import 'package:app/assets/components/textButton.dart';
import 'package:app/assets/components/buttons/darkButton.dart';
import 'package:app/assets/components/custom_network_image.dart';
import 'package:app/assets/StyleFrom.dart';
import 'package:app/routes.dart';

import 'package:stacked/stacked.dart';
import 'package:app/viewmodels/base_model.dart';

class Tile extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double hPadding;
  final Function onTap;
  Tile({this.child, this.borderRadius, this.hPadding, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            left: hPadding ?? 15, right: hPadding ?? 15, top: 16, bottom: 8),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.all(Radius.circular(borderRadius ?? 20)),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.16),
                    offset: Offset(0, 8),
                    blurRadius: 6)
              ]),
          child: GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(borderRadius ?? 20)),
              child: child,
            ),
          ),
        ));
  }
}

class CampaignTile extends StatefulWidget {
  final Campaign campaign;
  final double hPadding;
  final double hOuterPadding;

  CampaignTile(
    this.campaign, {
    this.hPadding,
    this.hOuterPadding,
  });

  @override
  _CampaignTileState createState() => _CampaignTileState();
}

class _CampaignTileState extends State<CampaignTile> {
  @override
  Widget build(BuildContext context) {
    GestureTapCallback _onTapMoreInfo = () {
      Navigator.of(context)
          .pushNamed(Routes.campaignInfo, arguments: widget.campaign);
    };

    var hPadding = widget.hPadding ?? 15.0;
    var hOuterPadding = widget.hOuterPadding;
    return Tile(
      hPadding: hOuterPadding,
      onTap: _onTapMoreInfo,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Image
          Expanded(
            child: Stack(children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                      decoration: BoxDecoration(
                    image: DecorationImage(
                      image: customNetworkImageProvider(
                          widget.campaign.getHeaderImage()),
                      fit: BoxFit.cover,
                    ),
                    //borderRadius: BorderRadius.only(topLeft: Radius.circular(10))
                  )),
                ),
              ),
              ViewModelBuilder<BaseModel>.reactive(
                  viewModelBuilder: () => BaseModel(),
                  builder: (context, model, child) {
                    bool selected = model.currentUser
                        .getSelectedCampaigns()
                        .contains(widget.campaign.getId());
                    if (selected) {
                      return Padding(
                          padding: EdgeInsets.all(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: JoinedIndicator(),
                          ));
                    } else {
                      return Container();
                    }
                  })
            ]),
          ),
          SizedBox(height: 10),
          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            child: Text(
              widget.campaign.getTitle(),
              textAlign: TextAlign.left,
              style: textStyleFrom(
                Theme.of(context).primaryTextTheme.headline3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 5, bottom: 10, left: hPadding, right: hPadding),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                NumberOfCampaignersIndicator(
                    widget.campaign.getNumberOfCampaigners())
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CampaignTileWithJoinButtons extends StatelessWidget {
  final bool isJoined;
  final Function joinCampaign;
  final Function leaveCampaign;
  final Campaign campaign;
  final double outerPadding;

  CampaignTileWithJoinButtons({
    @required this.isJoined,
    @required this.joinCampaign,
    @required this.leaveCampaign,
    @required this.campaign,
    this.outerPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(outerPadding ?? 18),
        child: CustomTile(
          child: Column(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        customNetworkImageProvider(campaign.getHeaderImage()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  Text(
                    campaign.getTitle(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textStyleFrom(
                      Theme.of(context).primaryTextTheme.headline3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  NumberOfCampaignersIndicator(
                      campaign.getNumberOfCampaigners()),
                ]),
              ),
              Container(
                color: Color.fromRGBO(247, 248, 252, 1),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextButton(
                        "More info",
                        onClick: () {},
                        fontColor: Color.fromRGBO(109, 113, 129, 1),
                      ),
                      isJoined
                          ? DarkButton(
                              "Joined",
                              //inverted: true,
                              onPressed: () {
                                leaveCampaign(campaign.getId());
                              },
                              size: DarkButtonSize.Small,
                              rightIcon: Icons.check,
                            )
                          : DarkButton(
                              "Join",
                              //inverted: true,
                              onPressed: () {
                                joinCampaign(campaign.getId());
                              },
                              size: DarkButtonSize.Medium,
                              rightIcon: Icons.link,
                              style: DarkButtonStyle.Secondary,
                            )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class NumberOfCampaignersIndicator extends StatelessWidget {
  final int numberOfCampaigners;
  NumberOfCampaignersIndicator(this.numberOfCampaigners);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.people,
          size: 18,
        ),
        SizedBox(width: 2),
        RichText(
            text: TextSpan(children: [
          TextSpan(
            text: numberOfCampaigners.toString(),
            style: textStyleFrom(
              Theme.of(context).primaryTextTheme.headline5,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(63, 61, 86, 1),
            ),
          ),
          TextSpan(
            text: " campaigners",
            style: textStyleFrom(
              Theme.of(context).primaryTextTheme.headline5,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(63, 61, 86, 1),
            ),
          ),
        ]))
      ],
    );
  }
}

/// Clickable tiles to take you to the campaings page
///
/// It looks a bit like this ![CampaignSelectiontile](https://i.ibb.co/xLvDbPx/IMG-20201102-213937.jpg)
class CampaignSelectionTile extends StatelessWidget {
  final double defaultHeight = 110;

  final Campaign campaign;
  final double height;
  CampaignSelectionTile(this.campaign, {this.height});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(Routes.campaignInfo, arguments: campaign.getId());
        },
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: CustomTile(
                color: colorFrom(
                  Theme.of(context).primaryColorDark,
                  opacity: 0.05,
                ),
                child: Stack(children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                          height: height ?? defaultHeight,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: customNetworkImageProvider(
                                  campaign.getHeaderImage()),
                              fit: BoxFit.cover,
                            ),
                          )),
                      Container(
                          height: height ?? defaultHeight,
                          color: colorFrom(
                            Colors.black,
                            opacity: 0.5,
                          )),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(campaign.getTitle(),
                            textAlign: TextAlign.center,
                            style: textStyleFrom(
                              Theme.of(context).primaryTextTheme.headline4,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ))),
                  )
                ]))));
  }
}
