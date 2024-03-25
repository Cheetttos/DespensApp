import 'package:flutter/material.dart';
import 'package:flutter_application_1/network/api_favoritos.dart';

class FavoriteMovieScreen extends StatefulWidget {
  const FavoriteMovieScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteMovieScreen> createState() => _FavoriteMovieScreenState();
}

class _FavoriteMovieScreenState extends State<FavoriteMovieScreen> {
  late Future<List<Map<String, dynamic>>> futureFavoritos;

  @override
  void initState() {
    super.initState();
    futureFavoritos = ApiFavoritos().getFavoritos();
    print(futureFavoritos = ApiFavoritos().getFavoritos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 46, 43, 43),
        title: const Text(
          "Mis favoritos",
          style: TextStyle(color: Colors.white, fontFamily: 'Tommy'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureFavoritos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Ocurrió un error: ${snapshot.error}"),
            );
          } else {
            List<Map<String, dynamic>> favoritos = snapshot.data ?? [];
            return GridView.builder(
              itemCount: favoritos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Aquí puedes hacer algo con el elemento seleccionado
                  },
                  child: FadeInImage(
                    placeholder: const AssetImage('images/login.gif'),
                    image: NetworkImage(
                      "https://image.tmdb.org/t/p/w500/${favoritos[index]['poster_path']}",
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
