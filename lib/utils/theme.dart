import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF244e4d), // hijau turquoise utama
      surfaceTint: Color(0xFF0A9E7C),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xFF13B89A),
      onPrimaryContainer: Color(0xffffffff),

      secondary: Color(0xFFffffff), // accent fitur
      onSecondary: Color(0xffffffff),

      secondaryContainer: Color(0xffffffff), // surface fitur
      onSecondaryContainer: Color(0xFF0E5948),

      tertiary: Color(0xff0877A5),
      onTertiary: Color(0xffffffff),

      error: Color(0xffFF4E4E),
      onError: Color(0xffffffff),

      surface: Color(0xffffffff), // background putih terang
      onSurface: Color(0xff1A1D1C),

      onSurfaceVariant: Color(0xff5D6B65),
      outline: Color(0xffC3D6D1),
      outlineVariant: Color(0xffE2EFEA),

      shadow: Color(0xff000000),
      scrim: Color(0xff000000),

      inverseSurface: Color(0xff2A2E2D),
      inversePrimary: Color(0xff34D8B4),

    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,

      primary: Color(0xFF0c1114), // hijau turquoise utama (dark)
      onPrimary: Color(0xff92bebc),
      surfaceTint: Color(0xFF1FAA89),
      primaryContainer: Color(0xFF0E6B5E),
      onPrimaryContainer: Color(0xffffffff),

      secondary: Color.fromARGB(255, 10, 14, 11),
      onSecondary: Color(0xff0A1A17),

      secondaryContainer: Color.fromARGB(255, 6, 7, 10), // card fitur gelap
      onSecondaryContainer: Color(0xffEAFBF4),

      tertiary: Color(0xff83cfff),
      onTertiary: Color(0xff001e2d),

      error: Color(0xffFF4E4E),
      onError: Color(0xffffffff),

      surface: Color(0xff0A1A17), // full dark background
      onSurface: Color(0xffE0E4DC),

      onSurfaceVariant: Color(0xff9EC8BD),
      outline: Color(0xff2E4D46),
      outlineVariant: Color(0xff40493F),

      shadow: Color(0xff000000),
      scrim: Color(0xff000000),

      inverseSurface: Color(0xffE0E4DC),
      inversePrimary: Color(0xff35D3B4),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
