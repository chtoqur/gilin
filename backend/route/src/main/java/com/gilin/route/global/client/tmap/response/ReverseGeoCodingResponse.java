package com.gilin.route.global.client.tmap.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReverseGeoCodingResponse {

    private AddressInfo addressInfo;

    @Getter
    @Setter
    public static class AddressInfo {

        @JsonProperty("fullAddress")
        private String fullAddress;

        @JsonProperty("addressKey")
        private String addressKey;

        @JsonProperty("roadAddressKey")
        private String roadAddressKey;

        @JsonProperty("addressType")
        private String addressType;

        @JsonProperty("city_do")
        private String city_do;

        @JsonProperty("gu_gun")
        private String gu_gun;

        @JsonProperty("eup_myun")
        private String eup_myun;

        @JsonProperty("adminDong")
        private String adminDong;

        @JsonProperty("adminDongCode")
        private String adminDongCode;

        @JsonProperty("legalDong")
        private String legalDong;

        @JsonProperty("legalDongCode")
        private String legalDongCode;

        @JsonProperty("ri")
        private String ri;

        @JsonProperty("roadName")
        private String roadName;

        @JsonProperty("buildingIndex")
        private String buildingIndex;

        @JsonProperty("buildingName")
        private String buildingName;

        @JsonProperty("mappingDistance")
        private double mappingDistance;

        @JsonProperty("roadCode")
        private String roadCode;

        @JsonProperty("bunji")
        private String bunji;

        @JsonProperty("adminDongCoord")
        private Coord adminDongCoord;

        @JsonProperty("legalDongCoord")
        private Coord legalDongCoord;

        @JsonProperty("roadCoord")
        private Coord roadCoord;

        @Getter
        @Setter
        public static class Coord {

            @JsonProperty("lat")
            private String lat;

            @JsonProperty("lon")
            private String lon;

            @JsonProperty("latEntr")
            private String latEntr;

            @JsonProperty("lonEntr")
            private String lonEntr;
        }
    }
}
