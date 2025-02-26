import 'package:causeApiClient/causeApiClient.dart' as Api;

class UserProfile {
  final int id;
  final String? email;
  final String? name;

  UserProfile({
    required this.id,
    required this.email,
    required this.name,
  });

  UserProfile.fromApiModel(Api.UserProfileGet apiModel)
      : id = apiModel.id,
        name = apiModel.name,
        email = apiModel.email;

  // TODO Find out why user name can be empty string - that should be impossible at server level
  bool get isInitialised => name != null && name != '';
}

class CausesUser {
  bool get isInitialised => selectedCausesIds.isNotEmpty;

  final Set<int> selectedCausesIds;
  final Set<int> completedActionIds;
  final Set<int> completedCampaignIds;
  final Set<int> completedLearningResourceIds;
  final Set<int> completedNewsArticleIds;

  CausesUser({
    required this.selectedCausesIds,
    required this.completedActionIds,
    required this.completedCampaignIds,
    required this.completedLearningResourceIds,
    required this.completedNewsArticleIds,
  });

  CausesUser.fromApiModel(Api.CausesUser apiModel)
      : selectedCausesIds = apiModel.selectedCausesIds.toSet(),
        completedActionIds = apiModel.completedActionIds.toSet(),
        completedCampaignIds = apiModel.completedCampaignIds.toSet(),
        completedLearningResourceIds =
            apiModel.completedLearningResourceIds.toSet(),
        completedNewsArticleIds = apiModel.completedNewsArticleIds.toSet();
}
