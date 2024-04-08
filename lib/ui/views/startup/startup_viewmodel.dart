import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:nowu/app/app.locator.dart';
import 'package:nowu/services/analytics.dart';
import 'package:nowu/services/api_service.dart';
import 'package:nowu/services/auth.dart';
import 'package:nowu/services/causes_service.dart';
import 'package:nowu/services/dynamicLinks.dart';
import 'package:nowu/services/pushNotifications.dart';
import 'package:nowu/services/router_service.dart';
import 'package:nowu/services/shared_preferences_service.dart';
import 'package:nowu/ui/common/post_login_viewmodel.dart';
import 'package:nowu/ui/views/startup/startup_state.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stacked/stacked.dart';

class StartupViewModel extends BaseViewModel with PostLoginViewModelMixin {
  final _routerService = locator<RouterService>();
  final _logger = Logger('StartupViewModel');
  final _apiService = locator<ApiService>();
  final _authenticationService = locator<AuthenticationService>();
  final _dynamicLinkService = locator<DynamicLinkService>();
  final _pushNotificationService = locator<PushNotificationService>();
  final _sharedPreferencesService = locator<SharedPreferencesService>();
  final _analyticsService = locator<AnalyticsService>();
  final _causesService = locator<CausesService>();

  static const int MAX_RETRY_COUNT = 2;
  int _retryCount = 0;

  StartupState _stateValue = const Loading();

  set _state(StartupState value) {
    _stateValue = value;
    notifyListeners();
  }

  StartupState get state => _stateValue;

  @override
  void initialise() {
    _logger.info('Initialised startup view model');

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    _authenticationService.initSupabase();

    handleStartUpLogic();
  }

  Future handleStartUpLogic() async {
    _logger.info('handleStartUpLogic starting');

    await initServices()
        .onError((error, _) => _handleStartupError(error))
        .then((_) => navigateNext());
  }

  Future initServices() async {
    final sentryTransaction = Sentry.startTransaction(
      'StartupViewModel',
      'handleStartUpLogic',
    );

    final isMobile = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;

    await Future.wait(
      [
        if (isMobile) _dynamicLinkService.handleDynamicLinks(),
        if (isMobile) _pushNotificationService.init(),
        _sharedPreferencesService.init(),
        _apiService.init(),
        _causesService.init(),
        _authenticationService.init(),
      ],
      eagerError: true,
    );

    sentryTransaction.finish();
  }

  Future navigateNext() async {
    if (_authenticationService.isAuthenticated) {
      _logger.info('User is authenticated');

      if (_authenticationService.token != null) {
        _logger.info('Setting token for api service');
        _apiService.setToken(_authenticationService.token!);
      }

      _analyticsService.setUserProperties(
        userId: _authenticationService.userId!,
      );
      return fetchUserAndNavigatePostLogin();
    }

    // TODO Track if device has already finished intro, if so show login page instead
    _logger.info('User is not authenticated');
    _routerService.clearStackAndShow(const IntroViewRoute());
  }

  void _handleStartupError(dynamic error) {
    _logger.severe('Error during startup: $error');
    if (_retryCount < MAX_RETRY_COUNT) {
      _retryCount++;
      _logger.warning('Retrying startup');
      handleStartUpLogic();
    } else {
      _logger.severe('Startup failed after $_retryCount retries');
      // TODO: correct error messages https://github.com/now-u/now-u-app/issues/255
      _state = const Error(message: 'Failed to start app');
    }

    throw error;
  }

  void retryStartup() {
    if (state is Error) {
      _state = const Loading();
      _retryCount = 0;
      handleStartUpLogic();
    }
  }
}
