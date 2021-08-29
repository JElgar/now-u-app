import 'package:flutter/material.dart';

import 'package:app/assets/components/buttons/darkButton.dart';
import 'package:app/assets/StyleFrom.dart';
import 'package:app/routes.dart';

class ViewCampaigns extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Center(
            child: Text(
              "Join campaigns to see more actions!",
              textAlign: TextAlign.center,
              style: textStyleFrom(
                Theme.of(context).primaryTextTheme.headline4,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        DarkButton("View campaigns", onPressed: () {
          Navigator.of(context).pushNamed(Routes.campaign);
        })
      ],
    );
  }
}
