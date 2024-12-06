import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zoovie/widgets/bookmark_widgets/bookmark_btn.dart';

Column detailPoster({
  required Map<String, dynamic>? mediaDetail,
  required bool bookmark,
  required VoidCallback toggleBookmark,
}) {
  return Column(
    children: [
      const SizedBox(height: 45),
      Container(
        padding: const EdgeInsets.fromLTRB(0, 45, 0, 10),
        height: 300,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
            mediaDetail?['poster_path'] != null
                ? Image.network(
                    mediaDetail!['poster_path'],
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff00FF99),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff00FF99),
                    ),
                  ),
            Positioned(
              top: 270,
              child: mediaDetail?['logo_path'] != null
                  ? Image.network(
                      mediaDetail!['logo_path'],
                      width: 350,
                      height: 80,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff00FF99),
                          ),
                        );
                      },
                    )
                  : SizedBox(
                      width: 350,
                      height: 120,
                      child: Column(
                        children: [
                          Text(
                            mediaDetail != null
                                ? (mediaDetail['title'] ??
                                    mediaDetail['name'] ??
                                    '정보 없음')
                                : '정보 없음',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 110),
      Container(
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 280,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  mediaDetail?['keywords'] != null &&
                          mediaDetail!['keywords'].isNotEmpty
                      ? (mediaDetail['keywords'] as List)
                          .map((keyword) => keyword['name'])
                          .take(4)
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
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ToggleBookmarkButton(
                isBookmarked: bookmark,
                onToggle: toggleBookmark,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
