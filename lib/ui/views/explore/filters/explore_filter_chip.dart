import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowu/models/action.dart';
import 'package:nowu/models/time.dart';
import 'package:nowu/services/causes_service.dart';
import 'package:nowu/ui/bottom_sheets/explore_filter/explore_filter_sheet.dart';
import 'package:nowu/ui/views/causes/bloc/causes_bloc.dart';
import 'package:nowu/ui/views/causes/bloc/causes_state.dart';
import 'package:tuple/tuple.dart';

import '../bloc/explore_filter_bloc.dart';
import '../bloc/explore_filter_state.dart';

class ExploreFilterChip extends StatelessWidget {
  final FilterConfig filterConfig;

  const ExploreFilterChip(
    this.filterConfig, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreFilterBloc, ExploreFilterState>(
      builder: (context, state) {
        return FilterChip(
          onSelected: (isSelected) => filterConfig.onSelected(
            context: context,
            state: state,
            filterBloc: context.read<ExploreFilterBloc>(),
            causesBloc: context.read<CausesBloc>(),
            isSelected: isSelected,
          ),
          selectedColor: Theme.of(context).colorScheme.primary,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.23),
          label: Text(
            filterConfig.label,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'PPPangramsSemibold',
            ),
          ),
          selected: filterConfig.isSelected(state),
        );
      },
    );
  }
}

abstract class FilterConfig {
  final String label;

  const FilterConfig({required this.label});

  void onSelected({
    required BuildContext context,
    required ExploreFilterState state,
    required ExploreFilterBloc filterBloc,
    required CausesBloc causesBloc,
    required bool isSelected,
  });

  bool isSelected(ExploreFilterState state);
}

abstract class DialogFilterConfig<T> extends FilterConfig {
  final String dialogHeading;

  const DialogFilterConfig({
    required String chipLabel,
    required this.dialogHeading,
  }) : super(label: chipLabel);

  void onSelected({
    required BuildContext context,
    required ExploreFilterState state,
    required ExploreFilterBloc filterBloc,
    required CausesBloc causesBloc,
    required bool isSelected,
  }) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: filterBloc),
          BlocProvider.value(value: causesBloc),
        ],
        child: BlocBuilder<ExploreFilterBloc, ExploreFilterState>(
          builder: (context, state) {
            return ExploreFilterSheet(
              filterName: dialogHeading,
              options: getOptions(context, state),
              onSelectOption: (option) =>
                  onSelectOption(context, state, option),
            );
          },
        ),
      ),
    );
  }

  bool isSelected(ExploreFilterState state);

  List<ExploreFilterSheetOption<T>> getOptions(
    BuildContext context,
    ExploreFilterState state,
  );

  onSelectOption(
    BuildContext context,
    ExploreFilterState state,
    T option,
  );
}

class CausesFilter extends DialogFilterConfig<int> {
  const CausesFilter() : super(chipLabel: 'Causes', dialogHeading: 'Causes');

  @override
  void onSelectOption(context, state, option) {
    final filterCauseIds = {...state.filterCauseIds};
    if (filterCauseIds.contains(option)) {
      filterCauseIds.remove(option);
    } else {
      filterCauseIds.add(option);
    }
    context.read<ExploreFilterBloc>().updateFilter(
          state.copyWith(
            filterCauseIds: filterCauseIds,
          ),
        );
  }

  @override
  List<ExploreFilterSheetOption<int>> getOptions(context, state) {
    // TODO Get causes from somewhere - maybe we need to add the causes provider as well
    switch (context.read<CausesBloc>().state) {
      case CausesStateLoading():
        // TODO In an ideal world we could show some loading animation here
        return [];
      case CausesStateLoaded(:final causes):
        return causes.map((cause) {
          return ExploreFilterSheetOption(
            title: cause.title,
            value: cause.id,
            isSelected: state.filterCauseIds.contains(cause.id),
          );
        }).toList();
      case CausesStateError():
        // TODO In an ideal world we could show some error here
        return [];
    }
  }

