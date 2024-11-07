import 'dart:math';

// 카텍 좌표계(네이버 지역 검색) 와 WGS84 좌표계 간의 변환 클래스
class CoordinateConverter {
  static (double lat, double lng) convertToWGS84(int katecX, int katecY) {
    const double RE = 6371.00877; // 지구 반경(km)
    const double GRID = 5.0; // 격자 간격(km)
    const double SLAT1 = 30.0; // 투영 위도1(degree)
    const double SLAT2 = 60.0; // 투영 위도2(degree)
    const double OLON = 126.0; // 기준점 경도(degree)
    const double OLAT = 38.0; // 기준점 위도(degree)
    const double XO = 43; // 기준점 X좌표(GRID)
    const double YO = 136; // 기준점 Y좌표(GRID)

    double degrad = pi / 180.0;
    double re = RE / GRID;
    double slat1 = SLAT1 * degrad;
    double slat2 = SLAT2 * degrad;
    double olon = OLON * degrad;
    double olat = OLAT * degrad;

    double sn = tan(pi * 0.25 + slat2 * 0.5) / tan(pi * 0.25 + slat1 * 0.5);
    sn = log(cos(slat1) / cos(slat2)) / log(sn);
    double sf = tan(pi * 0.25 + slat1 * 0.5);
    sf = pow(sf, sn) * cos(slat1) / (sn * re);
    double ro = tan(pi * 0.25 + olat * 0.5);
    ro = re * sf / pow(ro, sn);

    double ra = tan(pi * 0.25 + (katecY / (re * sf)) * degrad * 0.5);
    ra = re * sf / pow(ra, sn);
    var theta = katecX * degrad / sn;

    double lat = (pi * 0.5 - 2.0 * atan(pow(ra / re, 1.0 / sn))) / degrad;
    double lng = (olon + theta / degrad) % 360.0;
    if (lng > 180.0) lng -= 360.0;

    return (lat, lng);

  }
}