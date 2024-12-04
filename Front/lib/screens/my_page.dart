import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff4A8D81), Color(0xff717171)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 120),
              Container(
                padding: const EdgeInsets.only(top: 100),
                child: const CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("lib/assets/images/user.png"),
                ),
              ),
              const SizedBox(height: 15),
              Obx(() {
                final username = userController.user?.username ?? "게스트";
                return Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                );
              }),
              const SizedBox(height: 5),
              Obx(() => Text(
                    userController.user?.email ?? "guest@example.com",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  )),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  userController.clearUser();
                  Get.offAllNamed('/login_page');
                },
                icon: const Icon(Icons.logout),
                label: const Text("로그아웃"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
