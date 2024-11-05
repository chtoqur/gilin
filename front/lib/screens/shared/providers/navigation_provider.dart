import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavState extends StateNotifier<int> {
  BottomNavState() : super(0);

  void setPage(int index) {
    state = index;
  }

  void updateIndexFromPath(String path) {
    switch (path) {
      case '/':
        state = 0;
        break;
      case '/schedule':
        state = 1;
        break;
      case '/alert':
        state = 2;
        break;
      case '/mypage':
        state = 3;
        break;
    }
  }
}

final bottomNavProvider = StateNotifierProvider<BottomNavState, int>((ref) {
  return BottomNavState();
});