import 'package:flutter/material.dart';

class PlatformBox extends StatelessWidget {
  final String logoPath;
  final String providerName;

  const PlatformBox({
    super.key,
    required this.logoPath,
    required this.providerName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 110,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              logoPath,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            providerName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
