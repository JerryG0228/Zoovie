import 'package:dio/dio.dart';
import '../models/media_model.dart';

class ContentDataLoader {
  final Dio dio;
  final Function(List<MediaModel>, List<MediaModel>, List<MediaModel>,
      List<MediaModel>) onDataLoaded;

  ContentDataLoader({
    required this.dio,
    required this.onDataLoaded,
  });

  Future<void> loadData({required String contentType}) async {
    try {
      final response =
          await dio.get('http://127.0.0.1:5000/media/$contentType/loaddatas');
      final data = response.data;

      final nowPlayingContents = (data['nowPlaying'] as List)
          .map((content) => MediaModel.fromJson(content))
          .toList();
      final popularContents = (data['popular'] as List)
          .map((content) => MediaModel.fromJson(content))
          .toList();
      final topRatedContents = (data['topRated'] as List)
          .map((content) => MediaModel.fromJson(content))
          .toList();
      final upcomingContents = (data['upcoming'] as List)
          .map((content) => MediaModel.fromJson(content))
          .toList();

      onDataLoaded(
        nowPlayingContents,
        popularContents,
        topRatedContents,
        upcomingContents,
      );
    } catch (e) {
      print('Error loading $contentType data: $e');
    }
  }
}
