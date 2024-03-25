import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/popular_model.dart';
import 'package:flutter_application_1/network/api_actores.dart';
import 'package:flutter_application_1/network/api_favoritos.dart';
import 'package:flutter_application_1/network/api_review.dart';
import 'package:flutter_application_1/network/api_trailer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMovieScreen extends StatefulWidget {
  const DetailMovieScreen({Key? key}) : super(key: key);
  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  //variables
  late YoutubePlayerController _controller;
  bool isFavorite = false;
  final ApiFavoritos apiFavorites = ApiFavoritos();
  Key favoriteKey = UniqueKey();
  late List<Map<String, dynamic>> actores = [];
  late List<Map<String, dynamic>> review = [];
  String _error = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActores();
  }

  //metodos

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTrailer();
    _favoritos();
    _loadReview();
  }

  void _loadActores() async {
    await Future.delayed(Duration(seconds: 5));

    final popularModel =
        // ignore: use_build_context_synchronously
        ModalRoute.of(context)!.settings.arguments as PopularModel;
    final actoresMovie = ApiActores();

    try {
      final actoresData = await actoresMovie.getActores(popularModel.id!);
      if (actoresData != null) {
        setState(() {
          actores = actoresData;
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void _loadReview() async {
    await Future.delayed(Duration(seconds: 5));

    final popularModel =
        // ignore: use_build_context_synchronously
        ModalRoute.of(context)!.settings.arguments as PopularModel;
    final reviewMovies = ApiReview();

    try {
      final reviewData = await reviewMovies.getReview(popularModel.id!);
      if (reviewData != null) {
        setState(() {
          review = reviewData;
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //cargar trailer
  void _loadTrailer() async {
    final popularModel =
        ModalRoute.of(context)!.settings.arguments as PopularModel;
    final movieTrailer = ApiTrailer();

    try {
      final trailers = await movieTrailer.movieTrailer(popularModel.id!);
      if (trailers!.isNotEmpty) {
        final trailerId = YoutubePlayer.convertUrlToId(trailers[0]);
        if (trailerId != null) {
          setState(() {
            _controller = YoutubePlayerController(
              initialVideoId: trailerId,
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
              ),
            );
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error cargando el trailer: $e');
    }
  }

  //añadir y revisar favoritos
  void _btnFavorito() async {
    final popularModel =
        ModalRoute.of(context)!.settings.arguments as PopularModel;
    try {
      if (isFavorite) {
        await apiFavorites.removeFromFavorites(popularModel.id!);
      } else {
        await apiFavorites.addToFavorites(popularModel.id!);
      }
      _favoritos();
      setState(() {
        favoriteKey = UniqueKey();
      });
    } catch (e) {
      _error = 'error al agregar o eliminar de favoritos';
      print(_error);
    }
  }

  Future<bool> _favoritos() async {
    final popularModel =
        ModalRoute.of(context)!.settings.arguments as PopularModel;
    try {
      final favoriteMovies = await apiFavorites.getFavoritos();
      isFavorite =
          favoriteMovies.any((movie) => movie['id'] == popularModel.id);
      return isFavorite;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the PopularModel from the route arguments
    final popularModel =
        ModalRoute.of(context)!.settings.arguments as PopularModel;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 46, 43, 43),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          FutureBuilder(
            future: _favoritos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return FavoriteButton(
                  iconSize: 45,
                  isFavorite: isFavorite,
                  iconColor: Colors.red,
                  valueChanged: (isFavorite) {
                    _btnFavorito();
                  },
                );
              }
            },
          )
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 46, 43, 43),
      body: Column(
        children: [
          Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Hero(
                    tag: 'poster_${popularModel.id}',
                    child: Container(
                      height: 450,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            alignment: FractionalOffset.topCenter,
                            image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500/${popularModel.posterPath}'
                                    .replaceAll("w185", "w400"))),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 350,
                      child: Container(
                        width: _width,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: const [0.1, 0.3, 0.5, 0.7, 0.9],
                            colors: [
                              const Color.fromARGB(255, 46, 43, 43)
                                  .withOpacity(0.01),
                              const Color.fromARGB(255, 46, 43, 43)
                                  .withOpacity(0.25),
                              const Color.fromARGB(255, 46, 43, 43)
                                  .withOpacity(0.8),
                              const Color.fromARGB(255, 46, 43, 43)
                                  .withOpacity(0.95),
                              const Color.fromARGB(255, 46, 43, 43)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      )),
                  Positioned(
                    left: 20,
                    top: 390,
                    right: 20,
                    bottom: 20,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            popularModel.title!,
                            style: const TextStyle(
                                fontFamily: 'Milker',
                                color: Colors.white,
                                fontSize: 30,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w900),
                          ),
                        ]),
                  ),
                  Positioned(
                    left: 35,
                    top: 485,
                    right: 35,
                    child: Container(
                      width: _width - 40,
                      height: 1,
                      color: const Color.fromARGB(255, 100, 96, 96),
                    ),
                  ),
                ],
              )),
          Expanded(
            flex: 3,
            child: Container(
              color: const Color.fromARGB(255, 46, 43, 43),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        width: _width,
                        height: 130,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: (_width - 40) / 2,
                                  height: 100,
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          popularModel.popularity.toString(),
                                          style: const TextStyle(
                                            fontFamily: 'Tommy',
                                            decoration: TextDecoration.none,
                                            color: Color.fromARGB(
                                                255, 201, 107, 107),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28,
                                          ),
                                        ),
                                        const Text(
                                          'Popularidad',
                                          style: TextStyle(
                                            fontFamily: 'Tommy',
                                            decoration: TextDecoration.none,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: (_width - 40) / 2,
                                  height: 100,
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(popularModel.voteCount!.toString(),
                                            style: const TextStyle(
                                              fontFamily: 'Tommy',
                                              fontStyle: FontStyle.normal,
                                              decoration: TextDecoration.none,
                                              color: Color.fromARGB(
                                                  255, 87, 103, 170),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                            )),
                                        const Text('Total de votos',
                                            style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: 'Tommy',
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        width: _width - 40,
                        child: Column(
                          children: [
                            SizedBox(
                              width: (_width - 40),
                              height: 100,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RatingBar.builder(
                                      minRating: 0,
                                      allowHalfRating: true,
                                      itemSize: 30,
                                      itemCount: 10,
                                      initialRating: customRound(
                                          popularModel.voteAverage!),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                      onRatingUpdate: (rating) {},
                                      ignoreGestures: true,
                                    ),
                                    Text(
                                      popularModel.voteAverage!
                                          .toStringAsFixed(2)
                                          .toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Tommy',
                                          decoration: TextDecoration.none,
                                          fontSize: 15,
                                          color: Color.fromARGB(
                                              255, 77, 154, 101)),
                                    ),
                                    const Text(
                                      'Rating',
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontFamily: 'Tommy',
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: _width - 40,
                        height: 1,
                        color: const Color.fromARGB(255, 100, 96, 96),
                      ),
                      SizedBox(
                        width: _width - 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Sinopsis',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Tommy',
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 197, 168, 122)),
                            ),
                            Text(
                              popularModel.overview!,
                              style: const TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Tommy',
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: _width - 40,
                              height: 1,
                              color: const Color.fromARGB(255, 100, 96, 96),
                            ),
                            SizedBox(height: 10),
                            const Text(
                              'Tráiler',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Tommy',
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 197, 168, 122)),
                            ),
                            SizedBox(height: 10),
                            isLoading
                                ? CircularProgressIndicator()
                                : _controller != null
                                    ? YoutubePlayer(
                                        controller: _controller,
                                        showVideoProgressIndicator: true,
                                      )
                                    : Text('No se encontró ningún trailer'),
                            SizedBox(height: 10),
                            Container(
                              width: _width - 40,
                              height: 1,
                              color: const Color.fromARGB(255, 100, 96, 96),
                            ),
                            SizedBox(height: 10),
                            const Text(
                              'Elenco',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Tommy',
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 197, 168, 122)),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 150,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: actores.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(left: 20.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(10.0),
                                            width: 60,
                                            height: 60,
                                            child: ClipOval(
                                              child: actores[index]
                                                          ['profile_path'] !=
                                                      null
                                                  ? Image.network(
                                                      'https://image.tmdb.org/t/p/w500/${actores[index]['profile_path']}',
                                                      width: 80,
                                                      height: 80,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      'https://cdn-icons-png.flaticon.com/512/1753/1753460.png',
                                                      width: 80,
                                                      height: 80,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            actores[index]['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            actores[index]['character'],
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: _width - 40,
                              height: 1,
                              color: const Color.fromARGB(255, 100, 96, 96),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Reseñas',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Tommy',
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 197, 168, 122)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 300,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: review.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(left: 20.0),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 5),
                                          Text(
                                            review[index]['author_details']
                                                ['username'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: 'Tommy',
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(8.0),
                                            width: 120,
                                            height: 120,
                                            child: ClipOval(
                                              child: review[index]
                                                              ['author_details']
                                                          ['avatar_path'] !=
                                                      null
                                                  ? Image.network(
                                                      'https://image.tmdb.org/t/p/w500${review[index]['author_details']['avatar_path']}',
                                                      width: 80,
                                                      height: 80,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      'https://icones.pro/wp-content/uploads/2021/02/icone-utilisateur-gris.png',
                                                      width: 80,
                                                      height: 80,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Container(
                                            width: 150,
                                            height: 70,
                                            child: Text(
                                              review[index]['content'],
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontFamily: 'Tommy',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            width: 150,
                                            height: 20,
                                            child: review[index]
                                                            ['author_details']
                                                        ['rating'] !=
                                                    null
                                                ? RatingBar.builder(
                                                    minRating: 0,
                                                    allowHalfRating: true,
                                                    itemSize: 13,
                                                    itemCount: 10,
                                                    initialRating: review[index]
                                                            ['author_details']
                                                        ['rating'],
                                                    itemBuilder: (context, _) =>
                                                        const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                      size: 20,
                                                    ),
                                                    onRatingUpdate: (rating) {},
                                                    ignoreGestures: true,
                                                  )
                                                : const Text(
                                                    'No se asignó',
                                                    style: TextStyle(
                                                        fontFamily: 'Tommy',
                                                        fontSize: 13,
                                                        color: Colors.white),
                                                  ),
                                          ),
                                          Container(
                                            child: review[index]
                                                        ['created_at'] !=
                                                    null
                                                ? Text(
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(DateTime.parse(
                                                            review[index][
                                                                'created_at'])),
                                                    style: const TextStyle(
                                                        fontFamily: 'Tommy',
                                                        fontSize: 13,
                                                        color: Colors.white))
                                                : const Text(
                                                    'No se tiene fecha registrada',
                                                    style: TextStyle(
                                                        fontFamily: 'Tommy',
                                                        fontSize: 13,
                                                        color: Colors.white)),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }
}

double customRound(double value) {
  if (value >= 0.01 && value <= 0.25) {
    return value.floorToDouble();
  } else if (value >= 0.76 && value <= 0.99) {
    return (value + 1).floorToDouble();
  } else {
    return (value * 2).roundToDouble() / 2;
  }
}
