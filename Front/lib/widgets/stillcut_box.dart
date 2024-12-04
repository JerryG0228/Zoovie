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
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 48, 48, 48),
      ),
      height: 180,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 15,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    20,
                    (index) => Container(
                          width: 8,
                          height: 15,
                          color: Colors.grey[800],
                        )),
              ),
            ),
          ),
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
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${mediaDetail!['stillcuts'][index]['file_path']}',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 15,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    20,
                    (index) => Container(
                          width: 8,
                          height: 15,
                          color: Colors.grey[800],
                        )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
