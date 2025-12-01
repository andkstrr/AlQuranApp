import 'dart:convert';

class DetailSurahModel {
  final bool? status;
  final int? nomor;
  final String? nama;
  final String? namaLatin;
  final int? jumlahAyat;
  final String? tempatTurun;
  final String? arti;
  final String? deskripsi;
  final String? audio;
  final List<Ayat>? ayat;
  final bool? suratSebelumnya;

  DetailSurahModel({
    this.status,
    this.nomor,
    this.nama,
    this.namaLatin,
    this.jumlahAyat,
    this.tempatTurun,
    this.arti,
    this.deskripsi,
    this.audio,
    this.ayat,
    this.suratSebelumnya,
  });

  factory DetailSurahModel.fromJson(String str) =>
      DetailSurahModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetailSurahModel.fromMap(Map<String, dynamic> json) =>
      DetailSurahModel(
        status: json["status"],
        nomor: json["nomor"],
        nama: json["nama"],
        namaLatin: json["nama_latin"],
        jumlahAyat: json["jumlah_ayat"],
        tempatTurun: json["tempat_turun"],
        arti: json["arti"],
        deskripsi: json["deskripsi"],
        audio: json["audio"],
        ayat:
            json["ayat"] == null
                ? []
                : List<Ayat>.from(json["ayat"]!.map((x) => Ayat.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "nomor": nomor,
    "nama": nama,
    "nama_latin": namaLatin,
    "jumlah_ayat": jumlahAyat,
    "tempat_turun": tempatTurun,
    "arti": arti,
    "deskripsi": deskripsi,
    "audio": audio,
    "ayat": ayat == null ? [] : List<dynamic>.from(ayat!.map((x) => x.toMap())),
  };
}

class Ayat {
  final int? id;
  final int? surah;
  final int? nomor;
  final String? ar;
  final String? tr;
  final String? idn;

  Ayat({this.id, this.surah, this.nomor, this.ar, this.tr, this.idn});

  factory Ayat.fromJson(String str) => Ayat.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ayat.fromMap(Map<String, dynamic> json) => Ayat(
    id: json["id"],
    surah: json["surah"],
    nomor: json["nomor"],
    ar: json["ar"],
    tr: json["tr"],
    idn: json["idn"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "surah": surah,
    "nomor": nomor,
    "ar": ar,
    "tr": tr,
    "idn": idn,
  };
}

class SuratSelanjutnya {
  final int? id;
  final int? nomor;
  final String? nama;
  final String? namaLatin;
  final int? jumlahAyat;
  final String? tempatTurun;
  final String? arti;
  final String? deskripsi;
  final String? audio;

  SuratSelanjutnya({
    this.id,
    this.nomor,
    this.nama,
    this.namaLatin,
    this.jumlahAyat,
    this.tempatTurun,
    this.arti,
    this.deskripsi,
    this.audio,
  });

  factory SuratSelanjutnya.fromJson(String str) =>
      SuratSelanjutnya.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SuratSelanjutnya.fromMap(Map<String, dynamic> json) =>
      SuratSelanjutnya(
        id: json["id"],
        nomor: json["nomor"],
        nama: json["nama"],
        namaLatin: json["nama_latin"],
        jumlahAyat: json["jumlah_ayat"],
        tempatTurun: json["tempat_turun"],
        arti: json["arti"],
        deskripsi: json["deskripsi"],
        audio: json["audio"],
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nomor": nomor,
    "nama": nama,
    "nama_latin": namaLatin,
    "jumlah_ayat": jumlahAyat,
    "tempat_turun": tempatTurun,
    "arti": arti,
    "deskripsi": deskripsi,
    "audio": audio,
  };
}