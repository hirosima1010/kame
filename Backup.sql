--
-- PostgreSQL database dump
--

\restrict Mukz9bVrhg01O5cjyGrxvh43fsfDaH7lWDFXhcVArQ57MtC3geYFu1Mbe9mkWjc

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-07-13 10:39:23

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16443)
-- Name: menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menu (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    price integer NOT NULL
);


ALTER TABLE public.menu OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16442)
-- Name: menu_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.menu_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menu_id_seq OWNER TO postgres;

--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 219
-- Name: menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.menu_id_seq OWNED BY public.menu.id;


--
-- TOC entry 224 (class 1259 OID 16502)
-- Name: menus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menus (
    id integer NOT NULL,
    menu_name character varying(100) NOT NULL,
    kana_name character varying(150),
    price integer NOT NULL,
    category character varying(50) NOT NULL,
    description text,
    image_path character varying(255) DEFAULT 'no_image.png'::character varying,
    is_available boolean DEFAULT true,
    is_recommend boolean DEFAULT false,
    is_limited boolean DEFAULT false,
    allergy_info character varying(255) DEFAULT 'なし'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT menus_category_check CHECK (((category)::text = ANY ((ARRAY['カメドリンク'::character varying, 'カメフード'::character varying, 'スイーツ'::character varying, 'コーヒー豆・茶葉'::character varying, 'グッズ・道具'::character varying])::text[])))
);


ALTER TABLE public.menus OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16501)
-- Name: menus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.menus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menus_id_seq OWNER TO postgres;

--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 223
-- Name: menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.menus_id_seq OWNED BY public.menus.id;


--
-- TOC entry 230 (class 1259 OID 16569)
-- Name: order_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_details (
    detail_id integer NOT NULL,
    order_id integer NOT NULL,
    menu_name character varying(100) NOT NULL,
    price integer NOT NULL,
    quantity integer NOT NULL
);


ALTER TABLE public.order_details OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16568)
-- Name: order_details_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_details_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_details_detail_id_seq OWNER TO postgres;

--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 229
-- Name: order_details_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_details_detail_id_seq OWNED BY public.order_details.detail_id;


--
-- TOC entry 228 (class 1259 OID 16556)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    staff_name character varying(100) NOT NULL,
    eat_style character varying(20) NOT NULL,
    my_kame_shell boolean NOT NULL,
    total_price integer NOT NULL,
    receipt_name character varying(100),
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    age_group character varying(20) DEFAULT 'unknown'::character varying
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16555)
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_order_id_seq OWNER TO postgres;

--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 227
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- TOC entry 226 (class 1259 OID 16537)
-- Name: shifts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shifts (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    work_date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    break_minutes integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.shifts OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16536)
-- Name: shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shifts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shifts_id_seq OWNER TO postgres;

--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 225
-- Name: shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shifts_id_seq OWNED BY public.shifts.id;


--
-- TOC entry 222 (class 1259 OID 16480)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(20) DEFAULT 'staff'::character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    full_name character varying(100) NOT NULL,
    kana_name character varying(100),
    gender character varying(10),
    birth_date date,
    phone character varying(20),
    email character varying(100),
    postal_code character varying(10),
    address character varying(255),
    hourly_wage integer DEFAULT 0,
    transportation_fee integer DEFAULT 0,
    bank_name character varying(100),
    bank_branch character varying(100),
    account_number character varying(20),
    hire_date date DEFAULT CURRENT_DATE
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16479)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 221
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 4881 (class 2604 OID 16446)
-- Name: menu id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu ALTER COLUMN id SET DEFAULT nextval('public.menu_id_seq'::regclass);


--
-- TOC entry 4888 (class 2604 OID 16505)
-- Name: menus id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menus ALTER COLUMN id SET DEFAULT nextval('public.menus_id_seq'::regclass);


--
-- TOC entry 4902 (class 2604 OID 16572)
-- Name: order_details detail_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_details ALTER COLUMN detail_id SET DEFAULT nextval('public.order_details_detail_id_seq'::regclass);


--
-- TOC entry 4899 (class 2604 OID 16559)
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- TOC entry 4896 (class 2604 OID 16540)
-- Name: shifts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts ALTER COLUMN id SET DEFAULT nextval('public.shifts_id_seq'::regclass);


--
-- TOC entry 4882 (class 2604 OID 16483)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 5068 (class 0 OID 16443)
-- Dependencies: 220
-- Data for Name: menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menu (id, name, price) FROM stdin;
1	スペシャルブレンド	450
\.


