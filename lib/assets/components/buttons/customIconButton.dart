import 'package:flutter/material.dart';
import 'package:app/assets/StyleFrom.dart';

final double defaultBorderRadius = 8.0;
final double defaultPadding = 14.0;

enum ButtonSize { Small, Medium, Large }
enum ButtonStyle { Primary, Secondary, Outline }

Map buttonStyleStyles = {
  ButtonSize.Small: {
    'style': ButtonSize.Small,
    'height': 32.0,
    'borderRadius': 8.0,
    'fontSize': 14.0,
    'hPadding': 8,
    'vPadding': 8,
  },
  ButtonSize.Medium: {
    'style': ButtonSize.Medium,
    'height': 40.0,
    'borderRadius': 8.0,
    'fontSize': 17.0,
    'hPadding': 16.0,
    'vPadding': 8.0,
  },
  ButtonSize.Large: {
    'style': ButtonSize.Large,
    'height': 48.0,
    'borderRadius': 8.0,
    'fontSize': 17.0,
    'hPadding': 16.0,
    'vPadding': 8.0,
  },
};

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final ButtonSize size;
  final Color backgroundColor;
  final Color iconColor;
  final bool isCircularButton;

  CustomIconButton({
    @required this.onPressed,
    @required this.icon,
    this.iconColor,
    @required this.size,
    @required this.isCircularButton,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: buttonStyleStyles[size]['height'],
      elevation: 0,
      color: this.backgroundColor ?? Theme.of(context).primaryColor,
      disabledColor: colorFrom(
        Theme.of(context).primaryColor,
        opacity: 0.5,
      ),
      onPressed: onPressed,
      shape: isCircularButton
          ? CircleBorder()
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  buttonStyleStyles[size]['borderRadius']),
            ),
      padding: isCircularButton
          ? EdgeInsets.all(0)
          : EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
      child: Icon(
        icon,
        size: isCircularButton ? 15 : 25,
        color: iconColor ?? Colors.white,
      ),
    );
  }
}
