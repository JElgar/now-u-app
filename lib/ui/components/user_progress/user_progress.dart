import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowu/locator.dart';
import 'package:nowu/services/causes_service.dart';

import 'bloc/user_progress_state.dart';
import 'bloc/user_progress_bloc.dart';

// TODO Add state for when there is no user
class ProgressTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProgressBloc(causesService: locator<CausesService>())
        ..fetchUserState(),
      child: BlocBuilder<UserProgressBloc, UserProgressState>(
        builder: (context, state) {
          switch (state) {
            case Loaded(:final userInfo):
              return _ProgressTile(
                campaignsScore: userInfo.completedCampaignIds.length,
                actionsScore: userInfo.completedActionIds.length,
                learningsScore: userInfo.completedLearningResourceIds.length,
              );
            case Loading():
            case Error():
            case NoUser():
              return Container();
          }
        },
      ),
    );
  }
}

class _ProgressTile extends StatelessWidget {
  final int campaignsScore;
  final int actionsScore;
  final int learningsScore;

  _ProgressTile({
    required this.campaignsScore,
    required this.actionsScore,
    required this.learningsScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      height: 200,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Text(
                'My Progress',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // TODO: Make a builder for 3 ProgressCircles
                ProgressCircle(
                  progressTitle: 'Campaigns',
                  progressScore: campaignsScore,
                ),
                ProgressCircle(
                  progressTitle: 'Actions',
                  progressScore: actionsScore,
                ),
                ProgressCircle(
                  progressTitle: 'Learnings',
                  progressScore: learningsScore,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressCircle extends StatelessWidget {
  final String progressTitle;
  final int progressScore;

  ProgressCircle({required this.progressTitle, required this.progressScore});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(width: 4, color: const Color(0XFFE6F0DD)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 7), // changes position of shadow
              ),
            ],
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Text(
            progressScore.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          progressTitle,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
