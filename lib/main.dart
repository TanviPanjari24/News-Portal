import 'package:flutter/material.dart';
import 'package:news_portal/home.dart';
import 'package:news_portal/res/app_colors.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Portal',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,  
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      primaryColor: AppColors.colorPrimary,
      hintColor: AppColors.colorAccent,
      scaffoldBackgroundColor: AppColors.backColorLight,
     appBarTheme: const AppBarTheme(
        color: AppColors.colorPrimary,
        titleTextStyle: TextStyle(color: AppColors.ivory, fontSize: 20), 
        iconTheme: IconThemeData(color: AppColors.colorWhite),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppColors.colorPrimaryText),
        bodySmall: TextStyle(color: AppColors.colorSecondaryText),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.colorAccent,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      primaryColor: AppColors.colorPrimary,
      hintColor: AppColors.colorAccent,
      scaffoldBackgroundColor: AppColors.backColorDark,
      appBarTheme: const AppBarTheme(
        color: AppColors.colorPrimary,
       titleTextStyle: TextStyle(color: AppColors.ivory, fontSize: 20), 
        iconTheme: IconThemeData(color: AppColors.colorWhite),
      ),
     
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.colorAccent,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
