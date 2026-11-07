import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(primaryContainer: Color(0xFF282828),
      secondary: Color(0xFFC6C6C6),
      error: Color(0xFFFF5252)),
  scaffoldBackgroundColor: Color(0xFF181818),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF181818),
    titleTextStyle: TextStyle(color: Color(0xFFFFFCFC), fontSize: 20),
    centerTitle: true,
    iconTheme: IconThemeData(color: Color(0xFFFFFCFC)),
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Color(0xFF15886C);
      }
      return Colors.white;
    }),
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return Color(0xFF9E9E9E);
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.transparent;
      }
      return Color(0xFF9E9E9E);
    }),
    trackOutlineWidth: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return 0;
      }
      return 2;
    }),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Color(0xFF15B86C)),
      foregroundColor: WidgetStateProperty.all(Color(0xFFFFFCFC)),
      textStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF15B86C),
      foregroundColor: Color(0xFFFFFCFC),
      extendedTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      )
  ),
  textTheme: TextTheme(
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: Color(0XFFFFFFFF),
    ),
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xFFC6C6C6),
    ),
    // done Task
    titleLarge: TextStyle(
      color: Color(0xFFA0A0A0),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.lineThrough,
      decorationColor: const Color(0xFFC6C6C6),
      overflow: TextOverflow.ellipsis,
    ),
    labelSmall: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: Color(0XFFFFFCFC),
    ),
    labelMedium: TextStyle(color: Colors.white, fontSize: 16),
    labelLarge: TextStyle(color: Colors.white, fontSize: 24),
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(color: Color(0xFF6d6d6d)),
    filled: true,
    fillColor: const Color(0xFF282828),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.red),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    side: BorderSide(color: Color(0xFF6E6E6E), width: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  iconTheme: IconThemeData(color: Color(0xFFFFFCFC)),
  listTileTheme: ListTileThemeData(
    titleTextStyle:TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),

    ),),
  dividerTheme: DividerThemeData(
    color: Color(0xFF6E6E6E),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor:Colors.white70,
    selectionHandleColor: Colors.white,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF181818),
    type: BottomNavigationBarType.fixed,
    unselectedItemColor: Color(0xFFC6C6C6),
    selectedItemColor: Color(0xFF15B86C),
  ),
  splashFactory: NoSplash.splashFactory,
  dialogTheme: DialogThemeData(
    backgroundColor: Color(0xFF282828),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Color(0xFF15B86C), width: 1),
      borderRadius: BorderRadius.circular(16),
    ),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Color(0xFFFFFCFC),
    ),
    contentTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Color(0xFFC6C6C6),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(Color(0xFF15B86C)),
      textStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
      color: Color(0xFF181818),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFF15B86C), width: 1),
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      elevation: 2,
      shadowColor: Color(0xFF15B86C),
      labelTextStyle:WidgetStateProperty.all(
          TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400
          )
      )
  ),
);