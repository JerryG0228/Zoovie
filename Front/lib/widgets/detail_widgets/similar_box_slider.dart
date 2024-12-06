import 'package:flutter/material.dart';
import 'package:zoovie/models/media_model.dart';
import 'package:zoovie/screens/similar_more_page.dart';
import 'package:zoovie/widgets/main_widgets/movie_box.dart';

class SimilarBoxSlider extends StatelessWidget {
  final List<MediaModel> medias;
  final String category;
  final String contentType;
  final int id;

  const SimilarBoxSlider({
    super.key,
    required this.medias,
    required this.category,
    required this.contentType,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SimilarMorePage(
                        category: category,
                        contentType: contentType,
                        id: id,
                      ),
                    ),
                  );
                },
                child: const Text(
                  '더보기',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff00FF99),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemCount: medias.length,
              itemBuilder: (context, index) => MovieBox(
                media: medias[index],
                contentType: contentType,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
