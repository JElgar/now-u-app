import 'package:app/assets/StyleFrom.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:app/models/Explorable.dart';
import 'package:app/assets/components/selectionItem.dart';

// Custom Icons
import 'package:app/assets/icons/customIcons.dart';

enum CampaignActionSuperType { GetInvolved, Learn, Advoacte, RaiseMoney }

enum CampaignActionType {
  Volunteer,
  Donation,
  Fundraise,
  Awareness,
  Petition,
  Behaviour,
  Contact,
  Protest,
  Connect,
  Learn,
  Quiz,
  Other
}

List<String> rejectionReasons = [
  "It requires too much effort",
  "It takes too long",
  "It does not seem useful/impactful",
  "I have completed too many of these",
  "This is not something I like doing",
  "Other",
];

// Depreciated
Color red = Color.fromRGBO(211, 0, 1, 1);
Color redO = colorFrom(red, opacity: 0.15);

Color green = Color.fromRGBO(89, 152, 26, 0.7);
Color greenO = colorFrom(green, opacity: 0.2);
Color orange = Color.fromRGBO(255, 136, 0, 0.7);
Color orangeO = colorFrom(orange, opacity: 0.2);
Color yellow = Color.fromRGBO(243, 183, 0, 0.7);
Color yellowO = colorFrom(yellow, opacity: 0.2);
Color blue = Color.fromRGBO(38, 151, 211, 0.7);
Color blueO = colorFrom(blue, opacity: 0.2);

Map campaignActionSuperTypeData = {
  CampaignActionSuperType.GetInvolved: {
    'name': "Get involved",
    'icon': CustomIcons.ic_getinvolved,
    'iconColor': orange,
    'iconBackgroundColor': orangeO,
  },
  CampaignActionSuperType.Learn: {
    'name': "Learn",
    'icon': CustomIcons.ic_learning,
    'iconColor': blue,
    'iconBackgroundColor': blueO,
  },
  CampaignActionSuperType.Advoacte: {
    'name': "Advocate",
    'icon': CustomIcons.ic_raiseawareness,
    'iconColor': orange,
    'iconBackgroundColor': orangeO,
  },
  CampaignActionSuperType.RaiseMoney: {
    'name': "Raise money",
    'icon': CustomIcons.ic_raisemoney,
    'iconColor': yellow,
    'iconBackgroundColor': yellowO,
  },
};

Map defaultCampaignActionTypeData = {
  'name': "other",
  'verb': "Complete",
  'pastVerb': "Completed",
  'displayName': "special action",
  //'icon': FontAwesomeIcons.check,
  //'Type': CustomIcons.heartHand,
  'type': CampaignActionSuperType.GetInvolved,
};

Map campaignActionTypeData = {
  CampaignActionType.Volunteer: {
    'name': "volunteer",
    'verb': "Volunteer",
    'pastVerb': "Volunteered",
    'displayName': "volunteer",
    //'icon': CustomIcons.icon_vol_1,
    'type': CampaignActionSuperType.GetInvolved,
  },
  CampaignActionType.Donation: {
    'name': "donate",
    'verb': "Make",
    'pastVerb': "Made",
    'displayName': "donation",
    //'icon': CustomIcons.icon_donate_01,
    'type': CampaignActionSuperType.RaiseMoney,
  },
  CampaignActionType.Fundraise: {
    'name': "fundraise",
    'verb': "Take part in",
    'pastVerb': "Took part in",
    'displayName': "fundraiser",
    //'icon': CustomIcons.icon_fundraise_01,
    'type': CampaignActionSuperType.RaiseMoney,
  },
  CampaignActionType.Awareness: {
    'name': "awareness",
    'verb': "Raise awareness",
    'pastVerb': "Raised awareness",
    'displayName': "time",
    //'icon': CustomIcons.icon_raise_awareness_01_01,
    'type': CampaignActionSuperType.Advoacte,
  },
  CampaignActionType.Petition: {
    'name': "sign",
    'verb': "Sign",
    'pastVerb': "Signed",
    'displayName': "petiton",
    //'icon': CustomIcons.icon_petition_01,
    'type': CampaignActionSuperType.Advoacte,
  },
  CampaignActionType.Behaviour: {
    'name': "behaviour",
    'verb': "Complete",
    'pastVerb': "Completed",
    'displayName': "behaviour change action",
    //'icon': CustomIcons.icon_behaviour_01,
    'type': CampaignActionSuperType.GetInvolved,
  },
  CampaignActionType.Contact: {
    'name': "contact",
    'verb': "Complete",
    'pastVerb': "Completed",
    'displayName': "contact change action",
    //'icon': CustomIcons.icon_contact_01,
    'type': CampaignActionSuperType.Advoacte,
  },
  CampaignActionType.Protest: {
    'name': "protest",
    'verb': "Take part in",
    'pastVerb': "Took part in",
    'displayName': "protest",
    //'icon': CustomIcons.icon_protest_01,
    'type': CampaignActionSuperType.GetInvolved,
  },
  CampaignActionType.Connect: {
    'name': "connect",
    'verb': "Connect",
    'pastVerb': "Connted",
    'displayName': "times",
    //'icon': FontAwesomeIcons.link,
    //'icon': CustomIcons.icon_connect_01,
    'type': CampaignActionSuperType.GetInvolved,
  },
  CampaignActionType.Learn: {
    'name': "learn",
    'verb': "Complete",
    'pastVerb': "Completed",
    'displayName': "learning action",
    //'icon': CustomIcons.icon_learning_01,
    'type': CampaignActionSuperType.Learn,
  },
  CampaignActionType.Quiz: {
    'name': "quiz",
    'verb': "Complete",
    'pastVerb': "Completed",
    'displayName': "quiz",
    //'icon': CustomIcons.icon_quiz_01,
    'type': CampaignActionSuperType.Learn,
  },
  CampaignActionType.Other: defaultCampaignActionTypeData
};

