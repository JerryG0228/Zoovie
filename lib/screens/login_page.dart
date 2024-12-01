import 'package:flutter/material.dart';
import 'package:zoovie/widgets/loginTextBox.dart';
import 'package:zoovie/screens/main_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isFormValid = false;

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
              top: 100,
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
                    height: 200,
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

                            if (email == "test@test.com" &&
                                password == "1234") {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const MainPage(),
                                  transitionDuration: Duration.zero,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('이메일 또는 비밀번호가 잘못되었습니다.'),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(16),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
