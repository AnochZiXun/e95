CREATE TABLE"AccessLog"(
	"id"serial8 PRIMARY KEY,
	"remoteHost"varchar,
	"userName"varchar,
	"timestamp"timestamptz NOT NULL DEFAULT"now"(),
	"virtualHost"varchar,
	"method"varchar,
	"query"varchar,
	"status"int2,
	"bytes"int8 NOT NULL DEFAULT'0',
	"referer"varchar,
	"userAgent"varchar
);
-- DELETE FROM"AccessLog"WHERE"timestamp"<CURRENT_DATE;

CREATE SEQUENCE"Bulletin_id_seq"MAXVALUE 32767 CYCLE;
CREATE TABLE"Bulletin"(
	"id"int2 DEFAULT"nextval"('"Bulletin_id_seq"'::"regclass")PRIMARY KEY,
	"subject"varchar NOT NULL,
	"html"text NOT NULL,
	"when"date NOT NULL DEFAULT"now"()
);
ALTER SEQUENCE"Bulletin_id_seq"OWNED BY"Bulletin"."id";
COMMENT ON COLUMN"Bulletin"."id"IS'主鍵^16';
COMMENT ON COLUMN"Bulletin"."subject"IS'主旨';
COMMENT ON COLUMN"Bulletin"."html"IS'HTML內容';
COMMENT ON COLUMN"Bulletin"."when"IS'發佈日期';
COMMENT ON TABLE"Bulletin"IS'最新消息';

CREATE SEQUENCE"FrequentlyAskedQuestion_id_seq"MAXVALUE 32767 CYCLE;
CREATE TABLE"FrequentlyAskedQuestion"(
	"id"int2 DEFAULT"nextval"('"FrequentlyAskedQuestion_id_seq"'::"regclass")PRIMARY KEY,
	"question"varchar NOT NULL,
	"answer"text NOT NULL
);
ALTER SEQUENCE"FrequentlyAskedQuestion_id_seq"OWNED BY"FrequentlyAskedQuestion"."id";
COMMENT ON COLUMN"FrequentlyAskedQuestion"."id"IS'主鍵^16';
COMMENT ON COLUMN"FrequentlyAskedQuestion"."question"IS'問題';
COMMENT ON COLUMN"FrequentlyAskedQuestion"."answer"IS'答案';
COMMENT ON TABLE"FrequentlyAskedQuestion"IS'常見問答';

CREATE SEQUENCE"Banner_id_seq"MAXVALUE 32767 CYCLE;
CREATE TABLE"Banner"(
	"id"int2 DEFAULT"nextval"('"Banner_id_seq"'::"regclass")PRIMARY KEY,
	"content"bytea NOT NULL,
	"href"text,
	"external"bool NOT NULL DEFAULT'0',
	"ordinal"int2 NOT NULL UNIQUE
);
ALTER SEQUENCE"Banner_id_seq"OWNED BY"Banner"."id";
COMMENT ON COLUMN"Banner"."id"IS'主鍵^16';
COMMENT ON COLUMN"Banner"."content"IS'內容';
COMMENT ON COLUMN"Banner"."href"IS'連結';
COMMENT ON COLUMN"Banner"."external"IS'外部連結';
COMMENT ON COLUMN"Banner"."ordinal"IS'排序';
COMMENT ON TABLE"Banner"IS'連播橫幅';

CREATE SEQUENCE"Mofo_id_seq"MAXVALUE 32767 CYCLE;
CREATE TABLE"Mofo"(
	"id"int2 DEFAULT"nextval"('"Mofo_id_seq"'::"regclass")PRIMARY KEY,
	"name"varchar NOT NULL UNIQUE
);
ALTER SEQUENCE"Mofo_id_seq"OWNED BY"Mofo"."id";
COMMENT ON COLUMN"Mofo"."id"IS'主鍵^16';
COMMENT ON COLUMN"Mofo"."name"IS'攤商分類名稱';
COMMENT ON TABLE"Mofo"IS'攤商分類';
-- 
INSERT INTO"Mofo"("name")VALUES(E'食'),(E'衣'),(E'住'),(E'行'),(E'育'),(E'樂');

