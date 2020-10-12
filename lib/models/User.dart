import 'package:app/models/Reward.dart';
import 'package:app/models/Action.dart';
import 'package:app/models/Campaign.dart';
import 'package:app/models/Campaigns.dart';
import 'package:app/models/Organisation.dart';

List<String> stagingUsers = [
  "james@now-u.com",
  "dave@now-u.com",
  "valusoutrik@gmail.com",
  "jamezy850@gmail.com"
];

List<int> rewardValues = [1, 5, 10, 25, 50, 100, 200];
int pointsForJoiningCampaign = 10;
int pointsForCompletingAction = 5;

class User {
  int id;
  //FirebaseUser firebaseUser;
  String fullName;
  String email;
  DateTime dateOfBirth;

  // TODO make some attributes class that can take any attrribute so I dont need this
  String location;
  double monthlyDonationLimit;
  bool homeOwner;

  // Progress (All data stored as ids)
  List<int> selectedCampaigns =
      []; // Stores all campaings that have been selected (including old ones)
  List<int> completedCampaigns =
      []; // Stores campaings where all actions have been completed (maybe we should do 80% of something)
  //List<int> completedRewards = [];
  List<int> completedActions = [];
  List<int> completedLearningResources = [];

  // Key is rejected id
  // Map stores rejection time and rejection reason
  List<int> rejectedActions = [];

  List<int> starredActions = [];

  Map<CampaignActionType, int> completedActionsType;

  int points;

  Organisation _organisation;
  Organisation get organisation => _organisation;
  set setOrganisation(Organisation org) => _organisation = org;

  String token;

  User(
      {id,
      token,
      fullName,
      email,
      dateOfBirth,
      location,
      monthlyDonationLimit,
      homeOwner,
      selectedCampaigns,
      completedCampaigns,
      completedActions,
      rejectedActions,
      starredActions,
      completedRewards,
      completedActionsType,
      completedLearningResources,
      points,
      organisation,
    }) {
    this.id = id;
    this.fullName = fullName;
    this.email = email;
    this.dateOfBirth = dateOfBirth;
    this.location = location;
    this.monthlyDonationLimit = monthlyDonationLimit;
    this.homeOwner = homeOwner;

    this.selectedCampaigns = selectedCampaigns ?? [];
    this.completedActions = completedActions ?? [];
    this.rejectedActions = rejectedActions ?? [];
    this.starredActions = starredActions ?? [];
    //this.completedRewards = completedRewards ?? [];

    this.completedLearningResources = completedLearningResources ?? [];

    this.completedActionsType = completedActionsType ?? initCompletedAction();

    this.points = points ?? 0;

    this.token = token;
    _organisation = organisation;
  }

  // This will be removed real soon cause if the user token is null then we need to login again
  User.empty() {
    id = -1;
    fullName = "unknown";
    email = "unknown";
    dateOfBirth = DateTime(1990, 1, 1);
    location = "uknown";
    monthlyDonationLimit = -1;
    homeOwner = false;
    selectedCampaigns = [];
    completedCampaigns = [];
    //completedRewards = [];
    completedActions = [];
    rejectedActions = [];
    starredActions = [];
    completedLearningResources = [];
    completedActionsType = initCompletedAction();
    token = null;
    points = 0;
  }

  User copyWith({
    int id,
    //FirebaseUser firebaseUser,
    String fullName,
    String email,
    DateTime dateOfBirth,

    // TODO make some attributes class that can take any attrribute so I dont need this
    String location,
    double monthlyDonationLimit,
    bool homeOwner,

    // Progress
    List<int> selectedCampaigns,
    List<int> completedCampaigns,
    //List<int> completedRewards,
    List<int> completedActions,
    List<int> rejectedActions,
    List<int> starredActions,
    List<int> completedLearningResources,
    Map<CampaignActionType, int> completedActionsType,
    int points,
    String token,
    Organisation organisation,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      location: location ?? this.location,
      monthlyDonationLimit: monthlyDonationLimit ?? this.monthlyDonationLimit,
      homeOwner: homeOwner ?? this.homeOwner,
      selectedCampaigns: selectedCampaigns ?? this.selectedCampaigns,
      completedCampaigns: completedCampaigns ?? this.completedCampaigns,
      //completedRewards: completedRewards ?? this.completedRewards,
      completedActions: completedActions ?? this.completedActions,
      rejectedActions: rejectedActions ?? this.rejectedActions,
      starredActions: starredActions ?? this.starredActions,
      completedLearningResources:
          completedLearningResources ?? this.completedLearningResources,
      completedActionsType: completedActionsType ?? this.completedActionsType,
      points: points ?? this.points,
      token: token ?? this.token,
      organisation: organisation ?? _organisation,
    );
  }

