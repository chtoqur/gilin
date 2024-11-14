package com.gilin.route.domain.member.service;

import com.gilin.route.domain.member.dto.Authenticated;
import com.gilin.route.domain.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.MethodParameter;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import java.util.Objects;

@Slf4j
@Component
@RequiredArgsConstructor
public class AuthenticatedArgumentResolver implements HandlerMethodArgumentResolver {

    private final JwtTokenProvider jwtTokenProvider;
    private final MemberRepository memberRepository;

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.hasParameterAnnotation(Authenticated.class);
    }

    @Override
    public Object resolveArgument(MethodParameter parameter,
                                  ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest,
                                  WebDataBinderFactory binderFactory) throws Exception {
        Long memberId = parseMemberId(webRequest.getHeader("AUTHORIZATION"));
        return Objects.isNull(memberId) ? null : memberRepository.findById(memberId).orElse(null);
    }

    private Long parseMemberId(String token) {
        if (Objects.isNull(token) || !token.startsWith("Bearer ")) {
            return null;
        }
        return Long.parseLong(jwtTokenProvider.extractAccessToken(token.substring(7)));
    }
}
