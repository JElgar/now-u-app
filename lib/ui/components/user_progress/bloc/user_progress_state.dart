import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nowu/models/user.dart';

part 'user_progress_state.freezed.dart';

@freezed
sealed class UserProgressState with _$UserProgressState {
  const factory UserProgressState.loading() = UserProgressStateLoading;
  const factory UserProgressState.noUser() = UserProgressStateNoUser;
  const factory UserProgressState.loaded({required CausesUser userInfo}) =
      UserProgressStateLoaded;
  const factory UserProgressState.error(String message) =
      UserProgressStateError;
}

extension UserProgressStateExt on UserProgressState {
  CausesUser? _getUserInfo() {
    switch (this) {
      case UserProgressStateLoading():
      case UserProgressStateError():
      case UserProgressStateNoUser():
        return null;
      case UserProgressStateLoaded(:final userInfo):
        return userInfo;
    }
  }

  bool learningResourceIsCompleted(int learningResourceId) {
    return _getUserInfo()
            ?.completedLearningResourceIds
            .contains(learningResourceId) ??
        false;
  }

  bool actionIsCompleted(int actionId) {
    return _getUserInfo()?.completedActionIds.contains(actionId) ?? false;
  }

  bool campaignIsCompleted(int campaignId) {
    return _getUserInfo()?.completedCampaignIds.contains(campaignId) ?? false;
  }

  bool newsArticleIsCompleted(int articleId) {
    return _getUserInfo()?.completedNewsArticleIds.contains(articleId) ?? false;
  }

  bool causeIsSelected(int causeId) {
    return _getUserInfo()?.selectedCausesIds.contains(causeId) ?? false;
  }
}
