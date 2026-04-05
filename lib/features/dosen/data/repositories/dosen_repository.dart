import 'package:dio/dio.dart';
import 'package:mobile_dua/features/dosen/data/models/dosen_model.dart';

class DosenRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Accept': 'application/json'},
  ));

  Future<List<DosenModel>> getDosenList() async {
    try {
      final response = await _dio.get('/users');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print(data);
        return data.map((json) => DosenModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data dosen: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      throw Exception('Gagal memuat data dosen: ${e.message}');
    }
  }
}