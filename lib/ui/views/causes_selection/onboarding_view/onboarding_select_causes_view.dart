import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowu/locator.dart';
import 'package:nowu/router.gr.dart';
import 'package:nowu/services/causes_service.dart';
import 'package:nowu/ui/views/causes_selection/bloc/causes_selection_bloc.dart';
import 'package:nowu/ui/views/causes_selection/bloc/causes_selection_state.dart';
import 'package:nowu/ui/views/causes_selection/components/causeTileGrid.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class OnboardingSelectCausesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CausesSelectionBloc(
        initialSelectedCausesIds: Set(),
        causesService: locator<CausesService>(),
      ),
      child: BlocListener<CausesSelectionBloc, CausesSelectionState>(
        listener: (context, state) {
          if (state.submissionState
              is CausesSelectionSubmissionStateSubmitted) {
            context.router.replaceAll([
              TabsRoute(children: [const HomeRoute()]),
            ]);
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.43,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0XFF011A43), Color(0XFF012B93)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    'Welcome to now-u',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'PPPangramsBold',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(flex: 3, child: SizedBox()),
                              ],
                            ),
                            Text(
                              'Take action and select the causes most important to you',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 10,
                      child: const CauseTileGrid(),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: BlocBuilder<CausesSelectionBloc,
                            CausesSelectionState>(
                          builder: (context, causesSelectionState) {
                            // TODO Add loading button when submission state is loading!!!
                            // TODO Disable button when loading
                            // TODO Show error state when errored!! and make sure handled correctly
                            return ElevatedButton(
                              child: const Text('Get started'),
                              onPressed: causesSelectionState
                                      .selectedCausesIds.isNotEmpty
                                  ? () {
                                      context
                                          .read<CausesSelectionBloc>()
                                          .selectCauses(
                                            causesSelectionState
                                                .selectedCausesIds,
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
            ],
          ),
        ),
      ),
    );
  }
}
