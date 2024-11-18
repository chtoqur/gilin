import 'package:flutter/material.dart';

class PathColors {
  // 지하철 노선 색상
  static const Map<int, Color> subwayColors = {
    1: Color(0xFF0032A0),    // 1호선
    2: Color(0xFF00B140),    // 2호선
    3: Color(0xFFFC4C02),    // 3호선
    4: Color(0xFF00A9E0),    // 4호선
    5: Color(0xFFA05EB5),    // 5호선
    6: Color(0xFFA9431E),    // 6호선
    7: Color(0xFF67823A),    // 7호선
    8: Color(0xFFE31C79),    // 8호선
    9: Color(0xFF8C8279),    // 9호선
    116: Color(0xFFEBA900),  // 수인분당선
    108: Color(0xFF08AF7B),  // 경춘선
    101: Color(0xFF65A6D2),  // 공항철도
    109: Color(0xFFA71E31),  // 신분당선
  };

  static const Color defaultSubwayColor = Colors.red;

  // 버스 유형별 색상
  static const Map<int, Color> busColors = {
    14: Color(0xFFFB5852),  // 광역버스
    11: Color(0xFF386DE8),  // 간선버스
    3: Color(0xFF87C700),   // 마을버스
    12: Color(0xFF3CC344),  // 지선버스
  };

  static const Color defaultBusColor = Colors.red;

  // 기타 이동수단 색상
  static const Color taxiColor = Color(0xFFFFFF00);
  static const Color bicycleColor = Colors.blue;
  static const Color walkColor = Colors.grey;
}