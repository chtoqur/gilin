package com.gilin.route.global.client.tmap.response;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import lombok.Data;

import java.util.List;

@Data
public class PedestrianPathResponse {

    private String type;
    private List<Feature> features;

    @Data
    public static class Feature {

        private String type;
        private Geometry geometry;
        private Properties properties;

        @Data
        @JsonTypeInfo(use = JsonTypeInfo.Id.NAME, property = "type", visible = true)
        @JsonSubTypes({
            @JsonSubTypes.Type(value = PointGeometry.class, name = "Point"),
            @JsonSubTypes.Type(value = LineStringGeometry.class, name = "LineString")
        })
        public static abstract class Geometry {

        }

        @Data
        public static class PointGeometry extends Geometry {

            private List<Double> coordinates;
        }

        @Data
        public static class LineStringGeometry extends Geometry {

            private List<List<Double>> coordinates;
        }

        @Data
        public static class Properties {

            private Integer index;
            private Integer pointIndex;
            private String name;
            private String description;
            private String direction;
            private String intersectionName;
            private String nearPoiX;
            private String nearPoiY;
            private String nearPoiName;
            private Integer turnType;
            private String pointType;
            private String facilityType;
            private String facilityName;
            private Integer totalDistance;
            private Integer totalTime;
            private Integer lineIndex;
            private String roadType;
            private Integer categoryRoadType;
        }
    }
}
