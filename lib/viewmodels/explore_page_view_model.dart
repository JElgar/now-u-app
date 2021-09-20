import 'package:app/viewmodels/base_model.dart';
import 'package:app/pages/explore/ExploreSection.dart';
import 'package:app/pages/explore/ExploreFilter.dart';

class ExplorePageViewModel extends BaseModel {
  void selectFilterOption(ExploreFilterOption filterOption) {
    filterOption.toggleSelect();
    notifyListeners();
  }
}
