import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavState extends StateNotifier<int> {
  BottomNavState() : super(0);

  void navigateToPage(BuildContext context, int index, String route) {
    state = index;
    context.go(route);
  }

  void updateIndex(int index) {
    state = index;
  }
}

final bottomNavProvider = StateNotifierProvider<BottomNavState, int>((ref) {
  return BottomNavState();
});
