import 'package:app/routes.dart';
import 'package:app/viewmodels/base_model.dart';
import 'package:app/models/Cause.dart';
import "dart:async";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app/services/navigation_service.dart';
import 'package:app/locator.dart';

class CausesViewModel extends BaseModel {
  List<Cause> _causesList;
  List<Cause> get causesList => _causesList;

  List<bool> _causesSelectedList = [false, false, false, false, false, false];
  List<bool> get causesSelectedList => _causesSelectedList;

  bool _isButtonDisabled = true;
  bool get isButtonDisabled => _isButtonDisabled;

  final NavigationService _navigationService = locator<NavigationService>();

  Future fetchCauses() async {
    await Future.delayed(const Duration(seconds: 5));
    _causesList = [
      Cause(name: 'Environment'),
      Cause(name: 'Health & Wellbeing'),
      Cause(name: 'Equality & Human-Rights'),
      Cause(name: 'Education & Citizenship'),
      Cause(name: 'Economic Opportunity'),
      Cause(name: 'Safe Homes & Community')
    ];
    notifyListeners();
  }

  void getIsButtonDisabled() {
    _isButtonDisabled = true;
    for (int countIndex = 0; countIndex <= 5; countIndex++) {
      if (_causesSelectedList[countIndex] == true) {
        _isButtonDisabled = false;
      }
    }
  }

  void toggleSelection({int causeIndex}) {
    _causesSelectedList[causeIndex] = !_causesSelectedList[causeIndex];
    getIsButtonDisabled();
    notifyListeners();
  }

  void goHome() async {
    _navigationService.navigateTo(Routes.home);
  }
}
