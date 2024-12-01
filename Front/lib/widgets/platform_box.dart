import 'package:flutter/material.dart';

class PlatformBox extends StatelessWidget {
  final List<String> platforms;

  const PlatformBox({
    super.key,
    required this.platforms,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 15,
      runSpacing: 15,
      children: platforms.map((platform) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(platform),
          ),
        );
      }).toList(),
    );
  }
}
