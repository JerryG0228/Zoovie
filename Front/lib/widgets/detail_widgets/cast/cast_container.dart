import 'package:flutter/material.dart';
import 'package:zoovie/widgets/detail_widgets/cast/cast_box.dart';

class CastContainer extends StatelessWidget {
  const CastContainer({
    super.key,
    required this.mediaDetail,
  });

  final Map<String, dynamic>? mediaDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 5),
            child: Text(
              "주요 출연진",
              style: TextStyle(
                color: Color(0xff00FF99),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mediaDetail!['cast'].length,
              itemBuilder: (context, index) {
                final castMember = mediaDetail!['cast'][index];
                return CastBox(castMember: castMember);
              },
            ),
          ),
        ],
      ),
    );
  }
}
