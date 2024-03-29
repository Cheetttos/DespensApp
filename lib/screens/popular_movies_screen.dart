import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/popular_model.dart';
import 'package:flutter_application_1/network/api_popular.dart';

class PopularMoviesScreen extends StatefulWidget {
  const PopularMoviesScreen({super.key});

  @override
  State<PopularMoviesScreen> createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> {
  ApiPopular? apiPopular;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 46, 43, 43),
          title: Text(
            "Peliculas",
            style: TextStyle(color: Colors.white, fontFamily: 'Tommy'),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favorites');
              },
              child: Container(
                child: const Text('Ver favoritos',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Tommy',
                    )),
              ),
            )
          ],
        ),
        body: FutureBuilder(
          future: apiPopular!.getPopularMovie(),
          builder: (context, AsyncSnapshot<List<PopularModel>?> snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .7,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/detail",
                        arguments: snapshot.data![index]),
                    child: FadeInImage(
                      placeholder: const AssetImage('images/login.gif'),
                      image: NetworkImage(
                          "https://image.tmdb.org/t/p/w500/${snapshot.data![index].posterPath}"),
                    ),
                  );
                },
              );
            } else {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Ocurrio un error :"),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          },
        ));
  }
}
