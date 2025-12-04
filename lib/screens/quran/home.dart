import 'package:al_quran_app/remote_resource.dart';
import 'package:al_quran_app/models/surah/surah.dart';
import 'package:al_quran_app/screens/quran/quran.dart';
import 'package:al_quran_app/widgets/card_surah.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';

class HomeQuranScreen extends StatefulWidget {
  const HomeQuranScreen({super.key});

  @override
  State<HomeQuranScreen> createState() => _HomeQuranScreenState();
}

class _HomeQuranScreenState extends State<HomeQuranScreen> {
  final remoteResource = RemoteResource();
  final List<SurahModel> surahList = [];
  bool isSearching = false;

  bool isLoading = false;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });

    final result = await remoteResource.fetchQuran();

    result.fold(
      (error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $error')));
      },
      (data) {
        setState(() {
          isLoading = false;
          surahList.addAll(data);
        });
      },
    );
  }

  void toggleSearch() {
    setState(() {
      isSearching = !isSearching;
    });
    clearSearch();
  }

  final List<SurahModel> _originalSurah = [];

  void _searchSurah(String query) {
    final searchLower = query.trim().toLowerCase();

    if (searchLower.isEmpty) {
      if (_originalSurah.isNotEmpty) {
        setState(() {
          surahList
            ..clear()
            ..addAll(_originalSurah);
          _originalSurah.clear();
        });
      }
      return;
    }

    if (_originalSurah.isEmpty) {
      _originalSurah.addAll(surahList);
    }

    final filtered = _originalSurah.where((surah) {
      final namaSuratLower = surah.nama?.toLowerCase() ?? '';
      final namaLatinLower = surah.namaLatin?.toLowerCase() ?? '';
      return namaSuratLower.contains(searchLower) ||
          namaLatinLower.contains(searchLower);
    }).toList();

    setState(() {
      surahList
        ..clear()
        ..addAll(filtered);
    });
  }

  void clearSearch() {
    _searchSurah('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0, -0.3),
              end: Offset.zero,
            ).animate(animation);
            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: isSearching
              ? SizedBox(
                  height: 44,
                  child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Cari surah...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      visualDensity: VisualDensity.compact,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.primary,
                    ),
                    style: const TextStyle(fontSize: 16),
                    onChanged: (value) {
                      _searchSurah(value);
                    },
                  ),
                )
              : const Text('Yuk Ngaji', key: ValueKey('titleText')),
        ),
        centerTitle: true,
        leading: !isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_left_rounded, size: 40),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search, size: 30),
            onPressed: () {
              toggleSearch();
            },
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Assalamu'alaikum,",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  "Sudah bacakah Al-Qur'an hari ini?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: Image.asset('assets/images/banner.png'),
                ),
                const SizedBox(height: 30),
                Skeletonizer(
                  enabled: isLoading && surahList.isEmpty,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: isLoading
                        ? 10
                        : surahList
                              .length, // optional biar skeleton berjumlah 10
                    separatorBuilder: (context, index) =>
                        const Divider(thickness: 1.5),
                    itemBuilder: (context, index) {
                      if (isLoading) {
                        return CardSurah(
                          namaSurat: 'Loading...',
                          namaLatin: 'Loading...',
                          nomorSurat: '0',
                          jumlahAyat: 0,
                          tempatTurun: '',
                          onTap: () {},
                        );
                      }

                      final surah = surahList[index];
                      return CardSurah(
                        namaSurat: surah.namaLatin,
                        namaLatin: surah.nama,
                        nomorSurat: surah.nomor.toString(),
                        jumlahAyat: surah.jumlahAyat,
                        tempatTurun: surah.tempatTurun,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuranScreen(
                                surahList: _originalSurah.isNotEmpty
                                    ? _originalSurah
                                    : surahList,
                                id: surah.nomor!,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
