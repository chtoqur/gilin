import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/auth/auth_provider.dart';
import '../../state/auth/auth_state.dart';
import '../../themes/color.dart';

const Color primaryColor = Color(0xFF463C33);

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
  Widget build(BuildContext context) {
    var authState = ref.watch(authProvider);

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
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontFamily: 'RobotoSlab',
                            letterSpacing: 1.8,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '길 잃지 않는 여정을 위해,\n당신의 시간을 지켜드립니다',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
                  authState.when(
                    data: (state) {
                      if (state is AuthAuthenticated) {
                        return Column(
                          children: [
                            Text(
                              '환영합니다, ${state.kakaoUser.kakaoAccount?.profile?.nickname}님',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () =>
                                  ref.read(authProvider.notifier).signOut(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor, // primaryColor 수정
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 24),
                              ),
                              child: const Text(
                                '로그아웃',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: GestureDetector(
                              onTap: () => ref
                                  .read(authProvider.notifier)
                                  .signInWithKakao(),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
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
                              '시작하기 버튼을 누르면\n이용약관과 개인정보 처리방침에 동의하게 됩니다.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    error: (error, stack) => Text('에러: $error'),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}


