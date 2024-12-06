import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  const Overview({
    super.key,
    required this.mediaDetail,
  });

  final Map<String, dynamic>? mediaDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Text(
        mediaDetail?['overview'] ?? '추후 줄거리 추가 예정',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }
}
