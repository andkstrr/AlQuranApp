import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardSurah extends StatelessWidget {
  const CardSurah({
    super.key,
    required this.nomorSurat,
    required this.namaSurat,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.onTap,
  });

  final String? nomorSurat;
  final String? namaSurat;
  final String? namaLatin;
  final int? jumlahAyat;
  final String? tempatTurun;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/jewish-star.svg',
                      width: 40,
                      height: 40,
                      color: Theme.of(context).brightness == Brightness.dark
                        ? Color(0xff92bebc)
                        : Color(0xFF13a893),
                    ),
                    Text(
                      nomorSurat!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaSurat!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("${tempatTurun!} • ${jumlahAyat!} Ayat"),
                  ],
                ),
              ],
            ),
            Text(
              namaLatin!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                 color: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xff92bebc)
                  : Color(0xFF13a893),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
