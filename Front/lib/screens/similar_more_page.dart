import 'package:flutter/material.dart';
import 'package:zoovie/models/media_model.dart';
import 'package:zoovie/widgets/main_widgets/movie_box.dart';
import 'package:dio/dio.dart';

class SimilarMorePage extends StatefulWidget {
  final String category;
  final String contentType;
  final int id;

  const SimilarMorePage(
      {super.key,
      required this.category,
      required this.contentType,
      required this.id});

  @override
  State<SimilarMorePage> createState() => _MorePageState();
}

class _MorePageState extends State<SimilarMorePage> {
  final List<MediaModel> medias = [];
  bool isLoading = true;
  final dio = Dio();
  late final String option;
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    loadMoreData();
    _scrollController.addListener(_onScroll);
  }

  Future<void> loadMoreData() async {
    try {
      final response = await dio.get(
          'http://127.0.0.1:5000/similar/${widget.contentType}/${widget.id}/$currentPage');

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data;
        setState(() {
          medias.addAll(
            results.map((item) => MediaModel.fromJson(item)).toList(),
          );
          currentPage++;
          isLoading = false;
        });
      }
    } catch (e) {
      print('데이터 로드 중 오류 발생: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMoreData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: const Color(0xFF4A8D81),
        iconTheme: const IconThemeData(color: Color(0xff00FF99)),
        elevation: 10,
        shadowColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A8D81),
              Color(0xFF717171),
            ],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: isLoading && medias.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff00FF99),
                  ),
                )
              : CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Center(
                        child: medias.isNotEmpty
                            ? Stack(
                                children: [
                                  Column(
                                    children: [
                                      MovieBox(
                                        media: medias[0],
                                        contentType: widget.contentType,
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                  Positioned(
                                    left: 8,
                                    bottom: 28,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        medias[0].title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                    SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final actualIndex = index + 1;
                          if (actualIndex < medias.length) {
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: MovieBox(
                                    media: medias[actualIndex],
                                    contentType: widget.contentType,
                                  ),
                                ),
                                Positioned(
                                  left: 18,
                                  bottom: 5,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      medias[actualIndex].title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xff00FF99),
                              ),
                            );
                          }
                          return null;
                        },
                        childCount:
                            isLoading ? medias.length : medias.length - 1,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        mainAxisSpacing: 20,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
