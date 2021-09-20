import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:app/models/Action.dart';
import 'package:app/models/Organisation.dart';
import 'package:app/models/SDG.dart';

import 'package:app/locator.dart';
import 'package:app/services/dynamicLinks.dart';
import 'package:app/models/Explorable.dart';

final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();

class Campaign implements Explorable {
  int id;
  String title;
  String shortName;
  String description;
  int numberOfCampaigners;
  int numberOfActionsCompleted;
  String headerImage;
  String _infographic;
  String get infographic => _infographic;
  bool isCampaignSelected;
  List<CampaignAction> actions;
  List<Organisation> generalPartners;
  List<Organisation> campaignPartners;
  String videoLink;
  List<SDG> sdgs;
  List<String> keyAims;
  DateTime startDate;
  DateTime endDate;

  Campaign({
    @required int id,
    @required String title,
    @required String shortName,
    @required String description,
    this.numberOfCampaigners,
    this.numberOfActionsCompleted,
    @required String headerImage,
    @required List<CampaignAction> actions,
    @required List<SDG> sdgs,
    List<Organisation> generalPartners,
    List<Organisation> campaignPartners,
    String videoLink,
    String infographic,
    List<String> keyAims,
    DateTime startDate,
    DateTime endDate,
  }) {
    this.id = id;
    this.title = title;
    this.shortName = shortName;
    this.description = description;
    this.numberOfCampaigners = numberOfCampaigners;
    this.headerImage = headerImage;
    this.actions = actions;
    this.videoLink = videoLink;
    this.generalPartners = generalPartners ?? [];
    this.campaignPartners = campaignPartners ?? [];
    this.sdgs = sdgs ?? [];
    this.keyAims = keyAims ?? [];
    this.startDate = startDate;
    this.endDate = endDate;
    this._infographic = infographic;
  }

  Campaign.fromJson(Map json) {
    print("Getting campaigns from json");
    print(json);
    id = json['id'];
    title = json['title'];
    shortName = json['short_name'];
    description = json['description_app'];
    numberOfCampaigners = json['number_of_campaigners'];
    numberOfActionsCompleted = json['number_of_completed_actions'];
    headerImage = json['header_image'];
    _infographic = json['infographic_url'];

    actions = (json['actions']) == null
        ? []
        : (json['actions'])
            .map((e) => CampaignAction.fromJson(e))
            .toList()
            .cast<CampaignAction>();
    campaignPartners = json["campaign_partners"] == null
        ? []
        : (json['campaign_partners'])
            .map((e) => Organisation.fromJson(e))
            .toList()
            .cast<Organisation>();
    generalPartners = json['general_partners'] == null
        ? []
        : (json['general_partners'])
            .map((e) => Organisation.fromJson(e))
            .toList()
            .cast<Organisation>();
    videoLink = json['video_link'];
    sdgs = json['sdgs'] == null
        ? <SDG>[]
        : json['sdgs']
            .map((s) => getSDGfromNumber(s['id']))
            .toList()
            .cast<SDG>();

    keyAims = json['key_aims'] == null
        ? <String>[]
        : json['key_aims'].map((a) => a['title']).toList().cast<String>();

    startDate =
        json['start_date'] == null ? null : DateTime.parse(json['start_date']);
    endDate =
        json['end_date'] == null ? null : DateTime.parse(json['end_date']);
  }

  Map toJson() => {
        'id': id,
        'title': title,
        'short_name': shortName,
        'description': description,
        'number_of_campaigners': numberOfCampaigners,
        'number_of_completed_actions': numberOfActionsCompleted,
        'header_image': headerImage,
        // TODO this proabably wont work
        'actions': actions,
        'general_partners': generalPartners,
        'campaign_partners': campaignPartners,
        'video_link': videoLink,
        'sdgs': sdgs.map((s) => s.getNumber()),
      };

  int getId() {
    return id;
  }

  String getTitle() {
    return title;
  }

  String getShortName() {
    return shortName;
  }

  String getDescription() {
    // TODO function to remove escape characters
    var descriptionWithoutNs = description.replaceAll('\\n', '\n\n');
    return descriptionWithoutNs;
  }

  int getNumberOfCampaigners() {
    return numberOfCampaigners;
  }

  int getNumberOfActionsCompleted() {
    return numberOfActionsCompleted;
  }

  String getHeaderImage() {
    return headerImage;
  }

  String getVideoLink() {
    return videoLink;
  }

  bool isSelected(List<int> selectedCampaings) {
    return selectedCampaings.contains(id);
  }

  List<CampaignAction> getActions() {
    return actions;
  }

  List<Organisation> getCampaignPartners() {
    return campaignPartners;
  }

  List<Organisation> getGeneralPartners() {
    return generalPartners;
  }

  List<SDG> getSDGs() {
    return sdgs;
  }

  List<String> getKeyAims() {
    return keyAims;
  }

  // TODO on error use this function instead
  //String getManualShareLink() {
  //  return "https://nowu.page.link/?link=https://now-u.com/campaigns/$id&apn=com.nowu.app&isi=1516126639&ibi=com.nowu.app&st=${Uri.encodeFull(title)}&si=$headerImage";
  //}

  Future<String> getShareText() async {
    Uri uri = await _dynamicLinkService.createDynamicLink(
      linkPath: "campaigns/$id",
      title: "$title",
      description: "$description",
      imageUrl: "$headerImage",
    );
    String shareLink = uri.toString();
    //return "Check out the $title campaign on now-u! ${getShareLink()}";
    return "Check out the $title campaign on now-u! $shareLink";
  }

  bool isPast() {
    if (endDate == null) {
      return false;
    }
    return DateTime.now().compareTo(endDate) > 0;
  }
}
