package com.gilin.route.domain.member.service;

import com.gilin.route.domain.member.dto.request.OAuthRegisterRequest;
import com.gilin.route.domain.member.dto.response.PlaceResponse;
import com.gilin.route.domain.member.entity.MemberPlace;
import com.gilin.route.domain.member.repository.MemberPlaceRepository;
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
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {

    private final MemberRepository memberRepository;
    private final MemberPlaceRepository memberPlaceRepository;
    private final OAuthKakaoClient kakaoClient;
    private final JwtTokenProvider jwtTokenProvider;
    private final RedisTemplate<String, String> redisTemplate;

    private static final String REFRESH_TOKEN_PREFIX = "RT:";

    @Override
    public LoginResponse login(OAuthLoginRequest oAuthLoginRequest) {
        KakaoInfoResponse response = kakaoClient.getUser(oAuthLoginRequest.accessToken());

        Member member = memberRepository.findByoAuthTypeAndOauthId(OAuthType.KAKAO, response.id())
                .orElseThrow(() -> new GilinException(HttpStatus.UNAUTHORIZED, "회원가입이 필요합니다."));

        return makeLoginResponse(member);
    }

    @Override
    public LoginResponse reissue(String refreshToken) {
        jwtTokenProvider.validateRefreshToken(refreshToken);

        String refreshTokenUuid = jwtTokenProvider.extractRefreshTokenSubject(refreshToken);

        String memberId = redisTemplate.opsForValue().get(REFRESH_TOKEN_PREFIX + refreshTokenUuid);
        if (Objects.isNull(memberId)) {
            throw new GilinException(HttpStatus.UNAUTHORIZED, "유효하지 않은 리프레시 토큰입니다.");
        }
        redisTemplate.delete(REFRESH_TOKEN_PREFIX + refreshTokenUuid);
        Member member = memberRepository.findById(Long.parseLong(memberId))
                .orElseThrow(() -> new GilinException(HttpStatus.UNAUTHORIZED, "유효하지 않은 리프레시 토큰입니다."));

        return makeLoginResponse(member);
    }

    @Override
    public LoginResponse register(OAuthRegisterRequest oAuthRegisterRequest) {
        KakaoInfoResponse response = kakaoClient.getUser(oAuthRegisterRequest.accessToken());

        memberRepository.findByoAuthTypeAndOauthId(OAuthType.KAKAO, response.id())
                .ifPresent(m -> {
                    throw new GilinException(HttpStatus.CONFLICT, "이미 가입한 회원입니다.");
                });

        Member member = Member.builder()
                .oauthId(response.id())
                .oAuthType(oAuthRegisterRequest.oAuthType())
                .name(oAuthRegisterRequest.name())
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
                REFRESH_TOKEN_PREFIX + refreshTokenUuid,
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

    @Override
    public LoginResponse testLogin(Long memberId) {
        return makeLoginResponse(memberRepository.findById(memberId).orElseThrow());
    }

    @Override
    public List<PlaceResponse> getPlace(Member member) {
        return memberPlaceRepository.findByMember(member)
                .stream()
                .map(PlaceResponse::of)
                .toList();
    }
}