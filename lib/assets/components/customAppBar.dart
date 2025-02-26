import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

AppBar customAppBar({
  required String text,
  required BuildContext context,
  String? backButtonText,
}) {
  return AppBar(
    //leading: SizedBox(width: 0),
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    centerTitle: true,
    elevation: 0,
    bottom: PreferredSize(
      preferredSize: const Size(0, 30),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, bottom: 5),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    ),
    title: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: TextButton.icon(
                icon: Icon(
                  Icons.chevron_left,
                  size: 25,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  backButtonText ?? 'Back',
                ),
                onPressed: () {
                  context.router.maybePop();
                },
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
