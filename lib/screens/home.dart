import 'dart:async';
import 'package:flutter/material.dart';
import 'package:al_quran_app/widgets/item_feature.dart';
import 'package:al_quran_app/widgets/item_prayer.dart';
import 'package:al_quran_app/widgets/item_recitation.dart';
import 'package:al_quran_app/models/prayer/prayer_time.dart';
import 'package:al_quran_app/services/location.dart';
import 'package:al_quran_app/services/prayer.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:al_quran_app/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PrayerTime? prayerTime;
  bool isLoading = true;

  DateTime? nextPrayerTime;
  String nextPrayerName = "";
  Duration countdown = Duration.zero;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadPrayerTimes();
  }

  Future<void> loadPrayerTimes() async {
    final position = await LocationService.getCurrentPosition();
    double lat = position?.latitude ?? -6.595038;
    double lng = position?.longitude ?? 106.816635;

    prayerTime = await PrayerService().getPrayerTimes(lat, lng);

    calculateNextPrayer();

    setState(() => isLoading = false);
  }

  void calculateNextPrayer() {
    if (prayerTime == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final List<Map<String, dynamic>> times = [
      {"name": "Subuh", "time": prayerTime!.fajr},
      {"name": "Dzuhur", "time": prayerTime!.dhuhr},
      {"name": "Ashar", "time": prayerTime!.asr},
      {"name": "Maghrib", "time": prayerTime!.maghrib},
      {"name": "Isya", "time": prayerTime!.isha},
    ];

    for (var t in times) {
      final hhmm = t["time"].split(":");
      final dt = DateTime(
        today.year,
        today.month,
        today.day,
        int.parse(hhmm[0]),
        int.parse(hhmm[1]),
      );

      if (dt.isAfter(now)) {
        nextPrayerTime = dt;
        nextPrayerName = t["name"];
        countdown = dt.difference(now);

        startCountdown();
        return;
      }
    }

    nextPrayerName = "Subuh (Besok)";
    nextPrayerTime = today.add(const Duration(days: 1, hours: 4, minutes: 30));
    countdown = nextPrayerTime!.difference(now);
    startCountdown();
  }

  void startCountdown() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (nextPrayerTime != null) {
        setState(() {
          countdown = nextPrayerTime!.difference(DateTime.now());
        });
      }
    });
  }

  String formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;

    if (hours > 0) return "$hours jam $minutes menit";
    if (minutes > 0) return "$minutes menit $seconds detik";
    return "$seconds detik";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prayerTime?.hijriDate ?? "Memuat...",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            Text(
                              "Bogor, Indonesia",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            isDarkMode.value = !isDarkMode.value;
                          },
                          icon: Theme.of(context).brightness == Brightness.dark
                              ? Icon(
                                  LucideIcons.sun,
                                  size: 28,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                )
                              : Icon(
                                  LucideIcons.moon, 
                                  size: 28,
                                  color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            TimeOfDay.now().format(context),
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          Text(
                            nextPrayerTime != null
                                ? "Menuju $nextPrayerName ${formatDuration(countdown)}"
                                : "Memuat jadwal...",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),
                    GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            childAspectRatio: 0.9,
                          ),
                      children: [
                        ItemPrayer(
                          label: 'Shubuh',
                          icon: LucideIcons.moon,
                          time: prayerTime?.fajr ?? "--:--",
                        ),
                        ItemPrayer(
                          label: 'Dzuhur',
                          icon: LucideIcons.sun,
                          time: prayerTime?.dhuhr ?? "--:--",
                        ),
                        ItemPrayer(
                          label: 'Ashar',
                          icon: LucideIcons.cloudSun,
                          time: prayerTime?.asr ?? "--:--",
                        ),
                        ItemPrayer(
                          label: 'Maghrib',
                          icon: LucideIcons.sunset,
                          time: prayerTime?.maghrib ?? "--:--",
                        ),
                        ItemPrayer(
                          label: "Isya'",
                          icon: LucideIcons.moonStar,
                          time: prayerTime?.isha ?? "--:--",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ---- BOTTOM CONTAINER ----
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Semua Fitur",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 10,
                            ),
                        children: [
                          ItemFeature(
                            routeName: "/quran",
                            icon: LucideIcons.bookOpen,
                            label: "Quran",
                          ),
                          ItemFeature(
                            routeName: "/adzan",
                            icon: LucideIcons.volume2,
                            label: "Adzan",
                          ),
                          ItemFeature(
                            routeName: "/qibla",
                            icon: LucideIcons.compass,
                            label: "Qibla",
                          ),
                          ItemFeature(
                            routeName: "/donation",
                            icon: LucideIcons.heart,
                            label: "Donation",
                          ),
                          ItemFeature(
                            routeName: "/all-features",
                            icon: LucideIcons.layoutDashboard,
                            label: "All",
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ngaji Online",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Lihat Semua",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 320,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            YoutubePlayerBuilder(
                              player: YoutubePlayer(
                                controller: YoutubePlayerController(
                                  initialVideoId:
                                      'sX-kePnlgy4', // ID video YouTube
                                  flags: const YoutubePlayerFlags(
                                    autoPlay: false,
                                    mute: false,
                                  ),
                                ),
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: Colors.blueAccent,
                              ),
                              builder: (context, player) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 300,
                                    height: 200,
                                    child: player,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Menata Hati ala Ustadz Hanan Attaki',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Ustadz Hanan Attaki',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '1.2M views • 2 hours ago',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const ItemRecitation(
                              imageUrl:
                                  'https://www.goersapp.com/blog/wp-content/uploads/2024/02/Jadwal-Kajian-Ustadz-Hanan-Attaki-Maret-2024.jpg',
                              title: 'Menata Hati ala Ustadz Hanan Attaki',
                              channel: 'Ustadz Hanan Attaki',
                              views: '1.2M views',
                              time: '2 hours ago',
                            ),
                            const SizedBox(width: 15),
                            const ItemRecitation(
                              imageUrl:
                                  'https://imgsrv2.voi.id/SHaosPENG8ABKPTRlEmR0hoAdSpDY_Ck-DRc1_5zmSk/auto/1200/675/sm/1/bG9jYWw6Ly8vcHVibGlzaGVycy80NDE0MTQvMjAyNDEyMTAxMjMwLW1haW4uanBlZw.jpg',
                              title:
                                  'Setinggi Apa Iman Kita, Disitulah Kebahagiaan Kita Berada',
                              channel: 'Ustadz Adi Hidayat',
                              views: '1.2M views',
                              time: '2 hours ago',
                            ),
                            const SizedBox(width: 15),
                            const ItemRecitation(
                              imageUrl:
                                  'https://img.okezone.com/content/2023/01/14/621/2746139/ustadz-felix-siauw-ungkap-perjalanan-menemukan-tuhan-bermula-belajar-sains-hingga-keajaiban-alquran-aDvQMgNYTM.jpg',
                              title: 'Menemukan Keindahan Islam',
                              channel: 'Ustadz Felix Siauw',
                              views: '1.2M views',
                              time: '2 hours ago',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
