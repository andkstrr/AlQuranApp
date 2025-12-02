import 'package:al_quran_app/screens/home.dart';
import 'package:al_quran_app/screens/quran/home.dart';
import 'package:al_quran_app/screens/quran/quran.dart';
import 'package:al_quran_app/screens/splash.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/home': (context) => const HomeScreen(),
  '/quran': (context) => const HomeQuranScreen(),
  '/surah/read': (context) => const QuranScreen(),
};