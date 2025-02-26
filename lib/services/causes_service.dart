import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:causeApiClient/causeApiClient.dart' as Api;
import 'package:logging/logging.dart';
import 'package:nowu/locator.dart';
import 'package:nowu/models/action.dart';
import 'package:nowu/models/article.dart';
import 'package:nowu/models/campaign.dart';
import 'package:nowu/models/cause.dart';
import 'package:nowu/models/learning.dart';
import 'package:nowu/models/organisation.dart';
import 'package:nowu/models/user.dart';
import 'package:nowu/services/analytics.dart';
import 'package:nowu/services/api_service.dart';
import 'package:nowu/services/auth.dart';
import 'package:nowu/utils/let.dart';
import 'package:nowu/utils/stream_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

export 'package:nowu/models/action.dart';
export 'package:nowu/models/campaign.dart';
export 'package:nowu/models/cause.dart';
export 'package:nowu/models/learning.dart';
export 'package:nowu/models/organisation.dart';

class CausesService {
  final _authService = locator<AuthenticationService>();
  final _analyticsService = locator<AnalyticsService>();
  final _apiService = locator<ApiService>();
  final _logger = Logger('CausesService');

  CausesService() {
    _authService.authState.listen((event) {
      switch (event.event) {
        case AuthChangeEvent.signedOut:
          _userInfoStore.value = null;
          break;
        default:
          break;
      }
    });
  }

  // Cache of user info
  StreamStore<CausesUser?> _userInfoStore = StreamStore<CausesUser?>(null);
  StreamStore<List<Cause>?> _causesStore = StreamStore<List<Cause>?>(null);

  Stream<CausesUser?> get userInfoStream => _userInfoStore.stream;
  Stream<List<Cause>?> get causesStream => _causesStore.stream;

  Future<List<Cause>?> _fetchCauses() async {
    _logger.info('Fetching causes from the service');
    final response = await _causeServiceClient.getCausesApi().causesList();

    final causes = response.data?.map(Cause.fromApiModel).toList();

    _logger.info('Got causes, ${_causesStore.value}');

    _causesStore.value = causes;
    return causes;
  }

  Api.CauseApiClient get _causeServiceClient => _apiService.apiClient;

  /// Get a list of causes
  ///
  /// Input params
  /// Returns a list of Causes from the API
  Future<List<Cause>> listCauses() async {
    if (_causesStore.value == null) {
      await _fetchCauses();
    }
    return _causesStore.value!;
  }

  Future<Cause> getCause(int id) async {
    final causes = await listCauses();
    return causes.firstWhere((cause) => cause.id == id);
  }

  /// Get a campaign by id
  ///
  /// Input Action id
  /// Returns the Action with that id
  Future<Campaign> getCampaign(int id) async {
    final response =
        await _causeServiceClient.getCampaignsApi().campaignsRetrieve(id: id);
    return Campaign.fromApiModel(response.data!);
  }

  /// Get an action by id
  ///
  /// Input params
  /// Return a List of ListActions
  Future<Action> getAction(int id) async {
    _logger.info('Getting action id=$id');
    final response =
        await _causeServiceClient.getActionsApi().actionsRetrieve(id: id);
    return Action.fromApiModel(response.data!);
  }

  /// Set user's selected causes
  ///
  /// Input causes that the user has selected
  /// Posts the ids of these causes to the API
  Future<void> selectCauses(Set<int> selectedCausesIds) async {
    final response =
        await _causeServiceClient.getMeApi().meCausesInfoPartialUpdate(
              patchedCausesUser: Api.PatchedCausesUser(
                (userInfo) => userInfo
                  ..selectedCausesIds = ListBuilder(selectedCausesIds.toList()),
              ),
            );

    _userInfoStore.value = response.data?.let(CausesUser.fromApiModel);

    // After selecting causes we fetch all causes to updated 'selected' status
    await _fetchCauses();
  }

  /// Complete an action
  ///
  /// Used so a user can set an action as completed
  Future completeAction(ListAction action) async {
    await (
      _causeServiceClient.getActionsApi().actionsComplete(id: action.id),
      _analyticsService.logActionEvent(
        action,
        ActionEvent.Complete,
      ),
    ).wait;

    // Update user after request
    await fetchUserInfo();
  }

  /// Uncomlete an action
  ///
  /// Sets an action as uncompleted
  Future removeActionStatus(ListAction action) async {
    await (
      _causeServiceClient.getActionsApi().actionsUncomplete(id: action.id),
      _analyticsService.logActionEvent(
        action,
        ActionEvent.Uncomplete,
      ),
    ).wait;

    // Update user after request
    await fetchUserInfo();
  }

  /// Complete a learning resource
  ///
  /// Marks a learning resource as completed
  Future completeLearningResource(LearningResource learningResource) async {
    if (!_authService.isAuthenticated) {
      _logger.warning(
        'User is not logged in, skipping learning resource completion',
      );
      return;
    }
    await (
      _causeServiceClient
          .getLearningResourcesApi()
          .learningResourcesComplete(id: learningResource.id),
      _analyticsService.logLearningResourceClicked(learningResource),
    ).wait;

    // Update user after request
    await fetchUserInfo();
  }

  Future completeNewsArticle(NewsArticle newsArticle) async {
    if (!_authService.isAuthenticated) {
      _logger.warning(
        'User is not logged in, skipping news article completion',
      );
      return;
    }
    await (
      _causeServiceClient
          .getNewsArticlesApi()
          .newsArticleComplete2(id: newsArticle.id),
      _analyticsService.logNewsArticleClicked(newsArticle),
    ).wait;

    // Update user after request
    await fetchUserInfo();
  }

  /// Fetch organisation which are partnered with now-u
  Future<List<Organisation>?> getPartners() async {
    final response =
        await _causeServiceClient.getOrganisationsApi().organisationsList();

    return response.data?.results?.map((org) => Organisation(org)).toList();
  }

  // TODO Make private
  Future<CausesUser?> fetchUserInfo() async {
    if (!_authService.isAuthenticated) {
      _logger.warning('Trying to fetch user info when not authenticated');
      return null;
    }
    final response =
        await _causeServiceClient.getMeApi().meCausesInfoRetrieve();
    return _userInfoStore.value = response.data?.let(CausesUser.fromApiModel);
  }

  Future<CausesUser?> getUserInfo() async {
    if (_userInfoStore.value != null) {
      return _userInfoStore.value;
    }
    return fetchUserInfo();
  }
}
