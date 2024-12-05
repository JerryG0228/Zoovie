import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:zoovie/controllers/user_controller.dart';
import 'package:zoovie/models/media_model.dart';
import 'package:zoovie/screens/detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:zoovie/widgets/bookmark_btn.dart';

class Carousel extends StatefulWidget {
  final List<MediaModel> medias;
  final String contentType;
  const Carousel({super.key, required this.medias, required this.contentType});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late List<MediaModel> medias;
  late List<Widget> images;
  late List<String> keywords;
  late List<bool> bookmarks;
  int _currPage = 0;

  @override
  void initState() {
    super.initState();
    medias = widget.medias;
    images = medias
        .map((m) => Image.network(
              m.posterPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                    child: Text('이미지를 불러올 수 없습니다',
                        style: TextStyle(color: Colors.white)));
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: SizedBox(
                    width: 115,
                    height: 115,
                    child: Transform.scale(
                      scale: 2.0,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                );
              },
            ))
        .toList();
    keywords = medias.map((m) => m.title).toList();
    for (var media in medias) {
      media.mediaType = widget.contentType;
    }
    bookmarks = medias
        .map((m) =>
            Get.find<UserController>()
                .user
                ?.bookmarked[widget.contentType]
                ?.contains(m.id.toString()) ??
            false)
        .toList();
  }

  void toggleBookmark() async {
    final mediaId = medias[_currPage].id;
    final username = Get.find<UserController>().user?.username;

    final url = bookmarks[_currPage]
        ? 'http://127.0.0.1:5000/${medias[_currPage].mediaType}/cancelBookmark'
        : 'http://127.0.0.1:5000/${medias[_currPage].mediaType}/bookmark';

    try {
      final response = await Dio().post(
        url,
        data: {
          'username': username,
          'item_id': mediaId.toString(),
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          bookmarks[_currPage] = !bookmarks[_currPage];
          medias[_currPage].bookmark = bookmarks[_currPage];
          Get.find<UserController>()
              .toggleBookmark(mediaId.toString(), medias[_currPage].mediaType);
        });
      }
    } catch (e) {
      printError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(40),
        ),
        CarouselSlider(
          items: images
              .map((image) => Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: image,
                        ),
                      ),
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
            height: 360,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            viewportFraction: 0.7,
            onPageChanged: (index, reason) => setState(() {
              _currPage = index;
            }),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 3),
          child: const Text(""),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: toggleBookmark,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: Column(
                children: [
                  Icon(
                    bookmarks[_currPage]
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "북마크",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                width: 130,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: EdgeInsets.all(3),
                        ),
                        Text(
                          "재생",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                medias[_currPage].mediaType = widget.contentType;
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) {
                      return DetailScreen(
                        media: medias[_currPage],
                      );
                    }));
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "정보",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: makeIndicator(bookmarks, _currPage),
        )
      ],
    );
  }
}

List<Widget> makeIndicator(List list, int _currPage) {
  List<Widget> results = [];

  for (var i = 0; i < list.length; i++) {
    results.add(Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currPage == i
            ? const Color.fromRGBO(255, 255, 255, 0.9)
            : const Color.fromRGBO(255, 255, 255, 0.4),
      ),
    ));
  }

  return results;
}
