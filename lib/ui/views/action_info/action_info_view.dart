import 'package:flutter/material.dart' hide Action;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nowu/assets/components/customAppBar.dart';
import 'package:nowu/assets/components/textButton.dart';
import 'package:nowu/assets/icons/customIcons.dart';
import 'package:nowu/locator.dart';
import 'package:nowu/router.dart';
import 'package:nowu/router.gr.dart';
import 'package:nowu/services/causes_service.dart';
import 'package:nowu/themes.dart';
import 'package:nowu/ui/views/action_info/bloc/action_info_bloc.dart';
import 'package:nowu/ui/views/action_info/bloc/action_info_event.dart';
import 'package:nowu/ui/views/action_info/bloc/action_info_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:nowu/ui/views/explore/explore_page_viewmodel.dart';

// TODO Use from constants
final double hPadding = 10;

@RoutePage()
class ActionInfoView extends StatelessWidget {
  // TODO Can we just remove this?
  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>(); (also below)

  final int actionId;

  const ActionInfoView({Key? key, @pathParam required this.actionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActionInfoBloc(
        actionId: actionId,
        causesService: locator<CausesService>(),
      )..fetchAction(),
      child: Scaffold(
        // TODO Fix app bar
        // appBar: customAppBar(
        // 	text: BlocBuilder<ActionInfoBloc, ActionInfoState>(
        // 		builder: (context, state) {
        // 			switch (state) {
        // 				case ActionInfoStateFetchFailure():
        // 				case ActionInfoStateInitial():
        // 					return const Text('Loading');
        // 				case ActionInfoStateSuccess():
        // 				case ActionInfoUpdateFailedEvent():
        // 					return const Text('Loading');
        // 		}
        // 	),
        // 	context: context,
        // ),
        body: BlocBuilder<ActionInfoBloc, ActionInfoState>(
          builder: (context, state) {
            switch (state) {
              case ActionInfoStateInitial():
                return const Center(child: const CircularProgressIndicator());
              case ActionInfoStateFetchFailure():
                return const Center(child: const Text('Error fetching action'));
              case ActionInfoStateSuccess(:final action):
              case ActionInfoStateUpdateFailed(:final action):
                return Stack(
                  children: [
                    ListView(
                      children: [
                        Container(
                          width: double.infinity,
                          color: action.type.secondaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 20,
                            ),
                            child: Text(action.title),
                          ),
                        ),
                        Container(
                          height: action.isCompleted ? null : 10,
                          color: action.type.primaryColor,
                          child: action.isCompleted
                              ? Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      CustomIcons.ic_check,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      'Done',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ],
                                )
                              : Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    action.type.icon,
                                    color: action.type.primaryColor,
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    FontAwesomeIcons.clock,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(action.timeText),
                                ],
                              ),
                              GestureDetector(
                                // TODO This must go to the causes info page
                                // For now this can be the home explore page filtered by a single cause
                                onTap: () => context.router.push(
                                  ExploreRoute(
                                    filterData: ExplorePageFilterData(
                                      filterCauseIds: Set.of([action.cause.id]),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  height: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Text(
                                      'See cause',
                                      // TODO Fix
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Text
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: hPadding,
                            vertical: 0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'What should I do?',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                action.whatDescription,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),

                        // Buttons
                        const SizedBox(height: 20),

                        // First
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              'First',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: FilledButton(
                            child: const Text('Take action'),
                            style: secondaryFilledButtonStyle,
                            onPressed: () {
                              launchLinkExternal(context, action.link);
                            },
                          ),
                        ),

                        !action.isCompleted
                            ?
                            // If not completed show the then button
                            Column(
                                children: [
                                  //Dividor
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 20,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      color: const Color.fromRGBO(
                                        222,
                                        223,
                                        232,
                                        1,
                                      ),
                                      height: 1,
                                    ),
                                  ),

                                  // Then
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        'Then',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: FilledButton(
                                      child: const Text('Mark as done'),
                                      onPressed: () => context
                                          .read<ActionInfoBloc>()
                                          .markActionComplete(),
                                      style: secondaryFilledButtonStyle,
                                    ),
                                  ),
                                ],
                              )
                            : // Otherwise show the youre great thing
                            Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 10,
                                ),
                                child: Container(
                                  color: action.type.secondaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Many small actions have a big impact',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                        const SizedBox(height: 10),
                                        RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            children: [
                                              const TextSpan(
                                                text:
                                                    'Thank you for completing this action and contributing to this important cause!',
                                              ),
                                              // TODO What is happening to this?
                                              // TextSpan(
                                              //     text: _campaign!.title,
                                              //     style: textStyleFrom(
                                              //       Theme.of(context)
                                              //           .textTheme
                                              //           .bodyLarge,
                                              //       color: Theme.of(context)
                                              //           .buttonColor,
                                              //     ),
                                              //     recognizer:
                                              //         TapGestureRecognizer()
                                              //           ..onTap = () {
                                              //             Navigator.of(context)
                                              //                 .pushNamed(
                                              //                     Routes
                                              //                         .campaignInfo,
                                              //                     arguments:
                                              //                         _campaign!
                                              //                             .id);
                                              //           }),
                                              // TextSpan(
                                              //   text: " campaign.",
                                              // ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Icon(
                                          FontAwesomeIcons.calendar,
                                          color: Theme.of(context).primaryColor,
                                          size: 60,
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                        const SizedBox(height: 30),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: hPadding,
                            vertical: 0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Why is this useful?',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                action.whyDescription,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            action.isCompleted
                                ? CustomTextButton(
                                    'Mark as not done',
                                    fontSize: 14,
                                    onClick: () {
                                      context
                                          .read<ActionInfoBloc>()
                                          .clearActionStatus();
                                    },
                                  )
                                : Container(),
                            //TextButton("Hide this action", fontSize: 14,
                            //    onClick: () {
                            //  showDialog(
                            //    context: context,
                            //    barrierDismissible: true,
                            //    builder: (_) =>
                            //        RejectDialogue(_action, viewModel),
                            //  );
                            //}),

                            const SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 15),
                        !action.isCompleted
                            ? Container()
                            : Container(
                                height: 65,
                                color: const Color.fromRGBO(155, 159, 177, 1),
                                child: Center(
                                  child: Text(
                                    'You completed this action',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: action.isCompleted ? 0 : 70,
                        ),
                      ],
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
