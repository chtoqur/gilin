import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import '../model/user_model.dart';


class AuthController extends GetxController {
  final Rxn<AppUser> currentUser = Rxn<AppUser>();

  AuthController();

  Future<void> handleKakaoLogin() async {
    try {
      if (await kakao.isKakaoTalkInstalled()) {
        await kakao.UserApi.instance.loginWithKakaoTalk();
      } else {
        await kakao.UserApi.instance.loginWithKakaoAccount();
      }

      // 카카오 사용자 정보 가져오기
      var kakaoUser = await kakao.UserApi.instance.me();

      // 백엔드에서 JWT 토큰 발급

      // 사용자 정보 변환 및 상태 업데이트
      currentUser.value = AppUser.fromKakaoUser(kakaoUser);

      await Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('로그인 실패', '다시 시도해주세요');
    }
  }
}