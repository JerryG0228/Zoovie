import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zoovie/models/media_model.dart';
import 'package:zoovie/widgets/detail_widgets/cast/cast_container.dart';
import 'package:zoovie/widgets/detail_widgets/detail_poster.dart';
import 'package:dio/dio.dart';
import 'package:zoovie/widgets/detail_widgets/detail_top.dart';
import 'package:zoovie/widgets/detail_widgets/overview.dart';
import 'package:zoovie/widgets/detail_widgets/platform/platform_container.dart';
import 'package:zoovie/widgets/detail_widgets/stillcut_box.dart';
import 'package:get/get.dart';
import 'package:zoovie/controllers/user_controller.dart';
import 'package:zoovie/widgets/detail_widgets/similar_box_slider.dart';
import 'package:zoovie/widgets/main_widgets/video_btn.dart';

class DetailScreen extends StatefulWidget {
  final MediaModel media;
  const DetailScreen({super.key, required this.media});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool bookmark = false;
  late int movieId;
  Map<String, dynamic>? mediaDetail;
  final dio = Dio();
  List<MediaModel> similarMedias = [];

  Future<Map<String, dynamic>?> fetchmediaDetail() async {
    try {
      final response = await dio.get(
          'http://127.0.0.1:5000/media/getdatabyid/${widget.media.mediaType}/${widget.media.id}');
      return response.data;
    } catch (e) {
      print('Error fetching media detail: $e');
      return null;
    }
  }

  Future<void> fetchSimilarMedias() async {
    try {
      final response = await dio.get(
          'http://127.0.0.1:5000/search/similar/${widget.media.mediaType}/${widget.media.id}/1');
      if (response.statusCode == 200) {
        similarMedias = (response.data as List)
            .map((media) => MediaModel.fromJson(media))
            .toList();
      }
    } catch (e) {
      print('Error fetching similar medias: $e');
    }
  }

  void toggleBookmark() async {
    final mediaId = widget.media.id;
    final username = Get.find<UserController>().user?.username;

    final url = bookmark
        ? 'http://127.0.0.1:5000/user/${widget.media.mediaType}/cancelBookmark'
        : 'http://127.0.0.1:5000/user/${widget.media.mediaType}/bookmark';

    try {
      final response = await dio.post(
        url,
        data: {
          'username': username,
          'item_id': mediaId.toString(),
        },
      );

      if (response.statusCode == 200) {
        bookmark = !bookmark;
        widget.media.bookmark = bookmark;
        Get.find<UserController>()
            .toggleBookmark(mediaId.toString(), widget.media.mediaType);
        setState(() {});
      }
    } catch (e) {
      print('Error toggling bookmark: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    bookmark = widget.media.bookmark ||
        (Get.find<UserController>()
                .user
                ?.bookmarked[widget.media.mediaType]
                ?.contains(widget.media.id.toString()) ??
            false);
    movieId = widget.media.id;
    fetchSimilarMedias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchmediaDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff4A8D81), Color(0xff717171)],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff00FF99),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('데이터를 불러올 수 없습니다.'),
            );
          } else {
            mediaDetail = snapshot.data;
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff4A8D81), Color(0xff717171)],
                ),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.maxFinite,
                        decoration: mediaDetail?['poster_path'] != null
                            ? BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      NetworkImage(mediaDetail!['poster_path']),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : null,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.black.withOpacity(0.2),
                              child: detailPoster(
                                mediaDetail: mediaDetail,
                                bookmark: bookmark,
                                toggleBookmark: toggleBookmark,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 80,
                        left: 10,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 비디오 버튼 컨테이너
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 130),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        // 중앙 정렬 추가
                        child: VideoBtn(media: widget.media),
                      ),
                    ),
                  ),

                  DetailTop(
                      mediaDetail: mediaDetail,
                      widget: widget), // 별점, 런타임, 시즌 수

                  if (mediaDetail?['stillcuts'] != null && // 스틸컷
                      mediaDetail!['stillcuts'].isNotEmpty)
                    StillcutBox(mediaDetail: mediaDetail),

                  Overview(mediaDetail: mediaDetail), // 줄거리
                  if (mediaDetail?['cast'] != null &&
                      mediaDetail!['cast'].isNotEmpty)
                    CastContainer(mediaDetail: mediaDetail), // 캐스팅 배우

                  SimilarBoxSlider(
                    // 비슷한 영화
                    medias: similarMedias,
                    category: widget.media.mediaType == 'movie'
                        ? '비슷한 영화'
                        : '비슷한 시리즈 & TV프로그램',
                    contentType: widget.media.mediaType,
                    id: mediaDetail?['id'],
                  ),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                    child: Text(
                      "스트리밍 플랫폼",
                      style: TextStyle(
                        color: Color(0xff00FF99),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 49, 49, 49),
                          Color.fromARGB(255, 68, 68, 68),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 120,
                          child: Column(
                            children: [
                              platformContainer(mediaDetail: mediaDetail),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
