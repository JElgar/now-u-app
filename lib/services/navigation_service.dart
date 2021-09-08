import 'package:flutter/material.dart';
import 'package:app/routes.dart';

import 'package:app/locator.dart';
import 'package:app/services/dialog_service.dart';
import 'package:app/services/campaign_service.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:app/assets/components/buttons/darkButton.dart';
import 'package:app/models/Learning.dart';
import 'package:app/models/Action.dart';

const String INTERNAL_PREFIX = "internal:";

const List ID_ROUTES = [
  Routes.campaignInfo,
  Routes.learningTopic,
  Routes.learningSingle,
  Routes.actionInfo
];

class NavigationService {
  final DialogService _dialogService = locator<DialogService>();

  final CampaignService _campaignService = locator<CampaignService>();

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  void goBack() {
    return navigatorKey.currentState.pop();
  }

  bool isInternalLink(String link) {
    return link.startsWith(INTERNAL_PREFIX);
  }

  bool isPDF(String link) {
    return link.endsWith(".pdf");
  }

  bool isInsecureLink(String link) {
    return link.startsWith("http://");
  }

  bool isMailTo(String link) {
    return link.startsWith("mailto:");
  }

  Map getInternalLinkParameters(String url) {
    String link = url.substring(INTERNAL_PREFIX.length);

    if (!link.contains('&')) return null;

    Map parametersMap = {};
    String linkParameters = link.split('&')[1];
    List parameters = linkParameters.split('?');
    for (final param in parameters) {
      List splitParameter = param.split('=');
      String key = splitParameter[0];
      String value = splitParameter[1];
      parametersMap[key] = value;
    }
    return parametersMap;
  }

  getInternalLinkRoute(String url) {
    String link = url.substring(INTERNAL_PREFIX.length);
    if (link.contains('&')) {
      return link.split('&')[0];
    } else {
      return link;
    }
  }

  Future launchLink(
    String url, {
    String title,
    String description,
    String buttonText,
    String closeButtonText,
    Function extraOnConfirmFunction,
    bool isExternal,
  }) async {
    if (isInternalLink(url)) {
      String route = getInternalLinkRoute(url);
      Map parameters = getInternalLinkParameters(url);

      if (ID_ROUTES.contains(route)) {
        int id = int.tryParse(parameters['id']);

        if (route == Routes.campaignInfo || route == Routes.learningSingle) {
          navigateTo(route, arguments: id);
          return;
        }

        if (route == Routes.actionInfo) {
          _campaignService.getAction(id).then((CampaignAction action) {
            navigateTo(route, arguments: action);
          }).catchError((e) {
            _dialogService.showDialog(
                title: "Error", description: "Error navigating to route");
          });
          return;
        }

        if (route == Routes.learningTopic) {
          _campaignService.getLearningTopic(id).then((LearningTopic topic) {
            navigateTo(route, arguments: topic);
          }).catchError((e) {
            _dialogService.showDialog(
                title: "Error", description: "Error navigating to route");
          });
          return;
        }
      }

      navigateTo(route);
    } else if ((isExternal ?? false) || isPDF(url) || isMailTo(url)) {
      launchLinkExternal(
        url,
        title: title,
        description: description,
        buttonText: buttonText,
        closeButtonText: closeButtonText,
        extraOnConfirmFunction: extraOnConfirmFunction,
      );
    } else {
      if (extraOnConfirmFunction != null) extraOnConfirmFunction();
      navigateTo(Routes.webview, arguments: url);
    }
  }

  void launchLinkExternal(
    String url, {
    String title,
    String description,
    String buttonText,
    String closeButtonText,
    Function extraOnConfirmFunction,
  }) async {
    AlertResponse exit = await _dialogService.showDialog(
        title: title ?? "You're about to leave",
        description: description ??
            "This link will take you out of the app. Are you sure you want to go?",
        buttons: [
          CustomDialogButton(
            text: buttonText ?? "Let's go",
            response: true,
          ),
          CustomDialogButton(
            text: closeButtonText ?? "Close",
            response: false,
            style: DarkButtonStyle.Secondary,
          ),
        ]);
    if (exit.response) {
      if (extraOnConfirmFunction != null) {
        extraOnConfirmFunction();
      }
      launch(url);
    }
  }

  void launchPDF() {}
}
