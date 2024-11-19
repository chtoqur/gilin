import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    var kakaoTaxiPlayStore = Uri.parse('market://details?id=com.kakao.taxi');

    try {
      var launched = await launchUrl(
        Uri.parse(kakaoTaxiUrlScheme),
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        await launchUrl(kakaoTaxiPlayStore);
      }
    } catch (e) {
      await launchUrl(kakaoTaxiPlayStore);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF463C33).withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '택시 승차 안내',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF463C33),
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
          const Gap(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF8F5F0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF463C33).withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFF463C33).withOpacity(0.3),
                      )),
                  child: const Icon(
                    Icons.local_taxi,
                    color: Color(0xFF463C33),
                    size: 30,
                  ),
                ),
                const Gap(16),
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
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF463C33),
                              ),
                            ),
                            TextSpan(
                              text: location,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF463C33),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(4),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Color(0xFF463C33)),
                          children: [
                            const TextSpan(
                              text: '도착 예정: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: estimatedTime,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(4),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Color(0xFF463C33)),
                          children: [
                            const TextSpan(
                              text: '예상 비용: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: '${estimatedCost.toString()}원',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),
          // 카카오 택시 버튼
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: _openKakaoTaxi,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF282C4B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/kakao_taxi.webp',
                      width: 25,
                      height: 25,
                    ),
                    const Gap(8),
                    const Text(
                      '카카오 T 호출하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
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
