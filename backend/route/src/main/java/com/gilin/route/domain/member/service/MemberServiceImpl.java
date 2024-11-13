package com.gilin.route.domain.member.service;

import com.gilin.route.global.client.oAuthKakao.KakaoInfoResponse;
import com.gilin.route.domain.member.dto.request.OAuthTokenRequest;
import com.gilin.route.domain.member.dto.response.TokenResponse;
import com.gilin.route.domain.member.dto.request.MemberPlacePutRequest;
import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.member.entity.OAuthType;
import com.gilin.route.domain.member.repository.MemberRepository;
import com.gilin.route.global.client.oAuthKakao.OAuthKakaoClient;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;


@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {

    private final MemberRepository memberRepository;
    private final OAuthKakaoClient kakaoClient;
    private final JwtTokenProvider jwtTokenProvider;
    @Autowired
    private RedisTemplate<String, String> redisTemplate;

    @Override
    public TokenResponse login(OAuthTokenRequest oAuthTokenRequest) {
        KakaoInfoResponse response = kakaoClient.getUser(oAuthTokenRequest.accessToken());

        Member member = memberRepository
                .findByoAuthTypeAndOauthId(OAuthType.KAKAO, response.id())
                .stream()
                .findFirst()
                .orElseGet(() -> register(OAuthType.KAKAO, response.id()));

        String accessToken = jwtTokenProvider.generateAccessToken(member.getId().toString());
        String refreshToken = jwtTokenProvider.generateRefreshToken();

        String refreshTokenUuid = jwtTokenProvider.extractRefreshTokenSubject(refreshToken);

        redisTemplate.opsForValue().set(
                "RT:" + refreshTokenUuid,
                member.getId().toString(),
                jwtTokenProvider.getRefreshTokenExpiration(),
                TimeUnit.MILLISECONDS
        );
        return new TokenResponse(accessToken, refreshToken);
    }

    private Member register(OAuthType oAuthType, String id) {
        Member member = new Member(oAuthType, id);
        return memberRepository.save(member);
    }

    @Override
    public TokenResponse reissue(String refreshToken) {
        jwtTokenProvider.validateRefreshToken(refreshToken);

        String refreshTokenUuid = jwtTokenProvider.extractRefreshTokenSubject(refreshToken);

        String userId = redisTemplate.opsForValue().get("RT:" + refreshTokenUuid);
        if (userId == null) {
            throw new IllegalArgumentException("유효하지 않은 리프레시 토큰입니다.");
        }

        String newAccessToken = jwtTokenProvider.generateAccessToken(userId);
        String newRefreshToken = jwtTokenProvider.generateRefreshToken();
        String newRefreshTokenUuid = jwtTokenProvider.extractRefreshTokenSubject(newRefreshToken);

        redisTemplate.delete("RT:" + refreshTokenUuid);
        redisTemplate.opsForValue().set(
                "RT:" + newRefreshTokenUuid,
                userId,
                jwtTokenProvider.getRefreshTokenExpiration(),
                TimeUnit.MILLISECONDS
        );

        return new TokenResponse(newAccessToken, newRefreshToken);
    }
}