CREATE SEQUENCE"Accordion_id_seq"MAXVALUE 32767 CYCLE;
CREATE TABLE"Accordion"(
	"id"int2 DEFAULT"nextval"('"Accordion_id_seq"'::"regclass")PRIMARY KEY,
	"parent"int2 REFERENCES"Accordion"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	"fragment"varchar UNIQUE,
	"internal"bool NOT NULL,
	"name"varchar NOT NULL,
	"ordinal"int2 NOT NULL,
	UNIQUE("parent","name"),
	UNIQUE("parent","ordinal")
);
ALTER SEQUENCE"Accordion_id_seq"OWNED BY"Accordion"."id";
COMMENT ON COLUMN"Accordion"."id"IS'主鍵^16';
COMMENT ON COLUMN"Accordion"."parent"IS'header';
COMMENT ON COLUMN"Accordion"."fragment"IS'網址片段';
COMMENT ON COLUMN"Accordion"."internal"IS'內部使用';
COMMENT ON COLUMN"Accordion"."name"IS'header or container name';
COMMENT ON COLUMN"Accordion"."ordinal"IS'排序';
COMMENT ON TABLE"Accordion"IS'手風琴';
-- 
INSERT INTO"Accordion"("parent","fragment","internal","name","ordinal")VALUES
(NULL,NULL,FALSE,E'訂單相關','1'),
(NULL,NULL,FALSE,E'商品相關','2'),
(NULL,NULL,TRUE,E'其它','3'),
('1',E'preparing/',FALSE,E'備貨中','1'),
('1',E'delivering/',FALSE,E'出貨中','2'),
('1',E'closed/',FALSE,E'已結單','3'),
('2',E'shelf/',FALSE,E'商品分類','1'),
('3',E'regular/',TRUE,E'會員','1'),
('3',E'booth/',TRUE,E'店家','2'),
('3',E'banner/',TRUE,E'連播橫幅','3'),
('3',E'bulletin/',TRUE,E'最新消息','4'),
('3',E'staff/',TRUE,E'工作人員','5'),
-- 2016-03-29
(NULL,NULL,FALSE,E'其它','4'),
('13',E'faq/',TRUE,E'常見問答','6');

