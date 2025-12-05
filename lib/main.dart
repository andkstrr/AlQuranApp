import 'package:flutter/material.dart';
import 'package:al_quran_app/utils/theme.dart';
import 'package:al_quran_app/utils/util.dart';
import 'package:al_quran_app/routes/routes.dart';

ValueNotifier<bool> isDarkMode = ValueNotifier(true);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AlQuranApp());
}

class AlQuranApp extends StatelessWidget {
  const AlQuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");
    MaterialTheme theme = MaterialTheme(textTheme);

    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, _) {
        return MaterialApp(
          title: 'Al-Quran App',
          theme: value ? theme.dark() : theme.light(),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: appRoutes,
        );
      },
    );
  }
}
