package com.gilin.route.domain.route.client.odsay;

import com.gilin.route.domain.route.client.odsay.request.SearchPubTransPathRequest;
import com.gilin.route.domain.route.client.odsay.response.SearchPubTransPathResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.cloud.openfeign.SpringQueryMap;
import org.springframework.web.bind.annotation.GetMapping;

@FeignClient(url = "https://api.odsay.com/v1/api", name = "ODSayClient")
public interface ODSayClient {

    @GetMapping("/searchPubTransPathT")
    SearchPubTransPathResponse searchPubTransPathT(@SpringQueryMap SearchPubTransPathRequest searchPubTransPathRequest);
}
