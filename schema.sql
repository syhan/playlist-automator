CREATE TABLE contributors (
  UID INTEGER PRIMARY KEY,
  name TEXT
);

CREATE TABLE contributions (
    UID INTEGER,
    TRACK_ID INTEGER,
    DAY DATE
);

CREATE TABLE tracks (
    TRACK_ID INTEGER,
    ALBUM_ID INTEGER,
    ARTIST TEXT,
    NAME TEXT
);

CREATE TABLE albums (
    ALBUM_ID INTEGER PRIMARY KEY,
    NAME TEXT
);


CREATE TABLE history (
    DAY DATE,
    THEME TEXT
);

INSERT INTO contributors VALUES ('17944090', '依旧是vp影迷');
INSERT INTO contributors VALUES ('20226098', '大藏藏');
INSERT INTO contributors VALUES ('52272721', '荒集卷子');
INSERT INTO contributors VALUES ('75306666', '歪Joey');
INSERT INTO contributors VALUES ('100091090', '任可爱-');
INSERT INTO contributors VALUES ('109213963', '会有猫的咸菜');
INSERT INTO contributors VALUES ('109902362', 'NightCar0312');
INSERT INTO contributors VALUES ('283864891', '噗嗤就知道吃');
INSERT INTO contributors VALUES ('296658058', '吼吼破喉咙');
INSERT INTO contributors VALUES ('334095530', '啃啃坑坑');
INSERT INTO contributors VALUES ('342404009', '一本只有省略号的书');
INSERT INTO contributors VALUES ('355654248', 'KeyL_0207');
INSERT INTO contributors VALUES ('368885808', '雒哈哈');
INSERT INTO contributors VALUES ('372426144', '-由里畅');
INSERT INTO contributors VALUES ('444666870', '冒牌患者');
INSERT INTO contributors VALUES ('474989529', 'LongDreamRiver');
INSERT INTO contributors VALUES ('483270183', '憖憖a');
INSERT INTO contributors VALUES ('1299733662', '透过星星的月亮');
INSERT INTO contributors VALUES ('1323257970', '流金年华1994');
INSERT INTO contributors VALUES ('1803720314', '三絲餃子');
INSERT INTO contributors VALUES ('1969429200', '希澈yuri9doo');
INSERT INTO contributors VALUES ('4030706955', 'satoshi的鱼');
INSERT INTO contributions VALUES ('334095530', '486999662', '2022/11/12');
INSERT INTO contributions VALUES ('334095530', '1886221713', '2022/11/12');
INSERT INTO contributions VALUES ('334095530', '409031377', '2022/11/12');
INSERT INTO contributions VALUES ('109213963', '28977819', '2022/11/12');
INSERT INTO contributions VALUES ('1323257970', '188177', '2022/11/12');
INSERT INTO contributions VALUES ('1323257970', '187993', '2022/11/12');
INSERT INTO contributions VALUES ('109213963', '353413', '2022/11/12');
INSERT INTO contributions VALUES ('296658058', '22201008', '2022/11/12');
INSERT INTO contributions VALUES ('1323257970', '406737702', '2022/11/12');
INSERT INTO contributions VALUES ('109213963', '28996921', '2022/11/12');
INSERT INTO contributions VALUES ('296658058', '22200079', '2022/11/12');
INSERT INTO contributions VALUES ('296658058', '1465253979', '2022/11/12');
INSERT INTO contributions VALUES ('52272721', '22650573', '2023/03/17');
INSERT INTO contributions VALUES ('52272721', '1389882639', '2023/03/17');
INSERT INTO contributions VALUES ('296658058', '299515', '2023/03/17');
INSERT INTO contributions VALUES ('296658058', '1375468479', '2023/03/17');
INSERT INTO contributions VALUES ('52272721', '1809755469', '2023/03/17');
INSERT INTO contributions VALUES ('4030706955', '1353535', '2022/04/08');
INSERT INTO contributions VALUES ('4030706955', '404182424', '2022/04/08');
INSERT INTO contributions VALUES ('4030706955', '299660', '2022/04/08');
INSERT INTO contributions VALUES ('100091090', '28009051', '2022/04/08');
INSERT INTO contributions VALUES ('100091090', '36894550', '2022/04/08');
INSERT INTO contributions VALUES ('100091090', '1470057289', '2022/04/08');
INSERT INTO contributions VALUES ('283864891', '1488790719', '2022/04/08');
INSERT INTO contributions VALUES ('1299733662', '1903773837', '2022/04/08');
INSERT INTO contributions VALUES ('1299733662', '348074', '2022/04/08');
INSERT INTO contributions VALUES ('296658058', '19550016', '2022/04/08');
INSERT INTO contributions VALUES ('296658058', '167916', '2022/04/08');
INSERT INTO contributions VALUES ('296658058', '454828916', '2022/04/08');
INSERT INTO contributions VALUES ('109213963', '1805380249', '2021/08/10');
INSERT INTO contributions VALUES ('109213963', '139392', '2021/08/10');
INSERT INTO contributions VALUES ('109213963', '186100', '2021/08/10');
INSERT INTO contributions VALUES ('444666870', '1808008464', '2021/08/10');
INSERT INTO contributions VALUES ('444666870', '1857011954', '2021/08/10');
INSERT INTO contributions VALUES ('474989529', '1299844834', '2021/08/10');
INSERT INTO contributions VALUES ('1803720314', '2701514', '2021/08/10');
INSERT INTO contributions VALUES ('368885808', '1347650986', '2021/08/10');
INSERT INTO contributions VALUES ('368885808', '27698092', '2021/08/10');
INSERT INTO contributions VALUES ('1803720314', '326734', '2021/08/10');
INSERT INTO contributions VALUES ('20226098', '109884', '2021/08/10');
INSERT INTO contributions VALUES ('283864891', '579954', '2021/08/10');
INSERT INTO contributions VALUES ('1803720314', '551339740', '2021/08/10');
INSERT INTO contributions VALUES ('20226098', '357423', '2021/08/10');
INSERT INTO contributions VALUES ('283864891', '355989', '2021/08/10');
INSERT INTO contributions VALUES ('20226098', '25950606', '2021/08/10');
INSERT INTO contributions VALUES ('342404009', '87565', '2021/08/10');
INSERT INTO contributions VALUES ('483270183', '30148802', '2021/08/10');
INSERT INTO contributions VALUES ('296658058', '22201016', '2021/08/10');
INSERT INTO contributions VALUES ('100091090', '483242434', '2021/08/10');
INSERT INTO contributions VALUES ('296658058', '135029', '2021/08/10');
INSERT INTO contributions VALUES ('342404009', '176939', '2021/08/10');
INSERT INTO contributions VALUES ('342404009', '177028', '2021/08/10');
INSERT INTO contributions VALUES ('296658058', '185715', '2021/08/10');
INSERT INTO contributions VALUES ('483270183', '1379663217', '2021/08/10');
INSERT INTO contributions VALUES ('100091090', '1388366084', '2021/08/10');
INSERT INTO contributions VALUES ('100091090', '357253', '2021/08/10');
INSERT INTO contributions VALUES ('355654248', '1413368107', '2022/03/16');
INSERT INTO contributions VALUES ('355654248', '1381814876', '2022/03/16');
INSERT INTO contributions VALUES ('355654248', '1426157742', '2022/03/16');
INSERT INTO contributions VALUES ('109213963', '308494', '2022/03/16');
INSERT INTO contributions VALUES ('109213963', '509512939', '2022/03/16');
INSERT INTO contributions VALUES ('372426144', '1811881459', '2022/03/16');
INSERT INTO contributions VALUES ('372426144', '1389882897', '2022/03/16');
INSERT INTO contributions VALUES ('109902362', '1891711659', '2022/03/16');
INSERT INTO contributions VALUES ('372426144', '1452668705', '2022/03/16');
INSERT INTO contributions VALUES ('109902362', '385973', '2022/03/16');
INSERT INTO contributions VALUES ('109213963', '65334', '2022/03/16');
INSERT INTO contributions VALUES ('109902362', '29567192', '2022/03/16');
INSERT INTO contributions VALUES ('100091090', '1889635394', '2022/03/16');
INSERT INTO contributions VALUES ('100091090', '1886122351', '2022/03/16');
INSERT INTO contributions VALUES ('20226098', '348101', '2022/03/16');
INSERT INTO contributions VALUES ('100091090', '26256267', '2022/03/16');
INSERT INTO contributions VALUES ('1969429200', '5243416', '2022/03/16');
INSERT INTO contributions VALUES ('20226098', '208941', '2022/03/16');
INSERT INTO contributions VALUES ('20226098', '297612', '2022/03/16');
INSERT INTO contributions VALUES ('75306666', '187953', '2022/03/16');
INSERT INTO contributions VALUES ('1969429200', '27646205', '2022/03/16');
INSERT INTO contributions VALUES ('1969429200', '139357', '2022/03/16');
INSERT INTO contributions VALUES ('296658058', '185713', '2022/03/16');
INSERT INTO contributions VALUES ('296658058', '299264', '2022/03/16');
INSERT INTO contributions VALUES ('296658058', '394669', '2022/03/16');
INSERT INTO contributions VALUES ('296658058', '209407', '2021/09/12');
INSERT INTO contributions VALUES ('296658058', '385973', '2021/09/12');
INSERT INTO contributions VALUES ('296658058', '526470351', '2021/09/12');
INSERT INTO contributions VALUES ('109213963', '1854105063', '2021/09/12');
INSERT INTO contributions VALUES ('109213963', '1368756097', '2021/09/12');
INSERT INTO contributions VALUES ('109213963', '579954', '2021/09/12');
INSERT INTO contributions VALUES ('17944090', '4981374', '2021/09/12');
INSERT INTO contributions VALUES ('17944090', '511783974', '2021/09/12');
INSERT INTO contributions VALUES ('17944090', '1317457805', '2021/09/12');
INSERT INTO contributions VALUES ('283864891', '1848375872', '2021/09/12');
INSERT INTO contributions VALUES ('1803720314', '1482927399', '2021/09/12');
INSERT INTO contributions VALUES ('1803720314', '22712636', '2021/09/12');
INSERT INTO contributions VALUES ('1803720314', '516358164', '2021/09/12');
INSERT INTO contributions VALUES ('283864891', '1452913090', '2021/09/12');
INSERT INTO contributions VALUES ('283864891', '1817506681', '2021/09/12');
INSERT INTO contributions VALUES ('100091090', '1473720185', '2021/09/12');
INSERT INTO contributions VALUES ('100091090', '987320', '2021/09/12');
INSERT INTO contributions VALUES ('100091090', '1877027537', '2021/09/12');
INSERT INTO contributions VALUES ('368885808', '25843038', '2021/09/12');
INSERT INTO contributions VALUES ('368885808', '1347650362', '2021/09/12');
INSERT INTO contributions VALUES ('20226098', '139463', '2021/09/12');
INSERT INTO contributions VALUES ('20226098', '144359', '2021/09/12');
INSERT INTO contributions VALUES ('20226098', '385488', '2021/09/12');
INSERT INTO contributions VALUES ('483270183', '326705', '2021/09/12');
INSERT INTO contributions VALUES ('483270183', '459839016', '2021/09/12');
INSERT INTO contributions VALUES ('483270183', '421870099', '2021/09/12');
INSERT INTO contributions VALUES ('296658058', '230095', '2022/10/26');
INSERT INTO contributions VALUES ('296658058', '168500', '2022/10/26');
INSERT INTO contributions VALUES ('296658058', '5280041', '2022/10/26');
