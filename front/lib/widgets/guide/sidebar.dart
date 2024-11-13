import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../models/route/transit_route.dart';

class GuideSidebar extends StatefulWidget {
  final TransitRoute routeData;
  final Function(TransitSegment) onSegmentTap;  // NLatLng 대신 TransitSegment
  final VoidCallback? onClose;  // onClose 콜백 추가

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
  late Animation<Offset> _slideAnimation;
  bool _isOpen = true;
  int _selectedSegmentIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
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
    }
  }

  String _getTransitTypeText(TransitType type) {
    switch (type) {
      case TransitType.BUS:
        return '버스';
      case TransitType.METRO:
        return '지하철';
      case TransitType.TAXI:
        return '택시';
      case TransitType.WALK:
        return '도보';
      case TransitType.BICYCLE:
        return '자전거';
    }
  }

  String _formatDistance(double meters) {
    return meters >= 1000
        ? '${(meters / 1000).toStringAsFixed(1)}km'
        : '${meters.toInt()}m';
  }

  Widget _buildTimelineItem(TransitSegment segment, bool isLast) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        child: CustomPaint(
                          painter: DashedLinePainter(
                            color: const Color(0xFFF8F5F0),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Expanded(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 16),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           '${_getTransitTypeText(segment.travelType)} ${_formatDistance(segment.distance)}',
              //           style: const TextStyle(
              //             color: Color(0xFFF8F5F0),
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         const Gap(4),
              //         Text(
              //           '${segment.startName} → ${segment.endName}',
              //           style: TextStyle(
              //             color: const Color(0xFFF8F5F0).withOpacity(0.8),
              //             fontSize: 14,
              //           ),
              //         ),
              //         const Gap(8),
              //         Text(
              //           '소요시간 약 ${segment.sectionTime}분',
              //           style: TextStyle(
              //             color: const Color(0xFFF8F5F0).withOpacity(0.6),
              //             fontSize: 12,
              //           ),
              //         ) ,
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        if (!isLast) const Gap(16),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SlideTransition(
          position: _slideAnimation,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                _toggleSidebar();
              }
            },
            child: Container(
              width: 300,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFFF8F5F0),
                              ),
                              onPressed: _toggleSidebar,
                            ),
                            const Gap(8),
                            // const Text(
                            //   '경로 정보',
                            //   style: TextStyle(
                            //     color: Color(0xFFF8F5F0),
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                          ],
                        ),
                        const Gap(8),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       '총 거리 ${_formatDistance(widget.routeData.info.totalDistance.toDouble())}',
                        //       style: const TextStyle(
                        //         color: Color(0xFFF8F5F0),
                        //         fontSize: 14,
                        //       ),
                        //     ),
                        //     Text(
                        //       '예상 소요시간 ${widget.routeData.info.totalTime}분',
                        //       style: const TextStyle(
                        //         color: Color(0xFFF8F5F0),
                        //         fontSize: 14,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
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
                          // TODO: 안내 시작 로직
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
                          '안내 시작하기',
                          style: TextStyle(
                            fontSize: 16,
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
        ),
        // 탭 인덱스
        Positioned(
          right: _isOpen ? 300 : 0,
          top: MediaQuery.of(context).size.height * 0.4,
          child: GestureDetector(
            onTap: () {
              if (!_isOpen) _toggleSidebar();
            },
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // RotatedBox(
                  //   quarterTurns: 3,
                  //   child: Text(
                  //     '경로 정보',
                  //     style: TextStyle(
                  //       color: Colors.white.withOpacity(0.9),
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  // const Gap(8),
                  Icon(
                    _isOpen ? Icons.chevron_right : Icons.chevron_left,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// 점선을 그리기 위한 CustomPainter
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