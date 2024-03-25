import 'dart:async';
import 'package:dio/dio.dart';

class ApiTrailer {
  final String apiKey = '4a4ae5808139f17b7ecdd1a24413ccf5';
  final dio = Dio();

  Future<List<String>?> movieTrailer(int movieId) async {
    try {
      Response response = await dio.get(
          'https://api.themoviedb.org/3/movie/$movieId/videos',
          queryParameters: {'api_key': apiKey});
      if (response.statusCode == 200) {
        final List<dynamic> listTrailerMap =
            response.data['results'] as List<dynamic>;
        final List<String> trailerUrls = listTrailerMap
            .where((trailer) => trailer['site'] == 'YouTube')
            .map<String>((trailer) =>
                'https://www.youtube.com/watch?v=${trailer['key']}')
            .toList();
        return trailerUrls;
      }
      else{
        throw Exception('Error al cargar los trailer de las peliculas');
      }
    } catch (error) {
      throw Exception('Error al cargar los trailer de las peliculas $error');
    }
  }
}
