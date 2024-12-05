import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoovie/models/media_model.dart';
import '../apis/main_load_data.dart';
import '../widgets/main_widgets/box_slider.dart';
import '../widgets/main_widgets/carousel.dart';
import 'package:zoovie/widgets/top_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late ContentDataLoader contentLoader;
  final dio = Dio();
  List<MediaModel> nowPlayingContents = [];
  List<MediaModel> popularContents = [];
  List<MediaModel> topRatedContents = [];
  List<MediaModel> upcomingContents = [];
  bool isLoading = true;
  String currentContentType = 'movie';

  @override
  void initState() {
    super.initState();
    contentLoader = ContentDataLoader(
      dio: dio,
      onDataLoaded: (nowPlaying, popular, topRated, upcoming) {
        if (!mounted) return;

        setState(() {
          nowPlayingContents = nowPlaying;
          popularContents = popular;
          topRatedContents = topRated;
          upcomingContents = upcoming;
          isLoading = false;
        });
      },
    );

    loadMovieData();
  }

  Future<void> loadMovieData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await contentLoader.loadData(contentType: 'movie');
    } catch (error) {
      print("데이터 로드 중 오류 발생: $error");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

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
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xff00FF99),
              ),
            )
          : ListView(
              children: [
                Stack(
                  children: [
                    Carousel(
                        medias: nowPlayingContents.take(5).toList(),
                        contentType: currentContentType),
                    Topbar(
                      onContentTypeChanged: (contentType) async {
                        setState(() {
                          currentContentType = contentType;
                          isLoading = true;
                        });
                        await contentLoader.loadData(contentType: contentType);
                      },
                    ),
                  ],
                ),
                BoxSlider(
                    medias: nowPlayingContents.take(10).toList(),
                    category: "지금 뜨는 콘텐츠",
                    contentType: currentContentType),
                BoxSlider(
                    medias: upcomingContents.take(10).toList(),
                    category: "상영 예정중인",
                    contentType: currentContentType),
                BoxSlider(
                    medias: popularContents.take(10).toList(),
                    category: "인기있는",
                    contentType: currentContentType),
                BoxSlider(
                    medias: topRatedContents.take(10).toList(),
                    category: "높은 평가를 받은",
                    contentType: currentContentType),
              ],
            ),
    );
  }
}
