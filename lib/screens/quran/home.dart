import 'package:al_quran_app/remote_resource.dart';
import 'package:al_quran_app/model/surah.dart';
import 'package:al_quran_app/screens/quran/detail_surah.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeQuranScreen extends StatefulWidget {
  const HomeQuranScreen({super.key});

  @override
  State<HomeQuranScreen> createState() => _HomeQuranScreenState();
}

class _HomeQuranScreenState extends State<HomeQuranScreen> {
  final remoteResource = RemoteResource();
  final List<SurahModel> surahList = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    final result = await remoteResource.fetchQuran();
    result.fold(
      (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $error')));
      },
      (data) {
        setState(() {
          surahList.addAll(data);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Al-Qur\'an'))),
      body: ListView.builder(
        itemCount: surahList.length,
        itemBuilder: (context, index) {
          final surah = surahList[index];
          return buildSurahCard(surah);
        },
      ),
    );
  }

  Widget buildSurahCard(SurahModel surah) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withValues(alpha: 0.5),
            spreadRadius: 0.5,
            offset: Offset(0, 0.5), 
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailSurahScreen(id: surah.nomor ?? 0),
            ),
          );
        },
        child: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/jewish-star.svg',
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.secondary,
                    BlendMode.srcIn,
                  ),
                  width: 52,
                  height: 52,
                ),
                Center(
                  child: Text(
                    surah.nomor.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.namaLatin ?? '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(surah.arti ?? ''),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${surah.nama}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('${surah.jumlahAyat} Ayat'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

