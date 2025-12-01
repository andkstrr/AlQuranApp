class PrayerTime {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String hijriDate;
  final String readableDate;

  PrayerTime({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.hijriDate,
    required this.readableDate,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    String cleanTime(String time) => time.split(' ').first;

    final hijri = json['date']['hijri'];
    final day = hijri['day'];
    final monthEn = hijri['month']['en'];
    final year = hijri['year'];

    final hijriMonthId = _convertHijriMonth(monthEn);

    return PrayerTime(
      fajr: cleanTime(json['timings']['Fajr']),
      dhuhr: cleanTime(json['timings']['Dhuhr']),
      asr: cleanTime(json['timings']['Asr']),
      maghrib: cleanTime(json['timings']['Maghrib']),
      isha: cleanTime(json['timings']['Isha']),
      hijriDate: "$day $hijriMonthId $year H",
      readableDate: json['date']['readable'],
    );
  }

  static String _convertHijriMonth(String month) {
    switch (month) {
      case "Muharram": return "Muharram";
      case "Safar": return "Safar";
      case "Rabi-Al-Awwal": return "Rabiul Awal";
      case "Rabi-Al-Thani": return "Rabiul Akhir";
      case "Jumada-Al-Awwal": return "Jumadil Awal";
      case "Jumada-Al-Thani": return "Jumadil Akhir";
      case "Rajab": return "Rajab";
      case "Shaban": return "Sya'ban";
      case "Ramadan": return "Ramadhan";
      case "Shawwal": return "Syawal";
      case "Dhu-Al-Qadah": return "Dzulqaidah";
      case "Dhu-Al-Hijjah": return "Dzulhijjah";
      default: return month;
    }
  }
}
