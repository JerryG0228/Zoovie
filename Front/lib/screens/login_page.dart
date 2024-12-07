import 'package:flutter/material.dart';
import 'package:zoovie/screens/bookmark_page.dart';
import 'package:zoovie/screens/my_page.dart';
import 'package:zoovie/screens/search_page.dart';
import 'package:zoovie/widgets/bottom_bar.dart';
import 'package:zoovie/widgets/user_widgets/loginTextBox.dart';
import 'package:zoovie/screens/main_page.dart';
import 'package:zoovie/screens/signup_page.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isFormValid = false;
  final Dio _dio = Dio();
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    emailController.addListener(updateFormValidity);
    passwordController.addListener(updateFormValidity);
  }

  void updateFormValidity() {
    setState(() {
      isFormValid =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(String email, String password) async {
    try {
      final response = await _dio.post(
        'http://127.0.0.1:5000/user/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        try {
          print('사용자 정보 요청');
          final userResponse = await _dio.post(
            'http://127.0.0.1:5000/user/user',
            data: {
              'email': email,
            },
          );

          print('응답 상태 코드: ${userResponse.statusCode}');
          print('응답 데이터: ${userResponse.data}');

          final userData = userResponse.data;
          final user = User(
            username: userData['username'],
            email: userData['email'],
            bookmarked: {
              'movie': List<String>.from(userData['bookmarked']['movie'] ?? []),
              'tv': List<String>.from(userData['bookmarked']['tv'] ?? [])
            },
          );

          userController.setUser(user);

          print('저장된 사용자 정보: ${userController.user}');

          Get.off(() => const DefaultTabController(
                length: 4,
                child: Scaffold(
                  body: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      MainPage(),
                      SearchPage(),
                      BookmarkPage(),
                      MyPage(),
                    ],
                  ),
                  bottomNavigationBar: BottomBar(),
                ),
              ));
        } on DioException catch (e) {
          print('사용자 정보 조회 오류: ${e.response?.data}');
          Get.snackbar(
            '오류',
            '사용자 정보를 불러오는데 실패했습니다.',
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } on DioException catch (e) {
      String errorMessage = '로그인에 실패했습니다.';
      if (e.response?.statusCode == 401) {
        errorMessage = '이메일 또는 비밀번호가 잘못되었습니다.';
      }

      Get.snackbar(
        '오류',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A8D81),
              Color(0xFF717171),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 130,
              left: 0,
              right: 0,
              child: Image.asset(
                'lib/assets/images/splash.png',
                width: 250,
                height: 250,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 220,
                  ),
                  LoginTextBox(
                    controller: emailController,
                    labelText: '이메일',
                  ),
                  const SizedBox(height: 16.0),
                  LoginTextBox(
                    controller: passwordController,
                    labelText: '비밀번호',
                    isPassword: true,
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: isFormValid
                        ? () {
                            final email = emailController.text;
                            final password = passwordController.text;
                            _login(email, password);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isFormValid ? const Color(0xFF00FF99) : Colors.grey,
                      minimumSize:
                          const Size(double.infinity, 56), // TextField와 같은 높이
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18), // TextField와 같은 모서리 둥글기
                      ),
                    ),
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        color: isFormValid ? Colors.black : Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupPage(),
                            ),
                          );
                        },
                        child: const Text(
                          '회원가입',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Text(
                        '|',
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          '아이디 찾기',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Text(
                        '|',
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          '비밀번호 찾기',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
