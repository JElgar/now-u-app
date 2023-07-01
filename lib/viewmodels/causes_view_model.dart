import 'package:nowu/routes.dart';
import 'package:nowu/viewmodels/base_model.dart';
import 'package:nowu/models/Cause.dart';
import "dart:async";
import 'package:nowu/services/navigation_service.dart';
import 'package:nowu/services/causes_service.dart';
import 'package:nowu/locator.dart';
import 'package:nowu/services/dialog_service.dart';

class CausesViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final CausesService _causesService = locator<CausesService>();

  Map<ListCause, bool> _causes = {};

  List<ListCause> get causesList => _causes.keys.toList();
  bool get areCausesDisabled => !_causes.values.toList().any((value) => value);

  Future fetchCauses() async {
    setBusy(true);

    List<ListCause> causesList = await _causesService.getCauses();
    _causes = {for (ListCause cause in causesList) cause: cause.isSelected};

    setBusy(false);
    notifyListeners();

    print(_causes);
  }

  bool isCauseSelected(ListCause cause) {
    return _causes[cause] ?? false;
  }

  void toggleSelection({required ListCause listCause}) {
    bool isCauseSelected = _causes[listCause] ?? false;
    _causes[listCause] = !isCauseSelected;
    print("Cause selected");
    print(areCausesDisabled);
    notifyListeners();
  }

  Future getCausePopup(
      {required ListCause listCause, required int causeIndex}) async {
    var dialogResult =
        await _dialogService.showDialog(CauseDialog(causesList[causeIndex]));
    if (dialogResult.response) {
      if (_causes[listCause] == false) {
        toggleSelection(listCause: listCause);
      }
    }
  }

  Future<void> selectCauses() async {
    List<ListCause> selectedCauses =
        causesList.where((cause) => isCauseSelected(cause)).toList();
    return await _causesService.selectCauses(selectedCauses);
  }
}

class SelectCausesViewModel extends CausesViewModel {
  Future<void> selectCauses() async {
    await super.selectCauses();
    _navigationService.navigateTo(Routes.home, clearHistory: true);
  }
}

class ChangeCausesViewModel extends CausesViewModel {
  Future<void> selectCauses() async {
    await super.selectCauses();
    _navigationService.navigateTo(Routes.home);
  }

  void goToPreviousPage() {
    _navigationService.goBack();
  }
}
