import 'package:dio/dio.dart';
import 'package:al_quran_app/models/prayer/prayer_time.dart';

class PrayerService {
  final Dio _dio = Dio();

  Future<PrayerTime> getPrayerTimes(double lat, double lng) async {
    final response = await _dio.get(
      'https://api.aladhan.com/v1/timings',
      queryParameters: {
        'latitude': lat,
        'longitude': lng,
        'method': 11,
      },
    );

    return PrayerTime.fromJson(response.data['data']);
  }
}