List<Map> timeBrackets = [
  {"text": "1-5 mins", "minTime": 0, "maxTime": 5},
  {"text": "5-15 mins", "minTime": 5, "maxTime": 15},
  {"text": "15-30 mins", "minTime": 15, "maxTime": 30},
  {"text": "30-60 mins", "minTime": 30, "maxTime": 60},
  {"text": "Few hours", "minTime": 60, "maxTime": 240},
  {"text": "Long term", "minTime": 240, "maxTime": double.infinity},
];

CampaignActionType campaignActionTypeFromString(String s) {
  // Apparently if we return early it just doesnt do the return? Not sure why that would be but this seems to fix it
  CampaignActionType t = CampaignActionType.Other;
  campaignActionTypeData.forEach((key, value) {
    if (value['name'] == s) {
      t = key;
    }
  });
  return t;
}

Tuple3<String, String, String> generateCampaingActionDesc(
    CampaignActionType t) {
  print("Getting campaing aciton desc");
  if (campaignActionTypeData.containsKey(t)) {
    print("Found key");
    print(campaignActionTypeData[t]['name']);
    print("Looking for the thing");
    return Tuple3(
        campaignActionTypeData[t]['verb'],
        campaignActionTypeData[t]['pastVerb'],
        campaignActionTypeData[t]['displayName']);
  }
  return Tuple3("Complete", "Completed", "special action");
}

class CampaignAction implements Explorable {
  int id;
  String title;
  double time;
  String whatDescription;
  String whyDescription;
  String link;
  CampaignActionType type;
  DateTime createdAt;
  DateTime releasedAt;

  CampaignAction({
    @required this.id,
    @required this.title,
    @required this.whatDescription,
    @required this.whyDescription,
    @required this.link,
    @required this.type,
    @required this.time,
    this.createdAt,
    this.releasedAt,
  });

  CampaignAction.fromJson(Map json) {
    //print(json);
    id = json['id'];
    title = json['title'];
    whatDescription = json['what_description'];
    whyDescription = json['why_description'];
    link = json['link'];
    time = json['time'] == null ? 5.0 : json['time'].toDouble();
    type = campaignActionTypeFromString(json['type']);
    createdAt = DateTime.parse(json['created_at']);
    releasedAt = json['release_date'] == null
        ? null
        : DateTime.parse(json['release_date']);
  }

  Map toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'time': time,
      };

  int getId() {
    return id;
  }

  String getTitle() {
    return title;
  }

  String getWhatDescription() {
    return whatDescription;
  }

  String getWhyDescription() {
    return whyDescription;
  }

  String getLink() {
    return link;
  }

  double getTime() {
    return time;
  }

  String getTimeText() {
    return timeBrackets.firstWhere((b) => b['maxTime'] > time)['text'];
  }

  CampaignActionType getType() {
    return type;
  }

  CampaignActionSuperType getSuperType() {
    return campaignActionTypeData[type]['type'];
  }

  Map getSuperTypeData() {
    return campaignActionSuperTypeData[campaignActionTypeData[type]['type']];
  }

  String getSuperTypeName() {
    return campaignActionSuperTypeData[campaignActionTypeData[type]['type']]
        ['name'];
  }

  Map getActionIconMap() {
    if (campaignActionTypeData.containsKey(type)) {
      return {
        'icon':
            campaignActionSuperTypeData[campaignActionTypeData[type]['type']]
                ['icon'],
        'iconColor':
            campaignActionSuperTypeData[campaignActionTypeData[type]['type']]
                ['iconColor'],
        'iconBackgroundColor':
            campaignActionSuperTypeData[campaignActionTypeData[type]['type']]
                ['iconBackgroundColor'],
      };
    }
    return defaultCampaignActionTypeData;
  }

  bool isNew() {
    if (releasedAt == null) {
      return DateTime.now().difference(createdAt).compareTo(Duration(days: 2)) <
          0;
    } else {
      return DateTime.now()
              .difference(releasedAt)
              .compareTo(Duration(days: 2)) <
          0;
    }
  }
}