--
-- TOC entry 5072 (class 0 OID 16502)
-- Dependencies: 224
-- Data for Name: menus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menus (id, menu_name, kana_name, price, category, description, image_path, is_available, is_recommend, is_limited, allergy_info, created_at, updated_at) FROM stdin;
3	ウミガメ ダーク モカ チップ フラペチーノ (Grande)	うみがめ だーく もか チップ ふらぺちーの	635	カメドリンク	チョコチップ入りのフローズンドリンク	no_image.png	t	t	f	乳,小麦	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
4	カメの甲羅 チョコレートクランチスコーン	かめのこうら ちょこれーとくらんちすこーん	300	スイーツ	ザクザク食感のスコーン	no_image.png	t	t	f	乳,小麦	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
5	タートル ニューヨークチーズケーキ	たーとる にゅーよーくちーずけーき	485	スイーツ	クリーミーで濃厚なチーズケーキ	no_image.png	t	t	f	卵,乳,小麦	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
6	カメねるねるねるね（メロン味）	かめねるねるねるね メロンあじ	90	スイーツ	カメも大好きねるねるねるね	no_image.png	t	t	f	なし	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
7	カメうまい棒（コーンポタージュ味）	かめうまいぼう こーんぽたーじゅあじ	30	スイーツ	定番のコーンポタージュ味	no_image.png	t	t	f	乳,小麦	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
8	ソイ カメ ラテ (Grande)	そい かめ らて	550	カメドリンク	豆乳を使った優しいラテ	no_image.png	t	f	f	大豆	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
9	カメバックス 特製ラテ (Grande)	かめばっくす とくせいらて	495	カメドリンク	エスプレッソとミルクの絶妙なコク	no_image.png	t	f	f	乳	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
10	亀の甲羅 キャラメル マキアート (Grande)	かめのこうら きゃらめる まきあーと	590	カメドリンク	キャラメルシロップの甘み	no_image.png	t	f	f	乳	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
11	のんびり抽出 コールドブリュー コーヒー (Grande)	のんびりちゅうしゅつ こーるどぶりゅー こーひー	480	カメドリンク	時間をかけて抽出した水出しコーヒー	no_image.png	t	f	f	なし	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
12	万年長寿 キャラメル フラペチーノ (Grande)	まんねんちょうじゅ きゃらめる フラペチーノ	620	カメドリンク	贅沢なキャラメルフラペチーノ	no_image.png	t	f	f	乳	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
13	すっぽん アップル ジュース	すっぽん あっぷる じゅーす	400	カメドリンク	元気が出る果汁100%ジュース	no_image.png	t	f	f	りんご	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
14	亀の甲羅の湧き水 ミネラルウォーター	かめのこうらのわきみず みねらるうぉーたー	250	カメドリンク	すっきり澄んだ湧き水	no_image.png	t	f	f	なし	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
15	カメの甲羅風 メロンパンサンドイッチ	かめのこうらふう めろんぱんさんどいっち	680	カメフード	甘じょっぱさが癖になるサンド	no_image.png	t	f	f	卵,乳,小麦	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
16	スモークサーモン タートルベーグル	すもーくさーもん たーとるべーぐる	720	カメフード	スモークサーモンを挟んだ特製ベーグル	no_image.png	t	f	f	小麦,さけ	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
17	ホカホカ 焼きカメパニーニ	ほかほか やきかめぱにーに	580	カメフード	温かいとろけるチーズのパニーニ	no_image.png	t	f	f	乳,小麦	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
18	カメの渦巻き シナモンロール	かめのうずまき しなもんろーる	380	スイーツ	シナモンの香りが広がるロールケーキ風パン	no_image.png	t	f	f	卵,乳,小麦	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
19	甲羅型 シュガードーナツ	こうらがた しゅがーどーなつ	300	スイーツ	定番のシンプルなドーナツ	no_image.png	t	f	f	卵,乳,小麦	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
20	贅沢 カメプリン・アラモード	ぜいたく かめぷりん あらもーど	650	スイーツ	フルーツたっぷりのプリンアラモード	no_image.png	t	f	f	卵,乳	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
21	カメバックス厳選 コーヒー豆	かめばっくすげんせん こーひーまめ	1480	コーヒー豆・茶葉	お家で楽しめる特選ブレンド豆	no_image.png	t	f	f	なし	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
22	特製カメデカフェコーヒー豆	とくせいかめでかふぇこーひーまめ	1550	コーヒー豆・茶葉	カフェインレスの体に優しいコーヒー豆	no_image.png	t	f	f	なし	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
23	シングルオリジン（ガラパゴス諸島産）	しんぐるおりじん がらぱごすしょとうさん	1800	コーヒー豆・茶葉	希少なガラパゴス諸島産のコーヒー豆	no_image.png	t	f	t	なし	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
24	カメさんイラスト タンブラー	かめさんいらすと たんぶらー	1500	グッズ・道具	カメのイラストが可愛いマイボトル	no_image.png	t	f	f	なし	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
25	カメバックス オリジナルロゴマグカップ	かめばっくす おりじなりるろごまぐかっぷ	1200	グッズ・道具	お店と同じデザインのマグカップ	no_image.png	t	f	f	なし	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
26	のんびり挽く コーヒーミル（手挽き）	のんびりひく こーひーみる てびき	2800	グッズ・道具	時間を忘れて豆を挽くアンティーク調ミル	no_image.png	t	f	f	なし	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
2	よりどりみどり 抹茶 クリーム フラペチーノ (Grande)	よりどりみどり まっちゃ くりーむ ふらぺちーの	630	カメドリンク	AHAHAHAHAH	no_image.png	f	t	f	乳	2026-07-03 00:57:22.797241	2026-07-03 00:57:22.797241
\.


