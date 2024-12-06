import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoovie/models/media_model.dart';
import 'package:zoovie/widgets/main_widgets/youtube_player.dart';

class VideoBtn extends StatelessWidget {
  final MediaModel media;

  const VideoBtn({
    super.key,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final mediaId = media.id;
        final mediaType = media.mediaType;

        try {
          final response = await Dio().get(
            'http://127.0.0.1:5000/video/$mediaType/$mediaId',
          );

          if (response.statusCode == 200 && response.data != null) {
            final videoUrl = response.data as String;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return YouTubePlayerScreen(videoUrl: videoUrl);
              },
            );
          } else {
            _showNoVideoDialog(context);
          }
        } catch (e) {
          _showNoVideoDialog(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_arrow,
              color: Colors.black,
            ),
            SizedBox(width: 5),
            Text(
              "관련 영상",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNoVideoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.black.withOpacity(0.9),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notification_important,
                size: 60,
                color: Colors.amber,
              ),
              SizedBox(height: 20),
              Text(
                "아직 티저 영상이 존재하지 않습니다.",
                textAlign: TextAlign.center, // 텍스트 가운데 정렬
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4A8D81), // 버튼 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글게
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "확인",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
