import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/screens/login/kakao_login.dart';
import 'package:gilin/screens/login/login_view_model.dart';
import 'package:gilin/themes/color.dart';
import 'package:gilin/core/storage/secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../../core/network/dio_provider.dart';
import '../main_screen.dart';
import '../route/route_screen.dart';

class LoginScreenUI extends ConsumerStatefulWidget {
  const LoginScreenUI({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreenUI> createState() => _LoginScreenUIState();
}

class _LoginScreenUIState extends ConsumerState<LoginScreenUI>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;

  // Provider를 통한 의존성 주입
  late final LoginViewModel viewModel;

  @override
  void initState() {
    super.initState();

    // ViewModel 초기화
    viewModel = LoginViewModel(
      KakaoLogin(dio: ref.read(dioProvider)),
      SecureStorage.instance,
    );

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

  Future<void> _signInWithKakao() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // BuildContext 캡처
      var navigator = Navigator.of(context);
      var scaffoldMessenger = ScaffoldMessenger.of(context);

      print('카카오 로그인 시작');

      // 1. 카카오톡 설치 여부 확인
      var installed = await isKakaoTalkInstalled();
      print('카카오톡 설치 여부: $installed');

      // 2. 카카오 로그인 수행
      if (installed) {
      } else {
      }
      print('카카오 토큰 발급 성공');

      // 3. 카카오 사용자 정보 조회
      var user = await UserApi.instance.me();
      print('카카오 사용자 정보 조회 성공: ${user.id}');

      // 4. 백엔드 서버에 토큰 전송 및 JWT 수신
      var dio = Dio();
      var response = await dio.post(
        'YOUR_BACKEND_URL/auth/kakao',
        data: {
          'kakaoId': user.id.toString(),
          'email': user.kakaoAccount?.email,
          'nickname': user.kakaoAccount?.profile?.nickname,
        },
      );

      // 5. JWT 토큰 저장
      await SecureStorage.instance.write(
        key: 'accessToken',
        value: response.data['accessToken'],
      );
      await SecureStorage.instance.write(
        key: 'refreshToken',
        value: response.data['refreshToken'],
      );

      // 토큰 저장 확인
      var accessToken = await SecureStorage.instance.read(key: 'accessToken');
      var refreshToken = await SecureStorage.instance.read(key: 'refreshToken');
      print('저장된 액세스 토큰: $accessToken');
      print('저장된 리프레시 토큰: $refreshToken');

      if (!mounted) return;

      // 6. 로그인 성공 처리
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('로그인 성공!'),
          backgroundColor: Colors.green,
        ),
      );

      // 7. 메인 화면으로 이동
      await navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScreen(
            showBottomNav: true,
            child: RouteScreen(),
          ),
        ),
      );
    } catch (error) {
      print('로그인 에러: $error');
      if (!mounted) return;

      // 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인 실패: ${error.toString()}'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: '다시 시도',
            textColor: Colors.white,
            onPressed: _signInWithKakao,
          ),
        ),
      );
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
                      onTap: _signInWithKakao,
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
                  // 토큰 확인용 버튼
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ElevatedButton(
                      onPressed: () async {
                        // BuildContext 캡처
                        var context = this.context;
                        var navigator = Navigator.of(context);
                        var scaffoldMessenger = ScaffoldMessenger.of(context);

                        try {
                          var accessToken = await SecureStorage.instance.read(key: 'accessToken');
                          var refreshToken = await SecureStorage.instance.read(key: 'refreshToken');

                          if (!mounted) return;

                          await showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('저장된 토큰 정보'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Access Token:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                      accessToken?.substring(0, min(20, accessToken.length)) ?? '없음',
                                      style: const TextStyle(fontSize: 12)
                                  ),
                                  const SizedBox(height: 12),
                                  const Text('Refresh Token:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                      refreshToken?.substring(0, min(20, refreshToken.length)) ?? '없음',
                                      style: const TextStyle(fontSize: 12)
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => navigator.pop(),
                                  child: const Text('확인'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await SecureStorage.instance.deleteAll();
                                    if (!mounted) return;

                                    navigator.pop();
                                    scaffoldMessenger.showSnackBar(
                                      const SnackBar(content: Text('토큰이 삭제되었습니다')),
                                    );
                                  },
                                  child: const Text('토큰 삭제'),
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          if (!mounted) return;

                          scaffoldMessenger.showSnackBar(
                            SnackBar(content: Text('토큰 확인 실패: ${e.toString()}')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '토큰 확인',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  ///////////////////////////////
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