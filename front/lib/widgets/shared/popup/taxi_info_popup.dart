import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TaxiInfoPopup extends StatelessWidget {
  final String location;
  final String estimatedTime;
  final int estimatedCost;
  final VoidCallback? onClose;

  const TaxiInfoPopup({
    Key? key,
    required this.location,
    required this.estimatedTime,
    required this.estimatedCost,
    this.onClose,
  }) : super(key: key);

  Future<void> _openKakaoTaxi() async {
    const kakaoTaxiUrlScheme = 'kakaot://';
    final kakaoTaxiPlayStore = Uri.parse('market://details?id=com.kakao.taxi');

    try {
      final launched = await launchUrl(
        Uri.parse(kakaoTaxiUrlScheme),
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // 앱이 설치되어 있지 않은 경우 플레이스토어로 이동
        await launchUrl(kakaoTaxiPlayStore);
      }
    } catch (e) {
      // URL 실행 실패시 플레이스토어로 이동
      await launchUrl(kakaoTaxiPlayStore);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '택시 승차 안내',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    Icons.close,
                    size: 24,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          // 정보 영역
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_taxi,
                    color: Colors.black54,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black87),
                          children: [
                            const TextSpan(
                              text: '승차 장소: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(text: location),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black87),
                          children: [
                            const TextSpan(
                              text: '도착 예정: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(text: estimatedTime),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black87),
                          children: [
                            const TextSpan(
                              text: '예상 비용: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(text: '${estimatedCost.toString()}원'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 카카오 택시 버튼
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: _openKakaoTaxi,
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF392020),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/kakao_t_logo.png', // 카카오 T 로고 이미지
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '카카오 T 호출하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}