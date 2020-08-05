import 'package:app/models/User.dart';
import 'package:app/models/Action.dart';
import 'package:app/models/Campaign.dart';
import 'package:app/models/Campaigns.dart';
import 'package:app/models/Learning.dart';

class InitaliseState {}

class InitalisedState {
  InitalisedState();
}

class JoinedCampaign {
  User user;
  JoinedCampaign(this.user);
}

class UnjoinCampaign {
  final Campaign campaign;

  UnjoinCampaign(this.campaign);
}

class UnjoinedCampaign {
  final int points;
  final List<int> joinedCampaigns;

  UnjoinedCampaign(this.points, this.joinedCampaigns);
}

class CompletedAction {
  final User user;
  CompletedAction(this.user);
}

class RejectAction {
  final CampaignAction action;
  final String reason;
  RejectAction(this.action, this.reason);
}

class RejectedAction {
  final User user;
  RejectedAction(this.user);
}

class StarredAction {
  final User user;
  StarredAction(this.user);
}

class RemovedActionStatus {
  final User user;
  RemovedActionStatus(this.user);
}

class CompleteLearningResource {
  final LearningResource resource;
  CompleteLearningResource(this.resource);
}

class CompletedLearningResource {
  final User user;
  CompletedLearningResource(this.user);
}

class CreateNewUser {
  final User user;
  CreateNewUser(this.user);
}

class Logout {}

class UpdateUserDetails {
  final User user;
  UpdateUserDetails(this.user);
}

class UpdatedUserDetails {
  final User user;
  UpdatedUserDetails(this.user);
}

class GetCampaignsAction {}

class LoadedCampaignsAction {
  final Campaigns campaigns;

  LoadedCampaignsAction(this.campaigns);
}

class GetUserDataAction {}

class LoadedUserDataAction {
  final User user;
  LoadedUserDataAction(this.user);
}

// User Actions
class StartLoadingUserAction {}

class LoginSuccessAction {
  final User user;
  LoginSuccessAction(this.user);
}

class LoginFailedAction {}

class SendingAuthEmail {}

class SentAuthEmail {
  final String email;
  SentAuthEmail(this.email);
}

// Logic called on startup
class StartUp {}
