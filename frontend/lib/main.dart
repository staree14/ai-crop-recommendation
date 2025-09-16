import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'screens/home_screen.dart';
import 'screens/soil_data_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/recommendations_screen.dart';
import 'screens/static_market_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('hi'),
        Locale('kn'),
        Locale('or'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: FarmerApp(),
    ),
  );
}

class FarmerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app_title'.tr(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          border: OutlineInputBorder(),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      routes: {
        '/home': (_) => HomeScreen(),
        '/soil': (_) => SoilDataScreen(),
        '/upload': (_) => UploadScreen(),
        '/chat': (_) => ChatScreen(),
        '/recommendations': (_) => RecommendationsScreen(),
        '/market': (_) => StaticMarketScreen(),
        '/settings': (_) => SettingsScreen(),
      },
    );
  }
}