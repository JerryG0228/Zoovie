import 'package:flutter/material.dart';

class ToggleBookmarkButton extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onToggle;

  const ToggleBookmarkButton({
    super.key,
    required this.isBookmarked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onToggle,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Column(
        children: [
          isBookmarked
              ? const Icon(
                  Icons.bookmark,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.bookmark_border,
                  color: Colors.white,
                ),
        ],
      ),
    );
  }
}
