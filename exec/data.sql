INSERT INTO member (member_id, oauth_type, oauth_id, name, age, gender)
VALUES
    (1, 'KAKAO', 'oauth_id_1', '조승기', 30, 'M'),
    (2, 'KAKAO', 'oauth_id_2', '김종호', 25, 'F')
ON CONFLICT DO NOTHING;

INSERT INTO member_place (member_place_id, member_id, type, x, y, address, arrival_time, place_name)
VALUES
    (1, 1, 1, 37.512585, 127.102544, '서울 송파구 올림픽로 300', '09:00:00', null),
    (2, 1, 2, 37.501280, 127.039598, '서울 강남구 역삼동 718-5', '10:30:00', null),
    (3, 1, 3, 37.566404, 126.938713, '서울 서대문구 연세로 50', '13:00:00', null),
    (4, 1, 4, 37.503946, 127.004750, '서울특별시 서초구 반포동 19-3', '11:00:00', '친구집')

ON CONFLICT DO NOTHING;