--
-- TOC entry 5078 (class 0 OID 16569)
-- Dependencies: 230
-- Data for Name: order_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_details (detail_id, order_id, menu_name, price, quantity) FROM stdin;
1	3	ウミガメ ダーク モカ チップ フラペチーノ (Grande)	635	4
2	3	カメの甲羅風 メロンパンサンドイッチ	680	3
3	4	ウミガメ ダーク モカ チップ フラペチーノ (Grande)	635	6
\.


--
-- TOC entry 5076 (class 0 OID 16556)
-- Dependencies: 228
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, staff_name, eat_style, my_kame_shell, total_price, receipt_name, order_date, age_group) FROM stdin;
1	亀井 晃弘	sea	f	0		2026-07-09 12:21:12.950009	unknown
2	亀井 晃弘	sea	f	0		2026-07-09 12:21:26.514652	unknown
3	亀井 晃弘	sea	f	4580		2026-07-09 12:21:45.210609	unknown
4	亀井 晃弘	sea	f	3810		2026-07-13 09:57:23.948624	unknown
\.


--
-- TOC entry 5074 (class 0 OID 16537)
-- Dependencies: 226
-- Data for Name: shifts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shifts (id, username, work_date, start_time, end_time, break_minutes, created_at) FROM stdin;
9	2	2026-07-21	18:00:00	22:00:00	0	2026-07-03 21:16:14.888517
10	admin	2026-07-21	18:00:00	00:00:00	0	2026-07-03 22:03:27.552393
11	1	2021-01-01	00:00:00	22:00:00	0	2026-07-03 22:04:43.3895
12	1	2020-07-12	14:00:00	22:00:00	0	2026-07-04 17:48:10.12685
3	1	2026-07-21	18:00:00	22:00:00	0	2026-07-03 20:35:04.920778
\.


--
-- TOC entry 5070 (class 0 OID 16480)
-- Dependencies: 222
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, password, role, is_active, full_name, kana_name, gender, birth_date, phone, email, postal_code, address, hourly_wage, transportation_fee, bank_name, bank_branch, account_number, hire_date) FROM stdin;
2	1	1111	staff	t	亀井 晃弘	カメイ ミツヒロ	男	2006-10-10	00000000000	kame@gmail.com	000-0000	広島県広島市南区一丁目100-100-999	10000	100000	亀井銀行	亀井支店	0000000	2026-07-01
6	3	password	staff	t	大谷 翔平	オオタニ ショウヘイ	男	1999-10-14					0	0				2026-07-01
3	2	1111	staff	t	田中 夢	タナカ ユメ	女	2002-11-13	070-0000-0001	yume@gmail.com	000-0000	広島県広島市南区一丁目100-100-999	100	0	亀井銀行	亀井支店	00	2026-07-01
7	99	admin	admin	t	ドナルド・トランプ	ドナルド・トランプ	男	1500-10-10	999-9999-9999	toto@gmail.com	000-0000	広島県広島市南区一丁目100-100-999	0	0	亀井銀行	亀井支店	0000000	2026-07-07
5	admin	1111	admin	f	ドナルド・トランプ	ドナルド・トランプ	男	1500-10-10	999-9999-9999	toto@gmail.com	000-0000	広島県広島市南区一丁目100-100-999	5000	0	亀井銀行	亀井支店	0000000	2026-07-01
\.


--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 219
-- Name: menu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.menu_id_seq', 1, true);


--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 223
-- Name: menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.menus_id_seq', 81, true);


--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 229
-- Name: order_details_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_details_detail_id_seq', 3, true);


--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 227
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 4, true);


--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 225
-- Name: shifts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shifts_id_seq', 12, true);


--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 221
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 7, true);


--
-- TOC entry 4905 (class 2606 OID 16451)
-- Name: menu menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (id);


--
-- TOC entry 4911 (class 2606 OID 16520)
-- Name: menus menus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_pkey PRIMARY KEY (id);


--
-- TOC entry 4917 (class 2606 OID 16579)
-- Name: order_details order_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_details
    ADD CONSTRAINT order_details_pkey PRIMARY KEY (detail_id);


--
-- TOC entry 4915 (class 2606 OID 16567)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 4913 (class 2606 OID 16549)
-- Name: shifts shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (id);


--
-- TOC entry 4907 (class 2606 OID 16498)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4909 (class 2606 OID 16500)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4919 (class 2606 OID 16580)
-- Name: order_details order_details_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_details
    ADD CONSTRAINT order_details_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


--
-- TOC entry 4918 (class 2606 OID 16550)
-- Name: shifts shifts_username_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_username_fkey FOREIGN KEY (username) REFERENCES public.users(username) ON DELETE CASCADE;


-- Completed on 2026-07-13 10:39:23

--
-- PostgreSQL database dump complete
--

\unrestrict Mukz9bVrhg01O5cjyGrxvh43fsfDaH7lWDFXhcVArQ57MtC3geYFu1Mbe9mkWjc

