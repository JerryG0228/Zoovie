import 'package:flutter/material.dart';
import 'package:zoovie/models/media_model.dart';
import 'package:zoovie/widgets/movie_box.dart';

class BoxSlider extends StatelessWidget {
  final List<MediaModel> medias;
  final String category;
  const BoxSlider({
    super.key,
    required this.medias,
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
              children: medias.map((media) => MovieBox(media: media)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
