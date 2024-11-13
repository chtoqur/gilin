package com.gilin.route.global.config;

import com.gilin.route.domain.member.entity.Member;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import jakarta.annotation.PostConstruct;
import org.springdoc.core.utils.SpringDocUtils;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {
    private static final String jwt = "JWT";

    @Bean
    public OpenAPI openAPI() {
        Info info = new Info()
                .version("v1.0.0")
                .title("API")
                .description("");


        SecurityRequirement securityRequirement = new SecurityRequirement().addList(jwt); // 헤더에 토큰 포함
        Components components = new Components().addSecuritySchemes(jwt, new SecurityScheme()
                .name(jwt)
                .type(SecurityScheme.Type.HTTP)
                .scheme("bearer")
                .bearerFormat("JWT")
        );

        Server localServer = new Server();
        localServer.setDescription("local");
        localServer.setUrl("http://localhost:8080/api");

        Server testServer = new Server();
        testServer.setDescription("server");
        testServer.setUrl("https://k11a306.p.ssafy.io/api");

        return new OpenAPI()
                .info(info)
                .addSecurityItem(securityRequirement)
                .components(components)
                .addServersItem(localServer)
                .addServersItem(testServer);
    }

    @PostConstruct
    public void ignoreMemberParameter() {
        SpringDocUtils.getConfig().addRequestWrapperToIgnore(Member.class);
    }
}
