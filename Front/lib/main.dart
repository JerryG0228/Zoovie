import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/user_controller.dart';
import 'screens/login_page.dart';

void main() {
  // UserController 초기화
  Get.put(UserController());

  runApp(
    GetMaterialApp(
      home: const LoginScreen(),
      getPages: [
        GetPage(
          name: '/login_page',
          page: () => const LoginScreen(),
        ),
      ],
    ),
  );
}
