// ignore_for_file: unused_field

import 'package:al_quran_app/models/surah/detail_surah.dart';
import 'package:al_quran_app/models/surah/surah.dart';
import 'package:al_quran_app/remote_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:skeletonizer/skeletonizer.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key, this.surah, this.id = 1, this.surahList});

  final SurahModel? surah;
  final List<SurahModel>? surahList;
  final int? id;

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen>
    with SingleTickerProviderStateMixin {
  final remoteResource = RemoteResource();
  List<SurahModel> get surahList => widget.surahList ?? [];
  final Map<int, List<Ayat>> _ayatCache = {};
  final Map<int, SurahModel> _surahCache = {};
  final Map<int, DetailSurahModel> _detailSurahCache = {};
  DetailSurahModel detailSurah = DetailSurahModel();

  late AudioPlayer player;
  TabController? _tabController;
  int? _loadingSurahId;
  bool _isLoadingAyat = false;
  bool _isLoadingSkeleton = false;

  List<Ayat> dummyAyat = List.generate(
    5,
    (index) => Ayat(
      nomor: index + 1,
      ar: 'آية ${index + 1}', // Teks Arab dummy
      tr: 'Transliterasi Ayat ${index + 1}', // Transliterasi dummy
      idn: 'Terjemahan Ayat ${index + 1}', // Terjemahan dummy
    ),
  );

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    if (widget.surahList != null && widget.surahList!.isNotEmpty) {
      final sortedSurah = List<SurahModel>.from(widget.surahList!)
        ..sort((a, b) => (b.nomor ?? 0).compareTo(a.nomor ?? 0));

      setState(() {
        surahList
          ..clear()
          ..addAll(sortedSurah);
      });

      final preferredId =
          widget.id ?? widget.surah?.nomor ?? surahList.first.nomor ?? 1;
      final initialIndex = surahList.indexWhere(
        (element) => element.nomor == preferredId,
      );
      _initTabController(initialIndex >= 0 ? initialIndex : 0);

      final targetId =
          surahList[_tabController!.index].nomor ?? surahList.first.nomor!;
      _loadSurah(targetId);
      return;
    }
  }

  @override
  void dispose() {
    player.dispose();
    _tabController?.removeListener(_handleTabChange);
    _tabController?.dispose();
    super.dispose();
  }

  void _initTabController(int initialIndex) {
    _tabController?.removeListener(_handleTabChange);
    _tabController?.dispose();

    _tabController = TabController(
      length: surahList.length,
      vsync: this,
      initialIndex: initialIndex,
    )..addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!mounted ||
        _tabController == null ||
        _tabController!.indexIsChanging ||
        surahList.isEmpty) {
      return;
    }
    final surah = surahList[_tabController!.index];
    final id = surah.nomor;
    if (id != null) {
      _loadSurah(id);
    }
  }

  String _parseHtml(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  Future<void> fetchSurah() async {
    if (widget.surahList != null && widget.surahList!.isNotEmpty) {
      setState(() {
        final sortedSurah = List<SurahModel>.from(widget.surahList!)
          ..sort((a, b) => (b.nomor ?? 0).compareTo(a.nomor ?? 0));
        surahList
          ..clear()
          ..addAll(sortedSurah);
      });
      return;
    }

    final result = await remoteResource.fetchQuran();
    result.fold(
      (error) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $error'))),
      (data) {
        if (!mounted || data.isEmpty) return;
        final sortedSurah = List<SurahModel>.from(data)
          ..sort((a, b) => (b.nomor ?? 0).compareTo(a.nomor ?? 0));
        setState(() {
          surahList
            ..clear()
            ..addAll(sortedSurah);
        });

        final preferredId =
            widget.id ?? widget.surah?.nomor ?? surahList.first.nomor ?? 1;
        final initialIndex = surahList.indexWhere(
          (element) => element.nomor == preferredId,
        );
        _initTabController(initialIndex >= 0 ? initialIndex : 0);

        final targetId =
            surahList[_tabController!.index].nomor ?? surahList.first.nomor!;
        _loadSurah(targetId);
      },
    );
  }

  Future<void> _loadSurah(int id) async {
    final cachedDetail = _detailSurahCache[id];
    if (cachedDetail != null) {
      setState(() {
        detailSurah = cachedDetail;
      });
      _updateAudioSource(cachedDetail.audio);
      return;
    }

    setState(() {
      _loadingSurahId = id;
      _isLoadingAyat = true;
    });

    final result = await remoteResource.detailSurah(id);
    if (!mounted) return;

    result.fold(
      (error) {
        setState(() {
          _loadingSurahId = null;
          _isLoadingAyat = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $error')));
      },
      (data) {
        setState(() {
          detailSurah = data;
          _detailSurahCache[id] = data;
          _ayatCache[id] = data.ayat ?? [];
          _surahCache[id] = surahList.firstWhere((surah) => surah.nomor == id);
          _loadingSurahId = null;
          _isLoadingAyat = false;
        });
        _updateAudioSource(data.audio);
      },
    );
  }

  void _updateAudioSource(String? audioUrl) {
    if (audioUrl != null && audioUrl.isNotEmpty) {
      player.setUrl(audioUrl);
    } else {
      player.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReady = surahList.isNotEmpty && _tabController != null;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_left_rounded, size: 40),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Quran'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: !isReady
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  dividerColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[300],
                  indicatorColor: Color(0xff244e4d),
                  tabs: surahList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final surah = entry.value;
                    final isActive = _tabController?.index == index;
                    return Tab(
                      child: Text(
                        surah.namaLatin ?? 'Surah',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isActive
                              ? (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black)
                              : Colors.grey,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: surahList.map((surah) {
                      final surahId = surah.nomor;
                      if (surahId == null) {
                        return const Center(child: Text('Surah tidak valid'));
                      }

                      final ayat = _ayatCache[surahId] ?? <Ayat>[];
                      final isLoadingThisTab =
                          _isLoadingAyat && _loadingSurahId == surahId;

                      return Skeletonizer(
                        enabled: isLoadingThisTab,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xff244e4d),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        surah.namaLatin ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${detailSurah.jumlahAyat ?? 0} Ayat, ${detailSurah.tempatTurun ?? ''}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (surahId != 1 && surahId != 9)
                                const Text(
                                  'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24),
                                ),
                              const SizedBox(height: 12),
                              ...(isLoadingThisTab ? dummyAyat : ayat).map(
                                (item) => cardAyat(item),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[600]!, width: 1)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.audiotrack,
                      size: 30,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detailSurah.namaLatin ?? 'Loading...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Text(
                          '${detailSurah.jumlahAyat ?? 0} Ayat • ${detailSurah.tempatTurun ?? ''}',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<PlayerState>(
                    stream: player.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final isPlaying = playerState?.playing ?? false;
                      return IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 30,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        onPressed: () {
                          if (isPlaying) {
                            player.pause();
                          } else {
                            player.play();
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              StreamBuilder<Duration>(
                stream: player.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  return StreamBuilder<Duration?>(
                    stream: player.durationStream,
                    builder: (context, snapshot) {
                      final duration = snapshot.data ?? Duration.zero;
                      final maxDuration = duration.inMilliseconds > 0
                          ? duration.inMilliseconds.toDouble()
                          : 1.0;
                      final isDark =
                          Theme.of(context).brightness == Brightness.dark;
                      return SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 0,
                          ),
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 0,
                          ),
                          trackHeight: 2,
                        ),
                        child: Slider(
                          value: position.inMilliseconds.toDouble().clamp(
                            0.0,
                            maxDuration,
                          ),
                          max: maxDuration,
                          activeColor: isDark
                              ? Colors.white
                              : Theme.of(context).colorScheme.primary,
                          inactiveColor: isDark
                              ? Colors.white24
                              : Colors.black26,
                          onChanged: (value) {
                            player.seek(Duration(milliseconds: value.toInt()));
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardAyat(Ayat ayat) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.brightnessOf(context) == Brightness.dark ? Colors.grey[800]! : Colors.grey[300]!, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/jewish-star.svg',
                        width: 36,
                        height: 36,
                        color: Color(0xFF244e4d),
                      ),
                      Text(
                        '${ayat.nomor}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      ayat.ar ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              _parseHtml(ayat.tr ?? ''),
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.grey[500]
                : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text('${ayat.idn}', style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
