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

INSERT INTO contributors VALUES ('11997809', '不安小思er');
INSERT INTO contributors VALUES ('13905905', '你在放屁吗');
INSERT INTO contributors VALUES ('17944090', '依旧是vp影迷');
INSERT INTO contributors VALUES ('19511725', '月亦凝殇');
INSERT INTO contributors VALUES ('20226098', '大藏藏');
INSERT INTO contributors VALUES ('41625506', '默已释然');
INSERT INTO contributors VALUES ('52272721', '荒集卷子');
INSERT INTO contributors VALUES ('61382708', '伴着淅淅梭梭的雨声');
INSERT INTO contributors VALUES ('75306666', '歪Joey');
INSERT INTO contributors VALUES ('83715386', 'cidgur');
INSERT INTO contributors VALUES ('100091090', '任可爱-');
INSERT INTO contributors VALUES ('109213963', '会有猫的咸菜');
INSERT INTO contributors VALUES ('109902362', 'NightCar0312');
INSERT INTO contributors VALUES ('135858701', '橙月leo');
INSERT INTO contributors VALUES ('283864891', '噗嗤就知道吃');
INSERT INTO contributors VALUES ('296658058', '吼吼破喉咙');
INSERT INTO contributors VALUES ('321118040', 'EMILYwhatever');
INSERT INTO contributors VALUES ('342404009', '一本只有省略号的书');
INSERT INTO contributors VALUES ('358269079', '感觉jojo');
INSERT INTO contributors VALUES ('368885808', '雒哈哈');
INSERT INTO contributors VALUES ('374278278', '稳如cheems');
INSERT INTO contributors VALUES ('483270183', '憖憖a');
INSERT INTO contributors VALUES ('540114760', '黑黑黑矮星-');
INSERT INTO contributors VALUES ('541001620', '土豆大笨蛋');
INSERT INTO contributors VALUES ('1299733662', '透过星星的月亮');
INSERT INTO contributors VALUES ('1343967564', '-噼里啪啦丶');
INSERT INTO contributors VALUES ('1497085517', '忽然停止扇动');
INSERT INTO contributors VALUES ('1528570202', 'oldsoup-');
INSERT INTO contributors VALUES ('1803720314', '三絲餃子');
INSERT INTO contributors VALUES ('1969429200', '希澈yuri9doo');
INSERT INTO contributors VALUES ('4036417663', '很哇噻的一只熊');
INSERT INTO contributions VALUES ('368885808', '1396568808', '2021/09/02');
INSERT INTO contributions VALUES ('20226098', '139391', '2021/09/02');
INSERT INTO contributions VALUES ('1528570202', '1430773100', '2021/09/02');
INSERT INTO contributions VALUES ('1528570202', '1456446169', '2021/09/02');
INSERT INTO contributions VALUES ('1528570202', '1824149662', '2021/09/02');
INSERT INTO contributions VALUES ('283864891', '277686', '2021/09/02');
INSERT INTO contributions VALUES ('109213963', '485413811', '2021/09/02');
INSERT INTO contributions VALUES ('109213963', '569200212', '2021/09/02');
INSERT INTO contributions VALUES ('109213963', '1479706965', '2021/09/02');
INSERT INTO contributions VALUES ('20226098', '29771089', '2021/09/02');
INSERT INTO contributions VALUES ('283864891', '597359', '2021/09/02');
INSERT INTO contributions VALUES ('20226098', '22822507', '2021/09/02');
INSERT INTO contributions VALUES ('283864891', '357421', '2021/09/02');
INSERT INTO contributions VALUES ('374278278', '31066037', '2021/09/02');
INSERT INTO contributions VALUES ('100091090', '421870099', '2021/09/02');
INSERT INTO contributions VALUES ('374278278', '1396438012', '2021/09/02');
INSERT INTO contributions VALUES ('374278278', '1860234945', '2021/09/02');
INSERT INTO contributions VALUES ('100091090', '1303027499', '2021/09/02');
INSERT INTO contributions VALUES ('100091090', '1366216050', '2021/09/02');
INSERT INTO contributions VALUES ('342404009', '865048849', '2021/09/02');
INSERT INTO contributions VALUES ('342404009', '1329734169', '2021/09/02');
INSERT INTO contributions VALUES ('342404009', '350838', '2021/09/02');
INSERT INTO contributions VALUES ('296658058', '185712', '2021/09/02');
INSERT INTO contributions VALUES ('540114760', '1872403236', '2021/09/02');
INSERT INTO contributions VALUES ('540114760', '399341494', '2021/09/02');
INSERT INTO contributions VALUES ('296658058', '299519', '2021/09/02');
INSERT INTO contributions VALUES ('540114760', '441491828', '2021/09/02');
INSERT INTO contributions VALUES ('296658058', '526470351', '2021/09/02');
INSERT INTO contributions VALUES ('83715386', '552457903', '2022/03/12');
INSERT INTO contributions VALUES ('1969429200', '386835', '2022/03/12');
INSERT INTO contributions VALUES ('1969429200', '386829', '2022/03/12');
INSERT INTO contributions VALUES ('1969429200', '306855', '2022/03/12');
INSERT INTO contributions VALUES ('296658058', '357432', '2022/03/12');
INSERT INTO contributions VALUES ('296658058', '26632172', '2022/03/12');
INSERT INTO contributions VALUES ('296658058', '209760', '2022/03/12');
INSERT INTO contributions VALUES ('20226098', '386828', '2022/03/12');
INSERT INTO contributions VALUES ('20226098', '316034', '2022/03/12');
INSERT INTO contributions VALUES ('20226098', '483378330', '2022/03/12');
INSERT INTO contributions VALUES ('541001620', '1853733460', '2023/03/10');
INSERT INTO contributions VALUES ('541001620', '1853581161', '2023/03/10');
INSERT INTO contributions VALUES ('296658058', '5274955', '2023/01/09');
INSERT INTO contributions VALUES ('296658058', '357263', '2023/01/09');
INSERT INTO contributions VALUES ('100091090', '26467048', '2021/11/15');
INSERT INTO contributions VALUES ('100091090', '1391126134', '2021/11/15');
INSERT INTO contributions VALUES ('1497085517', '1342022280', '2021/11/15');
INSERT INTO contributions VALUES ('100091090', '1808249963', '2021/11/15');
INSERT INTO contributions VALUES ('61382708', '1319805087', '2021/11/15');
INSERT INTO contributions VALUES ('61382708', '4337980', '2021/11/15');
INSERT INTO contributions VALUES ('109213963', '395167', '2021/11/15');
INSERT INTO contributions VALUES ('296658058', '288838', '2021/11/15');
INSERT INTO contributions VALUES ('296658058', '333750', '2021/11/15');
INSERT INTO contributions VALUES ('20226098', '26418528', '2021/11/15');
INSERT INTO contributions VALUES ('20226098', '28285334', '2021/11/15');
INSERT INTO contributions VALUES ('20226098', '67274', '2021/11/15');
INSERT INTO contributions VALUES ('109213963', '5281398', '2021/11/15');
INSERT INTO contributions VALUES ('296658058', '395153', '2021/11/15');
INSERT INTO contributions VALUES ('109213963', '109827', '2021/11/15');
INSERT INTO contributions VALUES ('1969429200', '1411847995', '2021/11/15');
INSERT INTO contributions VALUES ('1969429200', '1411847364', '2021/11/15');
INSERT INTO contributions VALUES ('1969429200', '1411849063', '2021/11/15');
INSERT INTO contributions VALUES ('75306666', '1398567085', '2022/03/22');
INSERT INTO contributions VALUES ('75306666', '1872992411', '2022/03/22');
INSERT INTO contributions VALUES ('75306666', '21253869', '2022/03/22');
INSERT INTO contributions VALUES ('52272721', '17341073', '2022/03/22');
INSERT INTO contributions VALUES ('109213963', '1875376654', '2022/03/22');
INSERT INTO contributions VALUES ('109213963', '554245291', '2022/03/22');
INSERT INTO contributions VALUES ('52272721', '28860055', '2022/03/22');
INSERT INTO contributions VALUES ('20226098', '422427950', '2022/03/22');
INSERT INTO contributions VALUES ('20226098', '390467', '2022/03/22');
INSERT INTO contributions VALUES ('20226098', '27928217', '2022/03/22');
INSERT INTO contributions VALUES ('52272721', '1485899784', '2022/03/22');
INSERT INTO contributions VALUES ('296658058', '1496747474', '2022/03/22');
INSERT INTO contributions VALUES ('41625506', '1397160249', '2022/03/22');
INSERT INTO contributions VALUES ('109213963', '26837670', '2022/03/22');
INSERT INTO contributions VALUES ('296658058', '108248', '2022/03/22');
INSERT INTO contributions VALUES ('296658058', '287933', '2022/03/22');
INSERT INTO contributions VALUES ('321118040', '1483786045', '2023/02/11');
INSERT INTO contributions VALUES ('321118040', '1372584200', '2023/02/11');
INSERT INTO contributions VALUES ('321118040', '344157', '2023/02/11');
INSERT INTO contributions VALUES ('52272721', '1894277830', '2023/02/11');
INSERT INTO contributions VALUES ('52272721', '1849057398', '2023/02/11');
INSERT INTO contributions VALUES ('52272721', '1456445962', '2023/02/11');
INSERT INTO contributions VALUES ('135858701', '407435011', '2023/02/11');
INSERT INTO contributions VALUES ('135858701', '420401511', '2023/02/11');
INSERT INTO contributions VALUES ('135858701', '424496769', '2023/02/11');
INSERT INTO contributions VALUES ('135858701', '4237923', '2022/12/22');
INSERT INTO contributions VALUES ('135858701', '29715559', '2022/12/22');
INSERT INTO contributions VALUES ('135858701', '1405908431', '2022/12/22');
INSERT INTO contributions VALUES ('540114760', '1403921413', '2022/12/22');
INSERT INTO contributions VALUES ('540114760', '109444', '2022/12/22');
INSERT INTO contributions VALUES ('540114760', '327186', '2022/12/22');
INSERT INTO contributions VALUES ('296658058', '1854657935', '2022/12/22');
INSERT INTO contributions VALUES ('296658058', '1334270056', '2022/12/22');
INSERT INTO contributions VALUES ('11997809', '239340', '2021/12/07');
INSERT INTO contributions VALUES ('11997809', '326706', '2021/12/07');
INSERT INTO contributions VALUES ('1299733662', '167946', '2021/12/07');
INSERT INTO contributions VALUES ('1343967564', '1807796555', '2021/12/07');
INSERT INTO contributions VALUES ('1343967564', '1412264341', '2021/12/07');
INSERT INTO contributions VALUES ('1803720314', '1465257533', '2021/12/07');
INSERT INTO contributions VALUES ('1803720314', '1889784808', '2021/12/07');
INSERT INTO contributions VALUES ('1803720314', '326698', '2021/12/07');
INSERT INTO contributions VALUES ('296658058', '26235094', '2021/12/07');
INSERT INTO contributions VALUES ('296658058', '255497', '2021/12/07');
INSERT INTO contributions VALUES ('296658058', '299255', '2021/12/07');
INSERT INTO contributions VALUES ('1497085517', '202373', '2021/12/07');
INSERT INTO contributions VALUES ('1497085517', '1416922423', '2021/12/07');
INSERT INTO contributions VALUES ('20226098', '191237', '2021/12/07');
INSERT INTO contributions VALUES ('1969429200', '454828916', '2021/12/07');
INSERT INTO contributions VALUES ('1969429200', '5247627', '2021/12/07');
INSERT INTO contributions VALUES ('20226098', '167555', '2021/12/07');
INSERT INTO contributions VALUES ('1969429200', '5238991', '2021/12/07');
INSERT INTO contributions VALUES ('20226098', '108120', '2021/12/07');
INSERT INTO contributions VALUES ('19511725', '326705', '2021/09/07');
INSERT INTO contributions VALUES ('19511725', '441120217', '2021/09/07');
INSERT INTO contributions VALUES ('19511725', '188647', '2021/09/07');
INSERT INTO contributions VALUES ('374278278', '1415813272', '2021/09/07');
INSERT INTO contributions VALUES ('374278278', '186105', '2021/09/07');
INSERT INTO contributions VALUES ('374278278', '4017234', '2021/09/07');
INSERT INTO contributions VALUES ('4036417663', '516358164', '2021/09/07');
INSERT INTO contributions VALUES ('4036417663', '1487205165', '2021/09/07');
INSERT INTO contributions VALUES ('13905905', '1325905146', '2021/09/07');
INSERT INTO contributions VALUES ('20226098', '1441290403', '2021/09/07');
INSERT INTO contributions VALUES ('100091090', '1397680225', '2021/09/07');
INSERT INTO contributions VALUES ('20226098', '33399024', '2021/09/07');
INSERT INTO contributions VALUES ('13905905', '569213220', '2021/09/07');
INSERT INTO contributions VALUES ('20226098', '365708', '2021/09/07');
INSERT INTO contributions VALUES ('296658058', '471403427', '2021/09/07');
INSERT INTO contributions VALUES ('100091090', '447925725', '2021/09/07');
INSERT INTO contributions VALUES ('296658058', '409872641', '2021/09/07');
INSERT INTO contributions VALUES ('296658058', '187417', '2021/09/07');
INSERT INTO contributions VALUES ('100091090', '1332725422', '2021/09/07');
INSERT INTO contributions VALUES ('109213963', '394670', '2021/12/28');
INSERT INTO contributions VALUES ('109213963', '187672', '2021/12/28');
INSERT INTO contributions VALUES ('109213963', '1813312517', '2021/12/28');
INSERT INTO contributions VALUES ('540114760', '174082', '2021/12/28');
INSERT INTO contributions VALUES ('540114760', '1424916458', '2021/12/28');
INSERT INTO contributions VALUES ('540114760', '1814784389', '2021/12/28');
INSERT INTO contributions VALUES ('540114760', '1815692964', '2021/12/28');
INSERT INTO contributions VALUES ('540114760', '365586', '2021/12/28');
INSERT INTO contributions VALUES ('1497085517', '1407424616', '2021/12/28');
INSERT INTO contributions VALUES ('1497085517', '286959', '2021/12/28');
INSERT INTO contributions VALUES ('1299733662', '1436910205', '2021/12/28');
INSERT INTO contributions VALUES ('1299733662', '386844', '2021/12/28');
INSERT INTO contributions VALUES ('1299733662', '353414', '2021/12/28');
INSERT INTO contributions VALUES ('52272721', '91441', '2021/12/28');
INSERT INTO contributions VALUES ('52272721', '28152163', '2021/12/28');
INSERT INTO contributions VALUES ('52272721', '16139381', '2021/12/28');
INSERT INTO contributions VALUES ('1497085517', '28768107', '2021/12/28');
INSERT INTO contributions VALUES ('52272721', '1328315092', '2021/12/28');
INSERT INTO contributions VALUES ('1497085517', '1456446168', '2021/12/28');
INSERT INTO contributions VALUES ('75306666', '1473721141', '2021/12/28');
INSERT INTO contributions VALUES ('75306666', '1351384773', '2021/12/28');
INSERT INTO contributions VALUES ('109902362', '31877523', '2021/12/28');
INSERT INTO contributions VALUES ('4036417663', '1366001376', '2021/12/28');
INSERT INTO contributions VALUES ('109902362', '1814036459', '2021/12/28');
INSERT INTO contributions VALUES ('4036417663', '18602345', '2021/12/28');
INSERT INTO contributions VALUES ('4036417663', '481876542', '2021/12/28');
INSERT INTO contributions VALUES ('4036417663', '574925509', '2021/12/28');
INSERT INTO contributions VALUES ('109902362', '1456446169', '2021/12/28');
INSERT INTO contributions VALUES ('1497085517', '1393632139', '2021/12/28');
INSERT INTO contributions VALUES ('1497085517', '1808250358', '2021/12/28');
INSERT INTO contributions VALUES ('1497085517', '479382670', '2021/12/28');
INSERT INTO contributions VALUES ('1497085517', '25718007', '2021/12/28');
INSERT INTO contributions VALUES ('75306666', '26425118', '2021/12/28');
INSERT INTO contributions VALUES ('100091090', '156736', '2021/12/28');
INSERT INTO contributions VALUES ('100091090', '85756', '2021/12/28');
INSERT INTO contributions VALUES ('100091090', '193473', '2021/12/28');
INSERT INTO contributions VALUES ('1497085517', '1488763761', '2021/12/28');
INSERT INTO contributions VALUES ('1497085517', '41659256', '2021/12/28');
INSERT INTO contributions VALUES ('75306666', '356486', '2021/12/28');
INSERT INTO contributions VALUES ('1497085517', '1405908431', '2021/12/28');
INSERT INTO contributions VALUES ('1969429200', '4877797', '2021/12/28');
INSERT INTO contributions VALUES ('20226098', '110400', '2021/12/28');
INSERT INTO contributions VALUES ('540114760', '135020', '2021/12/28');
INSERT INTO contributions VALUES ('540114760', '25706279', '2021/12/28');
INSERT INTO contributions VALUES ('1969429200', '453927792', '2021/12/28');
INSERT INTO contributions VALUES ('540114760', '1470057289', '2021/12/28');
INSERT INTO contributions VALUES ('1969429200', '223644', '2021/12/28');
INSERT INTO contributions VALUES ('20226098', '230095', '2021/12/28');
INSERT INTO contributions VALUES ('20226098', '463262368', '2021/12/28');
INSERT INTO contributions VALUES ('374278278', '1922374770', '2022/11/17');
INSERT INTO contributions VALUES ('374278278', '348110', '2022/11/17');
INSERT INTO contributions VALUES ('358269079', '4022094', '2022/11/17');
INSERT INTO contributions VALUES ('358269079', '29764382', '2022/11/17');
INSERT INTO contributions VALUES ('358269079', '524148328', '2022/11/17');
INSERT INTO contributions VALUES ('321118040', '1490098724', '2022/11/17');
INSERT INTO contributions VALUES ('1299733662', '19207074', '2022/11/17');
INSERT INTO contributions VALUES ('1299733662', '1805639523', '2022/11/17');
INSERT INTO contributions VALUES ('52272721', '453927774', '2022/11/17');
INSERT INTO contributions VALUES ('52272721', '326708', '2022/11/17');
INSERT INTO contributions VALUES ('52272721', '453927759', '2022/11/17');
INSERT INTO contributions VALUES ('109213963', '29418974', '2022/11/17');
INSERT INTO contributions VALUES ('321118040', '1945894789', '2022/11/17');
INSERT INTO contributions VALUES ('109213963', '31273716', '2022/11/17');
INSERT INTO contributions VALUES ('20226098', '28381285', '2022/11/17');
INSERT INTO contributions VALUES ('109213963', '34324641', '2022/11/17');
INSERT INTO contributions VALUES ('20226098', '207005', '2022/11/17');
INSERT INTO contributions VALUES ('20226098', '326722', '2022/11/17');
INSERT INTO contributions VALUES ('296658058', '230568', '2022/11/17');
INSERT INTO contributions VALUES ('296658058', '230567', '2022/11/17');
INSERT INTO contributions VALUES ('296658058', '230566', '2022/11/17');
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
