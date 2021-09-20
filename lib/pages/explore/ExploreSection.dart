import 'package:flutter/material.dart';
import 'package:app/models/Explorable.dart';
import 'package:app/pages/explore/ExploreFilter.dart';

import 'package:app/models/Campaign.dart';
import 'package:app/models/Action.dart';

import 'package:app/locator.dart';
import 'package:app/services/campaign_service.dart';

import 'package:stacked/stacked.dart';
import 'package:app/viewmodels/explore_page_view_model.dart';

abstract class ExploreSection<ExplorableType> {

  /// Title of the section
  final String title;

  // TODO
  /// Where clicking on the title should go (maybe this should be a function?)
  // final String link;

  /// Description of the section
  final String description;

  // Params to provide to fetch query
  final Map fetchParams;

  /// 
  final ExploreFilter filter;
 
  const ExploreSection({this.title, this.description, this.fetchParams, this.filter});

  Future<List<ExplorableType>> fetchTiles();
  Widget renderTile(ExplorableType tile);

  Widget render(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).primaryTextTheme.headline2, textAlign: TextAlign.left),
        Text(description, style: Theme.of(context).primaryTextTheme.headline4, textAlign: TextAlign.left),
        
        filter != null 
          ? ViewModelBuilder<ExplorePageViewModel>.reactive(
              viewModelBuilder: () => ExplorePageViewModel(),
              builder: (context, model, child) {
                return Container(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: filter.options.map((ExploreFilterOption option) => Padding(
                        padding: EdgeInsets.all(10),
                        child: option.render(model),
                      )
                    ).toList()
                  ),
                );
              }
            )
          : SizedBox(height: 0),

        Container(
          height: 200,
          child: FutureBuilder<List<ExplorableType>>(
            future: fetchTiles(),
            builder: (BuildContext context, AsyncSnapshot<List<ExplorableType>> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  child: CircularProgressIndicator()
                );
              }
              return ListView(
                scrollDirection: Axis.horizontal,
                children: snapshot.data.map((item) => Padding(
                    padding: EdgeInsets.all(10),
                    child: renderTile(item) 
                  )
                ).toList()
              );
            }
          ),
        ),
      ]
    );
  }
}

class CampaignExploreSection extends ExploreSection<Campaign> {
  const CampaignExploreSection({String title, String description, Map fetchParams, ExploreFilter filter}) : super(title:title, description:description, fetchParams:fetchParams, filter:filter);

  Future<List<Campaign>> fetchTiles() async {
    final CampaignService _campaignService = locator<CampaignService>();
    await _campaignService.fetchCampaigns();
    return _campaignService.campaigns;
  }

  Widget renderTile(Campaign campaign) {
    return Container(color: Colors.red, height: 100, width: 200, child: Text(campaign.title));
  }
}

class ActionExploreSection extends ExploreSection<CampaignAction> {
  const ActionExploreSection({String title, String description, Map fetchParams, ExploreFilter filter}) : super(title:title, description:description, fetchParams:fetchParams, filter:filter);

  Future<List<CampaignAction>> fetchTiles() async {
    final CampaignService _campaignService = locator<CampaignService>();
    await _campaignService.fetchCampaigns();
    return _campaignService.getActiveActions();
  }

  Widget renderTile(CampaignAction tile) {
    return Container(
      color: Colors.blue, height: 100, width: 200
    );
  }
}