CREATE SEQUENCE"Staff_id_seq"MAXVALUE 2147483647 CYCLE;
CREATE TABLE"Staff"(
	"id"int4 DEFAULT"nextval"('"Staff_id_seq"'::"regclass")PRIMARY KEY,
	"internal"bool NOT NULL DEFAULT'0',
	"login"varchar NOT NULL UNIQUE,
	"shadow"text NOT NULL,
	"name"varchar NOT NULL,
	"logo"bytea,
	"html"text,
	"address"text,
	"cellular"text,
	"phone"text,
	"representative"varchar,
	"merchantID"varchar,
	"hashKey"varchar,
	"hashIV"varchar,
	"mofo"int2 REFERENCES"Mofo"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	"revoked"bool NOT NULL DEFAULT'0'
);
ALTER SEQUENCE"Staff_id_seq"OWNED BY"Staff"."id";
COMMENT ON COLUMN"Staff"."id"IS'主鍵^32';
COMMENT ON COLUMN"Staff"."internal"IS'內部工作人員';
COMMENT ON COLUMN"Staff"."login"IS'帳號(電子郵件)';
COMMENT ON COLUMN"Staff"."shadow"IS'密碼';
COMMENT ON COLUMN"Staff"."name"IS'工作人員暱稱|攤商抬頭';
COMMENT ON COLUMN"Staff"."logo"IS'攤商圖像';
COMMENT ON COLUMN"Staff"."html"IS'攤商簡介';
COMMENT ON COLUMN"Staff"."address"IS'攤商實體地址';
COMMENT ON COLUMN"Staff"."cellular"IS'攤商手機號碼';
COMMENT ON COLUMN"Staff"."phone"IS'攤商市內電話';
COMMENT ON COLUMN"Staff"."representative"IS'攤商聯絡代表';
COMMENT ON COLUMN"Staff"."merchantID"IS'攤商歐付寶特店編號';
COMMENT ON COLUMN"Staff"."hashKey"IS'攤商歐付寶AIO介接的HashKey';
COMMENT ON COLUMN"Staff"."hashIV"IS'攤商歐付寶AIO介接的HashIV';
COMMENT ON COLUMN"Staff"."mofo"IS'攤商分類';
COMMENT ON COLUMN"Staff"."revoked"IS'停權';
COMMENT ON TABLE"Staff"IS'工作人員|攤商';
-- 
CREATE VIEW"passwd"AS SELECT"login"AS"name","shadow"AS"credentials",'cPanel'::"varchar"AS"role"FROM"Staff";
-- 
INSERT INTO"Staff"("id","internal","login","shadow","name")VALUES('-1',TRUE,E'x@y.z',E'9bbd635272f0dd18c7cd9aef254bf6fc',E'管理者');
/*
INSERT INTO"Staff"("login","shadow","name")VALUES
(E'apple',E'116f370e4c3134219fcb871dde3133a7',E'蘋果'),
(E'asus',E'116f370e4c3134219fcb871dde3133a7',E'華碩'),
(E'htc',E'116f370e4c3134219fcb871dde3133a7',E'宏達國際電子'),
(E'huawei',E'116f370e4c3134219fcb871dde3133a7',E'華為'),
(E'infocus',E'116f370e4c3134219fcb871dde3133a7',E'富可視'),
(E'lg',E'116f370e4c3134219fcb871dde3133a7',E'樂金'),
(E'oppo',E'116f370e4c3134219fcb871dde3133a7',E'歐珀'),
(E'samsung',E'116f370e4c3134219fcb871dde3133a7',E'三星'),
(E'sonyericsson',E'116f370e4c3134219fcb871dde3133a7',E'索尼易利信'),
(E'xiaomi',E'116f370e4c3134219fcb871dde3133a7',E'小米');
*/

CREATE SEQUENCE"Forgot_id_seq"MAXVALUE 9223372036854775807 CYCLE;
CREATE TABLE"Forgot"(
	"id"int8 DEFAULT"nextval"('"Forgot_id_seq"'::"regclass")PRIMARY KEY,
	"booth"int4 NOT NULL REFERENCES"Staff"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	"code"varchar NOT NULL UNIQUE,
	"when"timestamp NOT NULL
);
ALTER SEQUENCE"Forgot_id_seq"OWNED BY"Forgot"."id";
COMMENT ON COLUMN"Forgot"."id"IS'主鍵^64';
COMMENT ON COLUMN"Forgot"."booth"IS'攤商';
COMMENT ON COLUMN"Forgot"."code"IS'辨識碼';
COMMENT ON COLUMN"Forgot"."when"IS'何時';
COMMENT ON TABLE"Forgot"IS'忘記密碼';

CREATE SEQUENCE"Shelf_id_seq"MAXVALUE 9223372036854775807 CYCLE;
CREATE TABLE"Shelf"(
	"id"int8 DEFAULT"nextval"('"Shelf_id_seq"'::"regclass")PRIMARY KEY,
	"booth"int4 NOT NULL REFERENCES"Staff"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	"name"varchar NOT NULL,
	UNIQUE("booth","name")
);
ALTER SEQUENCE"Shelf_id_seq"OWNED BY"Shelf"."id";
COMMENT ON COLUMN"Shelf"."id"IS'主鍵^64';
COMMENT ON COLUMN"Shelf"."booth"IS'攤商';
COMMENT ON COLUMN"Shelf"."name"IS'商品分類名稱';
COMMENT ON TABLE"Shelf"IS'商品分類';

