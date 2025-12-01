import 'package:al_quran_app/models/surah/detail_surah.dart';
import 'package:al_quran_app/remote_resource.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class DetailSurahScreen extends StatefulWidget {
  final int id;
  const DetailSurahScreen({super.key, required this.id});

  @override
  State<DetailSurahScreen> createState() => _DetailSurahScreenState();
}

class _DetailSurahScreenState extends State<DetailSurahScreen> {
  final remoteResource = RemoteResource();
  final List<Ayat> ayatList = [];
  DetailSurahModel detailSurah = DetailSurahModel();

  late AudioPlayer player;
  Stream<Duration> get _positionStream => player.positionStream;
  Stream<Duration?> get _durationStream => player.durationStream;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    player = AudioPlayer();
    getDetailSurah(widget.id);
    super.initState();
  }

  void getDetailSurah(int id) async {
    final result = await remoteResource.detailSurah(id);
    result.fold(
      (error) => {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $error'))),
      },
      (data) {
        setState(() {
          detailSurah = data;
          ayatList.addAll(data.ayat ?? []);
        });
        player.setUrl(detailSurah.audio ?? '');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      detailSurah.namaLatin ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      detailSurah.nama ?? '',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.blueGrey.withValues(alpha: 0.5),
                  thickness: 1,
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      spacing: 2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '(${detailSurah.arti})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${detailSurah.tempatTurun?.toUpperCase()} | ${detailSurah.jumlahAyat} Ayat',
                        ),
                      ],
                    ),
                    StreamBuilder<PlayerState>(
                      stream: player.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        final playing = playerState?.playing ?? false;

                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) {
                          return IconButton(
                            icon: CircularProgressIndicator(),
                            onPressed: null,
                          );
                        } else if (playing) {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: IconButton(
                              icon: Icon(
                                Icons.pause_circle_filled,
                                size: 48,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              onPressed: player.pause,
                            ),
                          );
                        } else {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: IconButton(
                              icon: Icon(
                                Icons.play_circle_filled,
                                size: 42,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              onPressed: player.play,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                StreamBuilder<Duration>(
                  stream: _positionStream,
                  builder: (context, positionSnapshot) {
                    final position = positionSnapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration?>(
                      stream: _durationStream,
                      builder: (context, durationSnapshot) {
                        final duration = durationSnapshot.data ?? Duration.zero;
                        return Slider(
                          value: position.inSeconds.toDouble(),
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          onChanged:
                              (value) =>
                                  player.seek(Duration(seconds: value.toInt())),
                          activeColor: Theme.of(context).colorScheme.secondary,
                          // Color of the part already played
                          inactiveColor: Colors.grey[300],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ayatList.length,
              itemBuilder: (context, index) {
                return cardAyat(ayatList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget cardAyat(Ayat ayat) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${ayat.surah}:${ayat.nomor}',
                    style: TextStyle(fontSize: 11),
                  ),
                ),

                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      ayat.ar ?? '',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ],
            ),
            Text('${ayat.idn}'),
          ],
        ),
      ),
    );
  }
}

