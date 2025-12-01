import 'dart:convert';

import 'package:al_quran_app/models/surah/detail_surah.dart';
import 'package:al_quran_app/models/surah/surah.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

class RemoteResource {
  final dio = Dio();

  RemoteResource() {
    dio.options.baseUrl = 'https://open-api.my.id/api/';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Accept-Charset'] = 'utf-8';
    // Tambahkan interceptor untuk handle encoding
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          // Decode manual jika diperlukan
          if (response.data is String) {
            response.data = json.decode(utf8.decode(response.data.codeUnits));
          }
          return handler.next(response);
        },
      ),
    );
  }

  Future<Either<String, List<SurahModel>>> fetchQuran() async {
    try {
      final response = await dio.get('quran/surah');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<SurahModel> surahList =
            data.map((json) {
              return SurahModel.fromMap(json);
            }).toList();
        return Right(surahList);
      } else {
        return Left('Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return Left('DioException: ${e.message}');
    }
  }

  Future<Either<String, DetailSurahModel>> detailSurah(int id) async {
    try {
      final response = await dio.get('quran/surah/$id');
      if (response.statusCode == 200) {
        DetailSurahModel detailSurah = DetailSurahModel.fromMap(response.data);
        return Right(detailSurah);
      } else {
        return Left('Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return Left('DioException: ${e.message}');
    }
  }
}

