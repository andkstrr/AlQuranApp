import 'package:flutter/material.dart';
import 'package:al_quran_app/screens/home.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Future.delayed akan menjalankan fungsi callback setelah durasi yang ditentukan (3 detik)
    Future.delayed(const Duration(seconds: 7), () {
      // pushReplacement mencegah pengguna kembali ke splash screen dengan tombol kembali
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/jewish-star.svg',
                      width: 60,
                      height: 60,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yuk Ngaji',
                          style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        Text(
                          "#SempetinWaktuNgaji",
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: LoadingAnimationWidget.horizontalRotatingDots(
                color: Theme.of(context).colorScheme.onPrimary,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
