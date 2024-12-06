import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoovie/models/media_model.dart';
import 'package:zoovie/screens/detail_screen.dart';

Widget ScrapBox(String type, List<dynamic> mediaIds) {
  Future<Map<String, dynamic>?> fetchMediaData(String media, String id) async {
    try {
      final response =
          await Dio().get('http://127.0.0.1:5000/getdatabyid/$media/$id');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load media data: $e');
    }
  }

  return FutureBuilder<List<Map<String, dynamic>?>>(
    future:
        Future.wait(mediaIds.map((id) => fetchMediaData(type, id.toString()))),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xff00FF99),
          ),
        );
      }

      if (snapshot.hasError || snapshot.data == null) {
        return Center(
          child: Text('오류 발생: ${snapshot.error ?? "데이터가 없습니다"}'),
        );
      }

      final mediaDataList = snapshot.data!;
      final mediaList =
          mediaDataList.map((data) => MediaModel.fromJson(data!)).toList();

      return mediaList.isEmpty
          ? const Center(
              child: Text(
              '북마크된 컨텐츠가 없습니다.',
              style: TextStyle(color: Colors.white),
            ))
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: mediaList.length,
              itemBuilder: (context, index) {
                final media = mediaList[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (BuildContext context) {
                          return DetailScreen(
                            media: media,
                          );
                        }));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: media.posterPath.isEmpty
                          ? const Center(
                              child: Icon(Icons.image_not_supported),
                            )
                          : Image.network(
                              media.posterPath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Icon(Icons.error)),
                            ),
                    ),
                  ),
                );
              },
            );
    },
  );
}
