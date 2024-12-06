import 'package:flutter/material.dart';
import 'package:zoovie/screens/detail_screen.dart';

class DetailTop extends StatelessWidget {
  const DetailTop({
    super.key,
    required this.mediaDetail,
    required this.widget,
  });

  final Map<String, dynamic>? mediaDetail;
  final DetailScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: List.generate(
              5,
              (index) {
                final double rating = (mediaDetail?['vote_average'] ?? 0) / 2;
                if (index < rating.floor()) {
                  return const Icon(
                    Icons.star,
                    color: Color(0xff00FF99),
                    size: 35,
                  );
                } else if (index == rating.floor() && rating % 1 > 0) {
                  return const Icon(
                    Icons.star_half,
                    color: Color(0xff00FF99),
                    size: 35,
                  );
                } else {
                  return const Icon(
                    Icons.star_border,
                    color: Color(0xff00FF99),
                    size: 35,
                  );
                }
              },
            ),
          ),
          if (widget.media.mediaType == 'tv')
            Text(
              "시즌 ${mediaDetail?['seasons'].length ?? 0}개",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 20,
              ),
            )
          else
            Text(
              mediaDetail?['runtime'] != null
                  ? "${(mediaDetail!['runtime'] ~/ 60)}시간 ${mediaDetail!['runtime'] % 60}분"
                  : "0분",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 20,
              ),
            ),
        ],
      ),
    );
  }
}
