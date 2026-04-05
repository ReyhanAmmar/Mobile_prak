import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_dua/features/mahasiswa_aktif/data/models/mahasiswa_aktif_model.dart';

class MahasiswaAktifRepositoryHttp {
  Future<List<MahasiswaAktifModel>> getMahasiswaAktifList() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print(data); // Debug
      return data.map((json) => MahasiswaAktifModel.fromJson(json)).toList();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception(
          'Gagal memuat data mahasiswa aktif: ${response.statusCode}');
    }
  }
}

class MahasiswaAktifRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Accept': 'application/json'},
  ));

  Future<List<MahasiswaAktifModel>> getMahasiswaAktifList() async {
    try {
      final response = await _dio.get('/posts');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print(data); // Debug
        return data
            .map((json) => MahasiswaAktifModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'Gagal memuat data mahasiswa aktif: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      throw Exception('Gagal memuat data mahasiswa aktif: ${e.message}');
    }
  }
}