  User.fromJson(
    Map json,
  ) {
    print("Getting user deets");
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    print("Getting up to email");
    dateOfBirth = json['date_of_birth'] == null || json['date_of_birth'] == ""
        ? null
        : DateTime.tryParse(json['date_of_birth']);
    location = json['location'];
    monthlyDonationLimit = json['monthly_donation_limit'];
    homeOwner = json['home_owner'] ?? false;
    print("Getting up to selectedCampaigns");
    // For cast not to throw null exception must be a default value of [] in User class
    selectedCampaigns =
        json['selected_campaigns'] == null || json['selected_campaigns'].isEmpty
            ? <int>[]
            : json['selected_campaigns'].cast<int>();
    print("Getting up to completed campaigns");
    completedCampaigns = json['completed_campaigns'] == null ||
            json['completed_campaigns'].isEmpty
        ? <int>[]
        : json['completed_campaigns'].cast<int>();
    print("Getting up to completed actions");
    completedActions =
        json['completed_actions'] == null || json['completed_actions'].isEmpty
            ? <int>[]
            : json['completed_actions'].cast<int>();
    rejectedActions =
        json['rejected_actions'] == null || json['rejected_actions'].isEmpty
            ? <int>[]
            : json['rejected_actions'].cast<int>();
    starredActions =
        json['favourited_actions'] == null || json['favourited_actions'].isEmpty
            ? <int>[]
            : json['favourited_actions'].cast<int>();

    completedLearningResources = json['completed_learning_resources'] == null ||
            json['completed_learning_resources'].isEmpty
        ? <int>[]
        : json['completed_learning_resources'].cast<int>();

    completedActionsType = json['completed_actions_type'] == null
        ? this.initCompletedAction()
        : campaignActionTypesDecode(json['completed_actions_type'].cast<int>());

    points = json['points'] ?? 0;
    token = json['token'];
    _organisation = json['organisation'] == null ? null : Organisation.fromJson(json['organisation']);
    print("Got new user");
  }
  Map toJson() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        'date_of_birth':
            dateOfBirth == null ? null : dateOfBirth.toIso8601String(),
        'location': location,
        'monthly_donation_limit': monthlyDonationLimit,
        'home_owner': homeOwner,
        'selected_campaigns': selectedCampaigns,
        'completed_campaigns': completedCampaigns,
        'completed_actions': completedActions,
        'rejected_actions': rejectedActions,
        'favourited_actions': starredActions,
        'completed_learning_resources': completedLearningResources,
        //'completed_rewards': completedRewards,
        'completed_actions_type':
            campaignActionTypesEncode(completedActionsType),
        'points': points,
        'token': token,
      };

  Map getAttributes() {
    return {
      //'id' : id,
      'full_name': fullName,
      'email': email,
      'date_of_birth': dateOfBirth,
      'location': location,
      'monthly_donation_limit': monthlyDonationLimit ?? -1.0,
      'home_owner': homeOwner,
    };
  }

  Map getPostAttributes() {
    return {
      //'id' : id,
      'full_name': fullName,
      'email': email,
      'date_of_birth': dateOfBirth.toString(),
      'location': location,
      'monthly_donatIon_limit': monthlyDonationLimit,
      'home_owner': homeOwner,
    };
  }

  void setAttribute(String k, v) {
    switch (k) {
      case 'full_name':
        {
          this.setName(v.toString());
          break;
        }
      case 'email':
        {
          this.setEmail(v.toString());
          break;
        }
      case 'date_of_birth':
        {
          print("Settting attribute dob");
          this.setDateOfBirth(v);
          break;
        }
      case 'location':
        {
          this.setLocation(v.toString());
          break;
        }
      case 'monthly_donation_limit':
        {
          this.setMonthlyDonationLimit(v);
          break;
        }
      case 'home_owner':
        {
          bool value = v;
          this.setHomeOwner(value);
          break;
        }
    }
  }

  int getId() {
    return id;
  }

  String getName() {
    return fullName;
  }

  String getEmail() {
    return email;
  }

  DateTime getDateOfBirth() {
    return dateOfBirth;
  }

  int getAge() {
    //TODO calculate from dob
    return -1;
  }

  String getLocation() {
    return location;
  }

  double getMonthlyDonationLimit() {
    return monthlyDonationLimit;
  }

  bool getHomeOwner() {
    return homeOwner;
  }

  List<int> getSelectedCampaigns() {
    return selectedCampaigns ?? [];
  }

  List<Campaign> filterSelectedCampaigns(List<Campaign> campaigns) {
    return campaigns
        .where((c) => selectedCampaigns.contains(c.getId()))
        .toList();
  }

  List<Campaign> filterUnselectedCampaigns(List<Campaign> campaigns) {
    return campaigns
        .where((c) => !selectedCampaigns.contains(c.getId()))
        .toList();
  }

  int getSelectedCampaignsLength() {
    if (selectedCampaigns == null)
      return 0;
    else
      return selectedCampaigns.length;
  }

  List<int> getCompletedActions() {
    return completedActions;
  }

  int getPoints() {
    return points;
  }
  
  String getToken() {
    return token;
  }

  List<int> getRejectedActions() {
    return rejectedActions;
  }

  List<int> getStarredActions() {
    return starredActions;
  }

  List<int> getCompletedLearningResources() {
    return completedLearningResources;
  }

  void setName(String name) {
    this.fullName = name;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setDateOfBirth(DateTime dob) {
    this.dateOfBirth = dob;
  }

  void setLocation(location) {
    this.location = location;
  }

  void setMonthlyDonationLimit(double monthlyDonationLimit) {
    this.monthlyDonationLimit = monthlyDonationLimit;
  }

  void setHomeOwner(bool homeOwner) {
    this.homeOwner = homeOwner;
  }

  void setPoints(int points) {
    this.points = points;
  }

  void setCompletedActions(List<int> actions) {
    this.completedActions = actions;
  }
  
  void setToken(String token) {
    this.token = token;
  }

  void incrementPoints(int points) {
    this.points += points;
    print("User points are now " + this.points.toString());
  }

  void decrementPoints(int points) {
    this.points -= points;
    print("User points are now " + this.points.toString());
  }

  void addSelectedCamaping(int id) {
    if (!selectedCampaigns.contains(id)) {
      if (this.selectedCampaigns == null) {
        this.selectedCampaigns = [id];
      } else {
        this.selectedCampaigns.add(id);
      }
      incrementPoints(pointsForJoiningCampaign);
    }
  }

  void removeSelectedCamaping(int id) {
    this.selectedCampaigns.remove(id);
    decrementPoints(pointsForJoiningCampaign);
  }

  double getCampaignProgress(Campaign campaign) {
    return numberOfCompletedActionsForCampaign(campaign) /
        campaign.getActions().length;
  }

  int numberOfCompletedActionsForCampaign(Campaign campaign) {
    int count = 0;
    List<CampaignAction> actions = campaign.getActions();
    for (int i = 0; i < actions.length; i++) {
      if (this.completedActions.contains(actions[i].getId())) {
        count++;
      }
    }
    return count;
  }

  double getActiveCampaignsProgress(Campaigns campaigns) {
    double total = 0;
    for (int i = 0; i < campaigns.activeLength(); i++) {
      total += getCampaignProgress(campaigns.getActiveCampaigns()[i]);
    }
    return total / campaigns.activeLength();
  }

  // Progress
  // Return the reward progress
  double getRewardProgress(Reward reward) {
    //if(this.completedRewards.contains(reward.getId())) return 1;
    RewardType type = reward.type;
    int count = 0;
    if (type == RewardType.CompletedActionsNumber) {
      count = this.completedActions.length;
    } else if (type == RewardType.CompletedCampaignsNumber) {
      count = this.completedCampaigns.length;
    } else if (type == RewardType.SelectInOneMonthCampaignsNumber) {
      count = this.selectedCampaigns.length;
    } else if (type == RewardType.CompletedTypedActionsNumber) {
      if (reward.getActionType() == null) {
        print(
            "A CompletedTypedActionsNumber reward requires a CampaignActionType");
        return 0;
      } else {
        count = this.completedActionsType[reward.getActionType()];
      }
    }

    // return
    if (count > reward.successNumber) {
      //completeReward(reward);
      return 1;
    }
    return count / reward.successNumber;
  }

  void completeAction(CampaignAction a, {Function onCompleteReward}) {
    if (completedActions.contains(a.getId())) {
      print("You can only complete an action once");
      return;
    }
    completedActions.add(a.getId());
    completedActionsType.update(a.getType(), (int x) => x + 1);
    //incrementPoints(pointsForCompletingAction);
    print(a.getType().toString());
    print(completedActionsType[a.getType()]);
  }

  void rejectAction(CampaignAction a) {
    rejectedActions.add(a.getId());
  }

  bool isMilestone(int x) {
    if (x < 300) {
      return rewardValues.contains(x);
    } else
      return x % 50 == 0;
  }

  // Returns the news rewards completed when this action is completed
  List<Reward> newlyCompletedRewards(CampaignAction completedAction) {
    List<Reward> newRewards = [];
    if (isMilestone(completedActions.length + 1)) {
      newRewards.add(Reward(
        successNumber: completedActions.length + 1,
        type: RewardType.CompletedActionsNumber,
        //title: nextValue(v, rewardValues) == 1 ? "Complete your first ${ k.toString() } " : "Complete ${ nextValue(v, rewardValues)} ${ k.toString() }",
      ));
    }
    print(completedAction.getType());
    print(this.completedActionsType);
    if (isMilestone(completedActionsType[completedAction.getType()] + 1)) {
      newRewards.add(Reward(
        successNumber: completedActionsType[completedAction.getType()] + 1,
        type: RewardType.CompletedTypedActionsNumber,
        actionType: completedAction.getType(),
      ));
    }
    return newRewards;
  }

  // Old reward system
  //void completeReward(Reward r) {
  //  completedRewards.add(r.getId());
  //}

  bool isCompleted(CampaignAction a) {
    return completedActions.contains(a.getId());
  }

  Map<CampaignActionType, int> initCompletedAction() {
    Map<CampaignActionType, int> cas = {};
    List<CampaignActionType> types = CampaignActionType.values;
    for (int i = 0; i < CampaignActionType.values.length; i++) {
      print(i);
      CampaignActionType t = types[i];
      cas[t] = 0;
    }
    print(cas);
    return cas;
  }

  int nextValue(int x, List<int> nums) {
    for (int i = 0; i < nums.length; i++) {
      if (rewardValues[i] > x) return rewardValues[i];
    }
    return ((x % 100) + 1) * 100; // Keep incrememnting rewardValues in 100s
  }

  int prevValue(int x, List<int> nums) {
    if (x <= 0) return 0; // In this case no reward completed
    if (x >= 300) {
      return ((x % 100)) * 100; // Keep incrememnting rewardValues in 100s

    }
    for (int i = nums.length - 1; i >= 0; i--) {
      if (rewardValues[i] <= x) return rewardValues[i];
    }
    return 0; // Probably bad news if we get here
  }

  // Get rewards to be completed
  List<Reward> getNextRewards({int x}) {
    List<Reward> rewards = [];
    // Get new CompletedTypedActionsNumber
    completedActionsType.forEach((k, v) {
      rewards.add(Reward(
        successNumber: nextValue(v, rewardValues),
        type: RewardType.CompletedTypedActionsNumber,
        actionType: k,
        //title: nextValue(v, rewardValues) == 1 ? "Complete your first ${ k.toString() } " : "Complete ${ nextValue(v, rewardValues)} ${ k.toString() }",
      ));
    });
    // Add next completedActionsNumber
    rewards.add(Reward(
      successNumber: nextValue(completedCampaigns.length, rewardValues),
      type: RewardType.CompletedCampaignsNumber,
    ));

    // Add total completed actions
    rewards.add(Reward(
      successNumber: nextValue(completedActions.length, rewardValues),
      type: RewardType.CompletedActionsNumber,
    ));
    return rewards;
  }

  // Get largest reward that have been completed
  List<Reward> getPreviousRewards({int x}) {
    List<Reward> rewards = [];
    // Get pev (complted) CompletedTypedActionsNumber
    completedActionsType.forEach((k, v) {
      if (prevValue(v, rewardValues) != 0) {
        rewards.add(Reward(
          //id: ,  // Need to generate id based on value --> same each time generated
          successNumber: prevValue(v, rewardValues),
          type: RewardType.CompletedTypedActionsNumber,
          actionType: k,
          //title: prevValue(v, rewardValues) == 1 ? "Complete your first ${ k.toString() } " : "Complete ${ prevValue(v, rewardValues)} ${ k.toString() }",
        ));
      }
    });

    // Add total completed campaigns
    if (completedCampaigns.length > 0) {
      rewards.add(Reward(
        successNumber: prevValue(completedCampaigns.length, rewardValues),
        type: RewardType.CompletedCampaignsNumber,
      ));
    }

    // Add total completed actions
    if (completedActions.length > 0) {
      rewards.add(Reward(
        successNumber: prevValue(completedActions.length, rewardValues),
        type: RewardType.CompletedActionsNumber,
      ));
    }

    print("previous rewards");
    print(rewards.length);
    return rewards;
  }

  List<Reward> getAllRewards({int x}) {
    List<Reward> completedRewards = getPreviousRewards();
    List<Reward> nextRewards = getNextRewards();
    return completedRewards..addAll(nextRewards);
  }

  bool isStagingUser() {
    return stagingUsers.contains(email);
  }
}

// TODO this feels very fragile. Find out what happens if I delete/add a CampaignActionType
List<int> campaignActionTypesEncode(Map<CampaignActionType, int> cats) {
  List<int> encodable = <int>[];
  List<CampaignActionType> list = CampaignActionType.values;
  for (int i = 0; i < list.length; i++) {
    encodable.add(cats[list[i]]);
  }
  return encodable;
}

Map<CampaignActionType, int> campaignActionTypesDecode(List<int> ints) {
  Map<CampaignActionType, int> cats = {};
  List<CampaignActionType> types = CampaignActionType.values;
  for (int i = 0; i < ints.length; i++) {
    CampaignActionType t = types[i];
    cats[t] = ints[i];
  }
  return cats;
}
