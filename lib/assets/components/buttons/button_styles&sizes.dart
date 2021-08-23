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
