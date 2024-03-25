import 'package:dio/dio.dart';

class ApiReview {
  final dio = Dio();
  List<Map<String, dynamic>> review = [];
  Future<List<Map<String, dynamic>>?> getReview(movieId) async {
    try {
      Response response =
          await dio.get("https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=4a4ae5808139f17b7ecdd1a24413ccf5");
      if (response.statusCode == 200) {
        review = List<Map<String, dynamic>>.from(response.data['results']);
        
      } else {
        return null;
      }
      return review;
    } catch (e) {
      throw Exception('Error al obtener los actores $e');
    }
  }
}
