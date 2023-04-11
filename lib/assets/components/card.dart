import 'package:nowu/assets/constants.dart';
import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  final Widget child;

  BaseCard(this.child);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: tileBorderRadius),
      clipBehavior: Clip.antiAlias,
      elevation: tileElevation,
      shadowColor: tileBoxShadowLight.color,
      child: child,
    );
  }
}
