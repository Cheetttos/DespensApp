import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/model/popular_model.dart';

class ApiFavoritos {
  final String apiKey = '4a4ae5808139f17b7ecdd1a24413ccf5';
  final String sessionId = 'f360978955a499bf481e5df6d86998c02aafc122';
  final String account_id = '21050744';

  final StreamController<void> _updateController =
      StreamController<void>.broadcast();

  Stream<void> get updateStream => _updateController.stream;

  void dispose() {
    _updateController.close();
  }

  final dio = Dio();

  Future<List<PopularModel>?> getFavorito() async {
    Response response = await dio.get(
      'https://api.themoviedb.org/3/account/$account_id/favorite/movies',
      queryParameters: {
        'api_key': apiKey,
        'session_id': sessionId,
      },
    );

    if (response.statusCode == 200) {
      final listMoviesMap = response.data['results'] as List;
      return listMoviesMap.map((movie) => PopularModel.fromMap(movie)).toList();
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getFavoritos() async {
    try {
      final response = await dio.get(
        'https://api.themoviedb.org/3/account/$account_id/favorite/movies',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> favoriteMovies =
            List<Map<String, dynamic>>.from(response.data['results']);
            print(favoriteMovies);
        return favoriteMovies;
      } else {
        throw Exception('Failed to retrieve favorite movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addToFavorites(int movieId) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://api.themoviedb.org/3/account/$account_id/favorite',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': true,
        },
      );

      if (response.statusCode == 200) {
        _updateController.add(null);
      } else {}
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> removeFromFavorites(int movieId) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://api.themoviedb.org/3/account/$account_id/favorite',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': false,
        },
      );

      if (response.statusCode == 200) {
        _updateController.add(null); // Emitir un evento de actualización
      } else {
        throw Exception('Error al eliminar la película de favoritos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<PopularModel?> getMovieDetails(int movieId) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&language=es',
      );

      if (response.statusCode == 200) {
        return PopularModel.fromMap(response.data);
      } else {
        throw Exception('Failed to retrieve movie details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