CREATE SEQUENCE"Regular_id_seq"MAXVALUE 2147483647 CYCLE;
CREATE TABLE"Regular"(
	"id"int4 DEFAULT"nextval"('"Regular_id_seq"'::"regclass")PRIMARY KEY,
	"lastname"varchar NOT NULL,
	"firstname"varchar NOT NULL,
	"email"varchar NOT NULL UNIQUE,
	"shadow"text NOT NULL,
	"birth"date NOT NULL,
	"gender"bool NOT NULL,
	"phone"text,
	"address"text
);
ALTER SEQUENCE"Regular_id_seq"OWNED BY"Regular"."id";
COMMENT ON COLUMN"Regular"."id"IS'主鍵^32';
COMMENT ON COLUMN"Regular"."lastname"IS'姓氏';
COMMENT ON COLUMN"Regular"."firstname"IS'名字';
COMMENT ON COLUMN"Regular"."email"IS'電子郵件';
COMMENT ON COLUMN"Regular"."shadow"IS'密碼';
COMMENT ON COLUMN"Regular"."birth"IS'生日';
COMMENT ON COLUMN"Regular"."gender"IS'性別';
COMMENT ON COLUMN"Regular"."phone"IS'聯絡電話';
COMMENT ON COLUMN"Regular"."address"IS'預設地址';
COMMENT ON TABLE"Regular"IS'會員';
-- 
/*
INSERT INTO"Regular"("lastname","firstname","email","shadow","birth","gender")VALUES
(E'高',E'新興',E'gao_xin_xing_uuxmvim_gao_xin_xing@tfbnw.net',E'a2984216e12e198e324b30c98c7447eeda873ea403740f0cdb8b1fd51440bb9a3e6d3147a50c7a71d6e09f65c6772c08b0e26e15d700f0b1d344a659d1882954','1998-02-07','t'),
(E'高',E'前金',E'gao_qian_jin_lagrmpu_gao_qian_jin@tfbnw.net',E'a2984216e12e198e324b30c98c7447eeda873ea403740f0cdb8b1fd51440bb9a3e6d3147a50c7a71d6e09f65c6772c08b0e26e15d700f0b1d344a659d1882954','1998-02-06','t'),
(E'高',E'苓雅',E'gao_ling_ya_umepklp_gao_ling_ya@tfbnw.net',E'a2984216e12e198e324b30c98c7447eeda873ea403740f0cdb8b1fd51440bb9a3e6d3147a50c7a71d6e09f65c6772c08b0e26e15d700f0b1d344a659d1882954','1998-02-05','f'),
(E'高',E'鹽埕',E'gao_yan_cheng_aqoxllj_gao_yan_cheng@tfbnw.net',E'a2984216e12e198e324b30c98c7447eeda873ea403740f0cdb8b1fd51440bb9a3e6d3147a50c7a71d6e09f65c6772c08b0e26e15d700f0b1d344a659d1882954','1998-02-04','t'),
(E'高',E'股山',E'gao_gu_shan_nncywsg_gao_gu_shan@tfbnw.net',E'a2984216e12e198e324b30c98c7447eeda873ea403740f0cdb8b1fd51440bb9a3e6d3147a50c7a71d6e09f65c6772c08b0e26e15d700f0b1d344a659d1882954','1998-02-03','t'),
(E'高',E'烈嶼',E'jin_lie_yu_kryunhv_jin_lie_yu@tfbnw.net',E'a2984216e12e198e324b30c98c7447eeda873ea403740f0cdb8b1fd51440bb9a3e6d3147a50c7a71d6e09f65c6772c08b0e26e15d700f0b1d344a659d1882954','1998-02-02','t'),
(E'高',E'烏坵',E'jin_wu_qiu_tbcxduw_jin_wu_qiu@tfbnw.net',E'a2984216e12e198e324b30c98c7447eeda873ea403740f0cdb8b1fd51440bb9a3e6d3147a50c7a71d6e09f65c6772c08b0e26e15d700f0b1d344a659d1882954','1998-02-01','t'),
(E'高',E'旗津',E'gao_qi_jin_axhnbdx_gao_qi_jin@tfbnw.net',E'a2984216e12e198e324b30c98c7447eeda873ea403740f0cdb8b1fd51440bb9a3e6d3147a50c7a71d6e09f65c6772c08b0e26e15d700f0b1d344a659d1882954','1998-01-31','f'),
(E'高',E'前鎮',E'gao_qian_zhen_ihdjgzf_gao_qian_zhen@tfbnw.net',E'a2984216e12e198e324b30c98c7447eeda873ea403740f0cdb8b1fd51440bb9a3e6d3147a50c7a71d6e09f65c6772c08b0e26e15d700f0b1d344a659d1882954','1998-01-30','t'),
(E'高',E'三民',E'gao_san_min_fxrmafh_gao_san_min@tfbnw.net',E'a2984216e12e198e324b30c98c7447eeda873ea403740f0cdb8b1fd51440bb9a3e6d3147a50c7a71d6e09f65c6772c08b0e26e15d700f0b1d344a659d1882954','1998-01-29','t');
*/

