import 'package:flutter/material.dart';
import 'package:zoovie/models/movie_model.dart';
import 'package:zoovie/widgets/box_slider.dart';
import 'package:zoovie/widgets/carousel.dart';
import 'package:zoovie/widgets/top_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<MovieModel> movies = [
    MovieModel.fromJson({
      "title": "사랑의 불시착",
      "keyword": "사랑/로맨스/판타지",
      "poster": "dummyMovie.png",
      "like": false,
    }),
    MovieModel.fromJson({
      "title": "사랑의 불시착",
      "keyword": "사랑/로맨스/판타지",
      "poster": "dummyMovie.png",
      "like": true,
    }),
    MovieModel.fromJson({
      "title": "사랑의 불시착",
      "keyword": "사랑/로맨스/판타지",
      "poster": "dummyMovie.png",
      "like": false,
    }),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff4A8D81), Color(0xff717171)],
        ),
      ),
      child: ListView(
        children: [
          Stack(
            children: [
              Carousel(movies: movies),
              const Topbar(),
            ],
          ),
          BoxSlider(movies: movies, category: "지금 뜨는 콘텐츠"),
          BoxSlider(movies: movies, category: "상영 예정중인"),
          BoxSlider(movies: movies, category: "현재 인기있는"),
          BoxSlider(movies: movies, category: "높은 평가를 받은"),
        ],
      ),
    );
  }
}
