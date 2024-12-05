import 'package:flutter/material.dart';

class StillcutBox extends StatelessWidget {
  const StillcutBox({
    super.key,
    required this.mediaDetail,
  });

  final Map<String, dynamic>? mediaDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            bottom: 15,
            left: 0,
            right: 0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mediaDetail!['stillcuts'].length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${mediaDetail!['stillcuts'][index]['file_path']}',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
