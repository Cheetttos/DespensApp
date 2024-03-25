import 'dart:async';
import 'package:dio/dio.dart';

class ApiActores {
  static const String apiKey = '4a4ae5808139f17b7ecdd1a24413ccf5';
  final dio = Dio();

  Future<List<Map<String, dynamic>>?> getActores(int movieId) async {
    try {
      
      Response response = await dio.get(
          'https://api.themoviedb.org/3/movie/$movieId/credits',
          queryParameters: {'api_key': apiKey});
      List<Map<String, dynamic>> credits = [];
      
      if (response.statusCode == 200) {
        final List<dynamic> castList = response.data['cast'] as List<dynamic>;
        // Filtramos y mapeamos si son actores
        credits = castList
            .where((cast) => cast['known_for_department'] == 'Acting')
            .map<Map<String, dynamic>>((cast) => {
                  'name': cast['name'],
                  'character': cast['character'],
                  'profile_path': cast['profile_path'],
                })
            .toList();
        
      } else {
        throw Exception('Error al obtener los actores ${response.statusCode}');
      }
      return credits;
    } catch (error) {
      throw Exception('Error al obtener los actores $error');
    }
    
  }
}
