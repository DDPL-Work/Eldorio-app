import 'package:flutter/material.dart';

class ThemeColors {
  static const int _primary = 0xFF0E2F5A;
  static const int _r = 14;
  static const int _g = 47;
  static const int _b = 90;

  static const int _secondary = 0xFFF2A01F;
  static const int _sr = 242;
  static const int _sg = 160;
  static const int _sb = 31;

  static const Map<int, Color> _color = {
    50: Color.fromRGBO(_r, _g, _b, .1),
    100: Color.fromRGBO(_r, _g, _b, .2),
    200: Color.fromRGBO(_r, _g, _b, .3),
    300: Color.fromRGBO(_r, _g, _b, .4),
    400: Color.fromRGBO(_r, _g, _b, .5),
    500: Color.fromRGBO(_r, _g, _b, .6),
    600: Color.fromRGBO(_r, _g, _b, .7),
    700: Color.fromRGBO(_r, _g, _b, .8),
    800: Color.fromRGBO(_r, _g, _b, .9),
    900: Color.fromRGBO(_r, _g, _b, 1),
  };

  static const Map<int, Color> _secondaryColor = {
    50: Color.fromRGBO(_sr, _sg, _sb, .1),
    100: Color.fromRGBO(_sr, _sg, _sb, .2),
    200: Color.fromRGBO(_sr, _sg, _sb, .3),
    300: Color.fromRGBO(_sr, _sg, _sb, .4),
    400: Color.fromRGBO(_sr, _sg, _sb, .5),
    500: Color.fromRGBO(_sr, _sg, _sb, .6),
    600: Color.fromRGBO(_sr, _sg, _sb, .7),
    700: Color.fromRGBO(_sr, _sg, _sb, .8),
    800: Color.fromRGBO(_sr, _sg, _sb, .9),
    900: Color.fromRGBO(_sr, _sg, _sb, 1),
  };

  static const Color brandNavy      = Color(0xFF0E2F5A);
  // static const Color brandNavyDeep  = Color(0xFF0A2342);
  static const Color brandNavySoft  = Color(0xFF1B4F8E);
  // static const Color brandNavyMuted = Color(0xFFC3D0E3);
  // static const Color accentOrange   = Color(0xFFF2A01F);
  // static const Color accentOrangeDk = Color(0xFFE68A0A);
  // static const Color accentInk      = Color(0xFF0A2342);