CREATE SEQUENCE"Merchandise_id_seq"MAXVALUE 9223372036854775807 CYCLE;
CREATE TABLE"Merchandise"(
	"id"int8 DEFAULT"nextval"('"Merchandise_id_seq"'::"regclass")PRIMARY KEY,
	"shelf"int8 NOT NULL REFERENCES"Shelf"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	"name"varchar NOT NULL,
	"price"int4 NOT NULL,
	"html"text NOT NULL,
	"carrying"bool NOT NULL DEFAULT'1',
	"inStock"bool NOT NULL DEFAULT'1',
	"recommended"bool NOT NULL DEFAULT'0'
);
ALTER SEQUENCE"Merchandise_id_seq"OWNED BY"Merchandise"."id";
COMMENT ON COLUMN"Merchandise"."id"IS'主鍵^64';
COMMENT ON COLUMN"Merchandise"."shelf"IS'商品分類';
COMMENT ON COLUMN"Merchandise"."name"IS'商品名稱';
COMMENT ON COLUMN"Merchandise"."price"IS'單價';
COMMENT ON COLUMN"Merchandise"."html"IS'HTML內容(描述)';
COMMENT ON COLUMN"Merchandise"."carrying"IS'上架|下架';
COMMENT ON COLUMN"Merchandise"."inStock"IS'有貨';
COMMENT ON COLUMN"Merchandise"."recommended"IS'推薦';
COMMENT ON TABLE"Merchandise"IS'商品';

CREATE SEQUENCE"PacketStatus_id_seq"MAXVALUE 3 CYCLE;
CREATE TABLE"PacketStatus"(
	"id"int2 DEFAULT"nextval"('"PacketStatus_id_seq"'::"regclass")PRIMARY KEY,
	"name"varchar NOT NULL UNIQUE
);
ALTER SEQUENCE"PacketStatus_id_seq"OWNED BY"PacketStatus"."id";
COMMENT ON COLUMN"PacketStatus"."id"IS'主鍵';
COMMENT ON COLUMN"PacketStatus"."name"IS'訂單狀態名稱';
COMMENT ON TABLE"PacketStatus"IS'訂單狀態';
-- 
INSERT INTO"PacketStatus"("name")VALUES(E'備貨中'),(E'出貨中'),(E'已結單');

CREATE SEQUENCE"Packet_id_seq"MAXVALUE 9223372036854775807 CYCLE;
CREATE TABLE"Packet"(
	"id"int8 DEFAULT"nextval"('"Packet_id_seq"'::"regclass")PRIMARY KEY,
	"booth"int4 NOT NULL REFERENCES"Staff"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	"regular"int4 NOT NULL REFERENCES"Regular"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	"packetStatus"int2 REFERENCES"PacketStatus"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	"merchantTradeNo"varchar NOT NULL UNIQUE,
	"merchantTradeDate"timestamp NOT NULL,
	"totalAmount"int4 NOT NULL,
	"checkMacValue"varchar,
	"recipient"text,
	"phone"text,
	"address"text,
);
ALTER SEQUENCE"Packet_id_seq"OWNED BY"Packet"."id";
COMMENT ON COLUMN"Packet"."id"IS'主鍵^64';
COMMENT ON COLUMN"Packet"."booth"IS'攤商';
COMMENT ON COLUMN"Packet"."regular"IS'會員';
COMMENT ON COLUMN"Packet"."packetStatus"IS'備貨中|出貨中|已結單';
COMMENT ON COLUMN"Packet"."merchantTradeNo"IS'交易編號';
COMMENT ON COLUMN"Packet"."merchantTradeDate"IS'交易時間';
COMMENT ON COLUMN"Packet"."totalAmount"IS'交易金額';
COMMENT ON COLUMN"Packet"."checkMacValue"IS'歐付寶AIO的檢查碼';
COMMENT ON COLUMN"Packet"."recipient"IS'收件者';
COMMENT ON COLUMN"Packet"."phone"IS'聯絡電話';
COMMENT ON COLUMN"Packet"."address"IS'運送地址';
COMMENT ON TABLE"Packet"IS'訂單';

