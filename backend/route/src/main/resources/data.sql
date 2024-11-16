INSERT INTO member (member_id, oauth_type, oauth_id, name, age, gender)
VALUES
    (1, 'KAKAO', 'oauth_id_1', '조승기', 30, 'M'),
    (2, 'KAKAO', 'oauth_id_2', '김종호', 25, 'F')
ON CONFLICT DO NOTHING;

INSERT INTO member_place (member_place_id, member_id, type, x, y, address, arrival_time)
VALUES
    (1, 1, 1, 37.5665, 126.9780, '서울역', '09:00:00'),
    (2, 1, 2, 37.5651, 126.9895, '경복궁', '10:30:00'),
    (3, 2, 1, 37.5796, 126.9770, '북촌한옥마을', '11:00:00'),
    (4, 2, 2, 37.5512, 126.9882, '남산타워', '13:00:00')
ON CONFLICT DO NOTHING;