  // Canonical Reference Theme Tokens (from Staff-app.html)
  // static const Color appBackgroundDeep = Color(0xFF071220); // main staff app root background
  static const Color appBackground     = Color(0xFF0B1524); // --bg
  static const Color cardSurface        = Color(0xFF102038); // staff card & list item background
  static const Color surface           = Color(0xFF12203A); // --surface
  static const Color surface2          = Color(0xFF1A2C4A); // --surface-2
  static const Color cardBorder         = Color(0xFF1E3558); // card outline border
  static const Color lineBorder         = Color(0xFF27395A); // --line / input border
  static const Color inputBg            = Color(0xFF091424); // input field background
  static const Color brandBlue          = Color(0xFF2C5EA3); // --brand-bg
  static const Color brandBlueLight     = Color(0xFF9EC2F0); // --brand-fg
  static const Color goldenAmber        = Color(0xFFF2A01F); // --accent
  static const Color goldenAmberDark    = Color(0xFFE68A0A);
  static const Color goldenAmberLight   = Color(0xFFF5C46F);
  static const Color goldenAmberBg      = Color(0xFF3A2A0C); // --warn-bg
  // static const Color skinTone           = Color(0xFFFDE68A); // staff avatar badge
  // static const Color skinToneDark       = Color(0xFFE7C27F);
  static const Color textLight          = Color(0xFFE8EEF7); // --fg
  static const Color textMuted          = Color(0xFFA6B3C7); // --muted
  static const Color textFaint          = Color(0xFFC3D0E3); // --nav-muted
  static const Color textWhite          = Colors.white;
  static const Color shadowColorDark    = Color(0x33000000);
  static const Color glowAmber          = Color(0x33F2A01F);
  // static const Color glowBlue           = Color(0x289EC2F0);
  static const Color successGreen       = Color(0xFF78D6A2); // --ok
  static const Color successGreenBg     = Color(0xFF123826); // --ok-bg
  static const Color errorRedColor      = Color(0xFFF2A0A0); // --bad
  static const Color errorRedBg         = Color(0xFF3E1717); // --bad-bg
  static const Color infoBlueBg         = Color(0xFF1A2C4A); // --info-bg
  static const Color infoBlueFg         = Color(0xFF9EC2F0); // --info-fg
  // static const Color textSlateMuted     = Color(0xFF8B9EB7); // slate muted text
  static const Color textSoftBlue       = Color(0xFFD4E0F0); // soft blue-tinted white
  // static const Color brandBlueDark      = Color(0xFF265A96); // brand gradient dark
  // static const Color trackButtonBg      = Color(0x33122B4D); // track button background
  // static const Color whiteBorder25      = Color(0x59FFFFFF); // 35% translucent white border
  // static const Color radialGlowAmber    = Color(0x55F2A01F); // radial amber glow
  static const Color sceneShadow        = Color(0x59071A33); // hero scene shadow
  static const Color sceneDarkNavy      = Color(0xFF071A33);
  // static const Color glowAmberCard      = Color(0x1FF2A01F); // 12% translucent amber glow
  // static const Color stepProgressTrack  = Color(0x33CBD5E1); // step progress indicator bar track
  static const Color textPlaceholder    = Color(0xFF566275); // input hint and secondary muted text
  // static const Color chipSelectedBg     = Color(0xFF0E2F5A); // chip selected navy background
  // static const Color infoBoxBg          = Color(0xFF14233A); // document info notice box
  // static const Color successGreenBorder = Color(0xFF16A34A); // uploaded border & approved status dot
  // static const Color statusSkyBlue      = Color(0xFF0284C7); // changes requested timeline dot
  // static const Color statusRed          = Color(0xFFDC2626); // rejected timeline dot
  // static const Color whiteBorder40      = Color(0x66FFFFFF); // 40% translucent white border
  static const Color deepNavy           = Color(0xFF0A2342); // deep navy ink
  static const Color transparent        = Colors.transparent;
  static const Color whatsAppGreen      = Color(0xFF178F50); // whatsapp button green
  static const Color dutyGreen          = Color(0xFF4ADE80); // on duty active green switch
  // static const Color dutyRingAura       = Color(0x594ADE80); // on duty avatar green halo
  // static const Color glassCardBg        = Color(0x5CFFFFFF); // translucent metric card bg
  // static const Color glassCardBorder    = Color(0x1FFFFFFF); // translucent metric card border
  // static const Color badgeStaffAssignedBg = Color(0xFF1A2C4A); // staff assigned badge bg
  // static const Color badgeStaffAssignedFg = Color(0xFF9EC2F0); // staff assigned badge text
  // static const Color signOutBorder      = Color(0x4DF2A0A0); // sign out button border

  // static Color get primary2 => const Color(0xFF12203A);

  static Color get black => Colors.white;

  static Color get white => const Color(0xFF12203A);
  // static const Color grey = Colors.grey;

  // static const Color onlyWhite    = Colors.white;
  // static const Color eldoriaNavy  = Color(0xFF1B4F8E);

  // static const Color oldLatter        = brandNavy;
  // static const Color oldLatterLight   = Color(0xFF1B4F8E);
  // static const Color oldLatterLight3  = Color(0xFF2C5EA3);
  static const Color oldLatterLight4  = Color(0xFFE4ECF7);
  // static const Color oldLatterLight5  = Color(0xFF0A2342);

  static Color get blue => const Color(0xFF9EC2F0);
  static const Color lightBlue = Color(0xFF62B6FF);

  static Color get whiteBlue => const Color(0xFF1A2C4A);

