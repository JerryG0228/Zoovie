import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zoovie/models/media_model.dart';
import 'package:zoovie/widgets/platform_box.dart';
import 'package:dio/dio.dart';

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

  Future<Map<String, dynamic>?> fetchmediaDetail() async {
    try {
      final response = await dio.get(
          'http://127.0.0.1:5000/getdatabyid/${widget.media.mediaType}/${widget.media.id}');
      return response.data;
    } catch (e) {
      print('Error fetching media detail: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    bookmark = widget.media.bookmark;
    movieId = widget.media.id;
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
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.black.withOpacity(0.1),
                              child: Column(
                                children: [
                                  const SizedBox(height: 45),
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 45, 0, 10),
                                    height: 300,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      clipBehavior: Clip.none,
                                      children: [
                                        mediaDetail?['poster_path'] != null
                                            ? Image.network(
                                                mediaDetail!['poster_path'],
                                                fit: BoxFit.contain,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Color(0xff00FF99),
                                                    ),
                                                  );
                                                },
                                              )
                                            : const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Color(0xff00FF99),
                                                ),
                                              ),
                                        Positioned(
                                          top: 270,
                                          child: mediaDetail?['logo_path'] !=
                                                  null
                                              ? Image.network(
                                                  mediaDetail!['logo_path'],
                                                  height: 80,
                                                  fit: BoxFit.contain,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color:
                                                            Color(0xff00FF99),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Column(
                                                  children: [
                                                    const SizedBox(height: 30),
                                                    Text(
                                                      mediaDetail != null
                                                          ? (widget.media
                                                                      .mediaType ==
                                                                  'movie'
                                                              ? mediaDetail![
                                                                      'title'] ??
                                                                  '제목 없음'
                                                              : mediaDetail![
                                                                      'name'] ??
                                                                  '이름 없음')
                                                          : '정보 없음',
                                                      style: const TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 110),
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 280,
                                          height: 45,
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              mediaDetail?['keywords'] !=
                                                          null &&
                                                      mediaDetail!['keywords']
                                                          .isNotEmpty
                                                  ? (mediaDetail!['keywords']
                                                          as List)
                                                      .map((keyword) =>
                                                          keyword['name'])
                                                      .take(3)
                                                      .join(', ')
                                                  : "키워드 없음",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 30),
                                        Container(
                                          width: 45,
                                          height: 45,
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                bookmark = !bookmark;
                                              });
                                            },
                                            icon: Icon(
                                              bookmark
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_outline,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: AppBar(
                          leading: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Color(0xff00FF99),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                      )
                    ],
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
                        Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PlatformBox(
                                      platforms: mediaDetail?['platforms'] ??
                                          ["플랫폼1", "플랫폼2", "플랫폼3", "플랫폼4"]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
