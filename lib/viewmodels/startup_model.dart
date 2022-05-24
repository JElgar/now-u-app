//import 'package:app/constants/route_names.dart';
import 'package:app/locator.dart';
import 'package:app/routes.dart';
import 'package:app/services/auth.dart';
import 'package:app/services/dynamicLinks.dart';
import 'package:app/services/navigation_service.dart';
import 'package:app/services/pushNotifications.dart';
import 'package:app/services/remote_config_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:app/viewmodels/base_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class StartUpViewModel extends BaseModel {
  final AuthenticationService? _authenticationService =
      locator<AuthenticationService>();
  final NavigationService? _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    registerFirebaseServicesToLocator();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    final DynamicLinkService _dynamicLinkService =
        locator<DynamicLinkService>();
    await _dynamicLinkService.handleDynamicLinks();

    // Register for push notifications
    final PushNotificationService _pushNotificationService =
        locator<PushNotificationService>();
    await _pushNotificationService.init();

    final RemoteConfigService _remoteConfigService =
        locator<RemoteConfigService>();
    await _remoteConfigService.init();

    var hasLoggedInUser = await _authenticationService!.isUserLoggedIn();

    if (hasLoggedInUser) {
      _navigationService!.navigateTo(Routes.home);
    } else {
      _navigationService!.navigateTo(Routes.intro);
    }
  }
}