  // static Color get offWhite => const Color(0xFF0B1524);

  // static Color get appBarGradientEnd2 => const Color(0xFF12203A);

  static Color get appBar => const Color(0xFF07101E);

  // static Color get drawerColor => const Color(0xFF12203A);

  // static Color get backgroundColor => const Color(0xFF0B1524);

  static const MaterialColor primaryColor = MaterialColor(_primary, _color);
  static const MaterialColor colorSecondary =
  MaterialColor(_secondary, _secondaryColor);

  // static const Color accentColor = Color(0xFFF2A01F);

  static Color get defaultTextColor => const Color(0xFFE8EEF7);

  static Color get textPrimaryColor => const Color(0xFFA6B3C7);

  static Color get shimmerBaseColor => const Color(0xFF27395A);

  static Color get shimmerHighlightColor => const Color(0xFF1A2C4A);

  static Color get greyColor => const Color(0xFFA6B3C7);

  // static Color verifiedColor = const Color(0xFF78D6A2);
  // static Color unVerifiedColor = const Color(0xFFF5C46F);
  // static Color till = const Color(0xFF178F50);

  // static const Color purple = Color(0xFF2C5EA3); // brand blue
  static const Color transparentColor = Colors.transparent;

  static Color get appBarGradientStart => const Color(0xFF07101E);

  static Color get appBarGradientEnd => const Color(0xFF0B1524);

  // static const Color appBarTitle        = Colors.white;
  // static const Color appBarSubtitle     = Color(0xB3FFFFFF);
  // static const Color appBarIconActive   = Colors.white;
  // static const Color appBarIconDisabled = Color(0x4DFFFFFF);

  // static Color get topBarBg => const Color(0xFF12203A);

  // static Color get topBarBorder => const Color(0xFF27395A);
  // static const Color topBarShadow = Color(0x14000000);

  // static Color get topBarText => const Color(0xFFE8EEF7);

  // static Color get topBarTextFaint => const Color(0xFFA6B3C7);

  // static Color get resolutionChipBg => const Color(0xFF1A2C4A);

  // static Color get resolutionChipBorder => const Color(0xFF2C5EA3);

  // static Color get resolutionChipIcon => Colors.white;

  // static Color get resolutionChipText => Colors.white;

  // static Color get chartCircleFill => const Color(0xFF12203A);

  // static Color get chartGradientInner => const Color(0xFF1A2C4A);

  // static Color get chartGrid => Colors.white10;
  // static const Color chartOuterRing = Color(0xFF0E2F5A);

  // static Color get chartAxis => Colors.white30;

  // static Color get chartRingLabel => Colors.white54;

  // static Color get chartAngleLabel => Colors.white70;
  // static const Color chartMarkedBorder = Color(0xD9FFFFFF);

  // static const Color sideButtonGradientStart = Color(0xFF0A2342);
  // static const Color sideButtonGradientEnd   = Color(0xFF1B4F8E);
  // static const Color sideButtonShadow        = Color(0x590A2342);
  // static const Color sideButtonIcon          = Colors.white;

  // static Color get bottomBarBg => const Color(0xFF12203A);

  // static Color get bottomBarBorder => const Color(0xFF27395A);
  // static const Color bottomBarShadow = Color(0x0F000000);

  // static Color get outlinedBtnBorder => const Color(0xFF2C5EA3);

  // static Color get outlinedBtnIcon => const Color(0xFF9EC2F0);

  // static Color get outlinedBtnText => const Color(0xFF9EC2F0);

  // static const Color filledBtnGradientStart = Color(0xFFF2A01F);
  // static const Color filledBtnGradientEnd   = Color(0xFFE68A0A);
  // static const Color filledBtnShadow        = Color(0x73F2A01F);
  // static const Color filledBtnContent       = Color(0xFF0A2342);

  // static Color get snackBg => const Color(0xFF1A2C4A);
  // static const Color snackText        = Colors.white;
  static const Color snackSuccessIcon = Color(0xFF78D6A2);

