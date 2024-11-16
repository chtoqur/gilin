import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../models/route/transit_route.dart';

class GuideSidebar extends StatefulWidget {
  final TransitRoute routeData;
  final Function(TransitSegment) onSegmentTap;
  final VoidCallback? onClose;

  const GuideSidebar({
    Key? key,
    required this.routeData,
    required this.onSegmentTap,
    this.onClose,
  }) : super(key: key);

  @override
  State<GuideSidebar> createState() => _GuideSidebarState();
}

class _GuideSidebarState extends State<GuideSidebar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool _isOpen = true;
  int _selectedSegmentIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  void _toggleSidebar() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
        widget.onClose?.call();
      }
    });
  }

  IconData _getTransitIcon(TransitType type) {
    switch (type) {
      case TransitType.BUS:
        return Icons.directions_bus;
      case TransitType.METRO:
        return Icons.subway;
      case TransitType.TAXI:
        return Icons.local_taxi;
      case TransitType.WALK:
        return Icons.directions_walk;
      case TransitType.BICYCLE:
        return Icons.pedal_bike;
      case TransitType.TRANSFER:
        return Icons.transfer_within_a_station;
    }
  }

  Widget _buildTimelineItem(TransitSegment segment, bool isLast) {
    if (segment.travelType == TransitType.TRANSFER) {
      return const SizedBox.shrink();
    }
    final bool isSelected = widget.routeData.subPath.indexOf(segment) == _selectedSegmentIndex;

    return Column(
      children: [

        InkWell(
          onTap: () {
            setState(() {
              _selectedSegmentIndex = widget.routeData.subPath.indexOf(segment);
            });
            widget.onSegmentTap(segment);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 60,
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? const Color(0xFFF8F5F0) : Colors.transparent,
                        border: Border.all(
                          color: const Color(0xFFF8F5F0),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        _getTransitIcon(segment.travelType),
                        color: isSelected ? const Color(0xFF8DA05D) : const Color(0xFFF8F5F0),
                        size: 20,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 40,
                        child: CustomPaint(
                          painter: DashedLinePainter(
                            color: const Color(0xFFF8F5F0),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Gap(16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        final slideValue = _slideAnimation.value;
        final screenWidth = MediaQuery.of(context).size.width;
        final sidebarWidth = screenWidth * 0.25; // 화면 너비의 25%

        return Stack(
          children: [
            // 메인 사이드바
            Transform.translate(
              offset: Offset(sidebarWidth * (1 - slideValue), 0),
              child: Container(
                width: sidebarWidth,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF8DA05D),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(-2, 0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(48),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFF8F5F0),
                        ),
                        onPressed: _toggleSidebar,
                      ),
                    ),
                    const Divider(color: Color(0xFFF8F5F0), height: 1),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            for (int i = 0; i < widget.routeData.subPath.length; i++)
                              _buildTimelineItem(
                                widget.routeData.subPath[i],
                                i == widget.routeData.subPath.length - 1,
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // 안내 시작 로직
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8F5F0),
                            foregroundColor: const Color(0xFF8DA05D),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '안내 시작',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 토글 버튼
            if (!_isOpen)
              Positioned(
                right: 0,
                top: MediaQuery.of(context).size.height * 0.4,
                child: GestureDetector(
                  onTap: _toggleSidebar,
                  child: Container(
                    width: 40,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8DA05D),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(-2, 0),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.chevron_left,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashHeight = 4;
    const dashSpace = 3;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}