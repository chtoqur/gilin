import 'package:flutter/material.dart';

class WarningBackground extends StatefulWidget {
  final Widget child;

  const WarningBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<WarningBackground> createState() => _WarningBackgroundState();
}

class _WarningBackgroundState extends State<WarningBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(microseconds: 600000),
      // duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 0.4,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.red.withOpacity(_animation.value),
        );
      },
    );
  }
}
