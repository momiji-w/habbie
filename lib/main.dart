import 'package:flutter/material.dart';
import 'package:habbie/habit_page.dart';
import 'package:habbie/theme.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData habbieTheme = ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: HabbieTheme.primary,
          onPrimary: HabbieTheme.onPrimary,
          background: HabbieTheme.background,
          onBackground: HabbieTheme.onBackground,
          surface: HabbieTheme.background,
          onSurface: HabbieTheme.onBackground,
        ));
    return MaterialApp(
        title: 'Habbie', theme: habbieTheme, home: const HabitTrackerPage());
  }
}
