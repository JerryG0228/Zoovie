import 'package:flutter/material.dart';

class Topbar extends StatelessWidget {
  final Function(String) onContentTypeChanged;

  const Topbar({
    super.key,
    required this.onContentTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 7, 20, 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            "lib/assets/images/logo.png",
            fit: BoxFit.contain,
            height: 50,
          ),
          const SizedBox(width: 30),
          TextButton(
            onPressed: () => onContentTypeChanged('movie'),
            child: const Text(
              "영화",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 15),
          TextButton(
            onPressed: () => onContentTypeChanged('tv'),
            child: const Text(
              "시리즈 & TV 프로그램",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
