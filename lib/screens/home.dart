import 'package:al_quran_app/widgets/item_prayer.dart';
import 'package:flutter/material.dart';
import 'package:al_quran_app/models/prayer/prayer_time.dart';
import 'package:al_quran_app/services/location.dart';
import 'package:al_quran_app/services/prayer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PrayerTime? prayerTime;
  bool isLoading = true;

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
    setState(() {
      isLoading = false;
    });
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
                  horizontal: 20,
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
                          onPressed: () {},
                          icon: Icon(
                            Icons.notifications,
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
                            "Menuju Dzuhur 6 jam 9 menit",
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: 0.9,
                      ),
                      children: [
                        ItemPrayer(
                          label: 'Shubuh', icon: Icons.sunny, time: prayerTime?.fajr ?? "--:--",
                        ),
                        ItemPrayer(
                          label: 'Dzuhur', icon: Icons.sunny, time: prayerTime?.dhuhr ?? "--:--",
                        ),
                        ItemPrayer(
                          label: 'Ashar', icon: Icons.sunny, time: prayerTime?.asr ?? "--:--",
                        ),
                        ItemPrayer(
                          label: 'Maghrib', icon: Icons.sunny, time: prayerTime?.maghrib ?? "--:--",
                        ),
                        ItemPrayer(
                          label: 'Isya\'', icon: Icons.sunny, time: prayerTime?.isha ?? "--:--",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 25,
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
                      GridView.builder(
                        itemCount: 5,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.book,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text("Fitur ${index + 1}"),
                            ],
                          );
                        },
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
                        // padding: EdgeInsets.only(left: 25),
                        height: 350,
                        child: ListView.separated(
                          itemCount: 5,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 20),
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    'https://www.goersapp.com/blog/wp-content/uploads/2024/02/Jadwal-Kajian-Ustadz-Hanan-Attaki-Maret-2024.jpg',
                                    width: 300,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Kajian ${index + 1}'),
                              ],
                            );
                          },
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
