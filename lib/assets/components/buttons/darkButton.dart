import 'package:app/assets/StyleFrom.dart';
import 'package:app/assets/components/customTile.dart';
import 'package:flutter/material.dart';

final double defaultBorderRadius = 8.0;
final double defaultPadding = 14.0;

enum DarkButtonSize { Small, Medium, Large }
enum DarkButtonStyle { Primary, Secondary, Outline }

Map darkButtonStyleStyles = {
  DarkButtonSize.Small: {
    'style': DarkButtonSize.Small,
    'height': 32.0,
    'borderRadius': 8.0,
    'fontSize': 14.0,
    'hPadding': 10.0,
    'vPadding': 8.0,
  },
  DarkButtonSize.Medium: {
    'style': DarkButtonSize.Medium,
    'height': 40.0,
    'borderRadius': 8.0,
    'fontSize': 17.0,
    'hPadding': 16.0,
    'vPadding': 8.0,
  },
  DarkButtonSize.Large: {
    'style': DarkButtonSize.Large,
    'height': 48.0,
    'borderRadius': 8.0,
    'fontSize': 17.0,
    'hPadding': 16.0,
    'vPadding': 8.0,
  },
};

// ignore: must_be_immutable
class DarkButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData rightIcon;
  final IconData leftIcon;
  final DarkButtonSize size;
  final double fontSize;
  final DarkButtonStyle style;

  DarkButton(this.text,
      {this.size = DarkButtonSize.Medium,
      @required this.onPressed,
      this.rightIcon,
      this.leftIcon,
      this.style,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    if (style == DarkButtonStyle.Primary) {
      return PrimaryButton(text,
          onPressed: onPressed,
          rightIcon: rightIcon,
          size: size,
          fontSize: fontSize);
    }
    if (style == DarkButtonStyle.Outline) {
      return OutlineButton(text,
          onPressed: onPressed, size: size, fontSize: fontSize);
    } else if (style == DarkButtonStyle.Secondary) {
      return SecondaryButton(text,
          onPressed: onPressed,
          rightIcon: rightIcon,
          size: size,
          fontSize: fontSize);
    } else {
      return PrimaryButton(text,
          onPressed: onPressed,
          rightIcon: rightIcon,
          size: size,
          fontSize: fontSize);
    }
  }
}

// ignore: must_be_immutable
class SecondaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData rightIcon;
  final DarkButtonSize size;
  final double fontSize;

  SecondaryButton(
    this.text, {
    @required this.onPressed,
    @required this.rightIcon,
    @required this.size,
    @required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTile(
        child: Container(
      color: Colors.white,
      height: darkButtonStyleStyles[size]['height'],
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    darkButtonStyleStyles[size]['borderRadius']),
              ),
            )),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: darkButtonStyleStyles[size]['vPadding'],
            horizontal: darkButtonStyleStyles[size]['hPadding'],
          ),
          child: Text(
            text,
            style: textStyleFrom(
              Theme.of(context).primaryTextTheme.button,
              color: Theme.of(context).buttonColor,
              fontSize: fontSize ?? darkButtonStyleStyles[size]['fontSize'],
            ),
          ),
        ),
      ),
    ));
  }
}

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData rightIcon;
  final DarkButtonSize size;
  final double fontSize;

  PrimaryButton(
    this.text, {
    @required this.onPressed,
    @required this.rightIcon,
    @required this.size,
    @required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: darkButtonStyleStyles[size]['height'],
      elevation: 0,
      color: Theme.of(context).buttonColor,
      disabledColor: colorFrom(
        Theme.of(context).primaryColor,
        opacity: 0.5,
      ),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(darkButtonStyleStyles[size]['borderRadius']),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          rightIcon == null
              ? Container()
              : Container(
                  width: 5,
                ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: darkButtonStyleStyles[size]['vPadding'],
              horizontal: darkButtonStyleStyles[size]['hPadding'],
            ),
            child: Text(
              text,
              style: textStyleFrom(
                Theme.of(context).primaryTextTheme.button,
                color: Colors.white,
                fontSize: fontSize ?? darkButtonStyleStyles[size]['fontSize'],
              ),
            ),
          ),
          rightIcon == null
              ? Container()
              : Icon(
                  rightIcon,
                  size: 25,
                  color: Colors.white,
                ),
        ],
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final DarkButtonSize size;
  final double fontSize;

  OutlineButton(
    this.text, {
    @required this.onPressed,
    @required this.size,
    @required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: darkButtonStyleStyles[size]['height'],
      elevation: 0,
      color: Colors.transparent,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(darkButtonStyleStyles[size]['borderRadius']),
        side: BorderSide(
          color: Colors.white,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: darkButtonStyleStyles[size]['vPadding'],
              horizontal: darkButtonStyleStyles[size]['hPadding'],
            ),
            child: Text(
              text,
              style: textStyleFrom(
                Theme.of(context).primaryTextTheme.button,
                color: Colors.white,
                fontSize: fontSize ?? darkButtonStyleStyles[size]['fontSize'],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
