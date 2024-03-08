import 'package:dio/dio.dart';
import 'package:flutter_application_1/model/popular_model.dart';

class ApiPopular {
  final url =
      "https://api.themoviedb.org/3/movie/popular?api_key=4a4ae5808139f17b7ecdd1a24413ccf5&language=es-MX&page=1";
  final dio = Dio();

  Future<List<PopularModel>?> getPopularMovie() async {
    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      final listMoviesMap = response.data['results'] as List;
      return listMoviesMap.map((movie) => PopularModel.fromMap(movie)).toList();
    }
    return null;
  }
}
