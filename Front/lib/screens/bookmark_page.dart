import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:zoovie/models/media_model.dart';
import 'package:zoovie/screens/detail_screen.dart';
import '../controllers/user_controller.dart';

class BookmarkPage extends GetView<UserController> {
  const BookmarkPage({super.key});

  Future<Map<String, dynamic>?> fetchMediaData(String media, String id) async {
    try {
      final response =
          await Dio().get('http://127.0.0.1:5000/getdatabyid/$media/$id');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load media data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff4A8D81), Color(0xff717171)],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: const Color(0xff4A8D81),
            bottom: const TabBar(
              labelStyle: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              indicatorColor: Color(0xff00FF99),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              tabs: [
                Tab(text: '영화'),
                Tab(text: '시리즈 & TV 프로그램'),
              ],
            ),
          ),
          body: Obx(() {
            final userBookmarks = controller.user?.bookmarked;
            print('사용자 북마크: $userBookmarks');

            if (userBookmarks == null || userBookmarks.isEmpty) {
              return const Center(child: Text('북마크 데이터를 불러올 수 없습니다.'));
            }

            List<dynamic> movieBookmarks = userBookmarks['movie'] ?? [];
            List<dynamic> tvBookmarks = userBookmarks['tv'] ?? [];

            return TabBarView(
              children: [
                _buildMediaList('movie', movieBookmarks),
                _buildMediaList('tv', tvBookmarks),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMediaList(String type, List<dynamic> mediaIds) {
    return FutureBuilder<List<Map<String, dynamic>?>>(
      future: Future.wait(
          mediaIds.map((id) => fetchMediaData(type, id.toString()))),
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
            ? const Center(child: Text('북마크된 컨텐츠가 없습니다.'))
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
}
