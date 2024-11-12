import 'package:flutter/material.dart';
import 'package:gilin/screens/login/kakao_login.dart';
import 'package:gilin/screens/login/login_view_model.dart';
import 'package:gilin/themes/color.dart';

import '../main_screen.dart';
import '../route/route_screen.dart';

class LoginScreenUI extends StatefulWidget {
  const LoginScreenUI({Key? key}) : super(key: key);

  @override
  State<LoginScreenUI> createState() => _LoginScreenUIState();
}

class _LoginScreenUIState extends State<LoginScreenUI> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;

  // 카카오 로그인 viewModel 추가
  final viewModel = LoginViewModel(KakaoLogin());

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 카카오 로그인 처리
  Future<void> _signInWithKakao(BuildContext context) async {
    try {
      setState(() => _isLoading = true);

      await viewModel.login();

      if (mounted && viewModel.isLogined) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인 성공!'),
            backgroundColor: Colors.green,
          ),
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(
                showBottomNav: true,
                child: RouteScreen(),
              ),
            ),
          );
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 실패: ${error.toString()}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: '다시 시도',
              textColor: Colors.white,
              onPressed: () => _signInWithKakao(context),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beige,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Hero(
                        tag: 'logo',
                        child: Image.asset(
                          'assets/images/icons/giraffe_login.png',
                          height: 200,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Column(
                      children: [
                        Text(
                          'GilIn',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '당신의 여행 길잡이',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: GestureDetector(
                      onTap: _isLoading ? null : () => _signInWithKakao(context),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/buttons/kakao_login_medium_wide.png',
                          height: 45,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      '시작하기 버튼을 누르면 이용약관과 개인정보 처리방침에 동의하게 됩니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}