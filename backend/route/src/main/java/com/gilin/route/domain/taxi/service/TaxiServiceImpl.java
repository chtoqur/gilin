package com.gilin.route.domain.taxi.service;


import com.gilin.route.domain.taxi.dto.TaxiInfo;
import com.gilin.route.global.client.kakao.KakaoClient;
import com.gilin.route.global.client.kakao.request.SearchKakaoCarDirectionRequest;
import com.gilin.route.global.client.kakao.response.SearchKakaoCarDirectionResponse;
import com.gilin.route.global.client.tmap.TMapClient;
import com.gilin.route.global.dto.Coordinate;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class TaxiServiceImpl implements TaxiService {

    private final TMapClient mapClient;
    private final KakaoClient kakaoClient;
    private final TMapClient tMapClient;
    @Value("${apikey.kakaos}")
    private String apiKey;

    /**
     * 두 지점 사이의 택시 경로 정보를 return합니다.
     *
     * @param start
     * @param end
     * @return
     */
    @Override
    public TaxiInfo getTaxiInfo(Coordinate start, Coordinate end) {
        SearchKakaoCarDirectionRequest searchKakaoCarDirectionRequest = SearchKakaoCarDirectionRequest.builder()
                                                                                                      .origin(
                                                                                                          start.toCoordinateString())
                                                                                                      .destination(
                                                                                                          end.toCoordinateString())
                                                                                                      .priority(
                                                                                                          "TIME")
                                                                                                      .avoid(
                                                                                                          "ferries")
                                                                                                      .alternatives(
                                                                                                          false)
                                                                                                      .build();
        SearchKakaoCarDirectionResponse response = kakaoClient.searchKakaoCarDirection(
            searchKakaoCarDirectionRequest, "KakaoAK " + apiKey);

        SearchKakaoCarDirectionResponse.RouteResponse route = response.routes()
                                                                      .get(0);
        SearchKakaoCarDirectionResponse.RouteSummary summary = route.summary();
        List<Coordinate> coordinates = route.toCoordinates();
        String address = null;
        if (coordinates.size() != 0) {
            address = tMapClient.getReverseGeocoding(coordinates.get(0)
                                                                .y()
                                                                .toString(), coordinates.get(0)
                                                                                        .x()
                                                                                        .toString())
                                .getAddressInfo()
                                .getFullAddress();
        }
        return TaxiInfo.builder()
                       .price(summary.fare()
                                     .taxi())
                       .distance(summary.distance())
                       .time(summary.duration())
                       .coordinates(coordinates)
                       .address(address)
                       .build();
    }

}
