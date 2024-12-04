import 'package:flutter/material.dart';

class CastBox extends StatelessWidget {
  const CastBox({
    super.key,
    required this.castMember,
  });

  final dynamic castMember;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              castMember['profile_path'] ?? 'assets/images/user.png',
            ),
          ),
          const SizedBox(height: 5),
          Text(
            castMember['name'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            castMember['character'],
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
