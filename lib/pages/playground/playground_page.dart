import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/assets/components/causeTile.dart';
import 'package:app/assets/icons/customIcons.dart';
import 'package:app/models/Cause.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlaygroundView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                height: MediaQuery.of(context).size.height,
                color: Color(0XFFF3F4F8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CauseTile(
                        cause: Cause(name: 'Environment'),
                        causeIcon: FontAwesomeIcons.leaf,
                        isSelected: false),
                    CauseTile(
                        cause: Cause(name: 'Health & Wellbeing'),
                        causeIcon: FontAwesomeIcons.heart,
                        isSelected: true),
                  ],
                ))));
  }
}