  @override
  bool isSelected(state) {
    return state.filterCauseIds.isNotEmpty;
  }
}

class TimeFilter extends DialogFilterConfig<Tuple2<double, double>> {
  const TimeFilter() : super(chipLabel: 'Time', dialogHeading: 'Times');

  @override
  getOptions(context, state) {
    return timeBrackets.map(
      (timeBracket) {
        final value = Tuple2(timeBracket.minTime, timeBracket.maxTime);
        return ExploreFilterSheetOption(
          title: timeBracket.text,
          value: value,
          isSelected: state.filterTimeBrackets.contains(value),
        );
      },
    ).toList();
  }

  @override
  onSelectOption(context, state, option) {
    final filterTimeBrackets = {...state.filterTimeBrackets};
    if (filterTimeBrackets.contains(option)) {
      filterTimeBrackets.remove(option);
    } else {
      filterTimeBrackets.add(option);
    }
    context.read<ExploreFilterBloc>().updateFilter(
          state.copyWith(
            filterTimeBrackets: filterTimeBrackets,
          ),
        );
  }

  @override
  bool isSelected(state) {
    return state.filterTimeBrackets.isNotEmpty;
  }
}

class ActionTypeFilter extends DialogFilterConfig<ActionType> {
  const ActionTypeFilter()
      : super(chipLabel: 'Type', dialogHeading: 'Action type');

  @override
  getOptions(context, state) {
    print('Getting options: Action type: ${state.filterActionTypes}');
    return actionTypes
        .map(
          (type) => ExploreFilterSheetOption(
            title: type.name,
            value: type,
            isSelected: type.subTypes
                .any((subType) => state.filterActionTypes.contains(subType)),
          ),
        )
        .toList();
  }

  @override
  onSelectOption(context, state, option) {
    final filterActionTypes = {...state.filterActionTypes};

    // TODO This is nonsense, currently we have an enum for the subtypes
    // but only expose the 4 parent types in the app.
    option.subTypes.forEach((subType) {
      if (filterActionTypes.contains(subType)) {
        filterActionTypes.remove(subType);
      } else {
        filterActionTypes.add(subType);
      }
    });
    context.read<ExploreFilterBloc>().updateFilter(
          state.copyWith(
            filterActionTypes: filterActionTypes,
          ),
        );
  }

  @override
  bool isSelected(state) {
    return state.filterActionTypes.isNotEmpty;
  }
}

class CompletedFilter extends FilterConfig {
  const CompletedFilter() : super(label: 'Completed');

  @override
  bool isSelected(state) {
    return state.filterCompleted;
  }

  @override
  void onSelected({
    required BuildContext context,
    required ExploreFilterState state,
    required ExploreFilterBloc filterBloc,
    required CausesBloc causesBloc,
    required bool isSelected,
  }) {
    context.read<ExploreFilterBloc>().updateFilter(
          state.copyWith(
            filterCompleted: !state.filterCompleted,
          ),
        );
  }
}

class RecommendedFilter extends FilterConfig {
  const RecommendedFilter() : super(label: 'Recommended');

  @override
  bool isSelected(state) {
    return state.filterRecommended;
  }

  @override
  void onSelected({
    required BuildContext context,
    required ExploreFilterState state,
    required ExploreFilterBloc filterBloc,
    required CausesBloc causesBloc,
    required bool isSelected,
  }) {
    context.read<ExploreFilterBloc>().updateFilter(
          state.copyWith(
            filterRecommended: !state.filterRecommended,
          ),
        );
  }
}

class NewFilter extends FilterConfig {
  const NewFilter() : super(label: 'New');

  @override
  bool isSelected(state) {
    return state.filterNew;
  }

  @override
  void onSelected({
    required BuildContext context,
    required ExploreFilterState state,
    required ExploreFilterBloc filterBloc,
    required CausesBloc causesBloc,
    required bool isSelected,
  }) {
    context.read<ExploreFilterBloc>().updateFilter(
          state.copyWith(
            filterNew: !state.filterNew,
          ),
        );
  }
}
