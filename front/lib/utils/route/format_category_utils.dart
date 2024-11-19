// 검색 결과 category 문자열에서 원하는 부분만 추출
// ex. '여행 > 숙박 > 호텔 > 베니키아 호텔' → '숙박 > 호텔'만 추출
class FormatCategoryUtils {
  static String formatCategory(String category) {
    List<String> parts = category.split(' > ');
    if (parts.length < 3) return category; // 구분자가 충분하지 않으면 원본 반환

    return '${parts[1]} > ${parts[2]}'; // 두 번째와 세 번째 부분만 반환
  }
}
