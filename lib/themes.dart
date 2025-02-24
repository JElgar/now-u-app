import 'package:flutter/material.dart';
import 'package:nowu/assets/constants.dart';
import 'package:nowu/ui/common/app_colors.dart';

const Offset tileShadowOffset = Offset(0, 3);
const double tileShadowBlurRadius = 20;
final BorderRadius tileBorderRadius = BorderRadius.circular(8);
const BoxShadow tileBoxShadowLight = BoxShadow(
  color: Color.fromRGBO(0, 45, 96, 0.08),
  offset: tileShadowOffset,
  blurRadius: tileShadowBlurRadius,
);

const double tileElevation = 10;

// TODO This apply doesn't seem to work
final baseTextTheme =
    const TextTheme().apply(displayColor: Colors.black, fontFamily: 'Nunito');

final textTheme = baseTextTheme.merge(
  const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'PPPangramsBold',
      color: Colors.black,
      fontSize: 36,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'PPPangramsBold',
      fontSize: 30,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'PPPangramsSemibold',
      color: Colors.black,
      fontSize: 24,
    ),
    displayMedium: TextStyle(
      fontFamily: 'PPPangramsMedium',
      color: Colors.black,
      fontSize: 18,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'PPPangramsRegular',
      color: Colors.black,
      fontSize: 16,
    ),
    bodySmall: TextStyle(
      fontFamily: 'PPPangramsRegular',
      // TODO Check this color is applied (over the baseTextTheme color)
      color: Color.fromRGBO(119, 119, 119, 1),
      fontSize: 16,
      fontStyle: FontStyle.italic,
    ),
    labelLarge: TextStyle(
      // TODO Check this font family is applied (over the baseTextTheme fontFamily)
      fontFamily: 'PPPangramsMedium',
      color: Colors.black,
    ),
    labelMedium: TextStyle(
      fontFamily: 'PPPangramsRegular',
      fontSize: 14,
      color: Color.fromRGBO(115, 159, 177, 1),
    ),
    labelSmall: TextStyle(
      fontFamily: 'PPPangramsSemibold',
      fontSize: 14,
      letterSpacing: 0.5,
    ),
  ),
);

final primaryTextButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.transparent,
  foregroundColor: CustomColors.brandColor,
  textStyle: textTheme.displayMedium!.copyWith(fontFamily: 'PPPangramsSemibold'),
  padding: const EdgeInsets.symmetric(
    vertical: 12.0,
    horizontal: 16.0,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
  ),
);

final primaryFilledButtonStyle = TextButton.styleFrom(
  backgroundColor: CustomColors.brandColor,
  foregroundColor: Colors.white,
  textStyle: textTheme.displayMedium!.copyWith(fontFamily: 'PPPangramsSemibold'),
  padding: const EdgeInsets.symmetric(
    vertical: 12.0,
    horizontal: 36.0,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
  ),
);

final secondaryFilledButtonStyle = TextButton.styleFrom(
  elevation: 10,
  shadowColor: tileBoxShadowLight.color,
  backgroundColor: Colors.white,
  foregroundColor: CustomColors.brandColor,
).merge(primaryTextButtonStyle);

final regularColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: CustomColors.brandColor,
  // TODO This is does not quite work as white isn't very visible on orange
  onPrimary: Colors.white,
  secondary: const Color.fromRGBO(255, 220, 121, 1),
  onSecondary: Colors.black,
  // TODO What is this really?
  surface: Colors.white,
  onSurface: Colors.black,
  error: const Color.fromRGBO(211, 0, 1, 1),
  // TODO Really?
  onError: Colors.white,
);

final regularTheme = ThemeData(
  scaffoldBackgroundColor: greyLight1,
  primaryColor: CustomColors.brandColor,
  fontFamily: 'PPPangramsRegular',
  colorScheme: regularColorScheme,
  textTheme: textTheme,
  buttonTheme: ButtonThemeData(
    buttonColor: CustomColors.brandColor,
    disabledColor: CustomColors.brandColor.withOpacity(0.5),
    height: 48,
  ),
  textButtonTheme: TextButtonThemeData(style: primaryTextButtonStyle),
  filledButtonTheme: FilledButtonThemeData(style: primaryFilledButtonStyle),
  // TODO Bring back!
  // TODO Fix buttons
  searchBarTheme: SearchBarThemeData(
    surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
    hintStyle: WidgetStatePropertyAll(
      textTheme.bodyLarge!.copyWith(color: Colors.grey),
    ),
    elevation: const WidgetStatePropertyAll(tileElevation),
    shadowColor: WidgetStatePropertyAll(tileBoxShadowLight.color),
  ),
  cardTheme: const CardTheme(
    surfaceTintColor: Colors.transparent,
  ),
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.transparent,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
    border: const OutlineInputBorder(),
    focusedBorder: UnderlineInputBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8.0),
        topRight: Radius.circular(8.0),
      ),
      borderSide: BorderSide(color: CustomColors.brandColor, width: 2.0),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.0),
        topRight: Radius.circular(8.0),
      ),
      borderSide:
          BorderSide(color: Color.fromRGBO(222, 224, 232, 1), width: 2.0),
    ),
    hintStyle: textTheme.labelMedium,
    errorStyle: TextStyle(
      color: regularColorScheme.error,
      fontStyle: FontStyle.italic,
      fontSize: textTheme.bodyMedium?.fontSize,
    ),
  ),
);

final darkTheme = regularTheme.copyWith(
  textTheme:
      textTheme.apply(displayColor: Colors.white, bodyColor: Colors.white),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: CustomColors.brandColor,
    onPrimary: Colors.black,
    secondary: const Color.fromRGBO(255, 220, 121, 1),
    onSecondary: Colors.black,
    surface: CustomColors.accentBlue,
    onSurface: Colors.white,
    error: const Color.fromRGBO(211, 0, 1, 1),
    onError: Colors.white,
  ),
);
