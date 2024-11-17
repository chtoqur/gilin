import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>((ref) {
  return NotificationSettingsNotifier();
});

class NotificationSettings {
  final bool pushEnabled;
  final bool departureAlert;
  final bool routeAlert;
  final bool marketingAlert;
  final bool nightAlert;

  NotificationSettings({
    this.pushEnabled = true,
    this.departureAlert = true,
    this.routeAlert = true,
    this.marketingAlert = false,
    this.nightAlert = true,
  });

  NotificationSettings copyWith({
    bool? pushEnabled,
    bool? departureAlert,
    bool? routeAlert,
    bool? marketingAlert,
    bool? nightAlert,
  }) {
    return NotificationSettings(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      departureAlert: departureAlert ?? this.departureAlert,
      routeAlert: routeAlert ?? this.routeAlert,
      marketingAlert: marketingAlert ?? this.marketingAlert,
      nightAlert: nightAlert ?? this.nightAlert,
    );
  }
}

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(NotificationSettings());

  void togglePush(bool value) {
    state = state.copyWith(pushEnabled: value);
  }

  void toggleDepartureAlert(bool value) {
    state = state.copyWith(departureAlert: value);
  }

  void toggleRouteAlert(bool value) {
    state = state.copyWith(routeAlert: value);
  }

  void toggleMarketingAlert(bool value) {
    state = state.copyWith(marketingAlert: value);
  }

  void toggleNightAlert(bool value) {
    state = state.copyWith(nightAlert: value);
  }
}

class NotificationSettingScreen extends ConsumerWidget {
  const NotificationSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var settings = ref.watch(notificationSettingsProvider);

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xffF8F5F0),
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Color(0xffF8F5F0),
        border: null,
        middle: Text(
          '알림 설정',
          style: TextStyle(
            color: Color(0xff463C33),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: CupertinoNavigationBarBackButton(
          color: Color(0xff463C33),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(25),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '앱 푸시 알림',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff463C33),
                          ),
                        ),
                        CupertinoSwitch(
                          value: settings.pushEnabled,
                          activeColor: const Color(0xFF669358),
                          onChanged: (bool value) {
                            ref.read(notificationSettingsProvider.notifier).togglePush(value);
                          },
                        ),
                      ],
                    ),
                    const Gap(5),
                    const Text(
                      '앱 푸시 알림을 켜면 아래 알림을 받을 수 있습니다.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6E6E6E),
                      ),
                    ),
                  ],
                ),
              ),
              if (settings.pushEnabled) ...[
                const Gap(8),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      _buildNotificationItem(
                        context: context,
                        title: '출발 알림',
                        subtitle: '출발 시간에 맞춰 알림을 받습니다',
                        value: settings.departureAlert,
                        onChanged: (value) {
                          ref.read(notificationSettingsProvider.notifier).toggleDepartureAlert(value);
                        },
                      ),
                      const Divider(height: 1, indent: 25, endIndent: 25),
                      _buildNotificationItem(
                        context: context,
                        title: '경로 알림',
                        subtitle: '경로 변경 시 알림을 받습니다',
                        value: settings.routeAlert,
                        onChanged: (value) {
                          ref.read(notificationSettingsProvider.notifier).toggleRouteAlert(value);
                        },
                      ),
                      const Divider(height: 1, indent: 25, endIndent: 25),
                      _buildNotificationItem(
                        context: context,
                        title: '마케팅 알림',
                        subtitle: '이벤트 및 혜택 알림을 받습니다',
                        value: settings.marketingAlert,
                        onChanged: (value) {
                          ref.read(notificationSettingsProvider.notifier).toggleMarketingAlert(value);
                        },
                      ),
                      const Divider(height: 1, indent: 25, endIndent: 25),
                      _buildNotificationItem(
                        context: context,
                        title: '야간 알림 수신',
                        subtitle: '오후 9시 ~ 오전 8시',
                        value: settings.nightAlert,
                        onChanged: (value) {
                          ref.read(notificationSettingsProvider.notifier).toggleNightAlert(value);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff463C33),
                  ),
                ),
                const Gap(5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6E6E6E),
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: const Color(0xFF669358),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}