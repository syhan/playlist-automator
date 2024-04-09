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

INSERT INTO contributors VALUES ('20226098', '大藏藏');
INSERT INTO contributors VALUES ('41625506', '默已释然');
INSERT INTO contributors VALUES ('52272721', '莲花芒果');
INSERT INTO contributors VALUES ('63728035', '旁人一眼便能看出谁是少叶女士');
INSERT INTO contributors VALUES ('69961016', '阿乄东');
INSERT INTO contributors VALUES ('75306666', '歪Joey');
INSERT INTO contributors VALUES ('83715386', 'cidgur');
INSERT INTO contributors VALUES ('90348498', '傅果果他爹');
INSERT INTO contributors VALUES ('93825695', '四处溜达的铁锤');
INSERT INTO contributors VALUES ('100091090', '任可爱-');
INSERT INTO contributors VALUES ('109213963', '会有猫的咸菜');
INSERT INTO contributors VALUES ('109902362', 'NightCar0312');
INSERT INTO contributors VALUES ('110687265', '在聆听吗');
INSERT INTO contributors VALUES ('135858701', '橙月leo');
INSERT INTO contributors VALUES ('280754621', 'Cheung8');
INSERT INTO contributors VALUES ('283864891', '噗嗤就知道吃');
INSERT INTO contributors VALUES ('296658058', '吼吼破喉咙');
INSERT INTO contributors VALUES ('321118040', 'EMILYwhatever');
INSERT INTO contributors VALUES ('325890444', '养什么手机宠物');
INSERT INTO contributors VALUES ('334095530', '啃啃坑坑');
INSERT INTO contributors VALUES ('342404009', '一本只有省略号的书');
INSERT INTO contributors VALUES ('355654248', 'PP-0207');
INSERT INTO contributors VALUES ('358269079', '感觉jojo');
INSERT INTO contributors VALUES ('368885808', '雒哈哈');
INSERT INTO contributors VALUES ('372426144', '-由里畅');
INSERT INTO contributors VALUES ('374278278', '稳如cheems');
INSERT INTO contributors VALUES ('474989529', 'LongDreamRiver');
INSERT INTO contributors VALUES ('483270183', '憖憖a');
INSERT INTO contributors VALUES ('540114760', '黑黑黑矮星-');
INSERT INTO contributors VALUES ('541001620', '土豆大笨蛋');
INSERT INTO contributors VALUES ('545181844', '-ccrystal_');
INSERT INTO contributors VALUES ('1299733662', '透过星星的月亮');
INSERT INTO contributors VALUES ('1343967564', '-噼里啪啦丶');
INSERT INTO contributors VALUES ('1497085517', '忽然停止扇动');
INSERT INTO contributors VALUES ('1528570202', 'oldsoup-');
INSERT INTO contributors VALUES ('1647240833', '晨一染');
INSERT INTO contributors VALUES ('1803720314', '三絲餃子');
INSERT INTO contributors VALUES ('1969429200', '希澈yuri9doo');
INSERT INTO contributors VALUES ('3248162956', '伍伍aww');
INSERT INTO contributors VALUES ('3721880397', '素履子');
INSERT INTO contributors VALUES ('4030706955', 'satoshi的鱼');
INSERT INTO contributors VALUES ('4036417663', '很哇噻的一只熊');
INSERT INTO contributions VALUES ('109213963', '167876', '2023/05/30');
INSERT INTO contributions VALUES ('109213963', '5264352', '2023/05/30');
INSERT INTO contributions VALUES ('334095530', '1372510711', '2023/05/30');
INSERT INTO contributions VALUES ('334095530', '1920623030', '2023/05/30');
INSERT INTO contributions VALUES ('474989529', '479219330', '2023/05/30');
INSERT INTO contributions VALUES ('109213963', '1913763108', '2023/05/30');
INSERT INTO contributions VALUES ('334095530', '500665348', '2023/05/30');
INSERT INTO contributions VALUES ('296658058', '300064', '2023/05/30');
INSERT INTO contributions VALUES ('296658058', '68377', '2023/05/30');
INSERT INTO contributions VALUES ('358269079', '27494071', '2023/02/03');
INSERT INTO contributions VALUES ('358269079', '1940771896', '2023/02/03');
INSERT INTO contributions VALUES ('358269079', '2014338474', '2023/02/03');
INSERT INTO contributions VALUES ('296658058', '299650', '2023/02/03');
INSERT INTO contributions VALUES ('296658058', '210680', '2023/02/03');
INSERT INTO contributions VALUES ('545181844', '1367521756', '2023/02/03');
INSERT INTO contributions VALUES ('296658058', '158939', '2023/02/03');
INSERT INTO contributions VALUES ('545181844', '21973899', '2023/02/03');
INSERT INTO contributions VALUES ('135858701', '4237923', '2022/12/22');
INSERT INTO contributions VALUES ('135858701', '29715559', '2022/12/22');
INSERT INTO contributions VALUES ('135858701', '1405908431', '2022/12/22');
INSERT INTO contributions VALUES ('540114760', '1403921413', '2022/12/22');
INSERT INTO contributions VALUES ('540114760', '109444', '2022/12/22');
INSERT INTO contributions VALUES ('540114760', '327186', '2022/12/22');
INSERT INTO contributions VALUES ('296658058', '1854657935', '2022/12/22');
INSERT INTO contributions VALUES ('296658058', '1334270056', '2022/12/22');
INSERT INTO contributions VALUES ('100091090', '1806316871', '2022/10/27');
INSERT INTO contributions VALUES ('100091090', '1805086601', '2022/10/27');
INSERT INTO contributions VALUES ('100091090', '1493931568', '2022/10/27');
INSERT INTO contributions VALUES ('1299733662', '39436490', '2022/10/27');
INSERT INTO contributions VALUES ('1299733662', '394679', '2022/10/27');
INSERT INTO contributions VALUES ('1299733662', '441120217', '2022/10/27');
INSERT INTO contributions VALUES ('109213963', '1834732035', '2022/10/27');
INSERT INTO contributions VALUES ('109213963', '1808250358', '2022/10/27');
INSERT INTO contributions VALUES ('109213963', '353415', '2022/10/27');
INSERT INTO contributions VALUES ('296658058', '5179544', '2022/10/27');
INSERT INTO contributions VALUES ('296658058', '287248', '2022/10/27');
INSERT INTO contributions VALUES ('296658058', '190563', '2022/10/27');
INSERT INTO contributions VALUES ('541001620', '1836139178', '2023/05/31');
INSERT INTO contributions VALUES ('541001620', '77462', '2023/05/31');
INSERT INTO contributions VALUES ('545181844', '1474959445', '2023/05/31');
INSERT INTO contributions VALUES ('541001620', '2026259394', '2023/05/31');
INSERT INTO contributions VALUES ('545181844', '28612195', '2023/05/31');
INSERT INTO contributions VALUES ('545181844', '472045245', '2023/05/31');
INSERT INTO contributions VALUES ('334095530', '447925725', '2023/05/31');
INSERT INTO contributions VALUES ('334095530', '2019831753', '2023/05/31');
INSERT INTO contributions VALUES ('334095530', '2046562631', '2023/05/31');
INSERT INTO contributions VALUES ('296658058', '283846', '2023/05/31');
INSERT INTO contributions VALUES ('100091090', '35618549', '2021/08/17');
INSERT INTO contributions VALUES ('100091090', '1838505400', '2021/08/17');
INSERT INTO contributions VALUES ('100091090', '29715559', '2021/08/17');
INSERT INTO contributions VALUES ('368885808', '34509586', '2021/08/17');
INSERT INTO contributions VALUES ('474989529', '529319768', '2021/08/17');
INSERT INTO contributions VALUES ('4030706955', '28587865', '2021/08/17');
INSERT INTO contributions VALUES ('4030706955', '28267674', '2021/08/17');
INSERT INTO contributions VALUES ('4030706955', '139481', '2021/08/17');
INSERT INTO contributions VALUES ('109213963', '4877246', '2021/08/17');
INSERT INTO contributions VALUES ('109213963', '1393739628', '2021/08/17');
INSERT INTO contributions VALUES ('1803720314', '1492362609', '2021/08/17');
INSERT INTO contributions VALUES ('1803720314', '287149', '2021/08/17');
INSERT INTO contributions VALUES ('1803720314', '1855487830', '2021/08/17');
INSERT INTO contributions VALUES ('109213963', '545589259', '2021/08/17');
INSERT INTO contributions VALUES ('20226098', '145245', '2021/08/17');
INSERT INTO contributions VALUES ('20226098', '327363', '2021/08/17');
INSERT INTO contributions VALUES ('20226098', '355947', '2021/08/17');
INSERT INTO contributions VALUES ('296658058', '139463', '2021/08/17');
INSERT INTO contributions VALUES ('296658058', '354432', '2021/08/17');
INSERT INTO contributions VALUES ('296658058', '476659144', '2021/08/17');
INSERT INTO contributions VALUES ('483270183', '357312', '2021/08/17');
INSERT INTO contributions VALUES ('483270183', '1433448814', '2021/08/17');
INSERT INTO contributions VALUES ('20226098', '1810827382', '2021/09/04');
INSERT INTO contributions VALUES ('374278278', '1336508425', '2021/09/04');
INSERT INTO contributions VALUES ('374278278', '1461637510', '2021/09/04');
INSERT INTO contributions VALUES ('374278278', '1813960297', '2021/09/04');
INSERT INTO contributions VALUES ('540114760', '1332675144', '2021/09/04');
INSERT INTO contributions VALUES ('540114760', '31738245', '2021/09/04');
INSERT INTO contributions VALUES ('540114760', '1473886611', '2021/09/04');
INSERT INTO contributions VALUES ('1343967564', '1394402692', '2021/09/04');
INSERT INTO contributions VALUES ('1343967564', '1459783374', '2021/09/04');
INSERT INTO contributions VALUES ('1343967564', '386829', '2021/09/04');
INSERT INTO contributions VALUES ('1803720314', '1452668705', '2021/09/04');
INSERT INTO contributions VALUES ('1803720314', '522351063', '2021/09/04');
INSERT INTO contributions VALUES ('1803720314', '536623692', '2021/09/04');
INSERT INTO contributions VALUES ('296658058', '354352', '2021/09/04');
INSERT INTO contributions VALUES ('296658058', '1474411442', '2021/09/04');
INSERT INTO contributions VALUES ('296658058', '299432', '2021/09/04');
INSERT INTO contributions VALUES ('100091090', '549309101', '2021/09/04');
INSERT INTO contributions VALUES ('483270183', '29592187', '2021/09/04');
INSERT INTO contributions VALUES ('483270183', '26427666', '2021/09/04');
INSERT INTO contributions VALUES ('342404009', '5245693', '2021/09/04');
INSERT INTO contributions VALUES ('342404009', '190203', '2021/09/04');
INSERT INTO contributions VALUES ('342404009', '31877511', '2021/09/04');
INSERT INTO contributions VALUES ('100091090', '157152', '2021/09/04');
INSERT INTO contributions VALUES ('109213963', '228755', '2021/09/04');
INSERT INTO contributions VALUES ('109213963', '26601005', '2021/09/04');
INSERT INTO contributions VALUES ('100091090', '1826783715', '2021/09/04');
INSERT INTO contributions VALUES ('109213963', '191179', '2021/09/04');
INSERT INTO contributions VALUES ('20226098', '26450089', '2021/09/04');
INSERT INTO contributions VALUES ('20226098', '68099', '2021/09/04');
INSERT INTO contributions VALUES ('20226098', '85570', '2021/09/04');
INSERT INTO contributions VALUES ('334095530', '64481', '2022/12/02');
INSERT INTO contributions VALUES ('334095530', '25706277', '2022/12/02');
INSERT INTO contributions VALUES ('334095530', '188227', '2022/12/02');
INSERT INTO contributions VALUES ('296658058', '400162028', '2022/12/02');
INSERT INTO contributions VALUES ('296658058', '1302604754', '2022/12/02');
INSERT INTO contributions VALUES ('296658058', '5270868', '2022/12/02');
INSERT INTO contributions VALUES ('52272721', '28996921', '2023/02/28');
INSERT INTO contributions VALUES ('358269079', '256946', '2023/02/28');
INSERT INTO contributions VALUES ('52272721', '109236', '2023/02/28');
INSERT INTO contributions VALUES ('52272721', '365622', '2023/02/28');
INSERT INTO contributions VALUES ('75306666', '2006426334', '2023/02/28');
INSERT INTO contributions VALUES ('296658058', '185796', '2023/02/28');
INSERT INTO contributions VALUES ('296658058', '27928230', '2023/02/28');
INSERT INTO contributions VALUES ('296658058', '394690', '2023/02/28');
INSERT INTO contributions VALUES ('20226098', '327387', '2022/10/29');
INSERT INTO contributions VALUES ('20226098', '186106', '2022/10/29');
INSERT INTO contributions VALUES ('20226098', '350854', '2022/10/29');
INSERT INTO contributions VALUES ('109213963', '1926899904', '2022/10/29');
INSERT INTO contributions VALUES ('41625506', '28258937', '2022/10/29');
INSERT INTO contributions VALUES ('109213963', '1484134848', '2022/10/29');
INSERT INTO contributions VALUES ('109213963', '1488990357', '2022/10/29');
INSERT INTO contributions VALUES ('100091090', '297894', '2022/10/29');
INSERT INTO contributions VALUES ('100091090', '255294', '2022/10/29');
INSERT INTO contributions VALUES ('100091090', '5246622', '2022/10/29');
INSERT INTO contributions VALUES ('374278278', '1963720468', '2022/10/29');
INSERT INTO contributions VALUES ('374278278', '1987796847', '2022/10/29');
INSERT INTO contributions VALUES ('1299733662', '490595927', '2022/10/29');
INSERT INTO contributions VALUES ('296658058', '139808', '2022/10/29');
INSERT INTO contributions VALUES ('1299733662', '1415576894', '2022/10/29');
INSERT INTO contributions VALUES ('1299733662', '569200211', '2022/10/29');
INSERT INTO contributions VALUES ('374278278', '1963720284', '2022/10/29');
INSERT INTO contributions VALUES ('296658058', '327190', '2022/10/29');
INSERT INTO contributions VALUES ('296658058', '1438465625', '2022/10/29');
INSERT INTO contributions VALUES ('374278278', '1968327487', '2022/09/09');
INSERT INTO contributions VALUES ('374278278', '1968779703', '2022/09/09');
INSERT INTO contributions VALUES ('296658058', '299652', '2022/09/09');
INSERT INTO contributions VALUES ('321118040', '1959668190', '2022/09/09');
INSERT INTO contributions VALUES ('296658058', '553546158', '2022/09/09');
INSERT INTO contributions VALUES ('374278278', '105926', '2022/09/09');
INSERT INTO contributions VALUES ('321118040', '27945088', '2022/09/09');
INSERT INTO contributions VALUES ('296658058', '5274363', '2022/09/09');
INSERT INTO contributions VALUES ('540114760', '1929356871', '2023/01/08');
INSERT INTO contributions VALUES ('135858701', '536623692', '2023/01/08');
INSERT INTO contributions VALUES ('540114760', '1469826255', '2023/01/08');
INSERT INTO contributions VALUES ('540114760', '1433786457', '2023/01/08');
INSERT INTO contributions VALUES ('135858701', '92778', '2023/01/08');
INSERT INTO contributions VALUES ('135858701', '108245', '2023/01/08');
INSERT INTO contributions VALUES ('296658058', '139424', '2023/01/08');
INSERT INTO contributions VALUES ('296658058', '300055', '2023/01/08');
INSERT INTO contributions VALUES ('100091090', '1323736730', '2022/07/01');
INSERT INTO contributions VALUES ('100091090', '28009051', '2022/07/01');
INSERT INTO contributions VALUES ('135858701', '1885840249', '2022/07/01');
INSERT INTO contributions VALUES ('100091090', '193473', '2022/07/01');
INSERT INTO contributions VALUES ('296658058', '1410233867', '2022/07/01');
INSERT INTO contributions VALUES ('20226098', '1486086374', '2022/07/01');
INSERT INTO contributions VALUES ('20226098', '190244', '2022/07/01');
INSERT INTO contributions VALUES ('20226098', '103432', '2022/07/01');
INSERT INTO contributions VALUES ('296658058', '185706', '2022/07/01');
INSERT INTO contributions VALUES ('296658058', '108632', '2022/07/01');
INSERT INTO contributions VALUES ('296658058', '147258', '2022/07/01');
INSERT INTO contributions VALUES ('109213963', '501133798', '2021/12/01');
INSERT INTO contributions VALUES ('109213963', '1487205164', '2021/12/01');
INSERT INTO contributions VALUES ('109213963', '454924322', '2021/12/01');
INSERT INTO contributions VALUES ('296658058', '385973', '2021/12/01');
INSERT INTO contributions VALUES ('296658058', '300148', '2021/12/01');
INSERT INTO contributions VALUES ('296658058', '327192', '2021/12/01');
INSERT INTO contributions VALUES ('1528570202', '1318571230', '2021/12/01');
INSERT INTO contributions VALUES ('109902362', '185824', '2021/12/01');
INSERT INTO contributions VALUES ('1528570202', '26459609', '2021/12/01');
INSERT INTO contributions VALUES ('1528570202', '1410647903', '2021/12/01');
INSERT INTO contributions VALUES ('1528570202', '28739036', '2021/12/01');
INSERT INTO contributions VALUES ('1528570202', '1837818274', '2021/12/01');
INSERT INTO contributions VALUES ('109902362', '1812202432', '2021/12/01');
INSERT INTO contributions VALUES ('109902362', '65931', '2021/12/01');
INSERT INTO contributions VALUES ('100091090', '1859321', '2021/12/01');
INSERT INTO contributions VALUES ('100091090', '350848', '2021/12/01');
INSERT INTO contributions VALUES ('20226098', '28996919', '2021/12/01');
INSERT INTO contributions VALUES ('20226098', '156324', '2021/12/01');
INSERT INTO contributions VALUES ('1497085517', '418257873', '2021/12/01');
INSERT INTO contributions VALUES ('1497085517', '1840927022', '2021/12/01');
INSERT INTO contributions VALUES ('20226098', '25843040', '2021/12/01');
INSERT INTO contributions VALUES ('1497085517', '1808250358', '2021/12/01');
INSERT INTO contributions VALUES ('1969429200', '27646205', '2021/12/01');
INSERT INTO contributions VALUES ('100091090', '167942', '2021/12/01');
INSERT INTO contributions VALUES ('1969429200', '520458664', '2021/12/01');
INSERT INTO contributions VALUES ('1969429200', '401722082', '2021/12/01');
INSERT INTO contributions VALUES ('283864891', '22644323', '2021/08/13');
INSERT INTO contributions VALUES ('100091090', '437715323', '2021/08/13');
INSERT INTO contributions VALUES ('20226098', '29995314', '2021/08/13');
INSERT INTO contributions VALUES ('20226098', '571059603', '2021/08/13');
INSERT INTO contributions VALUES ('20226098', '22822543', '2021/08/13');
INSERT INTO contributions VALUES ('109213963', '1424286681', '2021/08/13');
INSERT INTO contributions VALUES ('483270183', '1080657', '2021/08/13');
INSERT INTO contributions VALUES ('109213963', '1866877994', '2021/08/13');
INSERT INTO contributions VALUES ('109213963', '1497179369', '2021/08/13');
INSERT INTO contributions VALUES ('1803720314', '816978', '2021/08/13');
INSERT INTO contributions VALUES ('540114760', '29995363', '2021/08/13');
INSERT INTO contributions VALUES ('540114760', '33599265', '2021/08/13');
INSERT INTO contributions VALUES ('540114760', '27583401', '2021/08/13');
INSERT INTO contributions VALUES ('3248162956', '1401740583', '2021/08/13');
INSERT INTO contributions VALUES ('3248162956', '760058', '2021/08/13');
INSERT INTO contributions VALUES ('483270183', '34218388', '2021/08/13');
INSERT INTO contributions VALUES ('1803720314', '1345936196', '2021/08/13');
INSERT INTO contributions VALUES ('1803720314', '500014', '2021/08/13');
INSERT INTO contributions VALUES ('483270183', '28533584', '2021/08/13');
INSERT INTO contributions VALUES ('483270183', '784594', '2021/08/13');
INSERT INTO contributions VALUES ('368885808', '1330589933', '2021/08/13');
INSERT INTO contributions VALUES ('368885808', '1330603087', '2021/08/13');
INSERT INTO contributions VALUES ('368885808', '1823035883', '2021/08/13');
INSERT INTO contributions VALUES ('368885808', '29473749', '2021/08/13');
INSERT INTO contributions VALUES ('374278278', '29027341', '2021/08/13');
INSERT INTO contributions VALUES ('374278278', '31574225', '2021/08/13');
INSERT INTO contributions VALUES ('296658058', '28864473', '2021/08/13');
INSERT INTO contributions VALUES ('374278278', '441835079', '2021/08/13');
INSERT INTO contributions VALUES ('296658058', '1484843', '2021/08/13');
INSERT INTO contributions VALUES ('296658058', '1486430', '2021/08/13');
INSERT INTO contributions VALUES ('100091090', '1806779079', '2021/08/13');
INSERT INTO contributions VALUES ('100091090', '451991040', '2021/08/13');
INSERT INTO contributions VALUES ('358269079', '1331819951', '2022/11/18');
INSERT INTO contributions VALUES ('358269079', '187723', '2022/11/18');
INSERT INTO contributions VALUES ('334095530', '1481635386', '2022/11/18');
INSERT INTO contributions VALUES ('109213963', '26427653', '2022/11/18');
INSERT INTO contributions VALUES ('334095530', '1456669276', '2022/11/18');
INSERT INTO contributions VALUES ('109213963', '386829', '2022/11/18');
INSERT INTO contributions VALUES ('545181844', '26177038', '2022/11/18');
INSERT INTO contributions VALUES ('545181844', '16661481', '2022/11/18');
INSERT INTO contributions VALUES ('334095530', '381849', '2022/11/18');
INSERT INTO contributions VALUES ('109213963', '1465253976', '2022/11/18');
INSERT INTO contributions VALUES ('52272721', '520242139', '2022/11/18');
INSERT INTO contributions VALUES ('52272721', '350133', '2022/11/18');
INSERT INTO contributions VALUES ('52272721', '1807799506', '2022/11/18');
INSERT INTO contributions VALUES ('296658058', '151200', '2022/11/18');
INSERT INTO contributions VALUES ('296658058', '109998', '2022/11/18');
INSERT INTO contributions VALUES ('296658058', '189285', '2022/11/18');
INSERT INTO contributions VALUES ('334095530', '381849', '2023/04/25');
INSERT INTO contributions VALUES ('334095530', '29567189', '2023/04/25');
INSERT INTO contributions VALUES ('334095530', '350838', '2023/04/25');
INSERT INTO contributions VALUES ('545181844', '1986809294', '2023/04/25');
INSERT INTO contributions VALUES ('90348498', '1905980454', '2023/04/25');
INSERT INTO contributions VALUES ('90348498', '103153', '2023/04/25');
INSERT INTO contributions VALUES ('90348498', '1983534389', '2023/04/25');
INSERT INTO contributions VALUES ('20226098', '28935305', '2023/04/25');
INSERT INTO contributions VALUES ('90348498', '1492319444', '2023/04/25');
INSERT INTO contributions VALUES ('545181844', '139342', '2023/04/25');
INSERT INTO contributions VALUES ('90348498', '1915811362', '2023/04/25');
INSERT INTO contributions VALUES ('90348498', '362390', '2023/04/25');
INSERT INTO contributions VALUES ('90348498', '2040327122', '2023/04/25');
INSERT INTO contributions VALUES ('90348498', '26494703', '2023/04/25');
INSERT INTO contributions VALUES ('90348498', '34183450', '2023/04/25');
INSERT INTO contributions VALUES ('90348498', '1965909942', '2023/04/25');
INSERT INTO contributions VALUES ('20226098', '348101', '2021/08/05');
INSERT INTO contributions VALUES ('109213963', '381849', '2021/08/05');
INSERT INTO contributions VALUES ('109213963', '513375983', '2021/08/05');
INSERT INTO contributions VALUES ('109213963', '1451452397', '2021/08/05');
INSERT INTO contributions VALUES ('4030706955', '2117027', '2021/08/05');
INSERT INTO contributions VALUES ('374278278', '1342592226', '2021/08/05');
INSERT INTO contributions VALUES ('374278278', '511678808', '2021/08/05');
INSERT INTO contributions VALUES ('374278278', '1404709472', '2021/08/05');
INSERT INTO contributions VALUES ('83715386', '4283127', '2021/08/05');
INSERT INTO contributions VALUES ('93825695', '601630', '2021/08/05');
INSERT INTO contributions VALUES ('296658058', '139437', '2021/08/05');
INSERT INTO contributions VALUES ('296658058', '300146', '2021/08/05');
INSERT INTO contributions VALUES ('296658058', '394575', '2021/08/05');
INSERT INTO contributions VALUES ('100091090', '506094660', '2021/08/05');
INSERT INTO contributions VALUES ('100091090', '5241526', '2021/08/05');
INSERT INTO contributions VALUES ('63728035', '1334296072', '2021/08/05');
INSERT INTO contributions VALUES ('100091090', '30706318', '2021/08/05');
INSERT INTO contributions VALUES ('63728035', '1853253710', '2021/08/05');
INSERT INTO contributions VALUES ('20226098', '209268', '2021/08/05');
INSERT INTO contributions VALUES ('63728035', '18795421', '2021/08/05');
INSERT INTO contributions VALUES ('20226098', '297794', '2021/08/05');
INSERT INTO contributions VALUES ('20226098', '93471', '2021/08/05');
INSERT INTO contributions VALUES ('63728035', '18938933', '2021/08/05');
INSERT INTO contributions VALUES ('63728035', '1490185355', '2021/08/05');
INSERT INTO contributions VALUES ('63728035', '1325711261', '2021/08/05');
INSERT INTO contributions VALUES ('63728035', '1864604336', '2021/08/05');
INSERT INTO contributions VALUES ('334095530', '1468592465', '2023/07/06');
INSERT INTO contributions VALUES ('334095530', '2046562631', '2023/07/06');
INSERT INTO contributions VALUES ('334095530', '500665348', '2023/07/06');
INSERT INTO contributions VALUES ('296658058', '154480', '2023/07/06');
INSERT INTO contributions VALUES ('334095530', '67447', '2023/03/23');
INSERT INTO contributions VALUES ('334095530', '350820', '2023/03/23');
INSERT INTO contributions VALUES ('334095530', '29897928', '2023/03/23');
INSERT INTO contributions VALUES ('1647240833', '65766', '2023/03/23');
INSERT INTO contributions VALUES ('296658058', '28863012', '2023/03/23');
INSERT INTO contributions VALUES ('296658058', '87510', '2023/03/23');
INSERT INTO contributions VALUES ('4036417663', '1451856375', '2022/06/30');
INSERT INTO contributions VALUES ('4036417663', '483378334', '2022/06/30');
INSERT INTO contributions VALUES ('4036417663', '1946751557', '2022/06/30');
INSERT INTO contributions VALUES ('4036417663', '1391313820', '2022/06/30');
INSERT INTO contributions VALUES ('4036417663', '1922374770', '2022/06/30');
INSERT INTO contributions VALUES ('374278278', '1913476397', '2022/06/30');
INSERT INTO contributions VALUES ('374278278', '1953125353', '2022/06/30');
INSERT INTO contributions VALUES ('374278278', '1488796175', '2022/06/30');
INSERT INTO contributions VALUES ('368885808', '1804888816', '2022/06/30');
INSERT INTO contributions VALUES ('296658058', '21680447', '2022/06/30');
INSERT INTO contributions VALUES ('368885808', '528272281', '2022/06/30');
INSERT INTO contributions VALUES ('368885808', '1303273423', '2022/06/30');
INSERT INTO contributions VALUES ('20226098', '1456446166', '2022/06/30');
INSERT INTO contributions VALUES ('20226098', '5262805', '2022/06/30');
INSERT INTO contributions VALUES ('20226098', '103432', '2022/06/30');
INSERT INTO contributions VALUES ('296658058', '5232561', '2022/06/30');
INSERT INTO contributions VALUES ('296658058', '28068737', '2022/06/30');
INSERT INTO contributions VALUES ('52272721', '1409911804', '2022/12/31');
INSERT INTO contributions VALUES ('52272721', '1456446169', '2022/12/31');
INSERT INTO contributions VALUES ('52272721', '1456446168', '2022/12/31');
INSERT INTO contributions VALUES ('296658058', '185717', '2022/12/31');
INSERT INTO contributions VALUES ('296658058', '2006426337', '2022/12/31');
INSERT INTO contributions VALUES ('296658058', '1456669276', '2022/12/31');
INSERT INTO contributions VALUES ('1497085517', '25706285', '2022/12/31');
INSERT INTO contributions VALUES ('109213963', '29572506', '2021/08/21');
INSERT INTO contributions VALUES ('109213963', '33789165', '2021/08/21');
INSERT INTO contributions VALUES ('109213963', '1371939273', '2021/08/21');
INSERT INTO contributions VALUES ('1803720314', '1487205168', '2021/08/21');
INSERT INTO contributions VALUES ('1803720314', '497994', '2021/08/21');
INSERT INTO contributions VALUES ('1803720314', '577879', '2021/08/21');
INSERT INTO contributions VALUES ('4030706955', '139491', '2021/08/21');
INSERT INTO contributions VALUES ('4030706955', '293700', '2021/08/21');
INSERT INTO contributions VALUES ('4030706955', '293927', '2021/08/21');
INSERT INTO contributions VALUES ('483270183', '350760', '2021/08/21');
INSERT INTO contributions VALUES ('368885808', '1806683394', '2021/08/21');
INSERT INTO contributions VALUES ('540114760', '17858810', '2021/08/21');
INSERT INTO contributions VALUES ('20226098', '139385', '2021/08/21');
INSERT INTO contributions VALUES ('296658058', '324376', '2021/08/21');
INSERT INTO contributions VALUES ('20226098', '365743', '2021/08/21');
INSERT INTO contributions VALUES ('100091090', '26584329', '2021/08/21');
INSERT INTO contributions VALUES ('20226098', '4872842', '2021/08/21');
INSERT INTO contributions VALUES ('368885808', '365749', '2021/08/21');
INSERT INTO contributions VALUES ('296658058', '139375', '2021/08/21');
INSERT INTO contributions VALUES ('540114760', '1477670', '2021/08/21');
INSERT INTO contributions VALUES ('100091090', '4879327', '2021/08/21');
INSERT INTO contributions VALUES ('100091090', '1391335941', '2021/08/21');
INSERT INTO contributions VALUES ('296658058', '194740', '2021/08/21');
INSERT INTO contributions VALUES ('540114760', '39436490', '2021/08/21');
INSERT INTO contributions VALUES ('69961016', '409647016', '2022/03/08');
INSERT INTO contributions VALUES ('100091090', '1320101152', '2022/03/08');
INSERT INTO contributions VALUES ('100091090', '514774334', '2022/03/08');
INSERT INTO contributions VALUES ('355654248', '28923457', '2022/03/08');
INSERT INTO contributions VALUES ('100091090', '1860234945', '2022/03/08');
INSERT INTO contributions VALUES ('355654248', '1388674995', '2022/03/08');
INSERT INTO contributions VALUES ('355654248', '1375914761', '2022/03/08');
INSERT INTO contributions VALUES ('109213963', '1413863166', '2022/03/08');
INSERT INTO contributions VALUES ('109213963', '5242750', '2022/03/08');
INSERT INTO contributions VALUES ('296658058', '300222', '2022/03/08');
INSERT INTO contributions VALUES ('296658058', '1334270056', '2022/03/08');
INSERT INTO contributions VALUES ('296658058', '28254343', '2022/03/08');
INSERT INTO contributions VALUES ('109213963', '1476233570', '2022/03/08');
INSERT INTO contributions VALUES ('334095530', '1372510711', '2023/07/27');
INSERT INTO contributions VALUES ('334095530', '1809746622', '2023/07/27');
INSERT INTO contributions VALUES ('334095530', '475073278', '2023/07/27');
INSERT INTO contributions VALUES ('296658058', '112471', '2023/07/27');
INSERT INTO contributions VALUES ('474989529', '350854', '2023/07/27');
INSERT INTO contributions VALUES ('296658058', '287277', '2023/07/27');
INSERT INTO contributions VALUES ('474989529', '2067168896', '2023/07/27');
INSERT INTO contributions VALUES ('109213963', '5257070', '2022/01/26');
INSERT INTO contributions VALUES ('109213963', '399341494', '2022/01/26');
INSERT INTO contributions VALUES ('109213963', '1417454947', '2022/01/26');
INSERT INTO contributions VALUES ('1299733662', '66265', '2022/01/26');
INSERT INTO contributions VALUES ('1299733662', '573581361', '2022/01/26');
INSERT INTO contributions VALUES ('1299733662', '549320309', '2022/01/26');
INSERT INTO contributions VALUES ('100091090', '1412597751', '2022/01/26');
INSERT INTO contributions VALUES ('100091090', '65549', '2022/01/26');
INSERT INTO contributions VALUES ('100091090', '185712', '2022/01/26');
INSERT INTO contributions VALUES ('1969429200', '1830419924', '2022/01/26');
INSERT INTO contributions VALUES ('1969429200', '473045225', '2022/01/26');
INSERT INTO contributions VALUES ('1969429200', '28403111', '2022/01/26');
INSERT INTO contributions VALUES ('1803720314', '1371382065', '2022/04/07');
INSERT INTO contributions VALUES ('1803720314', '1307385071', '2022/04/07');
INSERT INTO contributions VALUES ('374278278', '28913379', '2022/04/07');
INSERT INTO contributions VALUES ('1803720314', '1913476397', '2022/04/07');
INSERT INTO contributions VALUES ('374278278', '554245291', '2022/04/07');
INSERT INTO contributions VALUES ('374278278', '1838498574', '2022/04/07');
INSERT INTO contributions VALUES ('374278278', '348074', '2022/04/07');
INSERT INTO contributions VALUES ('1299733662', '386700', '2022/04/07');
INSERT INTO contributions VALUES ('1299733662', '1446138503', '2022/04/07');
INSERT INTO contributions VALUES ('296658058', '27159995', '2022/04/07');
INSERT INTO contributions VALUES ('1299733662', '1430595488', '2022/04/07');
INSERT INTO contributions VALUES ('296658058', '185712', '2022/04/07');
INSERT INTO contributions VALUES ('296658058', '25642012', '2022/04/07');
INSERT INTO contributions VALUES ('4036417663', '25706279', '2022/04/21');
INSERT INTO contributions VALUES ('4036417663', '477428784', '2022/04/21');
INSERT INTO contributions VALUES ('4036417663', '386691', '2022/04/21');
INSERT INTO contributions VALUES ('296658058', '185715', '2022/04/21');
INSERT INTO contributions VALUES ('355654248', '1856318955', '2022/04/21');
INSERT INTO contributions VALUES ('296658058', '29418062', '2022/04/21');
INSERT INTO contributions VALUES ('355654248', '150667', '2022/04/21');
INSERT INTO contributions VALUES ('355654248', '1871868393', '2022/04/21');
INSERT INTO contributions VALUES ('296658058', '66164', '2022/04/21');
INSERT INTO contributions VALUES ('283864891', '1871868396', '2022/04/21');
INSERT INTO contributions VALUES ('283864891', '150660', '2022/04/21');
INSERT INTO contributions VALUES ('283864891', '1871868390', '2022/04/21');
INSERT INTO contributions VALUES ('135858701', '1970480716', '2023/03/13');
INSERT INTO contributions VALUES ('135858701', '2014291042', '2023/03/13');
INSERT INTO contributions VALUES ('135858701', '150532', '2023/03/13');
INSERT INTO contributions VALUES ('321118040', '1467971656', '2023/03/13');
INSERT INTO contributions VALUES ('321118040', '1496828999', '2023/03/13');
INSERT INTO contributions VALUES ('321118040', '2006426342', '2023/03/13');
INSERT INTO contributions VALUES ('280754621', '440411621', '2023/06/21');
INSERT INTO contributions VALUES ('358269079', '2004630510', '2023/06/21');
INSERT INTO contributions VALUES ('358269079', '22819662', '2023/06/21');
INSERT INTO contributions VALUES ('334095530', '449577636', '2023/06/21');
INSERT INTO contributions VALUES ('334095530', '2024869845', '2023/06/21');
INSERT INTO contributions VALUES ('334095530', '500665353', '2023/06/21');
INSERT INTO contributions VALUES ('296658058', '1895377443', '2023/06/21');
INSERT INTO contributions VALUES ('283864891', '438462600', '2021/12/25');
INSERT INTO contributions VALUES ('540114760', '139471', '2021/12/25');
INSERT INTO contributions VALUES ('540114760', '1453639477', '2021/12/25');
INSERT INTO contributions VALUES ('540114760', '287277', '2021/12/25');
INSERT INTO contributions VALUES ('1969429200', '139371', '2021/12/25');
INSERT INTO contributions VALUES ('100091090', '525081767', '2021/12/25');
INSERT INTO contributions VALUES ('1969429200', '28111225', '2021/12/25');
INSERT INTO contributions VALUES ('1969429200', '25011453', '2021/12/25');
INSERT INTO contributions VALUES ('372426144', '1448136306', '2021/12/25');
INSERT INTO contributions VALUES ('372426144', '460043705', '2021/12/25');
INSERT INTO contributions VALUES ('296658058', '561097027', '2021/12/25');
INSERT INTO contributions VALUES ('100091090', '1889635392', '2021/12/25');
INSERT INTO contributions VALUES ('100091090', '4899152', '2021/12/25');
INSERT INTO contributions VALUES ('372426144', '442562771', '2021/12/25');
INSERT INTO contributions VALUES ('296658058', '1892513656', '2021/12/25');
INSERT INTO contributions VALUES ('1497085517', '25714102', '2021/12/25');
INSERT INTO contributions VALUES ('296658058', '65355', '2021/12/25');
INSERT INTO contributions VALUES ('109213963', '114350', '2023/02/22');
INSERT INTO contributions VALUES ('109213963', '1942989843', '2023/02/22');
INSERT INTO contributions VALUES ('358269079', '2004988703', '2023/02/22');
INSERT INTO contributions VALUES ('358269079', '795881', '2023/02/22');
INSERT INTO contributions VALUES ('358269079', '60420', '2023/02/22');
INSERT INTO contributions VALUES ('325890444', '426852063', '2023/02/22');
INSERT INTO contributions VALUES ('325890444', '418603445', '2023/02/22');
INSERT INTO contributions VALUES ('325890444', '92305', '2023/02/22');
INSERT INTO contributions VALUES ('135858701', '27630173', '2023/02/22');
INSERT INTO contributions VALUES ('296658058', '4874221', '2023/02/22');
INSERT INTO contributions VALUES ('83715386', '1298510247', '2023/02/22');
INSERT INTO contributions VALUES ('296658058', '368780', '2023/02/22');
INSERT INTO contributions VALUES ('296658058', '299590', '2023/02/22');
INSERT INTO contributions VALUES ('283864891', '65592', '2023/02/22');
INSERT INTO contributions VALUES ('20226098', '485413811', '2023/05/06');
INSERT INTO contributions VALUES ('20226098', '1411784746', '2023/05/06');
INSERT INTO contributions VALUES ('110687265', '167595', '2023/05/06');
INSERT INTO contributions VALUES ('110687265', '1962385461', '2023/05/06');
INSERT INTO contributions VALUES ('110687265', '407759226', '2023/05/06');
INSERT INTO contributions VALUES ('109902362', '156956', '2023/05/06');
INSERT INTO contributions VALUES ('109902362', '355995', '2023/05/06');
INSERT INTO contributions VALUES ('109902362', '150651', '2023/05/06');
INSERT INTO contributions VALUES ('296658058', '40249668', '2023/05/06');
INSERT INTO contributions VALUES ('541001620', '554241264', '2023/05/06');
INSERT INTO contributions VALUES ('545181844', '1929355349', '2023/05/06');
INSERT INTO contributions VALUES ('545181844', '28053517', '2023/05/06');
INSERT INTO contributions VALUES ('541001620', '1836139178', '2023/05/06');
INSERT INTO contributions VALUES ('545181844', '459720412', '2023/05/06');
INSERT INTO contributions VALUES ('541001620', '2029903045', '2023/05/06');
INSERT INTO contributions VALUES ('334095530', '1385566412', '2023/05/06');
INSERT INTO contributions VALUES ('334095530', '506092013', '2023/05/06');
INSERT INTO contributions VALUES ('334095530', '1468592465', '2023/05/06');
INSERT INTO contributions VALUES ('4030706955', '28863012', '2022/07/19');
INSERT INTO contributions VALUES ('20226098', '292590', '2022/07/19');
INSERT INTO contributions VALUES ('4030706955', '26608738', '2022/07/19');
INSERT INTO contributions VALUES ('20226098', '353648', '2022/07/19');
INSERT INTO contributions VALUES ('20226098', '5261050', '2022/07/19');
INSERT INTO contributions VALUES ('4030706955', '27552548', '2022/07/19');
INSERT INTO contributions VALUES ('100091090', '316103', '2022/07/19');
INSERT INTO contributions VALUES ('100091090', '231412', '2022/07/19');
INSERT INTO contributions VALUES ('100091090', '299623', '2022/07/19');
INSERT INTO contributions VALUES ('3721880397', '718765', '2022/07/19');
INSERT INTO contributions VALUES ('296658058', '317151', '2022/07/19');
INSERT INTO contributions VALUES ('296658058', '210680', '2022/07/19');
INSERT INTO contributions VALUES ('296658058', '5280051', '2022/07/19');
