import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zoovie/widgets/bookmark_widgets/bookmark_box.dart';
import '../controllers/user_controller.dart';

class BookmarkPage extends GetView<UserController> {
  const BookmarkPage({super.key});

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
                ScrapBox('movie', movieBookmarks),
                ScrapBox('tv', tvBookmarks),
              ],
            );
          }),
        ),
      ),
    );
  }
}
