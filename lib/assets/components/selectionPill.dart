import 'package:app/assets/StyleFrom.dart';
import 'package:app/assets/components/customTile.dart';
import 'package:flutter/material.dart';


class SelectionPill extends StatelessWidget {
  /// The text to display on the pill
  final String text;

  /// The border radius of the pill 
  final double borderRadius;
  /// The font size of the text on the pill
  final double fontSize;
 
  /// Whether the pill is selected or not
  final bool isSelected;
  /// What to do when the pill is clicked on.
  /// this should define selection behaviour
  final Function onClick;

  SelectionPill(
    this.text,
    this.isSelected, {
    this.borderRadius,
    this.fontSize = 20,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onClick != null ? onClick : () => {},
        child: Padding(
            padding: EdgeInsets.only(left: 12, bottom: 10),
            child: Container(
              decoration: isSelected
                  ? BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius != null
                          ? BorderRadius.all(Radius.circular(borderRadius))
                          : tileBorderRadius(),
                    )
                  : BoxDecoration(
                      color: Color.fromRGBO(222, 224, 232, 1),
                      borderRadius: borderRadius != null
                          ? BorderRadius.all(Radius.circular(borderRadius))
                          : tileBorderRadius(),
                    ),
              child: Center(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: fontSize / 2, vertical: fontSize / 4),
                child: Text(
                  text,
                  style: textStyleFrom(
                    Theme.of(context).primaryTextTheme.bodyText1,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Color.fromRGBO(55, 58, 74, 1),
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }
}