CREATE SEQUENCE"InternalFrame_id_seq"MAXVALUE 9223372036854775807 CYCLE;
CREATE TABLE"InternalFrame"(
	"id"int8 DEFAULT"nextval"('"InternalFrame_id_seq"'::"regclass")PRIMARY KEY,
	"bulletin"int2 REFERENCES"Bulletin"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	"booth"int4 REFERENCES"Staff"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	"merchandise"int8 REFERENCES"Merchandise"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	"src"text NOT NULL,
	"width"int2,
	"height"int2,
	"ordinal"int2 NOT NULL,
	CHECK(("merchandise"IS NOT NULL AND"booth"IS NULL AND"bulletin"IS NULL)OR("merchandise"IS NULL AND"booth"IS NOT NULL AND"bulletin"IS NULL)OR("merchandise"IS NULL AND"booth"IS NULL AND"bulletin"IS NOT NULL)),
	UNIQUE("bulletin","ordinal"),
	UNIQUE("booth","ordinal"),
	UNIQUE("merchandise","ordinal")
);
ALTER SEQUENCE"InternalFrame_id_seq"OWNED BY"InternalFrame"."id";
COMMENT ON COLUMN"InternalFrame"."id"IS'主鍵^64';
COMMENT ON COLUMN"InternalFrame"."bulletin"IS'最新消息';
COMMENT ON COLUMN"InternalFrame"."booth"IS'攤商';
COMMENT ON COLUMN"InternalFrame"."merchandise"IS'商品';
COMMENT ON COLUMN"InternalFrame"."src"IS'address of the resource';
COMMENT ON COLUMN"InternalFrame"."width"IS'horizontal dimension';
COMMENT ON COLUMN"InternalFrame"."height"IS'vertical dimension';
COMMENT ON COLUMN"InternalFrame"."ordinal"IS'排序';
COMMENT ON TABLE"InternalFrame"IS'nested browsing context';

CREATE SEQUENCE"Cart_id_seq"MAXVALUE 9223372036854775807 CYCLE;
CREATE TABLE"Cart"(
	"id"int8 DEFAULT"nextval"('"Cart_id_seq"'::"regclass")PRIMARY KEY,
	"merchandise"int8 REFERENCES"Merchandise"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	"specification"varchar,
	"quantity"int2 NOT NULL,
	"packet"int8 REFERENCES"Packet"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	UNIQUE("merchandise","specification","packet")
);
ALTER SEQUENCE"Cart_id_seq"OWNED BY"Cart"."id";
COMMENT ON COLUMN"Cart"."id"IS'主鍵^64';
COMMENT ON COLUMN"Cart"."merchandise"IS'商品';
COMMENT ON COLUMN"Cart"."specification"IS'規格';
COMMENT ON COLUMN"Cart"."quantity"IS'數量';
COMMENT ON COLUMN"Cart"."packet"IS'訂單';
COMMENT ON TABLE"Cart"IS'明細';

