import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowu/locator.dart';
import 'package:nowu/services/causes_service.dart';
import 'package:nowu/ui/components/user_progress/bloc/user_progress_bloc.dart';
import 'package:nowu/ui/components/user_progress/bloc/user_progress_state.dart';
import 'package:nowu/ui/views/causes_selection/bloc/causes_selection_bloc.dart';
import 'package:nowu/ui/views/causes_selection/bloc/causes_selection_state.dart';
import 'package:nowu/ui/views/causes_selection/components/causeTileGrid.dart';

import '../../../../generated/l10n.dart';

@RoutePage()
class ChangeSelectCausesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        Set<int> getInitialSelectedCausesIds() {
          // NOTE We don't want to use a bloc builder here as if the state changes we don't want to
          // reload and update the users selection which they are working on.
          switch (context.read<UserProgressBloc>().state) {
            case UserProgressStateLoading():
            case UserProgressStateError():
            case UserProgressStateNoUser():
              return {};
            case UserProgressStateLoaded(:final userInfo):
              return userInfo.selectedCausesIds;
          }
        }

        return CausesSelectionBloc(
          initialSelectedCausesIds: getInitialSelectedCausesIds(),
          causesService: locator<CausesService>(),
        );
      },
      child: BlocListener<CausesSelectionBloc, CausesSelectionState>(
        listener: (context, state) {
          if (state.submissionState
              is CausesSelectionSubmissionStateSubmitted) {
            context.router.maybePop();
          }
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => context.router.maybePop(),
                        label: const Text('More'),
                        icon: const Icon(Icons.chevron_left),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Causes',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          S.of(context).changeSelectCausesSelectCausesLabel,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const CauseTileGrid(),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child:
                        BlocBuilder<CausesSelectionBloc, CausesSelectionState>(
                      builder: (context, causesSelectionState) {
                        return ElevatedButton(
                          child: Text(
                            S.of(context).actionSave,
                          ),
                          // TODO Add loading button when submission state is loading!!!
                          // TODO Disable button when loading
                          // TODO Show error state when errored!! and make sure handled correctly
                          onPressed: causesSelectionState
                                  .selectedCausesIds.isNotEmpty
                              ? () {
                                  context
                                      .read<CausesSelectionBloc>()
                                      .selectCauses(
                                        causesSelectionState.selectedCausesIds,
                                      );
                                }
                              : null,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
