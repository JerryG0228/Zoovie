import 'package:flutter/material.dart';
import 'package:zoovie/models/movie_model.dart';
import 'package:zoovie/screens/detail_screen.dart';

class BoxSlider extends StatelessWidget {
  final List<MovieModel> movies;
  final String category;
  const BoxSlider({
    super.key,
    required this.movies,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xff00FF99),
              shadows: [
                // 안쪽 그림자
                Shadow(
                  color: Color.fromARGB(137, 0, 255, 153),
                  blurRadius: 5,
                ),
                // 바깥쪽 그림자
                Shadow(
                  color: Color.fromARGB(83, 0, 255, 153),
                  blurRadius: 10,
                ),
                // 더 넓은 그림자
                Shadow(
                  color: Color.fromARGB(40, 0, 255, 153),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: makeBoxImages(context, movies),
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> makeBoxImages(BuildContext context, List<MovieModel> movies) {
  List<Widget> results = [];
  for (var i = 0; i < movies.length; i++) {
    results.add(
      InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) {
                return DetailScreen(
                  movie: movies[i],
                );
              }));
        },
        child: Container(
          padding: const EdgeInsets.only(right: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset("lib/assets/images/${movies[i].poster}"),
            ),
          ),
        ),
      ),
    );
  }

  return results;
}