CREATE SEQUENCE"AllPayHistory_id_seq"MAXVALUE 9223372036854775807 CYCLE;
CREATE TABLE"AllPayHistory"(
	"id"int8 DEFAULT"nextval"('"AllPayHistory_id_seq"'::"regclass")PRIMARY KEY,
	"packet"int8 NOT NULL REFERENCES"Packet"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	"tradeDesc"varchar,
	"rtnCode"int2,
	"rtnMsg"text,
	"tradeNo"varchar,
	"tradeAmt"int4,
	"paymentDate"timestamp,
	"paymentType"varchar,
	"paymentTypeChargeFee"int4,
	"tradeDate"timestamp,
	"simulatePaid"bool,
	"checkMacValue"varchar
);
ALTER SEQUENCE"AllPayHistory_id_seq"OWNED BY"AllPayHistory"."id";
COMMENT ON COLUMN"AllPayHistory"."id"IS'主鍵^64';
COMMENT ON COLUMN"AllPayHistory"."packet"IS'訂單';
COMMENT ON COLUMN"AllPayHistory"."tradeDesc"IS'交易描述(攤商抬頭)';
COMMENT ON COLUMN"AllPayHistory"."rtnCode"IS'交易狀態(付款結果通知)';
COMMENT ON COLUMN"AllPayHistory"."rtnMsg"IS'交易訊息(付款結果通知)';
COMMENT ON COLUMN"AllPayHistory"."tradeNo"IS'交易編號(付款結果通知)';
COMMENT ON COLUMN"AllPayHistory"."tradeAmt"IS'交易金額(付款結果通知)';
COMMENT ON COLUMN"AllPayHistory"."paymentDate"IS'付款時間(付款結果通知)';
COMMENT ON COLUMN"AllPayHistory"."paymentType"IS'會員選擇的付款方式(付款結果通知)';
COMMENT ON COLUMN"AllPayHistory"."paymentTypeChargeFee"IS'通路費(付款結果通知)';
COMMENT ON COLUMN"AllPayHistory"."tradeDate"IS'訂單成立時間(付款結果通知)';
COMMENT ON COLUMN"AllPayHistory"."simulatePaid"IS'是否為模擬付款(付款結果通知)';
COMMENT ON COLUMN"AllPayHistory"."checkMacValue"IS'檢查碼(付款結果通知)';
COMMENT ON TABLE"AllPayHistory"IS'歐付寶支付歷程';

CREATE SEQUENCE"MerchandiseImage_id_seq"MAXVALUE 9223372036854775807 CYCLE;
CREATE TABLE"MerchandiseImage"(
	"id"int8 DEFAULT"nextval"('"MerchandiseImage_id_seq"'::"regclass")PRIMARY KEY,
	"merchandise"int8 NOT NULL REFERENCES"Merchandise"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	"content"bytea NOT NULL,
	"ordinal"int2 NOT NULL,
	UNIQUE("merchandise","ordinal")
);
ALTER SEQUENCE"MerchandiseImage_id_seq"OWNED BY"MerchandiseImage"."id";
COMMENT ON COLUMN"MerchandiseImage"."id"IS'主鍵^64';
COMMENT ON COLUMN"MerchandiseImage"."merchandise"IS'商品';
COMMENT ON COLUMN"MerchandiseImage"."content"IS'內容';
COMMENT ON COLUMN"MerchandiseImage"."ordinal"IS'排序';
COMMENT ON TABLE"MerchandiseImage"IS'商品圖片';

CREATE SEQUENCE"MerchandiseSpecification_id_seq"MAXVALUE 9223372036854775807 CYCLE;
CREATE TABLE"MerchandiseSpecification"(
	"id"int8 DEFAULT"nextval"('"MerchandiseSpecification_id_seq"'::"regclass")PRIMARY KEY,
	"merchandise"int8 NOT NULL REFERENCES"Merchandise"("id")ON DELETE RESTRICT ON UPDATE CASCADE,
	"name"varchar NOT NULL,
	UNIQUE("merchandise","name")
);
ALTER SEQUENCE"MerchandiseSpecification_id_seq"OWNED BY"MerchandiseSpecification"."id";
COMMENT ON COLUMN"MerchandiseSpecification"."id"IS'主鍵^64';
COMMENT ON COLUMN"MerchandiseSpecification"."merchandise"IS'商品';
COMMENT ON COLUMN"MerchandiseSpecification"."name"IS'商品規格名稱';
COMMENT ON TABLE"MerchandiseSpecification"IS'商品規格';
