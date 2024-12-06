import 'package:flutter/material.dart';
import 'package:zoovie/widgets/detail_widgets/platform/platform_box.dart';

class platformContainer extends StatelessWidget {
  const platformContainer({
    super.key,
    required this.mediaDetail,
  });

  final Map<String, dynamic>? mediaDetail;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (mediaDetail?['providers'] != null &&
              mediaDetail!['providers'].isNotEmpty)
            ...mediaDetail!['providers'].map((provider) {
              return PlatformBox(
                logoPath: provider['logo_path'],
                providerName: provider['provider_name'],
              );
            }).toList()
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Text(
                '제공 중인 스트리밍 서비스가 없습니다',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
