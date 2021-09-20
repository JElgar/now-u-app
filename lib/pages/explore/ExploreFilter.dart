import 'package:flutter/material.dart';
import 'package:app/assets/components/selectionPill.dart';
import 'package:app/viewmodels/explore_page_view_model.dart';

class ExploreFilterOption<T> {
  /// What is displayed to the user
  final String displayName;

  /// The value posted to the api when this is selected
  final T parameterValue;

  /// Whether the filter is selected
  bool isSelected;

  ExploreFilterOption({this.displayName, this.parameterValue, this.isSelected = false});

  void toggleSelect() {
    isSelected = !isSelected;
  }

  Widget render(ExplorePageViewModel model) {
    return SelectionPill(displayName, isSelected, onClick: () => model.selectFilterOption(this));
  }
} 

class ExploreFilter {
  /// The name of the parameter to be posted to the api
  final String parameterName;

  /// The options that can be selected for this filter
  final List<ExploreFilterOption> options;

  /// Whether multiple filter options can be selected at once
  final bool multi; 

  const ExploreFilter({this.parameterName, this.options, this.multi});
}

