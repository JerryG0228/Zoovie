import 'package:flutter/material.dart';
import 'package:zoovie/models/media_model.dart';
import 'package:zoovie/screens/detail_screen.dart';

class MovieBox extends StatelessWidget {
  final MediaModel media;
  final String contentType;
  const MovieBox({
    super.key,
    required this.media,
    required this.contentType,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        media.mediaType = contentType;
        Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return DetailScreen(media: media);
            }));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Align(
          alignment: Alignment.center,
          child: Image.network(
            media.posterPath,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                  child: Text('이미지를 불러올 수 없습니다',
                      style: TextStyle(color: Colors.white)));
            },
          ),
        ),
      ),
    );
  }
}
