import 'package:flutter/material.dart';
import 'package:al_quran_app/utils/theme.dart';
import 'package:al_quran_app/utils/util.dart';
import 'package:al_quran_app/screens/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // binding framework (asynchronous code before runApp)
  runApp(const AlQuranApp());
}

class AlQuranApp extends StatelessWidget {
  const AlQuranApp({super.key});

  @override
  Widget build(BuildContext context) {
      TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");
      MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Al-Qur\'an App',
      theme: theme.light(),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