  // static LinearGradient get primaryGradient => const LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [Color(0xFF07101E), Color(0xFF12203A)],
  //   tileMode: TileMode.clamp,
  // );

  // static LinearGradient get gradient2 => const LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [Color(0xFF12203A), Color(0xFF0B1524)],
  // );

  // static LinearGradient get gradient3 => LinearGradient(
  //   colors: [appBarGradientStart, appBarGradientEnd],
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  // );

  // static LinearGradient get accentGradient => const LinearGradient(
  //   colors: [Color(0xFFF8B544), Color(0xFFF2A01F), Color(0xFFE68A0A)],
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  // );

  // static ThemeData get lightTheme => darkTheme;

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: false,
    primarySwatch: primaryColor,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF0B1524),
    brightness: Brightness.dark,
    fontFamily: 'Figtree',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF07101E),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF12203A),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFA6B3C7)),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      bodyLarge: TextStyle(color: Color(0xFFE8EEF7)),
      bodyMedium: TextStyle(color: Color(0xFFA6B3C7)),
    ),
    dividerColor: const Color(0xFF27395A),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF2C5EA3),
      secondary: Color(0xFFF2A01F),
      surface: Color(0xFF12203A),
      onSurface: Color(0xFFE8EEF7),
    ),
  );


  static const Color grey300 = Color(0xFFDCE3EC);
  // static const Color grey400 = Color(0xFFB7C1D1);
  // static const Color grey700 = Color(0xFF566275);
  // static const Color grey800 = Color(0xFF3A4557);

  // static const Color black45 = Color(0x73000000);
  // static const Color black54 = Color(0x8A000000);
  // static const Color white70 = Color(0xB3FFFFFF);


  static const Color danger500    = Color(0xFFA12B2B);
  // static const Color danger700    = Color(0xFF7F1D1D);
  // static const Color dangerBg     = Color(0xFFFBE7E7);
  // static const Color dangerBorder = Color(0xFFF2A0A0);
  static const Color errorRed     = Color(0xFFDC2626);
  static const Color red          = Color(0xFFF44336);

  static const Color success500 = Color(0xFF1E6B42);
  // static const Color success600 = Color(0xFF185C39);
  // static const Color success700 = Color(0xFF134A2E);
  // static const Color successBg  = Color(0xFFE3F4EA);
  // static const Color successBg2 = Color(0xFFD1EEDC);


  // static const Color warning500  = Color(0xFF8A5000);
  // static const Color warning600  = Color(0xFFB45309);
  // static const Color warning700  = Color(0xFF92400E);
  // static const Color warningText = Color(0xFF92400E);
  static const Color infoYellow  = Color(0xFFF2A01F);


  // static const Color info500  = Color(0xFF0E2F5A);
  // static const Color infoBg   = Color(0xFFE4ECF7);
  // static const Color linkBlue = Color(0xFF1B4F8E);

  // static const Color purple500 = Color(0xFF2C5EA3);
  // static const Color purple700 = Color(0xFF1B4F8E);
  // static const Color purpleBg  = Color(0xFFE4ECF7);

  // static const Color whatsappGreen = Color(0xFF128C4A);
  // static const Color whatsappGreenDark = Color(0xFF178F50);
  // static const Color linkedinBlue  = Color(0xFF0A66C2);
  // static const Color googleBlue    = Color(0xFF4285F4);
  // static const Color googleRed     = Color(0xFFEA4335);
  // static const Color razorpayBlue  = Color(0xFF2D80F2);
  // static const Color swiggyOrange  = Color(0xFFF2A01F);
  // static const Color meeshoPurple  = Color(0xFF2C5EA3);
  // static const Color olaGreen      = Color(0xFF128C4A);
  // static const Color credBlack     = Color(0xFF0A2342);
  // static const Color phonepePurple = Color(0xFF2C5EA3);
  // static const Color recruiterTeal = Color(0xFF128C4A);

  static Color get darkSurface => const Color(0xFF12203A);
  // static Color get darkCard    => const Color(0xFF1A2C4A);

  static Color get softSurface => const Color(0xFF1A2C4A);

  // static Color get greyBackground => const Color(0xFF0B1524);

  // static Color get inputFillLight     => const Color(0xFF091424);
  // static Color get disabledBgLight    => const Color(0xFF12203A);
  // static Color get disabledFillLight  => const Color(0xFF12203A);
  // static Color get disabledFgLight    => const Color(0xFF64748B);
  static Color get disabledFgDark     => const Color(0xFF64748B);
  // static Color get borderLight        => const Color(0xFF27395A);
  // static Color get indigoAccent       => const Color(0xFF2C5EA3);
  // static Color get hintDark           => const Color(0xFFA6B3C7);
  // static Color get lightTextMuted     => const Color(0xFFA6B3C7);
  // static Color get textLightAlt       => const Color(0xFFE8EEF7);
  // static Color get textDark           => const Color(0xFFE8EEF7);

  static const Color statusRequestedBg  = Color(0xFF3A2A0C);
  static const Color statusRequestedFg  = Color(0xFFF5C46F);
  static const Color statusConfirmedBg  = Color(0xFF1A2C4A);
  static const Color statusConfirmedFg  = Color(0xFF9EC2F0);
  static const Color statusAssignedBg   = Color(0xFF1A2C4A);
  static const Color statusAssignedFg   = Color(0xFF9EC2F0);
  static const Color statusOnWayBg      = Color(0xFF3A2A0C);
  static const Color statusOnWayFg      = Color(0xFFF5C46F);
  static const Color statusProgressBg   = Color(0xFF3A2A0C);
  static const Color statusProgressFg   = Color(0xFFF5C46F);
  static const Color statusCompletedBg  = Color(0xFF123826);
  static const Color statusCompletedFg  = Color(0xFF78D6A2);
  static const Color statusCancelledBg  = Color(0xFF3E1717);
  static const Color statusCancelledFg  = Color(0xFFF2A0A0);

  /// Always returns true — the app is locked to the single canonical dark navy & amber reference theme.
  // static bool isDarkMode(BuildContext context) => true;

  /// Card / container background colour (#12203A from reference).
  static Color cardColorOf(BuildContext context) => const Color(0xFF12203A);

  /// Scaffold / page background colour (#0B1524 from reference).
  // static Color scaffoldBackground(BuildContext context) => const Color(0xFF0B1524);

  /// Surface colour for inputs, sheets (#1A2C4A from reference).
  // static Color surfaceColor(BuildContext context) => const Color(0xFF1A2C4A);

  /// Primary text on a surface (#E8EEF7 from reference).
  static Color textOnSurface(BuildContext context) => const Color(0xFFE8EEF7);

  /// Secondary / muted text (#A6B3C7 from reference).
  static Color mutedText(BuildContext context) => const Color(0xFFA6B3C7);

  /// Divider / separator colour (#27395A from reference).
  // static Color dividerColorOf(BuildContext context) => const Color(0xFF27395A);

  /// Shadow helper – returns soft black for box shadows.
  static Color shadowWithAlpha(BuildContext context, double opacity) =>
      Colors.black.withValues(alpha: opacity);

  /// Link colour (#9EC2F0 from reference).
  // static Color linkColor(BuildContext context) => const Color(0xFF9EC2F0);

  /// Box-shadow colour.
  // static Color shadowColor(BuildContext context) =>
  //     Colors.black.withValues(alpha: 0.35);

  /// Navy header background (#07101E from reference).
  // static Color headerNavy(BuildContext context) => const Color(0xFF07101E);

  /// Accent amber orange (#F2A01F from reference).
  // static Color accent(BuildContext context) => const Color(0xFFF2A01F);

  /// WhatsApp brand green (#178F50 from reference).
  // static Color whatsapp(BuildContext context) => const Color(0xFF178F50);

  /// Border colour for inputs and cards (#27395A from reference).
  // static Color border(BuildContext context) => const Color(0xFF27395A);
}