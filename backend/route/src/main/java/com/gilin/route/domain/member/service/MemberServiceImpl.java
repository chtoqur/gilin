package com.gilin.route.domain.member.service;

import com.gilin.route.domain.member.dto.request.OAuthRegisterRequest;
import com.gilin.route.global.client.oAuthKakao.KakaoInfoResponse;
import com.gilin.route.domain.member.dto.request.OAuthLoginRequest;
import com.gilin.route.domain.member.dto.response.LoginResponse;
import com.gilin.route.domain.member.dto.request.MemberPlacePutRequest;
import com.gilin.route.domain.member.entity.Member;
import com.gilin.route.domain.member.entity.OAuthType;
import com.gilin.route.domain.member.repository.MemberRepository;
import com.gilin.route.global.client.oAuthKakao.OAuthKakaoClient;
import com.gilin.route.global.error.GilinException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.Objects;
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
    public LoginResponse login(OAuthLoginRequest oAuthLoginRequest) {
        KakaoInfoResponse response = kakaoClient.getUser(oAuthLoginRequest.accessToken());

        Member member = memberRepository
                .findByoAuthTypeAndOauthId(OAuthType.KAKAO, response.id())
                .stream()
                .findFirst()
                .orElseThrow(() -> new GilinException(HttpStatus.BAD_REQUEST, "회원가입이 필요합니다."));

        return makeLoginResponse(member);
    }

    @Override
    public LoginResponse reissue(String refreshToken) {
        jwtTokenProvider.validateRefreshToken(refreshToken);

        String refreshTokenUuid = jwtTokenProvider.extractRefreshTokenSubject(refreshToken);

        String memberId = redisTemplate.opsForValue().get("RT:" + refreshTokenUuid);
        if (Objects.isNull(memberId)) {
            throw new GilinException(HttpStatus.UNAUTHORIZED, "유효하지 않은 리프레시 토큰입니다.");
        }
        redisTemplate.delete("RT:" + refreshTokenUuid);
        Member member = memberRepository.findById(Long.parseLong(memberId))
                .orElseThrow(() -> new GilinException(HttpStatus.UNAUTHORIZED, "유효하지 않은 리프레시 토큰입니다."));

        return makeLoginResponse(member);
    }

    @Override
    public LoginResponse register(OAuthRegisterRequest oAuthRegisterRequest) {
        KakaoInfoResponse response = kakaoClient.getUser(oAuthRegisterRequest.accessToken());

        memberRepository.findByoAuthTypeAndOauthId(OAuthType.KAKAO, response.id())
                .stream()
                .findFirst()
                .ifPresent(m -> {
                    throw new GilinException(HttpStatus.BAD_REQUEST, "이미 가입한 회원입니다.");
                });

        Member member = Member.builder()
                .oauthId(response.id())
                .oAuthType(oAuthRegisterRequest.oAuthType())
                .name(response.kakaoAccount().name())
                .gender(oAuthRegisterRequest.gender())
                .age(oAuthRegisterRequest.ageGroup())
                .build();

        return makeLoginResponse(memberRepository.save(member));
    }

    private LoginResponse makeLoginResponse(Member member) {
        String accessToken = jwtTokenProvider.generateAccessToken(member.getId().toString());
        String refreshToken = jwtTokenProvider.generateRefreshToken();

        String refreshTokenUuid = jwtTokenProvider.extractRefreshTokenSubject(refreshToken);

        redisTemplate.opsForValue().set(
                "RT:" + refreshTokenUuid,
                member.getId().toString(),
                jwtTokenProvider.getRefreshTokenExpiration(),
                TimeUnit.MILLISECONDS
        );
        return LoginResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .name(member.getName())
                .age(member.getAge())
                .gender(member.getGender())
                .build();
    }

        return new TokenResponse(newAccessToken, newRefreshToken);
    @Override
    public void updatePlace(Member member, MemberPlacePutRequest request) {
        memberPlaceRepository.deleteByMemberAndType(member, request.type());
        MemberPlace memberPlace = MemberPlace.builder()
                .x(request.x())
                .y(request.y())
                .address(request.address())
                .member(member)
                .arrivalTime(request.arrivalTime()).build();
        memberPlaceRepository.save(memberPlace);
    }
}
