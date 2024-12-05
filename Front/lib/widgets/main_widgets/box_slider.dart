import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zoovie/models/media_model.dart';
import 'package:zoovie/screens/more_page.dart';
import 'package:zoovie/widgets/main_widgets/movie_box.dart';

class BoxSlider extends StatelessWidget {
  final List<MediaModel> medias;
  final String category;
  final String contentType;

  const BoxSlider({
    super.key,
    required this.medias,
    required this.category,
    required this.contentType,
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
                      builder: (context) => MorePage(
                        category: category,
                        contentType: contentType,
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
