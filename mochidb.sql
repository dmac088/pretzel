--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE mochi_app;
ALTER ROLE mochi_app WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:0tT3tCPkwIPL+NjWyxs/nQ==$vf/BMINULdjnVMIgeCKgqTxRkYA6wRZU9B8w+1z9zeQ=:m0PEjB+DlZ0DSZAHKC1PJ0Hv6E4O+P1CGkZrZgjHENY=' VALID UNTIL 'infinity';
CREATE ROLE mochidb_owner;
ALTER ROLE mochidb_owner WITH SUPERUSER INHERIT NOCREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:68H8Gs2ZsAwQMpptRDWUpA==$ICInLcCOTEPK4CqF9wRBSBgLyeKSCpceF7Lg6ZQK/qU=:fA0Qm2nXhxzGfF8hVhcSnMNkjsz9eavb40BVNqgQdqA=' VALID UNTIL 'infinity';
--CREATE ROLE postgres;
--ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:/x+NptPPTLPo9/Y8a8/kNQ==$TzrjrnDqBodd3qiDtNgoa5tFmLX/3sbUcuutSAq7044=:Ag7DBuF4PdXIFZTgRAIGrJw9q0Vau6jp7s9AHkS23Mg=';
CREATE ROLE security_app;
ALTER ROLE security_app WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:poMqI/pZ42J1JnhG1LTX1w==$CK9X9bfat9Ttwr3Qi0mOHpmvOJOmbfxzbRXSRiThyPw=:hRSu+Os7EV9U+/ZYEoKD4drZqvNjYC54xq54Q+muIK0=' VALID UNTIL 'infinity';
CREATE ROLE security_owner;
ALTER ROLE security_owner WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:IMR+GcZhI036KIumpl0iNA==$wFTjV3H8YrcAsB/lCTkp8xzD3kSYCyOraMeeKcf7Ui8=:uPs/6Jun0oTThL7dEg/JcGBHr9KZ2TdsgDgSDrzbcds=' VALID UNTIL 'infinity';






--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4 (Ubuntu 14.4-1.pgdg20.04+1)
-- Dumped by pg_dump version 14.4 (Ubuntu 14.4-1.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- Database "mochidb" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4 (Ubuntu 14.4-1.pgdg20.04+1)
-- Dumped by pg_dump version 14.4 (Ubuntu 14.4-1.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: mochidb; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE mochidb ENCODING = 'UTF8' LOCALE = 'en_HK.utf8' TEMPLATE = template0;


ALTER DATABASE mochidb OWNER TO postgres;

\connect mochidb

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: mochi; Type: SCHEMA; Schema: -; Owner: mochidb_owner
--

CREATE SCHEMA mochi;


ALTER SCHEMA mochi OWNER TO mochidb_owner;

--
-- Name: security; Type: SCHEMA; Schema: -; Owner: security_owner
--

CREATE SCHEMA security;


ALTER SCHEMA security OWNER TO security_owner;

--
-- Name: ft_brand_categories(text, text); Type: FUNCTION; Schema: mochi; Owner: mochidb_owner
--

CREATE FUNCTION mochi.ft_brand_categories(text, text) RETURNS TABLE(cat_id bigint, cat_cd text, cat_lvl bigint, hir_id bigint, cat_prnt_id bigint, cat_typ_id bigint, product_count bigint, child_cat_count bigint, max_price numeric)
    LANGUAGE sql
    AS $_$































 SELECT p.cat_id,































    p.cat_cd,































    p.cat_lvl,































    p.hir_id,































    p.cat_typ_id,































    p.cat_prnt_id,































    count(DISTINCT prd.upc_cd) AS product_count,































    count(DISTINCT cc.cat_cd) AS child_cat_count,































    coalesce(































    max(CASE































	WHEN pt.prc_typ_cd = 'MKD01'































	THEN prc.prc_val































	END),































    max(CASE































	WHEN pt.prc_typ_cd = 'RET01'































	THEN prc.prc_val































	END)) as max_price































   FROM mochi.category p































     JOIN LATERAL mochi.ft_categories(p.cat_cd::text) cc(cat_id, cat_cd, cat_prnt_id, cat_typ_id) ON 1 = 1































     LEFT JOIN mochi.brand_category pc ON cc.cat_id = pc.cat_id































     LEFT JOIN mochi.brand bnd ON pc.bnd_id = bnd.bnd_id































     LEFT JOIN mochi.product prd ON pc.bnd_id = prd.bnd_id































     LEFT JOIN mochi.price prc ON prd.prd_id = prc.prd_id AND now() between prc.prc_st_dt and prc.prc_en_dt































     LEFT JOIN mochi.currency curr ON prc.ccy_id = curr.ccy_id 































     LEFT JOIN mochi.price_type pt ON prc.prc_typ_id = pt.prc_typ_id 































  WHERE cc.cat_typ_id = 2































  AND p.cat_cd = $1































  AND ccy_cd = $2































  GROUP BY p.cat_id, p.cat_cd, p.cat_lvl, p.hir_id, p.cat_typ_id, p.cat_prnt_id;































$_$;


ALTER FUNCTION mochi.ft_brand_categories(text, text) OWNER TO mochidb_owner;

--
-- Name: ft_categories(text); Type: FUNCTION; Schema: mochi; Owner: mochidb_owner
--

CREATE FUNCTION mochi.ft_categories(text) RETURNS TABLE(cat_id bigint, cat_cd text, cat_prnt_id bigint, cat_typ_id bigint)
    LANGUAGE sql
    AS $_$























WITH RECURSIVE 























    -- starting node(s)























    starting (cat_id, cat_cd, cat_prnt_id, cat_typ_id) AS























    (























      SELECT t.cat_id, t.cat_cd, t.cat_prnt_id, t.cat_typ_id























      FROM mochi.category AS t























      WHERE t.cat_cd = $1        























    ),























    descendants (cat_id, cat_cd, cat_prnt_id, cat_typ_id) AS























    (























      SELECT t.cat_id, t.cat_cd, t.cat_prnt_id, t.cat_typ_id























      FROM mochi.category AS t























      WHERE t.cat_cd = $1























      UNION ALL























      SELECT t.cat_id, t.cat_cd, t.cat_prnt_id, t.cat_typ_id























      FROM mochi.category AS t 























		JOIN descendants AS d 























		ON t.cat_prnt_id = d.cat_id























    )















































SELECT 	descendants.cat_id,























		descendants.cat_cd,























		descendants.cat_prnt_id,























		descendants.cat_typ_id























FROM  starting 























		cross join descendants $_$;


ALTER FUNCTION mochi.ft_categories(text) OWNER TO mochidb_owner;

--
-- Name: ft_product_categories(text, text); Type: FUNCTION; Schema: mochi; Owner: mochidb_owner
--

CREATE FUNCTION mochi.ft_product_categories(text, text) RETURNS TABLE(cat_id bigint, cat_cd text, cat_lvl bigint, hir_id bigint, cat_prnt_id bigint, cat_typ_id bigint, product_count bigint, child_cat_count bigint, max_price numeric)
    LANGUAGE sql
    AS $_$































 SELECT p.cat_id,































    p.cat_cd,































    p.cat_lvl,































    p.hir_id,































    p.cat_typ_id,































    p.cat_prnt_id,































    count(DISTINCT prd.upc_cd) AS product_count,































    count(DISTINCT cc.cat_cd) AS child_cat_count,































    coalesce(































    max(CASE































	WHEN pt.prc_typ_cd = 'MKD01'































	THEN prc.prc_val































	END),































    max(CASE































	WHEN pt.prc_typ_cd = 'RET01'































	THEN prc.prc_val































	END)) as max_price































   FROM mochi.category p































     JOIN LATERAL mochi.ft_categories(p.cat_cd::text) cc(cat_id, cat_cd, cat_prnt_id, cat_typ_id) ON 1 = 1































     LEFT JOIN mochi.product_category pc ON cc.cat_id = pc.cat_id































     LEFT JOIN mochi.product prd ON pc.prd_id = prd.prd_id































     LEFT JOIN mochi.price prc ON prd.prd_id = prc.prd_id AND now() between prc.prc_st_dt and prc.prc_en_dt































     LEFT JOIN mochi.currency curr ON prc.ccy_id = curr.ccy_id 































     LEFT JOIN mochi.price_type pt ON prc.prc_typ_id = pt.prc_typ_id 































  WHERE cc.cat_typ_id = 1































  AND p.cat_cd = $1































  AND ccy_cd = $2































  GROUP BY p.cat_id, p.cat_cd, p.cat_lvl, p.hir_id, p.cat_typ_id, p.cat_prnt_id;































$_$;


ALTER FUNCTION mochi.ft_product_categories(text, text) OWNER TO mochidb_owner;

--
-- Name: load_postage_destination(); Type: FUNCTION; Schema: mochi; Owner: mochidb_owner
--

CREATE FUNCTION mochi.load_postage_destination() RETURNS integer
    LANGUAGE plpgsql
    AS $$

declare 

record_count integer = 0;

begin

	ALTER TABLE mochi.postage_destination_attr_lcl

    DROP CONSTRAINT IF EXISTS postage_destination_attr_lcl_pst_dst_id_fkey;



	ALTER TABLE mochi.product_shipping

    DROP CONSTRAINT IF EXISTS  product_shipping_postage_destination_pst_dst_id_fkey;



	TRUNCATE TABLE mochi.postage_destination_attr_lcl;



	TRUNCATE TABLE mochi.postage_destination;



	INSERT INTO mochi.postage_destination(pst_dst_id, pst_dst_cd, pst_zne_cd)

	SELECT pst_dst_id, destinationcode, zonecode

	FROM mochi.vw_postage_destination;

	

	INSERT INTO mochi.postage_destination_attr_lcl(pst_dst_lcl_id, pst_dst_id, pst_dst_desc, lcl_cd)

	SELECT pst_dst_lcl_id, pst_dst_id, pst_dst_desc, lcl_cd

	FROM mochi.vw_postage_destination_attr_lcl;



	ALTER TABLE mochi.product_shipping

    ADD CONSTRAINT product_shipping_postage_destination_pst_dst_id_fkey FOREIGN KEY (pst_dst_id)

    REFERENCES mochi.postage_destination (pst_dst_id) MATCH SIMPLE

    ON UPDATE RESTRICT

    ON DELETE RESTRICT;

	

	ALTER TABLE mochi.postage_destination_attr_lcl

    ADD CONSTRAINT postage_destination_attr_lcl_pst_dst_id_fkey FOREIGN KEY (pst_dst_id)

    REFERENCES mochi.postage_destination (pst_dst_id) MATCH SIMPLE

    ON UPDATE NO ACTION

    ON DELETE NO ACTION;



	RETURN 1;

end;

$$;


ALTER FUNCTION mochi.load_postage_destination() OWNER TO mochidb_owner;

--
-- Name: load_postage_type(); Type: FUNCTION; Schema: mochi; Owner: mochidb_owner
--

CREATE FUNCTION mochi.load_postage_type() RETURNS integer
    LANGUAGE plpgsql
    AS $$

declare 

record_count integer = 0;

begin

	ALTER TABLE mochi.postage_type_attr_lcl

    DROP CONSTRAINT IF EXISTS postage_type_attr_lcl_pst_typ_id_fkey;



	ALTER TABLE mochi.product_shipping

    DROP CONSTRAINT IF EXISTS  product_shipping_postage_type_pst_typ_id_fkey;



	TRUNCATE TABLE mochi.postage_type_attr_lcl;



	TRUNCATE TABLE mochi.postage_type;



	INSERT INTO mochi.postage_type(pst_typ_id, pst_typ_cd)

	SELECT pst_typ_id, pst_typ_cd

	FROM mochi.vw_postage_type;

	

	INSERT INTO mochi.postage_type_attr_lcl(pst_typ_lcl_id, pst_typ_id, pst_typ_desc, lcl_cd)

	SELECT pst_typ_lcl_id, pst_typ_id, pst_typ_desc, lcl_cd

	FROM mochi.vw_postage_type_attr_lcl;



	ALTER TABLE mochi.product_shipping

    ADD CONSTRAINT product_shipping_postage_type_pst_typ_id_fkey FOREIGN KEY (pst_typ_id)

    REFERENCES mochi.postage_type (pst_typ_id) MATCH SIMPLE

    ON UPDATE RESTRICT

    ON DELETE RESTRICT;

	

	ALTER TABLE mochi.postage_type_attr_lcl

    ADD CONSTRAINT postage_type_attr_lcl_pst_typ_id_fkey FOREIGN KEY (pst_typ_id)

    REFERENCES mochi.postage_type (pst_typ_id) MATCH SIMPLE

    ON UPDATE NO ACTION

    ON DELETE NO ACTION;



	RETURN 1;

end;

$$;


ALTER FUNCTION mochi.load_postage_type() OWNER TO mochidb_owner;

--
-- Name: load_shipping_products(); Type: FUNCTION; Schema: mochi; Owner: mochidb_owner
--

CREATE FUNCTION mochi.load_shipping_products() RETURNS integer
    LANGUAGE plpgsql
    AS $$

declare 

record_count integer = 0;

begin



INSERT INTO mochi.product(prd_id, upc_cd, prd_crtd_dt, bnd_id, dept_id, prd_sts_id)

SELECT 	

		nextval('mochi."hibernate_sequence"'),

		_product_upc_code, 

		to_date(_product_created_date, 'YYYY-MM-DD HH:MM:SS') as _product_created_date,

		42 as bnd_id,

		1 dept_id,

		1 prd_sts_id

FROM yahoo.vw_export_shipping_master m;



insert into mochi.product_attr_lcl(prd_lcl_id, prd_id, prd_desc, prd_img_pth, lcl_cd, prd_lng_desc)

select nextval('mochi."hibernate_sequence"'),

		p.prd_id,

		trim(m._product_description_en),

		null,

		'en-GB',

		trim(m._product_description_en)

from mochi.product p

	left join yahoo.vw_export_shipping_master m

		on p.upc_cd = m._product_upc_code

where p.dept_id = 1;







insert into mochi.product_attr_lcl(prd_lcl_id, prd_id, prd_desc, prd_img_pth, lcl_cd, prd_lng_desc)

select nextval('mochi."hibernate_sequence"'),

		p.prd_id,

		trim(m._product_description_hk),

		null,

		'zh-HK',

		trim(m._product_description_hk)

from mochi.product p

	left join yahoo.vw_export_shipping_master m

		on p.upc_cd = m._product_upc_code

where p.dept_id = 1;



insert into mochi.product_shipping (prd_id, shp_dst_id, shp_typ_id, shp_wgt_lim, shp_wgt_frm, shp_wgt_to, shp_trk_lvl)

select prd_id,

	   sd.shp_dst_id,

	   st.shp_typ_id,

	   m._weight_limit, 

	   m._weight_from,

	   m._weight_to, 

	   m._tracking_level::smallint

from mochi.product p

	left join yahoo.vw_export_shipping_master m

		on p.upc_cd = m._product_upc_code

		

	left join mochi.shipping_destination sd

		on m._destination_code = sd.shp_dst_cd

		

	left join mochi.shipping_type st 

		on m._service_type_code = st.shp_typ_cd

where p.dept_id = 1;



	RETURN 1;

end;

$$;


ALTER FUNCTION mochi.load_shipping_products() OWNER TO mochidb_owner;

--
-- Name: random_between(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.random_between(low integer, high integer) RETURNS integer
    LANGUAGE plpgsql STRICT
    AS $$
BEGIN
   RETURN floor(random()* (high-low + 1) + low);
END;
$$;


ALTER FUNCTION public.random_between(low integer, high integer) OWNER TO postgres;

--
-- Name: accessories_attr_lcl_prd_lcl_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.accessories_attr_lcl_prd_lcl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.accessories_attr_lcl_prd_lcl_id_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accessories_attr_lcl; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.accessories_attr_lcl (
    prd_lcl_id bigint DEFAULT nextval('mochi.accessories_attr_lcl_prd_lcl_id_seq'::regclass) NOT NULL,
    prd_id bigint NOT NULL,
    primary_metal_type character varying(100),
    primary_stone_type character varying(100),
    lcl_cd character varying(5) NOT NULL
);


ALTER TABLE mochi.accessories_attr_lcl OWNER TO mochidb_owner;

--
-- Name: address_addr_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.address_addr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.address_addr_id_seq OWNER TO postgres;

--
-- Name: address; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.address (
    addr_id bigint DEFAULT nextval('mochi.address_addr_id_seq'::regclass) NOT NULL,
    addr_ln_1 character varying(100),
    addr_ln_2 character varying(100),
    addr_ln_3 character varying(100),
    addr_cnty character varying(100) NOT NULL,
    addr_pst_cd character varying(10),
    addr_typ_id bigint NOT NULL,
    pty_id bigint
);


ALTER TABLE mochi.address OWNER TO mochidb_owner;

--
-- Name: address_type_addr_typ_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.address_type_addr_typ_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.address_type_addr_typ_id_seq OWNER TO postgres;

--
-- Name: address_type; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.address_type (
    addr_typ_id bigint DEFAULT nextval('mochi.address_type_addr_typ_id_seq'::regclass) NOT NULL,
    addr_typ_cd character varying(10) NOT NULL,
    addr_typ_desc character varying(20) NOT NULL
);


ALTER TABLE mochi.address_type OWNER TO mochidb_owner;

--
-- Name: bag_bag_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.bag_bag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.bag_bag_id_seq OWNER TO mochidb_owner;

--
-- Name: bag; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.bag (
    bag_id bigint DEFAULT nextval('mochi.bag_bag_id_seq'::regclass) NOT NULL,
    pty_id bigint NOT NULL,
    bag_crd_dt timestamp with time zone NOT NULL,
    bag_upd_dt timestamp with time zone NOT NULL,
    prm_id bigint
);


ALTER TABLE mochi.bag OWNER TO mochidb_owner;

--
-- Name: bag_item_bag_item_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.bag_item_bag_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.bag_item_bag_item_id_seq OWNER TO postgres;

--
-- Name: bag_item; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.bag_item (
    bag_item_id bigint DEFAULT nextval('mochi.bag_item_bag_item_id_seq'::regclass) NOT NULL,
    bag_id bigint NOT NULL,
    prd_id bigint NOT NULL,
    qty smallint NOT NULL,
    bag_item_sts_id bigint NOT NULL
);


ALTER TABLE mochi.bag_item OWNER TO mochidb_owner;

--
-- Name: bag_item_disc_bag_item_disc_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.bag_item_disc_bag_item_disc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.bag_item_disc_bag_item_disc_id_seq OWNER TO postgres;

--
-- Name: bag_item_disc; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.bag_item_disc (
    bag_item_disc_id bigint DEFAULT nextval('mochi.bag_item_disc_bag_item_disc_id_seq'::regclass) NOT NULL,
    bag_item_id bigint NOT NULL,
    disc_amt numeric NOT NULL
);


ALTER TABLE mochi.bag_item_disc OWNER TO mochidb_owner;

--
-- Name: bag_item_status_bag_item_sts_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.bag_item_status_bag_item_sts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.bag_item_status_bag_item_sts_id_seq OWNER TO postgres;

--
-- Name: bag_item_status; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.bag_item_status (
    bag_item_sts_id bigint DEFAULT nextval('mochi.bag_item_status_bag_item_sts_id_seq'::regclass) NOT NULL,
    bag_item_sts_cd character varying(5) NOT NULL,
    bag_item_sts_desc character varying(20)
);


ALTER TABLE mochi.bag_item_status OWNER TO mochidb_owner;

--
-- Name: brand_bnd_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.brand_bnd_id_seq
    START WITH 6
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.brand_bnd_id_seq OWNER TO mochidb_owner;

--
-- Name: brand; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.brand (
    bnd_id bigint DEFAULT nextval('mochi.brand_bnd_id_seq'::regclass) NOT NULL,
    bnd_cd character(5)
);


ALTER TABLE mochi.brand OWNER TO mochidb_owner;

--
-- Name: brand_attr_lcl_bnd_lcl_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.brand_attr_lcl_bnd_lcl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.brand_attr_lcl_bnd_lcl_id_seq OWNER TO postgres;

--
-- Name: brand_attr_lcl; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.brand_attr_lcl (
    bnd_lcl_id bigint DEFAULT nextval('mochi.brand_attr_lcl_bnd_lcl_id_seq'::regclass) NOT NULL,
    bnd_id bigint NOT NULL,
    bnd_desc character varying(100),
    bnd_img_pth character varying(100),
    lcl_cd character varying(5) NOT NULL
);


ALTER TABLE mochi.brand_attr_lcl OWNER TO mochidb_owner;

--
-- Name: brand_attr_lcl_bnd_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.brand_attr_lcl_bnd_id_seq
    START WITH 19
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.brand_attr_lcl_bnd_id_seq OWNER TO mochidb_owner;

--
-- Name: brand_category_bnd_cat_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.brand_category_bnd_cat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.brand_category_bnd_cat_id_seq OWNER TO mochidb_owner;

--
-- Name: brand_category; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.brand_category (
    bnd_cat_id bigint DEFAULT nextval('mochi.brand_category_bnd_cat_id_seq'::regclass) NOT NULL,
    bnd_id bigint,
    cat_id bigint
);


ALTER TABLE mochi.brand_category OWNER TO mochidb_owner;

--
-- Name: brand_promotion_bnd_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.brand_promotion_bnd_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.brand_promotion_bnd_id_seq OWNER TO postgres;

--
-- Name: brand_promotion_prm_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.brand_promotion_prm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.brand_promotion_prm_id_seq OWNER TO postgres;

--
-- Name: brand_promotion; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.brand_promotion (
    bnd_id bigint DEFAULT nextval('mochi.brand_promotion_bnd_id_seq'::regclass) NOT NULL,
    prm_id bigint DEFAULT nextval('mochi.brand_promotion_prm_id_seq'::regclass) NOT NULL
);


ALTER TABLE mochi.brand_promotion OWNER TO mochidb_owner;

--
-- Name: category_cat_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.category_cat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.category_cat_id_seq OWNER TO mochidb_owner;

--
-- Name: category; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.category (
    cat_id bigint DEFAULT nextval('mochi.category_cat_id_seq'::regclass) NOT NULL,
    cat_cd character(5) NOT NULL,
    cat_typ_id bigint,
    cat_lvl bigint,
    cat_prnt_cd character(5),
    cat_prnt_id bigint
);


ALTER TABLE mochi.category OWNER TO mochidb_owner;

--
-- Name: category_attr_lcl_cat_lcl_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.category_attr_lcl_cat_lcl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.category_attr_lcl_cat_lcl_id_seq OWNER TO postgres;

--
-- Name: category_attr_lcl; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.category_attr_lcl (
    cat_lcl_id bigint DEFAULT nextval('mochi.category_attr_lcl_cat_lcl_id_seq'::regclass) NOT NULL,
    cat_id bigint NOT NULL,
    cat_desc character varying(100),
    cat_img_pth character varying(100),
    lcl_cd character varying(5) NOT NULL
);


ALTER TABLE mochi.category_attr_lcl OWNER TO mochidb_owner;

--
-- Name: category_brand_cat_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.category_brand_cat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.category_brand_cat_id_seq OWNER TO postgres;

--
-- Name: category_brand; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.category_brand (
    cat_id bigint DEFAULT nextval('mochi.category_brand_cat_id_seq'::regclass) NOT NULL
);


ALTER TABLE mochi.category_brand OWNER TO mochidb_owner;

--
-- Name: category_product_cat_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.category_product_cat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.category_product_cat_id_seq OWNER TO postgres;

--
-- Name: category_product; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.category_product (
    cat_id bigint DEFAULT nextval('mochi.category_product_cat_id_seq'::regclass) NOT NULL
);


ALTER TABLE mochi.category_product OWNER TO mochidb_owner;

--
-- Name: category_promotion_cat_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.category_promotion_cat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.category_promotion_cat_id_seq OWNER TO postgres;

--
-- Name: category_promotion_prm_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.category_promotion_prm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.category_promotion_prm_id_seq OWNER TO postgres;

--
-- Name: category_promotion; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.category_promotion (
    cat_id bigint DEFAULT nextval('mochi.category_promotion_cat_id_seq'::regclass) NOT NULL,
    prm_id bigint DEFAULT nextval('mochi.category_promotion_prm_id_seq'::regclass) NOT NULL
);


ALTER TABLE mochi.category_promotion OWNER TO mochidb_owner;

--
-- Name: category_type_cat_typ_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.category_type_cat_typ_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.category_type_cat_typ_id_seq OWNER TO mochidb_owner;

--
-- Name: category_type; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.category_type (
    cat_typ_id bigint DEFAULT nextval('mochi.category_type_cat_typ_id_seq'::regclass) NOT NULL,
    cat_typ_cd character varying(5) NOT NULL,
    cat_typ_desc character varying(20)
);


ALTER TABLE mochi.category_type OWNER TO mochidb_owner;

--
-- Name: currency_ccy_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.currency_ccy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.currency_ccy_id_seq OWNER TO postgres;

--
-- Name: currency; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.currency (
    ccy_id bigint DEFAULT nextval('mochi.currency_ccy_id_seq'::regclass) NOT NULL,
    ccy_cd character(3)
);


ALTER TABLE mochi.currency OWNER TO mochidb_owner;

--
-- Name: customer_cst_num_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.customer_cst_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.customer_cst_num_seq OWNER TO mochidb_owner;

--
-- Name: customer_rle_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.customer_rle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.customer_rle_id_seq OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.customer (
    rle_id bigint DEFAULT nextval('mochi.customer_rle_id_seq'::regclass) NOT NULL,
    cst_num character(10) DEFAULT nextval('mochi.customer_cst_num_seq'::regclass) NOT NULL
);


ALTER TABLE mochi.customer OWNER TO mochidb_owner;

--
-- Name: department_dept_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.department_dept_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.department_dept_id_seq OWNER TO postgres;

--
-- Name: department; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.department (
    dept_id bigint DEFAULT nextval('mochi.department_dept_id_seq'::regclass) NOT NULL,
    dept_cd character varying(5) NOT NULL
);


ALTER TABLE mochi.department OWNER TO mochidb_owner;

--
-- Name: department_attr_lcl_dept_lcl_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.department_attr_lcl_dept_lcl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.department_attr_lcl_dept_lcl_id_seq OWNER TO postgres;

--
-- Name: department_attr_lcl; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.department_attr_lcl (
    dept_lcl_id bigint DEFAULT nextval('mochi.department_attr_lcl_dept_lcl_id_seq'::regclass) NOT NULL,
    dept_id bigint NOT NULL,
    dept_desc character varying(100),
    lcl_cd character varying(5) NOT NULL
);


ALTER TABLE mochi.department_attr_lcl OWNER TO mochidb_owner;

--
-- Name: discount_dis_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.discount_dis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.discount_dis_id_seq OWNER TO postgres;

--
-- Name: discount; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.discount (
    dis_id bigint DEFAULT nextval('mochi.discount_dis_id_seq'::regclass) NOT NULL,
    dis_cd character(5),
    prm_id bigint,
    dis_typ_id bigint NOT NULL,
    dis_val numeric
);


ALTER TABLE mochi.discount OWNER TO mochidb_owner;

--
-- Name: discount_type_dis_typ_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.discount_type_dis_typ_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.discount_type_dis_typ_id_seq OWNER TO postgres;

--
-- Name: discount_type; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.discount_type (
    dis_typ_id bigint DEFAULT nextval('mochi.discount_type_dis_typ_id_seq'::regclass) NOT NULL,
    dis_typ_desc character varying NOT NULL
);


ALTER TABLE mochi.discount_type OWNER TO mochidb_owner;

--
-- Name: inventory_location_inv_loc_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.inventory_location_inv_loc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.inventory_location_inv_loc_id_seq OWNER TO postgres;

--
-- Name: inventory_location; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.inventory_location (
    inv_loc_id bigint DEFAULT nextval('mochi.inventory_location_inv_loc_id_seq'::regclass) NOT NULL,
    inv_loc_cd character(5) NOT NULL,
    inv_loc_desc character varying(50) NOT NULL,
    inv_loc_act boolean NOT NULL
);


ALTER TABLE mochi.inventory_location OWNER TO mochidb_owner;

--
-- Name: inventory_transaction_inv_trx_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.inventory_transaction_inv_trx_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.inventory_transaction_inv_trx_id_seq OWNER TO mochidb_owner;

--
-- Name: inventory_transaction; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.inventory_transaction (
    inv_trx_id bigint DEFAULT nextval('mochi.inventory_transaction_inv_trx_id_seq'::regclass) NOT NULL,
    inv_loc_id bigint NOT NULL,
    inv_prd_id bigint NOT NULL,
    inv_qty bigint NOT NULL,
    inv_prc numeric NOT NULL,
    inv_ccy_id bigint NOT NULL,
    inv_trx_typ_id bigint NOT NULL,
    inv_pty_id bigint NOT NULL,
    inv_trx_dt timestamp(4) with time zone NOT NULL
);


ALTER TABLE mochi.inventory_transaction OWNER TO mochidb_owner;

--
-- Name: inventory_transaction_type_inv_trx_typ_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.inventory_transaction_type_inv_trx_typ_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.inventory_transaction_type_inv_trx_typ_id_seq OWNER TO postgres;

--
-- Name: inventory_transaction_type; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.inventory_transaction_type (
    inv_trx_typ_id bigint DEFAULT nextval('mochi.inventory_transaction_type_inv_trx_typ_id_seq'::regclass) NOT NULL,
    inv_trx_typ_cd character varying(10) NOT NULL
);


ALTER TABLE mochi.inventory_transaction_type OWNER TO mochidb_owner;

--
-- Name: locale_lcl_cd_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.locale_lcl_cd_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.locale_lcl_cd_seq OWNER TO postgres;

--
-- Name: locale; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.locale (
    lcl_cd character varying(20) DEFAULT nextval('mochi.locale_lcl_cd_seq'::regclass) NOT NULL
);


ALTER TABLE mochi.locale OWNER TO mochidb_owner;

--
-- Name: order_ord_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.order_ord_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.order_ord_id_seq OWNER TO postgres;

--
-- Name: order; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi."order" (
    ord_id bigint DEFAULT nextval('mochi.order_ord_id_seq'::regclass) NOT NULL,
    pty_id bigint NOT NULL
);


ALTER TABLE mochi."order" OWNER TO mochidb_owner;

--
-- Name: order_line_ord_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.order_line_ord_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.order_line_ord_id_seq OWNER TO postgres;

--
-- Name: order_line_ord_lne_no_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.order_line_ord_lne_no_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.order_line_ord_lne_no_seq OWNER TO postgres;

--
-- Name: order_line_prd_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.order_line_prd_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.order_line_prd_id_seq OWNER TO postgres;

--
-- Name: order_line; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.order_line (
    ord_id bigint DEFAULT nextval('mochi.order_line_ord_id_seq'::regclass) NOT NULL,
    prd_id bigint DEFAULT nextval('mochi.order_line_prd_id_seq'::regclass) NOT NULL,
    ord_lne_no bigint DEFAULT nextval('mochi.order_line_ord_lne_no_seq'::regclass) NOT NULL,
    qty smallint NOT NULL,
    prm_id bigint NOT NULL,
    amt money NOT NULL
);


ALTER TABLE mochi.order_line OWNER TO mochidb_owner;

--
-- Name: organisation; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.organisation (
    pty_id bigint NOT NULL,
    org_nme character varying(100) NOT NULL,
    org_reg_no character varying(50) NOT NULL
);


ALTER TABLE mochi.organisation OWNER TO mochidb_owner;

--
-- Name: party; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.party (
    pty_id bigint NOT NULL,
    pty_typ_id bigint NOT NULL
);


ALTER TABLE mochi.party OWNER TO mochidb_owner;

--
-- Name: party_pty_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.party_pty_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.party_pty_id_seq OWNER TO mochidb_owner;

--
-- Name: party_pty_id_seq; Type: SEQUENCE OWNED BY; Schema: mochi; Owner: mochidb_owner
--

ALTER SEQUENCE mochi.party_pty_id_seq OWNED BY mochi.party.pty_id;


--
-- Name: party_type; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.party_type (
    pty_typ_id bigint NOT NULL,
    pty_typ_desc character varying NOT NULL
);


ALTER TABLE mochi.party_type OWNER TO mochidb_owner;

--
-- Name: party_type_pty_typ_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.party_type_pty_typ_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.party_type_pty_typ_id_seq OWNER TO mochidb_owner;

--
-- Name: party_type_pty_typ_id_seq; Type: SEQUENCE OWNED BY; Schema: mochi; Owner: mochidb_owner
--

ALTER SEQUENCE mochi.party_type_pty_typ_id_seq OWNED BY mochi.party_type.pty_typ_id;


--
-- Name: person; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.person (
    pty_id bigint NOT NULL,
    psn_gvn_nm character varying NOT NULL,
    psn_fml_nm character varying NOT NULL,
    enb boolean NOT NULL
);


ALTER TABLE mochi.person OWNER TO mochidb_owner;

--
-- Name: price_prc_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.price_prc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.price_prc_id_seq OWNER TO mochidb_owner;

--
-- Name: price; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.price (
    prc_id bigint DEFAULT nextval('mochi.price_prc_id_seq'::regclass) NOT NULL,
    prc_typ_id bigint NOT NULL,
    prd_id bigint NOT NULL,
    prc_val numeric NOT NULL,
    ccy_id bigint NOT NULL
);


ALTER TABLE mochi.price OWNER TO mochidb_owner;

--
-- Name: price_type_prc_typ_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.price_type_prc_typ_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.price_type_prc_typ_id_seq OWNER TO postgres;

--
-- Name: price_type; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.price_type (
    prc_typ_id bigint DEFAULT nextval('mochi.price_type_prc_typ_id_seq'::regclass) NOT NULL,
    prc_typ_desc character varying,
    prc_typ_cd character varying
);


ALTER TABLE mochi.price_type OWNER TO mochidb_owner;

--
-- Name: product_prd_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.product_prd_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.product_prd_id_seq OWNER TO mochidb_owner;

--
-- Name: product; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.product (
    prd_id bigint DEFAULT nextval('mochi.product_prd_id_seq'::regclass) NOT NULL,
    upc_cd character varying(30) NOT NULL,
    prd_crtd_dt timestamp(4) with time zone NOT NULL,
    bnd_id bigint NOT NULL,
    dept_id bigint NOT NULL,
    prd_sts_id bigint NOT NULL
);


ALTER TABLE mochi.product OWNER TO mochidb_owner;

--
-- Name: product_attr_lcl_prd_lcl_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.product_attr_lcl_prd_lcl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.product_attr_lcl_prd_lcl_id_seq OWNER TO mochidb_owner;

--
-- Name: product_attr_lcl; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.product_attr_lcl (
    prd_lcl_id bigint DEFAULT nextval('mochi.product_attr_lcl_prd_lcl_id_seq'::regclass) NOT NULL,
    prd_id bigint NOT NULL,
    prd_desc character varying(200),
    prd_img_pth character varying(100),
    lcl_cd character varying(5) NOT NULL,
    prd_lng_desc text
);


ALTER TABLE mochi.product_attr_lcl OWNER TO mochidb_owner;

--
-- Name: product_basic_prd_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.product_basic_prd_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.product_basic_prd_id_seq OWNER TO postgres;

--
-- Name: product_basic; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.product_basic (
    prd_id bigint DEFAULT nextval('mochi.product_basic_prd_id_seq'::regclass) NOT NULL,
    width bigint,
    height bigint,
    length bigint,
    weight numeric(8,2)
);


ALTER TABLE mochi.product_basic OWNER TO mochidb_owner;

--
-- Name: product_category_prd_cat_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.product_category_prd_cat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.product_category_prd_cat_id_seq OWNER TO mochidb_owner;

--
-- Name: product_category; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.product_category (
    prd_cat_id bigint DEFAULT nextval('mochi.product_category_prd_cat_id_seq'::regclass) NOT NULL,
    prd_id bigint,
    cat_id bigint
);


ALTER TABLE mochi.product_category OWNER TO mochidb_owner;

--
-- Name: product_promotion_prd_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.product_promotion_prd_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.product_promotion_prd_id_seq OWNER TO postgres;

--
-- Name: product_promotion_prm_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.product_promotion_prm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.product_promotion_prm_id_seq OWNER TO postgres;

--
-- Name: product_promotion; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.product_promotion (
    prd_id bigint DEFAULT nextval('mochi.product_promotion_prd_id_seq'::regclass) NOT NULL,
    prm_id bigint DEFAULT nextval('mochi.product_promotion_prm_id_seq'::regclass) NOT NULL
);


ALTER TABLE mochi.product_promotion OWNER TO mochidb_owner;

--
-- Name: product_rating_prd_rat_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.product_rating_prd_rat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.product_rating_prd_rat_id_seq OWNER TO mochidb_owner;

--
-- Name: product_rating; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.product_rating (
    prd_rat_id bigint DEFAULT nextval('mochi.product_rating_prd_rat_id_seq'::regclass) NOT NULL,
    prd_id bigint NOT NULL,
    rat_id bigint NOT NULL,
    pty_id bigint NOT NULL,
    prd_rat_dt timestamp with time zone NOT NULL
);


ALTER TABLE mochi.product_rating OWNER TO mochidb_owner;

--
-- Name: product_shipping_prd_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.product_shipping_prd_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.product_shipping_prd_id_seq OWNER TO postgres;

--
-- Name: product_shipping; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.product_shipping (
    prd_id bigint DEFAULT nextval('mochi.product_shipping_prd_id_seq'::regclass) NOT NULL,
    shp_wgt_lim numeric,
    shp_wgt_frm numeric NOT NULL,
    shp_wgt_to numeric NOT NULL,
    shp_typ_cd character(6) NOT NULL,
    shp_ctry_cd character(3) NOT NULL
);


ALTER TABLE mochi.product_shipping OWNER TO mochidb_owner;

--
-- Name: product_shipping_attr_lcl_prd_lcl_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.product_shipping_attr_lcl_prd_lcl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.product_shipping_attr_lcl_prd_lcl_id_seq OWNER TO mochidb_owner;

--
-- Name: product_shipping_attr_lcl; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.product_shipping_attr_lcl (
    prd_lcl_id bigint DEFAULT nextval('mochi.product_shipping_attr_lcl_prd_lcl_id_seq'::regclass) NOT NULL,
    prd_id bigint NOT NULL,
    prd_shp_typ_desc character varying(100),
    prd_shp_ctry_desc character varying(100),
    lcl_cd character varying(5) NOT NULL
);


ALTER TABLE mochi.product_shipping_attr_lcl OWNER TO mochidb_owner;

--
-- Name: product_status_prd_sts_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.product_status_prd_sts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.product_status_prd_sts_id_seq OWNER TO mochidb_owner;

--
-- Name: product_status; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.product_status (
    prd_sts_id bigint DEFAULT nextval('mochi.product_status_prd_sts_id_seq'::regclass) NOT NULL,
    prd_sts_cd character varying(5) NOT NULL,
    prd_sts_desc character varying(20)
);


ALTER TABLE mochi.product_status OWNER TO mochidb_owner;

--
-- Name: product_supplier; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.product_supplier (
);


ALTER TABLE mochi.product_supplier OWNER TO mochidb_owner;

--
-- Name: product_tag_prd_tag_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.product_tag_prd_tag_id_seq
    START WITH 25
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.product_tag_prd_tag_id_seq OWNER TO mochidb_owner;

--
-- Name: product_tag; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.product_tag (
    prd_tag_id bigint DEFAULT nextval('mochi.product_tag_prd_tag_id_seq'::regclass) NOT NULL,
    prd_id bigint,
    tag_id bigint
);


ALTER TABLE mochi.product_tag OWNER TO mochidb_owner;

--
-- Name: promotion_prm_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.promotion_prm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.promotion_prm_id_seq OWNER TO postgres;

--
-- Name: promotion; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.promotion (
    prm_id bigint DEFAULT nextval('mochi.promotion_prm_id_seq'::regclass) NOT NULL,
    prm_cd character(6) NOT NULL,
    prm_st_dt timestamp(4) with time zone NOT NULL,
    prm_en_dt timestamp(4) with time zone NOT NULL,
    prm_mec_id bigint NOT NULL,
    prm_act boolean NOT NULL,
    prm_typ_id bigint NOT NULL,
    prm_lvl_id bigint NOT NULL,
    prm_dis_id bigint
);


ALTER TABLE mochi.promotion OWNER TO mochidb_owner;

--
-- Name: promotion_attr_lcl_prm_lcl_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.promotion_attr_lcl_prm_lcl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.promotion_attr_lcl_prm_lcl_id_seq OWNER TO postgres;

--
-- Name: promotion_attr_lcl; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.promotion_attr_lcl (
    prm_lcl_id bigint DEFAULT nextval('mochi.promotion_attr_lcl_prm_lcl_id_seq'::regclass) NOT NULL,
    prm_id bigint NOT NULL,
    prm_desc character varying(100),
    lcl_cd character varying(5) NOT NULL
);


ALTER TABLE mochi.promotion_attr_lcl OWNER TO mochidb_owner;

--
-- Name: promotion_level_prm_lvl_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.promotion_level_prm_lvl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.promotion_level_prm_lvl_id_seq OWNER TO postgres;

--
-- Name: promotion_level; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.promotion_level (
    prm_lvl_id bigint DEFAULT nextval('mochi.promotion_level_prm_lvl_id_seq'::regclass) NOT NULL,
    prm_lvl_cd character varying(5) NOT NULL,
    prm_lvl_desc character varying(50) NOT NULL
);


ALTER TABLE mochi.promotion_level OWNER TO mochidb_owner;

--
-- Name: promotion_mechanic_prm_mec_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.promotion_mechanic_prm_mec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.promotion_mechanic_prm_mec_id_seq OWNER TO postgres;

--
-- Name: promotion_mechanic; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.promotion_mechanic (
    prm_mec_id bigint DEFAULT nextval('mochi.promotion_mechanic_prm_mec_id_seq'::regclass) NOT NULL,
    prm_mec_cd character varying(10) NOT NULL,
    prm_mec_desc character varying
);


ALTER TABLE mochi.promotion_mechanic OWNER TO mochidb_owner;

--
-- Name: promotion_order_prm_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.promotion_order_prm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.promotion_order_prm_id_seq OWNER TO postgres;

--
-- Name: promotion_order; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.promotion_order (
    prm_id bigint DEFAULT nextval('mochi.promotion_order_prm_id_seq'::regclass) NOT NULL,
    prm_cpn_cd character varying(15) NOT NULL
);


ALTER TABLE mochi.promotion_order OWNER TO mochidb_owner;

--
-- Name: promotion_product_prm_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.promotion_product_prm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.promotion_product_prm_id_seq OWNER TO postgres;

--
-- Name: promotion_product; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.promotion_product (
    prm_id bigint DEFAULT nextval('mochi.promotion_product_prm_id_seq'::regclass) NOT NULL
);


ALTER TABLE mochi.promotion_product OWNER TO mochidb_owner;

--
-- Name: promotion_type_prm_typ_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.promotion_type_prm_typ_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.promotion_type_prm_typ_id_seq OWNER TO postgres;

--
-- Name: promotion_type; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.promotion_type (
    prm_typ_id bigint DEFAULT nextval('mochi.promotion_type_prm_typ_id_seq'::regclass) NOT NULL,
    prm_typ_cd character varying(5) NOT NULL,
    prm_class character varying(20) NOT NULL,
    prm_typ_desc character varying(50) NOT NULL
);


ALTER TABLE mochi.promotion_type OWNER TO mochidb_owner;

--
-- Name: rating_rat_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.rating_rat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.rating_rat_id_seq OWNER TO postgres;

--
-- Name: rating; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.rating (
    rat_id bigint DEFAULT nextval('mochi.rating_rat_id_seq'::regclass) NOT NULL,
    rat_desc character varying(50),
    rat_val smallint
);


ALTER TABLE mochi.rating OWNER TO mochidb_owner;

--
-- Name: role_rle_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.role_rle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.role_rle_id_seq OWNER TO mochidb_owner;

--
-- Name: role; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.role (
    rle_id bigint DEFAULT nextval('mochi.role_rle_id_seq'::regclass) NOT NULL,
    rle_typ_id bigint NOT NULL,
    rle_start_dt timestamp(4) with time zone DEFAULT now() NOT NULL,
    pty_id bigint NOT NULL
);


ALTER TABLE mochi.role OWNER TO mochidb_owner;

--
-- Name: role_type; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.role_type (
    rle_typ_id bigint NOT NULL,
    rle_typ_desc character varying NOT NULL
);


ALTER TABLE mochi.role_type OWNER TO mochidb_owner;

--
-- Name: role_type_rle_typ_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.role_type_rle_typ_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.role_type_rle_typ_id_seq OWNER TO mochidb_owner;

--
-- Name: role_type_rle_typ_id_seq; Type: SEQUENCE OWNED BY; Schema: mochi; Owner: mochidb_owner
--

ALTER SEQUENCE mochi.role_type_rle_typ_id_seq OWNED BY mochi.role_type.rle_typ_id;


--
-- Name: stock_on_hand_soh_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.stock_on_hand_soh_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.stock_on_hand_soh_id_seq OWNER TO postgres;

--
-- Name: stock_on_hand; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.stock_on_hand (
    soh_id bigint DEFAULT nextval('mochi.stock_on_hand_soh_id_seq'::regclass) NOT NULL,
    soh_prd_id bigint NOT NULL,
    soh_qty bigint NOT NULL
);


ALTER TABLE mochi.stock_on_hand OWNER TO mochidb_owner;

--
-- Name: supplier_rle_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.supplier_rle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.supplier_rle_id_seq OWNER TO postgres;

--
-- Name: supplier_sup_num_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.supplier_sup_num_seq
    START WITH 1000000001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.supplier_sup_num_seq OWNER TO mochidb_owner;

--
-- Name: supplier; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.supplier (
    rle_id bigint DEFAULT nextval('mochi.supplier_rle_id_seq'::regclass) NOT NULL,
    sup_num character(10) DEFAULT nextval('mochi.supplier_sup_num_seq'::regclass) NOT NULL
);


ALTER TABLE mochi.supplier OWNER TO mochidb_owner;

--
-- Name: tag_tag_id_seq; Type: SEQUENCE; Schema: mochi; Owner: mochidb_owner
--

CREATE SEQUENCE mochi.tag_tag_id_seq
    START WITH 15
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.tag_tag_id_seq OWNER TO mochidb_owner;

--
-- Name: tag; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.tag (
    tag_id bigint DEFAULT nextval('mochi.tag_tag_id_seq'::regclass) NOT NULL,
    tag_cd character(5) NOT NULL
);


ALTER TABLE mochi.tag OWNER TO mochidb_owner;

--
-- Name: tag_attr_lcl_tag_lcl_id_seq; Type: SEQUENCE; Schema: mochi; Owner: postgres
--

CREATE SEQUENCE mochi.tag_attr_lcl_tag_lcl_id_seq
    START WITH 6
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mochi.tag_attr_lcl_tag_lcl_id_seq OWNER TO postgres;

--
-- Name: tag_attr_lcl; Type: TABLE; Schema: mochi; Owner: mochidb_owner
--

CREATE TABLE mochi.tag_attr_lcl (
    tag_lcl_id bigint DEFAULT nextval('mochi.tag_attr_lcl_tag_lcl_id_seq'::regclass) NOT NULL,
    tag_id bigint NOT NULL,
    tag_desc character varying(100),
    tag_img_pth character varying(100),
    lcl_cd character varying(5) NOT NULL
);


ALTER TABLE mochi.tag_attr_lcl OWNER TO mochidb_owner;

--
-- Name: permission; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.permission (
    id bigint NOT NULL,
    name character varying(255)
);


ALTER TABLE security.permission OWNER TO security_owner;

--
-- Name: authority_id_seq; Type: SEQUENCE; Schema: security; Owner: security_owner
--

CREATE SEQUENCE security.authority_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE security.authority_id_seq OWNER TO security_owner;

--
-- Name: authority_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: security_owner
--

ALTER SEQUENCE security.authority_id_seq OWNED BY security.permission.id;


--
-- Name: clientdetails; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.clientdetails (
    appid character varying(256) NOT NULL,
    resourceids character varying(256),
    appsecret character varying(256),
    scope character varying(256),
    granttypes character varying(256),
    redirecturl character varying(256),
    authorities character varying(256),
    access_token_validity integer,
    refresh_token_validity integer,
    additionalinformation character varying(4096),
    autoapprovescopes character varying(256)
);


ALTER TABLE security.clientdetails OWNER TO security_owner;

--
-- Name: device_metadata; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.device_metadata (
    id bigint NOT NULL,
    device_details character varying(255),
    last_logged_in timestamp without time zone,
    location character varying(255),
    user_id bigint
);


ALTER TABLE security.device_metadata OWNER TO security_owner;

--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: security; Owner: security_owner
--

CREATE SEQUENCE security.hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE security.hibernate_sequence OWNER TO security_owner;

--
-- Name: new_location_token; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.new_location_token (
    id bigint NOT NULL,
    token character varying(255),
    user_location_id bigint NOT NULL
);


ALTER TABLE security.new_location_token OWNER TO security_owner;

--
-- Name: oauth_access_token; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.oauth_access_token (
    token_id character varying(256),
    token bytea,
    authentication_id character varying(256) NOT NULL,
    user_name character varying(256),
    client_id character varying(256),
    authentication bytea,
    refresh_token character varying(256)
);


ALTER TABLE security.oauth_access_token OWNER TO security_owner;

--
-- Name: oauth_approvals; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.oauth_approvals (
    userid character varying(256),
    clientid character varying(256),
    scope character varying(256),
    status character varying(10),
    expiresat timestamp without time zone,
    lastmodifiedat timestamp without time zone
);


ALTER TABLE security.oauth_approvals OWNER TO security_owner;

--
-- Name: oauth_client_details; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.oauth_client_details (
    client_id character varying(256) NOT NULL,
    resource_ids character varying(256),
    client_secret character varying(256),
    scope character varying(256),
    authorized_grant_types character varying(256),
    web_server_redirect_uri character varying(256),
    authorities character varying(256),
    access_token_validity integer,
    refresh_token_validity integer,
    additional_information character varying(4096),
    autoapprove character varying(256)
);


ALTER TABLE security.oauth_client_details OWNER TO security_owner;

--
-- Name: oauth_client_token; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.oauth_client_token (
    token_id character varying(256),
    token bytea,
    authentication_id character varying(256) NOT NULL,
    user_name character varying(256),
    client_id character varying(256)
);


ALTER TABLE security.oauth_client_token OWNER TO security_owner;

--
-- Name: oauth_code; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.oauth_code (
    code character varying(256),
    authentication bytea
);


ALTER TABLE security.oauth_code OWNER TO security_owner;

--
-- Name: oauth_refresh_token; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.oauth_refresh_token (
    token_id character varying(256),
    token bytea,
    authentication bytea
);


ALTER TABLE security.oauth_refresh_token OWNER TO security_owner;

--
-- Name: password_reset_token; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.password_reset_token (
    id bigint NOT NULL,
    expiry_date timestamp without time zone,
    token character varying(255),
    pty_id bigint NOT NULL
);


ALTER TABLE security.password_reset_token OWNER TO security_owner;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: security; Owner: security_owner
--

CREATE SEQUENCE security.role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE security.role_id_seq OWNER TO security_owner;

--
-- Name: role; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.role (
    id bigint DEFAULT nextval('security.role_id_seq'::regclass) NOT NULL,
    name character varying(40)
);


ALTER TABLE security.role OWNER TO security_owner;

--
-- Name: role_permission_id_seq; Type: SEQUENCE; Schema: security; Owner: security_owner
--

CREATE SEQUENCE security.role_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE security.role_permission_id_seq OWNER TO security_owner;

--
-- Name: role_permission; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.role_permission (
    id bigint DEFAULT nextval('security.role_permission_id_seq'::regclass) NOT NULL,
    role_id bigint NOT NULL,
    permission_id bigint NOT NULL
);


ALTER TABLE security.role_permission OWNER TO security_owner;

--
-- Name: user_; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.user_ (
    pty_id bigint NOT NULL,
    account_expired boolean,
    account_locked boolean,
    credentials_expired boolean,
    enabled boolean,
    password character varying(255),
    user_name character varying(255),
    is_using2fa boolean,
    secret character varying(255)
);


ALTER TABLE security.user_ OWNER TO security_owner;

--
-- Name: user_location; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.user_location (
    id bigint NOT NULL,
    country character varying(255),
    enabled boolean NOT NULL,
    pty_id bigint NOT NULL
);


ALTER TABLE security.user_location OWNER TO security_owner;

--
-- Name: user_role_id_seq; Type: SEQUENCE; Schema: security; Owner: security_owner
--

CREATE SEQUENCE security.user_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE security.user_role_id_seq OWNER TO security_owner;

--
-- Name: user_role; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.user_role (
    id bigint DEFAULT nextval('security.user_role_id_seq'::regclass) NOT NULL,
    pty_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE security.user_role OWNER TO security_owner;

--
-- Name: verification_token; Type: TABLE; Schema: security; Owner: security_owner
--

CREATE TABLE security.verification_token (
    id bigint NOT NULL,
    expiry_date timestamp without time zone,
    token character varying(255),
    pty_id bigint NOT NULL
);


ALTER TABLE security.verification_token OWNER TO security_owner;

--
-- Name: party pty_id; Type: DEFAULT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.party ALTER COLUMN pty_id SET DEFAULT nextval('mochi.party_pty_id_seq'::regclass);


--
-- Name: party_type pty_typ_id; Type: DEFAULT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.party_type ALTER COLUMN pty_typ_id SET DEFAULT nextval('mochi.party_type_pty_typ_id_seq'::regclass);


--
-- Name: role_type rle_typ_id; Type: DEFAULT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.role_type ALTER COLUMN rle_typ_id SET DEFAULT nextval('mochi.role_type_rle_typ_id_seq'::regclass);


--
-- Name: permission id; Type: DEFAULT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.permission ALTER COLUMN id SET DEFAULT nextval('security.authority_id_seq'::regclass);


--
-- Data for Name: accessories_attr_lcl; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.accessories_attr_lcl (prd_lcl_id, prd_id, primary_metal_type, primary_stone_type, lcl_cd) FROM stdin;
6	5	\N	\N	en-GB
8	7	\N	\N	en-GB
10	9	\N	\N	en-GB
14	13	\N	\N	en-GB
22	21	\N	\N	en-GB
24	23	\N	\N	en-GB
26	25	\N	\N	en-GB
27	26	\N	\N	en-GB
29	28	\N	\N	en-GB
31	30	\N	\N	en-GB
3	2	\N	\N	en-GB
9	8	\N	\N	en-GB
18	17	\N	\N	en-GB
4	3	\N	\N	en-GB
5	4	\N	\N	en-GB
7	6	\N	\N	en-GB
13	12	\N	\N	en-GB
17	16	\N	\N	en-GB
11	10	\N	\N	en-GB
12	11	\N	\N	en-GB
15	14	\N	\N	en-GB
16	15	\N	\N	en-GB
20	19	\N	\N	en-GB
21	20	\N	\N	en-GB
23	22	\N	\N	en-GB
25	24	\N	\N	en-GB
28	27	\N	\N	en-GB
30	29	\N	\N	en-GB
2	1	\N	\N	en-GB
19	18	\N	\N	en-GB
45	5	\N	\N	zh-HK
47	7	\N	\N	zh-HK
49	9	\N	\N	zh-HK
53	13	\N	\N	zh-HK
61	21	\N	\N	zh-HK
63	23	\N	\N	zh-HK
65	25	\N	\N	zh-HK
66	26	\N	\N	zh-HK
68	28	\N	\N	zh-HK
70	30	\N	\N	zh-HK
42	2	\N	\N	zh-HK
48	8	\N	\N	zh-HK
57	17	\N	\N	zh-HK
43	3	\N	\N	zh-HK
44	4	\N	\N	zh-HK
46	6	\N	\N	zh-HK
52	12	\N	\N	zh-HK
56	16	\N	\N	zh-HK
50	10	\N	\N	zh-HK
51	11	\N	\N	zh-HK
54	14	\N	\N	zh-HK
55	15	\N	\N	zh-HK
59	19	\N	\N	zh-HK
60	20	\N	\N	zh-HK
62	22	\N	\N	zh-HK
64	24	\N	\N	zh-HK
67	27	\N	\N	zh-HK
69	29	\N	\N	zh-HK
41	1	\N	\N	zh-HK
58	18	\N	\N	zh-HK
\.


--
-- Data for Name: address; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.address (addr_id, addr_ln_1, addr_ln_2, addr_ln_3, addr_cnty, addr_pst_cd, addr_typ_id, pty_id) FROM stdin;
1	Test Line 1	Test Line 2	Test Line 3	Test Ctry	Test PC	2	234482
2	Test Line 1	Test Line 2	Test Line 3	Test Ctry	Test PC	1	234482
\.


--
-- Data for Name: address_type; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.address_type (addr_typ_id, addr_typ_cd, addr_typ_desc) FROM stdin;
1	MAI01	Mailing Address
2	BIL01	Billing Address
\.


--
-- Data for Name: bag; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.bag (bag_id, pty_id, bag_crd_dt, bag_upd_dt, prm_id) FROM stdin;
234473	232304	2020-12-01 21:33:14.43+08	2020-12-01 21:33:14.431+08	\N
234476	232304	2020-12-01 21:40:31.98+08	2020-12-01 21:40:31.98+08	\N
234487	234485	2022-06-23 16:36:19.391+08	2022-06-23 16:36:19.391+08	\N
234484	234482	2020-12-02 12:54:34.693+08	2022-06-23 17:00:04.502+08	\N
\.


--
-- Data for Name: bag_item; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.bag_item (bag_item_id, bag_id, prd_id, qty, bag_item_sts_id) FROM stdin;
234517	234484	18	4	1
\.


--
-- Data for Name: bag_item_disc; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.bag_item_disc (bag_item_disc_id, bag_item_id, disc_amt) FROM stdin;
\.


--
-- Data for Name: bag_item_status; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.bag_item_status (bag_item_sts_id, bag_item_sts_cd, bag_item_sts_desc) FROM stdin;
1	NEW01	New
2	PRO01	Processed
3	PND01	Pending
\.


--
-- Data for Name: brand; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.brand (bnd_id, bnd_cd) FROM stdin;
32	DLE01
33	ENZ01
34	DIV01
35	DRI01
36	WON01
37	PLA01
38	GLO01
39	ADO01
40	GOL01
41	SHI01
233191	LAYLA
233194	WILOW
233197	MARLY
233200	SCOTI
233203	IPSY 
233206	LBS  
233209	LINSY
233212	PHONY
233215	HLEAF
42	HKP01
233218	TST02
\.


--
-- Data for Name: brand_attr_lcl; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.brand_attr_lcl (bnd_lcl_id, bnd_id, bnd_desc, bnd_img_pth, lcl_cd) FROM stdin;
59	32	Dole	\N	en-GB
60	32	Dole	\N	zh-HK
61	33	Enza	\N	en-GB
62	33	Enza	\N	zh-HK
63	34	Diva	\N	en-GB
64	34	Diva	\N	zh-HK
65	35	Driscolls	\N	en-GB
66	35	Driscolls	\N	zh-HK
67	36	Wonderful	\N	en-GB
68	36	Wonderful	\N	zh-HK
69	37	Planters	\N	en-GB
70	37	Planters	\N	zh-HK
71	38	Glorys	\N	en-GB
72	38	Glorys	\N	zh-HK
73	39	Adora	\N	en-GB
74	39	Adora	\N	zh-HK
75	40	Gold	\N	en-GB
76	40	Gold	\N	zh-HK
77	41	Shine	\N	en-GB
78	41	Shine	\N	zh-HK
233192	233191	LAYLA	\N	en-GB
233193	233191	Layla萊拉	\N	zh-HK
233195	233194	WILLOW	\N	en-GB
233196	233194	Willow小柳	\N	zh-HK
233198	233197	MARLEY 	\N	en-GB
233199	233197	Marley馬利	\N	zh-HK
233201	233200	Scottish  Hendoz 	\N	en-GB
233202	233200	Scottish Hendoz蘇格蘭亨多斯	\N	zh-HK
233204	233203	Ipsy	\N	en-GB
233205	233203	Ipsy葉子	\N	zh-HK
233207	233206	Little Bag	\N	en-GB
233208	233206	Little Bat小包包	\N	zh-HK
233210	233209	LINSY	\N	en-GB
233211	233209	Linsy連斯	\N	zh-HK
233213	233212	Phoney 	\N	en-GB
233214	233212	Phoney 	\N	zh-HK
233216	233215	HAPPYLEAF	\N	en-GB
233217	233215	開心葉	\N	zh-HK
79	42	Hong Kong Post	\N	en-GB
80	42	香港郵政	\N	zh-HK
233221	233218	test brand	\N	en-GB
233222	233218	測試品牌	\N	zh-HK
\.


--
-- Data for Name: brand_category; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.brand_category (bnd_cat_id, bnd_id, cat_id) FROM stdin;
11	32	45
12	33	45
13	34	45
14	35	45
\.


--
-- Data for Name: brand_promotion; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.brand_promotion (bnd_id, prm_id) FROM stdin;
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.category (cat_id, cat_cd, cat_typ_id, cat_lvl, cat_prnt_cd, cat_prnt_id) FROM stdin;
45	FBR01	2	0	\N	\N
39	PRM02	1	0	\N	\N
40	BND01	1	0	\N	\N
2	PRM01	1	0	\N	\N
38	FET01	1	1	PRM02	39
25	OFT01	1	2	FRT01	3
4	VEG01	1	1	PRM01	2
13	MEL01	1	2	FRT01	3
11	DRU01	1	2	FRT01	3
36	REV01	1	3	ROV01	6
22	PEC01	1	2	NUT01	16
10	POM01	1	2	FRT01	3
42	OTH02	1	1	BND01	40
17	PIS01	1	2	NUT01	16
5	DGV01	1	2	VEG01	4
15	TRO01	1	2	FRT01	3
6	ROV01	1	2	VEG01	4
12	BER01	1	2	FRT01	3
43	BSP01	1	1	PRM02	39
8	SVG01	1	2	VEG01	4
16	NUT01	1	1	PRM01	2
18	HAZ01	1	2	NUT01	16
26	ONT01	1	2	NUT01	16
7	BAP01	1	2	VEG01	4
14	CIT01	1	2	FRT01	3
44	UNK01	1	1	PRM02	39
21	PEA01	1	2	NUT01	16
24	MAC01	1	2	NUT01	16
23	BRA01	1	2	NUT01	16
19	CAS01	1	2	NUT01	16
9	OTH01	1	2	VEG01	4
3	FRT01	1	1	PRM01	2
20	ALM01	1	2	NUT01	16
37	ORV01	1	3	ROV01	6
233095	PRM05	1	0	     	\N
233131	FFSHO	1	3	FFOT1	233107
233185	HFCAR	1	3	HFLO1	233182
233059	AHAR1	1	2	ACC01	233056
233152	FCTOP	1	3	FCLO1	233116
233113	FWAT1	1	2	FAS01	233104
233155	FCBOT	1	3	FCLO1	233116
233098	AOLAN	1	3	AOTH1	233062
233134	FFSLI	1	3	FFOT1	233107
233173	FCPOC	1	3	FCOO1	233125
233101	AOPAD	1	3	AOTH1	233062
233167	FBHAN	1	3	FBAG1	233119
233065	AJEW1	1	2	ACC01	233056
233074	AHHAT	1	3	AHAR1	233059
233116	FCLO1	1	2	FAS01	233104
233107	FFOT1	1	2	FAS01	233104
233140	FBFAB	1	3	FBEL1	233110
233068	AHHAB	1	3	AHAR1	233059
233110	FBEL1	1	2	FAS01	233104
233143	FHSUN	1	3	FHEA1	233122
233071	AHHAC	1	3	AHAR1	233059
233080	AJEAR	1	3	AJEW1	233065
233137	FFSOC	1	3	FFOT1	233107
233164	FBBAC	1	3	FBAG1	233119
233092	AOKEY	1	3	AOTH1	233062
233161	FCSCA	1	3	FCLO1	233116
233122	FHEA1	1	2	FAS01	233104
233158	FCJAC	1	3	FCLO1	233116
233062	AOTH1	1	2	ACC01	233056
233119	FBAG1	1	2	FAS01	233104
233170	FBWAL	1	3	FBAG1	233119
233179	HOM01	1	1	PRM05	233095
233128	FPHO1	1	2	FAS01	233104
233104	FAS01	1	1	PRM05	233095
233089	AJBRO	1	3	AJEW1	233065
233146	FHHAT	1	3	FHEA1	233122
233188	HFCUP	1	3	HFLO1	233182
233125	FCOO1	1	2	FAS01	233104
233176	FPAPP	1	3	FPHO1	233128
233077	AJBRA	1	3	AJEW1	233065
233056	ACC01	1	1	PRM05	233095
233083	AJNEC	1	3	AJEW1	233065
233182	HFLO1	1	2	HOM01	233179
233086	AJRIN	1	3	AJEW1	233065
233149	FWWAT	1	3	FWAT1	233113
46	SHP01	1	0	\N	\N
\.


--
-- Data for Name: category_attr_lcl; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.category_attr_lcl (cat_lcl_id, cat_id, cat_desc, cat_img_pth, lcl_cd) FROM stdin;
14	3	水果		zh-HK
17	5	深綠色蔬菜	\N	zh-HK
19	6	紅色和橙色蔬菜	\N	zh-HK
21	7	豆類和豌豆	\N	zh-HK
23	8	澱粉蔬菜	\N	zh-HK
25	9	其他蔬菜	\N	zh-HK
27	10	梨果	\N	zh-HK
29	11	核果	\N	zh-HK
31	12	漿果	\N	zh-HK
33	13	瓜	\N	zh-HK
35	14	柑橘	\N	zh-HK
37	15	熱帶	\N	zh-HK
39	16	堅果	\N	zh-HK
41	17	開心果	\N	zh-HK
43	18	榛子	\N	zh-HK
45	19	腰果	\N	zh-HK
47	20	杏仁	\N	zh-HK
49	21	花生	\N	zh-HK
51	22	胡桃	\N	zh-HK
53	23	巴西	\N	zh-HK
55	24	澳洲	\N	zh-HK
57	25	其他水果	\N	zh-HK
59	26	其他堅果	\N	zh-HK
79	36	紅色蔬菜	\N	zh-HK
81	37	橙色蔬菜	\N	zh-HK
10	2	ALL		en-GB
11	3	Fruit		en-GB
20	7	Beans and Peas	\N	en-GB
26	10	Pomes	\N	en-GB
28	11	Drupes	\N	en-GB
30	12	Berries	\N	en-GB
32	13	Melons	\N	en-GB
34	14	Citrus	\N	en-GB
36	15	Tropical	\N	en-GB
38	16	Nuts	\N	en-GB
15	4	蔬菜	VEG01.jpg	zh-HK
12	4	Vegetables	VEG01.jpg	en-GB
40	17	Pistachios	\N	en-GB
42	18	Hazelnuts	\N	en-GB
44	19	Cashews	\N	en-GB
46	20	Almonds	\N	en-GB
48	21	Peanuts	\N	en-GB
50	22	Pecans	\N	en-GB
52	23	Brazil	\N	en-GB
54	24	Macadamia	\N	en-GB
56	25	Other Fruit	\N	en-GB
58	26	Other Nuts	\N	en-GB
82	38	Featured	\N	en-GB
83	38	精選	\N	zh-HK
84	39	MISC	\N	en-GB
85	39	雜	\N	zh-HK
86	40	All Brands	\N	en-GB
87	40	所有品牌	\N	zh-HK
90	42	Other Brands	\N	en-GB
99	42	其他品牌	\N	zh-HK
100	43	Best Sellers	\N	en-GB
101	43	最暢銷	\N	zh-HK
16	5	Dark Green	\N	en-GB
18	6	Red and Orange	\N	en-GB
22	8	Starchy	\N	en-GB
24	9	Other	\N	en-GB
78	36	Red	\N	en-GB
80	37	Orange	\N	en-GB
102	44	Unknown	\N	en-GB
103	44	未知	\N	zh-HK
13	2	ALL		zh-HK
104	45	Featured Brands	\N	en-GB
105	45	推薦品牌	\N	zh-HK
233057	233056	Accessories	\N	en-GB
233058	233056	配件	\N	zh-HK
233060	233059	Hair Accessories	\N	en-GB
233061	233059	髮飾	\N	zh-HK
233063	233062	Other Accessories 	\N	en-GB
233064	233062	其他飾物	\N	zh-HK
233066	233065	Jewelry	\N	en-GB
233067	233065	首飾	\N	zh-HK
233069	233068	Hair Bands	\N	en-GB
233070	233068	頭箍	\N	zh-HK
233072	233071	Hair Clips	\N	en-GB
233073	233071	髮夾	\N	zh-HK
233075	233074	Hair Ties 	\N	en-GB
233076	233074	頭髮橡筋	\N	zh-HK
233078	233077	Bracelets	\N	en-GB
233079	233077	手鏈 	\N	zh-HK
233081	233080	Earrings	\N	en-GB
233082	233080	耳環	\N	zh-HK
233084	233083	Necklaces	\N	en-GB
233085	233083	項鍊	\N	zh-HK
233087	233086	Rings	\N	en-GB
233088	233086	戒指	\N	zh-HK
233090	233089	Brooch	\N	en-GB
233091	233089	胸針	\N	zh-HK
233093	233092	Keyrings	\N	en-GB
233094	233092	鎖匙扣	\N	zh-HK
233096	233095	Master Category	\N	en-GB
233097	233095	主類別	\N	zh-HK
233099	233098	Lanyards	\N	en-GB
233100	233098	頸繩	\N	zh-HK
233102	233101	Packing decorations	\N	en-GB
233103	233101	包裝裝飾物	\N	zh-HK
233105	233104	Fashion 	\N	en-GB
233106	233104	時裝	\N	zh-HK
233108	233107	Footwear	\N	en-GB
233109	233107	鞋類	\N	zh-HK
233111	233110	Belts	\N	en-GB
233112	233110	皮帶	\N	zh-HK
233114	233113	Watches	\N	en-GB
233115	233113	手錶	\N	zh-HK
233117	233116	Clothes 	\N	en-GB
233118	233116	衣服	\N	zh-HK
233120	233119	Bags and wallets	\N	en-GB
233121	233119	手袋銀包	\N	zh-HK
233123	233122	Head Accessories 	\N	en-GB
233124	233122	頭飾	\N	zh-HK
233126	233125	Cool Stationary 	\N	en-GB
233127	233125	時尚文具	\N	zh-HK
233129	233128	Phone Accessories	\N	en-GB
233130	233128	手機配件	\N	zh-HK
233132	233131	Shoes	\N	en-GB
233133	233131	鞋	\N	zh-HK
233135	233134	Slippers	\N	en-GB
233136	233134	拖鞋	\N	zh-HK
233138	233137	Socks	\N	en-GB
233139	233137	襪	\N	zh-HK
233141	233140	Fashion Belts 	\N	en-GB
233142	233140	時尚皮帶	\N	zh-HK
233144	233143	Sunglasses	\N	en-GB
233145	233143	太陽眼鏡	\N	zh-HK
233147	233146	Hats	\N	en-GB
233148	233146	帽	\N	zh-HK
233150	233149	Fashion Watches	\N	en-GB
233151	233149	時尚手錶	\N	zh-HK
233153	233152	Tops	\N	en-GB
233154	233152	上衫	\N	zh-HK
233156	233155	Bottoms 	\N	en-GB
233157	233155	外褲	\N	zh-HK
233159	233158	Jackets	\N	en-GB
233160	233158	外褸	\N	zh-HK
233162	233161	Scarfs	\N	en-GB
233163	233161	頸巾	\N	zh-HK
233165	233164	Backpacks	\N	en-GB
233166	233164	背囊	\N	zh-HK
233168	233167	Handbags	\N	en-GB
233169	233167	包包	\N	zh-HK
233171	233170	Wallet 	\N	en-GB
233172	233170	銀包	\N	zh-HK
233174	233173	Pockets 	\N	en-GB
233175	233173	文件袋	\N	zh-HK
233177	233176	Apple	\N	en-GB
233178	233176	蘋果手機配件 	\N	zh-HK
233180	233179	Home	\N	en-GB
233181	233179	家居	\N	zh-HK
233183	233182	Floor	\N	en-GB
233184	233182	地板	\N	zh-HK
233186	233185	Carpets	\N	en-GB
233187	233185	地毯	\N	zh-HK
233189	233188	Cupboards	\N	en-GB
233190	233188	收納	\N	zh-HK
106	46	Shipping	\N	en-GB
107	46	船運	\N	zh-HK
\.


--
-- Data for Name: category_brand; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.category_brand (cat_id) FROM stdin;
45
\.


--
-- Data for Name: category_product; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.category_product (cat_id) FROM stdin;
43
39
38
40
42
8
16
36
15
4
23
20
25
26
13
22
21
5
11
3
14
17
19
37
12
10
18
9
24
6
2
7
44
233056
233059
233062
233065
233068
233071
233074
233077
233080
233083
233086
233089
233092
233095
233098
233101
233104
233107
233110
233113
233116
233119
233122
233125
233128
233131
233134
233137
233140
233143
233146
233149
233152
233155
233158
233161
233164
233167
233170
233173
233176
233179
233182
233185
233188
46
\.


--
-- Data for Name: category_promotion; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.category_promotion (cat_id, prm_id) FROM stdin;
10	234464
14	234467
\.


--
-- Data for Name: category_type; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.category_type (cat_typ_id, cat_typ_cd, cat_typ_desc) FROM stdin;
1	PRD01	product
2	BND01	brand
3	PRM01	promotion
4	LAY01	layout
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.currency (ccy_id, ccy_cd) FROM stdin;
1	HKD
2	USD
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.customer (rle_id, cst_num) FROM stdin;
1	1000000011
232217	1000000026
232221	1000000028
232231	1000000033
232233	1000000034
232235	1000000035
232237	1000000036
232239	1000000037
232241	1000000038
232243	1000000039
232245	1000000040
232247	1000000041
232249	1000000042
232251	1000000043
232253	1000000044
232255	1000000045
232257	1000000046
232259	1000000047
232261	1000000048
232263	1000000049
232305	1000000070
232311	1000000073
232313	1000000074
233017	1000000264
233019	1000000265
233021	1000000266
233023	1000000267
233025	1000000268
233055	1000000269
234478	1000000270
234483	1000000271
234486	6         
\.


--
-- Data for Name: department; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.department (dept_id, dept_cd) FROM stdin;
1	SHP01
2	ACC01
\.


--
-- Data for Name: department_attr_lcl; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.department_attr_lcl (dept_lcl_id, dept_id, dept_desc, lcl_cd) FROM stdin;
1	2	Jewellery	en-GB
2	2	首飾	zh-HK
3	1	Shipping	en-GB
4	1	船運	zh-HK
\.


--
-- Data for Name: discount; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.discount (dis_id, dis_cd, prm_id, dis_typ_id, dis_val) FROM stdin;
\.


--
-- Data for Name: discount_type; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.discount_type (dis_typ_id, dis_typ_desc) FROM stdin;
1	percentage
2	value
\.


--
-- Data for Name: inventory_location; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.inventory_location (inv_loc_id, inv_loc_cd, inv_loc_desc, inv_loc_act) FROM stdin;
1	LCK01	Lai Chi Kok Apartment	t
\.


--
-- Data for Name: inventory_transaction; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.inventory_transaction (inv_trx_id, inv_loc_id, inv_prd_id, inv_qty, inv_prc, inv_ccy_id, inv_trx_typ_id, inv_pty_id, inv_trx_dt) FROM stdin;
234238	1	11	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234240	1	21	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234242	1	23	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234244	1	25	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234246	1	26	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234248	1	28	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234250	1	30	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234252	1	17	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234254	1	16	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234256	1	14	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234258	1	15	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234260	1	19	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234262	1	20	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234264	1	22	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234266	1	24	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234268	1	27	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234270	1	29	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234272	1	18	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234274	1	233275	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234276	1	233282	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234278	1	233289	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234280	1	233296	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234282	1	233303	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234284	1	233310	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234286	1	233317	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234288	1	233324	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234290	1	233331	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234292	1	233338	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234294	1	233345	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234296	1	233352	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234298	1	233359	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234300	1	233366	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234302	1	233373	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234304	1	233380	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234306	1	233387	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234308	1	233394	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234310	1	233401	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234312	1	233408	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234314	1	233415	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234316	1	233422	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234318	1	233429	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234320	1	233436	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234322	1	233443	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234324	1	233450	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234326	1	233457	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234328	1	233464	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234330	1	233471	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234332	1	233478	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234334	1	233485	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234336	1	233492	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234338	1	233499	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234340	1	233506	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234342	1	233513	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234344	1	233520	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234346	1	233527	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234348	1	233534	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234350	1	233541	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234352	1	233548	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234354	1	233555	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234356	1	233562	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234358	1	233569	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234360	1	233576	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234362	1	233583	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234364	1	233590	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234366	1	233597	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234368	1	233604	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234370	1	233611	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234372	1	233618	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234374	1	233625	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234376	1	233632	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234378	1	233639	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234380	1	233646	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234382	1	233653	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234384	1	233660	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234386	1	233667	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234388	1	233674	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234390	1	233681	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234392	1	233688	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234394	1	233695	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234396	1	233702	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234398	1	233709	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234400	1	233716	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234402	1	233723	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234404	1	233730	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234406	1	13	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234408	1	4	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234410	1	7	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234412	1	9	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234414	1	12	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234416	1	1	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234418	1	10	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234420	1	8	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234422	1	6	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234424	1	2	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234426	1	3	10	2.59	2	1	233055	2020-10-04 00:00:00+08
234428	1	5	10	2.59	2	1	233055	2020-10-04 00:00:00+08
\.


--
-- Data for Name: inventory_transaction_type; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.inventory_transaction_type (inv_trx_typ_id, inv_trx_typ_cd) FROM stdin;
1	IN
2	OUT
\.


--
-- Data for Name: locale; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.locale (lcl_cd) FROM stdin;
af-ZA
am-ET
ar-AE
ar-BH
ar-DZ
ar-EG
ar-IQ
ar-JO
ar-KW
ar-LB
ar-LY
ar-MA
arn-CL
ar-OM
ar-QA
ar-SA
ar-SY
ar-TN
ar-YE
as-IN
az-Cyrl-AZ
az-Latn-AZ
ba-RU
be-BY
bg-BG
bn-BD
bn-IN
bo-CN
br-FR
bs-Cyrl-BA
bs-Latn-BA
ca-ES
co-FR
cs-CZ
cy-GB
da-DK
de-AT
de-CH
de-DE
de-LI
de-LU
dsb-DE
dv-MV
el-GR
en-029
en-AU
en-BZ
en-CA
en-GB
en-IE
en-IN
en-JM
en-MY
en-NZ
en-PH
en-SG
en-TT
en-US
en-ZA
en-ZW
es-AR
es-BO
es-CL
es-CO
es-CR
es-DO
es-EC
es-ES
es-GT
es-HN
es-MX
es-NI
es-PA
es-PE
es-PR
es-PY
es-SV
es-US
es-UY
es-VE
et-EE
eu-ES
fa-IR
fi-FI
fil-PH
fo-FO
fr-BE
fr-CA
fr-CH
fr-FR
fr-LU
fr-MC
fy-NL
ga-IE
gd-GB
gl-ES
gsw-FR
gu-IN
ha-Latn-NG
he-IL
hi-IN
hr-BA
hr-HR
hsb-DE
hu-HU
hy-AM
id-ID
ig-NG
ii-CN
is-IS
it-CH
it-IT
iu-Cans-CA
iu-Latn-CA
ja-JP
ka-GE
kk-KZ
kl-GL
km-KH
kn-IN
kok-IN
ko-KR
ky-KG
lb-LU
lo-LA
lt-LT
lv-LV
mi-NZ
mk-MK
ml-IN
mn-MN
mn-Mong-CN
moh-CA
mr-IN
ms-BN
ms-MY
mt-MT
nb-NO
ne-NP
nl-BE
nl-NL
nn-NO
nso-ZA
oc-FR
or-IN
pa-IN
pl-PL
prs-AF
ps-AF
pt-BR
pt-PT
qut-GT
quz-BO
quz-EC
quz-PE
rm-CH
ro-RO
ru-RU
rw-RW
sah-RU
sa-IN
se-FI
se-NO
se-SE
si-LK
sk-SK
sl-SI
sma-NO
sma-SE
smj-NO
smj-SE
smn-FI
sms-FI
sq-AL
sr-Cyrl-BA
sr-Cyrl-CS
sr-Cyrl-ME
sr-Cyrl-RS
sr-Latn-BA
sr-Latn-CS
sr-Latn-ME
sr-Latn-RS
sv-FI
sv-SE
sw-KE
syr-SY
ta-IN
te-IN
tg-Cyrl-TJ
th-TH
tk-TM
tn-ZA
tr-TR
tt-RU
tzm-Latn-DZ
ug-CN
uk-UA
ur-PK
uz-Cyrl-UZ
uz-Latn-UZ
vi-VN
wo-SN
xh-ZA
yo-NG
zh-CN
zh-HK
zh-MO
zh-SG
zh-TW
zu-ZA
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi."order" (ord_id, pty_id) FROM stdin;
\.


--
-- Data for Name: order_line; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.order_line (ord_id, prd_id, ord_lne_no, qty, prm_id, amt) FROM stdin;
\.


--
-- Data for Name: organisation; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.organisation (pty_id, org_nme, org_reg_no) FROM stdin;
233055	Taobao	NA
\.


--
-- Data for Name: party; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.party (pty_id, pty_typ_id) FROM stdin;
1	1
232216	1
232220	1
232230	1
232232	1
232234	1
232236	1
232238	1
232240	1
232242	1
232244	1
232246	1
232248	1
232250	1
232252	1
232254	1
232256	1
232258	1
232260	1
232262	1
232304	1
232310	1
232312	1
233016	1
233018	1
233020	1
233022	1
233024	1
233054	1
233055	2
234477	1
234482	1
234485	1
\.


--
-- Data for Name: party_type; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.party_type (pty_typ_id, pty_typ_desc) FROM stdin;
1	Person
2	Organisation
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.person (pty_id, psn_gvn_nm, psn_fml_nm, enb) FROM stdin;
1	Daniel	Mackie	t
232230	Will	Parkhouse	t
232232	Will	Parkhouse	t
232234	zoro	zoro	t
232236	j	j	t
232238	x	x	t
232240	z	z	t
232242	h	h	t
232244	i	i	t
232246	f	f	t
232248	Alexia	V	t
232250	marley	macculloch	t
232252	Layla	MacCulloch	t
232254	bill	bill	t
232256	dan	dan	t
232258	dan	dan	t
232260	nod	nod	t
232262	Daniel	Mackie	t
232304	Daniel	Mackie	t
232310	Daniel	Mackie	t
232312	Daniel	Mackie	t
232216	billy	wong	t
232220	purple	wong	t
233016	adam	apple	f
233018	barry	white	f
233020	will	parkhouse	f
233022	john	wayne	f
233024	bob	bob	f
233054	Daniel	Mackie	f
234477	rob	rob	f
234482	nob	nob	f
234485	Daniel	Mackie	f
\.


--
-- Data for Name: price; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.price (prc_id, prc_typ_id, prd_id, prc_val, ccy_id) FROM stdin;
1	1	1	75	1
2	1	2	75	1
3	1	3	120	1
4	1	4	60	1
5	1	5	48	1
6	1	6	32	1
7	1	7	56	1
8	1	8	16	1
9	1	9	82	1
10	1	10	35	1
11	1	11	60	1
12	1	12	60	1
13	1	13	22	1
14	1	14	48	1
15	1	15	75	1
16	1	16	16	1
17	1	17	72	1
18	1	18	45	1
19	1	19	60	1
20	1	20	36	1
21	1	21	69	1
22	1	22	95	1
23	1	23	160	1
24	1	24	180	1
25	1	25	28	1
26	1	26	200	1
27	1	27	190	1
28	1	28	950	1
29	1	29	650	1
30	1	30	170	1
41	1	11	7.7	2
71	2	11	6.93	2
91	2	1	67.50	1
92	2	2	67.50	1
93	2	3	108.00	1
94	2	4	54.00	1
95	2	5	43.20	1
96	2	6	28.80	1
97	2	7	50.40	1
98	2	8	14.40	1
99	2	9	73.80	1
100	2	10	31.50	1
101	2	11	54.00	1
102	2	12	54.00	1
103	2	13	19.80	1
104	2	14	43.20	1
105	2	15	67.50	1
106	2	16	14.40	1
107	2	17	64.80	1
108	2	18	40.50	1
109	2	19	54.00	1
110	2	20	32.40	1
111	2	21	62.10	1
112	2	22	85.50	1
113	2	23	144.00	1
114	2	24	162.00	1
115	2	25	25.20	1
116	2	26	180.00	1
117	2	27	171.00	1
118	2	28	855.00	1
119	2	29	585.00	1
120	2	30	153.00	1
233277	1	233275	6.4	2
233278	2	233275	6.4	2
233280	1	233275	50	1
233281	2	233275	50	1
233284	1	233282	6.4	2
233285	2	233282	6.4	2
233287	1	233282	50	1
233288	2	233282	50	1
233291	1	233289	3.8	2
233292	2	233289	3.8	2
233294	1	233289	30	1
233295	2	233289	30	1
233298	1	233296	2.6	2
233299	2	233296	2.6	2
233301	1	233296	20	1
233302	2	233296	20	1
233305	1	233303	2.6	2
233306	2	233303	2.6	2
233308	1	233303	20	1
233309	2	233303	20	1
233312	1	233310	10.3	2
233313	2	233310	10.3	2
233315	1	233310	80	1
233316	2	233310	80	1
233319	1	233317	3.2	2
233320	2	233317	3.2	2
233322	1	233317	25	1
233323	2	233317	25	1
233326	1	233324	5.1	2
233327	2	233324	5.1	2
233329	1	233324	40	1
233330	2	233324	40	1
233333	1	233331	5.1	2
233334	2	233331	5.1	2
233336	1	233331	40	1
233337	2	233331	40	1
233340	1	233338	3.8	2
233341	2	233338	3.8	2
233343	1	233338	30	1
233344	2	233338	30	1
233347	1	233345	5.1	2
233348	2	233345	5.1	2
233350	1	233345	40	1
233351	2	233345	40	1
233354	1	233352	3.2	2
233355	2	233352	3.2	2
233357	1	233352	25	1
233358	2	233352	25	1
233361	1	233359	5.1	2
233362	2	233359	5.1	2
233364	1	233359	40	1
233365	2	233359	40	1
233368	1	233366	2.6	2
233369	2	233366	2.6	2
233371	1	233366	20	1
233372	2	233366	20	1
233375	1	233373	2.6	2
233376	2	233373	2.6	2
233378	1	233373	20	1
233379	2	233373	20	1
233382	1	233380	5.1	2
233383	2	233380	5.1	2
233385	1	233380	40	1
233386	2	233380	40	1
233389	1	233387	5.8	2
233390	2	233387	5.8	2
233392	1	233387	45	1
233393	2	233387	45	1
233396	1	233394	0.6	2
233397	2	233394	0.6	2
233399	1	233394	5	1
233400	2	233394	5	1
233403	1	233401	1.3	2
233404	2	233401	1.3	2
233406	1	233401	10	1
233407	2	233401	10	1
233410	1	233408	3.8	2
233411	2	233408	3.8	2
233413	1	233408	30	1
233414	2	233408	30	1
233417	1	233415	3.8	2
233418	2	233415	3.8	2
233420	1	233415	30	1
233421	2	233415	30	1
233424	1	233422	3.8	2
233425	2	233422	3.8	2
233427	1	233422	30	1
233428	2	233422	30	1
233431	1	233429	6.4	2
233432	2	233429	6.4	2
233434	1	233429	50	1
233435	2	233429	50	1
233438	1	233436	5.1	2
233439	2	233436	5.1	2
233441	1	233436	40	1
233442	2	233436	40	1
233445	1	233443	4.5	2
233446	2	233443	4.5	2
233448	1	233443	35	1
233449	2	233443	35	1
233452	1	233450	10.3	2
233453	2	233450	10.3	2
233455	1	233450	80	1
233456	2	233450	80	1
233459	1	233457	7.7	2
233460	2	233457	7.7	2
233462	1	233457	60	1
233463	2	233457	60	1
233466	1	233464	12.8	2
233467	2	233464	12.8	2
233469	1	233464	100	1
233470	2	233464	100	1
233473	1	233471	7.7	2
233474	2	233471	7.7	2
233476	1	233471	60	1
233477	2	233471	60	1
233480	1	233478	7.7	2
233481	2	233478	7.7	2
233483	1	233478	60	1
233484	2	233478	60	1
233487	1	233485	10.3	2
233488	2	233485	10.3	2
233490	1	233485	80	1
233491	2	233485	80	1
233494	1	233492	10.3	2
233495	2	233492	10.3	2
233497	1	233492	80	1
233498	2	233492	80	1
233501	1	233499	12.8	2
233502	2	233499	12.8	2
233504	1	233499	100	1
233505	2	233499	100	1
233508	1	233506	6.4	2
233509	2	233506	6.4	2
233511	1	233506	50	1
233512	2	233506	50	1
233515	1	233513	6.4	2
233516	2	233513	6.4	2
233518	1	233513	50	1
233519	2	233513	50	1
233522	1	233520	6.4	2
233523	2	233520	6.4	2
233525	1	233520	50	1
233526	2	233520	50	1
233529	1	233527	6.4	2
233530	2	233527	6.4	2
233532	1	233527	50	1
233533	2	233527	50	1
233536	1	233534	3.8	2
233537	2	233534	3.8	2
233539	1	233534	30	1
233540	2	233534	30	1
233543	1	233541	1.5	2
233544	2	233541	1.5	2
233546	1	233541	12	1
233547	2	233541	12	1
233550	1	233548	1.5	2
233551	2	233548	1.5	2
233553	1	233548	12	1
233554	2	233548	12	1
233557	1	233555	1.5	2
233558	2	233555	1.5	2
233560	1	233555	12	1
233561	2	233555	12	1
233564	1	233562	1.3	2
233565	2	233562	1.3	2
233567	1	233562	10	1
233568	2	233562	10	1
233571	1	233569	1.3	2
233572	2	233569	1.3	2
233574	1	233569	10	1
233575	2	233569	10	1
233578	1	233576	6.4	2
233579	2	233576	6.4	2
233581	1	233576	50	1
233582	2	233576	50	1
233585	1	233583	12.8	2
233586	2	233583	12.8	2
233588	1	233583	100	1
233589	2	233583	100	1
233592	1	233590	12.8	2
233593	2	233590	12.8	2
233595	1	233590	100	1
233596	2	233590	100	1
233599	1	233597	6.4	2
233600	2	233597	6.4	2
233602	1	233597	50	1
233603	2	233597	50	1
233606	1	233604	10.3	2
233607	2	233604	10.3	2
233609	1	233604	80	1
233610	2	233604	80	1
233613	1	233611	6.4	2
233614	2	233611	6.4	2
233616	1	233611	50	1
233617	2	233611	50	1
233620	1	233618	3.8	2
233621	2	233618	3.8	2
233623	1	233618	30	1
233624	2	233618	30	1
233627	1	233625	3.2	2
233628	2	233625	3.2	2
233630	1	233625	25	1
233631	2	233625	25	1
233634	1	233632	3.8	2
233635	2	233632	3.8	2
233637	1	233632	30	1
233638	2	233632	30	1
233641	1	233639	5.1	2
233642	2	233639	5.1	2
233644	1	233639	40	1
233645	2	233639	40	1
233648	1	233646	3.8	2
233649	2	233646	3.8	2
233651	1	233646	30	1
233652	2	233646	30	1
233655	1	233653	3.8	2
233656	2	233653	3.8	2
233658	1	233653	30	1
233659	2	233653	30	1
233662	1	233660	6.4	2
233663	2	233660	6.4	2
233665	1	233660	50	1
233666	2	233660	50	1
233669	1	233667	6.4	2
233670	2	233667	6.4	2
233672	1	233667	50	1
233673	2	233667	50	1
233676	1	233674	10.3	2
233677	2	233674	10.3	2
233679	1	233674	80	1
233680	2	233674	80	1
233683	1	233681	10.3	2
233684	2	233681	10.3	2
233686	1	233681	80	1
233687	2	233681	80	1
233690	1	233688	10.3	2
233691	2	233688	10.3	2
233693	1	233688	80	1
233694	2	233688	80	1
233697	1	233695	3.8	2
233698	2	233695	3.8	2
233700	1	233695	30	1
233701	2	233695	30	1
233704	1	233702	7.7	2
233705	2	233702	7.7	2
233707	1	233702	60	1
233708	2	233702	60	1
233711	1	233709	10.3	2
233712	2	233709	12.8	2
233714	1	233709	80	1
233715	2	233709	100	1
233718	1	233716	3.8	2
233719	2	233716	5.1	2
233721	1	233716	30	1
233722	2	233716	40	1
233725	1	233723	6.4	2
233726	2	233723	7.7	2
233728	1	233723	50	1
233729	2	233723	60	1
233732	1	233730	10.3	2
233733	2	233730	12.8	2
233735	1	233730	80	1
233736	2	233730	100	1
56	1	26	25.6	2
58	1	28	121.8	2
43	1	13	2.8	2
34	1	4	7.7	2
37	1	7	7.2	2
39	1	9	10.5	2
60	1	30	21.8	2
50	1	20	4.6	2
51	1	21	8.8	2
42	1	12	7.7	2
49	1	19	7.7	2
59	1	29	83.3	2
48	1	18	5.8	2
31	1	1	9.6	2
46	1	16	2.1	2
47	1	17	9.2	2
40	1	10	4.5	2
45	1	15	9.6	2
38	1	8	2.1	2
52	1	22	12.2	2
44	1	14	6.2	2
36	1	6	4.1	2
53	1	23	20.5	2
54	1	24	23.1	2
57	1	27	24.4	2
32	1	2	9.6	2
33	1	3	15.4	2
35	1	5	6.2	2
55	1	25	3.6	2
74	2	14	5.5	2
80	2	20	4.2	2
77	2	17	8.3	2
67	2	7	6.5	2
72	2	12	6.9	2
89	2	29	75	2
90	2	30	19.6	2
88	2	28	109.6	2
62	2	2	8.7	2
75	2	15	8.7	2
70	2	10	4	2
87	2	27	21.9	2
81	2	21	8	2
86	2	26	23.1	2
84	2	24	20.8	2
85	2	25	3.2	2
76	2	16	1.8	2
66	2	6	3.7	2
82	2	22	11	2
83	2	23	18.5	2
63	2	3	13.8	2
69	2	9	9.5	2
64	2	4	6.9	2
73	2	13	2.5	2
78	2	18	5.2	2
79	2	19	6.9	2
68	2	8	1.8	2
61	2	1	8.7	2
65	2	5	5.5	2
2031800	1	2031066	1.28	2
2031801	2	2031066	1.28	2
2031802	1	2031066	10.0	1
2031803	2	2031066	10.0	1
2031804	1	2031067	1.28	2
2031805	2	2031067	1.28	2
2031806	1	2031067	10.0	1
2031807	2	2031067	10.0	1
2031808	1	2031068	2.31	2
2031809	2	2031068	2.31	2
2031810	1	2031068	18.0	1
2031811	2	2031068	18.0	1
2031812	1	2031069	2.31	2
2031813	2	2031069	2.31	2
2031814	1	2031069	18.0	1
2031815	2	2031069	18.0	1
2031816	1	2031070	2.31	2
2031817	2	2031070	2.31	2
2031818	1	2031070	18.0	1
2031819	2	2031070	18.0	1
2031820	1	2031071	2.95	2
2031821	2	2031071	2.95	2
2031822	1	2031071	23.0	1
2031823	2	2031071	23.0	1
2031824	1	2031072	2.95	2
2031825	2	2031072	2.95	2
2031826	1	2031072	23.0	1
2031827	2	2031072	23.0	1
2031828	1	2031073	3.59	2
2031829	2	2031073	3.59	2
2031830	1	2031073	28.0	1
2031831	2	2031073	28.0	1
2031832	1	2031074	3.59	2
2031833	2	2031074	3.59	2
2031834	1	2031074	28.0	1
2031835	2	2031074	28.0	1
2031836	1	2031075	3.59	2
2031837	2	2031075	3.59	2
2031838	1	2031075	28.0	1
2031839	2	2031075	28.0	1
2031840	1	2031076	4.23	2
2031841	2	2031076	4.23	2
2031842	1	2031076	33.0	1
2031843	2	2031076	33.0	1
2031844	1	2031077	4.23	2
2031845	2	2031077	4.23	2
2031846	1	2031077	33.0	1
2031847	2	2031077	33.0	1
2031848	1	2031078	4.87	2
2031849	2	2031078	4.87	2
2031850	1	2031078	38.0	1
2031851	2	2031078	38.0	1
2031852	1	2031079	4.87	2
2031853	2	2031079	4.87	2
2031854	1	2031079	38.0	1
2031855	2	2031079	38.0	1
2031856	1	2031080	4.87	2
2031857	2	2031080	4.87	2
2031858	1	2031080	38.0	1
2031859	2	2031080	38.0	1
2031860	1	2031081	5.51	2
2031861	2	2031081	5.51	2
2031862	1	2031081	43.0	1
2031863	2	2031081	43.0	1
2031864	1	2031082	5.51	2
2031865	2	2031082	5.51	2
2031866	1	2031082	43.0	1
2031867	2	2031082	43.0	1
2031868	1	2031083	6.15	2
2031869	2	2031083	6.15	2
2031870	1	2031083	48.0	1
2031871	2	2031083	48.0	1
2031872	1	2031084	6.15	2
2031873	2	2031084	6.15	2
2031874	1	2031084	48.0	1
2031875	2	2031084	48.0	1
2031876	1	2031085	6.15	2
2031877	2	2031085	6.15	2
2031878	1	2031085	48.0	1
2031879	2	2031085	48.0	1
2031880	1	2031086	6.79	2
2031881	2	2031086	6.79	2
2031882	1	2031086	53.0	1
2031883	2	2031086	53.0	1
2031884	1	2031087	6.79	2
2031885	2	2031087	6.79	2
2031886	1	2031087	53.0	1
2031887	2	2031087	53.0	1
2031888	1	2031088	7.44	2
2031889	2	2031088	7.44	2
2031890	1	2031088	58.0	1
2031891	2	2031088	58.0	1
2031892	1	2031089	7.44	2
2031893	2	2031089	7.44	2
2031894	1	2031089	58.0	1
2031895	2	2031089	58.0	1
2031896	1	2031090	7.44	2
2031897	2	2031090	7.44	2
2031898	1	2031090	58.0	1
2031899	2	2031090	58.0	1
2031900	1	2031091	8.08	2
2031901	2	2031091	8.08	2
2031902	1	2031091	63.0	1
2031903	2	2031091	63.0	1
2031904	1	2031092	8.08	2
2031905	2	2031092	8.08	2
2031906	1	2031092	63.0	1
2031907	2	2031092	63.0	1
2031908	1	2031093	8.72	2
2031909	2	2031093	8.72	2
2031910	1	2031093	68.0	1
2031911	2	2031093	68.0	1
2031912	1	2031094	8.72	2
2031913	2	2031094	8.72	2
2031914	1	2031094	68.0	1
2031915	2	2031094	68.0	1
2031916	1	2031095	8.72	2
2031917	2	2031095	8.72	2
2031918	1	2031095	68.0	1
2031919	2	2031095	68.0	1
2031920	1	2031096	9.36	2
2031921	2	2031096	9.36	2
2031922	1	2031096	73.0	1
2031923	2	2031096	73.0	1
2031924	1	2031097	9.36	2
2031925	2	2031097	9.36	2
2031926	1	2031097	73.0	1
2031927	2	2031097	73.0	1
2031928	1	2031098	10.00	2
2031929	2	2031098	10.00	2
2031930	1	2031098	78.0	1
2031931	2	2031098	78.0	1
2031932	1	2031099	10.00	2
2031933	2	2031099	10.00	2
2031934	1	2031099	78.0	1
2031935	2	2031099	78.0	1
2031936	1	2031100	10.00	2
2031937	2	2031100	10.00	2
2031938	1	2031100	78.0	1
2031939	2	2031100	78.0	1
2031940	1	2031101	10.64	2
2031941	2	2031101	10.64	2
2031942	1	2031101	83.0	1
2031943	2	2031101	83.0	1
2031944	1	2031102	10.64	2
2031945	2	2031102	10.64	2
2031946	1	2031102	83.0	1
2031947	2	2031102	83.0	1
2031948	1	2031103	11.28	2
2031949	2	2031103	11.28	2
2031950	1	2031103	88.0	1
2031951	2	2031103	88.0	1
2031952	1	2031104	11.28	2
2031953	2	2031104	11.28	2
2031954	1	2031104	88.0	1
2031955	2	2031104	88.0	1
2031956	1	2031105	11.28	2
2031957	2	2031105	11.28	2
2031958	1	2031105	88.0	1
2031959	2	2031105	88.0	1
2031960	1	2031106	11.92	2
2031961	2	2031106	11.92	2
2031962	1	2031106	93.0	1
2031963	2	2031106	93.0	1
2031964	1	2031107	11.92	2
2031965	2	2031107	11.92	2
2031966	1	2031107	93.0	1
2031967	2	2031107	93.0	1
2031968	1	2031108	12.56	2
2031969	2	2031108	12.56	2
2031970	1	2031108	98.0	1
2031971	2	2031108	98.0	1
2031972	1	2031109	12.56	2
2031973	2	2031109	12.56	2
2031974	1	2031109	98.0	1
2031975	2	2031109	98.0	1
2031976	1	2031110	12.56	2
2031977	2	2031110	12.56	2
2031978	1	2031110	98.0	1
2031979	2	2031110	98.0	1
2031980	1	2031111	13.21	2
2031981	2	2031111	13.21	2
2031982	1	2031111	103.0	1
2031983	2	2031111	103.0	1
2031984	1	2031112	13.21	2
2031985	2	2031112	13.21	2
2031986	1	2031112	103.0	1
2031987	2	2031112	103.0	1
2031988	1	2031113	13.85	2
2031989	2	2031113	13.85	2
2031990	1	2031113	108.0	1
2031991	2	2031113	108.0	1
2031992	1	2031114	13.85	2
2031993	2	2031114	13.85	2
2031994	1	2031114	108.0	1
2031995	2	2031114	108.0	1
2031996	1	2031115	13.85	2
2031997	2	2031115	13.85	2
2031998	1	2031115	108.0	1
2031999	2	2031115	108.0	1
2032000	1	2031116	14.49	2
2032001	2	2031116	14.49	2
2032002	1	2031116	113.0	1
2032003	2	2031116	113.0	1
2032004	1	2031117	14.49	2
2032005	2	2031117	14.49	2
2032006	1	2031117	113.0	1
2032007	2	2031117	113.0	1
2032008	1	2031118	15.13	2
2032009	2	2031118	15.13	2
2032010	1	2031118	118.0	1
2032011	2	2031118	118.0	1
2032012	1	2031119	15.13	2
2032013	2	2031119	15.13	2
2032014	1	2031119	118.0	1
2032015	2	2031119	118.0	1
2032016	1	2031120	15.13	2
2032017	2	2031120	15.13	2
2032018	1	2031120	118.0	1
2032019	2	2031120	118.0	1
2032020	1	2031121	15.77	2
2032021	2	2031121	15.77	2
2032022	1	2031121	123.0	1
2032023	2	2031121	123.0	1
2032024	1	2031122	15.77	2
2032025	2	2031122	15.77	2
2032026	1	2031122	123.0	1
2032027	2	2031122	123.0	1
2032028	1	2031123	16.41	2
2032029	2	2031123	16.41	2
2032030	1	2031123	128.0	1
2032031	2	2031123	128.0	1
2032032	1	2031124	16.41	2
2032033	2	2031124	16.41	2
2032034	1	2031124	128.0	1
2032035	2	2031124	128.0	1
2032036	1	2031125	16.41	2
2032037	2	2031125	16.41	2
2032038	1	2031125	128.0	1
2032039	2	2031125	128.0	1
2032040	1	2031126	17.05	2
2032041	2	2031126	17.05	2
2032042	1	2031126	133.0	1
2032043	2	2031126	133.0	1
2032044	1	2031127	17.05	2
2032045	2	2031127	17.05	2
2032046	1	2031127	133.0	1
2032047	2	2031127	133.0	1
2032048	1	2031128	17.69	2
2032049	2	2031128	17.69	2
2032050	1	2031128	138.0	1
2032051	2	2031128	138.0	1
2032052	1	2031129	17.69	2
2032053	2	2031129	17.69	2
2032054	1	2031129	138.0	1
2032055	2	2031129	138.0	1
2032056	1	2031130	17.69	2
2032057	2	2031130	17.69	2
2032058	1	2031130	138.0	1
2032059	2	2031130	138.0	1
2032060	1	2031131	18.33	2
2032061	2	2031131	18.33	2
2032062	1	2031131	143.0	1
2032063	2	2031131	143.0	1
2032064	1	2031132	18.33	2
2032065	2	2031132	18.33	2
2032066	1	2031132	143.0	1
2032067	2	2031132	143.0	1
2032068	1	2031133	18.97	2
2032069	2	2031133	18.97	2
2032070	1	2031133	148.0	1
2032071	2	2031133	148.0	1
2032072	1	2031134	18.97	2
2032073	2	2031134	18.97	2
2032074	1	2031134	148.0	1
2032075	2	2031134	148.0	1
2032076	1	2031135	18.97	2
2032077	2	2031135	18.97	2
2032078	1	2031135	148.0	1
2032079	2	2031135	148.0	1
2032080	1	2031136	19.62	2
2032081	2	2031136	19.62	2
2032082	1	2031136	153.0	1
2032083	2	2031136	153.0	1
2032084	1	2031137	19.62	2
2032085	2	2031137	19.62	2
2032086	1	2031137	153.0	1
2032087	2	2031137	153.0	1
2032088	1	2031138	20.26	2
2032089	2	2031138	20.26	2
2032090	1	2031138	158.0	1
2032091	2	2031138	158.0	1
2032092	1	2031139	20.26	2
2032093	2	2031139	20.26	2
2032094	1	2031139	158.0	1
2032095	2	2031139	158.0	1
2032096	1	2031140	20.26	2
2032097	2	2031140	20.26	2
2032098	1	2031140	158.0	1
2032099	2	2031140	158.0	1
2032100	1	2031141	20.90	2
2032101	2	2031141	20.90	2
2032102	1	2031141	163.0	1
2032103	2	2031141	163.0	1
2032104	1	2031142	20.90	2
2032105	2	2031142	20.90	2
2032106	1	2031142	163.0	1
2032107	2	2031142	163.0	1
2032108	1	2031143	21.54	2
2032109	2	2031143	21.54	2
2032110	1	2031143	168.0	1
2032111	2	2031143	168.0	1
2032112	1	2031144	21.54	2
2032113	2	2031144	21.54	2
2032114	1	2031144	168.0	1
2032115	2	2031144	168.0	1
2032116	1	2031145	21.54	2
2032117	2	2031145	21.54	2
2032118	1	2031145	168.0	1
2032119	2	2031145	168.0	1
2032120	1	2031146	22.18	2
2032121	2	2031146	22.18	2
2032122	1	2031146	173.0	1
2032123	2	2031146	173.0	1
2032124	1	2031147	22.18	2
2032125	2	2031147	22.18	2
2032126	1	2031147	173.0	1
2032127	2	2031147	173.0	1
2032128	1	2031148	22.82	2
2032129	2	2031148	22.82	2
2032130	1	2031148	178.0	1
2032131	2	2031148	178.0	1
2032132	1	2031149	22.82	2
2032133	2	2031149	22.82	2
2032134	1	2031149	178.0	1
2032135	2	2031149	178.0	1
2032136	1	2031150	22.82	2
2032137	2	2031150	22.82	2
2032138	1	2031150	178.0	1
2032139	2	2031150	178.0	1
2032140	1	2031151	23.46	2
2032141	2	2031151	23.46	2
2032142	1	2031151	183.0	1
2032143	2	2031151	183.0	1
2032144	1	2031152	23.46	2
2032145	2	2031152	23.46	2
2032146	1	2031152	183.0	1
2032147	2	2031152	183.0	1
2032148	1	2031153	24.10	2
2032149	2	2031153	24.10	2
2032150	1	2031153	188.0	1
2032151	2	2031153	188.0	1
2032152	1	2031154	24.10	2
2032153	2	2031154	24.10	2
2032154	1	2031154	188.0	1
2032155	2	2031154	188.0	1
2032156	1	2031155	24.10	2
2032157	2	2031155	24.10	2
2032158	1	2031155	188.0	1
2032159	2	2031155	188.0	1
2032160	1	2031156	24.74	2
2032161	2	2031156	24.74	2
2032162	1	2031156	193.0	1
2032163	2	2031156	193.0	1
2032164	1	2031157	24.74	2
2032165	2	2031157	24.74	2
2032166	1	2031157	193.0	1
2032167	2	2031157	193.0	1
2032168	1	2031158	25.38	2
2032169	2	2031158	25.38	2
2032170	1	2031158	198.0	1
2032171	2	2031158	198.0	1
2032172	1	2031159	25.38	2
2032173	2	2031159	25.38	2
2032174	1	2031159	198.0	1
2032175	2	2031159	198.0	1
2032176	1	2031160	25.38	2
2032177	2	2031160	25.38	2
2032178	1	2031160	198.0	1
2032179	2	2031160	198.0	1
2032180	1	2031161	26.03	2
2032181	2	2031161	26.03	2
2032182	1	2031161	203.0	1
2032183	2	2031161	203.0	1
2032184	1	2031162	26.03	2
2032185	2	2031162	26.03	2
2032186	1	2031162	203.0	1
2032187	2	2031162	203.0	1
2032188	1	2031163	26.67	2
2032189	2	2031163	26.67	2
2032190	1	2031163	208.0	1
2032191	2	2031163	208.0	1
2032192	1	2031164	26.67	2
2032193	2	2031164	26.67	2
2032194	1	2031164	208.0	1
2032195	2	2031164	208.0	1
2032196	1	2031165	26.67	2
2032197	2	2031165	26.67	2
2032198	1	2031165	208.0	1
2032199	2	2031165	208.0	1
2032200	1	2031166	4.10	2
2032201	2	2031166	4.10	2
2032202	1	2031166	32.0	1
2032203	2	2031166	32.0	1
2032204	1	2031167	4.10	2
2032205	2	2031167	4.10	2
2032206	1	2031167	32.0	1
2032207	2	2031167	32.0	1
2032208	1	2031168	5.77	2
2032209	2	2031168	5.77	2
2032210	1	2031168	45.0	1
2032211	2	2031168	45.0	1
2032212	1	2031169	5.77	2
2032213	2	2031169	5.77	2
2032214	1	2031169	45.0	1
2032215	2	2031169	45.0	1
2032216	1	2031170	5.77	2
2032217	2	2031170	5.77	2
2032218	1	2031170	45.0	1
2032219	2	2031170	45.0	1
2032220	1	2031171	7.31	2
2032221	2	2031171	7.31	2
2032222	1	2031171	57.0	1
2032223	2	2031171	57.0	1
2032224	1	2031172	7.31	2
2032225	2	2031172	7.31	2
2032226	1	2031172	57.0	1
2032227	2	2031172	57.0	1
2032228	1	2031173	7.31	2
2032229	2	2031173	7.31	2
2032230	1	2031173	57.0	1
2032231	2	2031173	57.0	1
2032232	1	2031174	7.31	2
2032233	2	2031174	7.31	2
2032234	1	2031174	57.0	1
2032235	2	2031174	57.0	1
2032236	1	2031175	7.31	2
2032237	2	2031175	7.31	2
2032238	1	2031175	57.0	1
2032239	2	2031175	57.0	1
2032240	1	2031176	8.97	2
2032241	2	2031176	8.97	2
2032242	1	2031176	70.0	1
2032243	2	2031176	70.0	1
2032244	1	2031177	8.97	2
2032245	2	2031177	8.97	2
2032246	1	2031177	70.0	1
2032247	2	2031177	70.0	1
2032248	1	2031178	8.97	2
2032249	2	2031178	8.97	2
2032250	1	2031178	70.0	1
2032251	2	2031178	70.0	1
2032252	1	2031179	8.97	2
2032253	2	2031179	8.97	2
2032254	1	2031179	70.0	1
2032255	2	2031179	70.0	1
2032256	1	2031180	8.97	2
2032257	2	2031180	8.97	2
2032258	1	2031180	70.0	1
2032259	2	2031180	70.0	1
2032260	1	2031181	8.97	2
2032261	2	2031181	8.97	2
2032262	1	2031181	70.0	1
2032263	2	2031181	70.0	1
2032264	1	2031182	8.97	2
2032265	2	2031182	8.97	2
2032266	1	2031182	70.0	1
2032267	2	2031182	70.0	1
2032268	1	2031183	8.97	2
2032269	2	2031183	8.97	2
2032270	1	2031183	70.0	1
2032271	2	2031183	70.0	1
2032272	1	2031184	8.97	2
2032273	2	2031184	8.97	2
2032274	1	2031184	70.0	1
2032275	2	2031184	70.0	1
2032276	1	2031185	8.97	2
2032277	2	2031185	8.97	2
2032278	1	2031185	70.0	1
2032279	2	2031185	70.0	1
2032280	1	2031186	8.97	2
2032281	2	2031186	8.97	2
2032282	1	2031186	70.0	1
2032283	2	2031186	70.0	1
2032284	1	2031187	8.97	2
2032285	2	2031187	8.97	2
2032286	1	2031187	70.0	1
2032287	2	2031187	70.0	1
2032288	1	2031188	8.97	2
2032289	2	2031188	8.97	2
2032290	1	2031188	70.0	1
2032291	2	2031188	70.0	1
2032292	1	2031189	8.97	2
2032293	2	2031189	8.97	2
2032294	1	2031189	70.0	1
2032295	2	2031189	70.0	1
2032296	1	2031190	8.97	2
2032297	2	2031190	8.97	2
2032298	1	2031190	70.0	1
2032299	2	2031190	70.0	1
2032300	1	2031191	10.90	2
2032301	2	2031191	10.90	2
2032302	1	2031191	85.0	1
2032303	2	2031191	85.0	1
2032304	1	2031192	10.90	2
2032305	2	2031192	10.90	2
2032306	1	2031192	85.0	1
2032307	2	2031192	85.0	1
2032308	1	2031193	10.90	2
2032309	2	2031193	10.90	2
2032310	1	2031193	85.0	1
2032311	2	2031193	85.0	1
2032312	1	2031194	10.90	2
2032313	2	2031194	10.90	2
2032314	1	2031194	85.0	1
2032315	2	2031194	85.0	1
2032316	1	2031195	10.90	2
2032317	2	2031195	10.90	2
2032318	1	2031195	85.0	1
2032319	2	2031195	85.0	1
2032320	1	2031196	12.82	2
2032321	2	2031196	12.82	2
2032322	1	2031196	100.0	1
2032323	2	2031196	100.0	1
2032324	1	2031197	12.82	2
2032325	2	2031197	12.82	2
2032326	1	2031197	100.0	1
2032327	2	2031197	100.0	1
2032328	1	2031198	12.82	2
2032329	2	2031198	12.82	2
2032330	1	2031198	100.0	1
2032331	2	2031198	100.0	1
2032332	1	2031199	12.82	2
2032333	2	2031199	12.82	2
2032334	1	2031199	100.0	1
2032335	2	2031199	100.0	1
2032336	1	2031200	12.82	2
2032337	2	2031200	12.82	2
2032338	1	2031200	100.0	1
2032339	2	2031200	100.0	1
2032340	1	2031201	15.38	2
2032341	2	2031201	15.38	2
2032342	1	2031201	120.0	1
2032343	2	2031201	120.0	1
2032344	1	2031202	15.38	2
2032345	2	2031202	15.38	2
2032346	1	2031202	120.0	1
2032347	2	2031202	120.0	1
2032348	1	2031203	15.38	2
2032349	2	2031203	15.38	2
2032350	1	2031203	120.0	1
2032351	2	2031203	120.0	1
2032352	1	2031204	15.38	2
2032353	2	2031204	15.38	2
2032354	1	2031204	120.0	1
2032355	2	2031204	120.0	1
2032356	1	2031205	15.38	2
2032357	2	2031205	15.38	2
2032358	1	2031205	120.0	1
2032359	2	2031205	120.0	1
2032360	1	2031206	17.95	2
2032361	2	2031206	17.95	2
2032362	1	2031206	140.0	1
2032363	2	2031206	140.0	1
2032364	1	2031207	17.95	2
2032365	2	2031207	17.95	2
2032366	1	2031207	140.0	1
2032367	2	2031207	140.0	1
2032368	1	2031208	17.95	2
2032369	2	2031208	17.95	2
2032370	1	2031208	140.0	1
2032371	2	2031208	140.0	1
2032372	1	2031209	17.95	2
2032373	2	2031209	17.95	2
2032374	1	2031209	140.0	1
2032375	2	2031209	140.0	1
2032376	1	2031210	17.95	2
2032377	2	2031210	17.95	2
2032378	1	2031210	140.0	1
2032379	2	2031210	140.0	1
2032380	1	2031211	19.87	2
2032381	2	2031211	19.87	2
2032382	1	2031211	155.0	1
2032383	2	2031211	155.0	1
2032384	1	2031212	19.87	2
2032385	2	2031212	19.87	2
2032386	1	2031212	155.0	1
2032387	2	2031212	155.0	1
2032388	1	2031213	19.87	2
2032389	2	2031213	19.87	2
2032390	1	2031213	155.0	1
2032391	2	2031213	155.0	1
2032392	1	2031214	19.87	2
2032393	2	2031214	19.87	2
2032394	1	2031214	155.0	1
2032395	2	2031214	155.0	1
2032396	1	2031215	19.87	2
2032397	2	2031215	19.87	2
2032398	1	2031215	155.0	1
2032399	2	2031215	155.0	1
2032400	1	2031216	21.15	2
2032401	2	2031216	21.15	2
2032402	1	2031216	165.0	1
2032403	2	2031216	165.0	1
2032404	1	2031217	21.15	2
2032405	2	2031217	21.15	2
2032406	1	2031217	165.0	1
2032407	2	2031217	165.0	1
2032408	1	2031218	21.15	2
2032409	2	2031218	21.15	2
2032410	1	2031218	165.0	1
2032411	2	2031218	165.0	1
2032412	1	2031219	21.15	2
2032413	2	2031219	21.15	2
2032414	1	2031219	165.0	1
2032415	2	2031219	165.0	1
2032416	1	2031220	21.15	2
2032417	2	2031220	21.15	2
2032418	1	2031220	165.0	1
2032419	2	2031220	165.0	1
2032420	1	2031221	22.44	2
2032421	2	2031221	22.44	2
2032422	1	2031221	175.0	1
2032423	2	2031221	175.0	1
2032424	1	2031222	22.44	2
2032425	2	2031222	22.44	2
2032426	1	2031222	175.0	1
2032427	2	2031222	175.0	1
2032428	1	2031223	22.44	2
2032429	2	2031223	22.44	2
2032430	1	2031223	175.0	1
2032431	2	2031223	175.0	1
2032432	1	2031224	22.44	2
2032433	2	2031224	22.44	2
2032434	1	2031224	175.0	1
2032435	2	2031224	175.0	1
2032436	1	2031225	22.44	2
2032437	2	2031225	22.44	2
2032438	1	2031225	175.0	1
2032439	2	2031225	175.0	1
2032440	1	2031226	22.44	2
2032441	2	2031226	22.44	2
2032442	1	2031226	175.0	1
2032443	2	2031226	175.0	1
2032444	1	2031227	22.44	2
2032445	2	2031227	22.44	2
2032446	1	2031227	175.0	1
2032447	2	2031227	175.0	1
2032448	1	2031228	22.44	2
2032449	2	2031228	22.44	2
2032450	1	2031228	175.0	1
2032451	2	2031228	175.0	1
2032452	1	2031229	22.44	2
2032453	2	2031229	22.44	2
2032454	1	2031229	175.0	1
2032455	2	2031229	175.0	1
2032456	1	2031230	22.44	2
2032457	2	2031230	22.44	2
2032458	1	2031230	175.0	1
2032459	2	2031230	175.0	1
2032460	1	2031231	23.08	2
2032461	2	2031231	23.08	2
2032462	1	2031231	180.0	1
2032463	2	2031231	180.0	1
2032464	1	2031232	23.08	2
2032465	2	2031232	23.08	2
2032466	1	2031232	180.0	1
2032467	2	2031232	180.0	1
2032468	1	2031233	23.08	2
2032469	2	2031233	23.08	2
2032470	1	2031233	180.0	1
2032471	2	2031233	180.0	1
2032472	1	2031234	23.08	2
2032473	2	2031234	23.08	2
2032474	1	2031234	180.0	1
2032475	2	2031234	180.0	1
2032476	1	2031235	23.08	2
2032477	2	2031235	23.08	2
2032478	1	2031235	180.0	1
2032479	2	2031235	180.0	1
2032480	1	2031236	23.08	2
2032481	2	2031236	23.08	2
2032482	1	2031236	180.0	1
2032483	2	2031236	180.0	1
2032484	1	2031237	23.08	2
2032485	2	2031237	23.08	2
2032486	1	2031237	180.0	1
2032487	2	2031237	180.0	1
2032488	1	2031238	23.08	2
2032489	2	2031238	23.08	2
2032490	1	2031238	180.0	1
2032491	2	2031238	180.0	1
2032492	1	2031239	23.08	2
2032493	2	2031239	23.08	2
2032494	1	2031239	180.0	1
2032495	2	2031239	180.0	1
2032496	1	2031240	23.08	2
2032497	2	2031240	23.08	2
2032498	1	2031240	180.0	1
2032499	2	2031240	180.0	1
2032500	1	2031241	26.92	2
2032501	2	2031241	26.92	2
2032502	1	2031241	210.0	1
2032503	2	2031241	210.0	1
2032504	1	2031242	26.92	2
2032505	2	2031242	26.92	2
2032506	1	2031242	210.0	1
2032507	2	2031242	210.0	1
2032508	1	2031243	26.92	2
2032509	2	2031243	26.92	2
2032510	1	2031243	210.0	1
2032511	2	2031243	210.0	1
2032512	1	2031244	26.92	2
2032513	2	2031244	26.92	2
2032514	1	2031244	210.0	1
2032515	2	2031244	210.0	1
2032516	1	2031245	26.92	2
2032517	2	2031245	26.92	2
2032518	1	2031245	210.0	1
2032519	2	2031245	210.0	1
2032520	1	2031246	26.92	2
2032521	2	2031246	26.92	2
2032522	1	2031246	210.0	1
2032523	2	2031246	210.0	1
2032524	1	2031247	26.92	2
2032525	2	2031247	26.92	2
2032526	1	2031247	210.0	1
2032527	2	2031247	210.0	1
2032528	1	2031248	26.92	2
2032529	2	2031248	26.92	2
2032530	1	2031248	210.0	1
2032531	2	2031248	210.0	1
2032532	1	2031249	26.92	2
2032533	2	2031249	26.92	2
2032534	1	2031249	210.0	1
2032535	2	2031249	210.0	1
2032536	1	2031250	26.92	2
2032537	2	2031250	26.92	2
2032538	1	2031250	210.0	1
2032539	2	2031250	210.0	1
2032540	1	2031251	26.92	2
2032541	2	2031251	26.92	2
2032542	1	2031251	210.0	1
2032543	2	2031251	210.0	1
2032544	1	2031252	26.92	2
2032545	2	2031252	26.92	2
2032546	1	2031252	210.0	1
2032547	2	2031252	210.0	1
2032548	1	2031253	26.92	2
2032549	2	2031253	26.92	2
2032550	1	2031253	210.0	1
2032551	2	2031253	210.0	1
2032552	1	2031254	26.92	2
2032553	2	2031254	26.92	2
2032554	1	2031254	210.0	1
2032555	2	2031254	210.0	1
2032556	1	2031255	26.92	2
2032557	2	2031255	26.92	2
2032558	1	2031255	210.0	1
2032559	2	2031255	210.0	1
2032560	1	2031256	29.49	2
2032561	2	2031256	29.49	2
2032562	1	2031256	230.0	1
2032563	2	2031256	230.0	1
2032564	1	2031257	29.49	2
2032565	2	2031257	29.49	2
2032566	1	2031257	230.0	1
2032567	2	2031257	230.0	1
2032568	1	2031258	29.49	2
2032569	2	2031258	29.49	2
2032570	1	2031258	230.0	1
2032571	2	2031258	230.0	1
2032572	1	2031259	29.49	2
2032573	2	2031259	29.49	2
2032574	1	2031259	230.0	1
2032575	2	2031259	230.0	1
2032576	1	2031260	29.49	2
2032577	2	2031260	29.49	2
2032578	1	2031260	230.0	1
2032579	2	2031260	230.0	1
2032580	1	2031261	29.49	2
2032581	2	2031261	29.49	2
2032582	1	2031261	230.0	1
2032583	2	2031261	230.0	1
2032584	1	2031262	29.49	2
2032585	2	2031262	29.49	2
2032586	1	2031262	230.0	1
2032587	2	2031262	230.0	1
2032588	1	2031263	29.49	2
2032589	2	2031263	29.49	2
2032590	1	2031263	230.0	1
2032591	2	2031263	230.0	1
2032592	1	2031264	29.49	2
2032593	2	2031264	29.49	2
2032594	1	2031264	230.0	1
2032595	2	2031264	230.0	1
2032596	1	2031265	29.49	2
2032597	2	2031265	29.49	2
2032598	1	2031265	230.0	1
2032599	2	2031265	230.0	1
2032600	1	2031266	29.49	2
2032601	2	2031266	29.49	2
2032602	1	2031266	230.0	1
2032603	2	2031266	230.0	1
2032604	1	2031267	29.49	2
2032605	2	2031267	29.49	2
2032606	1	2031267	230.0	1
2032607	2	2031267	230.0	1
2032608	1	2031268	29.49	2
2032609	2	2031268	29.49	2
2032610	1	2031268	230.0	1
2032611	2	2031268	230.0	1
2032612	1	2031269	29.49	2
2032613	2	2031269	29.49	2
2032614	1	2031269	230.0	1
2032615	2	2031269	230.0	1
2032616	1	2031270	29.49	2
2032617	2	2031270	29.49	2
2032618	1	2031270	230.0	1
2032619	2	2031270	230.0	1
2032620	1	2031271	29.49	2
2032621	2	2031271	29.49	2
2032622	1	2031271	230.0	1
2032623	2	2031271	230.0	1
2032624	1	2031272	29.49	2
2032625	2	2031272	29.49	2
2032626	1	2031272	230.0	1
2032627	2	2031272	230.0	1
2032628	1	2031273	29.49	2
2032629	2	2031273	29.49	2
2032630	1	2031273	230.0	1
2032631	2	2031273	230.0	1
2032632	1	2031274	29.49	2
2032633	2	2031274	29.49	2
2032634	1	2031274	230.0	1
2032635	2	2031274	230.0	1
2032636	1	2031275	29.49	2
2032637	2	2031275	29.49	2
2032638	1	2031275	230.0	1
2032639	2	2031275	230.0	1
2032644	1	2031277	54.36	2
2032645	2	2031277	54.36	2
2032646	1	2031277	424.0	1
2032647	2	2031277	424.0	1
2032648	1	2031278	54.36	2
2032649	2	2031278	54.36	2
2032650	1	2031278	424.0	1
2032651	2	2031278	424.0	1
2032652	1	2031279	54.36	2
2032653	2	2031279	54.36	2
2032654	1	2031279	424.0	1
2032655	2	2031279	424.0	1
2032656	1	2031280	54.36	2
2032657	2	2031280	54.36	2
2032658	1	2031280	424.0	1
2032659	2	2031280	424.0	1
2032660	1	2031281	54.36	2
2032661	2	2031281	54.36	2
2032662	1	2031281	424.0	1
2032663	2	2031281	424.0	1
2032664	1	2031282	66.28	2
2032665	2	2031282	66.28	2
2032666	1	2031282	517.0	1
2032667	2	2031282	517.0	1
2032668	1	2031283	66.28	2
2032669	2	2031283	66.28	2
2032670	1	2031283	517.0	1
2032671	2	2031283	517.0	1
2032672	1	2031284	78.21	2
2032673	2	2031284	78.21	2
2032674	1	2031284	610.0	1
2032675	2	2031284	610.0	1
2032676	1	2031285	78.21	2
2032677	2	2031285	78.21	2
2032678	1	2031285	610.0	1
2032679	2	2031285	610.0	1
2032680	1	2031286	78.21	2
2032681	2	2031286	78.21	2
2032682	1	2031286	610.0	1
2032683	2	2031286	610.0	1
2032684	1	2031287	90.13	2
2032685	2	2031287	90.13	2
2032686	1	2031287	703.0	1
2032687	2	2031287	703.0	1
2032688	1	2031288	90.13	2
2032689	2	2031288	90.13	2
2032690	1	2031288	703.0	1
2032691	2	2031288	703.0	1
2032692	1	2031289	102.05	2
2032693	2	2031289	102.05	2
2032694	1	2031289	796.0	1
2032695	2	2031289	796.0	1
2032696	1	2031290	102.05	2
2032697	2	2031290	102.05	2
2032698	1	2031290	796.0	1
2032699	2	2031290	796.0	1
2032700	1	2031291	102.05	2
2032701	2	2031291	102.05	2
2032702	1	2031291	796.0	1
2032703	2	2031291	796.0	1
2032704	1	2031292	113.97	2
2032705	2	2031292	113.97	2
2032706	1	2031292	889.0	1
2032707	2	2031292	889.0	1
2032708	1	2031293	113.97	2
2032709	2	2031293	113.97	2
2032710	1	2031293	889.0	1
2032711	2	2031293	889.0	1
2032712	1	2031294	125.90	2
2032713	2	2031294	125.90	2
2032714	1	2031294	982.0	1
2032715	2	2031294	982.0	1
2032716	1	2031295	125.90	2
2032717	2	2031295	125.90	2
2032718	1	2031295	982.0	1
2032719	2	2031295	982.0	1
2032720	1	2031296	125.90	2
2032721	2	2031296	125.90	2
2032722	1	2031296	982.0	1
2032723	2	2031296	982.0	1
2032724	1	2031297	137.82	2
2032725	2	2031297	137.82	2
2032726	1	2031297	1075.0	1
2032727	2	2031297	1075.0	1
2032728	1	2031298	137.82	2
2032729	2	2031298	137.82	2
2032730	1	2031298	1075.0	1
2032731	2	2031298	1075.0	1
2032732	1	2031299	149.74	2
2032733	2	2031299	149.74	2
2032734	1	2031299	1168.0	1
2032735	2	2031299	1168.0	1
2032736	1	2031300	149.74	2
2032737	2	2031300	149.74	2
2032738	1	2031300	1168.0	1
2032739	2	2031300	1168.0	1
2032740	1	2031301	149.74	2
2032741	2	2031301	149.74	2
2032742	1	2031301	1168.0	1
2032743	2	2031301	1168.0	1
2032744	1	2031302	161.67	2
2032745	2	2031302	161.67	2
2032746	1	2031302	1261.0	1
2032747	2	2031302	1261.0	1
2032748	1	2031303	161.67	2
2032749	2	2031303	161.67	2
2032750	1	2031303	1261.0	1
2032751	2	2031303	1261.0	1
2032752	1	2031304	173.59	2
2032753	2	2031304	173.59	2
2032754	1	2031304	1354.0	1
2032755	2	2031304	1354.0	1
2032756	1	2031305	173.59	2
2032757	2	2031305	173.59	2
2032758	1	2031305	1354.0	1
2032759	2	2031305	1354.0	1
2032760	1	2031306	173.59	2
2032761	2	2031306	173.59	2
2032762	1	2031306	1354.0	1
2032763	2	2031306	1354.0	1
2032764	1	2031307	185.51	2
2032765	2	2031307	185.51	2
2032766	1	2031307	1447.0	1
2032767	2	2031307	1447.0	1
2032768	1	2031308	185.51	2
2032769	2	2031308	185.51	2
2032770	1	2031308	1447.0	1
2032771	2	2031308	1447.0	1
2032772	1	2031309	197.44	2
2032773	2	2031309	197.44	2
2032774	1	2031309	1540.0	1
2032775	2	2031309	1540.0	1
2032776	1	2031310	197.44	2
2032777	2	2031310	197.44	2
2032778	1	2031310	1540.0	1
2032779	2	2031310	1540.0	1
2032780	1	2031311	197.44	2
2032781	2	2031311	197.44	2
2032782	1	2031311	1540.0	1
2032783	2	2031311	1540.0	1
2032784	1	2031312	209.36	2
2032785	2	2031312	209.36	2
2032786	1	2031312	1633.0	1
2032787	2	2031312	1633.0	1
2032788	1	2031313	209.36	2
2032789	2	2031313	209.36	2
2032790	1	2031313	1633.0	1
2032791	2	2031313	1633.0	1
2032792	1	2031314	221.28	2
2032793	2	2031314	221.28	2
2032794	1	2031314	1726.0	1
2032795	2	2031314	1726.0	1
2032796	1	2031315	221.28	2
2032797	2	2031315	221.28	2
2032798	1	2031315	1726.0	1
2032799	2	2031315	1726.0	1
2032800	1	2031316	221.28	2
2032801	2	2031316	221.28	2
2032802	1	2031316	1726.0	1
2032803	2	2031316	1726.0	1
2032804	1	2031317	233.21	2
2032805	2	2031317	233.21	2
2032806	1	2031317	1819.0	1
2032807	2	2031317	1819.0	1
2032808	1	2031318	233.21	2
2032809	2	2031318	233.21	2
2032810	1	2031318	1819.0	1
2032811	2	2031318	1819.0	1
2032812	1	2031319	245.13	2
2032813	2	2031319	245.13	2
2032814	1	2031319	1912.0	1
2032815	2	2031319	1912.0	1
2032816	1	2031320	245.13	2
2032817	2	2031320	245.13	2
2032818	1	2031320	1912.0	1
2032819	2	2031320	1912.0	1
2032820	1	2031321	245.13	2
2032821	2	2031321	245.13	2
2032822	1	2031321	1912.0	1
2032823	2	2031321	1912.0	1
2032824	1	2031322	257.05	2
2032825	2	2031322	257.05	2
2032826	1	2031322	2005.0	1
2032827	2	2031322	2005.0	1
2032828	1	2031323	257.05	2
2032829	2	2031323	257.05	2
2032830	1	2031323	2005.0	1
2032831	2	2031323	2005.0	1
2032832	1	2031324	268.97	2
2032833	2	2031324	268.97	2
2032834	1	2031324	2098.0	1
2032835	2	2031324	2098.0	1
2032836	1	2031325	268.97	2
2032837	2	2031325	268.97	2
2032838	1	2031325	2098.0	1
2032839	2	2031325	2098.0	1
2032840	1	2031326	268.97	2
2032841	2	2031326	268.97	2
2032842	1	2031326	2098.0	1
2032843	2	2031326	2098.0	1
2032844	1	2031327	280.90	2
2032845	2	2031327	280.90	2
2032846	1	2031327	2191.0	1
2032847	2	2031327	2191.0	1
2032848	1	2031328	280.90	2
2032849	2	2031328	280.90	2
2032850	1	2031328	2191.0	1
2032851	2	2031328	2191.0	1
2032852	1	2031329	292.82	2
2032853	2	2031329	292.82	2
2032854	1	2031329	2284.0	1
2032855	2	2031329	2284.0	1
2032856	1	2031330	292.82	2
2032857	2	2031330	292.82	2
2032858	1	2031330	2284.0	1
2032859	2	2031330	2284.0	1
2032860	1	2031331	292.82	2
2032861	2	2031331	292.82	2
2032862	1	2031331	2284.0	1
2032863	2	2031331	2284.0	1
2032864	1	2031332	304.74	2
2032865	2	2031332	304.74	2
2032866	1	2031332	2377.0	1
2032867	2	2031332	2377.0	1
2032868	1	2031333	304.74	2
2032869	2	2031333	304.74	2
2032870	1	2031333	2377.0	1
2032871	2	2031333	2377.0	1
2032872	1	2031334	316.67	2
2032873	2	2031334	316.67	2
2032874	1	2031334	2470.0	1
2032875	2	2031334	2470.0	1
2032876	1	2031335	316.67	2
2032877	2	2031335	316.67	2
2032878	1	2031335	2470.0	1
2032879	2	2031335	2470.0	1
2032880	1	2031336	316.67	2
2032881	2	2031336	316.67	2
2032882	1	2031336	2470.0	1
2032883	2	2031336	2470.0	1
2032884	1	2031337	328.59	2
2032885	2	2031337	328.59	2
2032886	1	2031337	2563.0	1
2032887	2	2031337	2563.0	1
2032888	1	2031338	328.59	2
2032889	2	2031338	328.59	2
2032890	1	2031338	2563.0	1
2032891	2	2031338	2563.0	1
2032892	1	2031339	340.51	2
2032893	2	2031339	340.51	2
2032894	1	2031339	2656.0	1
2032895	2	2031339	2656.0	1
2032896	1	2031340	340.51	2
2032897	2	2031340	340.51	2
2032898	1	2031340	2656.0	1
2032899	2	2031340	2656.0	1
2032900	1	2031341	340.51	2
2032901	2	2031341	340.51	2
2032902	1	2031341	2656.0	1
2032903	2	2031341	2656.0	1
2032904	1	2031342	352.44	2
2032905	2	2031342	352.44	2
2032906	1	2031342	2749.0	1
2032907	2	2031342	2749.0	1
2032908	1	2031343	352.44	2
2032909	2	2031343	352.44	2
2032910	1	2031343	2749.0	1
2032911	2	2031343	2749.0	1
2032912	1	2031344	364.36	2
2032913	2	2031344	364.36	2
2032914	1	2031344	2842.0	1
2032915	2	2031344	2842.0	1
2032916	1	2031345	364.36	2
2032917	2	2031345	364.36	2
2032918	1	2031345	2842.0	1
2032919	2	2031345	2842.0	1
2032920	1	2031346	364.36	2
2032921	2	2031346	364.36	2
2032922	1	2031346	2842.0	1
2032923	2	2031346	2842.0	1
2032924	1	2031347	376.28	2
2032925	2	2031347	376.28	2
2032926	1	2031347	2935.0	1
2032927	2	2031347	2935.0	1
2032928	1	2031348	376.28	2
2032929	2	2031348	376.28	2
2032930	1	2031348	2935.0	1
2032931	2	2031348	2935.0	1
2032932	1	2031349	388.21	2
2032933	2	2031349	388.21	2
2032934	1	2031349	3028.0	1
2032935	2	2031349	3028.0	1
2032936	1	2031350	388.21	2
2032937	2	2031350	388.21	2
2032938	1	2031350	3028.0	1
2032939	2	2031350	3028.0	1
2032940	1	2031351	388.21	2
2032941	2	2031351	388.21	2
2032942	1	2031351	3028.0	1
2032943	2	2031351	3028.0	1
2032944	1	2031352	400.13	2
2032945	2	2031352	400.13	2
2032946	1	2031352	3121.0	1
2032947	2	2031352	3121.0	1
2032948	1	2031353	400.13	2
2032949	2	2031353	400.13	2
2032950	1	2031353	3121.0	1
2032951	2	2031353	3121.0	1
2032952	1	2031354	412.05	2
2032953	2	2031354	412.05	2
2032954	1	2031354	3214.0	1
2032955	2	2031354	3214.0	1
2032956	1	2031355	412.05	2
2032957	2	2031355	412.05	2
2032958	1	2031355	3214.0	1
2032959	2	2031355	3214.0	1
2032960	1	2031356	412.05	2
2032961	2	2031356	412.05	2
2032962	1	2031356	3214.0	1
2032963	2	2031356	3214.0	1
2032964	1	2031357	423.97	2
2032965	2	2031357	423.97	2
2032966	1	2031357	3307.0	1
2032967	2	2031357	3307.0	1
2032968	1	2031358	423.97	2
2032969	2	2031358	423.97	2
2032970	1	2031358	3307.0	1
2032971	2	2031358	3307.0	1
2032972	1	2031359	435.90	2
2032973	2	2031359	435.90	2
2032974	1	2031359	3400.0	1
2032975	2	2031359	3400.0	1
2032976	1	2031360	435.90	2
2032977	2	2031360	435.90	2
2032978	1	2031360	3400.0	1
2032979	2	2031360	3400.0	1
2032980	1	2031361	435.90	2
2032981	2	2031361	435.90	2
2032982	1	2031361	3400.0	1
2032983	2	2031361	3400.0	1
2032984	1	2031362	447.82	2
2032985	2	2031362	447.82	2
2032986	1	2031362	3493.0	1
2032987	2	2031362	3493.0	1
2032988	1	2031363	447.82	2
2032989	2	2031363	447.82	2
2032990	1	2031363	3493.0	1
2032991	2	2031363	3493.0	1
2032992	1	2031364	459.74	2
2032993	2	2031364	459.74	2
2032994	1	2031364	3586.0	1
2032995	2	2031364	3586.0	1
2032996	1	2031365	459.74	2
2032997	2	2031365	459.74	2
2032998	1	2031365	3586.0	1
2032999	2	2031365	3586.0	1
2033000	1	2031366	459.74	2
2033001	2	2031366	459.74	2
2033002	1	2031366	3586.0	1
2033003	2	2031366	3586.0	1
2033004	1	2031367	471.67	2
2033005	2	2031367	471.67	2
2033006	1	2031367	3679.0	1
2033007	2	2031367	3679.0	1
2033008	1	2031368	471.67	2
2033009	2	2031368	471.67	2
2033010	1	2031368	3679.0	1
2033011	2	2031368	3679.0	1
2033012	1	2031369	483.59	2
2033013	2	2031369	483.59	2
2033014	1	2031369	3772.0	1
2033015	2	2031369	3772.0	1
2033016	1	2031370	483.59	2
2033017	2	2031370	483.59	2
2033018	1	2031370	3772.0	1
2033019	2	2031370	3772.0	1
2033020	1	2031371	483.59	2
2033021	2	2031371	483.59	2
2033022	1	2031371	3772.0	1
2033023	2	2031371	3772.0	1
2033024	1	2031372	495.51	2
2033025	2	2031372	495.51	2
2033026	1	2031372	3865.0	1
2033027	2	2031372	3865.0	1
2033028	1	2031373	495.51	2
2033029	2	2031373	495.51	2
2033030	1	2031373	3865.0	1
2033031	2	2031373	3865.0	1
2033032	1	2031374	507.44	2
2033033	2	2031374	507.44	2
2033034	1	2031374	3958.0	1
2033035	2	2031374	3958.0	1
2033036	1	2031375	507.44	2
2033037	2	2031375	507.44	2
2033038	1	2031375	3958.0	1
2033039	2	2031375	3958.0	1
2033040	1	2031376	507.44	2
2033041	2	2031376	507.44	2
2033042	1	2031376	3958.0	1
2033043	2	2031376	3958.0	1
2033044	1	2031377	519.36	2
2033045	2	2031377	519.36	2
2033046	1	2031377	4051.0	1
2033047	2	2031377	4051.0	1
2033048	1	2031378	519.36	2
2033049	2	2031378	519.36	2
2033050	1	2031378	4051.0	1
2033051	2	2031378	4051.0	1
2033052	1	2031379	531.28	2
2033053	2	2031379	531.28	2
2033054	1	2031379	4144.0	1
2033055	2	2031379	4144.0	1
2033056	1	2031380	531.28	2
2033057	2	2031380	531.28	2
2033058	1	2031380	4144.0	1
2033059	2	2031380	4144.0	1
2033060	1	2031381	531.28	2
2033061	2	2031381	531.28	2
2033062	1	2031381	4144.0	1
2033063	2	2031381	4144.0	1
2033064	1	2031382	543.21	2
2033065	2	2031382	543.21	2
2033066	1	2031382	4237.0	1
2033067	2	2031382	4237.0	1
2033068	1	2031383	543.21	2
2033069	2	2031383	543.21	2
2033070	1	2031383	4237.0	1
2033071	2	2031383	4237.0	1
2033072	1	2031384	555.13	2
2033073	2	2031384	555.13	2
2033074	1	2031384	4330.0	1
2033075	2	2031384	4330.0	1
2033076	1	2031385	555.13	2
2033077	2	2031385	555.13	2
2033078	1	2031385	4330.0	1
2033079	2	2031385	4330.0	1
2033080	1	2031386	555.13	2
2033081	2	2031386	555.13	2
2033082	1	2031386	4330.0	1
2033083	2	2031386	4330.0	1
2033084	1	2031387	567.05	2
2033085	2	2031387	567.05	2
2033086	1	2031387	4423.0	1
2033087	2	2031387	4423.0	1
2033088	1	2031388	567.05	2
2033089	2	2031388	567.05	2
2033090	1	2031388	4423.0	1
2033091	2	2031388	4423.0	1
2033092	1	2031389	578.97	2
2033093	2	2031389	578.97	2
2033094	1	2031389	4516.0	1
2033095	2	2031389	4516.0	1
2033096	1	2031390	578.97	2
2033097	2	2031390	578.97	2
2033098	1	2031390	4516.0	1
2033099	2	2031390	4516.0	1
2033100	1	2031391	578.97	2
2033101	2	2031391	578.97	2
2033102	1	2031391	4516.0	1
2033103	2	2031391	4516.0	1
2033104	1	2031392	590.90	2
2033105	2	2031392	590.90	2
2033106	1	2031392	4609.0	1
2033107	2	2031392	4609.0	1
2033108	1	2031393	590.90	2
2033109	2	2031393	590.90	2
2033110	1	2031393	4609.0	1
2033111	2	2031393	4609.0	1
2033112	1	2031394	602.82	2
2033113	2	2031394	602.82	2
2033114	1	2031394	4702.0	1
2033115	2	2031394	4702.0	1
2033116	1	2031395	602.82	2
2033117	2	2031395	602.82	2
2033118	1	2031395	4702.0	1
2033119	2	2031395	4702.0	1
2033120	1	2031396	602.82	2
2033121	2	2031396	602.82	2
2033122	1	2031396	4702.0	1
2033123	2	2031396	4702.0	1
2033124	1	2031397	614.74	2
2033125	2	2031397	614.74	2
2033126	1	2031397	4795.0	1
2033127	2	2031397	4795.0	1
2033128	1	2031398	614.74	2
2033129	2	2031398	614.74	2
2033130	1	2031398	4795.0	1
2033131	2	2031398	4795.0	1
2033132	1	2031399	626.67	2
2033133	2	2031399	626.67	2
2033134	1	2031399	4888.0	1
2033135	2	2031399	4888.0	1
2033136	1	2031400	626.67	2
2033137	2	2031400	626.67	2
2033138	1	2031400	4888.0	1
2033139	2	2031400	4888.0	1
2033140	1	2031401	626.67	2
2033141	2	2031401	626.67	2
2033142	1	2031401	4888.0	1
2033143	2	2031401	4888.0	1
2033144	1	2031402	638.59	2
2033145	2	2031402	638.59	2
2033146	1	2031402	4981.0	1
2033147	2	2031402	4981.0	1
2033148	1	2031403	638.59	2
2033149	2	2031403	638.59	2
2033150	1	2031403	4981.0	1
2033151	2	2031403	4981.0	1
2033152	1	2031404	650.51	2
2033153	2	2031404	650.51	2
2033154	1	2031404	5074.0	1
2033155	2	2031404	5074.0	1
2033156	1	2031405	650.51	2
2033157	2	2031405	650.51	2
2033158	1	2031405	5074.0	1
2033159	2	2031405	5074.0	1
2033160	1	2031406	650.51	2
2033161	2	2031406	650.51	2
2033162	1	2031406	5074.0	1
2033163	2	2031406	5074.0	1
2033164	1	2031407	662.44	2
2033165	2	2031407	662.44	2
2033166	1	2031407	5167.0	1
2033167	2	2031407	5167.0	1
2033168	1	2031408	662.44	2
2033169	2	2031408	662.44	2
2033170	1	2031408	5167.0	1
2033171	2	2031408	5167.0	1
2033172	1	2031409	674.36	2
2033173	2	2031409	674.36	2
2033174	1	2031409	5260.0	1
2033175	2	2031409	5260.0	1
2033176	1	2031410	674.36	2
2033177	2	2031410	674.36	2
2033178	1	2031410	5260.0	1
2033179	2	2031410	5260.0	1
2033180	1	2031411	674.36	2
2033181	2	2031411	674.36	2
2033182	1	2031411	5260.0	1
2033183	2	2031411	5260.0	1
2033184	1	2031412	686.28	2
2033185	2	2031412	686.28	2
2033186	1	2031412	5353.0	1
2033187	2	2031412	5353.0	1
2033188	1	2031413	686.28	2
2033189	2	2031413	686.28	2
2033190	1	2031413	5353.0	1
2033191	2	2031413	5353.0	1
2033192	1	2031414	698.21	2
2033193	2	2031414	698.21	2
2033194	1	2031414	5446.0	1
2033195	2	2031414	5446.0	1
2033196	1	2031415	698.21	2
2033197	2	2031415	698.21	2
2033198	1	2031415	5446.0	1
2033199	2	2031415	5446.0	1
2033200	1	2031416	698.21	2
2033201	2	2031416	698.21	2
2033202	1	2031416	5446.0	1
2033203	2	2031416	5446.0	1
2033204	1	2031417	710.13	2
2033205	2	2031417	710.13	2
2033206	1	2031417	5539.0	1
2033207	2	2031417	5539.0	1
2033208	1	2031418	710.13	2
2033209	2	2031418	710.13	2
2033210	1	2031418	5539.0	1
2033211	2	2031418	5539.0	1
2033212	1	2031419	722.05	2
2033213	2	2031419	722.05	2
2033214	1	2031419	5632.0	1
2033215	2	2031419	5632.0	1
2033216	1	2031420	722.05	2
2033217	2	2031420	722.05	2
2033218	1	2031420	5632.0	1
2033219	2	2031420	5632.0	1
2033220	1	2031421	722.05	2
2033221	2	2031421	722.05	2
2033222	1	2031421	5632.0	1
2033223	2	2031421	5632.0	1
2033224	1	2031422	733.97	2
2033225	2	2031422	733.97	2
2033226	1	2031422	5725.0	1
2033227	2	2031422	5725.0	1
2033228	1	2031423	733.97	2
2033229	2	2031423	733.97	2
2033230	1	2031423	5725.0	1
2033231	2	2031423	5725.0	1
2033232	1	2031424	745.90	2
2033233	2	2031424	745.90	2
2033234	1	2031424	5818.0	1
2033235	2	2031424	5818.0	1
2033236	1	2031425	745.90	2
2033237	2	2031425	745.90	2
2033238	1	2031425	5818.0	1
2033239	2	2031425	5818.0	1
2033240	1	2031426	745.90	2
2033241	2	2031426	745.90	2
2033242	1	2031426	5818.0	1
2033243	2	2031426	5818.0	1
2033244	1	2031427	34.23	2
2033245	2	2031427	34.23	2
2033246	1	2031427	267.0	1
2033247	2	2031427	267.0	1
2033248	1	2031428	34.23	2
2033249	2	2031428	34.23	2
2033250	1	2031428	267.0	1
2033251	2	2031428	267.0	1
2033252	1	2031429	34.23	2
2033253	2	2031429	34.23	2
2033254	1	2031429	267.0	1
2033255	2	2031429	267.0	1
2033256	1	2031430	34.23	2
2033257	2	2031430	34.23	2
2033258	1	2031430	267.0	1
2033259	2	2031430	267.0	1
2033260	1	2031431	34.23	2
2033261	2	2031431	34.23	2
2033262	1	2031431	267.0	1
2033263	2	2031431	267.0	1
2033264	1	2031432	36.79	2
2033265	2	2031432	36.79	2
2033266	1	2031432	287.0	1
2033267	2	2031432	287.0	1
2033268	1	2031433	36.79	2
2033269	2	2031433	36.79	2
2033270	1	2031433	287.0	1
2033271	2	2031433	287.0	1
2033272	1	2031434	36.79	2
2033273	2	2031434	36.79	2
2033274	1	2031434	287.0	1
2033275	2	2031434	287.0	1
2033276	1	2031435	36.79	2
2033277	2	2031435	36.79	2
2033278	1	2031435	287.0	1
2033279	2	2031435	287.0	1
2033280	1	2031436	36.79	2
2033281	2	2031436	36.79	2
2033282	1	2031436	287.0	1
2033283	2	2031436	287.0	1
2033284	1	2031437	39.36	2
2033285	2	2031437	39.36	2
2033286	1	2031437	307.0	1
2033287	2	2031437	307.0	1
2033288	1	2031438	39.36	2
2033289	2	2031438	39.36	2
2033290	1	2031438	307.0	1
2033291	2	2031438	307.0	1
2033292	1	2031439	39.36	2
2033293	2	2031439	39.36	2
2033294	1	2031439	307.0	1
2033295	2	2031439	307.0	1
2033296	1	2031440	39.36	2
2033297	2	2031440	39.36	2
2033298	1	2031440	307.0	1
2033299	2	2031440	307.0	1
2033300	1	2031441	39.36	2
2033301	2	2031441	39.36	2
2033302	1	2031441	307.0	1
2033303	2	2031441	307.0	1
2033304	1	2031442	41.92	2
2033305	2	2031442	41.92	2
2033306	1	2031442	327.0	1
2033307	2	2031442	327.0	1
2033308	1	2031443	41.92	2
2033309	2	2031443	41.92	2
2033310	1	2031443	327.0	1
2033311	2	2031443	327.0	1
2033312	1	2031444	41.92	2
2033313	2	2031444	41.92	2
2033314	1	2031444	327.0	1
2033315	2	2031444	327.0	1
2033316	1	2031445	41.92	2
2033317	2	2031445	41.92	2
2033318	1	2031445	327.0	1
2033319	2	2031445	327.0	1
2033320	1	2031446	41.92	2
2033321	2	2031446	41.92	2
2033322	1	2031446	327.0	1
2033323	2	2031446	327.0	1
2033324	1	2031447	44.49	2
2033325	2	2031447	44.49	2
2033326	1	2031447	347.0	1
2033327	2	2031447	347.0	1
2033328	1	2031448	44.49	2
2033329	2	2031448	44.49	2
2033330	1	2031448	347.0	1
2033331	2	2031448	347.0	1
2033332	1	2031449	44.49	2
2033333	2	2031449	44.49	2
2033334	1	2031449	347.0	1
2033335	2	2031449	347.0	1
2033336	1	2031450	44.49	2
2033337	2	2031450	44.49	2
2033338	1	2031450	347.0	1
2033339	2	2031450	347.0	1
2033340	1	2031451	44.49	2
2033341	2	2031451	44.49	2
2033342	1	2031451	347.0	1
2033343	2	2031451	347.0	1
2033344	1	2031452	47.05	2
2033345	2	2031452	47.05	2
2033346	1	2031452	367.0	1
2033347	2	2031452	367.0	1
2033348	1	2031453	47.05	2
2033349	2	2031453	47.05	2
2033350	1	2031453	367.0	1
2033351	2	2031453	367.0	1
2033352	1	2031454	47.05	2
2033353	2	2031454	47.05	2
2033354	1	2031454	367.0	1
2033355	2	2031454	367.0	1
2033356	1	2031455	47.05	2
2033357	2	2031455	47.05	2
2033358	1	2031455	367.0	1
2033359	2	2031455	367.0	1
2033360	1	2031456	47.05	2
2033361	2	2031456	47.05	2
2033362	1	2031456	367.0	1
2033363	2	2031456	367.0	1
2033364	1	2031457	49.62	2
2033365	2	2031457	49.62	2
2033366	1	2031457	387.0	1
2033367	2	2031457	387.0	1
2033368	1	2031458	49.62	2
2033369	2	2031458	49.62	2
2033370	1	2031458	387.0	1
2033371	2	2031458	387.0	1
2033372	1	2031459	49.62	2
2033373	2	2031459	49.62	2
2033374	1	2031459	387.0	1
2033375	2	2031459	387.0	1
2033376	1	2031460	49.62	2
2033377	2	2031460	49.62	2
2033378	1	2031460	387.0	1
2033379	2	2031460	387.0	1
2033380	1	2031461	49.62	2
2033381	2	2031461	49.62	2
2033382	1	2031461	387.0	1
2033383	2	2031461	387.0	1
2033384	1	2031462	52.05	2
2033385	2	2031462	52.05	2
2033386	1	2031462	406.0	1
2033387	2	2031462	406.0	1
2033388	1	2031463	52.05	2
2033389	2	2031463	52.05	2
2033390	1	2031463	406.0	1
2033391	2	2031463	406.0	1
2033392	1	2031464	52.05	2
2033393	2	2031464	52.05	2
2033394	1	2031464	406.0	1
2033395	2	2031464	406.0	1
2033396	1	2031465	52.05	2
2033397	2	2031465	52.05	2
2033398	1	2031465	406.0	1
2033399	2	2031465	406.0	1
2033400	1	2031466	52.05	2
2033401	2	2031466	52.05	2
2033402	1	2031466	406.0	1
2033403	2	2031466	406.0	1
2033404	1	2031467	54.49	2
2033405	2	2031467	54.49	2
2033406	1	2031467	425.0	1
2033407	2	2031467	425.0	1
2033408	1	2031468	54.49	2
2033409	2	2031468	54.49	2
2033410	1	2031468	425.0	1
2033411	2	2031468	425.0	1
2033412	1	2031469	54.49	2
2033413	2	2031469	54.49	2
2033414	1	2031469	425.0	1
2033415	2	2031469	425.0	1
2033416	1	2031470	54.49	2
2033417	2	2031470	54.49	2
2033418	1	2031470	425.0	1
2033419	2	2031470	425.0	1
2033420	1	2031471	54.49	2
2033421	2	2031471	54.49	2
2033422	1	2031471	425.0	1
2033423	2	2031471	425.0	1
2033424	1	2031472	56.92	2
2033425	2	2031472	56.92	2
2033426	1	2031472	444.0	1
2033427	2	2031472	444.0	1
2033428	1	2031473	56.92	2
2033429	2	2031473	56.92	2
2033430	1	2031473	444.0	1
2033431	2	2031473	444.0	1
2033432	1	2031474	56.92	2
2033433	2	2031474	56.92	2
2033434	1	2031474	444.0	1
2033435	2	2031474	444.0	1
2033436	1	2031475	56.92	2
2033437	2	2031475	56.92	2
2033438	1	2031475	444.0	1
2033439	2	2031475	444.0	1
2033440	1	2031476	56.92	2
2033441	2	2031476	56.92	2
2033442	1	2031476	444.0	1
2033443	2	2031476	444.0	1
2033444	1	2031477	59.36	2
2033445	2	2031477	59.36	2
2033446	1	2031477	463.0	1
2033447	2	2031477	463.0	1
2033448	1	2031478	59.36	2
2033449	2	2031478	59.36	2
2033450	1	2031478	463.0	1
2033451	2	2031478	463.0	1
2033452	1	2031479	59.36	2
2033453	2	2031479	59.36	2
2033454	1	2031479	463.0	1
2033455	2	2031479	463.0	1
2033456	1	2031480	59.36	2
2033457	2	2031480	59.36	2
2033458	1	2031480	463.0	1
2033459	2	2031480	463.0	1
2033460	1	2031481	59.36	2
2033461	2	2031481	59.36	2
2033462	1	2031481	463.0	1
2033463	2	2031481	463.0	1
2033464	1	2031482	61.79	2
2033465	2	2031482	61.79	2
2033466	1	2031482	482.0	1
2033467	2	2031482	482.0	1
2033468	1	2031483	61.79	2
2033469	2	2031483	61.79	2
2033470	1	2031483	482.0	1
2033471	2	2031483	482.0	1
2033472	1	2031484	61.79	2
2033473	2	2031484	61.79	2
2033474	1	2031484	482.0	1
2033475	2	2031484	482.0	1
2033476	1	2031485	61.79	2
2033477	2	2031485	61.79	2
2033478	1	2031485	482.0	1
2033479	2	2031485	482.0	1
2033480	1	2031486	61.79	2
2033481	2	2031486	61.79	2
2033482	1	2031486	482.0	1
2033483	2	2031486	482.0	1
2033484	1	2031487	64.23	2
2033485	2	2031487	64.23	2
2033486	1	2031487	501.0	1
2033487	2	2031487	501.0	1
2033488	1	2031488	64.23	2
2033489	2	2031488	64.23	2
2033490	1	2031488	501.0	1
2033491	2	2031488	501.0	1
2033492	1	2031489	64.23	2
2033493	2	2031489	64.23	2
2033494	1	2031489	501.0	1
2033495	2	2031489	501.0	1
2033496	1	2031490	64.23	2
2033497	2	2031490	64.23	2
2033498	1	2031490	501.0	1
2033499	2	2031490	501.0	1
2033500	1	2031491	64.23	2
2033501	2	2031491	64.23	2
2033502	1	2031491	501.0	1
2033503	2	2031491	501.0	1
2033504	1	2031492	66.67	2
2033505	2	2031492	66.67	2
2033506	1	2031492	520.0	1
2033507	2	2031492	520.0	1
2033508	1	2031493	66.67	2
2033509	2	2031493	66.67	2
2033510	1	2031493	520.0	1
2033511	2	2031493	520.0	1
2033512	1	2031494	66.67	2
2033513	2	2031494	66.67	2
2033514	1	2031494	520.0	1
2033515	2	2031494	520.0	1
2033516	1	2031495	66.67	2
2033517	2	2031495	66.67	2
2033518	1	2031495	520.0	1
2033519	2	2031495	520.0	1
2033520	1	2031496	66.67	2
2033521	2	2031496	66.67	2
2033522	1	2031496	520.0	1
2033523	2	2031496	520.0	1
2033524	1	2031497	69.10	2
2033525	2	2031497	69.10	2
2033526	1	2031497	539.0	1
2033527	2	2031497	539.0	1
2033528	1	2031498	69.10	2
2033529	2	2031498	69.10	2
2033530	1	2031498	539.0	1
2033531	2	2031498	539.0	1
2033532	1	2031499	69.10	2
2033533	2	2031499	69.10	2
2033534	1	2031499	539.0	1
2033535	2	2031499	539.0	1
2033536	1	2031500	69.10	2
2033537	2	2031500	69.10	2
2033538	1	2031500	539.0	1
2033539	2	2031500	539.0	1
2033540	1	2031501	69.10	2
2033541	2	2031501	69.10	2
2033542	1	2031501	539.0	1
2033543	2	2031501	539.0	1
2033544	1	2031502	71.54	2
2033545	2	2031502	71.54	2
2033546	1	2031502	558.0	1
2033547	2	2031502	558.0	1
2033548	1	2031503	71.54	2
2033549	2	2031503	71.54	2
2033550	1	2031503	558.0	1
2033551	2	2031503	558.0	1
2033552	1	2031504	71.54	2
2033553	2	2031504	71.54	2
2033554	1	2031504	558.0	1
2033555	2	2031504	558.0	1
2033556	1	2031505	71.54	2
2033557	2	2031505	71.54	2
2033558	1	2031505	558.0	1
2033559	2	2031505	558.0	1
2033560	1	2031506	71.54	2
2033561	2	2031506	71.54	2
2033562	1	2031506	558.0	1
2033563	2	2031506	558.0	1
2033564	1	2031507	73.97	2
2033565	2	2031507	73.97	2
2033566	1	2031507	577.0	1
2033567	2	2031507	577.0	1
2033568	1	2031508	73.97	2
2033569	2	2031508	73.97	2
2033570	1	2031508	577.0	1
2033571	2	2031508	577.0	1
2033572	1	2031509	73.97	2
2033573	2	2031509	73.97	2
2033574	1	2031509	577.0	1
2033575	2	2031509	577.0	1
2033576	1	2031510	73.97	2
2033577	2	2031510	73.97	2
2033578	1	2031510	577.0	1
2033579	2	2031510	577.0	1
2033580	1	2031511	73.97	2
2033581	2	2031511	73.97	2
2033582	1	2031511	577.0	1
2033583	2	2031511	577.0	1
2033584	1	2031512	76.41	2
2033585	2	2031512	76.41	2
2033586	1	2031512	596.0	1
2033587	2	2031512	596.0	1
2033588	1	2031513	76.41	2
2033589	2	2031513	76.41	2
2033590	1	2031513	596.0	1
2033591	2	2031513	596.0	1
2033592	1	2031514	76.41	2
2033593	2	2031514	76.41	2
2033594	1	2031514	596.0	1
2033595	2	2031514	596.0	1
2033596	1	2031515	76.41	2
2033597	2	2031515	76.41	2
2033598	1	2031515	596.0	1
2033599	2	2031515	596.0	1
2033600	1	2031516	76.41	2
2033601	2	2031516	76.41	2
2033602	1	2031516	596.0	1
2033603	2	2031516	596.0	1
2033604	1	2031517	78.85	2
2033605	2	2031517	78.85	2
2033606	1	2031517	615.0	1
2033607	2	2031517	615.0	1
2033608	1	2031518	78.85	2
2033609	2	2031518	78.85	2
2033610	1	2031518	615.0	1
2033611	2	2031518	615.0	1
2033612	1	2031519	78.85	2
2033613	2	2031519	78.85	2
2033614	1	2031519	615.0	1
2033615	2	2031519	615.0	1
2033616	1	2031520	78.85	2
2033617	2	2031520	78.85	2
2033618	1	2031520	615.0	1
2033619	2	2031520	615.0	1
2033620	1	2031521	78.85	2
2033621	2	2031521	78.85	2
2033622	1	2031521	615.0	1
2033623	2	2031521	615.0	1
2033624	1	2031522	81.28	2
2033625	2	2031522	81.28	2
2033626	1	2031522	634.0	1
2033627	2	2031522	634.0	1
2033628	1	2031523	81.28	2
2033629	2	2031523	81.28	2
2033630	1	2031523	634.0	1
2033631	2	2031523	634.0	1
2033632	1	2031524	81.28	2
2033633	2	2031524	81.28	2
2033634	1	2031524	634.0	1
2033635	2	2031524	634.0	1
2033636	1	2031525	81.28	2
2033637	2	2031525	81.28	2
2033638	1	2031525	634.0	1
2033639	2	2031525	634.0	1
2033640	1	2031526	81.28	2
2033641	2	2031526	81.28	2
2033642	1	2031526	634.0	1
2033643	2	2031526	634.0	1
2033644	1	2031527	83.72	2
2033645	2	2031527	83.72	2
2033646	1	2031527	653.0	1
2033647	2	2031527	653.0	1
2033648	1	2031528	83.72	2
2033649	2	2031528	83.72	2
2033650	1	2031528	653.0	1
2033651	2	2031528	653.0	1
2033652	1	2031529	83.72	2
2033653	2	2031529	83.72	2
2033654	1	2031529	653.0	1
2033655	2	2031529	653.0	1
2033656	1	2031530	83.72	2
2033657	2	2031530	83.72	2
2033658	1	2031530	653.0	1
2033659	2	2031530	653.0	1
2033660	1	2031531	83.72	2
2033661	2	2031531	83.72	2
2033662	1	2031531	653.0	1
2033663	2	2031531	653.0	1
2033664	1	2031532	86.15	2
2033665	2	2031532	86.15	2
2033666	1	2031532	672.0	1
2033667	2	2031532	672.0	1
2033668	1	2031533	86.15	2
2033669	2	2031533	86.15	2
2033670	1	2031533	672.0	1
2033671	2	2031533	672.0	1
2033672	1	2031534	86.15	2
2033673	2	2031534	86.15	2
2033674	1	2031534	672.0	1
2033675	2	2031534	672.0	1
2033676	1	2031535	86.15	2
2033677	2	2031535	86.15	2
2033678	1	2031535	672.0	1
2033679	2	2031535	672.0	1
2033680	1	2031536	86.15	2
2033681	2	2031536	86.15	2
2033682	1	2031536	672.0	1
2033683	2	2031536	672.0	1
2033684	1	2031537	88.59	2
2033685	2	2031537	88.59	2
2033686	1	2031537	691.0	1
2033687	2	2031537	691.0	1
2033688	1	2031538	88.59	2
2033689	2	2031538	88.59	2
2033690	1	2031538	691.0	1
2033691	2	2031538	691.0	1
2033692	1	2031539	88.59	2
2033693	2	2031539	88.59	2
2033694	1	2031539	691.0	1
2033695	2	2031539	691.0	1
2033696	1	2031540	88.59	2
2033697	2	2031540	88.59	2
2033698	1	2031540	691.0	1
2033699	2	2031540	691.0	1
2033700	1	2031541	88.59	2
2033701	2	2031541	88.59	2
2033702	1	2031541	691.0	1
2033703	2	2031541	691.0	1
2033704	1	2031542	91.03	2
2033705	2	2031542	91.03	2
2033706	1	2031542	710.0	1
2033707	2	2031542	710.0	1
2033708	1	2031543	91.03	2
2033709	2	2031543	91.03	2
2033710	1	2031543	710.0	1
2033711	2	2031543	710.0	1
2033712	1	2031544	91.03	2
2033713	2	2031544	91.03	2
2033714	1	2031544	710.0	1
2033715	2	2031544	710.0	1
2033716	1	2031545	91.03	2
2033717	2	2031545	91.03	2
2033718	1	2031545	710.0	1
2033719	2	2031545	710.0	1
2033720	1	2031546	91.03	2
2033721	2	2031546	91.03	2
2033722	1	2031546	710.0	1
2033723	2	2031546	710.0	1
2033724	1	2031547	93.46	2
2033725	2	2031547	93.46	2
2033726	1	2031547	729.0	1
2033727	2	2031547	729.0	1
2033728	1	2031548	93.46	2
2033729	2	2031548	93.46	2
2033730	1	2031548	729.0	1
2033731	2	2031548	729.0	1
2033732	1	2031549	93.46	2
2033733	2	2031549	93.46	2
2033734	1	2031549	729.0	1
2033735	2	2031549	729.0	1
2033736	1	2031550	93.46	2
2033737	2	2031550	93.46	2
2033738	1	2031550	729.0	1
2033739	2	2031550	729.0	1
2033740	1	2031551	93.46	2
2033741	2	2031551	93.46	2
2033742	1	2031551	729.0	1
2033743	2	2031551	729.0	1
2033744	1	2031552	95.90	2
2033745	2	2031552	95.90	2
2033746	1	2031552	748.0	1
2033747	2	2031552	748.0	1
2033748	1	2031553	95.90	2
2033749	2	2031553	95.90	2
2033750	1	2031553	748.0	1
2033751	2	2031553	748.0	1
2033752	1	2031554	95.90	2
2033753	2	2031554	95.90	2
2033754	1	2031554	748.0	1
2033755	2	2031554	748.0	1
2033756	1	2031555	95.90	2
2033757	2	2031555	95.90	2
2033758	1	2031555	748.0	1
2033759	2	2031555	748.0	1
2033760	1	2031556	95.90	2
2033761	2	2031556	95.90	2
2033762	1	2031556	748.0	1
2033763	2	2031556	748.0	1
2033764	1	2031557	98.33	2
2033765	2	2031557	98.33	2
2033766	1	2031557	767.0	1
2033767	2	2031557	767.0	1
2033768	1	2031558	98.33	2
2033769	2	2031558	98.33	2
2033770	1	2031558	767.0	1
2033771	2	2031558	767.0	1
2033772	1	2031559	98.33	2
2033773	2	2031559	98.33	2
2033774	1	2031559	767.0	1
2033775	2	2031559	767.0	1
2033776	1	2031560	98.33	2
2033777	2	2031560	98.33	2
2033778	1	2031560	767.0	1
2033779	2	2031560	767.0	1
2033780	1	2031561	98.33	2
2033781	2	2031561	98.33	2
2033782	1	2031561	767.0	1
2033783	2	2031561	767.0	1
2033784	1	2031562	100.77	2
2033785	2	2031562	100.77	2
2033786	1	2031562	786.0	1
2033787	2	2031562	786.0	1
2033788	1	2031563	100.77	2
2033789	2	2031563	100.77	2
2033790	1	2031563	786.0	1
2033791	2	2031563	786.0	1
2033792	1	2031564	100.77	2
2033793	2	2031564	100.77	2
2033794	1	2031564	786.0	1
2033795	2	2031564	786.0	1
2033796	1	2031565	100.77	2
2033797	2	2031565	100.77	2
2033798	1	2031565	786.0	1
2033799	2	2031565	786.0	1
2033800	1	2031566	100.77	2
2033801	2	2031566	100.77	2
2033802	1	2031566	786.0	1
2033803	2	2031566	786.0	1
2033804	1	2031567	103.21	2
2033805	2	2031567	103.21	2
2033806	1	2031567	805.0	1
2033807	2	2031567	805.0	1
2033808	1	2031568	103.21	2
2033809	2	2031568	103.21	2
2033810	1	2031568	805.0	1
2033811	2	2031568	805.0	1
2033812	1	2031569	103.21	2
2033813	2	2031569	103.21	2
2033814	1	2031569	805.0	1
2033815	2	2031569	805.0	1
2033816	1	2031570	103.21	2
2033817	2	2031570	103.21	2
2033818	1	2031570	805.0	1
2033819	2	2031570	805.0	1
2033820	1	2031571	103.21	2
2033821	2	2031571	103.21	2
2033822	1	2031571	805.0	1
2033823	2	2031571	805.0	1
2033824	1	2031572	105.64	2
2033825	2	2031572	105.64	2
2033826	1	2031572	824.0	1
2033827	2	2031572	824.0	1
2033828	1	2031573	105.64	2
2033829	2	2031573	105.64	2
2033830	1	2031573	824.0	1
2033831	2	2031573	824.0	1
2033832	1	2031574	105.64	2
2033833	2	2031574	105.64	2
2033834	1	2031574	824.0	1
2033835	2	2031574	824.0	1
2033836	1	2031575	105.64	2
2033837	2	2031575	105.64	2
2033838	1	2031575	824.0	1
2033839	2	2031575	824.0	1
2033840	1	2031576	105.64	2
2033841	2	2031576	105.64	2
2033842	1	2031576	824.0	1
2033843	2	2031576	824.0	1
2033844	1	2031577	9.12	2
2033845	2	2031577	9.12	2
2033846	1	2031577	71.1	1
2033847	2	2031577	71.1	1
2033848	1	2031578	13.09	2
2033849	2	2031578	13.09	2
2033850	1	2031578	102.1	1
2033851	2	2031578	102.1	1
2033852	1	2031579	19.13	2
2033853	2	2031579	19.13	2
2033854	1	2031579	149.2	1
2033855	2	2031579	149.2	1
2033856	1	2031580	23.79	2
2033857	2	2031580	23.79	2
2033858	1	2031580	185.6	1
2033859	2	2031580	185.6	1
2033860	1	2031581	28.46	2
2033861	2	2031581	28.46	2
2033862	1	2031581	222.0	1
2033863	2	2031581	222.0	1
2033864	1	2031582	33.13	2
2033865	2	2031582	33.13	2
2033866	1	2031582	258.4	1
2033867	2	2031582	258.4	1
2033868	1	2031583	37.79	2
2033869	2	2031583	37.79	2
2033870	1	2031583	294.8	1
2033871	2	2031583	294.8	1
2033872	1	2031584	42.46	2
2033873	2	2031584	42.46	2
2033874	1	2031584	331.2	1
2033875	2	2031584	331.2	1
2033876	1	2031585	47.13	2
2033877	2	2031585	47.13	2
2033878	1	2031585	367.6	1
2033879	2	2031585	367.6	1
2033880	1	2031586	51.79	2
2033881	2	2031586	51.79	2
2033882	1	2031586	404.0	1
2033883	2	2031586	404.0	1
2033884	1	2031587	23.85	2
2033885	2	2031587	23.85	2
2033886	1	2031587	186.0	1
2033887	2	2031587	186.0	1
2033888	1	2031588	23.85	2
2033889	2	2031588	23.85	2
2033890	1	2031588	186.0	1
2033891	2	2031588	186.0	1
2033892	1	2031589	31.15	2
2033893	2	2031589	31.15	2
2033894	1	2031589	243.0	1
2033895	2	2031589	243.0	1
2033896	1	2031590	31.15	2
2033897	2	2031590	31.15	2
2033898	1	2031590	243.0	1
2033899	2	2031590	243.0	1
2033900	1	2031591	31.15	2
2033901	2	2031591	31.15	2
2033902	1	2031591	243.0	1
2033903	2	2031591	243.0	1
2033904	1	2031592	40.00	2
2033905	2	2031592	40.00	2
2033906	1	2031592	312.0	1
2033907	2	2031592	312.0	1
2033908	1	2031593	40.00	2
2033909	2	2031593	40.00	2
2033910	1	2031593	312.0	1
2033911	2	2031593	312.0	1
2033912	1	2031594	49.10	2
2033913	2	2031594	49.10	2
2033914	1	2031594	383.0	1
2033915	2	2031594	383.0	1
2033916	1	2031595	49.10	2
2033917	2	2031595	49.10	2
2033918	1	2031595	383.0	1
2033919	2	2031595	383.0	1
2033920	1	2031596	49.10	2
2033921	2	2031596	49.10	2
2033922	1	2031596	383.0	1
2033923	2	2031596	383.0	1
2033924	1	2031597	61.67	2
2033925	2	2031597	61.67	2
2033926	1	2031597	481.0	1
2033927	2	2031597	481.0	1
2033928	1	2031598	61.67	2
2033929	2	2031598	61.67	2
2033930	1	2031598	481.0	1
2033931	2	2031598	481.0	1
2033932	1	2031599	71.15	2
2033933	2	2031599	71.15	2
2033934	1	2031599	555.0	1
2033935	2	2031599	555.0	1
2033936	1	2031600	71.15	2
2033937	2	2031600	71.15	2
2033938	1	2031600	555.0	1
2033939	2	2031600	555.0	1
2033940	1	2031601	71.15	2
2033941	2	2031601	71.15	2
2033942	1	2031601	555.0	1
2033943	2	2031601	555.0	1
2033944	1	2031602	81.28	2
2033945	2	2031602	81.28	2
2033946	1	2031602	634.0	1
2033947	2	2031602	634.0	1
2033948	1	2031603	81.28	2
2033949	2	2031603	81.28	2
2033950	1	2031603	634.0	1
2033951	2	2031603	634.0	1
2033952	1	2031604	90.90	2
2033953	2	2031604	90.90	2
2033954	1	2031604	709.0	1
2033955	2	2031604	709.0	1
2033956	1	2031605	90.90	2
2033957	2	2031605	90.90	2
2033958	1	2031605	709.0	1
2033959	2	2031605	709.0	1
2033960	1	2031606	90.90	2
2033961	2	2031606	90.90	2
2033962	1	2031606	709.0	1
2033963	2	2031606	709.0	1
2033964	1	2031607	101.15	2
2033965	2	2031607	101.15	2
2033966	1	2031607	789.0	1
2033967	2	2031607	789.0	1
2033968	1	2031608	101.15	2
2033969	2	2031608	101.15	2
2033970	1	2031608	789.0	1
2033971	2	2031608	789.0	1
2033972	1	2031609	110.64	2
2033973	2	2031609	110.64	2
2033974	1	2031609	863.0	1
2033975	2	2031609	863.0	1
2033976	1	2031610	110.64	2
2033977	2	2031610	110.64	2
2033978	1	2031610	863.0	1
2033979	2	2031610	863.0	1
2033980	1	2031611	110.64	2
2033981	2	2031611	110.64	2
2033982	1	2031611	863.0	1
2033983	2	2031611	863.0	1
2033984	1	2031612	119.36	2
2033985	2	2031612	119.36	2
2033986	1	2031612	931.0	1
2033987	2	2031612	931.0	1
2033988	1	2031613	119.36	2
2033989	2	2031613	119.36	2
2033990	1	2031613	931.0	1
2033991	2	2031613	931.0	1
2033992	1	2031614	127.44	2
2033993	2	2031614	127.44	2
2033994	1	2031614	994.0	1
2033995	2	2031614	994.0	1
2033996	1	2031615	127.44	2
2033997	2	2031615	127.44	2
2033998	1	2031615	994.0	1
2033999	2	2031615	994.0	1
2034000	1	2031616	127.44	2
2034001	2	2031616	127.44	2
2034002	1	2031616	994.0	1
2034003	2	2031616	994.0	1
2034004	1	2031617	135.64	2
2034005	2	2031617	135.64	2
2034006	1	2031617	1058.0	1
2034007	2	2031617	1058.0	1
2034008	1	2031618	135.64	2
2034009	2	2031618	135.64	2
2034010	1	2031618	1058.0	1
2034011	2	2031618	1058.0	1
2034012	1	2031619	143.72	2
2034013	2	2031619	143.72	2
2034014	1	2031619	1121.0	1
2034015	2	2031619	1121.0	1
2034016	1	2031620	143.72	2
2034017	2	2031620	143.72	2
2034018	1	2031620	1121.0	1
2034019	2	2031620	1121.0	1
2034020	1	2031621	143.72	2
2034021	2	2031621	143.72	2
2034022	1	2031621	1121.0	1
2034023	2	2031621	1121.0	1
2034024	1	2031622	151.67	2
2034025	2	2031622	151.67	2
2034026	1	2031622	1183.0	1
2034027	2	2031622	1183.0	1
2034028	1	2031623	151.67	2
2034029	2	2031623	151.67	2
2034030	1	2031623	1183.0	1
2034031	2	2031623	1183.0	1
2034032	1	2031624	159.10	2
2034033	2	2031624	159.10	2
2034034	1	2031624	1241.0	1
2034035	2	2031624	1241.0	1
2034036	1	2031625	159.10	2
2034037	2	2031625	159.10	2
2034038	1	2031625	1241.0	1
2034039	2	2031625	1241.0	1
2034040	1	2031626	159.10	2
2034041	2	2031626	159.10	2
2034042	1	2031626	1241.0	1
2034043	2	2031626	1241.0	1
2034044	1	2031627	167.18	2
2034045	2	2031627	167.18	2
2034046	1	2031627	1304.0	1
2034047	2	2031627	1304.0	1
2034048	1	2031628	167.18	2
2034049	2	2031628	167.18	2
2034050	1	2031628	1304.0	1
2034051	2	2031628	1304.0	1
2034052	1	2031629	175.13	2
2034053	2	2031629	175.13	2
2034054	1	2031629	1366.0	1
2034055	2	2031629	1366.0	1
2034056	1	2031630	175.13	2
2034057	2	2031630	175.13	2
2034058	1	2031630	1366.0	1
2034059	2	2031630	1366.0	1
2034060	1	2031631	175.13	2
2034061	2	2031631	175.13	2
2034062	1	2031631	1366.0	1
2034063	2	2031631	1366.0	1
2034064	1	2031632	183.21	2
2034065	2	2031632	183.21	2
2034066	1	2031632	1429.0	1
2034067	2	2031632	1429.0	1
2034068	1	2031633	183.21	2
2034069	2	2031633	183.21	2
2034070	1	2031633	1429.0	1
2034071	2	2031633	1429.0	1
2034072	1	2031634	191.28	2
2034073	2	2031634	191.28	2
2034074	1	2031634	1492.0	1
2034075	2	2031634	1492.0	1
2034076	1	2031635	191.28	2
2034077	2	2031635	191.28	2
2034078	1	2031635	1492.0	1
2034079	2	2031635	1492.0	1
2034080	1	2031636	191.28	2
2034081	2	2031636	191.28	2
2034082	1	2031636	1492.0	1
2034083	2	2031636	1492.0	1
2034084	1	2031637	216.03	2
2034085	2	2031637	216.03	2
2034086	1	2031637	1685.0	1
2034087	2	2031637	1685.0	1
2034088	1	2031638	216.03	2
2034089	2	2031638	216.03	2
2034090	1	2031638	1685.0	1
2034091	2	2031638	1685.0	1
2034092	1	2031639	224.23	2
2034093	2	2031639	224.23	2
2034094	1	2031639	1749.0	1
2034095	2	2031639	1749.0	1
2034096	1	2031640	224.23	2
2034097	2	2031640	224.23	2
2034098	1	2031640	1749.0	1
2034099	2	2031640	1749.0	1
2034100	1	2031641	224.23	2
2034101	2	2031641	224.23	2
2034102	1	2031641	1749.0	1
2034103	2	2031641	1749.0	1
2034104	1	2031642	233.08	2
2034105	2	2031642	233.08	2
2034106	1	2031642	1818.0	1
2034107	2	2031642	1818.0	1
2034108	1	2031643	233.08	2
2034109	2	2031643	233.08	2
2034110	1	2031643	1818.0	1
2034111	2	2031643	1818.0	1
2034112	1	2031644	241.92	2
2034113	2	2031644	241.92	2
2034114	1	2031644	1887.0	1
2034115	2	2031644	1887.0	1
2034116	1	2031645	241.92	2
2034117	2	2031645	241.92	2
2034118	1	2031645	1887.0	1
2034119	2	2031645	1887.0	1
2034120	1	2031646	241.92	2
2034121	2	2031646	241.92	2
2034122	1	2031646	1887.0	1
2034123	2	2031646	1887.0	1
2034124	1	2031647	250.77	2
2034125	2	2031647	250.77	2
2034126	1	2031647	1956.0	1
2034127	2	2031647	1956.0	1
2034128	1	2031648	250.77	2
2034129	2	2031648	250.77	2
2034130	1	2031648	1956.0	1
2034131	2	2031648	1956.0	1
2034132	1	2031649	259.74	2
2034133	2	2031649	259.74	2
2034134	1	2031649	2026.0	1
2034135	2	2031649	2026.0	1
2034136	1	2031650	259.74	2
2034137	2	2031650	259.74	2
2034138	1	2031650	2026.0	1
2034139	2	2031650	2026.0	1
2034140	1	2031651	259.74	2
2034141	2	2031651	259.74	2
2034142	1	2031651	2026.0	1
2034143	2	2031651	2026.0	1
2034144	1	2031652	268.59	2
2034145	2	2031652	268.59	2
2034146	1	2031652	2095.0	1
2034147	2	2031652	2095.0	1
2034148	1	2031653	268.59	2
2034149	2	2031653	268.59	2
2034150	1	2031653	2095.0	1
2034151	2	2031653	2095.0	1
2034152	1	2031654	276.67	2
2034153	2	2031654	276.67	2
2034154	1	2031654	2158.0	1
2034155	2	2031654	2158.0	1
2034156	1	2031655	276.67	2
2034157	2	2031655	276.67	2
2034158	1	2031655	2158.0	1
2034159	2	2031655	2158.0	1
2034160	1	2031656	276.67	2
2034161	2	2031656	276.67	2
2034162	1	2031656	2158.0	1
2034163	2	2031656	2158.0	1
2034164	1	2031657	285.64	2
2034165	2	2031657	285.64	2
2034166	1	2031657	2228.0	1
2034167	2	2031657	2228.0	1
2034168	1	2031658	285.64	2
2034169	2	2031658	285.64	2
2034170	1	2031658	2228.0	1
2034171	2	2031658	2228.0	1
2034172	1	2031659	294.49	2
2034173	2	2031659	294.49	2
2034174	1	2031659	2297.0	1
2034175	2	2031659	2297.0	1
2034176	1	2031660	294.49	2
2034177	2	2031660	294.49	2
2034178	1	2031660	2297.0	1
2034179	2	2031660	2297.0	1
2034180	1	2031661	294.49	2
2034181	2	2031661	294.49	2
2034182	1	2031661	2297.0	1
2034183	2	2031661	2297.0	1
2034184	1	2031662	303.33	2
2034185	2	2031662	303.33	2
2034186	1	2031662	2366.0	1
2034187	2	2031662	2366.0	1
2034188	1	2031663	303.33	2
2034189	2	2031663	303.33	2
2034190	1	2031663	2366.0	1
2034191	2	2031663	2366.0	1
2034192	1	2031664	311.28	2
2034193	2	2031664	311.28	2
2034194	1	2031664	2428.0	1
2034195	2	2031664	2428.0	1
2034196	1	2031665	311.28	2
2034197	2	2031665	311.28	2
2034198	1	2031665	2428.0	1
2034199	2	2031665	2428.0	1
2034200	1	2031666	311.28	2
2034201	2	2031666	311.28	2
2034202	1	2031666	2428.0	1
2034203	2	2031666	2428.0	1
2034204	1	2031667	320.26	2
2034205	2	2031667	320.26	2
2034206	1	2031667	2498.0	1
2034207	2	2031667	2498.0	1
2034208	1	2031668	320.26	2
2034209	2	2031668	320.26	2
2034210	1	2031668	2498.0	1
2034211	2	2031668	2498.0	1
2034212	1	2031669	328.33	2
2034213	2	2031669	328.33	2
2034214	1	2031669	2561.0	1
2034215	2	2031669	2561.0	1
2034216	1	2031670	328.33	2
2034217	2	2031670	328.33	2
2034218	1	2031670	2561.0	1
2034219	2	2031670	2561.0	1
2034220	1	2031671	328.33	2
2034221	2	2031671	328.33	2
2034222	1	2031671	2561.0	1
2034223	2	2031671	2561.0	1
2034224	1	2031672	337.18	2
2034225	2	2031672	337.18	2
2034226	1	2031672	2630.0	1
2034227	2	2031672	2630.0	1
2034228	1	2031673	337.18	2
2034229	2	2031673	337.18	2
2034230	1	2031673	2630.0	1
2034231	2	2031673	2630.0	1
2034232	1	2031674	345.38	2
2034233	2	2031674	345.38	2
2034234	1	2031674	2694.0	1
2034235	2	2031674	2694.0	1
2034236	1	2031675	345.38	2
2034237	2	2031675	345.38	2
2034238	1	2031675	2694.0	1
2034239	2	2031675	2694.0	1
2034240	1	2031676	345.38	2
2034241	2	2031676	345.38	2
2034242	1	2031676	2694.0	1
2034243	2	2031676	2694.0	1
2034244	1	2031677	353.46	2
2034245	2	2031677	353.46	2
2034246	1	2031677	2757.0	1
2034247	2	2031677	2757.0	1
2034248	1	2031678	353.46	2
2034249	2	2031678	353.46	2
2034250	1	2031678	2757.0	1
2034251	2	2031678	2757.0	1
2034252	1	2031679	362.31	2
2034253	2	2031679	362.31	2
2034254	1	2031679	2826.0	1
2034255	2	2031679	2826.0	1
2034256	1	2031680	362.31	2
2034257	2	2031680	362.31	2
2034258	1	2031680	2826.0	1
2034259	2	2031680	2826.0	1
2034260	1	2031681	362.31	2
2034261	2	2031681	362.31	2
2034262	1	2031681	2826.0	1
2034263	2	2031681	2826.0	1
2034264	1	2031682	370.51	2
2034265	2	2031682	370.51	2
2034266	1	2031682	2890.0	1
2034267	2	2031682	2890.0	1
2034268	1	2031683	370.51	2
2034269	2	2031683	370.51	2
2034270	1	2031683	2890.0	1
2034271	2	2031683	2890.0	1
2034272	1	2031684	379.36	2
2034273	2	2031684	379.36	2
2034274	1	2031684	2959.0	1
2034275	2	2031684	2959.0	1
2034276	1	2031685	379.36	2
2034277	2	2031685	379.36	2
2034278	1	2031685	2959.0	1
2034279	2	2031685	2959.0	1
2034280	1	2031686	379.36	2
2034281	2	2031686	379.36	2
2034282	1	2031686	2959.0	1
2034283	2	2031686	2959.0	1
2034284	1	2031687	387.44	2
2034285	2	2031687	387.44	2
2034286	1	2031687	3022.0	1
2034287	2	2031687	3022.0	1
2034288	1	2031688	387.44	2
2034289	2	2031688	387.44	2
2034290	1	2031688	3022.0	1
2034291	2	2031688	3022.0	1
2034292	1	2031689	394.87	2
2034293	2	2031689	394.87	2
2034294	1	2031689	3080.0	1
2034295	2	2031689	3080.0	1
2034296	1	2031690	394.87	2
2034297	2	2031690	394.87	2
2034298	1	2031690	3080.0	1
2034299	2	2031690	3080.0	1
2034300	1	2031691	394.87	2
2034301	2	2031691	394.87	2
2034302	1	2031691	3080.0	1
2034303	2	2031691	3080.0	1
2034304	1	2031692	402.31	2
2034305	2	2031692	402.31	2
2034306	1	2031692	3138.0	1
2034307	2	2031692	3138.0	1
2034308	1	2031693	402.31	2
2034309	2	2031693	402.31	2
2034310	1	2031693	3138.0	1
2034311	2	2031693	3138.0	1
2034312	1	2031694	410.38	2
2034313	2	2031694	410.38	2
2034314	1	2031694	3201.0	1
2034315	2	2031694	3201.0	1
2034316	1	2031695	410.38	2
2034317	2	2031695	410.38	2
2034318	1	2031695	3201.0	1
2034319	2	2031695	3201.0	1
2034320	1	2031696	410.38	2
2034321	2	2031696	410.38	2
2034322	1	2031696	3201.0	1
2034323	2	2031696	3201.0	1
2034324	1	2031697	417.82	2
2034325	2	2031697	417.82	2
2034326	1	2031697	3259.0	1
2034327	2	2031697	3259.0	1
2034328	1	2031698	417.82	2
2034329	2	2031698	417.82	2
2034330	1	2031698	3259.0	1
2034331	2	2031698	3259.0	1
2034332	1	2031699	425.90	2
2034333	2	2031699	425.90	2
2034334	1	2031699	3322.0	1
2034335	2	2031699	3322.0	1
2034336	1	2031700	425.90	2
2034337	2	2031700	425.90	2
2034338	1	2031700	3322.0	1
2034339	2	2031700	3322.0	1
2034340	1	2031701	425.90	2
2034341	2	2031701	425.90	2
2034342	1	2031701	3322.0	1
2034343	2	2031701	3322.0	1
2034344	1	2031702	434.74	2
2034345	2	2031702	434.74	2
2034346	1	2031702	3391.0	1
2034347	2	2031702	3391.0	1
2034348	1	2031703	434.74	2
2034349	2	2031703	434.74	2
2034350	1	2031703	3391.0	1
2034351	2	2031703	3391.0	1
2034352	1	2031704	442.82	2
2034353	2	2031704	442.82	2
2034354	1	2031704	3454.0	1
2034355	2	2031704	3454.0	1
2034356	1	2031705	442.82	2
2034357	2	2031705	442.82	2
2034358	1	2031705	3454.0	1
2034359	2	2031705	3454.0	1
2034360	1	2031706	442.82	2
2034361	2	2031706	442.82	2
2034362	1	2031706	3454.0	1
2034363	2	2031706	3454.0	1
2034364	1	2031707	451.79	2
2034365	2	2031707	451.79	2
2034366	1	2031707	3524.0	1
2034367	2	2031707	3524.0	1
2034368	1	2031708	451.79	2
2034369	2	2031708	451.79	2
2034370	1	2031708	3524.0	1
2034371	2	2031708	3524.0	1
2034372	1	2031709	460.64	2
2034373	2	2031709	460.64	2
2034374	1	2031709	3593.0	1
2034375	2	2031709	3593.0	1
2034376	1	2031710	460.64	2
2034377	2	2031710	460.64	2
2034378	1	2031710	3593.0	1
2034379	2	2031710	3593.0	1
2034380	1	2031711	460.64	2
2034381	2	2031711	460.64	2
2034382	1	2031711	3593.0	1
2034383	2	2031711	3593.0	1
2034384	1	2031712	468.72	2
2034385	2	2031712	468.72	2
2034386	1	2031712	3656.0	1
2034387	2	2031712	3656.0	1
2034388	1	2031713	468.72	2
2034389	2	2031713	468.72	2
2034390	1	2031713	3656.0	1
2034391	2	2031713	3656.0	1
2034392	1	2031714	477.69	2
2034393	2	2031714	477.69	2
2034394	1	2031714	3726.0	1
2034395	2	2031714	3726.0	1
2034396	1	2031715	477.69	2
2034397	2	2031715	477.69	2
2034398	1	2031715	3726.0	1
2034399	2	2031715	3726.0	1
2034400	1	2031716	477.69	2
2034401	2	2031716	477.69	2
2034402	1	2031716	3726.0	1
2034403	2	2031716	3726.0	1
2034404	1	2031717	486.54	2
2034405	2	2031717	486.54	2
2034406	1	2031717	3795.0	1
2034407	2	2031717	3795.0	1
2034408	1	2031718	486.54	2
2034409	2	2031718	486.54	2
2034410	1	2031718	3795.0	1
2034411	2	2031718	3795.0	1
2034412	1	2031719	495.38	2
2034413	2	2031719	495.38	2
2034414	1	2031719	3864.0	1
2034415	2	2031719	3864.0	1
2034416	1	2031720	495.38	2
2034417	2	2031720	495.38	2
2034418	1	2031720	3864.0	1
2034419	2	2031720	3864.0	1
2034420	1	2031721	495.38	2
2034421	2	2031721	495.38	2
2034422	1	2031721	3864.0	1
2034423	2	2031721	3864.0	1
2034424	1	2031722	503.33	2
2034425	2	2031722	503.33	2
2034426	1	2031722	3926.0	1
2034427	2	2031722	3926.0	1
2034428	1	2031723	503.33	2
2034429	2	2031723	503.33	2
2034430	1	2031723	3926.0	1
2034431	2	2031723	3926.0	1
2034432	1	2031724	512.31	2
2034433	2	2031724	512.31	2
2034434	1	2031724	3996.0	1
2034435	2	2031724	3996.0	1
2034436	1	2031725	512.31	2
2034437	2	2031725	512.31	2
2034438	1	2031725	3996.0	1
2034439	2	2031725	3996.0	1
2034440	1	2031726	512.31	2
2034441	2	2031726	512.31	2
2034442	1	2031726	3996.0	1
2034443	2	2031726	3996.0	1
2034444	1	2031727	521.15	2
2034445	2	2031727	521.15	2
2034446	1	2031727	4065.0	1
2034447	2	2031727	4065.0	1
2034448	1	2031728	521.15	2
2034449	2	2031728	521.15	2
2034450	1	2031728	4065.0	1
2034451	2	2031728	4065.0	1
2034452	1	2031729	530.00	2
2034453	2	2031729	530.00	2
2034454	1	2031729	4134.0	1
2034455	2	2031729	4134.0	1
2034456	1	2031730	530.00	2
2034457	2	2031730	530.00	2
2034458	1	2031730	4134.0	1
2034459	2	2031730	4134.0	1
2034460	1	2031731	530.00	2
2034461	2	2031731	530.00	2
2034462	1	2031731	4134.0	1
2034463	2	2031731	4134.0	1
2034464	1	2031732	538.21	2
2034465	2	2031732	538.21	2
2034466	1	2031732	4198.0	1
2034467	2	2031732	4198.0	1
2034468	1	2031733	538.21	2
2034469	2	2031733	538.21	2
2034470	1	2031733	4198.0	1
2034471	2	2031733	4198.0	1
2034472	1	2031734	547.05	2
2034473	2	2031734	547.05	2
2034474	1	2031734	4267.0	1
2034475	2	2031734	4267.0	1
2034476	1	2031735	547.05	2
2034477	2	2031735	547.05	2
2034478	1	2031735	4267.0	1
2034479	2	2031735	4267.0	1
2034480	1	2031736	547.05	2
2034481	2	2031736	547.05	2
2034482	1	2031736	4267.0	1
2034483	2	2031736	4267.0	1
2034484	1	2031737	279.74	2
2034485	2	2031737	279.74	2
2034486	1	2031737	2182.0	1
2034487	2	2031737	2182.0	1
2034488	1	2031738	279.74	2
2034489	2	2031738	279.74	2
2034490	1	2031738	2182.0	1
2034491	2	2031738	2182.0	1
2034492	1	2031739	279.74	2
2034493	2	2031739	279.74	2
2034494	1	2031739	2182.0	1
2034495	2	2031739	2182.0	1
2034496	1	2031740	279.74	2
2034497	2	2031740	279.74	2
2034498	1	2031740	2182.0	1
2034499	2	2031740	2182.0	1
2034500	1	2031741	279.74	2
2034501	2	2031741	279.74	2
2034502	1	2031741	2182.0	1
2034503	2	2031741	2182.0	1
2034504	1	2031742	279.74	2
2034505	2	2031742	279.74	2
2034506	1	2031742	2182.0	1
2034507	2	2031742	2182.0	1
2034508	1	2031743	279.74	2
2034509	2	2031743	279.74	2
2034510	1	2031743	2182.0	1
2034511	2	2031743	2182.0	1
2034512	1	2031744	279.74	2
2034513	2	2031744	279.74	2
2034514	1	2031744	2182.0	1
2034515	2	2031744	2182.0	1
2034516	1	2031745	279.74	2
2034517	2	2031745	279.74	2
2034518	1	2031745	2182.0	1
2034519	2	2031745	2182.0	1
2034520	1	2031746	279.74	2
2034521	2	2031746	279.74	2
2034522	1	2031746	2182.0	1
2034523	2	2031746	2182.0	1
2034524	1	2031747	279.74	2
2034525	2	2031747	279.74	2
2034526	1	2031747	2182.0	1
2034527	2	2031747	2182.0	1
2034528	1	2031748	279.74	2
2034529	2	2031748	279.74	2
2034530	1	2031748	2182.0	1
2034531	2	2031748	2182.0	1
2034532	1	2031749	279.74	2
2034533	2	2031749	279.74	2
2034534	1	2031749	2182.0	1
2034535	2	2031749	2182.0	1
2034536	1	2031750	279.74	2
2034537	2	2031750	279.74	2
2034538	1	2031750	2182.0	1
2034539	2	2031750	2182.0	1
2034540	1	2031751	279.74	2
2034541	2	2031751	279.74	2
2034542	1	2031751	2182.0	1
2034543	2	2031751	2182.0	1
2034544	1	2031752	279.74	2
2034545	2	2031752	279.74	2
2034546	1	2031752	2182.0	1
2034547	2	2031752	2182.0	1
2034548	1	2031753	279.74	2
2034549	2	2031753	279.74	2
2034550	1	2031753	2182.0	1
2034551	2	2031753	2182.0	1
2034552	1	2031754	279.74	2
2034553	2	2031754	279.74	2
2034554	1	2031754	2182.0	1
2034555	2	2031754	2182.0	1
2034556	1	2031755	279.74	2
2034557	2	2031755	279.74	2
2034558	1	2031755	2182.0	1
2034559	2	2031755	2182.0	1
2034560	1	2031756	279.74	2
2034561	2	2031756	279.74	2
2034562	1	2031756	2182.0	1
2034563	2	2031756	2182.0	1
2034564	1	2031757	279.74	2
2034565	2	2031757	279.74	2
2034566	1	2031757	2182.0	1
2034567	2	2031757	2182.0	1
2034568	1	2031758	279.74	2
2034569	2	2031758	279.74	2
2034570	1	2031758	2182.0	1
2034571	2	2031758	2182.0	1
2034572	1	2031759	279.74	2
2034573	2	2031759	279.74	2
2034574	1	2031759	2182.0	1
2034575	2	2031759	2182.0	1
2034576	1	2031760	279.74	2
2034577	2	2031760	279.74	2
2034578	1	2031760	2182.0	1
2034579	2	2031760	2182.0	1
2034580	1	2031761	279.74	2
2034581	2	2031761	279.74	2
2034582	1	2031761	2182.0	1
2034583	2	2031761	2182.0	1
2034584	1	2031762	279.74	2
2034585	2	2031762	279.74	2
2034586	1	2031762	2182.0	1
2034587	2	2031762	2182.0	1
2034588	1	2031763	279.74	2
2034589	2	2031763	279.74	2
2034590	1	2031763	2182.0	1
2034591	2	2031763	2182.0	1
2034592	1	2031764	279.74	2
2034593	2	2031764	279.74	2
2034594	1	2031764	2182.0	1
2034595	2	2031764	2182.0	1
2034596	1	2031765	279.74	2
2034597	2	2031765	279.74	2
2034598	1	2031765	2182.0	1
2034599	2	2031765	2182.0	1
2034600	1	2031766	279.74	2
2034601	2	2031766	279.74	2
2034602	1	2031766	2182.0	1
2034603	2	2031766	2182.0	1
2034604	1	2031767	279.74	2
2034605	2	2031767	279.74	2
2034606	1	2031767	2182.0	1
2034607	2	2031767	2182.0	1
2034608	1	2031768	279.74	2
2034609	2	2031768	279.74	2
2034610	1	2031768	2182.0	1
2034611	2	2031768	2182.0	1
2034612	1	2031769	279.74	2
2034613	2	2031769	279.74	2
2034614	1	2031769	2182.0	1
2034615	2	2031769	2182.0	1
2034616	1	2031770	279.74	2
2034617	2	2031770	279.74	2
2034618	1	2031770	2182.0	1
2034619	2	2031770	2182.0	1
2034620	1	2031771	279.74	2
2034621	2	2031771	279.74	2
2034622	1	2031771	2182.0	1
2034623	2	2031771	2182.0	1
2034624	1	2031772	279.74	2
2034625	2	2031772	279.74	2
2034626	1	2031772	2182.0	1
2034627	2	2031772	2182.0	1
2034628	1	2031773	279.74	2
2034629	2	2031773	279.74	2
2034630	1	2031773	2182.0	1
2034631	2	2031773	2182.0	1
2034632	1	2031774	279.74	2
2034633	2	2031774	279.74	2
2034634	1	2031774	2182.0	1
2034635	2	2031774	2182.0	1
2034636	1	2031775	279.74	2
2034637	2	2031775	279.74	2
2034638	1	2031775	2182.0	1
2034639	2	2031775	2182.0	1
2034640	1	2031776	279.74	2
2034641	2	2031776	279.74	2
2034642	1	2031776	2182.0	1
2034643	2	2031776	2182.0	1
2034644	1	2031777	279.74	2
2034645	2	2031777	279.74	2
2034646	1	2031777	2182.0	1
2034647	2	2031777	2182.0	1
2034648	1	2031778	279.74	2
2034649	2	2031778	279.74	2
2034650	1	2031778	2182.0	1
2034651	2	2031778	2182.0	1
2034652	1	2031779	279.74	2
2034653	2	2031779	279.74	2
2034654	1	2031779	2182.0	1
2034655	2	2031779	2182.0	1
2034656	1	2031780	279.74	2
2034657	2	2031780	279.74	2
2034658	1	2031780	2182.0	1
2034659	2	2031780	2182.0	1
2034660	1	2031781	279.74	2
2034661	2	2031781	279.74	2
2034662	1	2031781	2182.0	1
2034663	2	2031781	2182.0	1
2034664	1	2031782	279.74	2
2034665	2	2031782	279.74	2
2034666	1	2031782	2182.0	1
2034667	2	2031782	2182.0	1
2034668	1	2031783	279.74	2
2034669	2	2031783	279.74	2
2034670	1	2031783	2182.0	1
2034671	2	2031783	2182.0	1
2034672	1	2031784	279.74	2
2034673	2	2031784	279.74	2
2034674	1	2031784	2182.0	1
2034675	2	2031784	2182.0	1
2034676	1	2031785	279.74	2
2034677	2	2031785	279.74	2
2034678	1	2031785	2182.0	1
2034679	2	2031785	2182.0	1
2034680	1	2031786	279.74	2
2034681	2	2031786	279.74	2
2034682	1	2031786	2182.0	1
2034683	2	2031786	2182.0	1
2034684	1	2031787	279.74	2
2034685	2	2031787	279.74	2
2034686	1	2031787	2182.0	1
2034687	2	2031787	2182.0	1
2034688	1	2031788	279.74	2
2034689	2	2031788	279.74	2
2034690	1	2031788	2182.0	1
2034691	2	2031788	2182.0	1
2034692	1	2031789	279.74	2
2034693	2	2031789	279.74	2
2034694	1	2031789	2182.0	1
2034695	2	2031789	2182.0	1
2034696	1	2031790	279.74	2
2034697	2	2031790	279.74	2
2034698	1	2031790	2182.0	1
2034699	2	2031790	2182.0	1
2034700	1	2031791	279.74	2
2034701	2	2031791	279.74	2
2034702	1	2031791	2182.0	1
2034703	2	2031791	2182.0	1
2034704	1	2031792	279.74	2
2034705	2	2031792	279.74	2
2034706	1	2031792	2182.0	1
2034707	2	2031792	2182.0	1
2034708	1	2031793	279.74	2
2034709	2	2031793	279.74	2
2034710	1	2031793	2182.0	1
2034711	2	2031793	2182.0	1
2034712	1	2031794	279.74	2
2034713	2	2031794	279.74	2
2034714	1	2031794	2182.0	1
2034715	2	2031794	2182.0	1
2034716	1	2031795	279.74	2
2034717	2	2031795	279.74	2
2034718	1	2031795	2182.0	1
2034719	2	2031795	2182.0	1
2034720	1	2031796	279.74	2
2034721	2	2031796	279.74	2
2034722	1	2031796	2182.0	1
2034723	2	2031796	2182.0	1
2034724	1	2031797	279.74	2
2034725	2	2031797	279.74	2
2034726	1	2031797	2182.0	1
2034727	2	2031797	2182.0	1
2034728	1	2031798	279.74	2
2034729	2	2031798	279.74	2
2034730	1	2031798	2182.0	1
2034731	2	2031798	2182.0	1
2034732	1	2031799	279.74	2
2034733	2	2031799	279.74	2
2034734	1	2031799	2182.0	1
2034735	2	2031799	2182.0	1
2034736	1	2031800	279.74	2
2034737	2	2031800	279.74	2
2034738	1	2031800	2182.0	1
2034739	2	2031800	2182.0	1
2034740	1	2031801	279.74	2
2034741	2	2031801	279.74	2
2034742	1	2031801	2182.0	1
2034743	2	2031801	2182.0	1
2034744	1	2031802	279.74	2
2034745	2	2031802	279.74	2
2034746	1	2031802	2182.0	1
2034747	2	2031802	2182.0	1
2034748	1	2031803	279.74	2
2034749	2	2031803	279.74	2
2034750	1	2031803	2182.0	1
2034751	2	2031803	2182.0	1
2034752	1	2031804	279.74	2
2034753	2	2031804	279.74	2
2034754	1	2031804	2182.0	1
2034755	2	2031804	2182.0	1
2034756	1	2031805	279.74	2
2034757	2	2031805	279.74	2
2034758	1	2031805	2182.0	1
2034759	2	2031805	2182.0	1
2034760	1	2031806	279.74	2
2034761	2	2031806	279.74	2
2034762	1	2031806	2182.0	1
2034763	2	2031806	2182.0	1
2034764	1	2031807	279.74	2
2034765	2	2031807	279.74	2
2034766	1	2031807	2182.0	1
2034767	2	2031807	2182.0	1
2034768	1	2031808	279.74	2
2034769	2	2031808	279.74	2
2034770	1	2031808	2182.0	1
2034771	2	2031808	2182.0	1
2034772	1	2031809	279.74	2
2034773	2	2031809	279.74	2
2034774	1	2031809	2182.0	1
2034775	2	2031809	2182.0	1
2034776	1	2031810	279.74	2
2034777	2	2031810	279.74	2
2034778	1	2031810	2182.0	1
2034779	2	2031810	2182.0	1
2034780	1	2031811	279.74	2
2034781	2	2031811	279.74	2
2034782	1	2031811	2182.0	1
2034783	2	2031811	2182.0	1
2034784	1	2031812	279.74	2
2034785	2	2031812	279.74	2
2034786	1	2031812	2182.0	1
2034787	2	2031812	2182.0	1
2034788	1	2031813	279.74	2
2034789	2	2031813	279.74	2
2034790	1	2031813	2182.0	1
2034791	2	2031813	2182.0	1
2034792	1	2031814	279.74	2
2034793	2	2031814	279.74	2
2034794	1	2031814	2182.0	1
2034795	2	2031814	2182.0	1
2034796	1	2031815	279.74	2
2034797	2	2031815	279.74	2
2034798	1	2031815	2182.0	1
2034799	2	2031815	2182.0	1
2034800	1	2031816	279.74	2
2034801	2	2031816	279.74	2
2034802	1	2031816	2182.0	1
2034803	2	2031816	2182.0	1
2034804	1	2031817	279.74	2
2034805	2	2031817	279.74	2
2034806	1	2031817	2182.0	1
2034807	2	2031817	2182.0	1
2034808	1	2031818	279.74	2
2034809	2	2031818	279.74	2
2034810	1	2031818	2182.0	1
2034811	2	2031818	2182.0	1
2034812	1	2031819	279.74	2
2034813	2	2031819	279.74	2
2034814	1	2031819	2182.0	1
2034815	2	2031819	2182.0	1
2034816	1	2031820	279.74	2
2034817	2	2031820	279.74	2
2034818	1	2031820	2182.0	1
2034819	2	2031820	2182.0	1
2034820	1	2031821	279.74	2
2034821	2	2031821	279.74	2
2034822	1	2031821	2182.0	1
2034823	2	2031821	2182.0	1
2034824	1	2031822	279.74	2
2034825	2	2031822	279.74	2
2034826	1	2031822	2182.0	1
2034827	2	2031822	2182.0	1
2034828	1	2031823	279.74	2
2034829	2	2031823	279.74	2
2034830	1	2031823	2182.0	1
2034831	2	2031823	2182.0	1
2034832	1	2031824	279.74	2
2034833	2	2031824	279.74	2
2034834	1	2031824	2182.0	1
2034835	2	2031824	2182.0	1
2034836	1	2031825	279.74	2
2034837	2	2031825	279.74	2
2034838	1	2031825	2182.0	1
2034839	2	2031825	2182.0	1
2034840	1	2031826	279.74	2
2034841	2	2031826	279.74	2
2034842	1	2031826	2182.0	1
2034843	2	2031826	2182.0	1
2034844	1	2031827	279.74	2
2034845	2	2031827	279.74	2
2034846	1	2031827	2182.0	1
2034847	2	2031827	2182.0	1
2034848	1	2031828	279.74	2
2034849	2	2031828	279.74	2
2034850	1	2031828	2182.0	1
2034851	2	2031828	2182.0	1
2034852	1	2031829	279.74	2
2034853	2	2031829	279.74	2
2034854	1	2031829	2182.0	1
2034855	2	2031829	2182.0	1
2034856	1	2031830	279.74	2
2034857	2	2031830	279.74	2
2034858	1	2031830	2182.0	1
2034859	2	2031830	2182.0	1
2034860	1	2031831	279.74	2
2034861	2	2031831	279.74	2
2034862	1	2031831	2182.0	1
2034863	2	2031831	2182.0	1
2034864	1	2031832	279.74	2
2034865	2	2031832	279.74	2
2034866	1	2031832	2182.0	1
2034867	2	2031832	2182.0	1
2034868	1	2031833	279.74	2
2034869	2	2031833	279.74	2
2034870	1	2031833	2182.0	1
2034871	2	2031833	2182.0	1
2034872	1	2031834	279.74	2
2034873	2	2031834	279.74	2
2034874	1	2031834	2182.0	1
2034875	2	2031834	2182.0	1
2034876	1	2031835	279.74	2
2034877	2	2031835	279.74	2
2034878	1	2031835	2182.0	1
2034879	2	2031835	2182.0	1
2034880	1	2031836	279.74	2
2034881	2	2031836	279.74	2
2034882	1	2031836	2182.0	1
2034883	2	2031836	2182.0	1
2034884	1	2031837	279.74	2
2034885	2	2031837	279.74	2
2034886	1	2031837	2182.0	1
2034887	2	2031837	2182.0	1
2034888	1	2031838	279.74	2
2034889	2	2031838	279.74	2
2034890	1	2031838	2182.0	1
2034891	2	2031838	2182.0	1
2034892	1	2031839	279.74	2
2034893	2	2031839	279.74	2
2034894	1	2031839	2182.0	1
2034895	2	2031839	2182.0	1
2034896	1	2031840	279.74	2
2034897	2	2031840	279.74	2
2034898	1	2031840	2182.0	1
2034899	2	2031840	2182.0	1
2034900	1	2031841	279.74	2
2034901	2	2031841	279.74	2
2034902	1	2031841	2182.0	1
2034903	2	2031841	2182.0	1
2034904	1	2031842	279.74	2
2034905	2	2031842	279.74	2
2034906	1	2031842	2182.0	1
2034907	2	2031842	2182.0	1
2034908	1	2031843	279.74	2
2034909	2	2031843	279.74	2
2034910	1	2031843	2182.0	1
2034911	2	2031843	2182.0	1
2034912	1	2031844	279.74	2
2034913	2	2031844	279.74	2
2034914	1	2031844	2182.0	1
2034915	2	2031844	2182.0	1
2034916	1	2031845	279.74	2
2034917	2	2031845	279.74	2
2034918	1	2031845	2182.0	1
2034919	2	2031845	2182.0	1
2034920	1	2031846	279.74	2
2034921	2	2031846	279.74	2
2034922	1	2031846	2182.0	1
2034923	2	2031846	2182.0	1
2034924	1	2031847	279.74	2
2034925	2	2031847	279.74	2
2034926	1	2031847	2182.0	1
2034927	2	2031847	2182.0	1
2034928	1	2031848	279.74	2
2034929	2	2031848	279.74	2
2034930	1	2031848	2182.0	1
2034931	2	2031848	2182.0	1
2034932	1	2031849	279.74	2
2034933	2	2031849	279.74	2
2034934	1	2031849	2182.0	1
2034935	2	2031849	2182.0	1
2034936	1	2031850	279.74	2
2034937	2	2031850	279.74	2
2034938	1	2031850	2182.0	1
2034939	2	2031850	2182.0	1
2034940	1	2031851	279.74	2
2034941	2	2031851	279.74	2
2034942	1	2031851	2182.0	1
2034943	2	2031851	2182.0	1
2034944	1	2031852	279.74	2
2034945	2	2031852	279.74	2
2034946	1	2031852	2182.0	1
2034947	2	2031852	2182.0	1
2034948	1	2031853	279.74	2
2034949	2	2031853	279.74	2
2034950	1	2031853	2182.0	1
2034951	2	2031853	2182.0	1
2034952	1	2031854	279.74	2
2034953	2	2031854	279.74	2
2034954	1	2031854	2182.0	1
2034955	2	2031854	2182.0	1
2034956	1	2031855	279.74	2
2034957	2	2031855	279.74	2
2034958	1	2031855	2182.0	1
2034959	2	2031855	2182.0	1
2034960	1	2031856	279.74	2
2034961	2	2031856	279.74	2
2034962	1	2031856	2182.0	1
2034963	2	2031856	2182.0	1
2034964	1	2031857	279.74	2
2034965	2	2031857	279.74	2
2034966	1	2031857	2182.0	1
2034967	2	2031857	2182.0	1
2034968	1	2031858	279.74	2
2034969	2	2031858	279.74	2
2034970	1	2031858	2182.0	1
2034971	2	2031858	2182.0	1
2034972	1	2031859	279.74	2
2034973	2	2031859	279.74	2
2034974	1	2031859	2182.0	1
2034975	2	2031859	2182.0	1
2034976	1	2031860	279.74	2
2034977	2	2031860	279.74	2
2034978	1	2031860	2182.0	1
2034979	2	2031860	2182.0	1
2034980	1	2031861	279.74	2
2034981	2	2031861	279.74	2
2034982	1	2031861	2182.0	1
2034983	2	2031861	2182.0	1
2034984	1	2031862	279.74	2
2034985	2	2031862	279.74	2
2034986	1	2031862	2182.0	1
2034987	2	2031862	2182.0	1
2034988	1	2031863	279.74	2
2034989	2	2031863	279.74	2
2034990	1	2031863	2182.0	1
2034991	2	2031863	2182.0	1
2034992	1	2031864	279.74	2
2034993	2	2031864	279.74	2
2034994	1	2031864	2182.0	1
2034995	2	2031864	2182.0	1
2034996	1	2031865	279.74	2
2034997	2	2031865	279.74	2
2034998	1	2031865	2182.0	1
2034999	2	2031865	2182.0	1
2035000	1	2031866	279.74	2
2035001	2	2031866	279.74	2
2035002	1	2031866	2182.0	1
2035003	2	2031866	2182.0	1
2035004	1	2031867	279.74	2
2035005	2	2031867	279.74	2
2035006	1	2031867	2182.0	1
2035007	2	2031867	2182.0	1
2035008	1	2031868	279.74	2
2035009	2	2031868	279.74	2
2035010	1	2031868	2182.0	1
2035011	2	2031868	2182.0	1
2035012	1	2031869	279.74	2
2035013	2	2031869	279.74	2
2035014	1	2031869	2182.0	1
2035015	2	2031869	2182.0	1
2035016	1	2031870	279.74	2
2035017	2	2031870	279.74	2
2035018	1	2031870	2182.0	1
2035019	2	2031870	2182.0	1
2035020	1	2031871	279.74	2
2035021	2	2031871	279.74	2
2035022	1	2031871	2182.0	1
2035023	2	2031871	2182.0	1
2035024	1	2031872	279.74	2
2035025	2	2031872	279.74	2
2035026	1	2031872	2182.0	1
2035027	2	2031872	2182.0	1
2035028	1	2031873	279.74	2
2035029	2	2031873	279.74	2
2035030	1	2031873	2182.0	1
2035031	2	2031873	2182.0	1
2035032	1	2031874	279.74	2
2035033	2	2031874	279.74	2
2035034	1	2031874	2182.0	1
2035035	2	2031874	2182.0	1
2035036	1	2031875	279.74	2
2035037	2	2031875	279.74	2
2035038	1	2031875	2182.0	1
2035039	2	2031875	2182.0	1
2035040	1	2031876	279.74	2
2035041	2	2031876	279.74	2
2035042	1	2031876	2182.0	1
2035043	2	2031876	2182.0	1
2035044	1	2031877	279.74	2
2035045	2	2031877	279.74	2
2035046	1	2031877	2182.0	1
2035047	2	2031877	2182.0	1
2035048	1	2031878	279.74	2
2035049	2	2031878	279.74	2
2035050	1	2031878	2182.0	1
2035051	2	2031878	2182.0	1
2035052	1	2031879	279.74	2
2035053	2	2031879	279.74	2
2035054	1	2031879	2182.0	1
2035055	2	2031879	2182.0	1
2035056	1	2031880	279.74	2
2035057	2	2031880	279.74	2
2035058	1	2031880	2182.0	1
2035059	2	2031880	2182.0	1
2035060	1	2031881	279.74	2
2035061	2	2031881	279.74	2
2035062	1	2031881	2182.0	1
2035063	2	2031881	2182.0	1
2035064	1	2031882	279.74	2
2035065	2	2031882	279.74	2
2035066	1	2031882	2182.0	1
2035067	2	2031882	2182.0	1
2035068	1	2031883	279.74	2
2035069	2	2031883	279.74	2
2035070	1	2031883	2182.0	1
2035071	2	2031883	2182.0	1
2035072	1	2031884	279.74	2
2035073	2	2031884	279.74	2
2035074	1	2031884	2182.0	1
2035075	2	2031884	2182.0	1
2035076	1	2031885	279.74	2
2035077	2	2031885	279.74	2
2035078	1	2031885	2182.0	1
2035079	2	2031885	2182.0	1
2035080	1	2031886	279.74	2
2035081	2	2031886	279.74	2
2035082	1	2031886	2182.0	1
2035083	2	2031886	2182.0	1
2035085	1	2031888	60	1
2035086	1	2031888	8	2
2035087	2	2031888	55	1
2035088	2	2031888	7	2
\.


--
-- Data for Name: price_type; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.price_type (prc_typ_id, prc_typ_desc, prc_typ_cd) FROM stdin;
1	retail	RET01
2	markdown	MKD01
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.product (prd_id, upc_cd, prd_crtd_dt, bnd_id, dept_id, prd_sts_id) FROM stdin;
11	3577789	2019-01-04 00:00:00+08	32	2	1
233275	30833030	2020-03-07 00:00:00+08	233191	2	1
233282	30833031	2020-07-18 00:00:00+08	233191	2	1
233289	30833032	2020-03-07 00:00:00+08	233191	2	1
233296	30833033	2020-03-07 00:00:00+08	233191	2	1
233303	30833034	2020-03-07 00:00:00+08	233191	2	1
233310	30833035	2020-03-07 00:00:00+08	233191	2	1
233317	30833036	2020-07-18 00:00:00+08	233191	2	1
233324	30833037	2020-07-18 00:00:00+08	233191	2	1
233331	30833038	2020-07-18 00:00:00+08	233191	2	1
233338	30833039	2020-07-18 00:00:00+08	233203	2	1
233345	30833040	2020-07-18 00:00:00+08	233191	2	1
233352	30833041	2020-07-18 00:00:00+08	233191	2	1
233359	30833042	2020-07-18 00:00:00+08	233191	2	1
233366	30833043	2020-07-18 00:00:00+08	233191	2	1
233373	30833044	2020-07-18 00:00:00+08	233191	2	1
233380	30833045	2020-07-18 00:00:00+08	233191	2	1
233387	30833046	2020-07-18 00:00:00+08	233191	2	1
233394	30833047	2020-07-18 00:00:00+08	233191	2	1
233401	30833048	2020-07-18 00:00:00+08	233191	2	1
233408	30833049	2020-07-18 00:00:00+08	233200	2	1
233415	30833050	2020-07-18 00:00:00+08	233200	2	1
233422	30833051	2020-07-18 00:00:00+08	233200	2	1
233429	30833052	2020-07-18 00:00:00+08	233206	2	1
233436	30833029	2020-02-08 00:00:00+08	233206	2	1
233443	30833053	2020-07-18 00:00:00+08	233191	2	1
233450	30833054	2020-07-18 00:00:00+08	233206	2	1
233457	30833055	2020-07-18 00:00:00+08	233191	2	1
233464	30833056	2020-07-18 00:00:00+08	233206	2	1
233471	30833057	2020-07-18 00:00:00+08	233206	2	1
233478	30833058	2020-07-18 00:00:00+08	233206	2	1
233485	30833059	2020-07-18 00:00:00+08	233206	2	1
233492	30833060	2020-07-18 00:00:00+08	233206	2	1
233499	30833061	2020-07-18 00:00:00+08	233206	2	1
233506	30833062	2020-07-18 00:00:00+08	233206	2	1
233513	30833063	2020-07-18 00:00:00+08	233206	2	1
233520	30833064	2020-07-18 00:00:00+08	233206	2	1
233527	30833065	2020-07-18 00:00:00+08	233206	2	1
233534	30833066	2020-07-18 00:00:00+08	233206	2	1
233541	30833067	2020-07-18 00:00:00+08	233206	2	1
233548	30833068	2020-07-18 00:00:00+08	233206	2	1
233555	30833069	2020-07-18 00:00:00+08	233206	2	1
233562	30833070	2020-07-18 00:00:00+08	233206	2	1
233569	30833071	2020-07-18 00:00:00+08	233206	2	1
233576	30833072	2020-07-18 00:00:00+08	233206	2	1
233583	30833073	2020-07-18 00:00:00+08	233209	2	1
233590	30833074	2020-07-18 00:00:00+08	233209	2	1
233597	30833075	2020-07-18 00:00:00+08	233206	2	1
233604	30833076	2020-02-08 00:00:00+08	233206	2	1
233611	30833077	2020-02-08 00:00:00+08	233206	2	1
233618	30833078	2020-02-08 00:00:00+08	233212	2	1
233625	30833079	2020-02-08 00:00:00+08	233206	2	1
233632	30833080	2020-02-08 00:00:00+08	233206	2	1
233639	30833081	2020-02-08 00:00:00+08	233191	2	1
233646	30833082	2020-02-08 00:00:00+08	233206	2	1
233653	30833083	2020-02-08 00:00:00+08	233206	2	1
233660	30833084	2020-02-08 00:00:00+08	233206	2	1
233667	30833085	2020-02-09 00:00:00+08	233206	2	1
233674	30833086	2020-02-10 00:00:00+08	233215	2	1
233681	30833087	2020-02-11 00:00:00+08	233215	2	1
233688	30833088	2020-02-12 00:00:00+08	233215	2	1
233695	30833089	2020-02-13 00:00:00+08	233191	2	1
233702	30833090	2020-02-14 00:00:00+08	233215	2	1
233709	30833091	2020-02-15 00:00:00+08	233215	2	1
233716	30833092	2020-02-16 00:00:00+08	233191	2	1
233723	30833093	2020-02-17 00:00:00+08	233191	2	1
233730	30833094	2020-02-18 00:00:00+08	233215	2	1
14	13159658	2020-02-20 00:00:00+08	32	2	1
20	10688155	2020-02-21 00:00:00+08	37	2	1
17	18911676	2020-02-22 00:00:00+08	37	2	1
7	14445678	2020-02-23 00:00:00+08	37	2	1
12	64377789	2020-02-24 00:00:00+08	34	2	1
29	17152401	2020-02-25 00:00:00+08	33	2	1
30	16067775	2020-02-26 00:00:00+08	33	2	1
28	16153782	2020-02-27 00:00:00+08	34	2	1
2	23464789	2020-02-28 00:00:00+08	40	2	1
15	15410595	2020-02-29 00:00:00+08	38	2	1
10	23477789	2020-03-01 00:00:00+08	35	2	1
27	15946292	2020-03-02 00:00:00+08	39	2	1
21	18170258	2020-03-03 00:00:00+08	38	2	1
26	13627671	2020-03-04 00:00:00+08	35	2	1
24	19037164	2020-03-05 00:00:00+08	41	2	1
25	15483827	2020-03-06 00:00:00+08	35	2	1
16	18188784	2020-03-07 00:00:00+08	41	2	1
6	23739283	2020-03-08 00:00:00+08	38	2	1
22	17235347	2020-03-09 00:00:00+08	39	2	1
23	17236024	2020-03-10 00:00:00+08	35	2	1
3	19633678	2020-03-11 00:00:00+08	37	2	1
9	12366678	2020-03-12 00:00:00+08	32	2	1
4	23456645	2020-03-13 00:00:00+08	41	2	1
13	76477789	2020-03-14 00:00:00+08	33	2	1
18	17366878	2020-03-15 00:00:00+08	39	2	1
19	10760430	2020-03-16 00:00:00+08	33	2	1
8	25556789	2020-03-17 00:00:00+08	41	2	1
1	12345678	2020-03-18 00:00:00+08	38	2	1
5	12383658	2020-03-19 00:00:00+08	34	2	1
2031068	HKG_LEG_0.41_0.60	2022-05-21 22:39:10.986+08	42	1	1
2031069	HKG_LEG_0.61_0.80	2022-05-21 22:39:11.877+08	42	1	1
2031070	HKG_LEG_0.81_1.00	2022-05-21 22:39:12.76+08	42	1	1
2031071	HKG_LEG_1.01_1.20	2022-05-21 22:39:13.513+08	42	1	1
2031072	HKG_LEG_1.21_1.40	2022-05-21 22:39:14.394+08	42	1	1
2031073	HKG_LEG_1.41_1.60	2022-05-21 22:39:15.216+08	42	1	1
2031074	HKG_LEG_1.61_1.80	2022-05-21 22:39:16.03+08	42	1	1
2031075	HKG_LEG_1.81_2.00	2022-05-21 22:39:16.757+08	42	1	1
2031076	HKG_LEG_2.01_2.20	2022-05-21 22:39:17.469+08	42	1	1
2031077	HKG_LEG_2.21_2.40	2022-05-21 22:39:18.287+08	42	1	1
2031078	HKG_LEG_2.41_2.60	2022-05-21 22:39:19.001+08	42	1	1
2031079	HKG_LEG_2.61_2.80	2022-05-21 22:39:19.696+08	42	1	1
2031080	HKG_LEG_2.81_3.00	2022-05-21 22:39:20.38+08	42	1	1
2031081	HKG_LEG_3.01_3.20	2022-05-21 22:39:21.068+08	42	1	1
2031082	HKG_LEG_3.21_3.40	2022-05-21 22:39:21.718+08	42	1	1
2031083	HKG_LEG_3.41_3.60	2022-05-21 22:39:22.483+08	42	1	1
2031084	HKG_LEG_3.61_3.80	2022-05-21 22:39:23.201+08	42	1	1
2031085	HKG_LEG_3.81_4.00	2022-05-21 22:39:23.903+08	42	1	1
2031087	HKG_LEG_4.21_4.40	2022-05-21 22:39:25.352+08	42	1	1
2031088	HKG_LEG_4.41_4.60	2022-05-21 22:39:26.067+08	42	1	1
2031089	HKG_LEG_4.61_4.80	2022-05-21 22:39:26.716+08	42	1	1
2031090	HKG_LEG_4.81_5.00	2022-05-21 22:39:27.495+08	42	1	1
2031091	HKG_LEG_5.01_5.20	2022-05-21 22:39:28.16+08	42	1	1
2031092	HKG_LEG_5.21_5.40	2022-05-21 22:39:28.821+08	42	1	1
2031093	HKG_LEG_5.41_5.60	2022-05-21 22:39:29.497+08	42	1	1
2031094	HKG_LEG_5.61_5.80	2022-05-21 22:39:30.146+08	42	1	1
2031095	HKG_LEG_5.81_6.00	2022-05-21 22:39:30.814+08	42	1	1
2031096	HKG_LEG_6.01_6.20	2022-05-21 22:39:31.441+08	42	1	1
2031097	HKG_LEG_6.21_6.40	2022-05-21 22:39:32.103+08	42	1	1
2031098	HKG_LEG_6.41_6.60	2022-05-21 22:39:32.744+08	42	1	1
2031099	HKG_LEG_6.61_6.80	2022-05-21 22:39:33.459+08	42	1	1
2031100	HKG_LEG_6.81_7.00	2022-05-21 22:39:34.156+08	42	1	1
2031101	HKG_LEG_7.01_7.20	2022-05-21 22:39:34.779+08	42	1	1
2031102	HKG_LEG_7.21_7.40	2022-05-21 22:39:35.437+08	42	1	1
2031103	HKG_LEG_7.41_7.60	2022-05-21 22:39:36.077+08	42	1	1
2031104	HKG_LEG_7.61_7.80	2022-05-21 22:39:36.822+08	42	1	1
2031105	HKG_LEG_7.81_8.00	2022-05-21 22:39:37.534+08	42	1	1
2031106	HKG_LEG_8.01_8.20	2022-05-21 22:39:38.154+08	42	1	1
2031107	HKG_LEG_8.21_8.40	2022-05-21 22:39:38.968+08	42	1	1
2031108	HKG_LEG_8.41_8.60	2022-05-21 22:39:39.593+08	42	1	1
2031110	HKG_LEG_8.81_9.00	2022-05-21 22:39:40.993+08	42	1	1
2031111	HKG_LEG_9.01_9.20	2022-05-21 22:39:42.039+08	42	1	1
2031112	HKG_LEG_9.21_9.40	2022-05-21 22:39:42.86+08	42	1	1
2031113	HKG_LEG_9.41_9.60	2022-05-21 22:39:43.577+08	42	1	1
2031114	HKG_LEG_9.61_9.80	2022-05-21 22:39:44.229+08	42	1	1
2031115	HKG_LEG_9.81_10.00	2022-05-21 22:39:45.136+08	42	1	1
2031116	HKG_LEG_10.01_10.20	2022-05-21 22:39:45.934+08	42	1	1
2031117	HKG_LEG_10.21_10.40	2022-05-21 22:39:46.614+08	42	1	1
2031118	HKG_LEG_10.41_10.60	2022-05-21 22:39:47.287+08	42	1	1
2031119	HKG_LEG_10.61_10.80	2022-05-21 22:39:47.953+08	42	1	1
2031120	HKG_LEG_10.81_11.00	2022-05-21 22:39:48.608+08	42	1	1
2031121	HKG_LEG_11.01_11.20	2022-05-21 22:39:49.31+08	42	1	1
2031122	HKG_LEG_11.21_11.40	2022-05-21 22:39:49.974+08	42	1	1
2031123	HKG_LEG_11.41_11.60	2022-05-21 22:39:50.641+08	42	1	1
2031124	HKG_LEG_11.61_11.80	2022-05-21 22:39:51.356+08	42	1	1
2031125	HKG_LEG_11.81_12.00	2022-05-21 22:39:52.076+08	42	1	1
2031126	HKG_LEG_12.01_12.20	2022-05-21 22:39:52.738+08	42	1	1
2031127	HKG_LEG_12.21_12.40	2022-05-21 22:39:53.414+08	42	1	1
2031128	HKG_LEG_12.41_12.60	2022-05-21 22:39:54.076+08	42	1	1
2031129	HKG_LEG_12.61_12.80	2022-05-21 22:39:54.782+08	42	1	1
2031130	HKG_LEG_12.81_13.00	2022-05-21 22:39:55.533+08	42	1	1
2031131	HKG_LEG_13.01_13.20	2022-05-21 22:39:56.185+08	42	1	1
2031133	HKG_LEG_13.41_13.60	2022-05-21 22:39:57.469+08	42	1	1
2031134	HKG_LEG_13.61_13.80	2022-05-21 22:39:58.115+08	42	1	1
2031135	HKG_LEG_13.81_14.00	2022-05-21 22:39:58.755+08	42	1	1
2031136	HKG_LEG_14.01_14.20	2022-05-21 22:39:59.45+08	42	1	1
2031137	HKG_LEG_14.21_14.40	2022-05-21 22:40:00.298+08	42	1	1
2031138	HKG_LEG_14.41_14.60	2022-05-21 22:40:01.247+08	42	1	1
2031139	HKG_LEG_14.61_14.80	2022-05-21 22:40:02.02+08	42	1	1
2031140	HKG_LEG_14.81_15.00	2022-05-21 22:40:02.658+08	42	1	1
2031141	HKG_LEG_15.01_15.20	2022-05-21 22:40:03.316+08	42	1	1
2031142	HKG_LEG_15.21_15.40	2022-05-21 22:40:03.931+08	42	1	1
2031143	HKG_LEG_15.41_15.60	2022-05-21 22:40:04.564+08	42	1	1
2031144	HKG_LEG_15.61_15.80	2022-05-21 22:40:05.315+08	42	1	1
2031145	HKG_LEG_15.81_16.00	2022-05-21 22:40:06.007+08	42	1	1
2031146	HKG_LEG_16.01_16.20	2022-05-21 22:40:06.717+08	42	1	1
2031147	HKG_LEG_16.21_16.40	2022-05-21 22:40:07.638+08	42	1	1
2031148	HKG_LEG_16.41_16.60	2022-05-21 22:40:08.458+08	42	1	1
2031149	HKG_LEG_16.61_16.80	2022-05-21 22:40:09.277+08	42	1	1
2031150	HKG_LEG_16.81_17.00	2022-05-21 22:40:09.996+08	42	1	1
2031151	HKG_LEG_17.01_17.20	2022-05-21 22:40:10.712+08	42	1	1
2031152	HKG_LEG_17.21_17.40	2022-05-21 22:40:11.483+08	42	1	1
2031153	HKG_LEG_17.41_17.60	2022-05-21 22:40:12.149+08	42	1	1
2031154	HKG_LEG_17.61_17.80	2022-05-21 22:40:12.881+08	42	1	1
2031156	HKG_LEG_18.01_18.20	2022-05-21 22:40:14.17+08	42	1	1
2031157	HKG_LEG_18.21_18.40	2022-05-21 22:40:14.943+08	42	1	1
2031158	HKG_LEG_18.41_18.60	2022-05-21 22:40:15.587+08	42	1	1
2031159	HKG_LEG_18.61_18.80	2022-05-21 22:40:16.341+08	42	1	1
2031160	HKG_LEG_18.81_19.00	2022-05-21 22:40:16.974+08	42	1	1
2031161	HKG_LEG_19.01_19.20	2022-05-21 22:40:17.675+08	42	1	1
2031162	HKG_LEG_19.21_19.40	2022-05-21 22:40:18.393+08	42	1	1
2031163	HKG_LEG_19.41_19.60	2022-05-21 22:40:19.209+08	42	1	1
2031164	HKG_LEG_19.61_19.80	2022-05-21 22:40:19.925+08	42	1	1
2031165	HKG_LEG_19.81_20.00	2022-05-21 22:40:20.749+08	42	1	1
2031166	HKG_LCP_0.01_0.20	2022-05-21 22:40:21.489+08	42	1	1
2031167	HKG_LCP_0.21_0.40	2022-05-21 22:40:22.235+08	42	1	1
2031168	HKG_LCP_0.41_0.60	2022-05-21 22:40:22.998+08	42	1	1
2031169	HKG_LCP_0.61_0.80	2022-05-21 22:40:23.824+08	42	1	1
2031170	HKG_LCP_0.81_1.00	2022-05-21 22:40:24.542+08	42	1	1
2031171	HKG_LCP_1.01_1.20	2022-05-21 22:40:25.219+08	42	1	1
2031172	HKG_LCP_1.21_1.40	2022-05-21 22:40:25.94+08	42	1	1
2031173	HKG_LCP_1.41_1.60	2022-05-21 22:40:26.589+08	42	1	1
2031175	HKG_LCP_1.81_2.00	2022-05-21 22:40:27.845+08	42	1	1
2031176	HKG_LPL_0.01_0.20	2022-05-21 22:40:28.467+08	42	1	1
2031177	HKG_LPL_0.21_0.40	2022-05-21 22:40:29.086+08	42	1	1
2031178	HKG_LPL_0.41_0.60	2022-05-21 22:40:29.82+08	42	1	1
2031179	HKG_LPL_0.61_0.80	2022-05-21 22:40:30.49+08	42	1	1
2031180	HKG_LPL_0.81_1.00	2022-05-21 22:40:31.296+08	42	1	1
2031181	HKG_LPL_1.01_1.20	2022-05-21 22:40:32.005+08	42	1	1
2031182	HKG_LPL_1.21_1.40	2022-05-21 22:40:32.696+08	42	1	1
2031183	HKG_LPL_1.41_1.60	2022-05-21 22:40:33.359+08	42	1	1
2031184	HKG_LPL_1.61_1.80	2022-05-21 22:40:33.977+08	42	1	1
2031185	HKG_LPL_1.81_2.00	2022-05-21 22:40:34.67+08	42	1	1
2031186	HKG_LPL_2.01_2.20	2022-05-21 22:40:35.29+08	42	1	1
2031187	HKG_LPL_2.21_2.40	2022-05-21 22:40:35.948+08	42	1	1
2031188	HKG_LPL_2.41_2.60	2022-05-21 22:40:36.618+08	42	1	1
2031189	HKG_LPL_2.61_2.80	2022-05-21 22:40:37.3+08	42	1	1
2031190	HKG_LPL_2.81_3.00	2022-05-21 22:40:37.945+08	42	1	1
2031191	HKG_LPL_3.01_3.20	2022-05-21 22:40:38.597+08	42	1	1
2031192	HKG_LPL_3.21_3.40	2022-05-21 22:40:39.427+08	42	1	1
2031193	HKG_LPL_3.41_3.60	2022-05-21 22:40:40.165+08	42	1	1
2031194	HKG_LPL_3.61_3.80	2022-05-21 22:40:40.979+08	42	1	1
2031195	HKG_LPL_3.81_4.00	2022-05-21 22:40:41.742+08	42	1	1
2031196	HKG_LPL_4.01_4.20	2022-05-21 22:40:42.458+08	42	1	1
2031198	HKG_LPL_4.41_4.60	2022-05-21 22:40:43.888+08	42	1	1
2031199	HKG_LPL_4.61_4.80	2022-05-21 22:40:44.617+08	42	1	1
2031200	HKG_LPL_4.81_5.00	2022-05-21 22:40:46.708+08	42	1	1
2031201	HKG_LPL_5.01_5.20	2022-05-21 22:40:47.371+08	42	1	1
2031202	HKG_LPL_5.21_5.40	2022-05-21 22:40:49.385+08	42	1	1
2031203	HKG_LPL_5.41_5.60	2022-05-21 22:40:50.498+08	42	1	1
2031204	HKG_LPL_5.61_5.80	2022-05-21 22:40:55.921+08	42	1	1
2031205	HKG_LPL_5.81_6.00	2022-05-21 22:40:57.218+08	42	1	1
2031206	HKG_LPL_6.01_6.20	2022-05-21 22:40:58.371+08	42	1	1
2031207	HKG_LPL_6.21_6.40	2022-05-21 22:41:00.086+08	42	1	1
2031208	HKG_LPL_6.41_6.60	2022-05-21 22:41:00.85+08	42	1	1
2031209	HKG_LPL_6.61_6.80	2022-05-21 22:41:01.498+08	42	1	1
2031210	HKG_LPL_6.81_7.00	2022-05-21 22:41:02.424+08	42	1	1
2031211	HKG_LPL_7.01_7.20	2022-05-21 22:41:03.153+08	42	1	1
2031212	HKG_LPL_7.21_7.40	2022-05-21 22:41:03.854+08	42	1	1
2031213	HKG_LPL_7.41_7.60	2022-05-21 22:41:04.572+08	42	1	1
2031214	HKG_LPL_7.61_7.80	2022-05-21 22:41:05.288+08	42	1	1
2031215	HKG_LPL_7.81_8.00	2022-05-21 22:41:06.106+08	42	1	1
2031216	HKG_LPL_8.01_8.20	2022-05-21 22:41:06.755+08	42	1	1
2031217	HKG_LPL_8.21_8.40	2022-05-21 22:41:07.439+08	42	1	1
2031218	HKG_LPL_8.41_8.60	2022-05-21 22:41:08.114+08	42	1	1
2031219	HKG_LPL_8.61_8.80	2022-05-21 22:41:08.77+08	42	1	1
2031221	HKG_LPL_9.01_9.20	2022-05-21 22:41:10.267+08	42	1	1
2031222	HKG_LPL_9.21_9.40	2022-05-21 22:41:10.926+08	42	1	1
2031223	HKG_LPL_9.41_9.60	2022-05-21 22:41:11.655+08	42	1	1
2031224	HKG_LPL_9.61_9.80	2022-05-21 22:41:12.321+08	42	1	1
2031225	HKG_LPL_9.81_10.00	2022-05-21 22:41:13.06+08	42	1	1
2031226	HKG_LPL_10.01_10.20	2022-05-21 22:41:14.08+08	42	1	1
2031227	HKG_LPL_10.21_10.40	2022-05-21 22:41:14.753+08	42	1	1
2031228	HKG_LPL_10.41_10.60	2022-05-21 22:41:15.428+08	42	1	1
2031229	HKG_LPL_10.61_10.80	2022-05-21 22:41:16.143+08	42	1	1
2031230	HKG_LPL_10.81_11.00	2022-05-21 22:41:16.863+08	42	1	1
2031231	HKG_LPL_11.01_11.20	2022-05-21 22:41:17.585+08	42	1	1
2031232	HKG_LPL_11.21_11.40	2022-05-21 22:41:18.266+08	42	1	1
2031233	HKG_LPL_11.41_11.60	2022-05-21 22:41:19.071+08	42	1	1
2031234	HKG_LPL_11.61_11.80	2022-05-21 22:41:19.827+08	42	1	1
2031235	HKG_LPL_11.81_12.00	2022-05-21 22:41:20.468+08	42	1	1
2031236	HKG_LPL_12.01_12.20	2022-05-21 22:41:21.19+08	42	1	1
2031237	HKG_LPL_12.21_12.40	2022-05-21 22:41:21.93+08	42	1	1
2031238	HKG_LPL_12.41_12.60	2022-05-21 22:41:22.593+08	42	1	1
2031239	HKG_LPL_12.61_12.80	2022-05-21 22:41:23.454+08	42	1	1
2031240	HKG_LPL_12.81_13.00	2022-05-21 22:41:24.358+08	42	1	1
2031241	HKG_LPL_13.01_13.20	2022-05-21 22:41:25.462+08	42	1	1
2031242	HKG_LPL_13.21_13.40	2022-05-21 22:41:26.476+08	42	1	1
2031066	HKG_LEG_0.01_0.20	2022-05-21 22:39:09.009+08	42	1	1
2031067	HKG_LEG_0.21_0.40	2022-05-21 22:39:10.143+08	42	1	1
2031086	HKG_LEG_4.01_4.20	2022-05-21 22:39:24.556+08	42	1	1
2031109	HKG_LEG_8.61_8.80	2022-05-21 22:39:40.225+08	42	1	1
2031132	HKG_LEG_13.21_13.40	2022-05-21 22:39:56.794+08	42	1	1
2031155	HKG_LEG_17.81_18.00	2022-05-21 22:40:13.534+08	42	1	1
2031174	HKG_LCP_1.61_1.80	2022-05-21 22:40:27.222+08	42	1	1
2031197	HKG_LPL_4.21_4.40	2022-05-21 22:40:43.154+08	42	1	1
2031220	HKG_LPL_8.81_9.00	2022-05-21 22:41:09.488+08	42	1	1
2031243	HKG_LPL_13.41_13.60	2022-05-21 22:41:27.462+08	42	1	1
2031244	HKG_LPL_13.61_13.80	2022-05-21 22:41:28.434+08	42	1	1
2031245	HKG_LPL_13.81_14.00	2022-05-21 22:41:29.332+08	42	1	1
2031246	HKG_LPL_14.01_14.20	2022-05-21 22:41:30.107+08	42	1	1
2031247	HKG_LPL_14.21_14.40	2022-05-21 22:41:30.801+08	42	1	1
2031248	HKG_LPL_14.41_14.60	2022-05-21 22:41:31.503+08	42	1	1
2031249	HKG_LPL_14.61_14.80	2022-05-21 22:41:32.425+08	42	1	1
2031250	HKG_LPL_14.81_15.00	2022-05-21 22:41:33.142+08	42	1	1
2031251	HKG_LPL_15.01_15.20	2022-05-21 22:41:33.856+08	42	1	1
2031252	HKG_LPL_15.21_15.40	2022-05-21 22:41:34.676+08	42	1	1
2031253	HKG_LPL_15.41_15.60	2022-05-21 22:41:35.352+08	42	1	1
2031254	HKG_LPL_15.61_15.80	2022-05-21 22:41:36.126+08	42	1	1
2031255	HKG_LPL_15.81_16.00	2022-05-21 22:41:36.93+08	42	1	1
2031256	HKG_LPL_16.01_16.20	2022-05-21 22:41:37.746+08	42	1	1
2031257	HKG_LPL_16.21_16.40	2022-05-21 22:41:38.568+08	42	1	1
2031258	HKG_LPL_16.41_16.60	2022-05-21 22:41:39.39+08	42	1	1
2031259	HKG_LPL_16.61_16.80	2022-05-21 22:41:40.036+08	42	1	1
2031260	HKG_LPL_16.81_17.00	2022-05-21 22:41:40.715+08	42	1	1
2031261	HKG_LPL_17.01_17.20	2022-05-21 22:41:41.436+08	42	1	1
2031262	HKG_LPL_17.21_17.40	2022-05-21 22:41:42.176+08	42	1	1
2031263	HKG_LPL_17.41_17.60	2022-05-21 22:41:42.867+08	42	1	1
2031264	HKG_LPL_17.61_17.80	2022-05-21 22:41:43.605+08	42	1	1
2031265	HKG_LPL_17.81_18.00	2022-05-21 22:41:44.25+08	42	1	1
2031266	HKG_LPL_18.01_18.20	2022-05-21 22:41:45.119+08	42	1	1
2031267	HKG_LPL_18.21_18.40	2022-05-21 22:41:45.837+08	42	1	1
2031268	HKG_LPL_18.41_18.60	2022-05-21 22:41:46.555+08	42	1	1
2031269	HKG_LPL_18.61_18.80	2022-05-21 22:41:47.241+08	42	1	1
2031270	HKG_LPL_18.81_19.00	2022-05-21 22:41:47.874+08	42	1	1
2031271	HKG_LPL_19.01_19.20	2022-05-21 22:41:48.567+08	42	1	1
2031272	HKG_LPL_19.21_19.40	2022-05-21 22:41:49.28+08	42	1	1
2031273	HKG_LPL_19.41_19.60	2022-05-21 22:41:50.035+08	42	1	1
2031274	HKG_LPL_19.61_19.80	2022-05-21 22:41:50.643+08	42	1	1
2031275	HKG_LPL_19.81_20.00	2022-05-21 22:41:51.295+08	42	1	1
2031277	NZA_APL_0.01_0.20	2022-05-21 22:41:52.49+08	42	1	1
2031278	NZA_APL_0.21_0.40	2022-05-21 22:41:53.314+08	42	1	1
2031279	NZA_APL_0.41_0.60	2022-05-21 22:41:54.027+08	42	1	1
2031280	NZA_APL_0.61_0.80	2022-05-21 22:41:55.149+08	42	1	1
2031281	NZA_APL_0.81_1.00	2022-05-21 22:41:55.874+08	42	1	1
2031282	NZA_APL_1.01_1.20	2022-05-21 22:41:56.49+08	42	1	1
2031283	NZA_APL_1.21_1.40	2022-05-21 22:41:57.133+08	42	1	1
2031284	NZA_APL_1.41_1.60	2022-05-21 22:41:57.821+08	42	1	1
2031285	NZA_APL_1.61_1.80	2022-05-21 22:41:58.494+08	42	1	1
2031286	NZA_APL_1.81_2.00	2022-05-21 22:41:59.27+08	42	1	1
2031287	NZA_APL_2.01_2.20	2022-05-21 22:42:00.026+08	42	1	1
2031288	NZA_APL_2.21_2.40	2022-05-21 22:42:00.788+08	42	1	1
2031289	NZA_APL_2.41_2.60	2022-05-21 22:42:01.504+08	42	1	1
2031290	NZA_APL_2.61_2.80	2022-05-21 22:42:02.196+08	42	1	1
2031291	NZA_APL_2.81_3.00	2022-05-21 22:42:02.905+08	42	1	1
2031292	NZA_APL_3.01_3.20	2022-05-21 22:42:07.441+08	42	1	1
2031293	NZA_APL_3.21_3.40	2022-05-21 22:42:08.159+08	42	1	1
2031294	NZA_APL_3.41_3.60	2022-05-21 22:42:08.976+08	42	1	1
2031295	NZA_APL_3.61_3.80	2022-05-21 22:42:09.718+08	42	1	1
2031296	NZA_APL_3.81_4.00	2022-05-21 22:42:10.741+08	42	1	1
2031297	NZA_APL_4.01_4.20	2022-05-21 22:42:13.381+08	42	1	1
2031298	NZA_APL_4.21_4.40	2022-05-21 22:42:14.095+08	42	1	1
2031299	NZA_APL_4.41_4.60	2022-05-21 22:42:14.876+08	42	1	1
2031300	NZA_APL_4.61_4.80	2022-05-21 22:42:15.631+08	42	1	1
2031301	NZA_APL_4.81_5.00	2022-05-21 22:42:16.453+08	42	1	1
2031302	NZA_APL_5.01_5.20	2022-05-21 22:42:17.096+08	42	1	1
2031303	NZA_APL_5.21_5.40	2022-05-21 22:42:17.848+08	42	1	1
2031304	NZA_APL_5.41_5.60	2022-05-21 22:42:18.916+08	42	1	1
2031305	NZA_APL_5.61_5.80	2022-05-21 22:42:19.625+08	42	1	1
2031306	NZA_APL_5.81_6.00	2022-05-21 22:42:20.649+08	42	1	1
2031307	NZA_APL_6.01_6.20	2022-05-21 22:42:21.47+08	42	1	1
2031308	NZA_APL_6.21_6.40	2022-05-21 22:42:22.201+08	42	1	1
2031309	NZA_APL_6.41_6.60	2022-05-21 22:42:22.909+08	42	1	1
2031310	NZA_APL_6.61_6.80	2022-05-21 22:42:23.62+08	42	1	1
2031311	NZA_APL_6.81_7.00	2022-05-21 22:42:24.253+08	42	1	1
2031312	NZA_APL_7.01_7.20	2022-05-21 22:42:24.95+08	42	1	1
2031313	NZA_APL_7.21_7.40	2022-05-21 22:42:25.872+08	42	1	1
2031314	NZA_APL_7.41_7.60	2022-05-21 22:42:26.691+08	42	1	1
2031315	NZA_APL_7.61_7.80	2022-05-21 22:42:27.409+08	42	1	1
2031316	NZA_APL_7.81_8.00	2022-05-21 22:42:28.125+08	42	1	1
2031317	NZA_APL_8.01_8.20	2022-05-21 22:42:28.942+08	42	1	1
2031318	NZA_APL_8.21_8.40	2022-05-21 22:42:29.662+08	42	1	1
2031319	NZA_APL_8.41_8.60	2022-05-21 22:42:30.479+08	42	1	1
2031320	NZA_APL_8.61_8.80	2022-05-21 22:42:31.258+08	42	1	1
2031321	NZA_APL_8.81_9.00	2022-05-21 22:42:32.016+08	42	1	1
2031322	NZA_APL_9.01_9.20	2022-05-21 22:42:32.836+08	42	1	1
2031323	NZA_APL_9.21_9.40	2022-05-21 22:42:33.563+08	42	1	1
2031324	NZA_APL_9.41_9.60	2022-05-21 22:42:34.222+08	42	1	1
2031325	NZA_APL_9.61_9.80	2022-05-21 22:42:34.907+08	42	1	1
2031326	NZA_APL_9.81_10.00	2022-05-21 22:42:35.6+08	42	1	1
2031327	NZA_APL_10.01_10.20	2022-05-21 22:42:36.338+08	42	1	1
2031328	NZA_APL_10.21_10.40	2022-05-21 22:42:37.018+08	42	1	1
2031329	NZA_APL_10.41_10.60	2022-05-21 22:42:37.748+08	42	1	1
2031330	NZA_APL_10.61_10.80	2022-05-21 22:42:38.467+08	42	1	1
2031331	NZA_APL_10.81_11.00	2022-05-21 22:42:39.988+08	42	1	1
2031332	NZA_APL_11.01_11.20	2022-05-21 22:42:40.99+08	42	1	1
2031333	NZA_APL_11.21_11.40	2022-05-21 22:42:41.838+08	42	1	1
2031334	NZA_APL_11.41_11.60	2022-05-21 22:42:42.521+08	42	1	1
2031335	NZA_APL_11.61_11.80	2022-05-21 22:42:44.62+08	42	1	1
2031336	NZA_APL_11.81_12.00	2022-05-21 22:42:45.428+08	42	1	1
2031337	NZA_APL_12.01_12.20	2022-05-21 22:42:46.25+08	42	1	1
2031338	NZA_APL_12.21_12.40	2022-05-21 22:42:46.969+08	42	1	1
2031339	NZA_APL_12.41_12.60	2022-05-21 22:42:47.648+08	42	1	1
2031340	NZA_APL_12.61_12.80	2022-05-21 22:42:48.458+08	42	1	1
2031341	NZA_APL_12.81_13.00	2022-05-21 22:42:49.14+08	42	1	1
2031342	NZA_APL_13.01_13.20	2022-05-21 22:42:49.835+08	42	1	1
2031343	NZA_APL_13.21_13.40	2022-05-21 22:42:50.569+08	42	1	1
2031344	NZA_APL_13.41_13.60	2022-05-21 22:42:51.61+08	42	1	1
2031345	NZA_APL_13.61_13.80	2022-05-21 22:42:52.324+08	42	1	1
2031346	NZA_APL_13.81_14.00	2022-05-21 22:42:53.238+08	42	1	1
2031347	NZA_APL_14.01_14.20	2022-05-21 22:42:54.327+08	42	1	1
2031348	NZA_APL_14.21_14.40	2022-05-21 22:42:54.987+08	42	1	1
2031349	NZA_APL_14.41_14.60	2022-05-21 22:42:55.664+08	42	1	1
2031350	NZA_APL_14.61_14.80	2022-05-21 22:42:56.494+08	42	1	1
2031351	NZA_APL_14.81_15.00	2022-05-21 22:42:57.63+08	42	1	1
2031352	NZA_APL_15.01_15.20	2022-05-21 22:42:58.921+08	42	1	1
2031353	NZA_APL_15.21_15.40	2022-05-21 22:42:59.662+08	42	1	1
2031354	NZA_APL_15.41_15.60	2022-05-21 22:43:00.363+08	42	1	1
2031355	NZA_APL_15.61_15.80	2022-05-21 22:43:01.243+08	42	1	1
2031356	NZA_APL_15.81_16.00	2022-05-21 22:43:03.018+08	42	1	1
2031357	NZA_APL_16.01_16.20	2022-05-21 22:43:03.944+08	42	1	1
2031358	NZA_APL_16.21_16.40	2022-05-21 22:43:04.782+08	42	1	1
2031359	NZA_APL_16.41_16.60	2022-05-21 22:43:05.6+08	42	1	1
2031360	NZA_APL_16.61_16.80	2022-05-21 22:43:06.989+08	42	1	1
2031361	NZA_APL_16.81_17.00	2022-05-21 22:43:07.854+08	42	1	1
2031362	NZA_APL_17.01_17.20	2022-05-21 22:43:08.67+08	42	1	1
2031363	NZA_APL_17.21_17.40	2022-05-21 22:43:09.492+08	42	1	1
2031364	NZA_APL_17.41_17.60	2022-05-21 22:43:10.413+08	42	1	1
2031365	NZA_APL_17.61_17.80	2022-05-21 22:43:11.175+08	42	1	1
2031366	NZA_APL_17.81_18.00	2022-05-21 22:43:11.97+08	42	1	1
2031367	NZA_APL_18.01_18.20	2022-05-21 22:43:12.716+08	42	1	1
2031368	NZA_APL_18.21_18.40	2022-05-21 22:43:13.787+08	42	1	1
2031369	NZA_APL_18.41_18.60	2022-05-21 22:43:14.657+08	42	1	1
2031370	NZA_APL_18.61_18.80	2022-05-21 22:43:15.57+08	42	1	1
2031371	NZA_APL_18.81_19.00	2022-05-21 22:43:16.353+08	42	1	1
2031372	NZA_APL_19.01_19.20	2022-05-21 22:43:17.019+08	42	1	1
2031373	NZA_APL_19.21_19.40	2022-05-21 22:43:17.652+08	42	1	1
2031374	NZA_APL_19.41_19.60	2022-05-21 22:43:18.405+08	42	1	1
2031375	NZA_APL_19.61_19.80	2022-05-21 22:43:19.042+08	42	1	1
2031376	NZA_APL_19.81_20.00	2022-05-21 22:43:19.733+08	42	1	1
2031377	NZA_APL_20.01_20.20	2022-05-21 22:43:20.433+08	42	1	1
2031378	NZA_APL_20.21_20.40	2022-05-21 22:43:21.164+08	42	1	1
2031379	NZA_APL_20.41_20.60	2022-05-21 22:43:21.953+08	42	1	1
2031380	NZA_APL_20.61_20.80	2022-05-21 22:43:27.832+08	42	1	1
2031381	NZA_APL_20.81_21.00	2022-05-21 22:43:28.542+08	42	1	1
2031382	NZA_APL_21.01_21.20	2022-05-21 22:43:29.257+08	42	1	1
2031383	NZA_APL_21.21_21.40	2022-05-21 22:43:29.97+08	42	1	1
2031384	NZA_APL_21.41_21.60	2022-05-21 22:43:30.673+08	42	1	1
2031385	NZA_APL_21.61_21.80	2022-05-21 22:43:31.401+08	42	1	1
2031386	NZA_APL_21.81_22.00	2022-05-21 22:43:32.314+08	42	1	1
2031387	NZA_APL_22.01_22.20	2022-05-21 22:43:33.046+08	42	1	1
2031388	NZA_APL_22.21_22.40	2022-05-21 22:43:33.862+08	42	1	1
2031389	NZA_APL_22.41_22.60	2022-05-21 22:43:34.681+08	42	1	1
2031390	NZA_APL_22.61_22.80	2022-05-21 22:43:35.501+08	42	1	1
2031391	NZA_APL_22.81_23.00	2022-05-21 22:43:36.279+08	42	1	1
2031392	NZA_APL_23.01_23.20	2022-05-21 22:43:37.036+08	42	1	1
2031393	NZA_APL_23.21_23.40	2022-05-21 22:43:37.771+08	42	1	1
2031394	NZA_APL_23.41_23.60	2022-05-21 22:43:38.552+08	42	1	1
2031395	NZA_APL_23.61_23.80	2022-05-21 22:43:39.311+08	42	1	1
2031396	NZA_APL_23.81_24.00	2022-05-21 22:43:40.009+08	42	1	1
2031397	NZA_APL_24.01_24.20	2022-05-21 22:43:40.825+08	42	1	1
2031398	NZA_APL_24.21_24.40	2022-05-21 22:43:41.643+08	42	1	1
2031399	NZA_APL_24.41_24.60	2022-05-21 22:43:42.362+08	42	1	1
2031400	NZA_APL_24.61_24.80	2022-05-21 22:43:43.131+08	42	1	1
2031401	NZA_APL_24.81_25.00	2022-05-21 22:43:44.035+08	42	1	1
2031402	NZA_APL_25.01_25.20	2022-05-21 22:43:44.817+08	42	1	1
2031403	NZA_APL_25.21_25.40	2022-05-21 22:43:45.593+08	42	1	1
2031404	NZA_APL_25.41_25.60	2022-05-21 22:43:46.274+08	42	1	1
2031405	NZA_APL_25.61_25.80	2022-05-21 22:43:46.953+08	42	1	1
2031406	NZA_APL_25.81_26.00	2022-05-21 22:43:47.724+08	42	1	1
2031407	NZA_APL_26.01_26.20	2022-05-21 22:43:48.414+08	42	1	1
2031408	NZA_APL_26.21_26.40	2022-05-21 22:43:49.118+08	42	1	1
2031409	NZA_APL_26.41_26.60	2022-05-21 22:43:50.348+08	42	1	1
2031410	NZA_APL_26.61_26.80	2022-05-21 22:43:51.063+08	42	1	1
2031411	NZA_APL_26.81_27.00	2022-05-21 22:43:51.743+08	42	1	1
2031412	NZA_APL_27.01_27.20	2022-05-21 22:43:52.402+08	42	1	1
2031413	NZA_APL_27.21_27.40	2022-05-21 22:43:53.318+08	42	1	1
2031414	NZA_APL_27.41_27.60	2022-05-21 22:43:54.239+08	42	1	1
2031415	NZA_APL_27.61_27.80	2022-05-21 22:43:55.109+08	42	1	1
2031416	NZA_APL_27.81_28.00	2022-05-21 22:43:56.219+08	42	1	1
2031417	NZA_APL_28.01_28.20	2022-05-21 22:43:57.319+08	42	1	1
2031418	NZA_APL_28.21_28.40	2022-05-21 22:43:58.499+08	42	1	1
2031419	NZA_APL_28.41_28.60	2022-05-21 22:43:59.178+08	42	1	1
2031420	NZA_APL_28.61_28.80	2022-05-21 22:43:59.87+08	42	1	1
2031421	NZA_APL_28.81_29.00	2022-05-21 22:44:00.688+08	42	1	1
2031422	NZA_APL_29.01_29.20	2022-05-21 22:44:01.511+08	42	1	1
2031423	NZA_APL_29.21_29.40	2022-05-21 22:44:02.326+08	42	1	1
2031424	NZA_APL_29.41_29.60	2022-05-21 22:44:03.002+08	42	1	1
2031425	NZA_APL_29.61_29.80	2022-05-21 22:44:03.762+08	42	1	1
2031426	NZA_APL_29.81_30.00	2022-05-21 22:44:04.579+08	42	1	1
2031427	NZA_SPL_0.01_0.20	2022-05-21 22:44:05.606+08	42	1	1
2031428	NZA_SPL_0.21_0.40	2022-05-21 22:44:06.321+08	42	1	1
2031429	NZA_SPL_0.41_0.60	2022-05-21 22:44:07.063+08	42	1	1
2031430	NZA_SPL_0.61_0.80	2022-05-21 22:44:07.836+08	42	1	1
2031431	NZA_SPL_0.81_1.00	2022-05-21 22:44:08.574+08	42	1	1
2031432	NZA_SPL_1.01_1.20	2022-05-21 22:44:09.29+08	42	1	1
2031433	NZA_SPL_1.21_1.40	2022-05-21 22:44:10.01+08	42	1	1
2031434	NZA_SPL_1.41_1.60	2022-05-21 22:44:10.735+08	42	1	1
2031435	NZA_SPL_1.61_1.80	2022-05-21 22:44:11.542+08	42	1	1
2031436	NZA_SPL_1.81_2.00	2022-05-21 22:44:12.361+08	42	1	1
2031437	NZA_SPL_2.01_2.20	2022-05-21 22:44:13.182+08	42	1	1
2031438	NZA_SPL_2.21_2.40	2022-05-21 22:44:13.95+08	42	1	1
2031439	NZA_SPL_2.41_2.60	2022-05-21 22:44:14.821+08	42	1	1
2031440	NZA_SPL_2.61_2.80	2022-05-21 22:44:15.542+08	42	1	1
2031441	NZA_SPL_2.81_3.00	2022-05-21 22:44:16.253+08	42	1	1
2031442	NZA_SPL_3.01_3.20	2022-05-21 22:44:16.953+08	42	1	1
2031443	NZA_SPL_3.21_3.40	2022-05-21 22:44:17.794+08	42	1	1
2031444	NZA_SPL_3.41_3.60	2022-05-21 22:44:18.487+08	42	1	1
2031445	NZA_SPL_3.61_3.80	2022-05-21 22:44:19.324+08	42	1	1
2031446	NZA_SPL_3.81_4.00	2022-05-21 22:44:20.007+08	42	1	1
2031447	NZA_SPL_4.01_4.20	2022-05-21 22:44:20.764+08	42	1	1
2031448	NZA_SPL_4.21_4.40	2022-05-21 22:44:21.68+08	42	1	1
2031449	NZA_SPL_4.41_4.60	2022-05-21 22:44:22.521+08	42	1	1
2031450	NZA_SPL_4.61_4.80	2022-05-21 22:44:23.216+08	42	1	1
2031451	NZA_SPL_4.81_5.00	2022-05-21 22:44:23.951+08	42	1	1
2031452	NZA_SPL_5.01_5.20	2022-05-21 22:44:24.788+08	42	1	1
2031453	NZA_SPL_5.21_5.40	2022-05-21 22:44:25.529+08	42	1	1
2031454	NZA_SPL_5.41_5.60	2022-05-21 22:44:26.209+08	42	1	1
2031455	NZA_SPL_5.61_5.80	2022-05-21 22:44:26.986+08	42	1	1
2031456	NZA_SPL_5.81_6.00	2022-05-21 22:44:27.778+08	42	1	1
2031457	NZA_SPL_6.01_6.20	2022-05-21 22:44:28.51+08	42	1	1
2031458	NZA_SPL_6.21_6.40	2022-05-21 22:44:29.159+08	42	1	1
2031459	NZA_SPL_6.41_6.60	2022-05-21 22:44:29.879+08	42	1	1
2031460	NZA_SPL_6.61_6.80	2022-05-21 22:44:30.588+08	42	1	1
2031461	NZA_SPL_6.81_7.00	2022-05-21 22:44:31.405+08	42	1	1
2031462	NZA_SPL_7.01_7.20	2022-05-21 22:44:32.179+08	42	1	1
2031463	NZA_SPL_7.21_7.40	2022-05-21 22:44:32.921+08	42	1	1
2031464	NZA_SPL_7.41_7.60	2022-05-21 22:44:33.657+08	42	1	1
2031465	NZA_SPL_7.61_7.80	2022-05-21 22:44:34.479+08	42	1	1
2031466	NZA_SPL_7.81_8.00	2022-05-21 22:44:35.323+08	42	1	1
2031467	NZA_SPL_8.01_8.20	2022-05-21 22:44:36.105+08	42	1	1
2031468	NZA_SPL_8.21_8.40	2022-05-21 22:44:36.831+08	42	1	1
2031469	NZA_SPL_8.41_8.60	2022-05-21 22:44:38.112+08	42	1	1
2031470	NZA_SPL_8.61_8.80	2022-05-21 22:44:38.871+08	42	1	1
2031471	NZA_SPL_8.81_9.00	2022-05-21 22:44:39.801+08	42	1	1
2031472	NZA_SPL_9.01_9.20	2022-05-21 22:44:40.522+08	42	1	1
2031473	NZA_SPL_9.21_9.40	2022-05-21 22:44:41.273+08	42	1	1
2031474	NZA_SPL_9.41_9.60	2022-05-21 22:44:42.278+08	42	1	1
2031475	NZA_SPL_9.61_9.80	2022-05-21 22:44:43.27+08	42	1	1
2031476	NZA_SPL_9.81_10.00	2022-05-21 22:44:44.102+08	42	1	1
2031477	NZA_SPL_10.01_10.20	2022-05-21 22:44:44.981+08	42	1	1
2031478	NZA_SPL_10.21_10.40	2022-05-21 22:44:45.806+08	42	1	1
2031479	NZA_SPL_10.41_10.60	2022-05-21 22:44:46.564+08	42	1	1
2031480	NZA_SPL_10.61_10.80	2022-05-21 22:44:47.42+08	42	1	1
2031481	NZA_SPL_10.81_11.00	2022-05-21 22:44:48.219+08	42	1	1
2031482	NZA_SPL_11.01_11.20	2022-05-21 22:44:49.251+08	42	1	1
2031483	NZA_SPL_11.21_11.40	2022-05-21 22:44:50.058+08	42	1	1
2031484	NZA_SPL_11.41_11.60	2022-05-21 22:44:50.764+08	42	1	1
2031485	NZA_SPL_11.61_11.80	2022-05-21 22:44:51.688+08	42	1	1
2031486	NZA_SPL_11.81_12.00	2022-05-21 22:44:52.404+08	42	1	1
2031487	NZA_SPL_12.01_12.20	2022-05-21 22:44:53.238+08	42	1	1
2031488	NZA_SPL_12.21_12.40	2022-05-21 22:44:54.04+08	42	1	1
2031489	NZA_SPL_12.41_12.60	2022-05-21 22:44:54.958+08	42	1	1
2031490	NZA_SPL_12.61_12.80	2022-05-21 22:44:55.674+08	42	1	1
2031491	NZA_SPL_12.81_13.00	2022-05-21 22:44:56.392+08	42	1	1
2031492	NZA_SPL_13.01_13.20	2022-05-21 22:44:57.213+08	42	1	1
2031493	NZA_SPL_13.21_13.40	2022-05-21 22:44:58.036+08	42	1	1
2031494	NZA_SPL_13.41_13.60	2022-05-21 22:44:58.816+08	42	1	1
2031495	NZA_SPL_13.61_13.80	2022-05-21 22:44:59.49+08	42	1	1
2031496	NZA_SPL_13.81_14.00	2022-05-21 22:45:00.494+08	42	1	1
2031497	NZA_SPL_14.01_14.20	2022-05-21 22:45:01.622+08	42	1	1
2031498	NZA_SPL_14.21_14.40	2022-05-21 22:45:02.331+08	42	1	1
2031499	NZA_SPL_14.41_14.60	2022-05-21 22:45:03.15+08	42	1	1
2031500	NZA_SPL_14.61_14.80	2022-05-21 22:45:03.968+08	42	1	1
2031501	NZA_SPL_14.81_15.00	2022-05-21 22:45:04.714+08	42	1	1
2031502	NZA_SPL_15.01_15.20	2022-05-21 22:45:05.513+08	42	1	1
2031503	NZA_SPL_15.21_15.40	2022-05-21 22:45:06.305+08	42	1	1
2031504	NZA_SPL_15.41_15.60	2022-05-21 22:45:07.002+08	42	1	1
2031505	NZA_SPL_15.61_15.80	2022-05-21 22:45:07.75+08	42	1	1
2031506	NZA_SPL_15.81_16.00	2022-05-21 22:45:08.44+08	42	1	1
2031507	NZA_SPL_16.01_16.20	2022-05-21 22:45:09.31+08	42	1	1
2031508	NZA_SPL_16.21_16.40	2022-05-21 22:45:10.03+08	42	1	1
2031509	NZA_SPL_16.41_16.60	2022-05-21 22:45:10.831+08	42	1	1
2031510	NZA_SPL_16.61_16.80	2022-05-21 22:45:11.648+08	42	1	1
2031511	NZA_SPL_16.81_17.00	2022-05-21 22:45:12.366+08	42	1	1
2031512	NZA_SPL_17.01_17.20	2022-05-21 22:45:13.037+08	42	1	1
2031513	NZA_SPL_17.21_17.40	2022-05-21 22:45:13.73+08	42	1	1
2031514	NZA_SPL_17.41_17.60	2022-05-21 22:45:14.437+08	42	1	1
2031515	NZA_SPL_17.61_17.80	2022-05-21 22:45:15.237+08	42	1	1
2031516	NZA_SPL_17.81_18.00	2022-05-21 22:45:16.007+08	42	1	1
2031517	NZA_SPL_18.01_18.20	2022-05-21 22:45:16.737+08	42	1	1
2031518	NZA_SPL_18.21_18.40	2022-05-21 22:45:17.416+08	42	1	1
2031519	NZA_SPL_18.41_18.60	2022-05-21 22:45:18.304+08	42	1	1
2031520	NZA_SPL_18.61_18.80	2022-05-21 22:45:19.029+08	42	1	1
2031521	NZA_SPL_18.81_19.00	2022-05-21 22:45:19.94+08	42	1	1
2031522	NZA_SPL_19.01_19.20	2022-05-21 22:45:20.761+08	42	1	1
2031523	NZA_SPL_19.21_19.40	2022-05-21 22:45:21.478+08	42	1	1
2031524	NZA_SPL_19.41_19.60	2022-05-21 22:45:22.199+08	42	1	1
2031525	NZA_SPL_19.61_19.80	2022-05-21 22:45:22.869+08	42	1	1
2031526	NZA_SPL_19.81_20.00	2022-05-21 22:45:23.629+08	42	1	1
2031527	NZA_SPL_20.01_20.20	2022-05-21 22:45:24.35+08	42	1	1
2031528	NZA_SPL_20.21_20.40	2022-05-21 22:45:25.165+08	42	1	1
2031529	NZA_SPL_20.41_20.60	2022-05-21 22:45:25.909+08	42	1	1
2031530	NZA_SPL_20.61_20.80	2022-05-21 22:45:26.876+08	42	1	1
2031531	NZA_SPL_20.81_21.00	2022-05-21 22:45:27.623+08	42	1	1
2031532	NZA_SPL_21.01_21.20	2022-05-21 22:45:28.344+08	42	1	1
2031533	NZA_SPL_21.21_21.40	2022-05-21 22:45:29.162+08	42	1	1
2031534	NZA_SPL_21.41_21.60	2022-05-21 22:45:29.847+08	42	1	1
2031535	NZA_SPL_21.61_21.80	2022-05-21 22:45:30.537+08	42	1	1
2031536	NZA_SPL_21.81_22.00	2022-05-21 22:45:31.309+08	42	1	1
2031537	NZA_SPL_22.01_22.20	2022-05-21 22:45:32.026+08	42	1	1
2031538	NZA_SPL_22.21_22.40	2022-05-21 22:45:32.845+08	42	1	1
2031539	NZA_SPL_22.41_22.60	2022-05-21 22:45:33.594+08	42	1	1
2031540	NZA_SPL_22.61_22.80	2022-05-21 22:45:34.302+08	42	1	1
2031541	NZA_SPL_22.81_23.00	2022-05-21 22:45:35.098+08	42	1	1
2031542	NZA_SPL_23.01_23.20	2022-05-21 22:45:35.917+08	42	1	1
2031543	NZA_SPL_23.21_23.40	2022-05-21 22:45:36.593+08	42	1	1
2031544	NZA_SPL_23.41_23.60	2022-05-21 22:45:37.35+08	42	1	1
2031545	NZA_SPL_23.61_23.80	2022-05-21 22:45:38.166+08	42	1	1
2031546	NZA_SPL_23.81_24.00	2022-05-21 22:45:38.986+08	42	1	1
2031547	NZA_SPL_24.01_24.20	2022-05-21 22:45:39.653+08	42	1	1
2031548	NZA_SPL_24.21_24.40	2022-05-21 22:45:40.422+08	42	1	1
2031549	NZA_SPL_24.41_24.60	2022-05-21 22:45:41.138+08	42	1	1
2031550	NZA_SPL_24.61_24.80	2022-05-21 22:45:41.951+08	42	1	1
2031551	NZA_SPL_24.81_25.00	2022-05-21 22:45:42.633+08	42	1	1
2031552	NZA_SPL_25.01_25.20	2022-05-21 22:45:43.389+08	42	1	1
2031553	NZA_SPL_25.21_25.40	2022-05-21 22:45:44.209+08	42	1	1
2031554	NZA_SPL_25.41_25.60	2022-05-21 22:45:44.919+08	42	1	1
2031555	NZA_SPL_25.61_25.80	2022-05-21 22:45:45.745+08	42	1	1
2031556	NZA_SPL_25.81_26.00	2022-05-21 22:45:46.565+08	42	1	1
2031557	NZA_SPL_26.01_26.20	2022-05-21 22:45:47.281+08	42	1	1
2031558	NZA_SPL_26.21_26.40	2022-05-21 22:45:48.1+08	42	1	1
2031559	NZA_SPL_26.41_26.60	2022-05-21 22:45:49.534+08	42	1	1
2031560	NZA_SPL_26.61_26.80	2022-05-21 22:45:50.252+08	42	1	1
2031561	NZA_SPL_26.81_27.00	2022-05-21 22:45:51.07+08	42	1	1
2031562	NZA_SPL_27.01_27.20	2022-05-21 22:45:51.777+08	42	1	1
2031563	NZA_SPL_27.21_27.40	2022-05-21 22:45:52.606+08	42	1	1
2031564	NZA_SPL_27.41_27.60	2022-05-21 22:45:53.424+08	42	1	1
2031565	NZA_SPL_27.61_27.80	2022-05-21 22:45:54.164+08	42	1	1
2031566	NZA_SPL_27.81_28.00	2022-05-21 22:45:54.965+08	42	1	1
2031567	NZA_SPL_28.01_28.20	2022-05-21 22:45:55.678+08	42	1	1
2031568	NZA_SPL_28.21_28.40	2022-05-21 22:45:56.416+08	42	1	1
2031569	NZA_SPL_28.41_28.60	2022-05-21 22:45:57.146+08	42	1	1
2031570	NZA_SPL_28.61_28.80	2022-05-21 22:45:57.932+08	42	1	1
2031571	NZA_SPL_28.81_29.00	2022-05-21 22:45:58.75+08	42	1	1
2031572	NZA_SPL_29.01_29.20	2022-05-21 22:45:59.466+08	42	1	1
2031573	NZA_SPL_29.21_29.40	2022-05-21 22:46:00.306+08	42	1	1
2031574	NZA_SPL_29.41_29.60	2022-05-21 22:46:01.122+08	42	1	1
2031575	NZA_SPL_29.61_29.80	2022-05-21 22:46:01.928+08	42	1	1
2031576	NZA_SPL_29.81_30.00	2022-05-21 22:46:02.729+08	42	1	1
2031577	NZA_AEX_0.01_0.20	2022-05-21 22:46:03.561+08	42	1	1
2031578	NZA_AEX_0.21_0.40	2022-05-21 22:46:04.384+08	42	1	1
2031579	NZA_AEX_0.41_0.60	2022-05-21 22:46:05.209+08	42	1	1
2031580	NZA_AEX_0.61_0.80	2022-05-21 22:46:06.027+08	42	1	1
2031581	NZA_AEX_0.81_1.00	2022-05-21 22:46:06.772+08	42	1	1
2031582	NZA_AEX_1.01_1.20	2022-05-21 22:46:07.521+08	42	1	1
2031583	NZA_AEX_1.21_1.40	2022-05-21 22:46:08.273+08	42	1	1
2031584	NZA_AEX_1.41_1.60	2022-05-21 22:46:09.1+08	42	1	1
2031585	NZA_AEX_1.61_1.80	2022-05-21 22:46:10.016+08	42	1	1
2031586	NZA_AEX_1.81_2.00	2022-05-21 22:46:10.765+08	42	1	1
2031587	NZA_EMS_0.01_0.20	2022-05-21 22:46:11.452+08	42	1	1
2031588	NZA_EMS_0.21_0.40	2022-05-21 22:46:12.165+08	42	1	1
2031589	NZA_EMS_0.41_0.60	2022-05-21 22:46:12.887+08	42	1	1
2031590	NZA_EMS_0.61_0.80	2022-05-21 22:46:13.738+08	42	1	1
2031591	NZA_EMS_0.81_1.00	2022-05-21 22:46:14.518+08	42	1	1
2031592	NZA_EMS_1.01_1.20	2022-05-21 22:46:15.234+08	42	1	1
2031593	NZA_EMS_1.21_1.40	2022-05-21 22:46:16.156+08	42	1	1
2031594	NZA_EMS_1.41_1.60	2022-05-21 22:46:17.18+08	42	1	1
2031595	NZA_EMS_1.61_1.80	2022-05-21 22:46:18.204+08	42	1	1
2031596	NZA_EMS_1.81_2.00	2022-05-21 22:46:19.234+08	42	1	1
2031597	NZA_EMS_2.01_2.20	2022-05-21 22:46:20.047+08	42	1	1
2031598	NZA_EMS_2.21_2.40	2022-05-21 22:46:20.769+08	42	1	1
2031599	NZA_EMS_2.41_2.60	2022-05-21 22:46:21.583+08	42	1	1
2031600	NZA_EMS_2.61_2.80	2022-05-21 22:46:22.405+08	42	1	1
2031601	NZA_EMS_2.81_3.00	2022-05-21 22:46:23.121+08	42	1	1
2031602	NZA_EMS_3.01_3.20	2022-05-21 22:46:23.994+08	42	1	1
2031603	NZA_EMS_3.21_3.40	2022-05-21 22:46:24.758+08	42	1	1
2031604	NZA_EMS_3.41_3.60	2022-05-21 22:46:25.476+08	42	1	1
2031605	NZA_EMS_3.61_3.80	2022-05-21 22:46:26.298+08	42	1	1
2031606	NZA_EMS_3.81_4.00	2022-05-21 22:46:27.001+08	42	1	1
2031607	NZA_EMS_4.01_4.20	2022-05-21 22:46:27.846+08	42	1	1
2031608	NZA_EMS_4.21_4.40	2022-05-21 22:46:28.751+08	42	1	1
2031609	NZA_EMS_4.41_4.60	2022-05-21 22:46:29.57+08	42	1	1
2031610	NZA_EMS_4.61_4.80	2022-05-21 22:46:30.288+08	42	1	1
2031611	NZA_EMS_4.81_5.00	2022-05-21 22:46:31.064+08	42	1	1
2031612	NZA_EMS_5.01_5.20	2022-05-21 22:46:32.029+08	42	1	1
2031613	NZA_EMS_5.21_5.40	2022-05-21 22:46:32.847+08	42	1	1
2031614	NZA_EMS_5.41_5.60	2022-05-21 22:46:33.667+08	42	1	1
2031615	NZA_EMS_5.61_5.80	2022-05-21 22:46:34.694+08	42	1	1
2031616	NZA_EMS_5.81_6.00	2022-05-21 22:46:35.41+08	42	1	1
2031617	NZA_EMS_6.01_6.20	2022-05-21 22:46:36.127+08	42	1	1
2031618	NZA_EMS_6.21_6.40	2022-05-21 22:46:36.943+08	42	1	1
2031619	NZA_EMS_6.41_6.60	2022-05-21 22:46:37.662+08	42	1	1
2031620	NZA_EMS_6.61_6.80	2022-05-21 22:46:38.685+08	42	1	1
2031621	NZA_EMS_6.81_7.00	2022-05-21 22:46:39.731+08	42	1	1
2031622	NZA_EMS_7.01_7.20	2022-05-21 22:46:40.531+08	42	1	1
2031623	NZA_EMS_7.21_7.40	2022-05-21 22:46:41.279+08	42	1	1
2031624	NZA_EMS_7.41_7.60	2022-05-21 22:46:42.064+08	42	1	1
2031625	NZA_EMS_7.61_7.80	2022-05-21 22:46:42.882+08	42	1	1
2031626	NZA_EMS_7.81_8.00	2022-05-21 22:46:43.678+08	42	1	1
2031627	NZA_EMS_8.01_8.20	2022-05-21 22:46:44.54+08	42	1	1
2031628	NZA_EMS_8.21_8.40	2022-05-21 22:46:45.34+08	42	1	1
2031629	NZA_EMS_8.41_8.60	2022-05-21 22:46:46.159+08	42	1	1
2031630	NZA_EMS_8.61_8.80	2022-05-21 22:46:46.979+08	42	1	1
2031631	NZA_EMS_8.81_9.00	2022-05-21 22:46:47.796+08	42	1	1
2031632	NZA_EMS_9.01_9.20	2022-05-21 22:46:48.514+08	42	1	1
2031633	NZA_EMS_9.21_9.40	2022-05-21 22:46:49.246+08	42	1	1
2031634	NZA_EMS_9.41_9.60	2022-05-21 22:46:50.05+08	42	1	1
2031635	NZA_EMS_9.61_9.80	2022-05-21 22:46:50.867+08	42	1	1
2031636	NZA_EMS_9.81_10.00	2022-05-21 22:46:51.694+08	42	1	1
2031637	NZA_EMS_10.01_10.20	2022-05-21 22:46:52.509+08	42	1	1
2031638	NZA_EMS_10.21_10.40	2022-05-21 22:46:53.202+08	42	1	1
2031639	NZA_EMS_10.41_10.60	2022-05-21 22:46:53.941+08	42	1	1
2031640	NZA_EMS_10.61_10.80	2022-05-21 22:46:54.732+08	42	1	1
2031641	NZA_EMS_10.81_11.00	2022-05-21 22:46:55.543+08	42	1	1
2031642	NZA_EMS_11.01_11.20	2022-05-21 22:46:56.398+08	42	1	1
2031643	NZA_EMS_11.21_11.40	2022-05-21 22:46:57.223+08	42	1	1
2031644	NZA_EMS_11.41_11.60	2022-05-21 22:46:58.042+08	42	1	1
2031645	NZA_EMS_11.61_11.80	2022-05-21 22:46:58.755+08	42	1	1
2031646	NZA_EMS_11.81_12.00	2022-05-21 22:46:59.582+08	42	1	1
2031647	NZA_EMS_12.01_12.20	2022-05-21 22:47:00.493+08	42	1	1
2031648	NZA_EMS_12.21_12.40	2022-05-21 22:47:01.312+08	42	1	1
2031649	NZA_EMS_12.41_12.60	2022-05-21 22:47:02.132+08	42	1	1
2031650	NZA_EMS_12.61_12.80	2022-05-21 22:47:02.952+08	42	1	1
2031651	NZA_EMS_12.81_13.00	2022-05-21 22:47:03.678+08	42	1	1
2031652	NZA_EMS_13.01_13.20	2022-05-21 22:47:04.384+08	42	1	1
2031653	NZA_EMS_13.21_13.40	2022-05-21 22:47:05.206+08	42	1	1
2031654	NZA_EMS_13.41_13.60	2022-05-21 22:47:05.934+08	42	1	1
2031655	NZA_EMS_13.61_13.80	2022-05-21 22:47:06.675+08	42	1	1
2031656	NZA_EMS_13.81_14.00	2022-05-21 22:47:07.348+08	42	1	1
2031657	NZA_EMS_14.01_14.20	2022-05-21 22:47:08.174+08	42	1	1
2031658	NZA_EMS_14.21_14.40	2022-05-21 22:47:09.097+08	42	1	1
2031659	NZA_EMS_14.41_14.60	2022-05-21 22:47:09.915+08	42	1	1
2031660	NZA_EMS_14.61_14.80	2022-05-21 22:47:10.734+08	42	1	1
2031661	NZA_EMS_14.81_15.00	2022-05-21 22:47:11.496+08	42	1	1
2031662	NZA_EMS_15.01_15.20	2022-05-21 22:47:12.375+08	42	1	1
2031663	NZA_EMS_15.21_15.40	2022-05-21 22:47:13.192+08	42	1	1
2031664	NZA_EMS_15.41_15.60	2022-05-21 22:47:13.975+08	42	1	1
2031665	NZA_EMS_15.61_15.80	2022-05-21 22:47:14.726+08	42	1	1
2031666	NZA_EMS_15.81_16.00	2022-05-21 22:47:15.462+08	42	1	1
2031667	NZA_EMS_16.01_16.20	2022-05-21 22:47:16.184+08	42	1	1
2031668	NZA_EMS_16.21_16.40	2022-05-21 22:47:16.98+08	42	1	1
2031669	NZA_EMS_16.41_16.60	2022-05-21 22:47:17.727+08	42	1	1
2031670	NZA_EMS_16.61_16.80	2022-05-21 22:47:18.514+08	42	1	1
2031671	NZA_EMS_16.81_17.00	2022-05-21 22:47:19.333+08	42	1	1
2031672	NZA_EMS_17.01_17.20	2022-05-21 22:47:20.156+08	42	1	1
2031673	NZA_EMS_17.21_17.40	2022-05-21 22:47:20.896+08	42	1	1
2031674	NZA_EMS_17.41_17.60	2022-05-21 22:47:21.602+08	42	1	1
2031675	NZA_EMS_17.61_17.80	2022-05-21 22:47:22.406+08	42	1	1
2031676	NZA_EMS_17.81_18.00	2022-05-21 22:47:23.148+08	42	1	1
2031677	NZA_EMS_18.01_18.20	2022-05-21 22:47:23.913+08	42	1	1
2031678	NZA_EMS_18.21_18.40	2022-05-21 22:47:24.683+08	42	1	1
2031679	NZA_EMS_18.41_18.60	2022-05-21 22:47:25.67+08	42	1	1
2031680	NZA_EMS_18.61_18.80	2022-05-21 22:47:26.43+08	42	1	1
2031681	NZA_EMS_18.81_19.00	2022-05-21 22:47:27.325+08	42	1	1
2031682	NZA_EMS_19.01_19.20	2022-05-21 22:47:28.298+08	42	1	1
2031683	NZA_EMS_19.21_19.40	2022-05-21 22:47:29.067+08	42	1	1
2031684	NZA_EMS_19.41_19.60	2022-05-21 22:47:29.882+08	42	1	1
2031685	NZA_EMS_19.61_19.80	2022-05-21 22:47:30.702+08	42	1	1
2031686	NZA_EMS_19.81_20.00	2022-05-21 22:47:31.428+08	42	1	1
2031687	NZA_EMS_20.01_20.20	2022-05-21 22:47:32.579+08	42	1	1
2031688	NZA_EMS_20.21_20.40	2022-05-21 22:47:33.324+08	42	1	1
2031689	NZA_EMS_20.41_20.60	2022-05-21 22:47:34.082+08	42	1	1
2031690	NZA_EMS_20.61_20.80	2022-05-21 22:47:34.899+08	42	1	1
2031691	NZA_EMS_20.81_21.00	2022-05-21 22:47:35.718+08	42	1	1
2031692	NZA_EMS_21.01_21.20	2022-05-21 22:47:36.633+08	42	1	1
2031693	NZA_EMS_21.21_21.40	2022-05-21 22:47:37.46+08	42	1	1
2031694	NZA_EMS_21.41_21.60	2022-05-21 22:47:38.994+08	42	1	1
2031695	NZA_EMS_21.61_21.80	2022-05-21 22:47:39.722+08	42	1	1
2031696	NZA_EMS_21.81_22.00	2022-05-21 22:47:40.632+08	42	1	1
2031697	NZA_EMS_22.01_22.20	2022-05-21 22:47:41.454+08	42	1	1
2031698	NZA_EMS_22.21_22.40	2022-05-21 22:47:42.211+08	42	1	1
2031699	NZA_EMS_22.41_22.60	2022-05-21 22:47:42.977+08	42	1	1
2031700	NZA_EMS_22.61_22.80	2022-05-21 22:47:43.705+08	42	1	1
2031701	NZA_EMS_22.81_23.00	2022-05-21 22:47:44.558+08	42	1	1
2031702	NZA_EMS_23.01_23.20	2022-05-21 22:47:45.35+08	42	1	1
2031703	NZA_EMS_23.21_23.40	2022-05-21 22:47:46.218+08	42	1	1
2031704	NZA_EMS_23.41_23.60	2022-05-21 22:47:46.95+08	42	1	1
2031705	NZA_EMS_23.61_23.80	2022-05-21 22:47:47.8+08	42	1	1
2031706	NZA_EMS_23.81_24.00	2022-05-21 22:47:48.639+08	42	1	1
2031707	NZA_EMS_24.01_24.20	2022-05-21 22:47:49.442+08	42	1	1
2031708	NZA_EMS_24.21_24.40	2022-05-21 22:47:50.164+08	42	1	1
2031709	NZA_EMS_24.41_24.60	2022-05-21 22:47:51.077+08	42	1	1
2031710	NZA_EMS_24.61_24.80	2022-05-21 22:47:51.818+08	42	1	1
2031711	NZA_EMS_24.81_25.00	2022-05-21 22:47:52.922+08	42	1	1
2031712	NZA_EMS_25.01_25.20	2022-05-21 22:47:53.664+08	42	1	1
2031713	NZA_EMS_25.21_25.40	2022-05-21 22:47:54.429+08	42	1	1
2031714	NZA_EMS_25.41_25.60	2022-05-21 22:47:55.175+08	42	1	1
2031715	NZA_EMS_25.61_25.80	2022-05-21 22:47:56.198+08	42	1	1
2031716	NZA_EMS_25.81_26.00	2022-05-21 22:47:57.939+08	42	1	1
2031717	NZA_EMS_26.01_26.20	2022-05-21 22:47:59.066+08	42	1	1
2031718	NZA_EMS_26.21_26.40	2022-05-21 22:47:59.888+08	42	1	1
2031719	NZA_EMS_26.41_26.60	2022-05-21 22:48:01.215+08	42	1	1
2031720	NZA_EMS_26.61_26.80	2022-05-21 22:48:01.966+08	42	1	1
2031721	NZA_EMS_26.81_27.00	2022-05-21 22:48:03.366+08	42	1	1
2031722	NZA_EMS_27.01_27.20	2022-05-21 22:48:04.102+08	42	1	1
2031723	NZA_EMS_27.21_27.40	2022-05-21 22:48:04.911+08	42	1	1
2031724	NZA_EMS_27.41_27.60	2022-05-21 22:48:05.822+08	42	1	1
2031725	NZA_EMS_27.61_27.80	2022-05-21 22:48:06.643+08	42	1	1
2031726	NZA_EMS_27.81_28.00	2022-05-21 22:48:07.39+08	42	1	1
2031727	NZA_EMS_28.01_28.20	2022-05-21 22:48:08.178+08	42	1	1
2031728	NZA_EMS_28.21_28.40	2022-05-21 22:48:08.947+08	42	1	1
2031729	NZA_EMS_28.41_28.60	2022-05-21 22:48:09.737+08	42	1	1
2031730	NZA_EMS_28.61_28.80	2022-05-21 22:48:10.946+08	42	1	1
2031731	NZA_EMS_28.81_29.00	2022-05-21 22:48:11.699+08	42	1	1
2031732	NZA_EMS_29.01_29.20	2022-05-21 22:48:12.588+08	42	1	1
2031733	NZA_EMS_29.21_29.40	2022-05-21 22:48:13.4+08	42	1	1
2031734	NZA_EMS_29.41_29.60	2022-05-21 22:48:14.221+08	42	1	1
2031735	NZA_EMS_29.61_29.80	2022-05-21 22:48:15.046+08	42	1	1
2031736	NZA_EMS_29.81_30.00	2022-05-21 22:48:15.859+08	42	1	1
2031737	NZA_EMSMPB_0.01_0.20	2022-05-21 22:48:16.678+08	42	1	1
2031738	NZA_EMSMPB_0.21_0.40	2022-05-21 22:48:17.496+08	42	1	1
2031739	NZA_EMSMPB_0.41_0.60	2022-05-21 22:48:18.316+08	42	1	1
2031740	NZA_EMSMPB_0.61_0.80	2022-05-21 22:48:19.134+08	42	1	1
2031741	NZA_EMSMPB_0.81_1.00	2022-05-21 22:48:19.899+08	42	1	1
2031742	NZA_EMSMPB_1.01_1.20	2022-05-21 22:48:20.777+08	42	1	1
2031743	NZA_EMSMPB_1.21_1.40	2022-05-21 22:48:21.596+08	42	1	1
2031744	NZA_EMSMPB_1.41_1.60	2022-05-21 22:48:22.41+08	42	1	1
2031745	NZA_EMSMPB_1.61_1.80	2022-05-21 22:48:23.17+08	42	1	1
2031746	NZA_EMSMPB_1.81_2.00	2022-05-21 22:48:24.05+08	42	1	1
2031747	NZA_EMSMPB_2.01_2.20	2022-05-21 22:48:24.871+08	42	1	1
2031748	NZA_EMSMPB_2.21_2.40	2022-05-21 22:48:25.689+08	42	1	1
2031749	NZA_EMSMPB_2.41_2.60	2022-05-21 22:48:26.507+08	42	1	1
2031750	NZA_EMSMPB_2.61_2.80	2022-05-21 22:48:27.271+08	42	1	1
2031751	NZA_EMSMPB_2.81_3.00	2022-05-21 22:48:28.042+08	42	1	1
2031752	NZA_EMSMPB_3.01_3.20	2022-05-21 22:48:28.965+08	42	1	1
2031753	NZA_EMSMPB_3.21_3.40	2022-05-21 22:48:29.782+08	42	1	1
2031754	NZA_EMSMPB_3.41_3.60	2022-05-21 22:48:30.602+08	42	1	1
2031755	NZA_EMSMPB_3.61_3.80	2022-05-21 22:48:31.424+08	42	1	1
2031756	NZA_EMSMPB_3.81_4.00	2022-05-21 22:48:32.242+08	42	1	1
2031757	NZA_EMSMPB_4.01_4.20	2022-05-21 22:48:33.061+08	42	1	1
2031758	NZA_EMSMPB_4.21_4.40	2022-05-21 22:48:33.814+08	42	1	1
2031759	NZA_EMSMPB_4.41_4.60	2022-05-21 22:48:34.701+08	42	1	1
2031760	NZA_EMSMPB_4.61_4.80	2022-05-21 22:48:35.52+08	42	1	1
2031761	NZA_EMSMPB_4.81_5.00	2022-05-21 22:48:36.332+08	42	1	1
2031762	NZA_EMSMPB_5.01_5.20	2022-05-21 22:48:37.158+08	42	1	1
2031763	NZA_EMSMPB_5.21_5.40	2022-05-21 22:48:37.977+08	42	1	1
2031764	NZA_EMSMPB_5.41_5.60	2022-05-21 22:48:38.795+08	42	1	1
2031765	NZA_EMSMPB_5.61_5.80	2022-05-21 22:48:39.614+08	42	1	1
2031766	NZA_EMSMPB_5.81_6.00	2022-05-21 22:48:40.432+08	42	1	1
2031767	NZA_EMSMPB_6.01_6.20	2022-05-21 22:48:41.253+08	42	1	1
2031768	NZA_EMSMPB_6.21_6.40	2022-05-21 22:48:42.07+08	42	1	1
2031769	NZA_EMSMPB_6.41_6.60	2022-05-21 22:48:42.89+08	42	1	1
2031770	NZA_EMSMPB_6.61_6.80	2022-05-21 22:48:43.711+08	42	1	1
2031771	NZA_EMSMPB_6.81_7.00	2022-05-21 22:48:44.449+08	42	1	1
2031772	NZA_EMSMPB_7.01_7.20	2022-05-21 22:48:45.252+08	42	1	1
2031773	NZA_EMSMPB_7.21_7.40	2022-05-21 22:48:46.168+08	42	1	1
2031774	NZA_EMSMPB_7.41_7.60	2022-05-21 22:48:47.294+08	42	1	1
2031775	NZA_EMSMPB_7.61_7.80	2022-05-21 22:48:48.114+08	42	1	1
2031776	NZA_EMSMPB_7.81_8.00	2022-05-21 22:48:48.938+08	42	1	1
2031777	NZA_EMSMPB_8.01_8.20	2022-05-21 22:48:49.855+08	42	1	1
2031778	NZA_EMSMPB_8.21_8.40	2022-05-21 22:48:50.672+08	42	1	1
2031779	NZA_EMSMPB_8.41_8.60	2022-05-21 22:48:51.491+08	42	1	1
2031780	NZA_EMSMPB_8.61_8.80	2022-05-21 22:48:52.519+08	42	1	1
2031781	NZA_EMSMPB_8.81_9.00	2022-05-21 22:48:53.437+08	42	1	1
2031782	NZA_EMSMPB_9.01_9.20	2022-05-21 22:48:54.464+08	42	1	1
2031783	NZA_EMSMPB_9.21_9.40	2022-05-21 22:48:55.302+08	42	1	1
2031784	NZA_EMSMPB_9.41_9.60	2022-05-21 22:48:56.106+08	42	1	1
2031785	NZA_EMSMPB_9.61_9.80	2022-05-21 22:48:57.024+08	42	1	1
2031786	NZA_EMSMPB_9.81_10.00	2022-05-21 22:48:57.849+08	42	1	1
2031787	NZA_EMSMPB_10.01_10.20	2022-05-21 22:48:58.646+08	42	1	1
2031788	NZA_EMSMPB_10.21_10.40	2022-05-21 22:48:59.614+08	42	1	1
2031789	NZA_EMSMPB_10.41_10.60	2022-05-21 22:49:00.714+08	42	1	1
2031790	NZA_EMSMPB_10.61_10.80	2022-05-21 22:49:01.64+08	42	1	1
2031791	NZA_EMSMPB_10.81_11.00	2022-05-21 22:49:02.432+08	42	1	1
2031792	NZA_EMSMPB_11.01_11.20	2022-05-21 22:49:03.27+08	42	1	1
2031793	NZA_EMSMPB_11.21_11.40	2022-05-21 22:49:04.19+08	42	1	1
2031794	NZA_EMSMPB_11.41_11.60	2022-05-21 22:49:05.009+08	42	1	1
2031795	NZA_EMSMPB_11.61_11.80	2022-05-21 22:49:05.799+08	42	1	1
2031796	NZA_EMSMPB_11.81_12.00	2022-05-21 22:49:06.748+08	42	1	1
2031797	NZA_EMSMPB_12.01_12.20	2022-05-21 22:49:07.568+08	42	1	1
2031798	NZA_EMSMPB_12.21_12.40	2022-05-21 22:49:08.388+08	42	1	1
2031799	NZA_EMSMPB_12.41_12.60	2022-05-21 22:49:09.386+08	42	1	1
2031800	NZA_EMSMPB_12.61_12.80	2022-05-21 22:49:10.436+08	42	1	1
2031801	NZA_EMSMPB_12.81_13.00	2022-05-21 22:49:11.56+08	42	1	1
2031802	NZA_EMSMPB_13.01_13.20	2022-05-21 22:49:12.485+08	42	1	1
2031803	NZA_EMSMPB_13.21_13.40	2022-05-21 22:49:13.509+08	42	1	1
2031804	NZA_EMSMPB_13.41_13.60	2022-05-21 22:49:14.327+08	42	1	1
2031805	NZA_EMSMPB_13.61_13.80	2022-05-21 22:49:15.146+08	42	1	1
2031806	NZA_EMSMPB_13.81_14.00	2022-05-21 22:49:15.954+08	42	1	1
2031807	NZA_EMSMPB_14.01_14.20	2022-05-21 22:49:16.889+08	42	1	1
2031808	NZA_EMSMPB_14.21_14.40	2022-05-21 22:49:17.683+08	42	1	1
2031809	NZA_EMSMPB_14.41_14.60	2022-05-21 22:49:18.524+08	42	1	1
2031810	NZA_EMSMPB_14.61_14.80	2022-05-21 22:49:19.349+08	42	1	1
2031811	NZA_EMSMPB_14.81_15.00	2022-05-21 22:49:20.164+08	42	1	1
2031812	NZA_EMSMPB_15.01_15.20	2022-05-21 22:49:20.898+08	42	1	1
2031813	NZA_EMSMPB_15.21_15.40	2022-05-21 22:49:21.801+08	42	1	1
2031814	NZA_EMSMPB_15.41_15.60	2022-05-21 22:49:22.622+08	42	1	1
2031815	NZA_EMSMPB_15.61_15.80	2022-05-21 22:49:23.439+08	42	1	1
2031816	NZA_EMSMPB_15.81_16.00	2022-05-21 22:49:24.258+08	42	1	1
2031817	NZA_EMSMPB_16.01_16.20	2022-05-21 22:49:25.088+08	42	1	1
2031818	NZA_EMSMPB_16.21_16.40	2022-05-21 22:49:25.924+08	42	1	1
2031819	NZA_EMSMPB_16.41_16.60	2022-05-21 22:49:26.682+08	42	1	1
2031820	NZA_EMSMPB_16.61_16.80	2022-05-21 22:49:27.444+08	42	1	1
2031821	NZA_EMSMPB_16.81_17.00	2022-05-21 22:49:28.255+08	42	1	1
2031822	NZA_EMSMPB_17.01_17.20	2022-05-21 22:49:29.174+08	42	1	1
2031823	NZA_EMSMPB_17.21_17.40	2022-05-21 22:49:29.995+08	42	1	1
2031824	NZA_EMSMPB_17.41_17.60	2022-05-21 22:49:30.821+08	42	1	1
2031825	NZA_EMSMPB_17.61_17.80	2022-05-21 22:49:31.632+08	42	1	1
2031826	NZA_EMSMPB_17.81_18.00	2022-05-21 22:49:32.45+08	42	1	1
2031827	NZA_EMSMPB_18.01_18.20	2022-05-21 22:49:33.27+08	42	1	1
2031828	NZA_EMSMPB_18.21_18.40	2022-05-21 22:49:34.09+08	42	1	1
2031829	NZA_EMSMPB_18.41_18.60	2022-05-21 22:49:34.871+08	42	1	1
2031830	NZA_EMSMPB_18.61_18.80	2022-05-21 22:49:35.728+08	42	1	1
2031831	NZA_EMSMPB_18.81_19.00	2022-05-21 22:49:36.753+08	42	1	1
2031832	NZA_EMSMPB_19.01_19.20	2022-05-21 22:49:37.572+08	42	1	1
2031833	NZA_EMSMPB_19.21_19.40	2022-05-21 22:49:38.341+08	42	1	1
2031834	NZA_EMSMPB_19.41_19.60	2022-05-21 22:49:39.21+08	42	1	1
2031835	NZA_EMSMPB_19.61_19.80	2022-05-21 22:49:40.05+08	42	1	1
2031836	NZA_EMSMPB_19.81_20.00	2022-05-21 22:49:40.85+08	42	1	1
2031837	NZA_EMSMPB_20.01_20.20	2022-05-21 22:49:41.693+08	42	1	1
2031838	NZA_EMSMPB_20.21_20.40	2022-05-21 22:49:42.692+08	42	1	1
2031839	NZA_EMSMPB_20.41_20.60	2022-05-21 22:49:43.512+08	42	1	1
2031840	NZA_EMSMPB_20.61_20.80	2022-05-21 22:49:44.329+08	42	1	1
2031841	NZA_EMSMPB_20.81_21.00	2022-05-21 22:49:45.213+08	42	1	1
2031842	NZA_EMSMPB_21.01_21.20	2022-05-21 22:49:46.173+08	42	1	1
2031843	NZA_EMSMPB_21.21_21.40	2022-05-21 22:49:46.994+08	42	1	1
2031844	NZA_EMSMPB_21.41_21.60	2022-05-21 22:49:48.017+08	42	1	1
2031845	NZA_EMSMPB_21.61_21.80	2022-05-21 22:49:48.8+08	42	1	1
2031846	NZA_EMSMPB_21.81_22.00	2022-05-21 22:49:49.656+08	42	1	1
2031847	NZA_EMSMPB_22.01_22.20	2022-05-21 22:49:50.661+08	42	1	1
2031848	NZA_EMSMPB_22.21_22.40	2022-05-21 22:49:51.498+08	42	1	1
2031849	NZA_EMSMPB_22.41_22.60	2022-05-21 22:49:52.298+08	42	1	1
2031850	NZA_EMSMPB_22.61_22.80	2022-05-21 22:49:53.341+08	42	1	1
2031851	NZA_EMSMPB_22.81_23.00	2022-05-21 22:49:54.159+08	42	1	1
2031852	NZA_EMSMPB_23.01_23.20	2022-05-21 22:49:54.978+08	42	1	1
2031853	NZA_EMSMPB_23.21_23.40	2022-05-21 22:49:55.798+08	42	1	1
2031854	NZA_EMSMPB_23.41_23.60	2022-05-21 22:49:56.572+08	42	1	1
2031855	NZA_EMSMPB_23.61_23.80	2022-05-21 22:49:57.446+08	42	1	1
2031856	NZA_EMSMPB_23.81_24.00	2022-05-21 22:49:58.225+08	42	1	1
2031857	NZA_EMSMPB_24.01_24.20	2022-05-21 22:49:59.075+08	42	1	1
2031858	NZA_EMSMPB_24.21_24.40	2022-05-21 22:49:59.977+08	42	1	1
2031859	NZA_EMSMPB_24.41_24.60	2022-05-21 22:50:01.125+08	42	1	1
2031860	NZA_EMSMPB_24.61_24.80	2022-05-21 22:50:02.148+08	42	1	1
2031861	NZA_EMSMPB_24.81_25.00	2022-05-21 22:50:02.968+08	42	1	1
2031862	NZA_EMSMPB_25.01_25.20	2022-05-21 22:50:03.99+08	42	1	1
2031863	NZA_EMSMPB_25.21_25.40	2022-05-21 22:50:04.815+08	42	1	1
2031864	NZA_EMSMPB_25.41_25.60	2022-05-21 22:50:05.63+08	42	1	1
2031865	NZA_EMSMPB_25.61_25.80	2022-05-21 22:50:06.448+08	42	1	1
2031866	NZA_EMSMPB_25.81_26.00	2022-05-21 22:50:07.268+08	42	1	1
2031867	NZA_EMSMPB_26.01_26.20	2022-05-21 22:50:08.155+08	42	1	1
2031868	NZA_EMSMPB_26.21_26.40	2022-05-21 22:50:09.005+08	42	1	1
2031869	NZA_EMSMPB_26.41_26.60	2022-05-21 22:50:09.791+08	42	1	1
2031870	NZA_EMSMPB_26.61_26.80	2022-05-21 22:50:10.712+08	42	1	1
2031871	NZA_EMSMPB_26.81_27.00	2022-05-21 22:50:11.566+08	42	1	1
2031872	NZA_EMSMPB_27.01_27.20	2022-05-21 22:50:12.425+08	42	1	1
2031873	NZA_EMSMPB_27.21_27.40	2022-05-21 22:50:13.353+08	42	1	1
2031874	NZA_EMSMPB_27.41_27.60	2022-05-21 22:50:14.283+08	42	1	1
2031875	NZA_EMSMPB_27.61_27.80	2022-05-21 22:50:15.255+08	42	1	1
2031876	NZA_EMSMPB_27.81_28.00	2022-05-21 22:50:16.098+08	42	1	1
2031877	NZA_EMSMPB_28.01_28.20	2022-05-21 22:50:16.993+08	42	1	1
2031878	NZA_EMSMPB_28.21_28.40	2022-05-21 22:50:17.915+08	42	1	1
2031879	NZA_EMSMPB_28.41_28.60	2022-05-21 22:50:18.945+08	42	1	1
2031880	NZA_EMSMPB_28.61_28.80	2022-05-21 22:50:19.761+08	42	1	1
2031881	NZA_EMSMPB_28.81_29.00	2022-05-21 22:50:20.786+08	42	1	1
2031882	NZA_EMSMPB_29.01_29.20	2022-05-21 22:50:21.705+08	42	1	1
2031883	NZA_EMSMPB_29.21_29.40	2022-05-21 22:50:22.627+08	42	1	1
2031884	NZA_EMSMPB_29.41_29.60	2022-05-21 22:50:23.446+08	42	1	1
2031885	NZA_EMSMPB_29.61_29.80	2022-05-21 22:50:24.343+08	42	1	1
2031886	NZA_EMSMPB_29.81_30.00	2022-05-21 22:50:25.312+08	42	1	1
2031888	43254232	2020-04-11 00:00:00+08	35	2	1
\.


--
-- Data for Name: product_attr_lcl; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.product_attr_lcl (prd_lcl_id, prd_id, prd_desc, prd_img_pth, lcl_cd, prd_lng_desc) FROM stdin;
233276	233275	High Class See through Rose Packaging box (Leather paper)	30833030_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233283	233282	High Class See through Rose Packaging box ( Plastic)	30833031_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
21	11	capsicum	capsicum.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233290	233289	Korean Big White Flowers pretty Earrings 	30833032_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233297	233296	Korean Fashion Stripey Hairband	30833033_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233304	233303	Heart Shaped Earrings 	30833034_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233311	233310	Vintage Beige and Black Hair Clip with gold colour logo 	30833035_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233318	233317	S925 needle Korean Big Pearly dingle Earrings 	30833036_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233325	233324	S925 needle Korean Spaceman Big Moon Earrings 	30833037_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233332	233331	Korea Cute Fried Egg Necklace 	30833038_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233339	233338	Waterproof Outer Blue Makeup Wallet pouch 18x12cm	30833039_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233346	233345	Single Flower Clover Cosmos Necklace	30833040_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233353	233352	Rainbow colour smiley face flower Earrings 	30833041_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233360	233359	Korean Smiley face on pearly white shell Earrings 	30833042_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233367	233366	Happy Yellow Flowers Clip On Earrings	30833043_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233374	233373	Happy Green Flowers Clip On Earrings	30833044_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233381	233380	Korean white tea flower elegant pearls and crystals Earrings 	30833045_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233388	233387	Korean sweet pink ribbon bunny rabbit Earrings	30833046_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233395	233394	Pretty Girl Hair Sticker 	30833047_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233402	233401	Multicolour flower Hair Bobbles 	30833048_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233409	233408	Scottish Hendoz Multi purpose Navy Blue with white dots Crossbody Bag	30833049_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233416	233415	Scottish Hendoz Multi purpose Black with pink dots Crossbody Bag	30833050_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233423	233422	Scottish Hendoz Multi purpose Pink with green dots Crossbody Bag	30833051_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233430	233429	LBS Brown small Crossbody Bag	30833052_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233437	233436	LBS Brown wallet Clip Bag	30833029_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233444	233443	Korean Cute White Rabbit FlipFlops (EU37) 	30833053_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233451	233450	Korean Slim Waist Bag Fanny Pack (White) 	30833054_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233458	233457	White 4cm Platform Slipons	30833055_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233465	233464	Unisex Korean Black Sport BackPack	30833056_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233472	233471	Unisex Purple Sporty Student Postman Crossbody Bag	30833057_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233479	233478	Unisex Black Sporty Student Postman Crossbody Bag	30833058_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233486	233485	Black with White Text Bump Bag (Mens) 	30833059_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233493	233492	Black with Gold Text Bump Bag (Mens) 	30833060_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233500	233499	Multi purpose Black checkered patten BackPack	30833061_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233507	233506	Japanese Sukura Pretty Mama Blue background Crossbody Bag	30833062_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233514	233513	Japanese Sukura Pretty Mama Purple background Crossbody Bag	30833063_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233521	233520	Oxford Bag Pretty Mama Crossbody Bag (Black) 	30833064_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233528	233527	Oxford Bag Pretty Mama Crossbody Bag (Navy Blue)	30833065_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233535	233534	Pink Hearts Pretty Wallet 	30833066_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233542	233541	A4 Sized zipped with handle File Pocket (Farting bear) 	30833067_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233549	233548	A4 Sized zipped with handle File Pocket (Blue pigs) 	30833068_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233556	233555	A4 Sized zipped with handle File Pocket (Pink pig) 	30833069_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233563	233562	A6 sized zipped pink bunny Pen Bag 	30833070_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233570	233569	A6 sized zipped yellow duckling Pen Bag 	30833071_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233577	233576	Chic Sporty Hobo underarm Bag (Black) 	30833072_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233584	233583	Circle Carpet (Black) 	30833073_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233591	233590	Circle Carpet (Pink) 	30833074_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233598	233597	Little Mouse Waterproof PU material Bump Bag (White) 	30833075_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233605	233604	Little Mouse Waterproof PU material Cylinder Bag (Brown) 	30833076_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233612	233611	Black mobile pouch with gold square twist lock 	30833077_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233619	233618	Black Phone Cover 	30833078_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233626	233625	Coin Wallet With Zips ( can fit cards and coins) 	30833079_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233633	233632	Small D Simple Wallet 	30833080_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233640	233639	VC Lucky Flower Earrings ( Silver with white pearly shells) 	30833081_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233647	233646	Busy Bee Red Wallet 	30833082_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233654	233653	Busy Bee Green Wallet 	30833083_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233661	233660	Brown mobile pouch with gold square twist lock 	30833084_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233668	233667	Red mobile pouch with gold square twist lock 	30833085_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233675	233674	HAPPYLEAF Unisex multi colour pure cotton sport socks (gift pack of 5 pairs) 	30833086_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233682	233681	HAPPYLEAF F* OFF Slippers (White) 	30833087_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233689	233688	HAPPYLEAF F* OFF Slippers (Black) 	30833088_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233696	233695	Korean Style Pink Flat Slippers 	30833089_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233703	233702	Hurry Up "On my way" Red and Black Crossbody Bag	30833090_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233710	233709	HAPPYLEAR Unisex White with happy green leaf BackPack  	30833091_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233717	233716	Elegant Beach Off white flowers Flipflop 	30833092_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233724	233723	Little Mouse Waterproof PU material LIttle Tote Bag	30833093_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233731	233730	HAPPYLEAF Unisex White with happy green leaf Crossbody Bag	30833094_1.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
27	14	Pumpkin	pumpkin.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
39	20	Musk Melon	musk-melon.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
33	17	Apple	apple.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
13	7	carrot	carrots.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
233349	233345	靚靚斯文小小四葉花氣質鎖骨項鏈	30833040_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
23	12	mushroom	button-mushroom.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
57	29	Cashews	cashews.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
59	30	Walnuts	walnuts.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
55	28	Nuts Mixture	nuts-mixture.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
3	2	orange	orange.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
29	15	Corn	corn.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
19	10	brinjal	brinjal.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
53	27	Pistachio	pistachio.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
41	21	Pears	pears.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
51	26	Almonds	almonds.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
47	24	Strawberry	strawberry.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
49	25	Water Melon	water-melon.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
31	16	Onion	onion.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
11	6	beetroot	beetroot.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
43	22	Pomegranate	pomegranate.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
45	23	RaspberryDan	raspberry.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
5	3	brocolli	broccoli.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
17	9	beans	beans.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
7	4	cauliflower	cauliflower.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
25	13	potato	potato.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
35	18	Banana	banana.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
37	19	Grapes	grapes.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
15	8	tomato	tomato.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
1	1	mango	mango.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
9	5	cucumber	cucumber.jpg	en-GB	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Itaque obcaecati tempore reiciendis neque facere! Eos, necessitatibus? Fugit iure veritatis quidem velit quaerat quos qui pariatur dolore facilis, aliquid quae voluptatibus dicta. Quae harum velit hic molestias, eius ab cum quidem voluptates modi maiores laboriosam iusto excepturi ex, recusandae aut, facere earum ad vero aperiam. Minima dolores dignissimos ab ipsam atque placeat sapiente officia debitis nobis porro at quia veritatis, quidem id repudiandae ex tempore non. Enim soluta explicabo atque adipisci itaque.
22	11	辣椒	capsicum.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233279	233275	高檔花盒透明玫瑰花禮盒 ( 高質皮紙) 	30833030_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233286	233282	高檔花盒透明玫瑰花禮盒 (高質膠)	30833031_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233293	233289	韓國大白茶花精緻耳環	30833032_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233300	233296	韓國時尚條紋頭箍	30833033_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233307	233303	心形耳環	30833034_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233314	233310	古代小香奶茶色髮夾	30833035_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233321	233317	S925銀針韓國優雅復古珍珠耳環	30833036_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233328	233324	S925銀針宇宙大空人月亮耳環	30833037_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233335	233331	愛心大煎蛋項鏈(如圖包鏈) 	30833038_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233342	233338	防水藍色18x12cm化妝袋,銀包仔	30833039_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233356	233352	彩虹花花開心笑耳環	30833041_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233363	233359	韓國開心笑珍珠貝耳環	30833042_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233370	233366	開心大向日葵花花耳夾	30833043_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233377	233373	開心大綠花耳夾	30833044_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233384	233380	韓國白茶花配水晶珍珠氣質仙女耳環	30833045_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233391	233387	韓國甜美花朵蝴蝶可愛兔仔耳環	30833046_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233398	233394	可愛美少女頭髮貼可愛	30833047_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233405	233401	韓國可愛花花頭髮橡筋	30833048_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233412	233408	新款蘇格蘭亨多斯深藍色多用途斜孭包 	30833049_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233419	233415	新款蘇格蘭亨多斯黑色多用途斜孭包 	30833050_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233426	233422	新款蘇格蘭亨多斯粉紅色多用途斜孭包 	30833051_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233433	233429	新款啡色LBS版休閒斜孭女包	30833052_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233440	233436	新款啡色LBS金扣休閒斜孭女包	30833029_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233447	233443	韓國可愛兔兔人字拖女室內室外(EU37)	30833053_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233454	233450	韓國多功能胸包	30833054_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233461	233457	韓國厚底4cm白色女拖鞋 (EU38)	30833055_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233468	233464	中性韓版黑色運動背包	30833056_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233475	233471	中性紫色運動學生郵差斜孭包	30833057_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233482	233478	中性黑色運動學生郵差斜孭包	30833058_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233489	233485	黑底白字男多功能胸包	30833059_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233496	233492	黑底金字男多功能胸包	30833060_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233503	233499	多用途黑色格紋背囊	30833061_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233510	233506	日式花紋靚靚媽咪斜孭袋(藍色)	30833062_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233517	233513	日式花紋靚靚媽咪斜孭袋(紫色)	30833063_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233524	233520	牛津布靚靚媽咪防水尼龍帆布多用途斜孭袋(黑色)	30833064_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233531	233527	牛津布靚靚媽咪防水尼龍帆布多用途斜孭袋(寶藍色)	30833065_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233538	233534	粉紅心心長銀包	30833066_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233545	233541	A4放屁大能拉鍊文件袋	30833067_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233552	233548	A4飛天豬仔拉鍊文件袋	30833068_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233559	233555	A4粉紅為食豬拉鍊文件袋	30833069_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233566	233562	A6粉紅小兔筆袋	30833070_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233573	233569	A6黃色小鴨筆袋	30833071_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233580	233576	少女運動腋下小手袋 (黑色)	30833072_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233587	233583	圓圈地毯 (黑色)	30833073_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233594	233590	圓圈地毯 (粉紅色)	30833074_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233601	233597	小老鼠防水PU腰包袋白色	30833075_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233608	233604	小老鼠防水PU圓筒包包袋啡色	30833076_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233615	233611	方形金扣PU手機袋(黑色)	30833077_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233622	233618	黑色手機套	30833078_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233629	233625	拉鏈錢Coin包	30833079_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233636	233632	小號D簡約錢包	30833080_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
54	27	開心果	pistachio.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233643	233639	VC 銀色配白色珍珠貝幸運花花耳環	30833081_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233650	233646	忙碌小的蜜蜂高貴紅色銀包	30833082_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233657	233653	忙碌小的蜜蜂高貴綠色銀包	30833083_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233664	233660	方形金扣PU手機袋(啡色)	30833084_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233671	233667	方形金扣PU手機袋(红色)	30833085_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233678	233674	HAPPYLEAF男女潮流襪純棉中筒運動襪 (禮盒5對裝)	30833086_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233685	233681	HAPPYLEAF男女潮流白色運動拖鞋	30833087_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233692	233688	HAPPYLEAF男女潮流黑色運動拖鞋	30833088_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233699	233695	粉紅色平底韓版女拖鞋	30833089_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233706	233702	快D 快 D "On my way" 红黑斜孭袋	30833090_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233713	233709	HAPPYLEAF中性男女運動背包囊	30833091_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233720	233716	高雅花花米白沙灘人字拖	30833092_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233727	233723	小老鼠防水PU小手袋	30833093_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233734	233730	HAPPYLEAF中性男女運動斜孭袋	30833094_1.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
28	14	南瓜	pumpkin.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
40	20	麝香甜瓜	musk-melon.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
34	17	蘋果	apple.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
14	7	胡萝卜	carrots.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
24	12	蘑菇	button-mushroom.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
58	29	腰果	cashews.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
60	30	核桃	walnuts.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
56	28	堅果混合物	nuts-mixture.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
4	2	橙子	orange.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
30	15	玉米	corn.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
20	10	茄子	brinjal.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
42	21	梨	pears.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
52	26	杏仁	almonds.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
48	24	草莓	strawberry.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
50	25	西瓜	water-melon.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
32	16	洋蔥	onion.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
12	6	红菜头	beetroot.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
44	22	石榴	pomegranate.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
46	23	覆盆子	raspberry.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
6	3	西兰花	broccoli.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
18	9	豆子	beans.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
8	4	菜花	cauliflower.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
26	13	土豆	potato.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
36	18	香蕉	banana.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
38	19	葡萄	grapes.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
16	8	番茄	tomato.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
2	1	芒果	mango.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
10	5	黄瓜	cucumber.jpg	zh-HK	疼痛本身，疼痛是在主要的脂肪過程中實施的。被時間拒絕或做事蒙蔽了雙眼！那些需求？他迴避真理的權利，並渴望尋找那些他容易忍受痛苦的人，這種痛苦被稱為快樂。他選擇了哪一種煩惱，當他確實會歡迎、接受或打開正義者以這種辛苦的方式帶來的樂趣，並讓它們向真理敞開心扉時。最小的痛苦對她來說是最值得的，智者用我們應盡的義務取悅她；我將解釋鬆散的目的，並相應地獲得它們
233736	2031888	有機黃瓜	\N	zh-HK	新近新鮮的有機黃瓜
233737	2031888	organic cucumber	\N	en-GB	newly fresh organic cucumber
\.


--
-- Data for Name: product_basic; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.product_basic (prd_id, width, height, length, weight) FROM stdin;
11	\N	\N	\N	0.27
233275	\N	\N	\N	0.49
233282	\N	\N	\N	0.43
233289	\N	\N	\N	0.27
233296	\N	\N	\N	0.45
233303	\N	\N	\N	0.45
233310	\N	\N	\N	0.05
233317	\N	\N	\N	0.06
233324	\N	\N	\N	0.26
233331	\N	\N	\N	0.15
233338	\N	\N	\N	0.12
233345	\N	\N	\N	0.45
233352	\N	\N	\N	0.45
233359	\N	\N	\N	0.04
233366	\N	\N	\N	0.31
233373	\N	\N	\N	0.28
233380	\N	\N	\N	0.04
233387	\N	\N	\N	0.31
233394	\N	\N	\N	0.06
233401	\N	\N	\N	0.40
233408	\N	\N	\N	0.19
233415	\N	\N	\N	0.33
233422	\N	\N	\N	0.15
233429	\N	\N	\N	0.48
233436	\N	\N	\N	0.07
233443	\N	\N	\N	0.40
233450	\N	\N	\N	0.02
233457	\N	\N	\N	0.38
233464	\N	\N	\N	0.00
233471	\N	\N	\N	0.01
233478	\N	\N	\N	0.42
233485	\N	\N	\N	0.27
233492	\N	\N	\N	0.49
233499	\N	\N	\N	0.34
233506	\N	\N	\N	0.05
233513	\N	\N	\N	0.45
233520	\N	\N	\N	0.29
233527	\N	\N	\N	0.10
233534	\N	\N	\N	0.01
233541	\N	\N	\N	0.05
233548	\N	\N	\N	0.25
233555	\N	\N	\N	0.12
233562	\N	\N	\N	0.50
233569	\N	\N	\N	0.20
233576	\N	\N	\N	0.16
233583	\N	\N	\N	0.31
233590	\N	\N	\N	0.47
233597	\N	\N	\N	0.20
233604	\N	\N	\N	0.12
233611	\N	\N	\N	0.03
233618	\N	\N	\N	0.10
233625	\N	\N	\N	0.31
233632	\N	\N	\N	0.36
233639	\N	\N	\N	0.25
233646	\N	\N	\N	0.29
233653	\N	\N	\N	0.43
233660	\N	\N	\N	0.15
233667	\N	\N	\N	0.31
233674	\N	\N	\N	0.31
233681	\N	\N	\N	0.15
233688	\N	\N	\N	0.32
233695	\N	\N	\N	0.23
233702	\N	\N	\N	0.43
233709	\N	\N	\N	0.31
233716	\N	\N	\N	0.07
233723	\N	\N	\N	0.48
233730	\N	\N	\N	0.26
14	\N	\N	\N	0.36
20	\N	\N	\N	0.07
17	\N	\N	\N	0.26
7	\N	\N	\N	0.41
12	\N	\N	\N	0.32
29	\N	\N	\N	0.38
30	\N	\N	\N	0.41
28	\N	\N	\N	0.02
2	\N	\N	\N	0.04
15	\N	\N	\N	0.22
10	\N	\N	\N	0.49
27	\N	\N	\N	0.24
21	\N	\N	\N	0.34
26	\N	\N	\N	0.02
24	\N	\N	\N	0.35
25	\N	\N	\N	0.15
16	\N	\N	\N	0.38
6	\N	\N	\N	0.10
22	\N	\N	\N	0.44
23	\N	\N	\N	0.31
3	\N	\N	\N	0.25
9	\N	\N	\N	0.25
4	\N	\N	\N	0.12
13	\N	\N	\N	0.40
18	\N	\N	\N	0.07
19	\N	\N	\N	0.35
8	\N	\N	\N	0.33
1	\N	\N	\N	0.38
5	\N	\N	\N	0.42
2031888	0	0	0	0.00
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.product_category (prd_cat_id, prd_id, cat_id) FROM stdin;
39	1	15
40	2	14
41	3	5
42	4	8
43	5	5
45	7	8
46	8	14
47	9	7
48	10	9
50	12	9
51	13	8
52	14	8
53	15	9
54	16	9
55	17	10
56	18	15
57	19	14
58	20	13
59	21	10
60	22	10
61	23	12
62	24	12
63	25	13
64	26	20
65	27	17
66	28	26
67	29	19
68	30	26
69	1	38
70	10	38
71	11	38
72	14	38
73	15	38
74	18	38
75	19	38
76	20	38
77	22	38
78	24	38
79	27	38
80	29	38
81	2	43
82	14	43
83	18	43
84	22	43
85	12	43
86	16	43
87	26	43
88	6	43
89	20	43
90	5	43
123	233275	233101
124	233282	233101
125	233289	233080
126	233296	233068
127	233303	233080
128	233310	233071
129	233317	233080
130	233324	233080
131	233331	233083
132	233338	233170
133	233345	233083
134	233352	233080
135	233359	233080
136	233366	233080
137	233373	233080
138	233380	233080
139	233387	233080
140	233394	233068
141	233401	233074
142	233408	233167
143	233415	233167
144	233422	233167
145	233429	233167
146	233436	233167
147	233443	233134
148	233450	233167
149	233457	233134
150	233464	233164
151	233471	233167
152	233478	233167
153	233485	233167
154	233492	233167
155	233499	233164
156	233506	233167
157	233513	233167
158	233520	233167
159	233527	233167
160	233534	233170
161	233541	233173
162	233548	233173
163	233555	233173
164	233562	233173
165	233569	233173
166	233576	233167
167	233583	233185
168	233590	233185
169	233597	233167
170	233604	233167
171	233611	233167
172	233618	233176
173	233625	233170
174	233632	233170
175	233639	233080
176	233646	233170
177	233653	233170
178	233660	233167
179	233667	233167
180	233674	233137
181	233681	233134
182	233688	233134
183	233695	233134
184	233702	233167
185	233709	233164
186	233716	233134
187	233723	233167
188	233730	233167
44	6	36
1465	2031066	46
1466	2031067	46
1467	2031068	46
1468	2031069	46
1469	2031070	46
1470	2031071	46
1471	2031072	46
1472	2031073	46
1473	2031074	46
1474	2031075	46
1475	2031076	46
1476	2031077	46
1477	2031078	46
1478	2031079	46
1479	2031080	46
1480	2031081	46
1481	2031082	46
1482	2031083	46
1483	2031084	46
1484	2031085	46
1485	2031086	46
1486	2031087	46
1487	2031088	46
1488	2031089	46
1489	2031090	46
1490	2031091	46
1491	2031092	46
1492	2031093	46
1493	2031094	46
1494	2031095	46
1495	2031096	46
1496	2031097	46
1497	2031098	46
1498	2031099	46
1499	2031100	46
1500	2031101	46
1501	2031102	46
1502	2031103	46
1503	2031104	46
1504	2031105	46
1505	2031106	46
1506	2031107	46
1507	2031108	46
1508	2031109	46
1509	2031110	46
1510	2031111	46
1511	2031112	46
1512	2031113	46
1513	2031114	46
1514	2031115	46
1515	2031116	46
1516	2031117	46
1517	2031118	46
1518	2031119	46
1519	2031120	46
1520	2031121	46
1521	2031122	46
1522	2031123	46
1523	2031124	46
1524	2031125	46
1525	2031126	46
1526	2031127	46
1527	2031128	46
1528	2031129	46
1529	2031130	46
1530	2031131	46
1531	2031132	46
1532	2031133	46
1533	2031134	46
1534	2031135	46
1535	2031136	46
1536	2031137	46
1537	2031138	46
1538	2031139	46
1539	2031140	46
1540	2031141	46
1541	2031142	46
1542	2031143	46
1543	2031144	46
1544	2031145	46
1545	2031146	46
1546	2031147	46
1547	2031148	46
1548	2031149	46
1549	2031150	46
1550	2031151	46
1551	2031152	46
1552	2031153	46
1553	2031154	46
1554	2031155	46
1555	2031156	46
1556	2031157	46
1557	2031158	46
1558	2031159	46
1559	2031160	46
1560	2031161	46
1561	2031162	46
1562	2031163	46
1563	2031164	46
1564	2031165	46
1565	2031166	46
1566	2031167	46
1567	2031168	46
1568	2031169	46
1569	2031170	46
1570	2031171	46
1571	2031172	46
1572	2031173	46
1573	2031174	46
1574	2031175	46
1575	2031176	46
1576	2031177	46
1577	2031178	46
1578	2031179	46
1579	2031180	46
1580	2031181	46
1581	2031182	46
1582	2031183	46
1583	2031184	46
1584	2031185	46
1585	2031186	46
1586	2031187	46
1587	2031188	46
1588	2031189	46
1589	2031190	46
1590	2031191	46
1591	2031192	46
1592	2031193	46
1593	2031194	46
1594	2031195	46
1595	2031196	46
1596	2031197	46
1597	2031198	46
1598	2031199	46
1599	2031200	46
1600	2031201	46
1601	2031202	46
1602	2031203	46
1603	2031204	46
1604	2031205	46
1605	2031206	46
1606	2031207	46
1607	2031208	46
1608	2031209	46
1609	2031210	46
1610	2031211	46
1611	2031212	46
1612	2031213	46
1613	2031214	46
1614	2031215	46
1615	2031216	46
1616	2031217	46
1617	2031218	46
1618	2031219	46
1619	2031220	46
1620	2031221	46
1621	2031222	46
1622	2031223	46
1623	2031224	46
1624	2031225	46
1625	2031226	46
1626	2031227	46
1627	2031228	46
1628	2031229	46
1629	2031230	46
1630	2031231	46
1631	2031232	46
1632	2031233	46
1633	2031234	46
1634	2031235	46
1635	2031236	46
1636	2031237	46
1637	2031238	46
1638	2031239	46
1639	2031240	46
1640	2031241	46
1641	2031242	46
1642	2031243	46
1643	2031244	46
1644	2031245	46
1645	2031246	46
1646	2031247	46
1647	2031248	46
1648	2031249	46
1649	2031250	46
1650	2031251	46
1651	2031252	46
1652	2031253	46
1653	2031254	46
1654	2031255	46
1655	2031256	46
1656	2031257	46
1657	2031258	46
1658	2031259	46
1659	2031260	46
1660	2031261	46
1661	2031262	46
1662	2031263	46
1663	2031264	46
1664	2031265	46
1665	2031266	46
1666	2031267	46
1667	2031268	46
1668	2031269	46
1669	2031270	46
1670	2031271	46
1671	2031272	46
1672	2031273	46
1673	2031274	46
1674	2031275	46
1677	2031277	46
1678	2031278	46
1679	2031279	46
1680	2031280	46
1681	2031281	46
1682	2031282	46
1683	2031283	46
1684	2031284	46
1685	2031285	46
1686	2031286	46
1687	2031287	46
1688	2031288	46
1689	2031289	46
1690	2031290	46
1691	2031291	46
1692	2031292	46
1693	2031293	46
1694	2031294	46
1695	2031295	46
1696	2031296	46
1697	2031297	46
1698	2031298	46
1699	2031299	46
1700	2031300	46
1701	2031301	46
1702	2031302	46
1703	2031303	46
1704	2031304	46
1705	2031305	46
1706	2031306	46
1707	2031307	46
1708	2031308	46
1709	2031309	46
1710	2031310	46
1711	2031311	46
1712	2031312	46
1713	2031313	46
1714	2031314	46
1715	2031315	46
1716	2031316	46
1717	2031317	46
1718	2031318	46
1719	2031319	46
1720	2031320	46
1721	2031321	46
1722	2031322	46
1723	2031323	46
1724	2031324	46
1725	2031325	46
1726	2031326	46
1727	2031327	46
1728	2031328	46
1729	2031329	46
1730	2031330	46
1731	2031331	46
1732	2031332	46
1733	2031333	46
1734	2031334	46
1735	2031335	46
1736	2031336	46
1737	2031337	46
1738	2031338	46
1739	2031339	46
1740	2031340	46
1741	2031341	46
1742	2031342	46
1743	2031343	46
1744	2031344	46
1745	2031345	46
1746	2031346	46
1747	2031347	46
1748	2031348	46
1749	2031349	46
1750	2031350	46
1751	2031351	46
1752	2031352	46
1753	2031353	46
1754	2031354	46
1755	2031355	46
1756	2031356	46
1757	2031357	46
1758	2031358	46
1759	2031359	46
1760	2031360	46
1761	2031361	46
1762	2031362	46
1763	2031363	46
1764	2031364	46
1765	2031365	46
1766	2031366	46
1767	2031367	46
1768	2031368	46
1769	2031369	46
1770	2031370	46
1771	2031371	46
1772	2031372	46
1773	2031373	46
1774	2031374	46
1775	2031375	46
1776	2031376	46
1777	2031377	46
1778	2031378	46
1779	2031379	46
1780	2031380	46
1781	2031381	46
1782	2031382	46
1783	2031383	46
1784	2031384	46
1785	2031385	46
1786	2031386	46
1787	2031387	46
1788	2031388	46
1789	2031389	46
1790	2031390	46
1791	2031391	46
1792	2031392	46
1793	2031393	46
1794	2031394	46
1795	2031395	46
1796	2031396	46
1797	2031397	46
1798	2031398	46
1799	2031399	46
1800	2031400	46
1801	2031401	46
1802	2031402	46
1803	2031403	46
1804	2031404	46
1805	2031405	46
1806	2031406	46
1807	2031407	46
1808	2031408	46
1809	2031409	46
1810	2031410	46
1811	2031411	46
1812	2031412	46
1813	2031413	46
1814	2031414	46
1815	2031415	46
1816	2031416	46
1817	2031417	46
1818	2031418	46
1819	2031419	46
1820	2031420	46
1821	2031421	46
1822	2031422	46
1823	2031423	46
1824	2031424	46
1825	2031425	46
1826	2031426	46
1827	2031427	46
1828	2031428	46
1829	2031429	46
1830	2031430	46
1831	2031431	46
1832	2031432	46
1833	2031433	46
1834	2031434	46
1835	2031435	46
1836	2031436	46
1837	2031437	46
1838	2031438	46
1839	2031439	46
1840	2031440	46
1841	2031441	46
1842	2031442	46
1843	2031443	46
1844	2031444	46
1845	2031445	46
1846	2031446	46
1847	2031447	46
1848	2031448	46
1849	2031449	46
1850	2031450	46
1851	2031451	46
1852	2031452	46
1853	2031453	46
1854	2031454	46
1855	2031455	46
1856	2031456	46
1857	2031457	46
1858	2031458	46
1859	2031459	46
1860	2031460	46
1861	2031461	46
1862	2031462	46
1863	2031463	46
1864	2031464	46
1865	2031465	46
1866	2031466	46
1867	2031467	46
1868	2031468	46
1869	2031469	46
1870	2031470	46
1871	2031471	46
1872	2031472	46
1873	2031473	46
1874	2031474	46
1875	2031475	46
1876	2031476	46
1877	2031477	46
1878	2031478	46
1879	2031479	46
1880	2031480	46
1881	2031481	46
1882	2031482	46
1883	2031483	46
1884	2031484	46
1885	2031485	46
1886	2031486	46
1887	2031487	46
1888	2031488	46
1889	2031489	46
1890	2031490	46
1891	2031491	46
1892	2031492	46
1893	2031493	46
1894	2031494	46
1895	2031495	46
1896	2031496	46
1897	2031497	46
1898	2031498	46
1899	2031499	46
1900	2031500	46
1901	2031501	46
1902	2031502	46
1903	2031503	46
1904	2031504	46
1905	2031505	46
1906	2031506	46
1907	2031507	46
1908	2031508	46
1909	2031509	46
1910	2031510	46
1911	2031511	46
1912	2031512	46
1913	2031513	46
1914	2031514	46
1915	2031515	46
1916	2031516	46
1917	2031517	46
1918	2031518	46
1919	2031519	46
1920	2031520	46
1921	2031521	46
1922	2031522	46
1923	2031523	46
1924	2031524	46
1925	2031525	46
1926	2031526	46
1927	2031527	46
1928	2031528	46
1929	2031529	46
1930	2031530	46
1931	2031531	46
1932	2031532	46
1933	2031533	46
1934	2031534	46
1935	2031535	46
1936	2031536	46
1937	2031537	46
1938	2031538	46
1939	2031539	46
1940	2031540	46
1941	2031541	46
1942	2031542	46
1943	2031543	46
1944	2031544	46
1945	2031545	46
1946	2031546	46
1947	2031547	46
1948	2031548	46
1949	2031549	46
1950	2031550	46
1951	2031551	46
1952	2031552	46
1953	2031553	46
1954	2031554	46
1955	2031555	46
1956	2031556	46
1957	2031557	46
1958	2031558	46
1959	2031559	46
1960	2031560	46
1961	2031561	46
1962	2031562	46
1963	2031563	46
1964	2031564	46
1965	2031565	46
1966	2031566	46
1967	2031567	46
1968	2031568	46
1969	2031569	46
1970	2031570	46
1971	2031571	46
1972	2031572	46
1973	2031573	46
1974	2031574	46
1975	2031575	46
1976	2031576	46
1977	2031577	46
1978	2031578	46
1979	2031579	46
1980	2031580	46
1981	2031581	46
1982	2031582	46
1983	2031583	46
1984	2031584	46
1985	2031585	46
1986	2031586	46
1987	2031587	46
1988	2031588	46
1989	2031589	46
1990	2031590	46
1991	2031591	46
1992	2031592	46
1993	2031593	46
1994	2031594	46
1995	2031595	46
1996	2031596	46
1997	2031597	46
1998	2031598	46
1999	2031599	46
2000	2031600	46
2001	2031601	46
2002	2031602	46
2003	2031603	46
2004	2031604	46
2005	2031605	46
2006	2031606	46
2007	2031607	46
2008	2031608	46
2009	2031609	46
2010	2031610	46
2011	2031611	46
2012	2031612	46
2013	2031613	46
2014	2031614	46
2015	2031615	46
2016	2031616	46
2017	2031617	46
2018	2031618	46
2019	2031619	46
2020	2031620	46
2021	2031621	46
2022	2031622	46
2023	2031623	46
2024	2031624	46
2025	2031625	46
2026	2031626	46
2027	2031627	46
2028	2031628	46
2029	2031629	46
2030	2031630	46
2031	2031631	46
2032	2031632	46
2033	2031633	46
2034	2031634	46
2035	2031635	46
2036	2031636	46
2037	2031637	46
2038	2031638	46
2039	2031639	46
2040	2031640	46
2041	2031641	46
2042	2031642	46
2043	2031643	46
2044	2031644	46
2045	2031645	46
2046	2031646	46
2047	2031647	46
2048	2031648	46
2049	2031649	46
2050	2031650	46
2051	2031651	46
2052	2031652	46
2053	2031653	46
2054	2031654	46
2055	2031655	46
2056	2031656	46
2057	2031657	46
2058	2031658	46
2059	2031659	46
2060	2031660	46
2061	2031661	46
2062	2031662	46
2063	2031663	46
2064	2031664	46
2065	2031665	46
2066	2031666	46
2067	2031667	46
2068	2031668	46
2069	2031669	46
2070	2031670	46
2071	2031671	46
2072	2031672	46
2073	2031673	46
2074	2031674	46
2075	2031675	46
2076	2031676	46
2077	2031677	46
2078	2031678	46
2079	2031679	46
2080	2031680	46
2081	2031681	46
2082	2031682	46
2083	2031683	46
2084	2031684	46
2085	2031685	46
2086	2031686	46
2087	2031687	46
2088	2031688	46
2089	2031689	46
2090	2031690	46
2091	2031691	46
2092	2031692	46
2093	2031693	46
2094	2031694	46
2095	2031695	46
2096	2031696	46
2097	2031697	46
2098	2031698	46
2099	2031699	46
2100	2031700	46
2101	2031701	46
2102	2031702	46
2103	2031703	46
2104	2031704	46
2105	2031705	46
2106	2031706	46
2107	2031707	46
2108	2031708	46
2109	2031709	46
2110	2031710	46
2111	2031711	46
2112	2031712	46
2113	2031713	46
2114	2031714	46
2115	2031715	46
2116	2031716	46
2117	2031717	46
2118	2031718	46
2119	2031719	46
2120	2031720	46
2121	2031721	46
2122	2031722	46
2123	2031723	46
2124	2031724	46
2125	2031725	46
2126	2031726	46
2127	2031727	46
2128	2031728	46
2129	2031729	46
2130	2031730	46
2131	2031731	46
2132	2031732	46
2133	2031733	46
2134	2031734	46
2135	2031735	46
2136	2031736	46
2137	2031737	46
2138	2031738	46
2139	2031739	46
2140	2031740	46
2141	2031741	46
2142	2031742	46
2143	2031743	46
2144	2031744	46
2145	2031745	46
2146	2031746	46
2147	2031747	46
2148	2031748	46
2149	2031749	46
2150	2031750	46
2151	2031751	46
2152	2031752	46
2153	2031753	46
2154	2031754	46
2155	2031755	46
2156	2031756	46
2157	2031757	46
2158	2031758	46
2159	2031759	46
2160	2031760	46
2161	2031761	46
2162	2031762	46
2163	2031763	46
2164	2031764	46
2165	2031765	46
2166	2031766	46
2167	2031767	46
2168	2031768	46
2169	2031769	46
2170	2031770	46
2171	2031771	46
2172	2031772	46
2173	2031773	46
2174	2031774	46
2175	2031775	46
2176	2031776	46
2177	2031777	46
2178	2031778	46
2179	2031779	46
2180	2031780	46
2181	2031781	46
2182	2031782	46
2183	2031783	46
2184	2031784	46
2185	2031785	46
2186	2031786	46
2187	2031787	46
2188	2031788	46
2189	2031789	46
2190	2031790	46
2191	2031791	46
2192	2031792	46
2193	2031793	46
2194	2031794	46
2195	2031795	46
2196	2031796	46
2197	2031797	46
2198	2031798	46
2199	2031799	46
2200	2031800	46
2201	2031801	46
2202	2031802	46
2203	2031803	46
2204	2031804	46
2205	2031805	46
2206	2031806	46
2207	2031807	46
2208	2031808	46
2209	2031809	46
2210	2031810	46
2211	2031811	46
2212	2031812	46
2213	2031813	46
2214	2031814	46
2215	2031815	46
2216	2031816	46
2217	2031817	46
2218	2031818	46
2219	2031819	46
2220	2031820	46
2221	2031821	46
2222	2031822	46
2223	2031823	46
2224	2031824	46
2225	2031825	46
2226	2031826	46
2227	2031827	46
2228	2031828	46
2229	2031829	46
2230	2031830	46
2231	2031831	46
2232	2031832	46
2233	2031833	46
2234	2031834	46
2235	2031835	46
2236	2031836	46
2237	2031837	46
2238	2031838	46
2239	2031839	46
2240	2031840	46
2241	2031841	46
2242	2031842	46
2243	2031843	46
2244	2031844	46
2245	2031845	46
2246	2031846	46
2247	2031847	46
2248	2031848	46
2249	2031849	46
2250	2031850	46
2251	2031851	46
2252	2031852	46
2253	2031853	46
2254	2031854	46
2255	2031855	46
2256	2031856	46
2257	2031857	46
2258	2031858	46
2259	2031859	46
2260	2031860	46
2261	2031861	46
2262	2031862	46
2263	2031863	46
2264	2031864	46
2265	2031865	46
2266	2031866	46
2267	2031867	46
2268	2031868	46
2269	2031869	46
2270	2031870	46
2271	2031871	46
2272	2031872	46
2273	2031873	46
2274	2031874	46
2275	2031875	46
2276	2031876	46
2277	2031877	46
2278	2031878	46
2279	2031879	46
2280	2031880	46
2281	2031881	46
2282	2031882	46
2283	2031883	46
2284	2031884	46
2285	2031885	46
2286	2031886	46
2288	2031888	8
\.


--
-- Data for Name: product_promotion; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.product_promotion (prd_id, prm_id) FROM stdin;
13	234464
25	234467
2031276	234464
\.


--
-- Data for Name: product_rating; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.product_rating (prd_rat_id, prd_id, rat_id, pty_id, prd_rat_dt) FROM stdin;
1	11	6	1	2020-04-21 12:24:49.524028+08
2	5	1	1	2020-04-21 12:24:49.524028+08
3	7	5	1	2020-04-21 12:24:49.524028+08
4	9	5	1	2020-04-21 12:24:49.524028+08
5	13	2	1	2020-04-21 12:24:49.524028+08
6	21	2	1	2020-04-21 12:24:49.524028+08
7	23	4	1	2020-04-21 12:24:49.524028+08
8	25	3	1	2020-04-21 12:24:49.524028+08
9	26	5	1	2020-04-21 12:24:49.524028+08
10	28	3	1	2020-04-21 12:24:49.524028+08
11	30	3	1	2020-04-21 12:24:49.524028+08
12	2	5	1	2020-04-21 12:24:49.524028+08
13	8	4	1	2020-04-21 12:24:49.524028+08
14	17	2	1	2020-04-21 12:24:49.524028+08
15	3	3	1	2020-04-21 12:24:49.524028+08
16	4	2	1	2020-04-21 12:24:49.524028+08
17	6	5	1	2020-04-21 12:24:49.524028+08
18	12	5	1	2020-04-21 12:24:49.524028+08
19	16	5	1	2020-04-21 12:24:49.524028+08
20	10	4	1	2020-04-21 12:24:49.524028+08
21	14	5	1	2020-04-21 12:24:49.524028+08
22	15	2	1	2020-04-21 12:24:49.524028+08
23	19	3	1	2020-04-21 12:24:49.524028+08
24	20	4	1	2020-04-21 12:24:49.524028+08
25	22	2	1	2020-04-21 12:24:49.524028+08
26	24	4	1	2020-04-21 12:24:49.524028+08
27	27	4	1	2020-04-21 12:24:49.524028+08
28	29	3	1	2020-04-21 12:24:49.524028+08
29	1	5	1	2020-04-21 12:24:49.524028+08
30	18	4	1	2020-04-21 12:24:49.524028+08
31	11	1	232230	2020-04-21 12:25:18.024842+08
32	5	5	232230	2020-04-21 12:25:18.024842+08
33	7	4	232230	2020-04-21 12:25:18.024842+08
34	9	5	232230	2020-04-21 12:25:18.024842+08
35	13	4	232230	2020-04-21 12:25:18.024842+08
36	21	6	232230	2020-04-21 12:25:18.024842+08
37	23	2	232230	2020-04-21 12:25:18.024842+08
38	25	2	232230	2020-04-21 12:25:18.024842+08
39	26	2	232230	2020-04-21 12:25:18.024842+08
40	28	6	232230	2020-04-21 12:25:18.024842+08
41	30	4	232230	2020-04-21 12:25:18.024842+08
42	2	4	232230	2020-04-21 12:25:18.024842+08
43	8	5	232230	2020-04-21 12:25:18.024842+08
44	17	3	232230	2020-04-21 12:25:18.024842+08
45	3	5	232230	2020-04-21 12:25:18.024842+08
46	4	2	232230	2020-04-21 12:25:18.024842+08
47	6	4	232230	2020-04-21 12:25:18.024842+08
48	12	4	232230	2020-04-21 12:25:18.024842+08
49	16	6	232230	2020-04-21 12:25:18.024842+08
50	10	3	232230	2020-04-21 12:25:18.024842+08
51	14	2	232230	2020-04-21 12:25:18.024842+08
52	15	5	232230	2020-04-21 12:25:18.024842+08
53	19	5	232230	2020-04-21 12:25:18.024842+08
54	20	4	232230	2020-04-21 12:25:18.024842+08
55	22	3	232230	2020-04-21 12:25:18.024842+08
56	24	6	232230	2020-04-21 12:25:18.024842+08
57	27	2	232230	2020-04-21 12:25:18.024842+08
58	29	6	232230	2020-04-21 12:25:18.024842+08
59	1	2	232230	2020-04-21 12:25:18.024842+08
60	18	1	232230	2020-04-21 12:25:18.024842+08
61	11	4	232250	2020-04-21 12:25:36.451586+08
62	5	2	232250	2020-04-21 12:25:36.451586+08
63	7	5	232250	2020-04-21 12:25:36.451586+08
64	9	2	232250	2020-04-21 12:25:36.451586+08
65	13	2	232250	2020-04-21 12:25:36.451586+08
66	21	3	232250	2020-04-21 12:25:36.451586+08
67	23	2	232250	2020-04-21 12:25:36.451586+08
68	25	3	232250	2020-04-21 12:25:36.451586+08
69	26	4	232250	2020-04-21 12:25:36.451586+08
70	28	3	232250	2020-04-21 12:25:36.451586+08
71	30	2	232250	2020-04-21 12:25:36.451586+08
72	2	2	232250	2020-04-21 12:25:36.451586+08
73	8	1	232250	2020-04-21 12:25:36.451586+08
74	17	1	232250	2020-04-21 12:25:36.451586+08
75	3	4	232250	2020-04-21 12:25:36.451586+08
76	4	6	232250	2020-04-21 12:25:36.451586+08
77	6	2	232250	2020-04-21 12:25:36.451586+08
78	12	2	232250	2020-04-21 12:25:36.451586+08
79	16	4	232250	2020-04-21 12:25:36.451586+08
80	10	2	232250	2020-04-21 12:25:36.451586+08
81	14	4	232250	2020-04-21 12:25:36.451586+08
82	15	5	232250	2020-04-21 12:25:36.451586+08
83	19	5	232250	2020-04-21 12:25:36.451586+08
84	20	3	232250	2020-04-21 12:25:36.451586+08
85	22	3	232250	2020-04-21 12:25:36.451586+08
86	24	2	232250	2020-04-21 12:25:36.451586+08
87	27	2	232250	2020-04-21 12:25:36.451586+08
88	29	4	232250	2020-04-21 12:25:36.451586+08
89	1	2	232250	2020-04-21 12:25:36.451586+08
90	18	3	232250	2020-04-21 12:25:36.451586+08
91	11	4	232254	2020-04-21 12:26:01.053376+08
92	5	5	232254	2020-04-21 12:26:01.053376+08
93	7	5	232254	2020-04-21 12:26:01.053376+08
94	9	3	232254	2020-04-21 12:26:01.053376+08
95	13	2	232254	2020-04-21 12:26:01.053376+08
96	21	6	232254	2020-04-21 12:26:01.053376+08
97	23	5	232254	2020-04-21 12:26:01.053376+08
98	25	2	232254	2020-04-21 12:26:01.053376+08
99	26	3	232254	2020-04-21 12:26:01.053376+08
100	28	3	232254	2020-04-21 12:26:01.053376+08
101	30	5	232254	2020-04-21 12:26:01.053376+08
102	2	4	232254	2020-04-21 12:26:01.053376+08
103	8	5	232254	2020-04-21 12:26:01.053376+08
104	17	5	232254	2020-04-21 12:26:01.053376+08
105	3	4	232254	2020-04-21 12:26:01.053376+08
106	4	3	232254	2020-04-21 12:26:01.053376+08
107	6	5	232254	2020-04-21 12:26:01.053376+08
108	12	6	232254	2020-04-21 12:26:01.053376+08
109	16	3	232254	2020-04-21 12:26:01.053376+08
110	10	2	232254	2020-04-21 12:26:01.053376+08
111	14	1	232254	2020-04-21 12:26:01.053376+08
112	15	1	232254	2020-04-21 12:26:01.053376+08
113	19	1	232254	2020-04-21 12:26:01.053376+08
114	20	6	232254	2020-04-21 12:26:01.053376+08
115	22	3	232254	2020-04-21 12:26:01.053376+08
116	24	3	232254	2020-04-21 12:26:01.053376+08
117	27	2	232254	2020-04-21 12:26:01.053376+08
118	29	4	232254	2020-04-21 12:26:01.053376+08
119	1	1	232254	2020-04-21 12:26:01.053376+08
120	18	3	232254	2020-04-21 12:26:01.053376+08
\.


--
-- Data for Name: product_shipping; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.product_shipping (prd_id, shp_wgt_lim, shp_wgt_frm, shp_wgt_to, shp_typ_cd, shp_ctry_cd) FROM stdin;
2031067	20	0.21	0.40	LEG   	HKG
2031068	20	0.41	0.60	LEG   	HKG
2031070	20	0.81	1.00	LEG   	HKG
2031071	20	1.01	1.20	LEG   	HKG
2031072	20	1.21	1.40	LEG   	HKG
2031073	20	1.41	1.60	LEG   	HKG
2031074	20	1.61	1.80	LEG   	HKG
2031075	20	1.81	2.00	LEG   	HKG
2031076	20	2.01	2.20	LEG   	HKG
2031077	20	2.21	2.40	LEG   	HKG
2031078	20	2.41	2.60	LEG   	HKG
2031079	20	2.61	2.80	LEG   	HKG
2031080	20	2.81	3.00	LEG   	HKG
2031081	20	3.01	3.20	LEG   	HKG
2031082	20	3.21	3.40	LEG   	HKG
2031083	20	3.41	3.60	LEG   	HKG
2031084	20	3.61	3.80	LEG   	HKG
2031085	20	3.81	4.00	LEG   	HKG
2031087	20	4.21	4.40	LEG   	HKG
2031088	20	4.41	4.60	LEG   	HKG
2031089	20	4.61	4.80	LEG   	HKG
2031090	20	4.81	5.00	LEG   	HKG
2031091	20	5.01	5.20	LEG   	HKG
2031092	20	5.21	5.40	LEG   	HKG
2031093	20	5.41	5.60	LEG   	HKG
2031094	20	5.61	5.80	LEG   	HKG
2031095	20	5.81	6.00	LEG   	HKG
2031096	20	6.01	6.20	LEG   	HKG
2031097	20	6.21	6.40	LEG   	HKG
2031098	20	6.41	6.60	LEG   	HKG
2031099	20	6.61	6.80	LEG   	HKG
2031100	20	6.81	7.00	LEG   	HKG
2031101	20	7.01	7.20	LEG   	HKG
2031102	20	7.21	7.40	LEG   	HKG
2031104	20	7.61	7.80	LEG   	HKG
2031105	20	7.81	8.00	LEG   	HKG
2031106	20	8.01	8.20	LEG   	HKG
2031107	20	8.21	8.40	LEG   	HKG
2031108	20	8.41	8.60	LEG   	HKG
2031109	20	8.61	8.80	LEG   	HKG
2031110	20	8.81	9.00	LEG   	HKG
2031111	20	9.01	9.20	LEG   	HKG
2031112	20	9.21	9.40	LEG   	HKG
2031113	20	9.41	9.60	LEG   	HKG
2031114	20	9.61	9.80	LEG   	HKG
2031115	20	9.81	10.00	LEG   	HKG
2031116	20	10.01	10.20	LEG   	HKG
2031117	20	10.21	10.40	LEG   	HKG
2031118	20	10.41	10.60	LEG   	HKG
2031119	20	10.61	10.80	LEG   	HKG
2031121	20	11.01	11.20	LEG   	HKG
2031122	20	11.21	11.40	LEG   	HKG
2031123	20	11.41	11.60	LEG   	HKG
2031124	20	11.61	11.80	LEG   	HKG
2031125	20	11.81	12.00	LEG   	HKG
2031126	20	12.01	12.20	LEG   	HKG
2031127	20	12.21	12.40	LEG   	HKG
2031128	20	12.41	12.60	LEG   	HKG
2031129	20	12.61	12.80	LEG   	HKG
2031130	20	12.81	13.00	LEG   	HKG
2031131	20	13.01	13.20	LEG   	HKG
2031132	20	13.21	13.40	LEG   	HKG
2031133	20	13.41	13.60	LEG   	HKG
2031134	20	13.61	13.80	LEG   	HKG
2031135	20	13.81	14.00	LEG   	HKG
2031136	20	14.01	14.20	LEG   	HKG
2031138	20	14.41	14.60	LEG   	HKG
2031139	20	14.61	14.80	LEG   	HKG
2031140	20	14.81	15.00	LEG   	HKG
2031141	20	15.01	15.20	LEG   	HKG
2031142	20	15.21	15.40	LEG   	HKG
2031143	20	15.41	15.60	LEG   	HKG
2031144	20	15.61	15.80	LEG   	HKG
2031145	20	15.81	16.00	LEG   	HKG
2031146	20	16.01	16.20	LEG   	HKG
2031147	20	16.21	16.40	LEG   	HKG
2031148	20	16.41	16.60	LEG   	HKG
2031149	20	16.61	16.80	LEG   	HKG
2031150	20	16.81	17.00	LEG   	HKG
2031151	20	17.01	17.20	LEG   	HKG
2031152	20	17.21	17.40	LEG   	HKG
2031153	20	17.41	17.60	LEG   	HKG
2031155	20	17.81	18.00	LEG   	HKG
2031156	20	18.01	18.20	LEG   	HKG
2031157	20	18.21	18.40	LEG   	HKG
2031158	20	18.41	18.60	LEG   	HKG
2031159	20	18.61	18.80	LEG   	HKG
2031160	20	18.81	19.00	LEG   	HKG
2031161	20	19.01	19.20	LEG   	HKG
2031162	20	19.21	19.40	LEG   	HKG
2031163	20	19.41	19.60	LEG   	HKG
2031164	20	19.61	19.80	LEG   	HKG
2031165	20	19.81	20.00	LEG   	HKG
2031166	2	0.01	0.20	LCP   	HKG
2031167	2	0.21	0.40	LCP   	HKG
2031168	2	0.41	0.60	LCP   	HKG
2031169	2	0.61	0.80	LCP   	HKG
2031170	2	0.81	1.00	LCP   	HKG
2031172	2	1.21	1.40	LCP   	HKG
2031173	2	1.41	1.60	LCP   	HKG
2031174	2	1.61	1.80	LCP   	HKG
2031175	2	1.81	2.00	LCP   	HKG
2031176	20	0.01	0.20	LPL   	HKG
2031177	20	0.21	0.40	LPL   	HKG
2031178	20	0.41	0.60	LPL   	HKG
2031179	20	0.61	0.80	LPL   	HKG
2031180	20	0.81	1.00	LPL   	HKG
2031181	20	1.01	1.20	LPL   	HKG
2031182	20	1.21	1.40	LPL   	HKG
2031183	20	1.41	1.60	LPL   	HKG
2031184	20	1.61	1.80	LPL   	HKG
2031185	20	1.81	2.00	LPL   	HKG
2031066	20	0.01	0.20	LEG   	HKG
2031069	20	0.61	0.80	LEG   	HKG
2031086	20	4.01	4.20	LEG   	HKG
2031103	20	7.41	7.60	LEG   	HKG
2031120	20	10.81	11.00	LEG   	HKG
2031137	20	14.21	14.40	LEG   	HKG
2031154	20	17.61	17.80	LEG   	HKG
2031171	2	1.01	1.20	LCP   	HKG
2031186	20	2.01	2.20	LPL   	HKG
2031187	20	2.21	2.40	LPL   	HKG
2031188	20	2.41	2.60	LPL   	HKG
2031189	20	2.61	2.80	LPL   	HKG
2031190	20	2.81	3.00	LPL   	HKG
2031191	20	3.01	3.20	LPL   	HKG
2031192	20	3.21	3.40	LPL   	HKG
2031193	20	3.41	3.60	LPL   	HKG
2031194	20	3.61	3.80	LPL   	HKG
2031195	20	3.81	4.00	LPL   	HKG
2031196	20	4.01	4.20	LPL   	HKG
2031197	20	4.21	4.40	LPL   	HKG
2031198	20	4.41	4.60	LPL   	HKG
2031199	20	4.61	4.80	LPL   	HKG
2031200	20	4.81	5.00	LPL   	HKG
2031201	20	5.01	5.20	LPL   	HKG
2031202	20	5.21	5.40	LPL   	HKG
2031203	20	5.41	5.60	LPL   	HKG
2031204	20	5.61	5.80	LPL   	HKG
2031205	20	5.81	6.00	LPL   	HKG
2031206	20	6.01	6.20	LPL   	HKG
2031207	20	6.21	6.40	LPL   	HKG
2031208	20	6.41	6.60	LPL   	HKG
2031209	20	6.61	6.80	LPL   	HKG
2031210	20	6.81	7.00	LPL   	HKG
2031211	20	7.01	7.20	LPL   	HKG
2031212	20	7.21	7.40	LPL   	HKG
2031213	20	7.41	7.60	LPL   	HKG
2031214	20	7.61	7.80	LPL   	HKG
2031215	20	7.81	8.00	LPL   	HKG
2031216	20	8.01	8.20	LPL   	HKG
2031217	20	8.21	8.40	LPL   	HKG
2031218	20	8.41	8.60	LPL   	HKG
2031219	20	8.61	8.80	LPL   	HKG
2031220	20	8.81	9.00	LPL   	HKG
2031221	20	9.01	9.20	LPL   	HKG
2031222	20	9.21	9.40	LPL   	HKG
2031223	20	9.41	9.60	LPL   	HKG
2031224	20	9.61	9.80	LPL   	HKG
2031225	20	9.81	10.00	LPL   	HKG
2031226	20	10.01	10.20	LPL   	HKG
2031227	20	10.21	10.40	LPL   	HKG
2031228	20	10.41	10.60	LPL   	HKG
2031229	20	10.61	10.80	LPL   	HKG
2031230	20	10.81	11.00	LPL   	HKG
2031231	20	11.01	11.20	LPL   	HKG
2031232	20	11.21	11.40	LPL   	HKG
2031233	20	11.41	11.60	LPL   	HKG
2031234	20	11.61	11.80	LPL   	HKG
2031235	20	11.81	12.00	LPL   	HKG
2031236	20	12.01	12.20	LPL   	HKG
2031237	20	12.21	12.40	LPL   	HKG
2031238	20	12.41	12.60	LPL   	HKG
2031239	20	12.61	12.80	LPL   	HKG
2031240	20	12.81	13.00	LPL   	HKG
2031241	20	13.01	13.20	LPL   	HKG
2031242	20	13.21	13.40	LPL   	HKG
2031243	20	13.41	13.60	LPL   	HKG
2031244	20	13.61	13.80	LPL   	HKG
2031245	20	13.81	14.00	LPL   	HKG
2031246	20	14.01	14.20	LPL   	HKG
2031247	20	14.21	14.40	LPL   	HKG
2031248	20	14.41	14.60	LPL   	HKG
2031249	20	14.61	14.80	LPL   	HKG
2031250	20	14.81	15.00	LPL   	HKG
2031251	20	15.01	15.20	LPL   	HKG
2031252	20	15.21	15.40	LPL   	HKG
2031253	20	15.41	15.60	LPL   	HKG
2031254	20	15.61	15.80	LPL   	HKG
2031255	20	15.81	16.00	LPL   	HKG
2031256	20	16.01	16.20	LPL   	HKG
2031257	20	16.21	16.40	LPL   	HKG
2031258	20	16.41	16.60	LPL   	HKG
2031259	20	16.61	16.80	LPL   	HKG
2031260	20	16.81	17.00	LPL   	HKG
2031261	20	17.01	17.20	LPL   	HKG
2031262	20	17.21	17.40	LPL   	HKG
2031263	20	17.41	17.60	LPL   	HKG
2031264	20	17.61	17.80	LPL   	HKG
2031265	20	17.81	18.00	LPL   	HKG
2031266	20	18.01	18.20	LPL   	HKG
2031267	20	18.21	18.40	LPL   	HKG
2031268	20	18.41	18.60	LPL   	HKG
2031269	20	18.61	18.80	LPL   	HKG
2031270	20	18.81	19.00	LPL   	HKG
2031271	20	19.01	19.20	LPL   	HKG
2031272	20	19.21	19.40	LPL   	HKG
2031273	20	19.41	19.60	LPL   	HKG
2031274	20	19.61	19.80	LPL   	HKG
2031275	20	19.81	20.00	LPL   	HKG
2031277	30	0.01	0.20	APL   	NZA
2031278	30	0.21	0.40	APL   	NZA
2031279	30	0.41	0.60	APL   	NZA
2031280	30	0.61	0.80	APL   	NZA
2031281	30	0.81	1.00	APL   	NZA
2031282	30	1.01	1.20	APL   	NZA
2031283	30	1.21	1.40	APL   	NZA
2031284	30	1.41	1.60	APL   	NZA
2031285	30	1.61	1.80	APL   	NZA
2031286	30	1.81	2.00	APL   	NZA
2031287	30	2.01	2.20	APL   	NZA
2031288	30	2.21	2.40	APL   	NZA
2031289	30	2.41	2.60	APL   	NZA
2031290	30	2.61	2.80	APL   	NZA
2031291	30	2.81	3.00	APL   	NZA
2031292	30	3.01	3.20	APL   	NZA
2031293	30	3.21	3.40	APL   	NZA
2031294	30	3.41	3.60	APL   	NZA
2031295	30	3.61	3.80	APL   	NZA
2031296	30	3.81	4.00	APL   	NZA
2031297	30	4.01	4.20	APL   	NZA
2031298	30	4.21	4.40	APL   	NZA
2031299	30	4.41	4.60	APL   	NZA
2031300	30	4.61	4.80	APL   	NZA
2031301	30	4.81	5.00	APL   	NZA
2031302	30	5.01	5.20	APL   	NZA
2031303	30	5.21	5.40	APL   	NZA
2031304	30	5.41	5.60	APL   	NZA
2031305	30	5.61	5.80	APL   	NZA
2031306	30	5.81	6.00	APL   	NZA
2031307	30	6.01	6.20	APL   	NZA
2031308	30	6.21	6.40	APL   	NZA
2031309	30	6.41	6.60	APL   	NZA
2031310	30	6.61	6.80	APL   	NZA
2031311	30	6.81	7.00	APL   	NZA
2031312	30	7.01	7.20	APL   	NZA
2031313	30	7.21	7.40	APL   	NZA
2031314	30	7.41	7.60	APL   	NZA
2031315	30	7.61	7.80	APL   	NZA
2031316	30	7.81	8.00	APL   	NZA
2031317	30	8.01	8.20	APL   	NZA
2031318	30	8.21	8.40	APL   	NZA
2031319	30	8.41	8.60	APL   	NZA
2031320	30	8.61	8.80	APL   	NZA
2031321	30	8.81	9.00	APL   	NZA
2031322	30	9.01	9.20	APL   	NZA
2031323	30	9.21	9.40	APL   	NZA
2031324	30	9.41	9.60	APL   	NZA
2031325	30	9.61	9.80	APL   	NZA
2031326	30	9.81	10.00	APL   	NZA
2031327	30	10.01	10.20	APL   	NZA
2031328	30	10.21	10.40	APL   	NZA
2031329	30	10.41	10.60	APL   	NZA
2031330	30	10.61	10.80	APL   	NZA
2031331	30	10.81	11.00	APL   	NZA
2031332	30	11.01	11.20	APL   	NZA
2031333	30	11.21	11.40	APL   	NZA
2031334	30	11.41	11.60	APL   	NZA
2031335	30	11.61	11.80	APL   	NZA
2031336	30	11.81	12.00	APL   	NZA
2031337	30	12.01	12.20	APL   	NZA
2031338	30	12.21	12.40	APL   	NZA
2031339	30	12.41	12.60	APL   	NZA
2031340	30	12.61	12.80	APL   	NZA
2031341	30	12.81	13.00	APL   	NZA
2031342	30	13.01	13.20	APL   	NZA
2031343	30	13.21	13.40	APL   	NZA
2031344	30	13.41	13.60	APL   	NZA
2031345	30	13.61	13.80	APL   	NZA
2031346	30	13.81	14.00	APL   	NZA
2031347	30	14.01	14.20	APL   	NZA
2031348	30	14.21	14.40	APL   	NZA
2031349	30	14.41	14.60	APL   	NZA
2031350	30	14.61	14.80	APL   	NZA
2031351	30	14.81	15.00	APL   	NZA
2031352	30	15.01	15.20	APL   	NZA
2031353	30	15.21	15.40	APL   	NZA
2031354	30	15.41	15.60	APL   	NZA
2031355	30	15.61	15.80	APL   	NZA
2031356	30	15.81	16.00	APL   	NZA
2031357	30	16.01	16.20	APL   	NZA
2031358	30	16.21	16.40	APL   	NZA
2031359	30	16.41	16.60	APL   	NZA
2031360	30	16.61	16.80	APL   	NZA
2031361	30	16.81	17.00	APL   	NZA
2031362	30	17.01	17.20	APL   	NZA
2031363	30	17.21	17.40	APL   	NZA
2031364	30	17.41	17.60	APL   	NZA
2031365	30	17.61	17.80	APL   	NZA
2031366	30	17.81	18.00	APL   	NZA
2031367	30	18.01	18.20	APL   	NZA
2031368	30	18.21	18.40	APL   	NZA
2031369	30	18.41	18.60	APL   	NZA
2031370	30	18.61	18.80	APL   	NZA
2031371	30	18.81	19.00	APL   	NZA
2031372	30	19.01	19.20	APL   	NZA
2031373	30	19.21	19.40	APL   	NZA
2031374	30	19.41	19.60	APL   	NZA
2031375	30	19.61	19.80	APL   	NZA
2031376	30	19.81	20.00	APL   	NZA
2031377	30	20.01	20.20	APL   	NZA
2031378	30	20.21	20.40	APL   	NZA
2031379	30	20.41	20.60	APL   	NZA
2031380	30	20.61	20.80	APL   	NZA
2031381	30	20.81	21.00	APL   	NZA
2031382	30	21.01	21.20	APL   	NZA
2031383	30	21.21	21.40	APL   	NZA
2031384	30	21.41	21.60	APL   	NZA
2031385	30	21.61	21.80	APL   	NZA
2031386	30	21.81	22.00	APL   	NZA
2031387	30	22.01	22.20	APL   	NZA
2031388	30	22.21	22.40	APL   	NZA
2031389	30	22.41	22.60	APL   	NZA
2031390	30	22.61	22.80	APL   	NZA
2031391	30	22.81	23.00	APL   	NZA
2031392	30	23.01	23.20	APL   	NZA
2031393	30	23.21	23.40	APL   	NZA
2031394	30	23.41	23.60	APL   	NZA
2031395	30	23.61	23.80	APL   	NZA
2031396	30	23.81	24.00	APL   	NZA
2031397	30	24.01	24.20	APL   	NZA
2031398	30	24.21	24.40	APL   	NZA
2031399	30	24.41	24.60	APL   	NZA
2031400	30	24.61	24.80	APL   	NZA
2031401	30	24.81	25.00	APL   	NZA
2031402	30	25.01	25.20	APL   	NZA
2031403	30	25.21	25.40	APL   	NZA
2031404	30	25.41	25.60	APL   	NZA
2031405	30	25.61	25.80	APL   	NZA
2031406	30	25.81	26.00	APL   	NZA
2031407	30	26.01	26.20	APL   	NZA
2031408	30	26.21	26.40	APL   	NZA
2031409	30	26.41	26.60	APL   	NZA
2031410	30	26.61	26.80	APL   	NZA
2031411	30	26.81	27.00	APL   	NZA
2031412	30	27.01	27.20	APL   	NZA
2031413	30	27.21	27.40	APL   	NZA
2031414	30	27.41	27.60	APL   	NZA
2031415	30	27.61	27.80	APL   	NZA
2031416	30	27.81	28.00	APL   	NZA
2031417	30	28.01	28.20	APL   	NZA
2031418	30	28.21	28.40	APL   	NZA
2031419	30	28.41	28.60	APL   	NZA
2031420	30	28.61	28.80	APL   	NZA
2031421	30	28.81	29.00	APL   	NZA
2031422	30	29.01	29.20	APL   	NZA
2031423	30	29.21	29.40	APL   	NZA
2031424	30	29.41	29.60	APL   	NZA
2031425	30	29.61	29.80	APL   	NZA
2031426	30	29.81	30.00	APL   	NZA
2031427	30	0.01	0.20	SPL   	NZA
2031428	30	0.21	0.40	SPL   	NZA
2031429	30	0.41	0.60	SPL   	NZA
2031430	30	0.61	0.80	SPL   	NZA
2031431	30	0.81	1.00	SPL   	NZA
2031432	30	1.01	1.20	SPL   	NZA
2031433	30	1.21	1.40	SPL   	NZA
2031434	30	1.41	1.60	SPL   	NZA
2031435	30	1.61	1.80	SPL   	NZA
2031436	30	1.81	2.00	SPL   	NZA
2031437	30	2.01	2.20	SPL   	NZA
2031438	30	2.21	2.40	SPL   	NZA
2031439	30	2.41	2.60	SPL   	NZA
2031440	30	2.61	2.80	SPL   	NZA
2031441	30	2.81	3.00	SPL   	NZA
2031442	30	3.01	3.20	SPL   	NZA
2031443	30	3.21	3.40	SPL   	NZA
2031444	30	3.41	3.60	SPL   	NZA
2031445	30	3.61	3.80	SPL   	NZA
2031446	30	3.81	4.00	SPL   	NZA
2031447	30	4.01	4.20	SPL   	NZA
2031448	30	4.21	4.40	SPL   	NZA
2031449	30	4.41	4.60	SPL   	NZA
2031450	30	4.61	4.80	SPL   	NZA
2031451	30	4.81	5.00	SPL   	NZA
2031452	30	5.01	5.20	SPL   	NZA
2031453	30	5.21	5.40	SPL   	NZA
2031454	30	5.41	5.60	SPL   	NZA
2031455	30	5.61	5.80	SPL   	NZA
2031456	30	5.81	6.00	SPL   	NZA
2031457	30	6.01	6.20	SPL   	NZA
2031458	30	6.21	6.40	SPL   	NZA
2031459	30	6.41	6.60	SPL   	NZA
2031460	30	6.61	6.80	SPL   	NZA
2031461	30	6.81	7.00	SPL   	NZA
2031462	30	7.01	7.20	SPL   	NZA
2031463	30	7.21	7.40	SPL   	NZA
2031464	30	7.41	7.60	SPL   	NZA
2031465	30	7.61	7.80	SPL   	NZA
2031466	30	7.81	8.00	SPL   	NZA
2031467	30	8.01	8.20	SPL   	NZA
2031468	30	8.21	8.40	SPL   	NZA
2031469	30	8.41	8.60	SPL   	NZA
2031470	30	8.61	8.80	SPL   	NZA
2031471	30	8.81	9.00	SPL   	NZA
2031472	30	9.01	9.20	SPL   	NZA
2031473	30	9.21	9.40	SPL   	NZA
2031474	30	9.41	9.60	SPL   	NZA
2031475	30	9.61	9.80	SPL   	NZA
2031476	30	9.81	10.00	SPL   	NZA
2031477	30	10.01	10.20	SPL   	NZA
2031478	30	10.21	10.40	SPL   	NZA
2031479	30	10.41	10.60	SPL   	NZA
2031480	30	10.61	10.80	SPL   	NZA
2031481	30	10.81	11.00	SPL   	NZA
2031482	30	11.01	11.20	SPL   	NZA
2031483	30	11.21	11.40	SPL   	NZA
2031484	30	11.41	11.60	SPL   	NZA
2031485	30	11.61	11.80	SPL   	NZA
2031486	30	11.81	12.00	SPL   	NZA
2031487	30	12.01	12.20	SPL   	NZA
2031488	30	12.21	12.40	SPL   	NZA
2031489	30	12.41	12.60	SPL   	NZA
2031490	30	12.61	12.80	SPL   	NZA
2031491	30	12.81	13.00	SPL   	NZA
2031492	30	13.01	13.20	SPL   	NZA
2031493	30	13.21	13.40	SPL   	NZA
2031494	30	13.41	13.60	SPL   	NZA
2031495	30	13.61	13.80	SPL   	NZA
2031496	30	13.81	14.00	SPL   	NZA
2031497	30	14.01	14.20	SPL   	NZA
2031498	30	14.21	14.40	SPL   	NZA
2031499	30	14.41	14.60	SPL   	NZA
2031500	30	14.61	14.80	SPL   	NZA
2031501	30	14.81	15.00	SPL   	NZA
2031502	30	15.01	15.20	SPL   	NZA
2031503	30	15.21	15.40	SPL   	NZA
2031504	30	15.41	15.60	SPL   	NZA
2031505	30	15.61	15.80	SPL   	NZA
2031506	30	15.81	16.00	SPL   	NZA
2031507	30	16.01	16.20	SPL   	NZA
2031508	30	16.21	16.40	SPL   	NZA
2031509	30	16.41	16.60	SPL   	NZA
2031510	30	16.61	16.80	SPL   	NZA
2031511	30	16.81	17.00	SPL   	NZA
2031512	30	17.01	17.20	SPL   	NZA
2031513	30	17.21	17.40	SPL   	NZA
2031514	30	17.41	17.60	SPL   	NZA
2031515	30	17.61	17.80	SPL   	NZA
2031516	30	17.81	18.00	SPL   	NZA
2031517	30	18.01	18.20	SPL   	NZA
2031518	30	18.21	18.40	SPL   	NZA
2031519	30	18.41	18.60	SPL   	NZA
2031520	30	18.61	18.80	SPL   	NZA
2031521	30	18.81	19.00	SPL   	NZA
2031522	30	19.01	19.20	SPL   	NZA
2031523	30	19.21	19.40	SPL   	NZA
2031524	30	19.41	19.60	SPL   	NZA
2031525	30	19.61	19.80	SPL   	NZA
2031526	30	19.81	20.00	SPL   	NZA
2031527	30	20.01	20.20	SPL   	NZA
2031528	30	20.21	20.40	SPL   	NZA
2031529	30	20.41	20.60	SPL   	NZA
2031530	30	20.61	20.80	SPL   	NZA
2031531	30	20.81	21.00	SPL   	NZA
2031532	30	21.01	21.20	SPL   	NZA
2031533	30	21.21	21.40	SPL   	NZA
2031534	30	21.41	21.60	SPL   	NZA
2031535	30	21.61	21.80	SPL   	NZA
2031536	30	21.81	22.00	SPL   	NZA
2031537	30	22.01	22.20	SPL   	NZA
2031538	30	22.21	22.40	SPL   	NZA
2031539	30	22.41	22.60	SPL   	NZA
2031540	30	22.61	22.80	SPL   	NZA
2031541	30	22.81	23.00	SPL   	NZA
2031542	30	23.01	23.20	SPL   	NZA
2031543	30	23.21	23.40	SPL   	NZA
2031544	30	23.41	23.60	SPL   	NZA
2031545	30	23.61	23.80	SPL   	NZA
2031546	30	23.81	24.00	SPL   	NZA
2031547	30	24.01	24.20	SPL   	NZA
2031548	30	24.21	24.40	SPL   	NZA
2031549	30	24.41	24.60	SPL   	NZA
2031550	30	24.61	24.80	SPL   	NZA
2031551	30	24.81	25.00	SPL   	NZA
2031552	30	25.01	25.20	SPL   	NZA
2031553	30	25.21	25.40	SPL   	NZA
2031554	30	25.41	25.60	SPL   	NZA
2031555	30	25.61	25.80	SPL   	NZA
2031556	30	25.81	26.00	SPL   	NZA
2031557	30	26.01	26.20	SPL   	NZA
2031558	30	26.21	26.40	SPL   	NZA
2031559	30	26.41	26.60	SPL   	NZA
2031560	30	26.61	26.80	SPL   	NZA
2031561	30	26.81	27.00	SPL   	NZA
2031562	30	27.01	27.20	SPL   	NZA
2031563	30	27.21	27.40	SPL   	NZA
2031564	30	27.41	27.60	SPL   	NZA
2031565	30	27.61	27.80	SPL   	NZA
2031566	30	27.81	28.00	SPL   	NZA
2031567	30	28.01	28.20	SPL   	NZA
2031568	30	28.21	28.40	SPL   	NZA
2031569	30	28.41	28.60	SPL   	NZA
2031570	30	28.61	28.80	SPL   	NZA
2031571	30	28.81	29.00	SPL   	NZA
2031572	30	29.01	29.20	SPL   	NZA
2031573	30	29.21	29.40	SPL   	NZA
2031574	30	29.41	29.60	SPL   	NZA
2031575	30	29.61	29.80	SPL   	NZA
2031576	30	29.81	30.00	SPL   	NZA
2031577	2	0.01	0.20	AEX   	NZA
2031578	2	0.21	0.40	AEX   	NZA
2031579	2	0.41	0.60	AEX   	NZA
2031580	2	0.61	0.80	AEX   	NZA
2031581	2	0.81	1.00	AEX   	NZA
2031582	2	1.01	1.20	AEX   	NZA
2031583	2	1.21	1.40	AEX   	NZA
2031584	2	1.41	1.60	AEX   	NZA
2031585	2	1.61	1.80	AEX   	NZA
2031586	2	1.81	2.00	AEX   	NZA
2031587	30	0.01	0.20	EMS   	NZA
2031588	30	0.21	0.40	EMS   	NZA
2031589	30	0.41	0.60	EMS   	NZA
2031590	30	0.61	0.80	EMS   	NZA
2031591	30	0.81	1.00	EMS   	NZA
2031592	30	1.01	1.20	EMS   	NZA
2031593	30	1.21	1.40	EMS   	NZA
2031594	30	1.41	1.60	EMS   	NZA
2031595	30	1.61	1.80	EMS   	NZA
2031596	30	1.81	2.00	EMS   	NZA
2031597	30	2.01	2.20	EMS   	NZA
2031598	30	2.21	2.40	EMS   	NZA
2031599	30	2.41	2.60	EMS   	NZA
2031600	30	2.61	2.80	EMS   	NZA
2031601	30	2.81	3.00	EMS   	NZA
2031602	30	3.01	3.20	EMS   	NZA
2031603	30	3.21	3.40	EMS   	NZA
2031604	30	3.41	3.60	EMS   	NZA
2031605	30	3.61	3.80	EMS   	NZA
2031606	30	3.81	4.00	EMS   	NZA
2031607	30	4.01	4.20	EMS   	NZA
2031608	30	4.21	4.40	EMS   	NZA
2031609	30	4.41	4.60	EMS   	NZA
2031610	30	4.61	4.80	EMS   	NZA
2031611	30	4.81	5.00	EMS   	NZA
2031612	30	5.01	5.20	EMS   	NZA
2031613	30	5.21	5.40	EMS   	NZA
2031614	30	5.41	5.60	EMS   	NZA
2031615	30	5.61	5.80	EMS   	NZA
2031616	30	5.81	6.00	EMS   	NZA
2031617	30	6.01	6.20	EMS   	NZA
2031618	30	6.21	6.40	EMS   	NZA
2031619	30	6.41	6.60	EMS   	NZA
2031620	30	6.61	6.80	EMS   	NZA
2031621	30	6.81	7.00	EMS   	NZA
2031622	30	7.01	7.20	EMS   	NZA
2031623	30	7.21	7.40	EMS   	NZA
2031624	30	7.41	7.60	EMS   	NZA
2031625	30	7.61	7.80	EMS   	NZA
2031626	30	7.81	8.00	EMS   	NZA
2031627	30	8.01	8.20	EMS   	NZA
2031628	30	8.21	8.40	EMS   	NZA
2031629	30	8.41	8.60	EMS   	NZA
2031630	30	8.61	8.80	EMS   	NZA
2031631	30	8.81	9.00	EMS   	NZA
2031632	30	9.01	9.20	EMS   	NZA
2031633	30	9.21	9.40	EMS   	NZA
2031634	30	9.41	9.60	EMS   	NZA
2031635	30	9.61	9.80	EMS   	NZA
2031636	30	9.81	10.00	EMS   	NZA
2031637	30	10.01	10.20	EMS   	NZA
2031638	30	10.21	10.40	EMS   	NZA
2031639	30	10.41	10.60	EMS   	NZA
2031640	30	10.61	10.80	EMS   	NZA
2031641	30	10.81	11.00	EMS   	NZA
2031642	30	11.01	11.20	EMS   	NZA
2031643	30	11.21	11.40	EMS   	NZA
2031644	30	11.41	11.60	EMS   	NZA
2031645	30	11.61	11.80	EMS   	NZA
2031646	30	11.81	12.00	EMS   	NZA
2031647	30	12.01	12.20	EMS   	NZA
2031648	30	12.21	12.40	EMS   	NZA
2031649	30	12.41	12.60	EMS   	NZA
2031650	30	12.61	12.80	EMS   	NZA
2031651	30	12.81	13.00	EMS   	NZA
2031652	30	13.01	13.20	EMS   	NZA
2031653	30	13.21	13.40	EMS   	NZA
2031654	30	13.41	13.60	EMS   	NZA
2031655	30	13.61	13.80	EMS   	NZA
2031656	30	13.81	14.00	EMS   	NZA
2031657	30	14.01	14.20	EMS   	NZA
2031658	30	14.21	14.40	EMS   	NZA
2031659	30	14.41	14.60	EMS   	NZA
2031660	30	14.61	14.80	EMS   	NZA
2031661	30	14.81	15.00	EMS   	NZA
2031662	30	15.01	15.20	EMS   	NZA
2031663	30	15.21	15.40	EMS   	NZA
2031664	30	15.41	15.60	EMS   	NZA
2031665	30	15.61	15.80	EMS   	NZA
2031666	30	15.81	16.00	EMS   	NZA
2031667	30	16.01	16.20	EMS   	NZA
2031668	30	16.21	16.40	EMS   	NZA
2031669	30	16.41	16.60	EMS   	NZA
2031670	30	16.61	16.80	EMS   	NZA
2031671	30	16.81	17.00	EMS   	NZA
2031672	30	17.01	17.20	EMS   	NZA
2031673	30	17.21	17.40	EMS   	NZA
2031674	30	17.41	17.60	EMS   	NZA
2031675	30	17.61	17.80	EMS   	NZA
2031676	30	17.81	18.00	EMS   	NZA
2031677	30	18.01	18.20	EMS   	NZA
2031678	30	18.21	18.40	EMS   	NZA
2031679	30	18.41	18.60	EMS   	NZA
2031680	30	18.61	18.80	EMS   	NZA
2031681	30	18.81	19.00	EMS   	NZA
2031682	30	19.01	19.20	EMS   	NZA
2031683	30	19.21	19.40	EMS   	NZA
2031684	30	19.41	19.60	EMS   	NZA
2031685	30	19.61	19.80	EMS   	NZA
2031686	30	19.81	20.00	EMS   	NZA
2031687	30	20.01	20.20	EMS   	NZA
2031688	30	20.21	20.40	EMS   	NZA
2031689	30	20.41	20.60	EMS   	NZA
2031690	30	20.61	20.80	EMS   	NZA
2031691	30	20.81	21.00	EMS   	NZA
2031692	30	21.01	21.20	EMS   	NZA
2031693	30	21.21	21.40	EMS   	NZA
2031694	30	21.41	21.60	EMS   	NZA
2031695	30	21.61	21.80	EMS   	NZA
2031696	30	21.81	22.00	EMS   	NZA
2031697	30	22.01	22.20	EMS   	NZA
2031698	30	22.21	22.40	EMS   	NZA
2031699	30	22.41	22.60	EMS   	NZA
2031700	30	22.61	22.80	EMS   	NZA
2031701	30	22.81	23.00	EMS   	NZA
2031702	30	23.01	23.20	EMS   	NZA
2031703	30	23.21	23.40	EMS   	NZA
2031704	30	23.41	23.60	EMS   	NZA
2031705	30	23.61	23.80	EMS   	NZA
2031706	30	23.81	24.00	EMS   	NZA
2031707	30	24.01	24.20	EMS   	NZA
2031708	30	24.21	24.40	EMS   	NZA
2031709	30	24.41	24.60	EMS   	NZA
2031710	30	24.61	24.80	EMS   	NZA
2031711	30	24.81	25.00	EMS   	NZA
2031712	30	25.01	25.20	EMS   	NZA
2031713	30	25.21	25.40	EMS   	NZA
2031714	30	25.41	25.60	EMS   	NZA
2031715	30	25.61	25.80	EMS   	NZA
2031716	30	25.81	26.00	EMS   	NZA
2031717	30	26.01	26.20	EMS   	NZA
2031718	30	26.21	26.40	EMS   	NZA
2031719	30	26.41	26.60	EMS   	NZA
2031720	30	26.61	26.80	EMS   	NZA
2031721	30	26.81	27.00	EMS   	NZA
2031722	30	27.01	27.20	EMS   	NZA
2031723	30	27.21	27.40	EMS   	NZA
2031724	30	27.41	27.60	EMS   	NZA
2031725	30	27.61	27.80	EMS   	NZA
2031726	30	27.81	28.00	EMS   	NZA
2031727	30	28.01	28.20	EMS   	NZA
2031728	30	28.21	28.40	EMS   	NZA
2031729	30	28.41	28.60	EMS   	NZA
2031730	30	28.61	28.80	EMS   	NZA
2031731	30	28.81	29.00	EMS   	NZA
2031732	30	29.01	29.20	EMS   	NZA
2031733	30	29.21	29.40	EMS   	NZA
2031734	30	29.41	29.60	EMS   	NZA
2031735	30	29.61	29.80	EMS   	NZA
2031736	30	29.81	30.00	EMS   	NZA
2031737	30	0.01	0.20	EMSMPB	NZA
2031738	30	0.21	0.40	EMSMPB	NZA
2031739	30	0.41	0.60	EMSMPB	NZA
2031740	30	0.61	0.80	EMSMPB	NZA
2031741	30	0.81	1.00	EMSMPB	NZA
2031742	30	1.01	1.20	EMSMPB	NZA
2031743	30	1.21	1.40	EMSMPB	NZA
2031744	30	1.41	1.60	EMSMPB	NZA
2031745	30	1.61	1.80	EMSMPB	NZA
2031746	30	1.81	2.00	EMSMPB	NZA
2031747	30	2.01	2.20	EMSMPB	NZA
2031748	30	2.21	2.40	EMSMPB	NZA
2031749	30	2.41	2.60	EMSMPB	NZA
2031750	30	2.61	2.80	EMSMPB	NZA
2031751	30	2.81	3.00	EMSMPB	NZA
2031752	30	3.01	3.20	EMSMPB	NZA
2031753	30	3.21	3.40	EMSMPB	NZA
2031754	30	3.41	3.60	EMSMPB	NZA
2031755	30	3.61	3.80	EMSMPB	NZA
2031756	30	3.81	4.00	EMSMPB	NZA
2031757	30	4.01	4.20	EMSMPB	NZA
2031758	30	4.21	4.40	EMSMPB	NZA
2031759	30	4.41	4.60	EMSMPB	NZA
2031760	30	4.61	4.80	EMSMPB	NZA
2031761	30	4.81	5.00	EMSMPB	NZA
2031762	30	5.01	5.20	EMSMPB	NZA
2031763	30	5.21	5.40	EMSMPB	NZA
2031764	30	5.41	5.60	EMSMPB	NZA
2031765	30	5.61	5.80	EMSMPB	NZA
2031766	30	5.81	6.00	EMSMPB	NZA
2031767	30	6.01	6.20	EMSMPB	NZA
2031768	30	6.21	6.40	EMSMPB	NZA
2031769	30	6.41	6.60	EMSMPB	NZA
2031770	30	6.61	6.80	EMSMPB	NZA
2031771	30	6.81	7.00	EMSMPB	NZA
2031772	30	7.01	7.20	EMSMPB	NZA
2031773	30	7.21	7.40	EMSMPB	NZA
2031774	30	7.41	7.60	EMSMPB	NZA
2031775	30	7.61	7.80	EMSMPB	NZA
2031776	30	7.81	8.00	EMSMPB	NZA
2031777	30	8.01	8.20	EMSMPB	NZA
2031778	30	8.21	8.40	EMSMPB	NZA
2031779	30	8.41	8.60	EMSMPB	NZA
2031780	30	8.61	8.80	EMSMPB	NZA
2031781	30	8.81	9.00	EMSMPB	NZA
2031782	30	9.01	9.20	EMSMPB	NZA
2031783	30	9.21	9.40	EMSMPB	NZA
2031784	30	9.41	9.60	EMSMPB	NZA
2031785	30	9.61	9.80	EMSMPB	NZA
2031786	30	9.81	10.00	EMSMPB	NZA
2031787	30	10.01	10.20	EMSMPB	NZA
2031788	30	10.21	10.40	EMSMPB	NZA
2031789	30	10.41	10.60	EMSMPB	NZA
2031790	30	10.61	10.80	EMSMPB	NZA
2031791	30	10.81	11.00	EMSMPB	NZA
2031792	30	11.01	11.20	EMSMPB	NZA
2031793	30	11.21	11.40	EMSMPB	NZA
2031794	30	11.41	11.60	EMSMPB	NZA
2031795	30	11.61	11.80	EMSMPB	NZA
2031796	30	11.81	12.00	EMSMPB	NZA
2031797	30	12.01	12.20	EMSMPB	NZA
2031798	30	12.21	12.40	EMSMPB	NZA
2031799	30	12.41	12.60	EMSMPB	NZA
2031800	30	12.61	12.80	EMSMPB	NZA
2031801	30	12.81	13.00	EMSMPB	NZA
2031802	30	13.01	13.20	EMSMPB	NZA
2031803	30	13.21	13.40	EMSMPB	NZA
2031804	30	13.41	13.60	EMSMPB	NZA
2031805	30	13.61	13.80	EMSMPB	NZA
2031806	30	13.81	14.00	EMSMPB	NZA
2031807	30	14.01	14.20	EMSMPB	NZA
2031808	30	14.21	14.40	EMSMPB	NZA
2031809	30	14.41	14.60	EMSMPB	NZA
2031810	30	14.61	14.80	EMSMPB	NZA
2031811	30	14.81	15.00	EMSMPB	NZA
2031812	30	15.01	15.20	EMSMPB	NZA
2031813	30	15.21	15.40	EMSMPB	NZA
2031814	30	15.41	15.60	EMSMPB	NZA
2031815	30	15.61	15.80	EMSMPB	NZA
2031816	30	15.81	16.00	EMSMPB	NZA
2031817	30	16.01	16.20	EMSMPB	NZA
2031818	30	16.21	16.40	EMSMPB	NZA
2031819	30	16.41	16.60	EMSMPB	NZA
2031820	30	16.61	16.80	EMSMPB	NZA
2031821	30	16.81	17.00	EMSMPB	NZA
2031822	30	17.01	17.20	EMSMPB	NZA
2031823	30	17.21	17.40	EMSMPB	NZA
2031824	30	17.41	17.60	EMSMPB	NZA
2031825	30	17.61	17.80	EMSMPB	NZA
2031826	30	17.81	18.00	EMSMPB	NZA
2031827	30	18.01	18.20	EMSMPB	NZA
2031828	30	18.21	18.40	EMSMPB	NZA
2031829	30	18.41	18.60	EMSMPB	NZA
2031830	30	18.61	18.80	EMSMPB	NZA
2031831	30	18.81	19.00	EMSMPB	NZA
2031832	30	19.01	19.20	EMSMPB	NZA
2031833	30	19.21	19.40	EMSMPB	NZA
2031834	30	19.41	19.60	EMSMPB	NZA
2031835	30	19.61	19.80	EMSMPB	NZA
2031836	30	19.81	20.00	EMSMPB	NZA
2031837	30	20.01	20.20	EMSMPB	NZA
2031838	30	20.21	20.40	EMSMPB	NZA
2031839	30	20.41	20.60	EMSMPB	NZA
2031840	30	20.61	20.80	EMSMPB	NZA
2031841	30	20.81	21.00	EMSMPB	NZA
2031842	30	21.01	21.20	EMSMPB	NZA
2031843	30	21.21	21.40	EMSMPB	NZA
2031844	30	21.41	21.60	EMSMPB	NZA
2031845	30	21.61	21.80	EMSMPB	NZA
2031846	30	21.81	22.00	EMSMPB	NZA
2031847	30	22.01	22.20	EMSMPB	NZA
2031848	30	22.21	22.40	EMSMPB	NZA
2031849	30	22.41	22.60	EMSMPB	NZA
2031850	30	22.61	22.80	EMSMPB	NZA
2031851	30	22.81	23.00	EMSMPB	NZA
2031852	30	23.01	23.20	EMSMPB	NZA
2031853	30	23.21	23.40	EMSMPB	NZA
2031854	30	23.41	23.60	EMSMPB	NZA
2031855	30	23.61	23.80	EMSMPB	NZA
2031856	30	23.81	24.00	EMSMPB	NZA
2031857	30	24.01	24.20	EMSMPB	NZA
2031858	30	24.21	24.40	EMSMPB	NZA
2031859	30	24.41	24.60	EMSMPB	NZA
2031860	30	24.61	24.80	EMSMPB	NZA
2031861	30	24.81	25.00	EMSMPB	NZA
2031862	30	25.01	25.20	EMSMPB	NZA
2031863	30	25.21	25.40	EMSMPB	NZA
2031864	30	25.41	25.60	EMSMPB	NZA
2031865	30	25.61	25.80	EMSMPB	NZA
2031866	30	25.81	26.00	EMSMPB	NZA
2031867	30	26.01	26.20	EMSMPB	NZA
2031868	30	26.21	26.40	EMSMPB	NZA
2031869	30	26.41	26.60	EMSMPB	NZA
2031870	30	26.61	26.80	EMSMPB	NZA
2031871	30	26.81	27.00	EMSMPB	NZA
2031872	30	27.01	27.20	EMSMPB	NZA
2031873	30	27.21	27.40	EMSMPB	NZA
2031874	30	27.41	27.60	EMSMPB	NZA
2031875	30	27.61	27.80	EMSMPB	NZA
2031876	30	27.81	28.00	EMSMPB	NZA
2031877	30	28.01	28.20	EMSMPB	NZA
2031878	30	28.21	28.40	EMSMPB	NZA
2031879	30	28.41	28.60	EMSMPB	NZA
2031880	30	28.61	28.80	EMSMPB	NZA
2031881	30	28.81	29.00	EMSMPB	NZA
2031882	30	29.01	29.20	EMSMPB	NZA
2031883	30	29.21	29.40	EMSMPB	NZA
2031884	30	29.41	29.60	EMSMPB	NZA
2031885	30	29.61	29.80	EMSMPB	NZA
2031886	30	29.81	30.00	EMSMPB	NZA
\.


--
-- Data for Name: product_shipping_attr_lcl; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.product_shipping_attr_lcl (prd_lcl_id, prd_id, prd_shp_typ_desc, prd_shp_ctry_desc, lcl_cd) FROM stdin;
442	2031066	EC-Get	Hong Kong SAR	en-GB
443	2031066	易寄取 	香港特別行政區	zh-HK
444	2031067	易寄取 	香港特別行政區	zh-HK
445	2031067	EC-Get	Hong Kong SAR	en-GB
446	2031068	EC-Get	Hong Kong SAR	en-GB
447	2031068	易寄取 	香港特別行政區	zh-HK
448	2031069	EC-Get	Hong Kong SAR	en-GB
449	2031069	易寄取 	香港特別行政區	zh-HK
450	2031070	易寄取 	香港特別行政區	zh-HK
451	2031070	EC-Get	Hong Kong SAR	en-GB
452	2031071	易寄取 	香港特別行政區	zh-HK
453	2031071	EC-Get	Hong Kong SAR	en-GB
454	2031072	EC-Get	Hong Kong SAR	en-GB
455	2031072	易寄取 	香港特別行政區	zh-HK
456	2031073	EC-Get	Hong Kong SAR	en-GB
457	2031073	易寄取 	香港特別行政區	zh-HK
458	2031074	EC-Get	Hong Kong SAR	en-GB
459	2031074	易寄取 	香港特別行政區	zh-HK
460	2031075	易寄取 	香港特別行政區	zh-HK
461	2031075	EC-Get	Hong Kong SAR	en-GB
462	2031076	易寄取 	香港特別行政區	zh-HK
463	2031076	EC-Get	Hong Kong SAR	en-GB
464	2031077	易寄取 	香港特別行政區	zh-HK
465	2031077	EC-Get	Hong Kong SAR	en-GB
466	2031078	易寄取 	香港特別行政區	zh-HK
467	2031078	EC-Get	Hong Kong SAR	en-GB
468	2031079	易寄取 	香港特別行政區	zh-HK
469	2031079	EC-Get	Hong Kong SAR	en-GB
470	2031080	EC-Get	Hong Kong SAR	en-GB
471	2031080	易寄取 	香港特別行政區	zh-HK
472	2031081	EC-Get	Hong Kong SAR	en-GB
473	2031081	易寄取 	香港特別行政區	zh-HK
474	2031082	EC-Get	Hong Kong SAR	en-GB
475	2031082	易寄取 	香港特別行政區	zh-HK
476	2031083	易寄取 	香港特別行政區	zh-HK
477	2031083	EC-Get	Hong Kong SAR	en-GB
478	2031084	易寄取 	香港特別行政區	zh-HK
479	2031084	EC-Get	Hong Kong SAR	en-GB
480	2031085	EC-Get	Hong Kong SAR	en-GB
481	2031085	易寄取 	香港特別行政區	zh-HK
482	2031086	EC-Get	Hong Kong SAR	en-GB
483	2031086	易寄取 	香港特別行政區	zh-HK
484	2031087	易寄取 	香港特別行政區	zh-HK
485	2031087	EC-Get	Hong Kong SAR	en-GB
486	2031088	EC-Get	Hong Kong SAR	en-GB
487	2031088	易寄取 	香港特別行政區	zh-HK
488	2031089	易寄取 	香港特別行政區	zh-HK
489	2031089	EC-Get	Hong Kong SAR	en-GB
490	2031090	易寄取 	香港特別行政區	zh-HK
491	2031090	EC-Get	Hong Kong SAR	en-GB
492	2031091	EC-Get	Hong Kong SAR	en-GB
493	2031091	易寄取 	香港特別行政區	zh-HK
494	2031092	EC-Get	Hong Kong SAR	en-GB
495	2031092	易寄取 	香港特別行政區	zh-HK
496	2031093	易寄取 	香港特別行政區	zh-HK
497	2031093	EC-Get	Hong Kong SAR	en-GB
498	2031094	EC-Get	Hong Kong SAR	en-GB
499	2031094	易寄取 	香港特別行政區	zh-HK
500	2031095	EC-Get	Hong Kong SAR	en-GB
501	2031095	易寄取 	香港特別行政區	zh-HK
502	2031096	EC-Get	Hong Kong SAR	en-GB
503	2031096	易寄取 	香港特別行政區	zh-HK
504	2031097	易寄取 	香港特別行政區	zh-HK
505	2031097	EC-Get	Hong Kong SAR	en-GB
506	2031098	EC-Get	Hong Kong SAR	en-GB
507	2031098	易寄取 	香港特別行政區	zh-HK
508	2031099	易寄取 	香港特別行政區	zh-HK
509	2031099	EC-Get	Hong Kong SAR	en-GB
510	2031100	易寄取 	香港特別行政區	zh-HK
511	2031100	EC-Get	Hong Kong SAR	en-GB
512	2031101	易寄取 	香港特別行政區	zh-HK
513	2031101	EC-Get	Hong Kong SAR	en-GB
514	2031102	EC-Get	Hong Kong SAR	en-GB
515	2031102	易寄取 	香港特別行政區	zh-HK
516	2031103	EC-Get	Hong Kong SAR	en-GB
517	2031103	易寄取 	香港特別行政區	zh-HK
518	2031104	易寄取 	香港特別行政區	zh-HK
519	2031104	EC-Get	Hong Kong SAR	en-GB
520	2031105	EC-Get	Hong Kong SAR	en-GB
521	2031105	易寄取 	香港特別行政區	zh-HK
522	2031106	EC-Get	Hong Kong SAR	en-GB
523	2031106	易寄取 	香港特別行政區	zh-HK
524	2031107	EC-Get	Hong Kong SAR	en-GB
525	2031107	易寄取 	香港特別行政區	zh-HK
526	2031108	易寄取 	香港特別行政區	zh-HK
527	2031108	EC-Get	Hong Kong SAR	en-GB
528	2031109	易寄取 	香港特別行政區	zh-HK
529	2031109	EC-Get	Hong Kong SAR	en-GB
530	2031110	易寄取 	香港特別行政區	zh-HK
531	2031110	EC-Get	Hong Kong SAR	en-GB
532	2031111	EC-Get	Hong Kong SAR	en-GB
533	2031111	易寄取 	香港特別行政區	zh-HK
534	2031112	EC-Get	Hong Kong SAR	en-GB
535	2031112	易寄取 	香港特別行政區	zh-HK
536	2031113	易寄取 	香港特別行政區	zh-HK
537	2031113	EC-Get	Hong Kong SAR	en-GB
538	2031114	易寄取 	香港特別行政區	zh-HK
539	2031114	EC-Get	Hong Kong SAR	en-GB
540	2031115	易寄取 	香港特別行政區	zh-HK
541	2031115	EC-Get	Hong Kong SAR	en-GB
542	2031116	易寄取 	香港特別行政區	zh-HK
543	2031116	EC-Get	Hong Kong SAR	en-GB
544	2031117	EC-Get	Hong Kong SAR	en-GB
545	2031117	易寄取 	香港特別行政區	zh-HK
546	2031118	易寄取 	香港特別行政區	zh-HK
547	2031118	EC-Get	Hong Kong SAR	en-GB
548	2031119	EC-Get	Hong Kong SAR	en-GB
549	2031119	易寄取 	香港特別行政區	zh-HK
550	2031120	EC-Get	Hong Kong SAR	en-GB
551	2031120	易寄取 	香港特別行政區	zh-HK
552	2031121	EC-Get	Hong Kong SAR	en-GB
553	2031121	易寄取 	香港特別行政區	zh-HK
554	2031122	EC-Get	Hong Kong SAR	en-GB
555	2031122	易寄取 	香港特別行政區	zh-HK
556	2031123	EC-Get	Hong Kong SAR	en-GB
557	2031123	易寄取 	香港特別行政區	zh-HK
558	2031124	EC-Get	Hong Kong SAR	en-GB
559	2031124	易寄取 	香港特別行政區	zh-HK
560	2031125	易寄取 	香港特別行政區	zh-HK
561	2031125	EC-Get	Hong Kong SAR	en-GB
562	2031126	易寄取 	香港特別行政區	zh-HK
563	2031126	EC-Get	Hong Kong SAR	en-GB
564	2031127	易寄取 	香港特別行政區	zh-HK
565	2031127	EC-Get	Hong Kong SAR	en-GB
566	2031128	EC-Get	Hong Kong SAR	en-GB
567	2031128	易寄取 	香港特別行政區	zh-HK
568	2031129	EC-Get	Hong Kong SAR	en-GB
569	2031129	易寄取 	香港特別行政區	zh-HK
570	2031130	EC-Get	Hong Kong SAR	en-GB
571	2031130	易寄取 	香港特別行政區	zh-HK
572	2031131	易寄取 	香港特別行政區	zh-HK
573	2031131	EC-Get	Hong Kong SAR	en-GB
574	2031132	易寄取 	香港特別行政區	zh-HK
575	2031132	EC-Get	Hong Kong SAR	en-GB
576	2031133	EC-Get	Hong Kong SAR	en-GB
577	2031133	易寄取 	香港特別行政區	zh-HK
578	2031134	易寄取 	香港特別行政區	zh-HK
579	2031134	EC-Get	Hong Kong SAR	en-GB
580	2031135	EC-Get	Hong Kong SAR	en-GB
581	2031135	易寄取 	香港特別行政區	zh-HK
582	2031136	易寄取 	香港特別行政區	zh-HK
583	2031136	EC-Get	Hong Kong SAR	en-GB
584	2031137	易寄取 	香港特別行政區	zh-HK
585	2031137	EC-Get	Hong Kong SAR	en-GB
586	2031138	易寄取 	香港特別行政區	zh-HK
587	2031138	EC-Get	Hong Kong SAR	en-GB
588	2031139	EC-Get	Hong Kong SAR	en-GB
589	2031139	易寄取 	香港特別行政區	zh-HK
590	2031140	EC-Get	Hong Kong SAR	en-GB
591	2031140	易寄取 	香港特別行政區	zh-HK
592	2031141	易寄取 	香港特別行政區	zh-HK
593	2031141	EC-Get	Hong Kong SAR	en-GB
594	2031142	EC-Get	Hong Kong SAR	en-GB
595	2031142	易寄取 	香港特別行政區	zh-HK
596	2031143	EC-Get	Hong Kong SAR	en-GB
597	2031143	易寄取 	香港特別行政區	zh-HK
598	2031144	EC-Get	Hong Kong SAR	en-GB
599	2031144	易寄取 	香港特別行政區	zh-HK
600	2031145	EC-Get	Hong Kong SAR	en-GB
601	2031145	易寄取 	香港特別行政區	zh-HK
602	2031146	EC-Get	Hong Kong SAR	en-GB
603	2031146	易寄取 	香港特別行政區	zh-HK
604	2031147	EC-Get	Hong Kong SAR	en-GB
605	2031147	易寄取 	香港特別行政區	zh-HK
606	2031148	易寄取 	香港特別行政區	zh-HK
607	2031148	EC-Get	Hong Kong SAR	en-GB
608	2031149	易寄取 	香港特別行政區	zh-HK
609	2031149	EC-Get	Hong Kong SAR	en-GB
610	2031150	EC-Get	Hong Kong SAR	en-GB
611	2031150	易寄取 	香港特別行政區	zh-HK
612	2031151	EC-Get	Hong Kong SAR	en-GB
613	2031151	易寄取 	香港特別行政區	zh-HK
614	2031152	EC-Get	Hong Kong SAR	en-GB
615	2031152	易寄取 	香港特別行政區	zh-HK
616	2031153	EC-Get	Hong Kong SAR	en-GB
617	2031153	易寄取 	香港特別行政區	zh-HK
618	2031154	易寄取 	香港特別行政區	zh-HK
619	2031154	EC-Get	Hong Kong SAR	en-GB
620	2031155	易寄取 	香港特別行政區	zh-HK
621	2031155	EC-Get	Hong Kong SAR	en-GB
622	2031156	易寄取 	香港特別行政區	zh-HK
623	2031156	EC-Get	Hong Kong SAR	en-GB
624	2031157	EC-Get	Hong Kong SAR	en-GB
625	2031157	易寄取 	香港特別行政區	zh-HK
626	2031158	易寄取 	香港特別行政區	zh-HK
627	2031158	EC-Get	Hong Kong SAR	en-GB
628	2031159	EC-Get	Hong Kong SAR	en-GB
629	2031159	易寄取 	香港特別行政區	zh-HK
630	2031160	易寄取 	香港特別行政區	zh-HK
631	2031160	EC-Get	Hong Kong SAR	en-GB
632	2031161	EC-Get	Hong Kong SAR	en-GB
633	2031161	易寄取 	香港特別行政區	zh-HK
634	2031162	EC-Get	Hong Kong SAR	en-GB
635	2031162	易寄取 	香港特別行政區	zh-HK
636	2031163	易寄取 	香港特別行政區	zh-HK
637	2031163	EC-Get	Hong Kong SAR	en-GB
638	2031164	易寄取 	香港特別行政區	zh-HK
639	2031164	EC-Get	Hong Kong SAR	en-GB
640	2031165	EC-Get	Hong Kong SAR	en-GB
641	2031165	易寄取 	香港特別行政區	zh-HK
642	2031166	本地郵政速遞郵件 	香港特別行政區	zh-HK
643	2031166	Local Courier Post	Hong Kong SAR	en-GB
644	2031167	本地郵政速遞郵件 	香港特別行政區	zh-HK
645	2031167	Local Courier Post	Hong Kong SAR	en-GB
646	2031168	本地郵政速遞郵件 	香港特別行政區	zh-HK
647	2031168	Local Courier Post	Hong Kong SAR	en-GB
648	2031169	Local Courier Post	Hong Kong SAR	en-GB
649	2031169	本地郵政速遞郵件 	香港特別行政區	zh-HK
650	2031170	Local Courier Post	Hong Kong SAR	en-GB
651	2031170	本地郵政速遞郵件 	香港特別行政區	zh-HK
652	2031171	Local Courier Post	Hong Kong SAR	en-GB
653	2031171	本地郵政速遞郵件 	香港特別行政區	zh-HK
654	2031172	Local Courier Post	Hong Kong SAR	en-GB
655	2031172	本地郵政速遞郵件 	香港特別行政區	zh-HK
656	2031173	Local Courier Post	Hong Kong SAR	en-GB
657	2031173	本地郵政速遞郵件 	香港特別行政區	zh-HK
658	2031174	Local Courier Post	Hong Kong SAR	en-GB
659	2031174	本地郵政速遞郵件 	香港特別行政區	zh-HK
660	2031175	Local Courier Post	Hong Kong SAR	en-GB
661	2031175	本地郵政速遞郵件 	香港特別行政區	zh-HK
662	2031176	Local Parcel	Hong Kong SAR	en-GB
663	2031176	本地包裹	香港特別行政區	zh-HK
664	2031177	Local Parcel	Hong Kong SAR	en-GB
665	2031177	本地包裹	香港特別行政區	zh-HK
666	2031178	Local Parcel	Hong Kong SAR	en-GB
667	2031178	本地包裹	香港特別行政區	zh-HK
668	2031179	Local Parcel	Hong Kong SAR	en-GB
669	2031179	本地包裹	香港特別行政區	zh-HK
670	2031180	本地包裹	香港特別行政區	zh-HK
671	2031180	Local Parcel	Hong Kong SAR	en-GB
672	2031181	Local Parcel	Hong Kong SAR	en-GB
673	2031181	本地包裹	香港特別行政區	zh-HK
674	2031182	Local Parcel	Hong Kong SAR	en-GB
675	2031182	本地包裹	香港特別行政區	zh-HK
676	2031183	本地包裹	香港特別行政區	zh-HK
677	2031183	Local Parcel	Hong Kong SAR	en-GB
678	2031184	Local Parcel	Hong Kong SAR	en-GB
679	2031184	本地包裹	香港特別行政區	zh-HK
680	2031185	本地包裹	香港特別行政區	zh-HK
681	2031185	Local Parcel	Hong Kong SAR	en-GB
682	2031186	本地包裹	香港特別行政區	zh-HK
683	2031186	Local Parcel	Hong Kong SAR	en-GB
684	2031187	本地包裹	香港特別行政區	zh-HK
685	2031187	Local Parcel	Hong Kong SAR	en-GB
686	2031188	Local Parcel	Hong Kong SAR	en-GB
687	2031188	本地包裹	香港特別行政區	zh-HK
688	2031189	本地包裹	香港特別行政區	zh-HK
689	2031189	Local Parcel	Hong Kong SAR	en-GB
690	2031190	本地包裹	香港特別行政區	zh-HK
691	2031190	Local Parcel	Hong Kong SAR	en-GB
692	2031191	本地包裹	香港特別行政區	zh-HK
693	2031191	Local Parcel	Hong Kong SAR	en-GB
694	2031192	本地包裹	香港特別行政區	zh-HK
695	2031192	Local Parcel	Hong Kong SAR	en-GB
696	2031193	本地包裹	香港特別行政區	zh-HK
697	2031193	Local Parcel	Hong Kong SAR	en-GB
698	2031194	Local Parcel	Hong Kong SAR	en-GB
699	2031194	本地包裹	香港特別行政區	zh-HK
700	2031195	本地包裹	香港特別行政區	zh-HK
701	2031195	Local Parcel	Hong Kong SAR	en-GB
702	2031196	本地包裹	香港特別行政區	zh-HK
703	2031196	Local Parcel	Hong Kong SAR	en-GB
704	2031197	Local Parcel	Hong Kong SAR	en-GB
705	2031197	本地包裹	香港特別行政區	zh-HK
706	2031198	本地包裹	香港特別行政區	zh-HK
707	2031198	Local Parcel	Hong Kong SAR	en-GB
708	2031199	本地包裹	香港特別行政區	zh-HK
709	2031199	Local Parcel	Hong Kong SAR	en-GB
710	2031200	本地包裹	香港特別行政區	zh-HK
711	2031200	Local Parcel	Hong Kong SAR	en-GB
712	2031201	Local Parcel	Hong Kong SAR	en-GB
713	2031201	本地包裹	香港特別行政區	zh-HK
714	2031202	本地包裹	香港特別行政區	zh-HK
715	2031202	Local Parcel	Hong Kong SAR	en-GB
716	2031203	Local Parcel	Hong Kong SAR	en-GB
717	2031203	本地包裹	香港特別行政區	zh-HK
718	2031204	本地包裹	香港特別行政區	zh-HK
719	2031204	Local Parcel	Hong Kong SAR	en-GB
720	2031205	本地包裹	香港特別行政區	zh-HK
721	2031205	Local Parcel	Hong Kong SAR	en-GB
722	2031206	本地包裹	香港特別行政區	zh-HK
723	2031206	Local Parcel	Hong Kong SAR	en-GB
724	2031207	Local Parcel	Hong Kong SAR	en-GB
725	2031207	本地包裹	香港特別行政區	zh-HK
726	2031208	Local Parcel	Hong Kong SAR	en-GB
727	2031208	本地包裹	香港特別行政區	zh-HK
728	2031209	本地包裹	香港特別行政區	zh-HK
729	2031209	Local Parcel	Hong Kong SAR	en-GB
730	2031210	Local Parcel	Hong Kong SAR	en-GB
731	2031210	本地包裹	香港特別行政區	zh-HK
732	2031211	Local Parcel	Hong Kong SAR	en-GB
733	2031211	本地包裹	香港特別行政區	zh-HK
734	2031212	Local Parcel	Hong Kong SAR	en-GB
735	2031212	本地包裹	香港特別行政區	zh-HK
736	2031213	本地包裹	香港特別行政區	zh-HK
737	2031213	Local Parcel	Hong Kong SAR	en-GB
738	2031214	本地包裹	香港特別行政區	zh-HK
739	2031214	Local Parcel	Hong Kong SAR	en-GB
740	2031215	Local Parcel	Hong Kong SAR	en-GB
741	2031215	本地包裹	香港特別行政區	zh-HK
742	2031216	本地包裹	香港特別行政區	zh-HK
743	2031216	Local Parcel	Hong Kong SAR	en-GB
744	2031217	Local Parcel	Hong Kong SAR	en-GB
745	2031217	本地包裹	香港特別行政區	zh-HK
746	2031218	Local Parcel	Hong Kong SAR	en-GB
747	2031218	本地包裹	香港特別行政區	zh-HK
748	2031219	Local Parcel	Hong Kong SAR	en-GB
749	2031219	本地包裹	香港特別行政區	zh-HK
750	2031220	本地包裹	香港特別行政區	zh-HK
751	2031220	Local Parcel	Hong Kong SAR	en-GB
752	2031221	Local Parcel	Hong Kong SAR	en-GB
753	2031221	本地包裹	香港特別行政區	zh-HK
754	2031222	Local Parcel	Hong Kong SAR	en-GB
755	2031222	本地包裹	香港特別行政區	zh-HK
756	2031223	本地包裹	香港特別行政區	zh-HK
757	2031223	Local Parcel	Hong Kong SAR	en-GB
758	2031224	Local Parcel	Hong Kong SAR	en-GB
759	2031224	本地包裹	香港特別行政區	zh-HK
760	2031225	Local Parcel	Hong Kong SAR	en-GB
761	2031225	本地包裹	香港特別行政區	zh-HK
762	2031226	Local Parcel	Hong Kong SAR	en-GB
763	2031226	本地包裹	香港特別行政區	zh-HK
764	2031227	本地包裹	香港特別行政區	zh-HK
765	2031227	Local Parcel	Hong Kong SAR	en-GB
766	2031228	Local Parcel	Hong Kong SAR	en-GB
767	2031228	本地包裹	香港特別行政區	zh-HK
768	2031229	Local Parcel	Hong Kong SAR	en-GB
769	2031229	本地包裹	香港特別行政區	zh-HK
770	2031230	Local Parcel	Hong Kong SAR	en-GB
771	2031230	本地包裹	香港特別行政區	zh-HK
772	2031231	Local Parcel	Hong Kong SAR	en-GB
773	2031231	本地包裹	香港特別行政區	zh-HK
774	2031232	Local Parcel	Hong Kong SAR	en-GB
775	2031232	本地包裹	香港特別行政區	zh-HK
776	2031233	本地包裹	香港特別行政區	zh-HK
777	2031233	Local Parcel	Hong Kong SAR	en-GB
778	2031234	本地包裹	香港特別行政區	zh-HK
779	2031234	Local Parcel	Hong Kong SAR	en-GB
780	2031235	Local Parcel	Hong Kong SAR	en-GB
781	2031235	本地包裹	香港特別行政區	zh-HK
782	2031236	Local Parcel	Hong Kong SAR	en-GB
783	2031236	本地包裹	香港特別行政區	zh-HK
784	2031237	Local Parcel	Hong Kong SAR	en-GB
785	2031237	本地包裹	香港特別行政區	zh-HK
786	2031238	本地包裹	香港特別行政區	zh-HK
787	2031238	Local Parcel	Hong Kong SAR	en-GB
788	2031239	Local Parcel	Hong Kong SAR	en-GB
789	2031239	本地包裹	香港特別行政區	zh-HK
790	2031240	本地包裹	香港特別行政區	zh-HK
791	2031240	Local Parcel	Hong Kong SAR	en-GB
792	2031241	本地包裹	香港特別行政區	zh-HK
793	2031241	Local Parcel	Hong Kong SAR	en-GB
794	2031242	本地包裹	香港特別行政區	zh-HK
795	2031242	Local Parcel	Hong Kong SAR	en-GB
796	2031243	本地包裹	香港特別行政區	zh-HK
797	2031243	Local Parcel	Hong Kong SAR	en-GB
798	2031244	Local Parcel	Hong Kong SAR	en-GB
799	2031244	本地包裹	香港特別行政區	zh-HK
800	2031245	Local Parcel	Hong Kong SAR	en-GB
801	2031245	本地包裹	香港特別行政區	zh-HK
802	2031246	Local Parcel	Hong Kong SAR	en-GB
803	2031246	本地包裹	香港特別行政區	zh-HK
804	2031247	Local Parcel	Hong Kong SAR	en-GB
805	2031247	本地包裹	香港特別行政區	zh-HK
806	2031248	Local Parcel	Hong Kong SAR	en-GB
807	2031248	本地包裹	香港特別行政區	zh-HK
808	2031249	Local Parcel	Hong Kong SAR	en-GB
809	2031249	本地包裹	香港特別行政區	zh-HK
810	2031250	Local Parcel	Hong Kong SAR	en-GB
811	2031250	本地包裹	香港特別行政區	zh-HK
812	2031251	Local Parcel	Hong Kong SAR	en-GB
813	2031251	本地包裹	香港特別行政區	zh-HK
814	2031252	Local Parcel	Hong Kong SAR	en-GB
815	2031252	本地包裹	香港特別行政區	zh-HK
816	2031253	Local Parcel	Hong Kong SAR	en-GB
817	2031253	本地包裹	香港特別行政區	zh-HK
818	2031254	本地包裹	香港特別行政區	zh-HK
819	2031254	Local Parcel	Hong Kong SAR	en-GB
820	2031255	本地包裹	香港特別行政區	zh-HK
821	2031255	Local Parcel	Hong Kong SAR	en-GB
822	2031256	Local Parcel	Hong Kong SAR	en-GB
823	2031256	本地包裹	香港特別行政區	zh-HK
824	2031257	本地包裹	香港特別行政區	zh-HK
825	2031257	Local Parcel	Hong Kong SAR	en-GB
826	2031258	Local Parcel	Hong Kong SAR	en-GB
827	2031258	本地包裹	香港特別行政區	zh-HK
828	2031259	Local Parcel	Hong Kong SAR	en-GB
829	2031259	本地包裹	香港特別行政區	zh-HK
830	2031260	本地包裹	香港特別行政區	zh-HK
831	2031260	Local Parcel	Hong Kong SAR	en-GB
832	2031261	Local Parcel	Hong Kong SAR	en-GB
833	2031261	本地包裹	香港特別行政區	zh-HK
834	2031262	本地包裹	香港特別行政區	zh-HK
835	2031262	Local Parcel	Hong Kong SAR	en-GB
836	2031263	本地包裹	香港特別行政區	zh-HK
837	2031263	Local Parcel	Hong Kong SAR	en-GB
838	2031264	本地包裹	香港特別行政區	zh-HK
839	2031264	Local Parcel	Hong Kong SAR	en-GB
840	2031265	本地包裹	香港特別行政區	zh-HK
841	2031265	Local Parcel	Hong Kong SAR	en-GB
842	2031266	本地包裹	香港特別行政區	zh-HK
843	2031266	Local Parcel	Hong Kong SAR	en-GB
844	2031267	本地包裹	香港特別行政區	zh-HK
845	2031267	Local Parcel	Hong Kong SAR	en-GB
846	2031268	本地包裹	香港特別行政區	zh-HK
847	2031268	Local Parcel	Hong Kong SAR	en-GB
848	2031269	Local Parcel	Hong Kong SAR	en-GB
849	2031269	本地包裹	香港特別行政區	zh-HK
850	2031270	本地包裹	香港特別行政區	zh-HK
851	2031270	Local Parcel	Hong Kong SAR	en-GB
852	2031271	Local Parcel	Hong Kong SAR	en-GB
853	2031271	本地包裹	香港特別行政區	zh-HK
854	2031272	本地包裹	香港特別行政區	zh-HK
855	2031272	Local Parcel	Hong Kong SAR	en-GB
856	2031273	Local Parcel	Hong Kong SAR	en-GB
857	2031273	本地包裹	香港特別行政區	zh-HK
858	2031274	本地包裹	香港特別行政區	zh-HK
859	2031274	Local Parcel	Hong Kong SAR	en-GB
860	2031275	Local Parcel	Hong Kong SAR	en-GB
861	2031275	本地包裹	香港特別行政區	zh-HK
862	2031277	Air Parcel 	New Zealand	en-GB
863	2031277	空郵包裹	新西蘭 	zh-HK
864	2031278	Air Parcel 	New Zealand	en-GB
865	2031278	空郵包裹	新西蘭 	zh-HK
866	2031279	Air Parcel 	New Zealand	en-GB
867	2031279	空郵包裹	新西蘭 	zh-HK
868	2031280	空郵包裹	新西蘭 	zh-HK
869	2031280	Air Parcel 	New Zealand	en-GB
870	2031281	空郵包裹	新西蘭 	zh-HK
871	2031281	Air Parcel 	New Zealand	en-GB
872	2031282	Air Parcel 	New Zealand	en-GB
873	2031282	空郵包裹	新西蘭 	zh-HK
874	2031283	Air Parcel 	New Zealand	en-GB
875	2031283	空郵包裹	新西蘭 	zh-HK
876	2031284	Air Parcel 	New Zealand	en-GB
877	2031284	空郵包裹	新西蘭 	zh-HK
878	2031285	Air Parcel 	New Zealand	en-GB
879	2031285	空郵包裹	新西蘭 	zh-HK
880	2031286	Air Parcel 	New Zealand	en-GB
881	2031286	空郵包裹	新西蘭 	zh-HK
882	2031287	空郵包裹	新西蘭 	zh-HK
883	2031287	Air Parcel 	New Zealand	en-GB
884	2031288	Air Parcel 	New Zealand	en-GB
885	2031288	空郵包裹	新西蘭 	zh-HK
886	2031289	空郵包裹	新西蘭 	zh-HK
887	2031289	Air Parcel 	New Zealand	en-GB
888	2031290	Air Parcel 	New Zealand	en-GB
889	2031290	空郵包裹	新西蘭 	zh-HK
890	2031291	Air Parcel 	New Zealand	en-GB
891	2031291	空郵包裹	新西蘭 	zh-HK
892	2031292	空郵包裹	新西蘭 	zh-HK
893	2031292	Air Parcel 	New Zealand	en-GB
894	2031293	空郵包裹	新西蘭 	zh-HK
895	2031293	Air Parcel 	New Zealand	en-GB
896	2031294	Air Parcel 	New Zealand	en-GB
897	2031294	空郵包裹	新西蘭 	zh-HK
898	2031295	空郵包裹	新西蘭 	zh-HK
899	2031295	Air Parcel 	New Zealand	en-GB
900	2031296	Air Parcel 	New Zealand	en-GB
901	2031296	空郵包裹	新西蘭 	zh-HK
902	2031297	Air Parcel 	New Zealand	en-GB
903	2031297	空郵包裹	新西蘭 	zh-HK
904	2031298	空郵包裹	新西蘭 	zh-HK
905	2031298	Air Parcel 	New Zealand	en-GB
906	2031299	Air Parcel 	New Zealand	en-GB
907	2031299	空郵包裹	新西蘭 	zh-HK
908	2031300	空郵包裹	新西蘭 	zh-HK
909	2031300	Air Parcel 	New Zealand	en-GB
910	2031301	Air Parcel 	New Zealand	en-GB
911	2031301	空郵包裹	新西蘭 	zh-HK
912	2031302	空郵包裹	新西蘭 	zh-HK
913	2031302	Air Parcel 	New Zealand	en-GB
914	2031303	Air Parcel 	New Zealand	en-GB
915	2031303	空郵包裹	新西蘭 	zh-HK
916	2031304	空郵包裹	新西蘭 	zh-HK
917	2031304	Air Parcel 	New Zealand	en-GB
918	2031305	Air Parcel 	New Zealand	en-GB
919	2031305	空郵包裹	新西蘭 	zh-HK
920	2031306	Air Parcel 	New Zealand	en-GB
921	2031306	空郵包裹	新西蘭 	zh-HK
922	2031307	Air Parcel 	New Zealand	en-GB
923	2031307	空郵包裹	新西蘭 	zh-HK
924	2031308	空郵包裹	新西蘭 	zh-HK
925	2031308	Air Parcel 	New Zealand	en-GB
926	2031309	Air Parcel 	New Zealand	en-GB
927	2031309	空郵包裹	新西蘭 	zh-HK
928	2031310	空郵包裹	新西蘭 	zh-HK
929	2031310	Air Parcel 	New Zealand	en-GB
930	2031311	Air Parcel 	New Zealand	en-GB
931	2031311	空郵包裹	新西蘭 	zh-HK
932	2031312	空郵包裹	新西蘭 	zh-HK
933	2031312	Air Parcel 	New Zealand	en-GB
934	2031313	空郵包裹	新西蘭 	zh-HK
935	2031313	Air Parcel 	New Zealand	en-GB
936	2031314	空郵包裹	新西蘭 	zh-HK
937	2031314	Air Parcel 	New Zealand	en-GB
938	2031315	Air Parcel 	New Zealand	en-GB
939	2031315	空郵包裹	新西蘭 	zh-HK
940	2031316	空郵包裹	新西蘭 	zh-HK
941	2031316	Air Parcel 	New Zealand	en-GB
942	2031317	Air Parcel 	New Zealand	en-GB
943	2031317	空郵包裹	新西蘭 	zh-HK
944	2031318	空郵包裹	新西蘭 	zh-HK
945	2031318	Air Parcel 	New Zealand	en-GB
946	2031319	Air Parcel 	New Zealand	en-GB
947	2031319	空郵包裹	新西蘭 	zh-HK
948	2031320	Air Parcel 	New Zealand	en-GB
949	2031320	空郵包裹	新西蘭 	zh-HK
950	2031321	Air Parcel 	New Zealand	en-GB
951	2031321	空郵包裹	新西蘭 	zh-HK
952	2031322	Air Parcel 	New Zealand	en-GB
953	2031322	空郵包裹	新西蘭 	zh-HK
954	2031323	Air Parcel 	New Zealand	en-GB
955	2031323	空郵包裹	新西蘭 	zh-HK
956	2031324	空郵包裹	新西蘭 	zh-HK
957	2031324	Air Parcel 	New Zealand	en-GB
958	2031325	Air Parcel 	New Zealand	en-GB
959	2031325	空郵包裹	新西蘭 	zh-HK
960	2031326	空郵包裹	新西蘭 	zh-HK
961	2031326	Air Parcel 	New Zealand	en-GB
962	2031327	空郵包裹	新西蘭 	zh-HK
963	2031327	Air Parcel 	New Zealand	en-GB
964	2031328	Air Parcel 	New Zealand	en-GB
965	2031328	空郵包裹	新西蘭 	zh-HK
966	2031329	空郵包裹	新西蘭 	zh-HK
967	2031329	Air Parcel 	New Zealand	en-GB
968	2031330	Air Parcel 	New Zealand	en-GB
969	2031330	空郵包裹	新西蘭 	zh-HK
970	2031331	Air Parcel 	New Zealand	en-GB
971	2031331	空郵包裹	新西蘭 	zh-HK
972	2031332	Air Parcel 	New Zealand	en-GB
973	2031332	空郵包裹	新西蘭 	zh-HK
974	2031333	空郵包裹	新西蘭 	zh-HK
975	2031333	Air Parcel 	New Zealand	en-GB
976	2031334	Air Parcel 	New Zealand	en-GB
977	2031334	空郵包裹	新西蘭 	zh-HK
978	2031335	空郵包裹	新西蘭 	zh-HK
979	2031335	Air Parcel 	New Zealand	en-GB
980	2031336	空郵包裹	新西蘭 	zh-HK
981	2031336	Air Parcel 	New Zealand	en-GB
982	2031337	Air Parcel 	New Zealand	en-GB
983	2031337	空郵包裹	新西蘭 	zh-HK
984	2031338	Air Parcel 	New Zealand	en-GB
985	2031338	空郵包裹	新西蘭 	zh-HK
986	2031339	Air Parcel 	New Zealand	en-GB
987	2031339	空郵包裹	新西蘭 	zh-HK
988	2031340	空郵包裹	新西蘭 	zh-HK
989	2031340	Air Parcel 	New Zealand	en-GB
990	2031341	Air Parcel 	New Zealand	en-GB
991	2031341	空郵包裹	新西蘭 	zh-HK
992	2031342	空郵包裹	新西蘭 	zh-HK
993	2031342	Air Parcel 	New Zealand	en-GB
994	2031343	Air Parcel 	New Zealand	en-GB
995	2031343	空郵包裹	新西蘭 	zh-HK
996	2031344	Air Parcel 	New Zealand	en-GB
997	2031344	空郵包裹	新西蘭 	zh-HK
998	2031345	Air Parcel 	New Zealand	en-GB
999	2031345	空郵包裹	新西蘭 	zh-HK
1000	2031346	Air Parcel 	New Zealand	en-GB
1001	2031346	空郵包裹	新西蘭 	zh-HK
1002	2031347	空郵包裹	新西蘭 	zh-HK
1003	2031347	Air Parcel 	New Zealand	en-GB
1004	2031348	Air Parcel 	New Zealand	en-GB
1005	2031348	空郵包裹	新西蘭 	zh-HK
1006	2031349	空郵包裹	新西蘭 	zh-HK
1007	2031349	Air Parcel 	New Zealand	en-GB
1008	2031350	空郵包裹	新西蘭 	zh-HK
1009	2031350	Air Parcel 	New Zealand	en-GB
1010	2031351	空郵包裹	新西蘭 	zh-HK
1011	2031351	Air Parcel 	New Zealand	en-GB
1012	2031352	Air Parcel 	New Zealand	en-GB
1013	2031352	空郵包裹	新西蘭 	zh-HK
1014	2031353	空郵包裹	新西蘭 	zh-HK
1015	2031353	Air Parcel 	New Zealand	en-GB
1016	2031354	Air Parcel 	New Zealand	en-GB
1017	2031354	空郵包裹	新西蘭 	zh-HK
1018	2031355	空郵包裹	新西蘭 	zh-HK
1019	2031355	Air Parcel 	New Zealand	en-GB
1020	2031356	空郵包裹	新西蘭 	zh-HK
1021	2031356	Air Parcel 	New Zealand	en-GB
1022	2031357	Air Parcel 	New Zealand	en-GB
1023	2031357	空郵包裹	新西蘭 	zh-HK
1024	2031358	空郵包裹	新西蘭 	zh-HK
1025	2031358	Air Parcel 	New Zealand	en-GB
1026	2031359	Air Parcel 	New Zealand	en-GB
1027	2031359	空郵包裹	新西蘭 	zh-HK
1028	2031360	Air Parcel 	New Zealand	en-GB
1029	2031360	空郵包裹	新西蘭 	zh-HK
1030	2031361	空郵包裹	新西蘭 	zh-HK
1031	2031361	Air Parcel 	New Zealand	en-GB
1032	2031362	空郵包裹	新西蘭 	zh-HK
1033	2031362	Air Parcel 	New Zealand	en-GB
1034	2031363	空郵包裹	新西蘭 	zh-HK
1035	2031363	Air Parcel 	New Zealand	en-GB
1036	2031364	Air Parcel 	New Zealand	en-GB
1037	2031364	空郵包裹	新西蘭 	zh-HK
1038	2031365	空郵包裹	新西蘭 	zh-HK
1039	2031365	Air Parcel 	New Zealand	en-GB
1040	2031366	Air Parcel 	New Zealand	en-GB
1041	2031366	空郵包裹	新西蘭 	zh-HK
1042	2031367	Air Parcel 	New Zealand	en-GB
1043	2031367	空郵包裹	新西蘭 	zh-HK
1044	2031368	空郵包裹	新西蘭 	zh-HK
1045	2031368	Air Parcel 	New Zealand	en-GB
1046	2031369	Air Parcel 	New Zealand	en-GB
1047	2031369	空郵包裹	新西蘭 	zh-HK
1048	2031370	空郵包裹	新西蘭 	zh-HK
1049	2031370	Air Parcel 	New Zealand	en-GB
1050	2031371	空郵包裹	新西蘭 	zh-HK
1051	2031371	Air Parcel 	New Zealand	en-GB
1052	2031372	Air Parcel 	New Zealand	en-GB
1053	2031372	空郵包裹	新西蘭 	zh-HK
1054	2031373	Air Parcel 	New Zealand	en-GB
1055	2031373	空郵包裹	新西蘭 	zh-HK
1056	2031374	Air Parcel 	New Zealand	en-GB
1057	2031374	空郵包裹	新西蘭 	zh-HK
1058	2031375	Air Parcel 	New Zealand	en-GB
1059	2031375	空郵包裹	新西蘭 	zh-HK
1060	2031376	Air Parcel 	New Zealand	en-GB
1061	2031376	空郵包裹	新西蘭 	zh-HK
1062	2031377	Air Parcel 	New Zealand	en-GB
1063	2031377	空郵包裹	新西蘭 	zh-HK
1064	2031378	Air Parcel 	New Zealand	en-GB
1065	2031378	空郵包裹	新西蘭 	zh-HK
1066	2031379	空郵包裹	新西蘭 	zh-HK
1067	2031379	Air Parcel 	New Zealand	en-GB
1068	2031380	空郵包裹	新西蘭 	zh-HK
1069	2031380	Air Parcel 	New Zealand	en-GB
1070	2031381	Air Parcel 	New Zealand	en-GB
1071	2031381	空郵包裹	新西蘭 	zh-HK
1072	2031382	空郵包裹	新西蘭 	zh-HK
1073	2031382	Air Parcel 	New Zealand	en-GB
1074	2031383	Air Parcel 	New Zealand	en-GB
1075	2031383	空郵包裹	新西蘭 	zh-HK
1076	2031384	空郵包裹	新西蘭 	zh-HK
1077	2031384	Air Parcel 	New Zealand	en-GB
1078	2031385	空郵包裹	新西蘭 	zh-HK
1079	2031385	Air Parcel 	New Zealand	en-GB
1080	2031386	Air Parcel 	New Zealand	en-GB
1081	2031386	空郵包裹	新西蘭 	zh-HK
1082	2031387	空郵包裹	新西蘭 	zh-HK
1083	2031387	Air Parcel 	New Zealand	en-GB
1084	2031388	Air Parcel 	New Zealand	en-GB
1085	2031388	空郵包裹	新西蘭 	zh-HK
1086	2031389	Air Parcel 	New Zealand	en-GB
1087	2031389	空郵包裹	新西蘭 	zh-HK
1088	2031390	空郵包裹	新西蘭 	zh-HK
1089	2031390	Air Parcel 	New Zealand	en-GB
1090	2031391	空郵包裹	新西蘭 	zh-HK
1091	2031391	Air Parcel 	New Zealand	en-GB
1092	2031392	空郵包裹	新西蘭 	zh-HK
1093	2031392	Air Parcel 	New Zealand	en-GB
1094	2031393	Air Parcel 	New Zealand	en-GB
1095	2031393	空郵包裹	新西蘭 	zh-HK
1096	2031394	Air Parcel 	New Zealand	en-GB
1097	2031394	空郵包裹	新西蘭 	zh-HK
1098	2031395	Air Parcel 	New Zealand	en-GB
1099	2031395	空郵包裹	新西蘭 	zh-HK
1100	2031396	Air Parcel 	New Zealand	en-GB
1101	2031396	空郵包裹	新西蘭 	zh-HK
1102	2031397	空郵包裹	新西蘭 	zh-HK
1103	2031397	Air Parcel 	New Zealand	en-GB
1104	2031398	Air Parcel 	New Zealand	en-GB
1105	2031398	空郵包裹	新西蘭 	zh-HK
1106	2031399	Air Parcel 	New Zealand	en-GB
1107	2031399	空郵包裹	新西蘭 	zh-HK
1108	2031400	Air Parcel 	New Zealand	en-GB
1109	2031400	空郵包裹	新西蘭 	zh-HK
1110	2031401	Air Parcel 	New Zealand	en-GB
1111	2031401	空郵包裹	新西蘭 	zh-HK
1112	2031402	空郵包裹	新西蘭 	zh-HK
1113	2031402	Air Parcel 	New Zealand	en-GB
1114	2031403	Air Parcel 	New Zealand	en-GB
1115	2031403	空郵包裹	新西蘭 	zh-HK
1116	2031404	Air Parcel 	New Zealand	en-GB
1117	2031404	空郵包裹	新西蘭 	zh-HK
1118	2031405	Air Parcel 	New Zealand	en-GB
1119	2031405	空郵包裹	新西蘭 	zh-HK
1120	2031406	Air Parcel 	New Zealand	en-GB
1121	2031406	空郵包裹	新西蘭 	zh-HK
1122	2031407	Air Parcel 	New Zealand	en-GB
1123	2031407	空郵包裹	新西蘭 	zh-HK
1124	2031408	空郵包裹	新西蘭 	zh-HK
1125	2031408	Air Parcel 	New Zealand	en-GB
1126	2031409	Air Parcel 	New Zealand	en-GB
1127	2031409	空郵包裹	新西蘭 	zh-HK
1128	2031410	Air Parcel 	New Zealand	en-GB
1129	2031410	空郵包裹	新西蘭 	zh-HK
1130	2031411	Air Parcel 	New Zealand	en-GB
1131	2031411	空郵包裹	新西蘭 	zh-HK
1132	2031412	Air Parcel 	New Zealand	en-GB
1133	2031412	空郵包裹	新西蘭 	zh-HK
1134	2031413	空郵包裹	新西蘭 	zh-HK
1135	2031413	Air Parcel 	New Zealand	en-GB
1136	2031414	空郵包裹	新西蘭 	zh-HK
1137	2031414	Air Parcel 	New Zealand	en-GB
1138	2031415	Air Parcel 	New Zealand	en-GB
1139	2031415	空郵包裹	新西蘭 	zh-HK
1140	2031416	空郵包裹	新西蘭 	zh-HK
1141	2031416	Air Parcel 	New Zealand	en-GB
1142	2031417	Air Parcel 	New Zealand	en-GB
1143	2031417	空郵包裹	新西蘭 	zh-HK
1144	2031418	空郵包裹	新西蘭 	zh-HK
1145	2031418	Air Parcel 	New Zealand	en-GB
1146	2031419	Air Parcel 	New Zealand	en-GB
1147	2031419	空郵包裹	新西蘭 	zh-HK
1148	2031420	Air Parcel 	New Zealand	en-GB
1149	2031420	空郵包裹	新西蘭 	zh-HK
1150	2031421	空郵包裹	新西蘭 	zh-HK
1151	2031421	Air Parcel 	New Zealand	en-GB
1152	2031422	Air Parcel 	New Zealand	en-GB
1153	2031422	空郵包裹	新西蘭 	zh-HK
1154	2031423	空郵包裹	新西蘭 	zh-HK
1155	2031423	Air Parcel 	New Zealand	en-GB
1156	2031424	空郵包裹	新西蘭 	zh-HK
1157	2031424	Air Parcel 	New Zealand	en-GB
1158	2031425	Air Parcel 	New Zealand	en-GB
1159	2031425	空郵包裹	新西蘭 	zh-HK
1160	2031426	Air Parcel 	New Zealand	en-GB
1161	2031426	空郵包裹	新西蘭 	zh-HK
1162	2031427	Surface Parcel	New Zealand	en-GB
1163	2031427	平郵包裹	新西蘭 	zh-HK
1164	2031428	Surface Parcel	New Zealand	en-GB
1165	2031428	平郵包裹	新西蘭 	zh-HK
1166	2031429	Surface Parcel	New Zealand	en-GB
1167	2031429	平郵包裹	新西蘭 	zh-HK
1168	2031430	平郵包裹	新西蘭 	zh-HK
1169	2031430	Surface Parcel	New Zealand	en-GB
1170	2031431	Surface Parcel	New Zealand	en-GB
1171	2031431	平郵包裹	新西蘭 	zh-HK
1172	2031432	Surface Parcel	New Zealand	en-GB
1173	2031432	平郵包裹	新西蘭 	zh-HK
1174	2031433	平郵包裹	新西蘭 	zh-HK
1175	2031433	Surface Parcel	New Zealand	en-GB
1176	2031434	Surface Parcel	New Zealand	en-GB
1177	2031434	平郵包裹	新西蘭 	zh-HK
1178	2031435	Surface Parcel	New Zealand	en-GB
1179	2031435	平郵包裹	新西蘭 	zh-HK
1180	2031436	平郵包裹	新西蘭 	zh-HK
1181	2031436	Surface Parcel	New Zealand	en-GB
1182	2031437	平郵包裹	新西蘭 	zh-HK
1183	2031437	Surface Parcel	New Zealand	en-GB
1184	2031438	Surface Parcel	New Zealand	en-GB
1185	2031438	平郵包裹	新西蘭 	zh-HK
1186	2031439	Surface Parcel	New Zealand	en-GB
1187	2031439	平郵包裹	新西蘭 	zh-HK
1188	2031440	Surface Parcel	New Zealand	en-GB
1189	2031440	平郵包裹	新西蘭 	zh-HK
1190	2031441	Surface Parcel	New Zealand	en-GB
1191	2031441	平郵包裹	新西蘭 	zh-HK
1192	2031442	平郵包裹	新西蘭 	zh-HK
1193	2031442	Surface Parcel	New Zealand	en-GB
1194	2031443	Surface Parcel	New Zealand	en-GB
1195	2031443	平郵包裹	新西蘭 	zh-HK
1196	2031444	平郵包裹	新西蘭 	zh-HK
1197	2031444	Surface Parcel	New Zealand	en-GB
1198	2031445	平郵包裹	新西蘭 	zh-HK
1199	2031445	Surface Parcel	New Zealand	en-GB
1200	2031446	平郵包裹	新西蘭 	zh-HK
1201	2031446	Surface Parcel	New Zealand	en-GB
1202	2031447	Surface Parcel	New Zealand	en-GB
1203	2031447	平郵包裹	新西蘭 	zh-HK
1204	2031448	Surface Parcel	New Zealand	en-GB
1205	2031448	平郵包裹	新西蘭 	zh-HK
1206	2031449	平郵包裹	新西蘭 	zh-HK
1207	2031449	Surface Parcel	New Zealand	en-GB
1208	2031450	Surface Parcel	New Zealand	en-GB
1209	2031450	平郵包裹	新西蘭 	zh-HK
1210	2031451	Surface Parcel	New Zealand	en-GB
1211	2031451	平郵包裹	新西蘭 	zh-HK
1212	2031452	Surface Parcel	New Zealand	en-GB
1213	2031452	平郵包裹	新西蘭 	zh-HK
1214	2031453	Surface Parcel	New Zealand	en-GB
1215	2031453	平郵包裹	新西蘭 	zh-HK
1216	2031454	Surface Parcel	New Zealand	en-GB
1217	2031454	平郵包裹	新西蘭 	zh-HK
1218	2031455	Surface Parcel	New Zealand	en-GB
1219	2031455	平郵包裹	新西蘭 	zh-HK
1220	2031456	Surface Parcel	New Zealand	en-GB
1221	2031456	平郵包裹	新西蘭 	zh-HK
1222	2031457	Surface Parcel	New Zealand	en-GB
1223	2031457	平郵包裹	新西蘭 	zh-HK
1224	2031458	Surface Parcel	New Zealand	en-GB
1225	2031458	平郵包裹	新西蘭 	zh-HK
1226	2031459	Surface Parcel	New Zealand	en-GB
1227	2031459	平郵包裹	新西蘭 	zh-HK
1228	2031460	Surface Parcel	New Zealand	en-GB
1229	2031460	平郵包裹	新西蘭 	zh-HK
1230	2031461	平郵包裹	新西蘭 	zh-HK
1231	2031461	Surface Parcel	New Zealand	en-GB
1232	2031462	Surface Parcel	New Zealand	en-GB
1233	2031462	平郵包裹	新西蘭 	zh-HK
1234	2031463	平郵包裹	新西蘭 	zh-HK
1235	2031463	Surface Parcel	New Zealand	en-GB
1236	2031464	平郵包裹	新西蘭 	zh-HK
1237	2031464	Surface Parcel	New Zealand	en-GB
1238	2031465	平郵包裹	新西蘭 	zh-HK
1239	2031465	Surface Parcel	New Zealand	en-GB
1240	2031466	Surface Parcel	New Zealand	en-GB
1241	2031466	平郵包裹	新西蘭 	zh-HK
1242	2031467	Surface Parcel	New Zealand	en-GB
1243	2031467	平郵包裹	新西蘭 	zh-HK
1244	2031468	平郵包裹	新西蘭 	zh-HK
1245	2031468	Surface Parcel	New Zealand	en-GB
1246	2031469	Surface Parcel	New Zealand	en-GB
1247	2031469	平郵包裹	新西蘭 	zh-HK
1248	2031470	平郵包裹	新西蘭 	zh-HK
1249	2031470	Surface Parcel	New Zealand	en-GB
1250	2031471	平郵包裹	新西蘭 	zh-HK
1251	2031471	Surface Parcel	New Zealand	en-GB
1252	2031472	Surface Parcel	New Zealand	en-GB
1253	2031472	平郵包裹	新西蘭 	zh-HK
1254	2031473	Surface Parcel	New Zealand	en-GB
1255	2031473	平郵包裹	新西蘭 	zh-HK
1256	2031474	平郵包裹	新西蘭 	zh-HK
1257	2031474	Surface Parcel	New Zealand	en-GB
1258	2031475	Surface Parcel	New Zealand	en-GB
1259	2031475	平郵包裹	新西蘭 	zh-HK
1260	2031476	Surface Parcel	New Zealand	en-GB
1261	2031476	平郵包裹	新西蘭 	zh-HK
1262	2031477	Surface Parcel	New Zealand	en-GB
1263	2031477	平郵包裹	新西蘭 	zh-HK
1264	2031478	平郵包裹	新西蘭 	zh-HK
1265	2031478	Surface Parcel	New Zealand	en-GB
1266	2031479	Surface Parcel	New Zealand	en-GB
1267	2031479	平郵包裹	新西蘭 	zh-HK
1268	2031480	平郵包裹	新西蘭 	zh-HK
1269	2031480	Surface Parcel	New Zealand	en-GB
1270	2031481	Surface Parcel	New Zealand	en-GB
1271	2031481	平郵包裹	新西蘭 	zh-HK
1272	2031482	平郵包裹	新西蘭 	zh-HK
1273	2031482	Surface Parcel	New Zealand	en-GB
1274	2031483	平郵包裹	新西蘭 	zh-HK
1275	2031483	Surface Parcel	New Zealand	en-GB
1276	2031484	Surface Parcel	New Zealand	en-GB
1277	2031484	平郵包裹	新西蘭 	zh-HK
1278	2031485	Surface Parcel	New Zealand	en-GB
1279	2031485	平郵包裹	新西蘭 	zh-HK
1280	2031486	Surface Parcel	New Zealand	en-GB
1281	2031486	平郵包裹	新西蘭 	zh-HK
1282	2031487	Surface Parcel	New Zealand	en-GB
1283	2031487	平郵包裹	新西蘭 	zh-HK
1284	2031488	平郵包裹	新西蘭 	zh-HK
1285	2031488	Surface Parcel	New Zealand	en-GB
1286	2031489	平郵包裹	新西蘭 	zh-HK
1287	2031489	Surface Parcel	New Zealand	en-GB
1288	2031490	平郵包裹	新西蘭 	zh-HK
1289	2031490	Surface Parcel	New Zealand	en-GB
1290	2031491	平郵包裹	新西蘭 	zh-HK
1291	2031491	Surface Parcel	New Zealand	en-GB
1292	2031492	平郵包裹	新西蘭 	zh-HK
1293	2031492	Surface Parcel	New Zealand	en-GB
1294	2031493	平郵包裹	新西蘭 	zh-HK
1295	2031493	Surface Parcel	New Zealand	en-GB
1296	2031494	Surface Parcel	New Zealand	en-GB
1297	2031494	平郵包裹	新西蘭 	zh-HK
1298	2031495	平郵包裹	新西蘭 	zh-HK
1299	2031495	Surface Parcel	New Zealand	en-GB
1300	2031496	平郵包裹	新西蘭 	zh-HK
1301	2031496	Surface Parcel	New Zealand	en-GB
1302	2031497	平郵包裹	新西蘭 	zh-HK
1303	2031497	Surface Parcel	New Zealand	en-GB
1304	2031498	平郵包裹	新西蘭 	zh-HK
1305	2031498	Surface Parcel	New Zealand	en-GB
1306	2031499	平郵包裹	新西蘭 	zh-HK
1307	2031499	Surface Parcel	New Zealand	en-GB
1308	2031500	Surface Parcel	New Zealand	en-GB
1309	2031500	平郵包裹	新西蘭 	zh-HK
1310	2031501	Surface Parcel	New Zealand	en-GB
1311	2031501	平郵包裹	新西蘭 	zh-HK
1312	2031502	平郵包裹	新西蘭 	zh-HK
1313	2031502	Surface Parcel	New Zealand	en-GB
1314	2031503	平郵包裹	新西蘭 	zh-HK
1315	2031503	Surface Parcel	New Zealand	en-GB
1316	2031504	平郵包裹	新西蘭 	zh-HK
1317	2031504	Surface Parcel	New Zealand	en-GB
1318	2031505	Surface Parcel	New Zealand	en-GB
1319	2031505	平郵包裹	新西蘭 	zh-HK
1320	2031506	Surface Parcel	New Zealand	en-GB
1321	2031506	平郵包裹	新西蘭 	zh-HK
1322	2031507	Surface Parcel	New Zealand	en-GB
1323	2031507	平郵包裹	新西蘭 	zh-HK
1324	2031508	平郵包裹	新西蘭 	zh-HK
1325	2031508	Surface Parcel	New Zealand	en-GB
1326	2031509	Surface Parcel	New Zealand	en-GB
1327	2031509	平郵包裹	新西蘭 	zh-HK
1328	2031510	Surface Parcel	New Zealand	en-GB
1329	2031510	平郵包裹	新西蘭 	zh-HK
1330	2031511	平郵包裹	新西蘭 	zh-HK
1331	2031511	Surface Parcel	New Zealand	en-GB
1332	2031512	Surface Parcel	New Zealand	en-GB
1333	2031512	平郵包裹	新西蘭 	zh-HK
1334	2031513	平郵包裹	新西蘭 	zh-HK
1335	2031513	Surface Parcel	New Zealand	en-GB
1336	2031514	Surface Parcel	New Zealand	en-GB
1337	2031514	平郵包裹	新西蘭 	zh-HK
1338	2031515	Surface Parcel	New Zealand	en-GB
1339	2031515	平郵包裹	新西蘭 	zh-HK
1340	2031516	平郵包裹	新西蘭 	zh-HK
1341	2031516	Surface Parcel	New Zealand	en-GB
1342	2031517	平郵包裹	新西蘭 	zh-HK
1343	2031517	Surface Parcel	New Zealand	en-GB
1344	2031518	Surface Parcel	New Zealand	en-GB
1345	2031518	平郵包裹	新西蘭 	zh-HK
1346	2031519	平郵包裹	新西蘭 	zh-HK
1347	2031519	Surface Parcel	New Zealand	en-GB
1348	2031520	Surface Parcel	New Zealand	en-GB
1349	2031520	平郵包裹	新西蘭 	zh-HK
1350	2031521	Surface Parcel	New Zealand	en-GB
1351	2031521	平郵包裹	新西蘭 	zh-HK
1352	2031522	平郵包裹	新西蘭 	zh-HK
1353	2031522	Surface Parcel	New Zealand	en-GB
1354	2031523	Surface Parcel	New Zealand	en-GB
1355	2031523	平郵包裹	新西蘭 	zh-HK
1356	2031524	平郵包裹	新西蘭 	zh-HK
1357	2031524	Surface Parcel	New Zealand	en-GB
1358	2031525	Surface Parcel	New Zealand	en-GB
1359	2031525	平郵包裹	新西蘭 	zh-HK
1360	2031526	Surface Parcel	New Zealand	en-GB
1361	2031526	平郵包裹	新西蘭 	zh-HK
1362	2031527	Surface Parcel	New Zealand	en-GB
1363	2031527	平郵包裹	新西蘭 	zh-HK
1364	2031528	Surface Parcel	New Zealand	en-GB
1365	2031528	平郵包裹	新西蘭 	zh-HK
1366	2031529	平郵包裹	新西蘭 	zh-HK
1367	2031529	Surface Parcel	New Zealand	en-GB
1368	2031530	平郵包裹	新西蘭 	zh-HK
1369	2031530	Surface Parcel	New Zealand	en-GB
1370	2031531	Surface Parcel	New Zealand	en-GB
1371	2031531	平郵包裹	新西蘭 	zh-HK
1372	2031532	平郵包裹	新西蘭 	zh-HK
1373	2031532	Surface Parcel	New Zealand	en-GB
1374	2031533	平郵包裹	新西蘭 	zh-HK
1375	2031533	Surface Parcel	New Zealand	en-GB
1376	2031534	平郵包裹	新西蘭 	zh-HK
1377	2031534	Surface Parcel	New Zealand	en-GB
1378	2031535	平郵包裹	新西蘭 	zh-HK
1379	2031535	Surface Parcel	New Zealand	en-GB
1380	2031536	平郵包裹	新西蘭 	zh-HK
1381	2031536	Surface Parcel	New Zealand	en-GB
1382	2031537	平郵包裹	新西蘭 	zh-HK
1383	2031537	Surface Parcel	New Zealand	en-GB
1384	2031538	平郵包裹	新西蘭 	zh-HK
1385	2031538	Surface Parcel	New Zealand	en-GB
1386	2031539	平郵包裹	新西蘭 	zh-HK
1387	2031539	Surface Parcel	New Zealand	en-GB
1388	2031540	平郵包裹	新西蘭 	zh-HK
1389	2031540	Surface Parcel	New Zealand	en-GB
1390	2031541	平郵包裹	新西蘭 	zh-HK
1391	2031541	Surface Parcel	New Zealand	en-GB
1392	2031542	Surface Parcel	New Zealand	en-GB
1393	2031542	平郵包裹	新西蘭 	zh-HK
1394	2031543	平郵包裹	新西蘭 	zh-HK
1395	2031543	Surface Parcel	New Zealand	en-GB
1396	2031544	Surface Parcel	New Zealand	en-GB
1397	2031544	平郵包裹	新西蘭 	zh-HK
1398	2031545	Surface Parcel	New Zealand	en-GB
1399	2031545	平郵包裹	新西蘭 	zh-HK
1400	2031546	平郵包裹	新西蘭 	zh-HK
1401	2031546	Surface Parcel	New Zealand	en-GB
1402	2031547	平郵包裹	新西蘭 	zh-HK
1403	2031547	Surface Parcel	New Zealand	en-GB
1404	2031548	Surface Parcel	New Zealand	en-GB
1405	2031548	平郵包裹	新西蘭 	zh-HK
1406	2031549	Surface Parcel	New Zealand	en-GB
1407	2031549	平郵包裹	新西蘭 	zh-HK
1408	2031550	平郵包裹	新西蘭 	zh-HK
1409	2031550	Surface Parcel	New Zealand	en-GB
1410	2031551	Surface Parcel	New Zealand	en-GB
1411	2031551	平郵包裹	新西蘭 	zh-HK
1412	2031552	平郵包裹	新西蘭 	zh-HK
1413	2031552	Surface Parcel	New Zealand	en-GB
1414	2031553	Surface Parcel	New Zealand	en-GB
1415	2031553	平郵包裹	新西蘭 	zh-HK
1416	2031554	平郵包裹	新西蘭 	zh-HK
1417	2031554	Surface Parcel	New Zealand	en-GB
1418	2031555	平郵包裹	新西蘭 	zh-HK
1419	2031555	Surface Parcel	New Zealand	en-GB
1420	2031556	Surface Parcel	New Zealand	en-GB
1421	2031556	平郵包裹	新西蘭 	zh-HK
1422	2031557	平郵包裹	新西蘭 	zh-HK
1423	2031557	Surface Parcel	New Zealand	en-GB
1424	2031558	平郵包裹	新西蘭 	zh-HK
1425	2031558	Surface Parcel	New Zealand	en-GB
1426	2031559	平郵包裹	新西蘭 	zh-HK
1427	2031559	Surface Parcel	New Zealand	en-GB
1428	2031560	Surface Parcel	New Zealand	en-GB
1429	2031560	平郵包裹	新西蘭 	zh-HK
1430	2031561	Surface Parcel	New Zealand	en-GB
1431	2031561	平郵包裹	新西蘭 	zh-HK
1432	2031562	Surface Parcel	New Zealand	en-GB
1433	2031562	平郵包裹	新西蘭 	zh-HK
1434	2031563	Surface Parcel	New Zealand	en-GB
1435	2031563	平郵包裹	新西蘭 	zh-HK
1436	2031564	Surface Parcel	New Zealand	en-GB
1437	2031564	平郵包裹	新西蘭 	zh-HK
1438	2031565	平郵包裹	新西蘭 	zh-HK
1439	2031565	Surface Parcel	New Zealand	en-GB
1440	2031566	Surface Parcel	New Zealand	en-GB
1441	2031566	平郵包裹	新西蘭 	zh-HK
1442	2031567	平郵包裹	新西蘭 	zh-HK
1443	2031567	Surface Parcel	New Zealand	en-GB
1444	2031568	平郵包裹	新西蘭 	zh-HK
1445	2031568	Surface Parcel	New Zealand	en-GB
1446	2031569	平郵包裹	新西蘭 	zh-HK
1447	2031569	Surface Parcel	New Zealand	en-GB
1448	2031570	平郵包裹	新西蘭 	zh-HK
1449	2031570	Surface Parcel	New Zealand	en-GB
1450	2031571	平郵包裹	新西蘭 	zh-HK
1451	2031571	Surface Parcel	New Zealand	en-GB
1452	2031572	Surface Parcel	New Zealand	en-GB
1453	2031572	平郵包裹	新西蘭 	zh-HK
1454	2031573	Surface Parcel	New Zealand	en-GB
1455	2031573	平郵包裹	新西蘭 	zh-HK
1456	2031574	平郵包裹	新西蘭 	zh-HK
1457	2031574	Surface Parcel	New Zealand	en-GB
1458	2031575	Surface Parcel	New Zealand	en-GB
1459	2031575	平郵包裹	新西蘭 	zh-HK
1460	2031576	Surface Parcel	New Zealand	en-GB
1461	2031576	平郵包裹	新西蘭 	zh-HK
1462	2031577	易網遞 Available	新西蘭 	zh-HK
1463	2031577	e-Express Service	New Zealand	en-GB
1464	2031578	e-Express Service	New Zealand	en-GB
1465	2031578	易網遞 Available	新西蘭 	zh-HK
1466	2031579	易網遞 Available	新西蘭 	zh-HK
1467	2031579	e-Express Service	New Zealand	en-GB
1468	2031580	易網遞 Available	新西蘭 	zh-HK
1469	2031580	e-Express Service	New Zealand	en-GB
1470	2031581	易網遞 Available	新西蘭 	zh-HK
1471	2031581	e-Express Service	New Zealand	en-GB
1472	2031582	易網遞 Available	新西蘭 	zh-HK
1473	2031582	e-Express Service	New Zealand	en-GB
1474	2031583	e-Express Service	New Zealand	en-GB
1475	2031583	易網遞 Available	新西蘭 	zh-HK
1476	2031584	易網遞 Available	新西蘭 	zh-HK
1477	2031584	e-Express Service	New Zealand	en-GB
1478	2031585	e-Express Service	New Zealand	en-GB
1479	2031585	易網遞 Available	新西蘭 	zh-HK
1480	2031586	e-Express Service	New Zealand	en-GB
1481	2031586	易網遞 Available	新西蘭 	zh-HK
1482	2031587	特快專遞（標準服務）	新西蘭 	zh-HK
1483	2031587	SpeedPost (Standard Service)	New Zealand	en-GB
1484	2031588	SpeedPost (Standard Service)	New Zealand	en-GB
1485	2031588	特快專遞（標準服務）	新西蘭 	zh-HK
1486	2031589	SpeedPost (Standard Service)	New Zealand	en-GB
1487	2031589	特快專遞（標準服務）	新西蘭 	zh-HK
1488	2031590	特快專遞（標準服務）	新西蘭 	zh-HK
1489	2031590	SpeedPost (Standard Service)	New Zealand	en-GB
1490	2031591	SpeedPost (Standard Service)	New Zealand	en-GB
1491	2031591	特快專遞（標準服務）	新西蘭 	zh-HK
1492	2031592	SpeedPost (Standard Service)	New Zealand	en-GB
1493	2031592	特快專遞（標準服務）	新西蘭 	zh-HK
1494	2031593	SpeedPost (Standard Service)	New Zealand	en-GB
1495	2031593	特快專遞（標準服務）	新西蘭 	zh-HK
1496	2031594	特快專遞（標準服務）	新西蘭 	zh-HK
1497	2031594	SpeedPost (Standard Service)	New Zealand	en-GB
1498	2031595	SpeedPost (Standard Service)	New Zealand	en-GB
1499	2031595	特快專遞（標準服務）	新西蘭 	zh-HK
1500	2031596	特快專遞（標準服務）	新西蘭 	zh-HK
1501	2031596	SpeedPost (Standard Service)	New Zealand	en-GB
1502	2031597	SpeedPost (Standard Service)	New Zealand	en-GB
1503	2031597	特快專遞（標準服務）	新西蘭 	zh-HK
1504	2031598	特快專遞（標準服務）	新西蘭 	zh-HK
1505	2031598	SpeedPost (Standard Service)	New Zealand	en-GB
1506	2031599	SpeedPost (Standard Service)	New Zealand	en-GB
1507	2031599	特快專遞（標準服務）	新西蘭 	zh-HK
1508	2031600	SpeedPost (Standard Service)	New Zealand	en-GB
1509	2031600	特快專遞（標準服務）	新西蘭 	zh-HK
1510	2031601	SpeedPost (Standard Service)	New Zealand	en-GB
1511	2031601	特快專遞（標準服務）	新西蘭 	zh-HK
1512	2031602	特快專遞（標準服務）	新西蘭 	zh-HK
1513	2031602	SpeedPost (Standard Service)	New Zealand	en-GB
1514	2031603	SpeedPost (Standard Service)	New Zealand	en-GB
1515	2031603	特快專遞（標準服務）	新西蘭 	zh-HK
1516	2031604	特快專遞（標準服務）	新西蘭 	zh-HK
1517	2031604	SpeedPost (Standard Service)	New Zealand	en-GB
1518	2031605	SpeedPost (Standard Service)	New Zealand	en-GB
1519	2031605	特快專遞（標準服務）	新西蘭 	zh-HK
1520	2031606	SpeedPost (Standard Service)	New Zealand	en-GB
1521	2031606	特快專遞（標準服務）	新西蘭 	zh-HK
1522	2031607	SpeedPost (Standard Service)	New Zealand	en-GB
1523	2031607	特快專遞（標準服務）	新西蘭 	zh-HK
1524	2031608	特快專遞（標準服務）	新西蘭 	zh-HK
1525	2031608	SpeedPost (Standard Service)	New Zealand	en-GB
1526	2031609	特快專遞（標準服務）	新西蘭 	zh-HK
1527	2031609	SpeedPost (Standard Service)	New Zealand	en-GB
1528	2031610	SpeedPost (Standard Service)	New Zealand	en-GB
1529	2031610	特快專遞（標準服務）	新西蘭 	zh-HK
1530	2031611	特快專遞（標準服務）	新西蘭 	zh-HK
1531	2031611	SpeedPost (Standard Service)	New Zealand	en-GB
1532	2031612	特快專遞（標準服務）	新西蘭 	zh-HK
1533	2031612	SpeedPost (Standard Service)	New Zealand	en-GB
1534	2031613	SpeedPost (Standard Service)	New Zealand	en-GB
1535	2031613	特快專遞（標準服務）	新西蘭 	zh-HK
1536	2031614	SpeedPost (Standard Service)	New Zealand	en-GB
1537	2031614	特快專遞（標準服務）	新西蘭 	zh-HK
1538	2031615	SpeedPost (Standard Service)	New Zealand	en-GB
1539	2031615	特快專遞（標準服務）	新西蘭 	zh-HK
1540	2031616	SpeedPost (Standard Service)	New Zealand	en-GB
1541	2031616	特快專遞（標準服務）	新西蘭 	zh-HK
1542	2031617	特快專遞（標準服務）	新西蘭 	zh-HK
1543	2031617	SpeedPost (Standard Service)	New Zealand	en-GB
1544	2031618	特快專遞（標準服務）	新西蘭 	zh-HK
1545	2031618	SpeedPost (Standard Service)	New Zealand	en-GB
1546	2031619	SpeedPost (Standard Service)	New Zealand	en-GB
1547	2031619	特快專遞（標準服務）	新西蘭 	zh-HK
1548	2031620	特快專遞（標準服務）	新西蘭 	zh-HK
1549	2031620	SpeedPost (Standard Service)	New Zealand	en-GB
1550	2031621	特快專遞（標準服務）	新西蘭 	zh-HK
1551	2031621	SpeedPost (Standard Service)	New Zealand	en-GB
1552	2031622	特快專遞（標準服務）	新西蘭 	zh-HK
1553	2031622	SpeedPost (Standard Service)	New Zealand	en-GB
1554	2031623	SpeedPost (Standard Service)	New Zealand	en-GB
1555	2031623	特快專遞（標準服務）	新西蘭 	zh-HK
1556	2031624	特快專遞（標準服務）	新西蘭 	zh-HK
1557	2031624	SpeedPost (Standard Service)	New Zealand	en-GB
1558	2031625	SpeedPost (Standard Service)	New Zealand	en-GB
1559	2031625	特快專遞（標準服務）	新西蘭 	zh-HK
1560	2031626	特快專遞（標準服務）	新西蘭 	zh-HK
1561	2031626	SpeedPost (Standard Service)	New Zealand	en-GB
1562	2031627	SpeedPost (Standard Service)	New Zealand	en-GB
1563	2031627	特快專遞（標準服務）	新西蘭 	zh-HK
1564	2031628	特快專遞（標準服務）	新西蘭 	zh-HK
1565	2031628	SpeedPost (Standard Service)	New Zealand	en-GB
1566	2031629	SpeedPost (Standard Service)	New Zealand	en-GB
1567	2031629	特快專遞（標準服務）	新西蘭 	zh-HK
1568	2031630	SpeedPost (Standard Service)	New Zealand	en-GB
1569	2031630	特快專遞（標準服務）	新西蘭 	zh-HK
1570	2031631	SpeedPost (Standard Service)	New Zealand	en-GB
1571	2031631	特快專遞（標準服務）	新西蘭 	zh-HK
1572	2031632	SpeedPost (Standard Service)	New Zealand	en-GB
1573	2031632	特快專遞（標準服務）	新西蘭 	zh-HK
1574	2031633	SpeedPost (Standard Service)	New Zealand	en-GB
1575	2031633	特快專遞（標準服務）	新西蘭 	zh-HK
1576	2031634	SpeedPost (Standard Service)	New Zealand	en-GB
1577	2031634	特快專遞（標準服務）	新西蘭 	zh-HK
1578	2031635	特快專遞（標準服務）	新西蘭 	zh-HK
1579	2031635	SpeedPost (Standard Service)	New Zealand	en-GB
1580	2031636	特快專遞（標準服務）	新西蘭 	zh-HK
1581	2031636	SpeedPost (Standard Service)	New Zealand	en-GB
1582	2031637	特快專遞（標準服務）	新西蘭 	zh-HK
1583	2031637	SpeedPost (Standard Service)	New Zealand	en-GB
1584	2031638	特快專遞（標準服務）	新西蘭 	zh-HK
1585	2031638	SpeedPost (Standard Service)	New Zealand	en-GB
1586	2031639	特快專遞（標準服務）	新西蘭 	zh-HK
1587	2031639	SpeedPost (Standard Service)	New Zealand	en-GB
1588	2031640	特快專遞（標準服務）	新西蘭 	zh-HK
1589	2031640	SpeedPost (Standard Service)	New Zealand	en-GB
1590	2031641	SpeedPost (Standard Service)	New Zealand	en-GB
1591	2031641	特快專遞（標準服務）	新西蘭 	zh-HK
1592	2031642	SpeedPost (Standard Service)	New Zealand	en-GB
1593	2031642	特快專遞（標準服務）	新西蘭 	zh-HK
1594	2031643	特快專遞（標準服務）	新西蘭 	zh-HK
1595	2031643	SpeedPost (Standard Service)	New Zealand	en-GB
1596	2031644	SpeedPost (Standard Service)	New Zealand	en-GB
1597	2031644	特快專遞（標準服務）	新西蘭 	zh-HK
1598	2031645	特快專遞（標準服務）	新西蘭 	zh-HK
1599	2031645	SpeedPost (Standard Service)	New Zealand	en-GB
1600	2031646	特快專遞（標準服務）	新西蘭 	zh-HK
1601	2031646	SpeedPost (Standard Service)	New Zealand	en-GB
1602	2031647	特快專遞（標準服務）	新西蘭 	zh-HK
1603	2031647	SpeedPost (Standard Service)	New Zealand	en-GB
1604	2031648	特快專遞（標準服務）	新西蘭 	zh-HK
1605	2031648	SpeedPost (Standard Service)	New Zealand	en-GB
1606	2031649	SpeedPost (Standard Service)	New Zealand	en-GB
1607	2031649	特快專遞（標準服務）	新西蘭 	zh-HK
1608	2031650	SpeedPost (Standard Service)	New Zealand	en-GB
1609	2031650	特快專遞（標準服務）	新西蘭 	zh-HK
1610	2031651	SpeedPost (Standard Service)	New Zealand	en-GB
1611	2031651	特快專遞（標準服務）	新西蘭 	zh-HK
1612	2031652	SpeedPost (Standard Service)	New Zealand	en-GB
1613	2031652	特快專遞（標準服務）	新西蘭 	zh-HK
1614	2031653	特快專遞（標準服務）	新西蘭 	zh-HK
1615	2031653	SpeedPost (Standard Service)	New Zealand	en-GB
1616	2031654	SpeedPost (Standard Service)	New Zealand	en-GB
1617	2031654	特快專遞（標準服務）	新西蘭 	zh-HK
1618	2031655	SpeedPost (Standard Service)	New Zealand	en-GB
1619	2031655	特快專遞（標準服務）	新西蘭 	zh-HK
1620	2031656	SpeedPost (Standard Service)	New Zealand	en-GB
1621	2031656	特快專遞（標準服務）	新西蘭 	zh-HK
1622	2031657	SpeedPost (Standard Service)	New Zealand	en-GB
1623	2031657	特快專遞（標準服務）	新西蘭 	zh-HK
1624	2031658	SpeedPost (Standard Service)	New Zealand	en-GB
1625	2031658	特快專遞（標準服務）	新西蘭 	zh-HK
1626	2031659	SpeedPost (Standard Service)	New Zealand	en-GB
1627	2031659	特快專遞（標準服務）	新西蘭 	zh-HK
1628	2031660	SpeedPost (Standard Service)	New Zealand	en-GB
1629	2031660	特快專遞（標準服務）	新西蘭 	zh-HK
1630	2031661	特快專遞（標準服務）	新西蘭 	zh-HK
1631	2031661	SpeedPost (Standard Service)	New Zealand	en-GB
1632	2031662	特快專遞（標準服務）	新西蘭 	zh-HK
1633	2031662	SpeedPost (Standard Service)	New Zealand	en-GB
1634	2031663	SpeedPost (Standard Service)	New Zealand	en-GB
1635	2031663	特快專遞（標準服務）	新西蘭 	zh-HK
1636	2031664	SpeedPost (Standard Service)	New Zealand	en-GB
1637	2031664	特快專遞（標準服務）	新西蘭 	zh-HK
1638	2031665	SpeedPost (Standard Service)	New Zealand	en-GB
1639	2031665	特快專遞（標準服務）	新西蘭 	zh-HK
1640	2031666	SpeedPost (Standard Service)	New Zealand	en-GB
1641	2031666	特快專遞（標準服務）	新西蘭 	zh-HK
1642	2031667	特快專遞（標準服務）	新西蘭 	zh-HK
1643	2031667	SpeedPost (Standard Service)	New Zealand	en-GB
1644	2031668	特快專遞（標準服務）	新西蘭 	zh-HK
1645	2031668	SpeedPost (Standard Service)	New Zealand	en-GB
1646	2031669	SpeedPost (Standard Service)	New Zealand	en-GB
1647	2031669	特快專遞（標準服務）	新西蘭 	zh-HK
1648	2031670	SpeedPost (Standard Service)	New Zealand	en-GB
1649	2031670	特快專遞（標準服務）	新西蘭 	zh-HK
1650	2031671	特快專遞（標準服務）	新西蘭 	zh-HK
1651	2031671	SpeedPost (Standard Service)	New Zealand	en-GB
1652	2031672	SpeedPost (Standard Service)	New Zealand	en-GB
1653	2031672	特快專遞（標準服務）	新西蘭 	zh-HK
1654	2031673	SpeedPost (Standard Service)	New Zealand	en-GB
1655	2031673	特快專遞（標準服務）	新西蘭 	zh-HK
1656	2031674	特快專遞（標準服務）	新西蘭 	zh-HK
1657	2031674	SpeedPost (Standard Service)	New Zealand	en-GB
1658	2031675	特快專遞（標準服務）	新西蘭 	zh-HK
1659	2031675	SpeedPost (Standard Service)	New Zealand	en-GB
1660	2031676	特快專遞（標準服務）	新西蘭 	zh-HK
1661	2031676	SpeedPost (Standard Service)	New Zealand	en-GB
1662	2031677	特快專遞（標準服務）	新西蘭 	zh-HK
1663	2031677	SpeedPost (Standard Service)	New Zealand	en-GB
1664	2031678	特快專遞（標準服務）	新西蘭 	zh-HK
1665	2031678	SpeedPost (Standard Service)	New Zealand	en-GB
1666	2031679	特快專遞（標準服務）	新西蘭 	zh-HK
1667	2031679	SpeedPost (Standard Service)	New Zealand	en-GB
1668	2031680	SpeedPost (Standard Service)	New Zealand	en-GB
1669	2031680	特快專遞（標準服務）	新西蘭 	zh-HK
1670	2031681	特快專遞（標準服務）	新西蘭 	zh-HK
1671	2031681	SpeedPost (Standard Service)	New Zealand	en-GB
1672	2031682	特快專遞（標準服務）	新西蘭 	zh-HK
1673	2031682	SpeedPost (Standard Service)	New Zealand	en-GB
1674	2031683	SpeedPost (Standard Service)	New Zealand	en-GB
1675	2031683	特快專遞（標準服務）	新西蘭 	zh-HK
1676	2031684	SpeedPost (Standard Service)	New Zealand	en-GB
1677	2031684	特快專遞（標準服務）	新西蘭 	zh-HK
1678	2031685	SpeedPost (Standard Service)	New Zealand	en-GB
1679	2031685	特快專遞（標準服務）	新西蘭 	zh-HK
1680	2031686	SpeedPost (Standard Service)	New Zealand	en-GB
1681	2031686	特快專遞（標準服務）	新西蘭 	zh-HK
1682	2031687	SpeedPost (Standard Service)	New Zealand	en-GB
1683	2031687	特快專遞（標準服務）	新西蘭 	zh-HK
1684	2031688	特快專遞（標準服務）	新西蘭 	zh-HK
1685	2031688	SpeedPost (Standard Service)	New Zealand	en-GB
1686	2031689	特快專遞（標準服務）	新西蘭 	zh-HK
1687	2031689	SpeedPost (Standard Service)	New Zealand	en-GB
1688	2031690	特快專遞（標準服務）	新西蘭 	zh-HK
1689	2031690	SpeedPost (Standard Service)	New Zealand	en-GB
1690	2031691	特快專遞（標準服務）	新西蘭 	zh-HK
1691	2031691	SpeedPost (Standard Service)	New Zealand	en-GB
1692	2031692	特快專遞（標準服務）	新西蘭 	zh-HK
1693	2031692	SpeedPost (Standard Service)	New Zealand	en-GB
1694	2031693	特快專遞（標準服務）	新西蘭 	zh-HK
1695	2031693	SpeedPost (Standard Service)	New Zealand	en-GB
1696	2031694	SpeedPost (Standard Service)	New Zealand	en-GB
1697	2031694	特快專遞（標準服務）	新西蘭 	zh-HK
1698	2031695	特快專遞（標準服務）	新西蘭 	zh-HK
1699	2031695	SpeedPost (Standard Service)	New Zealand	en-GB
1700	2031696	特快專遞（標準服務）	新西蘭 	zh-HK
1701	2031696	SpeedPost (Standard Service)	New Zealand	en-GB
1702	2031697	特快專遞（標準服務）	新西蘭 	zh-HK
1703	2031697	SpeedPost (Standard Service)	New Zealand	en-GB
1704	2031698	SpeedPost (Standard Service)	New Zealand	en-GB
1705	2031698	特快專遞（標準服務）	新西蘭 	zh-HK
1706	2031699	特快專遞（標準服務）	新西蘭 	zh-HK
1707	2031699	SpeedPost (Standard Service)	New Zealand	en-GB
1708	2031700	特快專遞（標準服務）	新西蘭 	zh-HK
1709	2031700	SpeedPost (Standard Service)	New Zealand	en-GB
1710	2031701	SpeedPost (Standard Service)	New Zealand	en-GB
1711	2031701	特快專遞（標準服務）	新西蘭 	zh-HK
1712	2031702	特快專遞（標準服務）	新西蘭 	zh-HK
1713	2031702	SpeedPost (Standard Service)	New Zealand	en-GB
1714	2031703	SpeedPost (Standard Service)	New Zealand	en-GB
1715	2031703	特快專遞（標準服務）	新西蘭 	zh-HK
1716	2031704	SpeedPost (Standard Service)	New Zealand	en-GB
1717	2031704	特快專遞（標準服務）	新西蘭 	zh-HK
1718	2031705	SpeedPost (Standard Service)	New Zealand	en-GB
1719	2031705	特快專遞（標準服務）	新西蘭 	zh-HK
1720	2031706	SpeedPost (Standard Service)	New Zealand	en-GB
1721	2031706	特快專遞（標準服務）	新西蘭 	zh-HK
1722	2031707	SpeedPost (Standard Service)	New Zealand	en-GB
1723	2031707	特快專遞（標準服務）	新西蘭 	zh-HK
1724	2031708	特快專遞（標準服務）	新西蘭 	zh-HK
1725	2031708	SpeedPost (Standard Service)	New Zealand	en-GB
1726	2031709	特快專遞（標準服務）	新西蘭 	zh-HK
1727	2031709	SpeedPost (Standard Service)	New Zealand	en-GB
1728	2031710	SpeedPost (Standard Service)	New Zealand	en-GB
1729	2031710	特快專遞（標準服務）	新西蘭 	zh-HK
1730	2031711	特快專遞（標準服務）	新西蘭 	zh-HK
1731	2031711	SpeedPost (Standard Service)	New Zealand	en-GB
1732	2031712	SpeedPost (Standard Service)	New Zealand	en-GB
1733	2031712	特快專遞（標準服務）	新西蘭 	zh-HK
1734	2031713	SpeedPost (Standard Service)	New Zealand	en-GB
1735	2031713	特快專遞（標準服務）	新西蘭 	zh-HK
1736	2031714	特快專遞（標準服務）	新西蘭 	zh-HK
1737	2031714	SpeedPost (Standard Service)	New Zealand	en-GB
1738	2031715	SpeedPost (Standard Service)	New Zealand	en-GB
1739	2031715	特快專遞（標準服務）	新西蘭 	zh-HK
1740	2031716	特快專遞（標準服務）	新西蘭 	zh-HK
1741	2031716	SpeedPost (Standard Service)	New Zealand	en-GB
1742	2031717	特快專遞（標準服務）	新西蘭 	zh-HK
1743	2031717	SpeedPost (Standard Service)	New Zealand	en-GB
1744	2031718	特快專遞（標準服務）	新西蘭 	zh-HK
1745	2031718	SpeedPost (Standard Service)	New Zealand	en-GB
1746	2031719	特快專遞（標準服務）	新西蘭 	zh-HK
1747	2031719	SpeedPost (Standard Service)	New Zealand	en-GB
1748	2031720	SpeedPost (Standard Service)	New Zealand	en-GB
1749	2031720	特快專遞（標準服務）	新西蘭 	zh-HK
1750	2031721	特快專遞（標準服務）	新西蘭 	zh-HK
1751	2031721	SpeedPost (Standard Service)	New Zealand	en-GB
1752	2031722	特快專遞（標準服務）	新西蘭 	zh-HK
1753	2031722	SpeedPost (Standard Service)	New Zealand	en-GB
1754	2031723	特快專遞（標準服務）	新西蘭 	zh-HK
1755	2031723	SpeedPost (Standard Service)	New Zealand	en-GB
1756	2031724	SpeedPost (Standard Service)	New Zealand	en-GB
1757	2031724	特快專遞（標準服務）	新西蘭 	zh-HK
1758	2031725	SpeedPost (Standard Service)	New Zealand	en-GB
1759	2031725	特快專遞（標準服務）	新西蘭 	zh-HK
1760	2031726	特快專遞（標準服務）	新西蘭 	zh-HK
1761	2031726	SpeedPost (Standard Service)	New Zealand	en-GB
1762	2031727	SpeedPost (Standard Service)	New Zealand	en-GB
1763	2031727	特快專遞（標準服務）	新西蘭 	zh-HK
1764	2031728	特快專遞（標準服務）	新西蘭 	zh-HK
1765	2031728	SpeedPost (Standard Service)	New Zealand	en-GB
1766	2031729	SpeedPost (Standard Service)	New Zealand	en-GB
1767	2031729	特快專遞（標準服務）	新西蘭 	zh-HK
1768	2031730	特快專遞（標準服務）	新西蘭 	zh-HK
1769	2031730	SpeedPost (Standard Service)	New Zealand	en-GB
1770	2031731	SpeedPost (Standard Service)	New Zealand	en-GB
1771	2031731	特快專遞（標準服務）	新西蘭 	zh-HK
1772	2031732	特快專遞（標準服務）	新西蘭 	zh-HK
1773	2031732	SpeedPost (Standard Service)	New Zealand	en-GB
1774	2031733	SpeedPost (Standard Service)	New Zealand	en-GB
1775	2031733	特快專遞（標準服務）	新西蘭 	zh-HK
1776	2031734	SpeedPost (Standard Service)	New Zealand	en-GB
1777	2031734	特快專遞（標準服務）	新西蘭 	zh-HK
1778	2031735	特快專遞（標準服務）	新西蘭 	zh-HK
1779	2031735	SpeedPost (Standard Service)	New Zealand	en-GB
1780	2031736	特快專遞（標準服務）	新西蘭 	zh-HK
1781	2031736	SpeedPost (Standard Service)	New Zealand	en-GB
1782	2031737	Speedpost (Multipack Service) 	New Zealand	en-GB
1783	2031737	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1784	2031738	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1785	2031738	Speedpost (Multipack Service) 	New Zealand	en-GB
1786	2031739	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1787	2031739	Speedpost (Multipack Service) 	New Zealand	en-GB
1788	2031740	Speedpost (Multipack Service) 	New Zealand	en-GB
1789	2031740	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1790	2031741	Speedpost (Multipack Service) 	New Zealand	en-GB
1791	2031741	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1792	2031742	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1793	2031742	Speedpost (Multipack Service) 	New Zealand	en-GB
1794	2031743	Speedpost (Multipack Service) 	New Zealand	en-GB
1795	2031743	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1796	2031744	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1797	2031744	Speedpost (Multipack Service) 	New Zealand	en-GB
1798	2031745	Speedpost (Multipack Service) 	New Zealand	en-GB
1799	2031745	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1800	2031746	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1801	2031746	Speedpost (Multipack Service) 	New Zealand	en-GB
1802	2031747	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1803	2031747	Speedpost (Multipack Service) 	New Zealand	en-GB
1804	2031748	Speedpost (Multipack Service) 	New Zealand	en-GB
1805	2031748	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1806	2031749	Speedpost (Multipack Service) 	New Zealand	en-GB
1807	2031749	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1808	2031750	Speedpost (Multipack Service) 	New Zealand	en-GB
1809	2031750	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1810	2031751	Speedpost (Multipack Service) 	New Zealand	en-GB
1811	2031751	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1812	2031752	Speedpost (Multipack Service) 	New Zealand	en-GB
1813	2031752	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1814	2031753	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1815	2031753	Speedpost (Multipack Service) 	New Zealand	en-GB
1816	2031754	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1817	2031754	Speedpost (Multipack Service) 	New Zealand	en-GB
1818	2031755	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1819	2031755	Speedpost (Multipack Service) 	New Zealand	en-GB
1820	2031756	Speedpost (Multipack Service) 	New Zealand	en-GB
1821	2031756	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1822	2031757	Speedpost (Multipack Service) 	New Zealand	en-GB
1823	2031757	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1824	2031758	Speedpost (Multipack Service) 	New Zealand	en-GB
1825	2031758	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1826	2031759	Speedpost (Multipack Service) 	New Zealand	en-GB
1827	2031759	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1828	2031760	Speedpost (Multipack Service) 	New Zealand	en-GB
1829	2031760	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1830	2031761	Speedpost (Multipack Service) 	New Zealand	en-GB
1831	2031761	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1832	2031762	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1833	2031762	Speedpost (Multipack Service) 	New Zealand	en-GB
1834	2031763	Speedpost (Multipack Service) 	New Zealand	en-GB
1835	2031763	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1836	2031764	Speedpost (Multipack Service) 	New Zealand	en-GB
1837	2031764	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1838	2031765	Speedpost (Multipack Service) 	New Zealand	en-GB
1839	2031765	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1840	2031766	Speedpost (Multipack Service) 	New Zealand	en-GB
1841	2031766	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1842	2031767	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1843	2031767	Speedpost (Multipack Service) 	New Zealand	en-GB
1844	2031768	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1845	2031768	Speedpost (Multipack Service) 	New Zealand	en-GB
1846	2031769	Speedpost (Multipack Service) 	New Zealand	en-GB
1847	2031769	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1848	2031770	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1849	2031770	Speedpost (Multipack Service) 	New Zealand	en-GB
1850	2031771	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1851	2031771	Speedpost (Multipack Service) 	New Zealand	en-GB
1852	2031772	Speedpost (Multipack Service) 	New Zealand	en-GB
1853	2031772	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1854	2031773	Speedpost (Multipack Service) 	New Zealand	en-GB
1855	2031773	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1856	2031774	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1857	2031774	Speedpost (Multipack Service) 	New Zealand	en-GB
1858	2031775	Speedpost (Multipack Service) 	New Zealand	en-GB
1859	2031775	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1860	2031776	Speedpost (Multipack Service) 	New Zealand	en-GB
1861	2031776	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1862	2031777	Speedpost (Multipack Service) 	New Zealand	en-GB
1863	2031777	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1864	2031778	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1865	2031778	Speedpost (Multipack Service) 	New Zealand	en-GB
1866	2031779	Speedpost (Multipack Service) 	New Zealand	en-GB
1867	2031779	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1868	2031780	Speedpost (Multipack Service) 	New Zealand	en-GB
1869	2031780	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1870	2031781	Speedpost (Multipack Service) 	New Zealand	en-GB
1871	2031781	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1872	2031782	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1873	2031782	Speedpost (Multipack Service) 	New Zealand	en-GB
1874	2031783	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1875	2031783	Speedpost (Multipack Service) 	New Zealand	en-GB
1876	2031784	Speedpost (Multipack Service) 	New Zealand	en-GB
1877	2031784	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1878	2031785	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1879	2031785	Speedpost (Multipack Service) 	New Zealand	en-GB
1880	2031786	Speedpost (Multipack Service) 	New Zealand	en-GB
1881	2031786	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1882	2031787	Speedpost (Multipack Service) 	New Zealand	en-GB
1883	2031787	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1884	2031788	Speedpost (Multipack Service) 	New Zealand	en-GB
1885	2031788	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1886	2031789	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1887	2031789	Speedpost (Multipack Service) 	New Zealand	en-GB
1888	2031790	Speedpost (Multipack Service) 	New Zealand	en-GB
1889	2031790	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1890	2031791	Speedpost (Multipack Service) 	New Zealand	en-GB
1891	2031791	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1892	2031792	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1893	2031792	Speedpost (Multipack Service) 	New Zealand	en-GB
1894	2031793	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1895	2031793	Speedpost (Multipack Service) 	New Zealand	en-GB
1896	2031794	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1897	2031794	Speedpost (Multipack Service) 	New Zealand	en-GB
1898	2031795	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1899	2031795	Speedpost (Multipack Service) 	New Zealand	en-GB
1900	2031796	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1901	2031796	Speedpost (Multipack Service) 	New Zealand	en-GB
1902	2031797	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1903	2031797	Speedpost (Multipack Service) 	New Zealand	en-GB
1904	2031798	Speedpost (Multipack Service) 	New Zealand	en-GB
1905	2031798	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1906	2031799	Speedpost (Multipack Service) 	New Zealand	en-GB
1907	2031799	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1908	2031800	Speedpost (Multipack Service) 	New Zealand	en-GB
1909	2031800	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1910	2031801	Speedpost (Multipack Service) 	New Zealand	en-GB
1911	2031801	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1912	2031802	Speedpost (Multipack Service) 	New Zealand	en-GB
1913	2031802	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1914	2031803	Speedpost (Multipack Service) 	New Zealand	en-GB
1915	2031803	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1916	2031804	Speedpost (Multipack Service) 	New Zealand	en-GB
1917	2031804	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1918	2031805	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1919	2031805	Speedpost (Multipack Service) 	New Zealand	en-GB
1920	2031806	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1921	2031806	Speedpost (Multipack Service) 	New Zealand	en-GB
1922	2031807	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1923	2031807	Speedpost (Multipack Service) 	New Zealand	en-GB
1924	2031808	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1925	2031808	Speedpost (Multipack Service) 	New Zealand	en-GB
1926	2031809	Speedpost (Multipack Service) 	New Zealand	en-GB
1927	2031809	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1928	2031810	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1929	2031810	Speedpost (Multipack Service) 	New Zealand	en-GB
1930	2031811	Speedpost (Multipack Service) 	New Zealand	en-GB
1931	2031811	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1932	2031812	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1933	2031812	Speedpost (Multipack Service) 	New Zealand	en-GB
1934	2031813	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1935	2031813	Speedpost (Multipack Service) 	New Zealand	en-GB
1936	2031814	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1937	2031814	Speedpost (Multipack Service) 	New Zealand	en-GB
1938	2031815	Speedpost (Multipack Service) 	New Zealand	en-GB
1939	2031815	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1940	2031816	Speedpost (Multipack Service) 	New Zealand	en-GB
1941	2031816	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1942	2031817	Speedpost (Multipack Service) 	New Zealand	en-GB
1943	2031817	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1944	2031818	Speedpost (Multipack Service) 	New Zealand	en-GB
1945	2031818	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1946	2031819	Speedpost (Multipack Service) 	New Zealand	en-GB
1947	2031819	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1948	2031820	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1949	2031820	Speedpost (Multipack Service) 	New Zealand	en-GB
1950	2031821	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1951	2031821	Speedpost (Multipack Service) 	New Zealand	en-GB
1952	2031822	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1953	2031822	Speedpost (Multipack Service) 	New Zealand	en-GB
1954	2031823	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1955	2031823	Speedpost (Multipack Service) 	New Zealand	en-GB
1956	2031824	Speedpost (Multipack Service) 	New Zealand	en-GB
1957	2031824	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1958	2031825	Speedpost (Multipack Service) 	New Zealand	en-GB
1959	2031825	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1960	2031826	Speedpost (Multipack Service) 	New Zealand	en-GB
1961	2031826	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1962	2031827	Speedpost (Multipack Service) 	New Zealand	en-GB
1963	2031827	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1964	2031828	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1965	2031828	Speedpost (Multipack Service) 	New Zealand	en-GB
1966	2031829	Speedpost (Multipack Service) 	New Zealand	en-GB
1967	2031829	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1968	2031830	Speedpost (Multipack Service) 	New Zealand	en-GB
1969	2031830	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1970	2031831	Speedpost (Multipack Service) 	New Zealand	en-GB
1971	2031831	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1972	2031832	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1973	2031832	Speedpost (Multipack Service) 	New Zealand	en-GB
1974	2031833	Speedpost (Multipack Service) 	New Zealand	en-GB
1975	2031833	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1976	2031834	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1977	2031834	Speedpost (Multipack Service) 	New Zealand	en-GB
1978	2031835	Speedpost (Multipack Service) 	New Zealand	en-GB
1979	2031835	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1980	2031836	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1981	2031836	Speedpost (Multipack Service) 	New Zealand	en-GB
1982	2031837	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1983	2031837	Speedpost (Multipack Service) 	New Zealand	en-GB
1984	2031838	Speedpost (Multipack Service) 	New Zealand	en-GB
1985	2031838	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1986	2031839	Speedpost (Multipack Service) 	New Zealand	en-GB
1987	2031839	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1988	2031840	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1989	2031840	Speedpost (Multipack Service) 	New Zealand	en-GB
1990	2031841	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1991	2031841	Speedpost (Multipack Service) 	New Zealand	en-GB
1992	2031842	Speedpost (Multipack Service) 	New Zealand	en-GB
1993	2031842	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1994	2031843	Speedpost (Multipack Service) 	New Zealand	en-GB
1995	2031843	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1996	2031844	Speedpost (Multipack Service) 	New Zealand	en-GB
1997	2031844	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1998	2031845	特快專遞（萬用箱服務）	新西蘭 	zh-HK
1999	2031845	Speedpost (Multipack Service) 	New Zealand	en-GB
2000	2031846	Speedpost (Multipack Service) 	New Zealand	en-GB
2001	2031846	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2002	2031847	Speedpost (Multipack Service) 	New Zealand	en-GB
2003	2031847	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2004	2031848	Speedpost (Multipack Service) 	New Zealand	en-GB
2005	2031848	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2006	2031849	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2007	2031849	Speedpost (Multipack Service) 	New Zealand	en-GB
2008	2031850	Speedpost (Multipack Service) 	New Zealand	en-GB
2009	2031850	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2010	2031851	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2011	2031851	Speedpost (Multipack Service) 	New Zealand	en-GB
2012	2031852	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2013	2031852	Speedpost (Multipack Service) 	New Zealand	en-GB
2014	2031853	Speedpost (Multipack Service) 	New Zealand	en-GB
2015	2031853	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2016	2031854	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2017	2031854	Speedpost (Multipack Service) 	New Zealand	en-GB
2018	2031855	Speedpost (Multipack Service) 	New Zealand	en-GB
2019	2031855	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2020	2031856	Speedpost (Multipack Service) 	New Zealand	en-GB
2021	2031856	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2022	2031857	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2023	2031857	Speedpost (Multipack Service) 	New Zealand	en-GB
2024	2031858	Speedpost (Multipack Service) 	New Zealand	en-GB
2025	2031858	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2026	2031859	Speedpost (Multipack Service) 	New Zealand	en-GB
2027	2031859	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2028	2031860	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2029	2031860	Speedpost (Multipack Service) 	New Zealand	en-GB
2030	2031861	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2031	2031861	Speedpost (Multipack Service) 	New Zealand	en-GB
2032	2031862	Speedpost (Multipack Service) 	New Zealand	en-GB
2033	2031862	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2034	2031863	Speedpost (Multipack Service) 	New Zealand	en-GB
2035	2031863	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2036	2031864	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2037	2031864	Speedpost (Multipack Service) 	New Zealand	en-GB
2038	2031865	Speedpost (Multipack Service) 	New Zealand	en-GB
2039	2031865	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2040	2031866	Speedpost (Multipack Service) 	New Zealand	en-GB
2041	2031866	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2042	2031867	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2043	2031867	Speedpost (Multipack Service) 	New Zealand	en-GB
2044	2031868	Speedpost (Multipack Service) 	New Zealand	en-GB
2045	2031868	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2046	2031869	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2047	2031869	Speedpost (Multipack Service) 	New Zealand	en-GB
2048	2031870	Speedpost (Multipack Service) 	New Zealand	en-GB
2049	2031870	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2050	2031871	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2051	2031871	Speedpost (Multipack Service) 	New Zealand	en-GB
2052	2031872	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2053	2031872	Speedpost (Multipack Service) 	New Zealand	en-GB
2054	2031873	Speedpost (Multipack Service) 	New Zealand	en-GB
2055	2031873	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2056	2031874	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2057	2031874	Speedpost (Multipack Service) 	New Zealand	en-GB
2058	2031875	Speedpost (Multipack Service) 	New Zealand	en-GB
2059	2031875	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2060	2031876	Speedpost (Multipack Service) 	New Zealand	en-GB
2061	2031876	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2062	2031877	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2063	2031877	Speedpost (Multipack Service) 	New Zealand	en-GB
2064	2031878	Speedpost (Multipack Service) 	New Zealand	en-GB
2065	2031878	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2066	2031879	Speedpost (Multipack Service) 	New Zealand	en-GB
2067	2031879	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2068	2031880	Speedpost (Multipack Service) 	New Zealand	en-GB
2069	2031880	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2070	2031881	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2071	2031881	Speedpost (Multipack Service) 	New Zealand	en-GB
2072	2031882	Speedpost (Multipack Service) 	New Zealand	en-GB
2073	2031882	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2074	2031883	Speedpost (Multipack Service) 	New Zealand	en-GB
2075	2031883	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2076	2031884	Speedpost (Multipack Service) 	New Zealand	en-GB
2077	2031884	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2078	2031885	Speedpost (Multipack Service) 	New Zealand	en-GB
2079	2031885	特快專遞（萬用箱服務）	新西蘭 	zh-HK
2080	2031886	Speedpost (Multipack Service) 	New Zealand	en-GB
2081	2031886	特快專遞（萬用箱服務）	新西蘭 	zh-HK
\.


--
-- Data for Name: product_status; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.product_status (prd_sts_id, prd_sts_cd, prd_sts_desc) FROM stdin;
1	ACT01	active
2	INA01	inactive
\.


--
-- Data for Name: product_supplier; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.product_supplier  FROM stdin;
\.


--
-- Data for Name: product_tag; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.product_tag (prd_tag_id, prd_id, tag_id) FROM stdin;
25	10	17
26	11	15
27	22	17
30	7	17
31	2	15
32	5	17
34	13	17
35	233275	233269
36	233282	233269
37	233289	233230
38	233296	233230
39	233296	233266
40	233303	233230
41	233310	233230
42	233310	233266
43	233317	233221
44	233324	233230
45	233331	233230
46	233338	233230
47	233345	233230
48	233352	233221
49	233359	233230
50	233366	233230
51	233366	233221
52	233373	233230
53	233373	233221
54	233380	233230
55	233380	233221
56	233387	233230
57	233387	233224
58	233394	233266
59	233401	233230
60	233401	233266
61	233401	233221
62	233408	233251
63	233408	233236
64	233415	233251
65	233415	233236
66	233422	233251
67	233422	233236
68	233429	233251
69	233429	233236
70	233436	233251
71	233436	233236
72	233443	233230
73	233443	233224
74	233450	233230
75	233450	233245
76	233450	233248
77	233450	233239
78	233457	233230
79	233457	233242
80	233464	233230
81	233464	233245
82	233464	233239
83	233471	233245
84	233471	233239
85	233478	233245
86	233478	233239
87	233485	233245
88	233485	233248
89	233485	233239
90	233492	233245
91	233492	233248
92	233492	233239
93	233499	233251
94	233506	233251
95	233513	233251
96	233520	233251
97	233527	233251
98	233534	233251
99	233541	233254
100	233548	233254
101	233555	233254
102	233562	233254
103	233569	233254
104	233576	233257
105	233576	233239
106	233583	233230
107	233583	233260
108	233590	233230
109	233590	233260
110	233597	233248
111	233597	233242
112	233604	233251
113	233611	233251
114	233618	233251
115	233618	233245
116	233625	233251
117	233632	233251
118	233639	233230
119	233639	233221
120	233646	233251
121	233653	233251
122	233660	233251
123	233667	233251
124	233674	233272
125	233681	233272
126	233688	233272
127	233695	233230
128	233695	233251
129	233702	233272
130	233709	233245
131	233709	233272
132	233716	233221
133	233723	233230
134	233730	233272
136	2031888	15
\.


--
-- Data for Name: promotion; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.promotion (prm_id, prm_cd, prm_st_dt, prm_en_dt, prm_mec_id, prm_act, prm_typ_id, prm_lvl_id, prm_dis_id) FROM stdin;
234464	RB2G50	2020-03-07 00:00:00+08	2021-01-31 00:00:00+08	1	t	1	1	1
234467	RB3G33	2020-03-08 00:00:00+08	2021-02-01 00:00:00+08	1	t	1	1	1
2030864	C10PCT	2020-03-07 00:00:00+08	2021-01-31 00:00:00+08	3	t	2	3	2
\.


--
-- Data for Name: promotion_attr_lcl; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.promotion_attr_lcl (prm_lcl_id, prm_id, prm_desc, lcl_cd) FROM stdin;
234465	234464	Buy 1 get 1 free	en-GB
234466	234464	買1送1	zh-HK
234468	234467	買二送一	zh-HK
234469	234467	Buy 2 get 1 free	en-GB
2030865	2030864	10% off total basket	en-GB
2030866	2030864	總籃可享10％的折扣	zh-HK
\.


--
-- Data for Name: promotion_level; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.promotion_level (prm_lvl_id, prm_lvl_cd, prm_lvl_desc) FROM stdin;
1	PRD01	Product
2	CAT01	Category
3	ORD01	Order
\.


--
-- Data for Name: promotion_mechanic; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.promotion_mechanic (prm_mec_id, prm_mec_cd, prm_mec_desc) FROM stdin;
1	BNGNPCT	Buy N Get X Percent Off
2	BNGNF	Buy N Get N Free
3	ORDPCTOFF	Percentage off total order
\.


--
-- Data for Name: promotion_order; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.promotion_order (prm_id, prm_cpn_cd) FROM stdin;
2030864	ABCD1
\.


--
-- Data for Name: promotion_product; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.promotion_product (prm_id) FROM stdin;
234464
234467
\.


--
-- Data for Name: promotion_type; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.promotion_type (prm_typ_id, prm_typ_cd, prm_class, prm_typ_desc) FROM stdin;
1	PRD01	PromotionProductDTO	Product
2	ORD01	PromotionOrderDTO	Order
\.


--
-- Data for Name: rating; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.rating (rat_id, rat_desc, rat_val) FROM stdin;
1	One Star	1
2	Two Star	2
3	Three Star	3
4	Four Star	4
5	Five Star	5
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.role (rle_id, rle_typ_id, rle_start_dt, pty_id) FROM stdin;
1	1	2018-11-15 00:00:00+08	1
232217	1	2018-11-15 00:00:00+08	232216
232221	1	2018-11-15 00:00:00+08	232220
232231	1	2018-11-15 00:00:00+08	232230
232233	1	2018-11-15 00:00:00+08	232232
232235	1	2018-12-01 00:00:00+08	232234
232237	1	2018-12-01 00:00:00+08	232236
232239	1	2018-12-01 00:00:00+08	232238
232241	1	2018-12-01 00:00:00+08	232240
232243	1	2018-12-01 00:00:00+08	232242
232245	1	2018-12-01 00:00:00+08	232244
232247	1	2018-12-01 00:00:00+08	232246
232249	1	2018-12-12 00:00:00+08	232248
232251	1	2018-12-24 00:00:00+08	232250
232253	1	2018-12-24 00:00:00+08	232252
232255	1	2019-04-06 00:00:00+08	232254
232257	1	2019-04-06 00:00:00+08	232256
232259	1	2019-04-06 00:00:00+08	232258
232261	1	2019-04-15 00:00:00+08	232260
232263	1	2019-07-10 00:00:00+08	232262
232305	1	2019-07-11 00:00:00+08	232304
232311	1	2019-07-11 00:00:00+08	232310
232313	1	2019-07-11 00:00:00+08	232312
233017	1	2020-06-11 00:00:00+08	233016
233019	1	2020-06-11 00:00:00+08	233018
233021	1	2020-06-11 00:00:00+08	233020
233023	1	2020-06-11 00:00:00+08	233022
233025	1	2020-06-11 00:00:00+08	233024
233055	1	2020-08-20 00:00:00+08	233054
233056	2	2020-09-28 11:04:23.6741+08	233055
234478	1	2020-12-02 12:06:31.046+08	234477
234483	1	2020-12-02 12:54:34.679+08	234482
234486	1	2022-06-23 16:36:19.382+08	234485
\.


--
-- Data for Name: role_type; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.role_type (rle_typ_id, rle_typ_desc) FROM stdin;
1	Customer
2	Supplier
\.


--
-- Data for Name: stock_on_hand; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.stock_on_hand (soh_id, soh_prd_id, soh_qty) FROM stdin;
234239	11	10
234241	21	10
234243	23	10
234245	25	10
234247	26	10
234249	28	10
234251	30	10
234253	17	10
234255	16	10
234257	14	10
234259	15	10
234261	19	10
234263	20	10
234265	22	10
234267	24	10
234269	27	10
234271	29	10
234273	18	10
234275	233275	10
234277	233282	10
234279	233289	10
234281	233296	10
234283	233303	10
234285	233310	10
234287	233317	10
234289	233324	10
234291	233331	10
234293	233338	10
234295	233345	10
234297	233352	10
234299	233359	10
234301	233366	10
234305	233380	10
234307	233387	10
234309	233394	10
234311	233401	10
234313	233408	10
234315	233415	10
234317	233422	10
234319	233429	10
234321	233436	10
234323	233443	10
234325	233450	10
234327	233457	10
234329	233464	10
234331	233471	10
234333	233478	10
234335	233485	10
234337	233492	10
234339	233499	10
234341	233506	10
234343	233513	10
234345	233520	10
234347	233527	10
234349	233534	10
234351	233541	10
234353	233548	10
234355	233555	10
234357	233562	10
234359	233569	10
234361	233576	10
234363	233583	10
234365	233590	10
234367	233597	10
234369	233604	10
234371	233611	10
234373	233618	10
234375	233625	10
234377	233632	10
234379	233639	10
234381	233646	10
234383	233653	10
234385	233660	10
234387	233667	10
234389	233674	10
234391	233681	10
234393	233688	10
234395	233695	10
234397	233702	10
234399	233709	10
234401	233716	10
234403	233723	10
234405	233730	10
234407	13	10
234409	4	10
234411	7	10
234413	9	10
234415	12	10
234417	1	10
234419	10	10
234421	8	10
234423	6	10
234425	2	10
234427	3	10
234429	5	10
234303	233373	0
\.


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.supplier (rle_id, sup_num) FROM stdin;
233056	1000000002
\.


--
-- Data for Name: tag; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.tag (tag_id, tag_cd) FROM stdin;
15	ORG01
17	GFR01
233218	TAG01
233221	TAG02
233224	TAG03
233227	TAG04
233230	TAG05
233233	TAG06
233236	TAG07
233239	TAG08
233242	TAG09
233245	TAG10
233248	TAG11
233251	TAG12
233254	TAG13
233257	TAG14
233260	TAG15
233263	TAG16
233266	TAG17
233269	TAG18
233272	TAG19
\.


--
-- Data for Name: tag_attr_lcl; Type: TABLE DATA; Schema: mochi; Owner: mochidb_owner
--

COPY mochi.tag_attr_lcl (tag_lcl_id, tag_id, tag_desc, tag_img_pth, lcl_cd) FROM stdin;
2	15	有機	\N	zh-HK
233219	233218	S925	\N	en-GB
233220	233218	S925	\N	zh-HK
233222	233221	FLOWER	\N	en-GB
233223	233221	花	\N	zh-HK
233225	233224	BUNNY 	\N	en-GB
233226	233224	兔仔	\N	zh-HK
233228	233227	STARS	\N	en-GB
233229	233227	星	\N	zh-HK
233231	233230	KOREA	\N	en-GB
233232	233230	韓國	\N	zh-HK
233234	233233	CAT 	\N	en-GB
233235	233233	小貓	\N	zh-HK
233237	233236	CROSSBODY BAG 	\N	en-GB
233238	233236	斜咩袋	\N	zh-HK
233240	233239	SPORTS	\N	en-GB
233241	233239	運動	\N	zh-HK
233243	233242	WHITE	\N	en-GB
233244	233242	白色	\N	zh-HK
233246	233245	UNISEX	\N	en-GB
233247	233245	男女適合	\N	zh-HK
233249	233248	BUMBAG	\N	en-GB
233250	233248	腰包	\N	zh-HK
233252	233251	MUM 	\N	en-GB
233253	233251	靚媽媽	\N	zh-HK
233255	233254	KIDS	\N	en-GB
233256	233254	小童	\N	zh-HK
233258	233257	HOBO BAG	\N	en-GB
233259	233257	水餃包包	\N	zh-HK
233261	233260	HOME	\N	en-GB
233262	233260	家居	\N	zh-HK
233264	233263	PET	\N	en-GB
233265	233263	寵物	\N	zh-HK
233267	233266	HAIR	\N	en-GB
233268	233266	髮飾	\N	zh-HK
233270	233269	PACKAGING	\N	en-GB
233271	233269	 禮品包裝	\N	zh-HK
233273	233272	SKATEBOARD	\N	en-GB
233274	233272	滑板風	\N	zh-HK
1	15	ORGANIC	\N	en-GB
3	17	Gluten Free Test	\N	en-GB
4	17	無麩質測試	\N	zh-HK
\.


--
-- Data for Name: clientdetails; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.clientdetails (appid, resourceids, appsecret, scope, granttypes, redirecturl, authorities, access_token_validity, refresh_token_validity, additionalinformation, autoapprovescopes) FROM stdin;
\.


--
-- Data for Name: device_metadata; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.device_metadata (id, device_details, last_logged_in, location, user_id) FROM stdin;
\.


--
-- Data for Name: new_location_token; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.new_location_token (id, token, user_location_id) FROM stdin;
\.


--
-- Data for Name: oauth_access_token; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.oauth_access_token (token_id, token, authentication_id, user_name, client_id, authentication, refresh_token) FROM stdin;
61ec79cd526ad94ebcd43178b492eb74	\\xaced0005737200436f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f4175746832416363657373546f6b656e0cb29e361b24face0200064c00156164646974696f6e616c496e666f726d6174696f6e74000f4c6a6176612f7574696c2f4d61703b4c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b4c000c72656672657368546f6b656e74003f4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f636f6d6d6f6e2f4f417574683252656672657368546f6b656e3b4c000573636f706574000f4c6a6176612f7574696c2f5365743b4c0009746f6b656e547970657400124c6a6176612f6c616e672f537472696e673b4c000576616c756571007e00057870737200176a6176612e7574696c2e4c696e6b6564486173684d617034c04e5c106cc0fb0200015a000b6163636573734f72646572787200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000d61757468656e74696361746564737200116a6176612e6c616e672e426f6f6c65616ecd207280d59cfaee0200015a000576616c7565787001740015616363657373546f6b656e4578706972794461746574001c323032302d31322d30332032323a32353a35372e3035372b30383030740008757365724e616d65740007626f6240626f6278007372000e6a6176612e7574696c2e44617465686a81014b597419030000787077080000017628fed13a787372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e71007e0002787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c756571007e0005787074002463623931313665392d633239382d346465342d393861362d6561656431326230656330347371007e0011770800000176c36e56f678737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c0001637400164c6a6176612f7574696c2f436f6c6c656374696f6e3b7870737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f400000000000027400047265616474000577726974657874000662656172657274002464396339643737342d396363622d343662392d383361302d363766643162333630353330	35618f744928cf835f93349121d9c3e5	bob@bob	spring-security-oauth2-read-write-client	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000002377040000002373720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000001374000f435553544f4d45525f5550444154457371007e000d7371007e0011000000000000001874000f535550504c4945525f44454c4554457371007e000d7371007e0011000000000000001574000f535550504c4945525f4352454154457371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000001074000b524f4c455f44454c4554457371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000001774000f535550504c4945525f5550444154457371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000000774000d504552534f4e5f5550444154457371007e000d7371007e0011000000000000000874000d504552534f4e5f44454c4554457371007e000d7371007e0011000000000000001474000f435553544f4d45525f44454c4554457371007e000d7371007e0011000000000000001b74000e50524f445543545f5550444154457371007e000d7371007e0011000000000000000b7400134f5247414e49534154494f4e5f5550444154457371007e000d7371007e0011000000000000000474000c50415254595f44454c4554457371007e000d7371007e0011000000000000000574000d504552534f4e5f4352454154457371007e000d7371007e001100000000000000097400134f5247414e49534154494f4e5f4352454154457371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000000174000c50415254595f4352454154457371007e000d7371007e0011000000000000000f74000b524f4c455f5550444154457371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000000d74000b524f4c455f4352454154457371007e000d7371007e0011000000000000001c74000e50524f445543545f44454c4554457371007e000d7371007e0011000000000000000c7400134f5247414e49534154494f4e5f44454c4554457371007e000d7371007e0011000000000000001174000f435553544f4d45525f4352454154457371007e000d7371007e0011000000000000001974000e50524f445543545f4352454154457371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000000374000c50415254595f5550444154457371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e007e787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e007c4c000573636f706571007e007e7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e007c7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d65740007626f6240626f6278737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e008f770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00843f40000000000000770800000010000000007870737200396f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e546f6b656e52657175657374d62a84b8cf38f8010200014c00096772616e745479706571007e000f7871007e007f740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e747371007e00827371007e00843f400000000000037708000000040000000274000d726566726573685f746f6b656e74002465343433646561382d363730652d343835372d616432392d37656639663864363830386374000a6772616e745f7479706574000d726566726573685f746f6b656e787371007e008c7371007e008e770c000000103f400000000000007871007e00a07371007e008f770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e008f770c000000103f40000000000000787372005b6f72672e737072696e676672616d65776f726b2e73656375726974792e7765622e61757468656e7469636174696f6e2e707265617574682e50726541757468656e7469636174656441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000002377040000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787871007e00a9707400007372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e007e4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e00110000000000038e4074003c243261243038243444544b41396167686333674a4d616e307a6a6e32652f55524b53613636374a586c5655727736705337394f7a4273776d3670714b7372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e007e7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e00b2787000ffffffff000001007371007e00110000000000038e4071007e00ad740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00843f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e007e4c00046e616d6571007e000f787071007e004f7371007e00b000ffffffff0000010071007e004f71007e00b8740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00843f400000000000307708000000400000002371007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e003971007e003c71007e003c71007e003f71007e003f71007e004271007e004271007e004571007e004571007e004871007e004871007e004b71007e004b71007e004e71007e004e71007e005171007e005171007e005471007e005471007e005771007e005771007e005a71007e005a71007e005d71007e005d71007e006071007e006071007e006371007e006371007e006671007e006671007e006971007e006971007e006c71007e006c71007e006f71007e006f71007e007271007e007271007e007571007e007571007e007871007e0078787371007e008f770c000000403f4000000000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787874000541646d696e71007e00b8787371007e008f770c000000103f4000000000000171007e00b87870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00c14c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00c24c000f70657273697374656e74436c61737371007e00c17872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00b24c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e00ae7070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e00c874000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e00cb00000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e00c8740007626f6240626f62	f83a2ed468b31b6958ce913f5d84d0ba
449b9e9bbe90ea9d4d725626204fe044	\\xaced0005737200436f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f4175746832416363657373546f6b656e0cb29e361b24face0200064c00156164646974696f6e616c496e666f726d6174696f6e74000f4c6a6176612f7574696c2f4d61703b4c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b4c000c72656672657368546f6b656e74003f4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f636f6d6d6f6e2f4f417574683252656672657368546f6b656e3b4c000573636f706574000f4c6a6176612f7574696c2f5365743b4c0009746f6b656e547970657400124c6a6176612f6c616e672f537472696e673b4c000576616c756571007e00057870737200176a6176612e7574696c2e4c696e6b6564486173684d617034c04e5c106cc0fb0200015a000b6163636573734f72646572787200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000d61757468656e74696361746564737200116a6176612e6c616e672e426f6f6c65616ecd207280d59cfaee0200015a000576616c7565787001740015616363657373546f6b656e4578706972794461746574001c323032302d31322d30332032323a32383a33392e3033392b30383030740008757365724e616d65740007726f6240726f6278007372000e6a6176612e7574696c2e44617465686a81014b597419030000787077080000017629014b3a787372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e71007e0002787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c756571007e0005787074002436613965333364612d646334352d343766372d623263642d3138323730376162343562317371007e0011770800000176c370d0f878737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c0001637400164c6a6176612f7574696c2f436f6c6c656374696f6e3b7870737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f400000000000027400047265616474000577726974657874000662656172657274002434383966343764382d396566642d346165642d393931652d353939346463326235376666	454260bdf9d9a6674ba5224b74e33415	rob@rob	spring-security-oauth2-read-write-client	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000000e77040000000e73720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e003f787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e003d4c000573636f706571007e003f7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e003d7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d65740007726f6240726f6278737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e0050770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00453f40000000000000770800000010000000007870737200396f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e546f6b656e52657175657374d62a84b8cf38f8010200014c00096772616e745479706571007e000f7871007e0040740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e747371007e00437371007e00453f400000000000037708000000040000000274000d726566726573685f746f6b656e74002432393633656433382d316534322d343034662d396461312d31316464653930353764666574000a6772616e745f7479706574000d726566726573685f746f6b656e787371007e004d7371007e004f770c000000103f400000000000007871007e00617371007e0050770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e0050770c000000103f40000000000000787372005b6f72672e737072696e676672616d65776f726b2e73656375726974792e7765622e61757468656e7469636174696f6e2e707265617574682e50726541757468656e7469636174656441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000000e77040000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e00397871007e006a707400007372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e003f4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e001100000000000393ed74003c243261243038246c4d68385a61397064703454552f613071335355536539636a392f424e5a59784a3337756572576e365070395130763072526e49537372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e003f7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e0073787000ffffffff000001007371007e001100000000000393ed71007e006e740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00453f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e003f4c00046e616d6571007e000f787071007e00227371007e007100ffffffff0000010071007e002271007e0079740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00453f400000000000187708000000200000000e71007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e0039787371007e0050770c000000203f4000000000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003978740008437573746f6d657271007e0079787371007e0050770c000000103f4000000000000171007e00797870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00824c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00834c000f70657273697374656e74436c61737371007e00827872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00734c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e006f7070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e008974000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e008c00000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e0089740007726f6240726f62	1606f3c8b654059fd8aff4231a1a9958
447560266730d4d9ba295c4214c536d9	\\xaced0005737200436f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f4175746832416363657373546f6b656e0cb29e361b24face0200064c00156164646974696f6e616c496e666f726d6174696f6e74000f4c6a6176612f7574696c2f4d61703b4c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b4c000c72656672657368546f6b656e74003f4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f636f6d6d6f6e2f4f417574683252656672657368546f6b656e3b4c000573636f706574000f4c6a6176612f7574696c2f5365743b4c0009746f6b656e547970657400124c6a6176612f6c616e672f537472696e673b4c000576616c756571007e00057870737200176a6176612e7574696c2e4c696e6b6564486173684d617034c04e5c106cc0fb0200015a000b6163636573734f72646572787200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000d61757468656e74696361746564737200116a6176612e6c616e672e426f6f6c65616ecd207280d59cfaee0200015a000576616c7565787001740015616363657373546f6b656e4578706972794461746574001c323032312d30312d30322031363a35373a33372e3033372b30383030740008757365724e616d6574000a6164616d406170706c6578007372000e6a6176612e7574696c2e44617465686a81014b5974190300007870770800000176c2510002787372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e71007e0002787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c756571007e0005787074002431353936333861352d353635322d343562352d396132302d3061626436303833666239337371007e00117708000001775cc085c078737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c0001637400164c6a6176612f7574696c2f436f6c6c656374696f6e3b7870737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f400000000000027400047265616474000577726974657874000662656172657274002461623865646331332d303738652d346439652d616637632d336261613237633961333634	9400bc0c9f62052cb0abe347173f2668	adam@apple	spring-security-oauth2-read-write-client	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000002377040000002373720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000000574000d504552534f4e5f4352454154457371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000000874000d504552534f4e5f44454c4554457371007e000d7371007e0011000000000000000174000c50415254595f4352454154457371007e000d7371007e001100000000000000097400134f5247414e49534154494f4e5f4352454154457371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000000c7400134f5247414e49534154494f4e5f44454c4554457371007e000d7371007e0011000000000000001774000f535550504c4945525f5550444154457371007e000d7371007e0011000000000000000774000d504552534f4e5f5550444154457371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000000474000c50415254595f44454c4554457371007e000d7371007e0011000000000000001074000b524f4c455f44454c4554457371007e000d7371007e0011000000000000001474000f435553544f4d45525f44454c4554457371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000001974000e50524f445543545f4352454154457371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e0011000000000000000b7400134f5247414e49534154494f4e5f5550444154457371007e000d7371007e0011000000000000001174000f435553544f4d45525f4352454154457371007e000d7371007e0011000000000000000374000c50415254595f5550444154457371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000000d74000b524f4c455f4352454154457371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000001874000f535550504c4945525f44454c4554457371007e000d7371007e0011000000000000001574000f535550504c4945525f4352454154457371007e000d7371007e0011000000000000001c74000e50524f445543545f44454c4554457371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447371007e000d7371007e0011000000000000000f74000b524f4c455f5550444154457371007e000d7371007e0011000000000000001374000f435553544f4d45525f5550444154457371007e000d7371007e0011000000000000001b74000e50524f445543545f5550444154457371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e007e787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e007c4c000573636f706571007e007e7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e007c7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d6574000a6164616d406170706c6578737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e008f770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00843f40000000000000770800000010000000007870707371007e008f770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e008f770c000000103f40000000000000787372004f6f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e557365726e616d6550617373776f726441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000002377040000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787871007e009e737200176a6176612e7574696c2e4c696e6b6564486173684d617034c04e5c106cc0fb0200015a000b6163636573734f726465727871007e00843f400000000000067708000000080000000371007e008671007e008771007e008871007e008971007e008a71007e008b7800707372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e007e4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e00110000000000038e3874003c24326124303824726f674d4d642f764a35366130386c714f6c7a4172756a6951524e312e3261767a43514c74444f514238516358596f73366d7873797372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e007e7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e00a8787000ffffffff000001007371007e00110000000000038e3871007e00a3740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00843f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e007e4c00046e616d6571007e000f787071007e001c7371007e00a600ffffffff0000010071007e001c71007e00ae740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00843f400000000000307708000000400000002371007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e003971007e003c71007e003c71007e003f71007e003f71007e004271007e004271007e004571007e004571007e004871007e004871007e004b71007e004b71007e004e71007e004e71007e005171007e005171007e005471007e005471007e005771007e005771007e005a71007e005a71007e005d71007e005d71007e006071007e006071007e006371007e006371007e006671007e006671007e006971007e006971007e006c71007e006c71007e006f71007e006f71007e007271007e007271007e007571007e007571007e007871007e0078787371007e008f770c000000403f4000000000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787874000541646d696e71007e00ae787371007e008f770c000000103f4000000000000171007e00ae7870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00b74c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00b84c000f70657273697374656e74436c61737371007e00b77872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00a84c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e00a47070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e00be74000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e00c100000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e00be74000a6164616d406170706c65	1587352c0f5a2bee4b394e65482fb907
2c346a05c5047bc740c713c830a8852f	\\xaced0005737200436f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f4175746832416363657373546f6b656e0cb29e361b24face0200064c00156164646974696f6e616c496e666f726d6174696f6e74000f4c6a6176612f7574696c2f4d61703b4c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b4c000c72656672657368546f6b656e74003f4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f636f6d6d6f6e2f4f417574683252656672657368546f6b656e3b4c000573636f706574000f4c6a6176612f7574696c2f5365743b4c0009746f6b656e547970657400124c6a6176612f6c616e672f537472696e673b4c000576616c756571007e00057870737200176a6176612e7574696c2e4c696e6b6564486173684d617034c04e5c106cc0fb0200015a000b6163636573734f72646572787200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000d61757468656e74696361746564737200116a6176612e6c616e672e426f6f6c65616ecd207280d59cfaee0200015a000576616c7565787001740015616363657373546f6b656e4578706972794461746574001c323032322d30362d32342031383a30343a35392e3035392b30383030740008757365724e616d657400076e6f62406e6f6278007372000e6a6176612e7574696c2e44617465686a81014b5974190300007870770800000181952c0693787372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e71007e0002787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c756571007e0005787074002435336633333330372d393635612d346461642d616532302d3439303638626230306263657371007e00117708000001822f9b8c4f78737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c0001637400164c6a6176612f7574696c2f436f6c6c656374696f6e3b7870737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f400000000000027400047265616474000577726974657874000662656172657274002434656165333735632d373833322d343636372d383165322d666164353239643234303063	1f9aa19161c25177ef2bd864a23fa09d	nob@nob	spring-security-oauth2-read-write-client	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000000e77040000000e73720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e003f787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e003d4c000573636f706571007e003f7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e003d7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d657400076e6f62406e6f6278737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e0050770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002300200014c0004726f6c6571007e000f787074000455534552787371007e00453f40000000000000770800000010000000007870737200396f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e546f6b656e52657175657374d62a84b8cf38f8010200014c00096772616e745479706571007e000f7871007e0040740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e747371007e00437371007e00453f400000000000037708000000040000000274000d726566726573685f746f6b656e74002462376662363134622d306465302d343938352d396230332d66666363636339626363366374000a6772616e745f7479706574000d726566726573685f746f6b656e787371007e004d7371007e004f770c000000103f400000000000007871007e00617371007e0050770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e0050770c000000103f40000000000000787372005b6f72672e737072696e676672616d65776f726b2e73656375726974792e7765622e61757468656e7469636174696f6e2e707265617574682e50726541757468656e7469636174656441757468656e7469636174696f6e546f6b656e00000000000002300200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000000e77040000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e00397871007e006a707400007372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e003f4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e001100000000000393f274003c243261243038245144516655457a56746b61494c425248646b5655717542712f796c4c71532e44455366694e417657304e31316d773261316b6e304b7372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e003f7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e0073787000ffffffff000001007371007e001100000000000393f271007e006e740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00453f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e003f4c00046e616d6571007e000f787071007e001c7371007e007100ffffffff0000010071007e001c71007e0079740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00453f400000000000187708000000200000000e71007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e0039787371007e0050770c000000203f4000000000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003978740008437573746f6d657271007e0079787371007e0050770c000000103f4000000000000171007e00797870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00824c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00834c000f70657273697374656e74436c61737371007e00827872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00734c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e006f7070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e008974000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e008c00000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e00897400076e6f62406e6f62	3c36f6d3ddbfc8b3cc1c57807190b8a2
\.


--
-- Data for Name: oauth_approvals; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.oauth_approvals (userid, clientid, scope, status, expiresat, lastmodifiedat) FROM stdin;
\.


--
-- Data for Name: oauth_client_details; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.oauth_client_details (client_id, resource_ids, client_secret, scope, authorized_grant_types, web_server_redirect_uri, authorities, access_token_validity, refresh_token_validity, additional_information, autoapprove) FROM stdin;
spring-security-oauth2-read-client	resource-server-rest-api	$2a$04$WGq2P9egiOYoOFemBRfsiO9qTcyJtNRnPKNBl5tokP7IP.eZn93km	read	password,authorization_code,refresh_token,implicit	\N	USER	10800	2592000	\N	\N
spring-security-oauth2-read-write-client	resource-server-rest-api	$2a$04$soeOR.QFmClXeFIrhJVLWOQxfHjsJLSpWrU1iGxcMGdu.a5hvfY4W	read,write	password,authorization_code,refresh_token,implicit	\N	USER	10800	2592000	\N	\N
client		\N					30	\N	{}	
my-client-with-password	oauth2-resource	\N	read	password		ROLE_CLIENT	30	\N	{}	
\.


--
-- Data for Name: oauth_client_token; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.oauth_client_token (token_id, token, authentication_id, user_name, client_id) FROM stdin;
\.


--
-- Data for Name: oauth_code; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.oauth_code (code, authentication) FROM stdin;
\.


--
-- Data for Name: oauth_refresh_token; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.oauth_refresh_token (token_id, token, authentication) FROM stdin;
4ab10d0fc3f84463964f866843c296af	\\xaced00057372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c75657400124c6a6176612f6c616e672f537472696e673b787074002439313065313465642d333038322d346230372d616134332d3461636630623239626365337372000e6a6176612e7574696c2e44617465686a81014b59741903000078707708000001746b946b2278	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000002377040000002373720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000000574000d504552534f4e5f4352454154457371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447371007e000d7371007e0011000000000000000774000d504552534f4e5f5550444154457371007e000d7371007e0011000000000000000874000d504552534f4e5f44454c4554457371007e000d7371007e001100000000000000097400134f5247414e49534154494f4e5f4352454154457371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000000b7400134f5247414e49534154494f4e5f5550444154457371007e000d7371007e0011000000000000000c7400134f5247414e49534154494f4e5f44454c4554457371007e000d7371007e0011000000000000000d74000b524f4c455f4352454154457371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000000f74000b524f4c455f5550444154457371007e000d7371007e0011000000000000001074000b524f4c455f44454c4554457371007e000d7371007e0011000000000000001174000f435553544f4d45525f4352454154457371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000001374000f435553544f4d45525f5550444154457371007e000d7371007e0011000000000000001474000f435553544f4d45525f44454c4554457371007e000d7371007e0011000000000000001574000f535550504c4945525f4352454154457371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000001774000f535550504c4945525f5550444154457371007e000d7371007e0011000000000000001874000f535550504c4945525f44454c4554457371007e000d7371007e0011000000000000001974000e50524f445543545f4352454154457371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e0011000000000000001b74000e50524f445543545f5550444154457371007e000d7371007e0011000000000000001c74000e50524f445543545f44454c4554457371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000000174000c50415254595f4352454154457371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000000374000c50415254595f5550444154457371007e000d7371007e0011000000000000000474000c50415254595f44454c4554457871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e007e787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e007c4c000573636f706571007e007e7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e007c7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d65740007626f6240626f6278737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e008f770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00843f40000000000000770800000010000000007870737200396f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e546f6b656e52657175657374d62a84b8cf38f8010200014c00096772616e745479706571007e000f7871007e007f740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e747371007e00827371007e00843f400000000000037708000000040000000274000d726566726573685f746f6b656e74002465373165323635332d353464392d346239322d393939302d66316431656164636539353374000a6772616e745f7479706574000d726566726573685f746f6b656e787371007e008c7371007e008e770c000000103f400000000000007871007e00a07371007e008f770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e008f770c000000103f40000000000000787372005b6f72672e737072696e676672616d65776f726b2e73656375726974792e7765622e61757468656e7469636174696f6e2e707265617574682e50726541757468656e7469636174656441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000002377040000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787871007e00a9707400007372001b696f2e6e7a6265652e73656375726974792e757365722e5573657200000000000000010200095a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65644c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e007e4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f7870000000017371007e00110000000000038e4074003c243261243038243444544b41396167686333674a4d616e307a6a6e32652f55524b53613636374a586c5655727736705337394f7a4273776d3670714b7372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e007e7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e00b2787000ffffffff000001007371007e00110000000000038e4071007e00ad740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00843f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e007e4c00046e616d6571007e000f787071007e00707371007e00b000ffffffff0000010071007e007071007e00b8740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00843f400000000000307708000000400000002371007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e003971007e003c71007e003c71007e003f71007e003f71007e004271007e004271007e004571007e004571007e004871007e004871007e004b71007e004b71007e004e71007e004e71007e005171007e005171007e005471007e005471007e005771007e005771007e005a71007e005a71007e005d71007e005d71007e006071007e006071007e006371007e006371007e006671007e006671007e006971007e006971007e006c71007e006c71007e006f71007e006f71007e007271007e007271007e007571007e007571007e007871007e0078787371007e008f770c000000403f4000000000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787874000541646d696e71007e00b8787371007e008f770c000000103f4000000000000171007e00b878737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00c14c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00c24c000f70657273697374656e74436c61737371007e00c17872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00b24c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e00ae7070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e00c874000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e00cb00000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e00c8740007626f6240626f62
4314a36265d8ea027ca8886be3f8e357	\\xaced00057372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c75657400124c6a6176612f6c616e672f537472696e673b787074002431306234316238352d366230372d343936632d613664302d3166346434646636386238357372000e6a6176612e7574696c2e44617465686a81014b59741903000078707708000001746c1e9c2078	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000002377040000002373720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000001074000b524f4c455f44454c4554457371007e000d7371007e0011000000000000001c74000e50524f445543545f44454c4554457371007e000d7371007e0011000000000000001574000f535550504c4945525f4352454154457371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e0011000000000000000374000c50415254595f5550444154457371007e000d7371007e0011000000000000001474000f435553544f4d45525f44454c4554457371007e000d7371007e0011000000000000001b74000e50524f445543545f5550444154457371007e000d7371007e0011000000000000001374000f435553544f4d45525f5550444154457371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000000474000c50415254595f44454c4554457371007e000d7371007e001100000000000000097400134f5247414e49534154494f4e5f4352454154457371007e000d7371007e0011000000000000001174000f435553544f4d45525f4352454154457371007e000d7371007e0011000000000000001774000f535550504c4945525f5550444154457371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000000574000d504552534f4e5f4352454154457371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000000174000c50415254595f4352454154457371007e000d7371007e0011000000000000000874000d504552534f4e5f44454c4554457371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447371007e000d7371007e0011000000000000001874000f535550504c4945525f44454c4554457371007e000d7371007e0011000000000000000774000d504552534f4e5f5550444154457371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000000d74000b524f4c455f4352454154457371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000000b7400134f5247414e49534154494f4e5f5550444154457371007e000d7371007e0011000000000000001974000e50524f445543545f4352454154457371007e000d7371007e0011000000000000000c7400134f5247414e49534154494f4e5f44454c4554457371007e000d7371007e0011000000000000000f74000b524f4c455f5550444154457371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e007e787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e007c4c000573636f706571007e007e7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e007c7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d6574000a6164616d406170706c6578737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e008f770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00843f40000000000000770800000010000000007870707371007e008f770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e008f770c000000103f40000000000000787372004f6f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e557365726e616d6550617373776f726441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000002377040000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787871007e009e737200176a6176612e7574696c2e4c696e6b6564486173684d617034c04e5c106cc0fb0200015a000b6163636573734f726465727871007e00843f400000000000067708000000080000000371007e008671007e008771007e008871007e008971007e008a71007e008b7800707372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e007e4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e00110000000000038e3874003c24326124303824726f674d4d642f764a35366130386c714f6c7a4172756a6951524e312e3261767a43514c74444f514238516358596f73366d7873797372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e007e7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e00a8787000ffffffff000001007371007e00110000000000038e3871007e00a3740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00843f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e007e4c00046e616d6571007e000f787071007e004f7371007e00a600ffffffff0000010071007e004f71007e00ae740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00843f400000000000307708000000400000002371007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e003971007e003c71007e003c71007e003f71007e003f71007e004271007e004271007e004571007e004571007e004871007e004871007e004b71007e004b71007e004e71007e004e71007e005171007e005171007e005471007e005471007e005771007e005771007e005a71007e005a71007e005d71007e005d71007e006071007e006071007e006371007e006371007e006671007e006671007e006971007e006971007e006c71007e006c71007e006f71007e006f71007e007271007e007271007e007571007e007571007e007871007e0078787371007e008f770c000000403f4000000000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787874000541646d696e71007e00ae787371007e008f770c000000103f4000000000000171007e00ae7870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00b74c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00b84c000f70657273697374656e74436c61737371007e00b77872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00a84c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e00a47070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e00be74000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e00c100000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e00be74000a6164616d406170706c65
e8e46fa2ecea44f09503ba132ddfc01b	\\xaced00057372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c75657400124c6a6176612f6c616e672f537472696e673b787074002465623838666239382d333264662d346234392d613634352d6661353437333962643534317372000e6a6176612e7574696c2e44617465686a81014b59741903000078707708000001754b993ed278	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000002377040000002373720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000001974000e50524f445543545f4352454154457371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000001374000f435553544f4d45525f5550444154457371007e000d7371007e0011000000000000001474000f435553544f4d45525f44454c4554457371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000000874000d504552534f4e5f44454c4554457371007e000d7371007e0011000000000000001074000b524f4c455f44454c4554457371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000001874000f535550504c4945525f44454c4554457371007e000d7371007e0011000000000000000774000d504552534f4e5f5550444154457371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000001174000f435553544f4d45525f4352454154457371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000001c74000e50524f445543545f44454c4554457371007e000d7371007e0011000000000000001b74000e50524f445543545f5550444154457371007e000d7371007e0011000000000000000374000c50415254595f5550444154457371007e000d7371007e0011000000000000000c7400134f5247414e49534154494f4e5f44454c4554457371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000000b7400134f5247414e49534154494f4e5f5550444154457371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447371007e000d7371007e0011000000000000000d74000b524f4c455f4352454154457371007e000d7371007e0011000000000000001574000f535550504c4945525f4352454154457371007e000d7371007e0011000000000000000174000c50415254595f4352454154457371007e000d7371007e0011000000000000000f74000b524f4c455f5550444154457371007e000d7371007e0011000000000000001774000f535550504c4945525f5550444154457371007e000d7371007e001100000000000000097400134f5247414e49534154494f4e5f4352454154457371007e000d7371007e0011000000000000000474000c50415254595f44454c4554457371007e000d7371007e0011000000000000000574000d504552534f4e5f4352454154457871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e007e787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e007c4c000573636f706571007e007e7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e007c7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d65740007626f6240626f6278737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e008f770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00843f40000000000000770800000010000000007870737200396f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e546f6b656e52657175657374d62a84b8cf38f8010200014c00096772616e745479706571007e000f7871007e007f740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e747371007e00827371007e00843f400000000000037708000000040000000274000d726566726573685f746f6b656e74002431356436313538312d653031642d343165312d623138352d66666538383432356230626574000a6772616e745f7479706574000d726566726573685f746f6b656e787371007e008c7371007e008e770c000000103f400000000000007871007e00a07371007e008f770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e008f770c000000103f40000000000000787372005b6f72672e737072696e676672616d65776f726b2e73656375726974792e7765622e61757468656e7469636174696f6e2e707265617574682e50726541757468656e7469636174656441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000002377040000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787871007e00a9707400007372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e007e4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e00110000000000038e4074003c243261243038243444544b41396167686333674a4d616e307a6a6e32652f55524b53613636374a586c5655727736705337394f7a4273776d3670714b7372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e007e7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e00b2787000ffffffff000001007371007e00110000000000038e4071007e00ad740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00843f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e007e4c00046e616d6571007e000f787071007e006a7371007e00b000ffffffff0000010071007e006a71007e00b8740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00843f400000000000307708000000400000002371007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e003971007e003c71007e003c71007e003f71007e003f71007e004271007e004271007e004571007e004571007e004871007e004871007e004b71007e004b71007e004e71007e004e71007e005171007e005171007e005471007e005471007e005771007e005771007e005a71007e005a71007e005d71007e005d71007e006071007e006071007e006371007e006371007e006671007e006671007e006971007e006971007e006c71007e006c71007e006f71007e006f71007e007271007e007271007e007571007e007571007e007871007e0078787371007e008f770c000000403f4000000000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787874000541646d696e71007e00b8787371007e008f770c000000103f4000000000000171007e00b87870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00c14c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00c24c000f70657273697374656e74436c61737371007e00c17872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00b24c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e00ae7070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e00c874000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e00cb00000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e00c8740007626f6240626f62
40a151585cc7afff539a14f60d699ecb	\\xaced00057372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c75657400124c6a6176612f6c616e672f537472696e673b787074002438353137393064302d616564322d346235612d626235652d6130643965313332623539387372000e6a6176612e7574696c2e44617465686a81014b5974190300007870770800000174cf41c35d78	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000002377040000002373720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000000774000d504552534f4e5f5550444154457371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000000b7400134f5247414e49534154494f4e5f5550444154457371007e000d7371007e0011000000000000001374000f435553544f4d45525f5550444154457371007e000d7371007e0011000000000000000474000c50415254595f44454c4554457371007e000d7371007e0011000000000000000874000d504552534f4e5f44454c4554457371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000001874000f535550504c4945525f44454c4554457371007e000d7371007e0011000000000000000f74000b524f4c455f5550444154457371007e000d7371007e0011000000000000001574000f535550504c4945525f4352454154457371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447371007e000d7371007e0011000000000000001074000b524f4c455f44454c4554457371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000000574000d504552534f4e5f4352454154457371007e000d7371007e0011000000000000001974000e50524f445543545f4352454154457371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000000374000c50415254595f5550444154457371007e000d7371007e001100000000000000097400134f5247414e49534154494f4e5f4352454154457371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e0011000000000000001b74000e50524f445543545f5550444154457371007e000d7371007e0011000000000000000174000c50415254595f4352454154457371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e0011000000000000001474000f435553544f4d45525f44454c4554457371007e000d7371007e0011000000000000001774000f535550504c4945525f5550444154457371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000000d74000b524f4c455f4352454154457371007e000d7371007e0011000000000000001174000f435553544f4d45525f4352454154457371007e000d7371007e0011000000000000000c7400134f5247414e49534154494f4e5f44454c4554457371007e000d7371007e0011000000000000001c74000e50524f445543545f44454c4554457871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e007e787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e007c4c000573636f706571007e007e7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e007c7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d6574000a6164616d406170706c6578737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e008f770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00843f40000000000000770800000010000000007870707371007e008f770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e008f770c000000103f40000000000000787372004f6f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e557365726e616d6550617373776f726441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000002377040000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787871007e009e737200176a6176612e7574696c2e4c696e6b6564486173684d617034c04e5c106cc0fb0200015a000b6163636573734f726465727871007e00843f400000000000067708000000080000000371007e008671007e008771007e008871007e008971007e008a71007e008b7800707372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e007e4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e00110000000000038e3874003c24326124303824726f674d4d642f764a35366130386c714f6c7a4172756a6951524e312e3261767a43514c74444f514238516358596f73366d7873797372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e007e7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e00a8787000ffffffff000001007371007e00110000000000038e3871007e00a3740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00843f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e007e4c00046e616d6571007e000f787071007e005e7371007e00a600ffffffff0000010071007e005e71007e00ae740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00843f400000000000307708000000400000002371007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e003971007e003c71007e003c71007e003f71007e003f71007e004271007e004271007e004571007e004571007e004871007e004871007e004b71007e004b71007e004e71007e004e71007e005171007e005171007e005471007e005471007e005771007e005771007e005a71007e005a71007e005d71007e005d71007e006071007e006071007e006371007e006371007e006671007e006671007e006971007e006971007e006c71007e006c71007e006f71007e006f71007e007271007e007271007e007571007e007571007e007871007e0078787371007e008f770c000000403f4000000000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787874000541646d696e71007e00ae787371007e008f770c000000103f4000000000000171007e00ae7870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00b74c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00b84c000f70657273697374656e74436c61737371007e00b77872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00a84c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e00a47070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e00be74000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e00c100000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e00be74000a6164616d406170706c65
98f9fbbeb0b8a6b95f09c4814fbaa64f	\\xaced00057372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c75657400124c6a6176612f6c616e672f537472696e673b787074002464323965373864632d306138622d346532622d383634322d6266386163346334663935617372000e6a6176612e7574696c2e44617465686a81014b59741903000078707708000001755fb0d6a778	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000002377040000002373720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000001774000f535550504c4945525f5550444154457371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447371007e000d7371007e0011000000000000001374000f435553544f4d45525f5550444154457371007e000d7371007e0011000000000000001b74000e50524f445543545f5550444154457371007e000d7371007e0011000000000000001874000f535550504c4945525f44454c4554457371007e000d7371007e0011000000000000001974000e50524f445543545f4352454154457371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000000b7400134f5247414e49534154494f4e5f5550444154457371007e000d7371007e0011000000000000001574000f535550504c4945525f4352454154457371007e000d7371007e0011000000000000000474000c50415254595f44454c4554457371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000001474000f435553544f4d45525f44454c4554457371007e000d7371007e0011000000000000000174000c50415254595f4352454154457371007e000d7371007e0011000000000000000774000d504552534f4e5f5550444154457371007e000d7371007e001100000000000000097400134f5247414e49534154494f4e5f4352454154457371007e000d7371007e0011000000000000000d74000b524f4c455f4352454154457371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000000574000d504552534f4e5f4352454154457371007e000d7371007e0011000000000000000f74000b524f4c455f5550444154457371007e000d7371007e0011000000000000001c74000e50524f445543545f44454c4554457371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e0011000000000000000c7400134f5247414e49534154494f4e5f44454c4554457371007e000d7371007e0011000000000000000374000c50415254595f5550444154457371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000001174000f435553544f4d45525f4352454154457371007e000d7371007e0011000000000000000874000d504552534f4e5f44454c4554457371007e000d7371007e0011000000000000001074000b524f4c455f44454c4554457371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e007e787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e007c4c000573636f706571007e007e7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e007c7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d6574000a6164616d406170706c6578737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e008f770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00843f40000000000000770800000010000000007870707371007e008f770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e008f770c000000103f40000000000000787372004f6f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e557365726e616d6550617373776f726441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000002377040000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787871007e009e737200176a6176612e7574696c2e4c696e6b6564486173684d617034c04e5c106cc0fb0200015a000b6163636573734f726465727871007e00843f400000000000067708000000080000000371007e008671007e008771007e008871007e008971007e008a71007e008b7800707372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e007e4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e00110000000000038e3874003c24326124303824726f674d4d642f764a35366130386c714f6c7a4172756a6951524e312e3261767a43514c74444f514238516358596f73366d7873797372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e007e7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e00a8787000ffffffff000001007371007e00110000000000038e3871007e00a3740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00843f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e007e4c00046e616d6571007e000f787071007e00377371007e00a600ffffffff0000010071007e003771007e00ae740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00843f400000000000307708000000400000002371007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e003971007e003c71007e003c71007e003f71007e003f71007e004271007e004271007e004571007e004571007e004871007e004871007e004b71007e004b71007e004e71007e004e71007e005171007e005171007e005471007e005471007e005771007e005771007e005a71007e005a71007e005d71007e005d71007e006071007e006071007e006371007e006371007e006671007e006671007e006971007e006971007e006c71007e006c71007e006f71007e006f71007e007271007e007271007e007571007e007571007e007871007e0078787371007e008f770c000000403f4000000000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787874000541646d696e71007e00ae787371007e008f770c000000103f4000000000000171007e00ae7870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00b74c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00b84c000f70657273697374656e74436c61737371007e00b77872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00a84c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e00a47070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e00be74000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e00c100000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e00be74000a6164616d406170706c65
d5de54861a7506fe30637353f0165461	\\xaced00057372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c75657400124c6a6176612f6c616e672f537472696e673b787074002466646664383736302d623064302d346338362d386338392d3635646662383631663038307372000e6a6176612e7574696c2e44617465686a81014b59741903000078707708000001755fc0863a78	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000002377040000002373720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000000c7400134f5247414e49534154494f4e5f44454c4554457371007e000d7371007e0011000000000000001374000f435553544f4d45525f5550444154457371007e000d7371007e0011000000000000001874000f535550504c4945525f44454c4554457371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000000174000c50415254595f4352454154457371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000001574000f535550504c4945525f4352454154457371007e000d7371007e0011000000000000000474000c50415254595f44454c4554457371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000001174000f435553544f4d45525f4352454154457371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000000d74000b524f4c455f4352454154457371007e000d7371007e0011000000000000000f74000b524f4c455f5550444154457371007e000d7371007e001100000000000000097400134f5247414e49534154494f4e5f4352454154457371007e000d7371007e0011000000000000000574000d504552534f4e5f4352454154457371007e000d7371007e0011000000000000001b74000e50524f445543545f5550444154457371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e0011000000000000001c74000e50524f445543545f44454c4554457371007e000d7371007e0011000000000000000374000c50415254595f5550444154457371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000000774000d504552534f4e5f5550444154457371007e000d7371007e0011000000000000001974000e50524f445543545f4352454154457371007e000d7371007e0011000000000000000b7400134f5247414e49534154494f4e5f5550444154457371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000001774000f535550504c4945525f5550444154457371007e000d7371007e0011000000000000001074000b524f4c455f44454c4554457371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000000874000d504552534f4e5f44454c4554457371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e0011000000000000001474000f435553544f4d45525f44454c4554457871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e007e787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e007c4c000573636f706571007e007e7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e007c7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d6574000a6164616d406170706c6578737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e008f770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00843f40000000000000770800000010000000007870707371007e008f770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e008f770c000000103f40000000000000787372004f6f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e557365726e616d6550617373776f726441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000002377040000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787871007e009e737200176a6176612e7574696c2e4c696e6b6564486173684d617034c04e5c106cc0fb0200015a000b6163636573734f726465727871007e00843f400000000000067708000000080000000371007e008671007e008771007e008871007e008971007e008a71007e008b7800707372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e007e4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e00110000000000038e3874003c24326124303824726f674d4d642f764a35366130386c714f6c7a4172756a6951524e312e3261767a43514c74444f514238516358596f73366d7873797372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e007e7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e00a8787000ffffffff000001007371007e00110000000000038e3871007e00a3740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00843f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e007e4c00046e616d6571007e000f787071007e001f7371007e00a600ffffffff0000010071007e001f71007e00ae740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00843f400000000000307708000000400000002371007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e003971007e003c71007e003c71007e003f71007e003f71007e004271007e004271007e004571007e004571007e004871007e004871007e004b71007e004b71007e004e71007e004e71007e005171007e005171007e005471007e005471007e005771007e005771007e005a71007e005a71007e005d71007e005d71007e006071007e006071007e006371007e006371007e006671007e006671007e006971007e006971007e006c71007e006c71007e006f71007e006f71007e007271007e007271007e007571007e007571007e007871007e0078787371007e008f770c000000403f4000000000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787874000541646d696e71007e00ae787371007e008f770c000000103f4000000000000171007e00ae7870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00b74c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00b84c000f70657273697374656e74436c61737371007e00b77872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00a84c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e00a47070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e00be74000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e00c100000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e00be74000a6164616d406170706c65
f83a2ed468b31b6958ce913f5d84d0ba	\\xaced00057372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c75657400124c6a6176612f6c616e672f537472696e673b787074002463623931313665392d633239382d346465342d393861362d6561656431326230656330347372000e6a6176612e7574696c2e44617465686a81014b5974190300007870770800000176c36e56f678	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000002377040000002373720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000001374000f435553544f4d45525f5550444154457371007e000d7371007e0011000000000000001874000f535550504c4945525f44454c4554457371007e000d7371007e0011000000000000001574000f535550504c4945525f4352454154457371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000001074000b524f4c455f44454c4554457371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000001774000f535550504c4945525f5550444154457371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000000774000d504552534f4e5f5550444154457371007e000d7371007e0011000000000000000874000d504552534f4e5f44454c4554457371007e000d7371007e0011000000000000001474000f435553544f4d45525f44454c4554457371007e000d7371007e0011000000000000001b74000e50524f445543545f5550444154457371007e000d7371007e0011000000000000000b7400134f5247414e49534154494f4e5f5550444154457371007e000d7371007e0011000000000000000474000c50415254595f44454c4554457371007e000d7371007e0011000000000000000574000d504552534f4e5f4352454154457371007e000d7371007e001100000000000000097400134f5247414e49534154494f4e5f4352454154457371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000000174000c50415254595f4352454154457371007e000d7371007e0011000000000000000f74000b524f4c455f5550444154457371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000000d74000b524f4c455f4352454154457371007e000d7371007e0011000000000000001c74000e50524f445543545f44454c4554457371007e000d7371007e0011000000000000000c7400134f5247414e49534154494f4e5f44454c4554457371007e000d7371007e0011000000000000001174000f435553544f4d45525f4352454154457371007e000d7371007e0011000000000000001974000e50524f445543545f4352454154457371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000000374000c50415254595f5550444154457371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e007e787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e007c4c000573636f706571007e007e7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e007c7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d65740007626f6240626f6278737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e008f770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00843f40000000000000770800000010000000007870737200396f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e546f6b656e52657175657374d62a84b8cf38f8010200014c00096772616e745479706571007e000f7871007e007f740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e747371007e00827371007e00843f400000000000037708000000040000000274000d726566726573685f746f6b656e74002465343433646561382d363730652d343835372d616432392d37656639663864363830386374000a6772616e745f7479706574000d726566726573685f746f6b656e787371007e008c7371007e008e770c000000103f400000000000007871007e00a07371007e008f770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e008f770c000000103f40000000000000787372005b6f72672e737072696e676672616d65776f726b2e73656375726974792e7765622e61757468656e7469636174696f6e2e707265617574682e50726541757468656e7469636174656441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000002377040000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787871007e00a9707400007372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e007e4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e00110000000000038e4074003c243261243038243444544b41396167686333674a4d616e307a6a6e32652f55524b53613636374a586c5655727736705337394f7a4273776d3670714b7372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e007e7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e00b2787000ffffffff000001007371007e00110000000000038e4071007e00ad740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00843f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e007e4c00046e616d6571007e000f787071007e004f7371007e00b000ffffffff0000010071007e004f71007e00b8740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00843f400000000000307708000000400000002371007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e003971007e003c71007e003c71007e003f71007e003f71007e004271007e004271007e004571007e004571007e004871007e004871007e004b71007e004b71007e004e71007e004e71007e005171007e005171007e005471007e005471007e005771007e005771007e005a71007e005a71007e005d71007e005d71007e006071007e006071007e006371007e006371007e006671007e006671007e006971007e006971007e006c71007e006c71007e006f71007e006f71007e007271007e007271007e007571007e007571007e007871007e0078787371007e008f770c000000403f4000000000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787874000541646d696e71007e00b8787371007e008f770c000000103f4000000000000171007e00b87870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00c14c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00c24c000f70657273697374656e74436c61737371007e00c17872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00b24c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e00ae7070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e00c874000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e00cb00000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e00c8740007626f6240626f62
1606f3c8b654059fd8aff4231a1a9958	\\xaced00057372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c75657400124c6a6176612f6c616e672f537472696e673b787074002436613965333364612d646334352d343766372d623263642d3138323730376162343562317372000e6a6176612e7574696c2e44617465686a81014b5974190300007870770800000176c370d0f878	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000000e77040000000e73720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e003f787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e003d4c000573636f706571007e003f7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e003d7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d65740007726f6240726f6278737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e0050770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00453f40000000000000770800000010000000007870737200396f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e546f6b656e52657175657374d62a84b8cf38f8010200014c00096772616e745479706571007e000f7871007e0040740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e747371007e00437371007e00453f400000000000037708000000040000000274000d726566726573685f746f6b656e74002432393633656433382d316534322d343034662d396461312d31316464653930353764666574000a6772616e745f7479706574000d726566726573685f746f6b656e787371007e004d7371007e004f770c000000103f400000000000007871007e00617371007e0050770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e0050770c000000103f40000000000000787372005b6f72672e737072696e676672616d65776f726b2e73656375726974792e7765622e61757468656e7469636174696f6e2e707265617574682e50726541757468656e7469636174656441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000000e77040000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e00397871007e006a707400007372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e003f4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e001100000000000393ed74003c243261243038246c4d68385a61397064703454552f613071335355536539636a392f424e5a59784a3337756572576e365070395130763072526e49537372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e003f7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e0073787000ffffffff000001007371007e001100000000000393ed71007e006e740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00453f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e003f4c00046e616d6571007e000f787071007e00227371007e007100ffffffff0000010071007e002271007e0079740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00453f400000000000187708000000200000000e71007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e0039787371007e0050770c000000203f4000000000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003978740008437573746f6d657271007e0079787371007e0050770c000000103f4000000000000171007e00797870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00824c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00834c000f70657273697374656e74436c61737371007e00827872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00734c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e006f7070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e008974000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e008c00000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e0089740007726f6240726f62
1587352c0f5a2bee4b394e65482fb907	\\xaced00057372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c75657400124c6a6176612f6c616e672f537472696e673b787074002431353936333861352d353635322d343562352d396132302d3061626436303833666239337372000e6a6176612e7574696c2e44617465686a81014b59741903000078707708000001775cc085c078	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000002377040000002373720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000000574000d504552534f4e5f4352454154457371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000000874000d504552534f4e5f44454c4554457371007e000d7371007e0011000000000000000174000c50415254595f4352454154457371007e000d7371007e001100000000000000097400134f5247414e49534154494f4e5f4352454154457371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000000c7400134f5247414e49534154494f4e5f44454c4554457371007e000d7371007e0011000000000000001774000f535550504c4945525f5550444154457371007e000d7371007e0011000000000000000774000d504552534f4e5f5550444154457371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000000474000c50415254595f44454c4554457371007e000d7371007e0011000000000000001074000b524f4c455f44454c4554457371007e000d7371007e0011000000000000001474000f435553544f4d45525f44454c4554457371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000001974000e50524f445543545f4352454154457371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e0011000000000000000b7400134f5247414e49534154494f4e5f5550444154457371007e000d7371007e0011000000000000001174000f435553544f4d45525f4352454154457371007e000d7371007e0011000000000000000374000c50415254595f5550444154457371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000000d74000b524f4c455f4352454154457371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000001874000f535550504c4945525f44454c4554457371007e000d7371007e0011000000000000001574000f535550504c4945525f4352454154457371007e000d7371007e0011000000000000001c74000e50524f445543545f44454c4554457371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447371007e000d7371007e0011000000000000000f74000b524f4c455f5550444154457371007e000d7371007e0011000000000000001374000f435553544f4d45525f5550444154457371007e000d7371007e0011000000000000001b74000e50524f445543545f5550444154457371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e007e787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e007c4c000573636f706571007e007e7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e007c7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d6574000a6164616d406170706c6578737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e008f770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00843f40000000000000770800000010000000007870707371007e008f770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e008f770c000000103f40000000000000787372004f6f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e557365726e616d6550617373776f726441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000002377040000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787871007e009e737200176a6176612e7574696c2e4c696e6b6564486173684d617034c04e5c106cc0fb0200015a000b6163636573734f726465727871007e00843f400000000000067708000000080000000371007e008671007e008771007e008871007e008971007e008a71007e008b7800707372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e007e4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e00110000000000038e3874003c24326124303824726f674d4d642f764a35366130386c714f6c7a4172756a6951524e312e3261767a43514c74444f514238516358596f73366d7873797372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e007e7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e00a8787000ffffffff000001007371007e00110000000000038e3871007e00a3740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00843f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e007e4c00046e616d6571007e000f787071007e001c7371007e00a600ffffffff0000010071007e001c71007e00ae740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00843f400000000000307708000000400000002371007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e003971007e003c71007e003c71007e003f71007e003f71007e004271007e004271007e004571007e004571007e004871007e004871007e004b71007e004b71007e004e71007e004e71007e005171007e005171007e005471007e005471007e005771007e005771007e005a71007e005a71007e005d71007e005d71007e006071007e006071007e006371007e006371007e006671007e006671007e006971007e006971007e006c71007e006c71007e006f71007e006f71007e007271007e007271007e007571007e007571007e007871007e0078787371007e008f770c000000403f4000000000002371007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003971007e003c71007e003f71007e004271007e004571007e004871007e004b71007e004e71007e005171007e005471007e005771007e005a71007e005d71007e006071007e006371007e006671007e006971007e006c71007e006f71007e007271007e007571007e00787874000541646d696e71007e00ae787371007e008f770c000000103f4000000000000171007e00ae7870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00b74c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00b84c000f70657273697374656e74436c61737371007e00b77872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00a84c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e00a47070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e00be74000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e00c100000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e00be74000a6164616d406170706c65
da80bfc75ce074ca4484c66c6362f1dc	\\xaced00057372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c75657400124c6a6176612f6c616e672f537472696e673b787074002461346333363336302d616535642d346338642d623434622d3836636365656631646561647372000e6a6176612e7574696c2e44617465686a81014b59741903000078707708000001788da79b8878	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000000e77040000000e73720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e003f787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e003d4c000573636f706571007e003f7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e003d7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d657400076e6f62406e6f6278737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e0050770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00453f40000000000000770800000010000000007870707371007e0050770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e0050770c000000103f40000000000000787372004f6f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e557365726e616d6550617373776f726441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000000e77040000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e00397871007e005f737200176a6176612e7574696c2e4c696e6b6564486173684d617034c04e5c106cc0fb0200015a000b6163636573734f726465727871007e00453f400000000000067708000000080000000371007e004771007e004871007e004971007e004a71007e004b71007e004c7800707372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e003f4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e001100000000000393f274003c243261243038245144516655457a56746b61494c425248646b5655717542712f796c4c71532e44455366694e417657304e31316d773261316b6e304b7372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e003f7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e0069787000ffffffff000001007371007e001100000000000393f271007e0064740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00453f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e003f4c00046e616d6571007e000f787071007e00227371007e006700ffffffff0000010071007e002271007e006f740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00453f400000000000187708000000200000000e71007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e0039787371007e0050770c000000203f4000000000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003978740008437573746f6d657271007e006f787371007e0050770c000000103f4000000000000171007e006f7870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00784c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00794c000f70657273697374656e74436c61737371007e00787872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00694c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e00657070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e007f74000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e008200000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e007f7400076e6f62406e6f62
ca75b4141e941630307d041defcaf9d2	\\xaced00057372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c75657400124c6a6176612f6c616e672f537472696e673b787074002466323936613832612d356234322d343961342d623934652d3966313035393837616662617372000e6a6176612e7574696c2e44617465686a81014b59741903000078707708000001788dedd9f178	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000000e77040000000e73720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e003f787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e003d4c000573636f706571007e003f7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e003d7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d657400076e6f62406e6f6278737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e0050770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00453f40000000000000770800000010000000007870707371007e0050770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e0050770c000000103f40000000000000787372004f6f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e557365726e616d6550617373776f726441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000000e77040000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e00397871007e005f737200176a6176612e7574696c2e4c696e6b6564486173684d617034c04e5c106cc0fb0200015a000b6163636573734f726465727871007e00453f400000000000067708000000080000000371007e004771007e004871007e004971007e004a71007e004b71007e004c7800707372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e003f4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e001100000000000393f274003c243261243038245144516655457a56746b61494c425248646b5655717542712f796c4c71532e44455366694e417657304e31316d773261316b6e304b7372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e003f7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e0069787000ffffffff000001007371007e001100000000000393f271007e0064740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00453f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e003f4c00046e616d6571007e000f787071007e00347371007e006700ffffffff0000010071007e003471007e006f740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00453f400000000000187708000000200000000e71007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e0039787371007e0050770c000000203f4000000000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003978740008437573746f6d657271007e006f787371007e0050770c000000103f4000000000000171007e006f7870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00784c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00794c000f70657273697374656e74436c61737371007e00787872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00694c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e00657070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e007f74000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e008200000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e007f7400076e6f62406e6f62
c95136f77f67e30e3a9de1e307b96b62	\\xaced00057372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c75657400124c6a6176612f6c616e672f537472696e673b787074002431393237633064342d663534642d346466352d623366352d3637613637663964346665387372000e6a6176612e7574696c2e44617465686a81014b5974190300007870770800000178910dc51978	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000000e77040000000e73720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e003f787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e003d4c000573636f706571007e003f7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e003d7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d657400076e6f62406e6f6278737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e0050770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00453f40000000000000770800000010000000007870707371007e0050770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e0050770c000000103f40000000000000787372004f6f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e557365726e616d6550617373776f726441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000000e77040000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e00397871007e005f737200176a6176612e7574696c2e4c696e6b6564486173684d617034c04e5c106cc0fb0200015a000b6163636573734f726465727871007e00453f400000000000067708000000080000000371007e004771007e004871007e004971007e004a71007e004b71007e004c7800707372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e003f4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e001100000000000393f274003c243261243038245144516655457a56746b61494c425248646b5655717542712f796c4c71532e44455366694e417657304e31316d773261316b6e304b7372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e003f7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e0069787000ffffffff000001007371007e001100000000000393f271007e0064740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00453f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e003f4c00046e616d6571007e000f787071007e00137371007e006700ffffffff0000010071007e001371007e006f740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00453f400000000000187708000000200000000e71007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e0039787371007e0050770c000000203f4000000000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003978740008437573746f6d657271007e006f787371007e0050770c000000103f4000000000000171007e006f7870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00784c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00794c000f70657273697374656e74436c61737371007e00787872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00694c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e00657070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e007f74000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e008200000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e007f7400076e6f62406e6f62
6b8d1d817106f293130c5cfa9037074d	\\xaced00057372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c75657400124c6a6176612f6c616e672f537472696e673b787074002431633231343534632d663238372d343562622d623038662d3862303234326337383661347372000e6a6176612e7574696c2e44617465686a81014b597419030000787077080000017cde78257878	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000000e77040000000e73720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000000274000a50415254595f524541447871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e003f787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e003d4c000573636f706571007e003f7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e003d7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d657400076e6f62406e6f6278737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e0050770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00453f40000000000000770800000010000000007870707371007e0050770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e0050770c000000103f40000000000000787372004f6f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e557365726e616d6550617373776f726441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000000e77040000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e00397871007e005f737200176a6176612e7574696c2e4c696e6b6564486173684d617034c04e5c106cc0fb0200015a000b6163636573734f726465727871007e00453f400000000000067708000000080000000371007e004771007e004871007e004971007e004a71007e004b71007e004c7800707372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e003f4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e001100000000000393f274003c243261243038245144516655457a56746b61494c425248646b5655717542712f796c4c71532e44455366694e417657304e31316d773261316b6e304b7372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e003f7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e0069787000ffffffff000001007371007e001100000000000393f271007e0064740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00453f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e003f4c00046e616d6571007e000f787071007e003a7371007e006700ffffffff0000010071007e003a71007e006f740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00453f400000000000187708000000200000000e71007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e0039787371007e0050770c000000203f4000000000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003978740008437573746f6d657271007e006f787371007e0050770c000000103f4000000000000171007e006f7870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00784c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00794c000f70657273697374656e74436c61737371007e00787872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00694c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e00657070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e007f74000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e008200000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e007f7400076e6f62406e6f62
52d6a2e617670a687f988f9bbdbdcbaf	\\xaced00057372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c75657400124c6a6176612f6c616e672f537472696e673b787074002436343334346334392d313634652d343730612d616162372d3738626435623762366536667372000e6a6176612e7574696c2e44617465686a81014b597419030000787077080000017ce0190c2478	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000000e77040000000e73720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e003f787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e003d4c000573636f706571007e003f7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e003d7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d657400076e6f62406e6f6278737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e0050770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002080200014c0004726f6c6571007e000f787074000455534552787371007e00453f40000000000000770800000010000000007870707371007e0050770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e0050770c000000103f40000000000000787372004f6f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e557365726e616d6550617373776f726441757468656e7469636174696f6e546f6b656e00000000000002080200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000000e77040000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e00397871007e005f737200176a6176612e7574696c2e4c696e6b6564486173684d617034c04e5c106cc0fb0200015a000b6163636573734f726465727871007e00453f400000000000067708000000080000000371007e004771007e004871007e004971007e004a71007e004b71007e004c7800707372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e003f4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e001100000000000393f274003c243261243038245144516655457a56746b61494c425248646b5655717542712f796c4c71532e44455366694e417657304e31316d773261316b6e304b7372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e003f7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e0069787000ffffffff000001007371007e001100000000000393f271007e0064740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00453f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e003f4c00046e616d6571007e000f787071007e00317371007e006700ffffffff0000010071007e003171007e006f740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00453f400000000000187708000000200000000e71007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e0039787371007e0050770c000000203f4000000000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003978740008437573746f6d657271007e006f787371007e0050770c000000103f4000000000000171007e006f7870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00784c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00794c000f70657273697374656e74436c61737371007e00787872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00694c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e00657070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e007f74000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e008200000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e007f7400076e6f62406e6f62
3c36f6d3ddbfc8b3cc1c57807190b8a2	\\xaced00057372004c6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744578706972696e674f417574683252656672657368546f6b656e2fdf47639dd0c9b70200014c000a65787069726174696f6e7400104c6a6176612f7574696c2f446174653b787200446f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e636f6d6d6f6e2e44656661756c744f417574683252656672657368546f6b656e73e10e0a6354d45e0200014c000576616c75657400124c6a6176612f6c616e672f537472696e673b787074002435336633333330372d393635612d346461642d616532302d3439303638626230306263657372000e6a6176612e7574696c2e44617465686a81014b59741903000078707708000001822f9b8c4f78	\\xaced0005737200416f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f417574683241757468656e7469636174696f6ebd400b02166252130200024c000d73746f7265645265717565737474003c4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f4f4175746832526571756573743b4c00127573657241757468656e7469636174696f6e7400324c6f72672f737072696e676672616d65776f726b2f73656375726974792f636f72652f41757468656e7469636174696f6e3b787200476f72672e737072696e676672616d65776f726b2e73656375726974792e61757468656e7469636174696f6e2e416273747261637441757468656e7469636174696f6e546f6b656ed3aa287e6e47640e0200035a000d61757468656e746963617465644c000b617574686f7269746965737400164c6a6176612f7574696c2f436f6c6c656374696f6e3b4c000764657461696c737400124c6a6176612f6c616e672f4f626a6563743b787000737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c6973747400104c6a6176612f7574696c2f4c6973743b7872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c00016371007e00047870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a6578700000000e77040000000e73720025696f2e6e7a6265652e73656375726974792e617574686f726974792e417574686f7269747900000000000000010200024c000269647400104c6a6176612f6c616e672f4c6f6e673b4c00046e616d657400124c6a6176612f6c616e672f537472696e673b78707372000e6a6176612e6c616e672e4c6f6e673b8be490cc8f23df0200014a000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000000000000a7400114f5247414e49534154494f4e5f524541447371007e000d7371007e0011000000000000000e740009524f4c455f524541447371007e000d7371007e0011000000000000002274000f435553544f4d45525f5245414445527371007e000d7371007e0011000000000000000274000a50415254595f524541447371007e000d7371007e0011000000000000001e74000c50415254595f5245414445527371007e000d7371007e0011000000000000001a74000c50524f445543545f524541447371007e000d7371007e0011000000000000002374000f535550504c4945525f5245414445527371007e000d7371007e0011000000000000001d74000e50524f445543545f5245414445527371007e000d7371007e001100000000000000217400134f5247414e49534154494f4e5f5245414445527371007e000d7371007e0011000000000000000674000b504552534f4e5f524541447371007e000d7371007e0011000000000000001674000d535550504c4945525f524541447371007e000d7371007e0011000000000000001f74000b524f4c455f5245414445527371007e000d7371007e0011000000000000001274000d435553544f4d45525f524541447371007e000d7371007e0011000000000000002074000d504552534f4e5f5245414445527871007e000c707372003a6f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e4f41757468325265717565737400000000000000010200075a0008617070726f7665644c000b617574686f72697469657371007e00044c000a657874656e73696f6e7374000f4c6a6176612f7574696c2f4d61703b4c000b726564697265637455726971007e000f4c00077265667265736874003b4c6f72672f737072696e676672616d65776f726b2f73656375726974792f6f61757468322f70726f76696465722f546f6b656e526571756573743b4c000b7265736f7572636549647374000f4c6a6176612f7574696c2f5365743b4c000d726573706f6e7365547970657371007e003f787200386f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e426173655265717565737436287a3ea37169bd0200034c0008636c69656e74496471007e000f4c001172657175657374506172616d657465727371007e003d4c000573636f706571007e003f7870740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654d6170f1a5a8fe74f507420200014c00016d71007e003d7870737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000067708000000080000000374000a6772616e745f7479706574000870617373776f7264740009636c69656e745f6964740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e74740008757365726e616d657400076e6f62406e6f6278737200256a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65536574801d92d18f9b80550200007871007e0009737200176a6176612e7574696c2e4c696e6b656448617368536574d86cd75a95dd2a1e020000787200116a6176612e7574696c2e48617368536574ba44859596b8b7340300007870770c000000103f4000000000000274000472656164740005777269746578017371007e0050770c000000103f40000000000001737200426f72672e737072696e676672616d65776f726b2e73656375726974792e636f72652e617574686f726974792e53696d706c654772616e746564417574686f7269747900000000000002300200014c0004726f6c6571007e000f787074000455534552787371007e00453f40000000000000770800000010000000007870737200396f72672e737072696e676672616d65776f726b2e73656375726974792e6f61757468322e70726f76696465722e546f6b656e52657175657374d62a84b8cf38f8010200014c00096772616e745479706571007e000f7871007e0040740028737072696e672d73656375726974792d6f61757468322d726561642d77726974652d636c69656e747371007e00437371007e00453f400000000000037708000000040000000274000d726566726573685f746f6b656e74002462376662363134622d306465302d343938352d396230332d66666363636339626363366374000a6772616e745f7479706574000d726566726573685f746f6b656e787371007e004d7371007e004f770c000000103f400000000000007871007e00617371007e0050770c000000103f400000000000017400187265736f757263652d7365727665722d726573742d617069787371007e0050770c000000103f40000000000000787372005b6f72672e737072696e676672616d65776f726b2e73656375726974792e7765622e61757468656e7469636174696f6e2e707265617574682e50726541757468656e7469636174656441757468656e7469636174696f6e546f6b656e00000000000002300200024c000b63726564656e7469616c7371007e00054c00097072696e636970616c71007e00057871007e0003017371007e00077371007e000b0000000e77040000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e00397871007e006a707400007372001b696f2e6e7a6265652e73656375726974792e757365722e55736572000000000000000102000b5a000e6163636f756e74457870697265645a000d6163636f756e744c6f636b65645a001263726564656e7469616c73457870697265645a0007656e61626c65645a000a69735573696e673246414c0002496471007e000e4c000870617373776f726471007e000f4c0005726f6c657371007e003f4c000673656372657471007e000f4c000975736572506172747974001d4c696f2f6e7a6265652f656e746974792f70617274792f50617274793b4c0008757365726e616d6571007e000f787000000001007371007e001100000000000393f274003c243261243038245144516655457a56746b61494c425248646b5655717542712f796c4c71532e44455366694e417657304e31316d773261316b6e304b7372002f6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e50657273697374656e745365748b47ef79d4c9917d0200014c000373657471007e003f7872003e6f72672e68696265726e6174652e636f6c6c656374696f6e2e696e7465726e616c2e416273747261637450657273697374656e74436f6c6c656374696f6e5718b75d8aba735402000b5a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e49000a63616368656453697a655a000564697274795a000e656c656d656e7452656d6f7665645a000b696e697469616c697a65645a000d697354656d7053657373696f6e4c00036b65797400164c6a6176612f696f2f53657269616c697a61626c653b4c00056f776e657271007e00054c0004726f6c6571007e000f4c001273657373696f6e466163746f72795575696471007e000f4c000e73746f726564536e617073686f7471007e0073787000ffffffff000001007371007e001100000000000393f271007e006e740021696f2e6e7a6265652e73656375726974792e757365722e557365722e726f6c6573707371007e00453f400000000000017708000000020000000173720024696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c6500000000000000010200034c0002496471007e000e4c000b617574686f72697469657371007e003f4c00046e616d6571007e000f787071007e001c7371007e007100ffffffff0000010071007e001c71007e0079740030696f2e6e7a6265652e73656375726974792e757365722e726f6c652e55736572526f6c652e617574686f726974696573707371007e00453f400000000000187708000000200000000e71007e001071007e001071007e001571007e001571007e001871007e001871007e001b71007e001b71007e001e71007e001e71007e002171007e002171007e002471007e002471007e002771007e002771007e002a71007e002a71007e002d71007e002d71007e003071007e003071007e003371007e003371007e003671007e003671007e003971007e0039787371007e0050770c000000203f4000000000000e71007e001071007e001571007e001871007e001b71007e001e71007e002171007e002471007e002771007e002a71007e002d71007e003071007e003371007e003671007e003978740008437573746f6d657271007e0079787371007e0050770c000000103f4000000000000171007e00797870737200346f72672e68696265726e6174652e70726f78792e706f6a6f2e6279746562756464792e53657269616c697a61626c6550726f7879c8e2f1ffb619aa2e0200084c000f636f6d706f6e656e744964547970657400224c6f72672f68696265726e6174652f747970652f436f6d706f73697465547970653b4c001b6964656e7469666965724765747465724d6574686f64436c6173737400114c6a6176612f6c616e672f436c6173733b4c001a6964656e7469666965724765747465724d6574686f644e616d6571007e000f4c001b6964656e7469666965725365747465724d6574686f64436c61737371007e00824c001a6964656e7469666965725365747465724d6574686f644e616d6571007e000f5b001c6964656e7469666965725365747465724d6574686f64506172616d737400125b4c6a6176612f6c616e672f436c6173733b5b000a696e746572666163657371007e00834c000f70657273697374656e74436c61737371007e00827872002d6f72672e68696265726e6174652e70726f78792e416273747261637453657269616c697a61626c6550726f7879926a2d5a450b04610200055a001b616c6c6f774c6f61644f7574736964655472616e73616374696f6e4c000a656e746974794e616d6571007e000f4c0002696471007e00734c0008726561644f6e6c797400134c6a6176612f6c616e672f426f6f6c65616e3b4c001273657373696f6e466163746f72795575696471007e000f78700074001b696f2e6e7a6265652e656e746974792e70617274792e506172747971007e006f7070707672001b696f2e6e7a6265652e656e746974792e70617274792e50617274790000000000000000000000787074000a6765745061727479496471007e008974000a73657450617274794964757200125b4c6a6176612e6c616e672e436c6173733bab16d7aecbcd5a990200007870000000017671007e00117571007e008c00000001767200226f72672e68696265726e6174652e70726f78792e48696265726e61746550726f7879517e3626971bbe22020000787071007e00897400076e6f62406e6f62
\.


--
-- Data for Name: password_reset_token; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.password_reset_token (id, expiry_date, token, pty_id) FROM stdin;
\.


--
-- Data for Name: permission; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.permission (id, name) FROM stdin;
1	PARTY_CREATE
2	PARTY_READ
3	PARTY_UPDATE
4	PARTY_DELETE
5	PERSON_CREATE
6	PERSON_READ
7	PERSON_UPDATE
8	PERSON_DELETE
9	ORGANISATION_CREATE
10	ORGANISATION_READ
11	ORGANISATION_UPDATE
12	ORGANISATION_DELETE
13	ROLE_CREATE
14	ROLE_READ
15	ROLE_UPDATE
16	ROLE_DELETE
17	CUSTOMER_CREATE
18	CUSTOMER_READ
19	CUSTOMER_UPDATE
20	CUSTOMER_DELETE
21	SUPPLIER_CREATE
22	SUPPLIER_READ
23	SUPPLIER_UPDATE
24	SUPPLIER_DELETE
25	PRODUCT_CREATE
26	PRODUCT_READ
27	PRODUCT_UPDATE
28	PRODUCT_DELETE
29	PRODUCT_READER
30	PARTY_READER
31	ROLE_READER
32	PERSON_READER
33	ORGANISATION_READER
34	CUSTOMER_READER
35	SUPPLIER_READER
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.role (id, name) FROM stdin;
2	Customer
1	Admin
\.


--
-- Data for Name: role_permission; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.role_permission (id, role_id, permission_id) FROM stdin;
29	1	1
30	1	2
31	1	3
32	1	4
33	1	5
34	1	6
35	1	7
36	1	8
37	1	9
38	1	10
39	1	11
40	1	12
41	1	13
42	1	14
43	1	15
44	1	16
45	1	17
46	1	18
47	1	19
48	1	20
49	1	21
50	1	22
51	1	23
52	1	24
53	1	25
54	1	26
55	1	27
56	1	28
57	1	29
58	1	30
59	1	31
60	1	32
61	1	33
62	1	34
63	1	35
64	2	2
65	2	6
66	2	10
67	2	14
68	2	18
69	2	22
70	2	26
71	2	29
72	2	30
73	2	31
74	2	32
75	2	33
76	2	34
77	2	35
\.


--
-- Data for Name: user_; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.user_ (pty_id, account_expired, account_locked, credentials_expired, enabled, password, user_name, is_using2fa, secret) FROM stdin;
1	f	f	f	t	$2a$08$qvrzQZ7jJ7oy2p/msL4M0.l83Cd0jNsX6AJUitbgRXGzge4j035ha	admin	f	\N
232216	f	f	f	t	\N	asd321	f	\N
232220	f	f	f	t	$2a$08$HDsx4cloh1PXKlNp6C2yGObROfR3VysQAYdABq5naOXiGvFknU8/G	dandandan	f	\N
232230	f	f	f	t	$2a$08$7eM8kbxuV2Jse66alC42H.e0RR9cy4Hyp6Ospu5p3b/EmzeVgKhpK	willP009	f	\N
232232	f	f	f	t	$2a$08$3RoMwu7GVj6MXm6VabqzIOlP5rT5.v9bg9KNd7nSsTeKaklgZqbFu	willP010	f	\N
232234	f	f	f	t	$2a$08$cTnUGt.0wthXBGvsVMZHx.AJyQa0ebgvJW04X8JZ8/1/BXDfIjdWG	zoro	f	\N
232236	f	f	f	t	$2a$08$FabdFDGk9m8OjZPgKAErz.vrj.tBA0q8lnWT3W4Mi7dz9mHTuNSz.	j	f	\N
232238	f	f	f	t	$2a$08$81tduh5zwgiYtNggVPM6rOdDgv5YmCp.zI6gg13KpbXXv2qGqD0Am	x	f	\N
232240	f	f	f	t	$2a$08$5w4IxUjIw5BGrqRYSu/pDe5roRv3EubLbRH/sq39fIglXLLtfmNCW	z	f	\N
232242	f	f	f	t	$2a$08$09Z1moTTHngZmBYkgDKT6u.HG/IUv/wnZGRuGdQr3nIRfenYq1Tna	h	f	\N
232244	f	f	f	t	$2a$08$or5gp1qilssjjsmY.AlQJeqaYEG9eZmc4NhM3pV3SAFxqYi0CEZHG	i	f	\N
232246	f	f	f	t	$2a$08$eSAoAHFKAQrrfy3sgDGyc.DQiUvdN2wwq8uKLUAK.pJ.3fV7g3BK2	f	f	\N
232248	f	f	f	t	$2a$08$AeXLuGlP.9pcWACajgNQq.ft4nUNlVqxC6542ZZRSLrOlDksB.8Nq	av1	f	\N
232250	f	f	f	t	$2a$08$kbU80lL54gj.H333EHle9.uGYOgYu9jUf0TVqhxUR5QqquQQyQDjy	moobot	f	\N
232252	f	f	f	t	$2a$08$0rG7b0MAv3NhnhUnm9Wo/ue/OF3HeOxEpzjgAK8IIsVxQCpgFA6ji	Labrador	f	\N
232254	f	f	f	t	$2a$08$p1t6.ZTkGYnpgb/ZJ93n/eR3mPck7483VDthqLjMmq87C5eFPLlNi	bill	f	\N
232256	f	f	f	t	$2a$08$ZYgWAyU302Vu55IyqGY6KewH5dcTp5bfCQcD0VoFxRdJ6Jm6SOUKe	danielmackie82@gmail.com	f	\N
232258	f	f	f	t	$2a$08$FshVXmerj.mItbrKW1Dn8OvXo00F0SFC0XM6Is90HU29csTinQTt2	dan	f	\N
232260	f	f	f	t	$2a$08$LD84vr08Qr3eDbwuXshAXusm4eJ2qhN1kyMsOAD/LpdsreQjYBkkC	nod	f	\N
232262	f	f	f	t	$2a$08$c8qi4W9yonajx5mQ6GIsFe.BlpqfoIqa9YGwGvM7R99.RHu.SQ22a	dmac269	f	\N
232304	f	f	f	t	$2a$08$uMskpBcSMtkRQevNlIE5xORKArzGL8feooSuLyuL59.uRVXlhItMm	dmac088	f	\N
232310	f	f	f	t	$2a$08$WAj6Z.QOG6UqvCbEzlnFD./uyT2TafVm5MPH2LRUMUohM8Y33VboW	dmac999	f	\N
232312	f	f	f	t	$2a$08$1aM3WzOjSX9nJZUFhFutsOT4p8Xkos5iIidrXFnYeTAw6weAmykL.	dmac1111	f	\N
233016	f	f	f	t	$2a$08$rogMMd/vJ56a08lqOlzArujiQRN1.2avzCQLtDOQB8QcXYos6mxsy	adam@apple	f	\N
233018	f	f	f	t	$2a$08$RTEy6nmop87vx8IUyIsodO6YYUOrmwXB4V7wUhhcHf2SFMjwxd1Gy	barry@white	f	\N
233020	f	f	f	t	$2a$08$FLLvo2tVvtH29IaFbCOvHuCfq2UNWKcYQhiwfcFxYrKUSMwXgolcC	will@parkhouse	f	\N
233022	f	f	f	t	$2a$08$2HdSUuizuRx9Sw4q822W6OC.XBdNCC711euR/fghUWNeLdwhY2n/C	john@wayne	f	\N
233024	f	f	f	t	$2a$08$4DTKA9aghc3gJMan0zjn2e/URKSa667JXlVUrw6pS79OzBswm6pqK	bob@bob	f	\N
233054	f	f	f	f	$2a$08$qi9xsyMckwVhNG0k1C0m8.zBV5NgPhDnJ5zqAGhqV6ddrF62cwdFi	dmac1119	f	\N
234477	f	f	f	t	$2a$08$lMh8Za9pdp4TU/a0q3SUSe9cj9/BNZYxJ37uerWn6Pp9Q0v0rRnIS	rob@rob	f	\N
234482	f	f	f	t	$2a$08$QDQfUEzVtkaILBRHdkVUquBq/ylLqS.DESfiNAvW0N11mw2a1kn0K	nob@nob	f	\N
2030867	f	f	f	t	$2a$08$hcg54Vn8ksH8iv.Y2LTBr.mcGRBnNrv7EynIBNyBSBf/IhI0aoIlG	mackdad	f	\N
234485	f	f	f	f	$2a$08$.KhZEsHxZO1fBcZ/iOzVPu2T5mk82K/jXGKb/q0fph/bQN3NmFApK	dmac1124	f	\N
\.


--
-- Data for Name: user_location; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.user_location (id, country, enabled, pty_id) FROM stdin;
\.


--
-- Data for Name: user_role; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.user_role (id, pty_id, role_id) FROM stdin;
1	1	1
2	232216	1
3	232220	1
4	232230	2
5	232232	2
6	232234	2
7	232236	2
8	232238	2
9	232240	2
10	232242	2
11	232244	2
12	232246	2
13	232248	2
14	232250	2
15	232252	2
16	232254	2
17	232256	2
18	232258	2
19	232260	2
20	232262	2
41	232304	2
44	232310	2
45	232312	2
192	233016	1
193	233018	2
194	233020	2
195	233022	2
196	233024	1
204	233054	2
226	234477	2
227	234482	2
255	2030867	2
257	234485	2
\.


--
-- Data for Name: verification_token; Type: TABLE DATA; Schema: security; Owner: security_owner
--

COPY security.verification_token (id, expiry_date, token, pty_id) FROM stdin;
1	2020-08-21 22:41:05.192	f70d05b5-0239-4901-9326-5fe401981474	233054
2	2020-12-03 12:06:31.233	f69065e6-212a-4d50-bd45-a45f9203a3cf	234477
3	2020-12-03 12:54:35.06	fa3e4d83-5c34-4a4c-8233-0448063190c8	234482
\.


--
-- Name: accessories_attr_lcl_prd_lcl_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.accessories_attr_lcl_prd_lcl_id_seq', 71, true);


--
-- Name: address_addr_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.address_addr_id_seq', 3, true);


--
-- Name: address_type_addr_typ_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.address_type_addr_typ_id_seq', 3, true);


--
-- Name: bag_bag_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.bag_bag_id_seq', 234487, true);


--
-- Name: bag_item_bag_item_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.bag_item_bag_item_id_seq', 234517, true);


--
-- Name: bag_item_disc_bag_item_disc_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.bag_item_disc_bag_item_disc_id_seq', 1, false);


--
-- Name: bag_item_status_bag_item_sts_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.bag_item_status_bag_item_sts_id_seq', 4, true);


--
-- Name: brand_attr_lcl_bnd_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.brand_attr_lcl_bnd_id_seq', 78, true);


--
-- Name: brand_attr_lcl_bnd_lcl_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.brand_attr_lcl_bnd_lcl_id_seq', 233223, true);


--
-- Name: brand_bnd_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.brand_bnd_id_seq', 233219, true);


--
-- Name: brand_category_bnd_cat_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.brand_category_bnd_cat_id_seq', 15, true);


--
-- Name: brand_promotion_bnd_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.brand_promotion_bnd_id_seq', 1, false);


--
-- Name: brand_promotion_prm_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.brand_promotion_prm_id_seq', 1, false);


--
-- Name: category_attr_lcl_cat_lcl_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.category_attr_lcl_cat_lcl_id_seq', 233191, true);


--
-- Name: category_brand_cat_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.category_brand_cat_id_seq', 46, true);


--
-- Name: category_cat_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.category_cat_id_seq', 233189, true);


--
-- Name: category_product_cat_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.category_product_cat_id_seq', 233189, true);


--
-- Name: category_promotion_cat_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.category_promotion_cat_id_seq', 15, true);


--
-- Name: category_promotion_prm_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.category_promotion_prm_id_seq', 234468, true);


--
-- Name: category_type_cat_typ_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.category_type_cat_typ_id_seq', 5, true);


--
-- Name: currency_ccy_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.currency_ccy_id_seq', 3, true);


--
-- Name: customer_cst_num_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.customer_cst_num_seq', 6, true);


--
-- Name: customer_rle_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.customer_rle_id_seq', 234484, true);


--
-- Name: department_attr_lcl_dept_lcl_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.department_attr_lcl_dept_lcl_id_seq', 5, true);


--
-- Name: department_dept_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.department_dept_id_seq', 3, true);


--
-- Name: discount_dis_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.discount_dis_id_seq', 1, false);


--
-- Name: discount_type_dis_typ_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.discount_type_dis_typ_id_seq', 3, true);


--
-- Name: inventory_location_inv_loc_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.inventory_location_inv_loc_id_seq', 2, true);


--
-- Name: inventory_transaction_inv_trx_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.inventory_transaction_inv_trx_id_seq', 234429, true);


--
-- Name: inventory_transaction_type_inv_trx_typ_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.inventory_transaction_type_inv_trx_typ_id_seq', 3, true);


--
-- Name: locale_lcl_cd_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.locale_lcl_cd_seq', 1, false);


--
-- Name: order_line_ord_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.order_line_ord_id_seq', 1, false);


--
-- Name: order_line_ord_lne_no_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.order_line_ord_lne_no_seq', 1, false);


--
-- Name: order_line_prd_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.order_line_prd_id_seq', 1, false);


--
-- Name: order_ord_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.order_ord_id_seq', 1, false);


--
-- Name: party_pty_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.party_pty_id_seq', 234485, true);


--
-- Name: party_type_pty_typ_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.party_type_pty_typ_id_seq', 3, true);


--
-- Name: price_prc_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.price_prc_id_seq', 2035088, true);


--
-- Name: price_type_prc_typ_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.price_type_prc_typ_id_seq', 3, true);


--
-- Name: product_attr_lcl_prd_lcl_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.product_attr_lcl_prd_lcl_id_seq', 233737, true);


--
-- Name: product_basic_prd_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.product_basic_prd_id_seq', 233731, true);


--
-- Name: product_category_prd_cat_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.product_category_prd_cat_id_seq', 2288, true);


--
-- Name: product_prd_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.product_prd_id_seq', 2031888, true);


--
-- Name: product_promotion_prd_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.product_promotion_prd_id_seq', 2031277, true);


--
-- Name: product_promotion_prm_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.product_promotion_prm_id_seq', 234468, true);


--
-- Name: product_rating_prd_rat_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.product_rating_prd_rat_id_seq', 121, true);


--
-- Name: product_shipping_attr_lcl_prd_lcl_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.product_shipping_attr_lcl_prd_lcl_id_seq', 2082, true);


--
-- Name: product_shipping_prd_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.product_shipping_prd_id_seq', 2031887, true);


--
-- Name: product_status_prd_sts_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.product_status_prd_sts_id_seq', 3, true);


--
-- Name: product_tag_prd_tag_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.product_tag_prd_tag_id_seq', 136, true);


--
-- Name: promotion_attr_lcl_prm_lcl_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.promotion_attr_lcl_prm_lcl_id_seq', 2030867, true);


--
-- Name: promotion_level_prm_lvl_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.promotion_level_prm_lvl_id_seq', 4, true);


--
-- Name: promotion_mechanic_prm_mec_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.promotion_mechanic_prm_mec_id_seq', 4, true);


--
-- Name: promotion_order_prm_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.promotion_order_prm_id_seq', 2030865, true);


--
-- Name: promotion_prm_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.promotion_prm_id_seq', 2030865, true);


--
-- Name: promotion_product_prm_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.promotion_product_prm_id_seq', 234468, true);


--
-- Name: promotion_type_prm_typ_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.promotion_type_prm_typ_id_seq', 3, true);


--
-- Name: rating_rat_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.rating_rat_id_seq', 6, true);


--
-- Name: role_rle_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.role_rle_id_seq', 234486, true);


--
-- Name: role_type_rle_typ_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.role_type_rle_typ_id_seq', 3, true);


--
-- Name: stock_on_hand_soh_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.stock_on_hand_soh_id_seq', 234430, true);


--
-- Name: supplier_rle_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.supplier_rle_id_seq', 233057, true);


--
-- Name: supplier_sup_num_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.supplier_sup_num_seq', 1000000002, true);


--
-- Name: tag_attr_lcl_tag_lcl_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: postgres
--

SELECT pg_catalog.setval('mochi.tag_attr_lcl_tag_lcl_id_seq', 233275, true);


--
-- Name: tag_tag_id_seq; Type: SEQUENCE SET; Schema: mochi; Owner: mochidb_owner
--

SELECT pg_catalog.setval('mochi.tag_tag_id_seq', 233273, true);


--
-- Name: authority_id_seq; Type: SEQUENCE SET; Schema: security; Owner: security_owner
--

SELECT pg_catalog.setval('security.authority_id_seq', 1, false);


--
-- Name: hibernate_sequence; Type: SEQUENCE SET; Schema: security; Owner: security_owner
--

SELECT pg_catalog.setval('security.hibernate_sequence', 3, true);


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: security; Owner: security_owner
--

SELECT pg_catalog.setval('security.role_id_seq', 1, false);


--
-- Name: role_permission_id_seq; Type: SEQUENCE SET; Schema: security; Owner: security_owner
--

SELECT pg_catalog.setval('security.role_permission_id_seq', 77, true);


--
-- Name: user_role_id_seq; Type: SEQUENCE SET; Schema: security; Owner: security_owner
--

SELECT pg_catalog.setval('security.user_role_id_seq', 257, true);


--
-- Name: accessories_attr_lcl accessories_attr_lcl_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.accessories_attr_lcl
    ADD CONSTRAINT accessories_attr_lcl_pkey PRIMARY KEY (prd_lcl_id);


--
-- Name: address address_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (addr_id);


--
-- Name: address_type address_type_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.address_type
    ADD CONSTRAINT address_type_pkey PRIMARY KEY (addr_typ_id);


--
-- Name: bag_item_disc bag_item_disc_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.bag_item_disc
    ADD CONSTRAINT bag_item_disc_pkey PRIMARY KEY (bag_item_disc_id);


--
-- Name: bag_item bag_item_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.bag_item
    ADD CONSTRAINT bag_item_pkey PRIMARY KEY (bag_item_id);


--
-- Name: bag bag_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.bag
    ADD CONSTRAINT bag_pkey PRIMARY KEY (bag_id);


--
-- Name: bag_item_status bag_status_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.bag_item_status
    ADD CONSTRAINT bag_status_pkey PRIMARY KEY (bag_item_sts_id);


--
-- Name: brand_attr_lcl brand_attr_lcl_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.brand_attr_lcl
    ADD CONSTRAINT brand_attr_lcl_pkey PRIMARY KEY (bnd_lcl_id);


--
-- Name: brand_category brand_category_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.brand_category
    ADD CONSTRAINT brand_category_pkey PRIMARY KEY (bnd_cat_id);


--
-- Name: brand brand_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.brand
    ADD CONSTRAINT brand_pkey PRIMARY KEY (bnd_id);


--
-- Name: brand_promotion brand_promotion_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.brand_promotion
    ADD CONSTRAINT brand_promotion_pkey PRIMARY KEY (bnd_id, prm_id);


--
-- Name: category_attr_lcl category_attr_lcl_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.category_attr_lcl
    ADD CONSTRAINT category_attr_lcl_pkey PRIMARY KEY (cat_lcl_id);


--
-- Name: category_brand category_brand_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.category_brand
    ADD CONSTRAINT category_brand_pkey PRIMARY KEY (cat_id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (cat_id);


--
-- Name: category_product category_product_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.category_product
    ADD CONSTRAINT category_product_pkey PRIMARY KEY (cat_id);


--
-- Name: category_promotion category_promotion_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.category_promotion
    ADD CONSTRAINT category_promotion_pkey PRIMARY KEY (cat_id, prm_id);


--
-- Name: category_type category_type_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.category_type
    ADD CONSTRAINT category_type_pkey PRIMARY KEY (cat_typ_id);


--
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (ccy_id);


--
-- Name: customer customer_cst_id_key; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.customer
    ADD CONSTRAINT customer_cst_id_key UNIQUE (cst_num);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (rle_id);


--
-- Name: department_attr_lcl department_attr_lcl_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.department_attr_lcl
    ADD CONSTRAINT department_attr_lcl_pkey PRIMARY KEY (dept_lcl_id);


--
-- Name: department department_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (dept_id);


--
-- Name: discount discount_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.discount
    ADD CONSTRAINT discount_pkey PRIMARY KEY (dis_id);


--
-- Name: discount_type discount_type_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.discount_type
    ADD CONSTRAINT discount_type_pkey PRIMARY KEY (dis_typ_id);


--
-- Name: inventory_location inventory_location_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.inventory_location
    ADD CONSTRAINT inventory_location_pkey PRIMARY KEY (inv_loc_id);


--
-- Name: inventory_transaction inventory_transaction_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.inventory_transaction
    ADD CONSTRAINT inventory_transaction_pkey PRIMARY KEY (inv_trx_id);


--
-- Name: inventory_transaction_type inventory_transaction_type_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.inventory_transaction_type
    ADD CONSTRAINT inventory_transaction_type_pkey PRIMARY KEY (inv_trx_typ_id);


--
-- Name: order_line order_line_ord_id_key; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.order_line
    ADD CONSTRAINT order_line_ord_id_key UNIQUE (ord_id);


--
-- Name: order_line order_line_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.order_line
    ADD CONSTRAINT order_line_pkey PRIMARY KEY (ord_id, prd_id, ord_lne_no);


--
-- Name: order orders_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi."order"
    ADD CONSTRAINT orders_pkey PRIMARY KEY (ord_id);


--
-- Name: order orders_pty_id_key; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi."order"
    ADD CONSTRAINT orders_pty_id_key UNIQUE (pty_id);


--
-- Name: organisation organisation_org_id_key; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.organisation
    ADD CONSTRAINT organisation_org_id_key UNIQUE (pty_id);


--
-- Name: party party_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.party
    ADD CONSTRAINT party_pkey PRIMARY KEY (pty_id);


--
-- Name: party_type party_type_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.party_type
    ADD CONSTRAINT party_type_pkey PRIMARY KEY (pty_typ_id);


--
-- Name: party_type party_type_pty_typ_desc_key; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.party_type
    ADD CONSTRAINT party_type_pty_typ_desc_key UNIQUE (pty_typ_desc);


--
-- Name: person person_psn_id_key; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.person
    ADD CONSTRAINT person_psn_id_key UNIQUE (pty_id);


--
-- Name: locale pk_locale; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.locale
    ADD CONSTRAINT pk_locale PRIMARY KEY (lcl_cd);


--
-- Name: accessories_attr_lcl prd_id_lcl_cd_1; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.accessories_attr_lcl
    ADD CONSTRAINT prd_id_lcl_cd_1 UNIQUE (prd_id, lcl_cd);


--
-- Name: department_attr_lcl prd_id_lcl_cd_3; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.department_attr_lcl
    ADD CONSTRAINT prd_id_lcl_cd_3 UNIQUE (dept_id, lcl_cd);


--
-- Name: price price_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (prc_id);


--
-- Name: price_type price_type_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.price_type
    ADD CONSTRAINT price_type_pkey PRIMARY KEY (prc_typ_id);


--
-- Name: product_attr_lcl product_attr_lcl_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_attr_lcl
    ADD CONSTRAINT product_attr_lcl_pkey PRIMARY KEY (prd_lcl_id);


--
-- Name: product_basic product_basic_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_basic
    ADD CONSTRAINT product_basic_pkey PRIMARY KEY (prd_id);


--
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (prd_cat_id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (prd_id);


--
-- Name: product_promotion product_promotion_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_promotion
    ADD CONSTRAINT product_promotion_pkey PRIMARY KEY (prd_id, prm_id);


--
-- Name: product_rating product_rating_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_rating
    ADD CONSTRAINT product_rating_pkey PRIMARY KEY (prd_rat_id);


--
-- Name: product_shipping_attr_lcl product_shipping_attr_lcl_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_shipping_attr_lcl
    ADD CONSTRAINT product_shipping_attr_lcl_pkey PRIMARY KEY (prd_lcl_id);


--
-- Name: product_shipping product_shipping_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_shipping
    ADD CONSTRAINT product_shipping_pkey PRIMARY KEY (prd_id);


--
-- Name: product_status product_status_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_status
    ADD CONSTRAINT product_status_pkey PRIMARY KEY (prd_sts_id);


--
-- Name: product_tag product_tag_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_tag
    ADD CONSTRAINT product_tag_pkey PRIMARY KEY (prd_tag_id);


--
-- Name: promotion_attr_lcl promotion_attr_lcl_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion_attr_lcl
    ADD CONSTRAINT promotion_attr_lcl_pkey PRIMARY KEY (prm_lcl_id);


--
-- Name: promotion_order promotion_coupon_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion_order
    ADD CONSTRAINT promotion_coupon_pkey PRIMARY KEY (prm_id);


--
-- Name: promotion_level promotion_level_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion_level
    ADD CONSTRAINT promotion_level_pkey PRIMARY KEY (prm_lvl_id);


--
-- Name: promotion_mechanic promotion_mechanic_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion_mechanic
    ADD CONSTRAINT promotion_mechanic_pkey PRIMARY KEY (prm_mec_id);


--
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (prm_id);


--
-- Name: promotion_product promotion_regular_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion_product
    ADD CONSTRAINT promotion_regular_pkey PRIMARY KEY (prm_id);


--
-- Name: promotion_type promotion_type_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion_type
    ADD CONSTRAINT promotion_type_pkey PRIMARY KEY (prm_typ_id);


--
-- Name: rating rating_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.rating
    ADD CONSTRAINT rating_pkey PRIMARY KEY (rat_id);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (rle_id);


--
-- Name: role role_pty_id_key; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.role
    ADD CONSTRAINT role_pty_id_key UNIQUE (pty_id);


--
-- Name: role_type role_type_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.role_type
    ADD CONSTRAINT role_type_pkey PRIMARY KEY (rle_typ_id);


--
-- Name: role_type role_type_rle_typ_desc_key; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.role_type
    ADD CONSTRAINT role_type_rle_typ_desc_key UNIQUE (rle_typ_desc);


--
-- Name: stock_on_hand stock_on_hand_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.stock_on_hand
    ADD CONSTRAINT stock_on_hand_pkey PRIMARY KEY (soh_id);


--
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (rle_id);


--
-- Name: tag_attr_lcl tag_attr_lcl_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.tag_attr_lcl
    ADD CONSTRAINT tag_attr_lcl_pkey PRIMARY KEY (tag_lcl_id);


--
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (tag_id);


--
-- Name: bag_item uc_bag_item; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.bag_item
    ADD CONSTRAINT uc_bag_item UNIQUE (bag_id, prd_id);


--
-- Name: bag_item_status uc_bag_sts_cd; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.bag_item_status
    ADD CONSTRAINT uc_bag_sts_cd UNIQUE (bag_item_sts_cd);


--
-- Name: brand uc_bnd_cd; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.brand
    ADD CONSTRAINT uc_bnd_cd UNIQUE (bnd_cd);


--
-- Name: brand_attr_lcl uc_bnd_desc_lcl_cd; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.brand_attr_lcl
    ADD CONSTRAINT uc_bnd_desc_lcl_cd UNIQUE (bnd_desc, lcl_cd);


--
-- Name: brand_attr_lcl uc_bnd_lcl; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.brand_attr_lcl
    ADD CONSTRAINT uc_bnd_lcl UNIQUE (bnd_id, lcl_cd);


--
-- Name: brand_category uc_brand_category; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.brand_category
    ADD CONSTRAINT uc_brand_category UNIQUE (bnd_id, cat_id);


--
-- Name: category uc_cat_cd; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.category
    ADD CONSTRAINT uc_cat_cd UNIQUE (cat_cd);


--
-- Name: category_attr_lcl uc_cat_desc; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.category_attr_lcl
    ADD CONSTRAINT uc_cat_desc UNIQUE (cat_desc, lcl_cd);


--
-- Name: category_attr_lcl uc_cat_lcl; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.category_attr_lcl
    ADD CONSTRAINT uc_cat_lcl UNIQUE (cat_id, lcl_cd);


--
-- Name: category_type uc_cat_typ_cd; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.category_type
    ADD CONSTRAINT uc_cat_typ_cd UNIQUE (cat_typ_cd);


--
-- Name: stock_on_hand uc_prd_id; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.stock_on_hand
    ADD CONSTRAINT uc_prd_id UNIQUE (soh_prd_id);


--
-- Name: product_attr_lcl uc_prd_lcl_1; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_attr_lcl
    ADD CONSTRAINT uc_prd_lcl_1 UNIQUE (prd_id, lcl_cd);


--
-- Name: product_shipping_attr_lcl uc_prd_lcl_2; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_shipping_attr_lcl
    ADD CONSTRAINT uc_prd_lcl_2 UNIQUE (prd_id, lcl_cd);


--
-- Name: product_rating uc_prd_rat; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_rating
    ADD CONSTRAINT uc_prd_rat UNIQUE (prd_id, rat_id, pty_id);


--
-- Name: product_status uc_prd_sts_cd; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_status
    ADD CONSTRAINT uc_prd_sts_cd UNIQUE (prd_sts_cd);


--
-- Name: department uc_prd_typ_cd; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.department
    ADD CONSTRAINT uc_prd_typ_cd UNIQUE (dept_cd);


--
-- Name: promotion uc_prm_cd; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion
    ADD CONSTRAINT uc_prm_cd UNIQUE (prm_cd);


--
-- Name: promotion_attr_lcl uc_prm_lcl_1; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion_attr_lcl
    ADD CONSTRAINT uc_prm_lcl_1 UNIQUE (prm_id, lcl_cd);


--
-- Name: promotion_level uc_prm_lvl_cd; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion_level
    ADD CONSTRAINT uc_prm_lvl_cd UNIQUE (prm_lvl_cd);


--
-- Name: promotion_mechanic uc_prm_mec_cd; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion_mechanic
    ADD CONSTRAINT uc_prm_mec_cd UNIQUE (prm_mec_cd);


--
-- Name: promotion_type uc_prm_typ_cd; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion_type
    ADD CONSTRAINT uc_prm_typ_cd UNIQUE (prm_typ_cd);


--
-- Name: product_category uc_product_category; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_category
    ADD CONSTRAINT uc_product_category UNIQUE (prd_id, cat_id);


--
-- Name: product_tag uc_product_tag; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_tag
    ADD CONSTRAINT uc_product_tag UNIQUE (prd_id, tag_id);


--
-- Name: product uc_product_upc_cd; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product
    ADD CONSTRAINT uc_product_upc_cd UNIQUE (upc_cd);


--
-- Name: tag uc_tag_cd; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.tag
    ADD CONSTRAINT uc_tag_cd UNIQUE (tag_cd);


--
-- Name: tag_attr_lcl uc_tag_desc; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.tag_attr_lcl
    ADD CONSTRAINT uc_tag_desc UNIQUE (tag_desc, lcl_cd);


--
-- Name: tag_attr_lcl uc_tag_lcl; Type: CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.tag_attr_lcl
    ADD CONSTRAINT uc_tag_lcl UNIQUE (tag_id, lcl_cd);


--
-- Name: permission authority_name; Type: CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.permission
    ADD CONSTRAINT authority_name UNIQUE (name);


--
-- Name: permission authority_pkey; Type: CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.permission
    ADD CONSTRAINT authority_pkey PRIMARY KEY (id);


--
-- Name: clientdetails clientdetails_pkey; Type: CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.clientdetails
    ADD CONSTRAINT clientdetails_pkey PRIMARY KEY (appid);


--
-- Name: device_metadata device_metadata_pkey; Type: CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.device_metadata
    ADD CONSTRAINT device_metadata_pkey PRIMARY KEY (id);


--
-- Name: new_location_token new_location_token_pkey; Type: CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.new_location_token
    ADD CONSTRAINT new_location_token_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_token oauth_access_token_pkey; Type: CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.oauth_access_token
    ADD CONSTRAINT oauth_access_token_pkey PRIMARY KEY (authentication_id);


--
-- Name: oauth_client_details oauth_client_details_pkey; Type: CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.oauth_client_details
    ADD CONSTRAINT oauth_client_details_pkey PRIMARY KEY (client_id);


--
-- Name: oauth_client_token oauth_client_token_pkey; Type: CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.oauth_client_token
    ADD CONSTRAINT oauth_client_token_pkey PRIMARY KEY (authentication_id);


--
-- Name: password_reset_token password_reset_token_pkey; Type: CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.password_reset_token
    ADD CONSTRAINT password_reset_token_pkey PRIMARY KEY (id);


--
-- Name: role_permission role_permission_pkey; Type: CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.role_permission
    ADD CONSTRAINT role_permission_pkey PRIMARY KEY (id);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: user_ user___pkey; Type: CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.user_
    ADD CONSTRAINT user___pkey PRIMARY KEY (pty_id);


--
-- Name: user_location user_location_pkey; Type: CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.user_location
    ADD CONSTRAINT user_location_pkey PRIMARY KEY (id);


--
-- Name: user_role user_role_pkey; Type: CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (id);


--
-- Name: user_ user_user_name; Type: CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.user_
    ADD CONSTRAINT user_user_name UNIQUE (user_name);


--
-- Name: fki_product_attr_lcl_prd_id_fkey; Type: INDEX; Schema: mochi; Owner: mochidb_owner
--

CREATE INDEX fki_product_attr_lcl_prd_id_fkey ON mochi.product_attr_lcl USING btree (prd_id);


--
-- Name: fki_product_shipping_attr_lcl_prd_id_fkey; Type: INDEX; Schema: mochi; Owner: mochidb_owner
--

CREATE INDEX fki_product_shipping_attr_lcl_prd_id_fkey ON mochi.product_shipping_attr_lcl USING btree (prd_id);


--
-- Name: fki_promotion_attr_lcl_prm_id_fkey; Type: INDEX; Schema: mochi; Owner: mochidb_owner
--

CREATE INDEX fki_promotion_attr_lcl_prm_id_fkey ON mochi.promotion_attr_lcl USING btree (prm_id);


--
-- Name: role_role_typ_id_role_start_dttm_party_id_key; Type: INDEX; Schema: mochi; Owner: mochidb_owner
--

CREATE UNIQUE INDEX role_role_typ_id_role_start_dttm_party_id_key ON mochi.role USING btree (rle_typ_id, rle_start_dt, pty_id);


--
-- Name: accessories_attr_lcl accessories_attr_lcl_lcl_cd_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.accessories_attr_lcl
    ADD CONSTRAINT accessories_attr_lcl_lcl_cd_fkey FOREIGN KEY (lcl_cd) REFERENCES mochi.locale(lcl_cd);


--
-- Name: address address_addr_typ_id_address_type_addr_typ_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.address
    ADD CONSTRAINT address_addr_typ_id_address_type_addr_typ_id_fkey FOREIGN KEY (addr_typ_id) REFERENCES mochi.address_type(addr_typ_id);


--
-- Name: address address_pty_id_party_pty_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.address
    ADD CONSTRAINT address_pty_id_party_pty_id_fkey FOREIGN KEY (pty_id) REFERENCES mochi.party(pty_id);


--
-- Name: bag_item bag_item_bag_id_bag_bag_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.bag_item
    ADD CONSTRAINT bag_item_bag_id_bag_bag_id_fkey FOREIGN KEY (bag_id) REFERENCES mochi.bag(bag_id);


--
-- Name: bag_item_disc bag_item_disc_bag_item_id_bag_item_bag_item_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.bag_item_disc
    ADD CONSTRAINT bag_item_disc_bag_item_id_bag_item_bag_item_id_fkey FOREIGN KEY (bag_item_id) REFERENCES mochi.bag_item(bag_item_id);


--
-- Name: bag_item bag_item_sts_id_bag_item_sts_bag_item_sts_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.bag_item
    ADD CONSTRAINT bag_item_sts_id_bag_item_sts_bag_item_sts_id_fkey FOREIGN KEY (bag_item_sts_id) REFERENCES mochi.bag_item_status(bag_item_sts_id);


--
-- Name: bag bag_prm_id_promotion_order_prm_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.bag
    ADD CONSTRAINT bag_prm_id_promotion_order_prm_id_fkey FOREIGN KEY (prm_id) REFERENCES mochi.promotion_order(prm_id);


--
-- Name: bag bag_pty_id_party_pty_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.bag
    ADD CONSTRAINT bag_pty_id_party_pty_id_fkey FOREIGN KEY (pty_id) REFERENCES mochi.party(pty_id);


--
-- Name: brand_attr_lcl brand_attr_lcl_bnd_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.brand_attr_lcl
    ADD CONSTRAINT brand_attr_lcl_bnd_id_fkey FOREIGN KEY (bnd_id) REFERENCES mochi.brand(bnd_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: brand_attr_lcl brand_attr_lcl_lcl_cd_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.brand_attr_lcl
    ADD CONSTRAINT brand_attr_lcl_lcl_cd_fkey FOREIGN KEY (lcl_cd) REFERENCES mochi.locale(lcl_cd);


--
-- Name: brand_category brand_category_bnd_id_brand_bnd_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.brand_category
    ADD CONSTRAINT brand_category_bnd_id_brand_bnd_id_fkey FOREIGN KEY (bnd_id) REFERENCES mochi.brand(bnd_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: brand_category brand_category_cat_id_category_cat_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.brand_category
    ADD CONSTRAINT brand_category_cat_id_category_cat_id_fkey FOREIGN KEY (cat_id) REFERENCES mochi.category(cat_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: category_attr_lcl category_attr_lcl_cat_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.category_attr_lcl
    ADD CONSTRAINT category_attr_lcl_cat_id_fkey FOREIGN KEY (cat_id) REFERENCES mochi.category(cat_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: category_attr_lcl category_attr_lcl_lcl_cd_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.category_attr_lcl
    ADD CONSTRAINT category_attr_lcl_lcl_cd_fkey FOREIGN KEY (lcl_cd) REFERENCES mochi.locale(lcl_cd);


--
-- Name: category_brand category_brand_cat_id_category_cat_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.category_brand
    ADD CONSTRAINT category_brand_cat_id_category_cat_id_fkey FOREIGN KEY (cat_id) REFERENCES mochi.category(cat_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: category_product category_product_cat_id_category_cat_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.category_product
    ADD CONSTRAINT category_product_cat_id_category_cat_id_fkey FOREIGN KEY (cat_id) REFERENCES mochi.category(cat_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: customer customer_role_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.customer
    ADD CONSTRAINT customer_role_id_fkey FOREIGN KEY (rle_id) REFERENCES mochi.role(rle_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: department_attr_lcl department_attr_lcl_dept_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.department_attr_lcl
    ADD CONSTRAINT department_attr_lcl_dept_id_fkey FOREIGN KEY (dept_id) REFERENCES mochi.department(dept_id);


--
-- Name: department_attr_lcl department_attr_lcl_lcl_cd_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.department_attr_lcl
    ADD CONSTRAINT department_attr_lcl_lcl_cd_fkey FOREIGN KEY (lcl_cd) REFERENCES mochi.locale(lcl_cd);


--
-- Name: inventory_transaction inventory_transaction_ccy_id_currency_ccy_id; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.inventory_transaction
    ADD CONSTRAINT inventory_transaction_ccy_id_currency_ccy_id FOREIGN KEY (inv_ccy_id) REFERENCES mochi.currency(ccy_id);


--
-- Name: inventory_transaction inventory_transaction_inv_loc_id_inventory_location_inv_loc_id; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.inventory_transaction
    ADD CONSTRAINT inventory_transaction_inv_loc_id_inventory_location_inv_loc_id FOREIGN KEY (inv_loc_id) REFERENCES mochi.inventory_location(inv_loc_id);


--
-- Name: inventory_transaction inventory_transaction_inv_prd_id_product_prd_id; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.inventory_transaction
    ADD CONSTRAINT inventory_transaction_inv_prd_id_product_prd_id FOREIGN KEY (inv_prd_id) REFERENCES mochi.product(prd_id);


--
-- Name: inventory_transaction inventory_transaction_inv_pty_id_supplier_pty_id; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.inventory_transaction
    ADD CONSTRAINT inventory_transaction_inv_pty_id_supplier_pty_id FOREIGN KEY (inv_pty_id) REFERENCES mochi.party(pty_id);


--
-- Name: inventory_transaction inventory_transaction_inv_trx_typ_id_inventory_transaction_type; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.inventory_transaction
    ADD CONSTRAINT inventory_transaction_inv_trx_typ_id_inventory_transaction_type FOREIGN KEY (inv_trx_typ_id) REFERENCES mochi.inventory_transaction_type(inv_trx_typ_id);


--
-- Name: order_line order_line_order_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.order_line
    ADD CONSTRAINT order_line_order_id_fkey FOREIGN KEY (ord_id) REFERENCES mochi."order"(ord_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: order_line order_line_product_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.order_line
    ADD CONSTRAINT order_line_product_id_fkey FOREIGN KEY (prd_id) REFERENCES mochi.product(prd_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: order orders_party_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi."order"
    ADD CONSTRAINT orders_party_id_fkey FOREIGN KEY (pty_id) REFERENCES mochi.party(pty_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: organisation organisation_org_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.organisation
    ADD CONSTRAINT organisation_org_id_fkey FOREIGN KEY (pty_id) REFERENCES mochi.party(pty_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: party party_pty_typ_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.party
    ADD CONSTRAINT party_pty_typ_id_fkey FOREIGN KEY (pty_typ_id) REFERENCES mochi.party_type(pty_typ_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: person person_person_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.person
    ADD CONSTRAINT person_person_id_fkey FOREIGN KEY (pty_id) REFERENCES mochi.party(pty_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: price price_currency_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.price
    ADD CONSTRAINT price_currency_id_fkey FOREIGN KEY (ccy_id) REFERENCES mochi.currency(ccy_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: price price_product_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.price
    ADD CONSTRAINT price_product_id_fkey FOREIGN KEY (prd_id) REFERENCES mochi.product(prd_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: product_attr_lcl product_attr_lcl_lcl_cd_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_attr_lcl
    ADD CONSTRAINT product_attr_lcl_lcl_cd_fkey FOREIGN KEY (lcl_cd) REFERENCES mochi.locale(lcl_cd);


--
-- Name: product_attr_lcl product_attr_lcl_prd_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_attr_lcl
    ADD CONSTRAINT product_attr_lcl_prd_id_fkey FOREIGN KEY (prd_id) REFERENCES mochi.product(prd_id);


--
-- Name: product_basic product_basic_prd_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_basic
    ADD CONSTRAINT product_basic_prd_id_fkey FOREIGN KEY (prd_id) REFERENCES mochi.product(prd_id);


--
-- Name: product_category product_category_cat_id_category_cat_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_category
    ADD CONSTRAINT product_category_cat_id_category_cat_id_fkey FOREIGN KEY (cat_id) REFERENCES mochi.category(cat_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: product_category product_category_prd_id_product_prd_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_category
    ADD CONSTRAINT product_category_prd_id_product_prd_id_fkey FOREIGN KEY (prd_id) REFERENCES mochi.product(prd_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: product_shipping_attr_lcl product_shipping_attr_lcl_lcl_cd_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_shipping_attr_lcl
    ADD CONSTRAINT product_shipping_attr_lcl_lcl_cd_fkey FOREIGN KEY (lcl_cd) REFERENCES mochi.locale(lcl_cd);


--
-- Name: product_shipping_attr_lcl product_shipping_attr_lcl_prd_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_shipping_attr_lcl
    ADD CONSTRAINT product_shipping_attr_lcl_prd_id_fkey FOREIGN KEY (prd_id) REFERENCES mochi.product_shipping(prd_id);


--
-- Name: product_shipping product_shipping_prd_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_shipping
    ADD CONSTRAINT product_shipping_prd_id_fkey FOREIGN KEY (prd_id) REFERENCES mochi.product(prd_id);


--
-- Name: product product_sts_id_product_status_sts_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product
    ADD CONSTRAINT product_sts_id_product_status_sts_id_fkey FOREIGN KEY (prd_sts_id) REFERENCES mochi.product_status(prd_sts_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: product_tag product_tag_prd_id_product_prd_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_tag
    ADD CONSTRAINT product_tag_prd_id_product_prd_id_fkey FOREIGN KEY (prd_id) REFERENCES mochi.product(prd_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: product_tag product_tag_tag_id_tag_tag_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product_tag
    ADD CONSTRAINT product_tag_tag_id_tag_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES mochi.tag(tag_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: product product_typ_id_product_type_typ_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.product
    ADD CONSTRAINT product_typ_id_product_type_typ_id_fkey FOREIGN KEY (dept_id) REFERENCES mochi.department(dept_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: promotion_attr_lcl promotion_attr_lcl_lcl_cd_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion_attr_lcl
    ADD CONSTRAINT promotion_attr_lcl_lcl_cd_fkey FOREIGN KEY (lcl_cd) REFERENCES mochi.locale(lcl_cd);


--
-- Name: promotion_attr_lcl promotion_attr_lcl_prm_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion_attr_lcl
    ADD CONSTRAINT promotion_attr_lcl_prm_id_fkey FOREIGN KEY (prm_id) REFERENCES mochi.promotion(prm_id);


--
-- Name: promotion_order promotion_coupon_promotion_prm_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion_order
    ADD CONSTRAINT promotion_coupon_promotion_prm_id_fkey FOREIGN KEY (prm_id) REFERENCES mochi.promotion(prm_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: promotion_product promotion_regular_promotion_prm_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.promotion_product
    ADD CONSTRAINT promotion_regular_promotion_prm_id_fkey FOREIGN KEY (prm_id) REFERENCES mochi.promotion(prm_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: role role_party_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.role
    ADD CONSTRAINT role_party_id_fkey FOREIGN KEY (pty_id) REFERENCES mochi.party(pty_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: role role_role_typ_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.role
    ADD CONSTRAINT role_role_typ_id_fkey FOREIGN KEY (rle_typ_id) REFERENCES mochi.role_type(rle_typ_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: stock_on_hand stock_on_hand_prd_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.stock_on_hand
    ADD CONSTRAINT stock_on_hand_prd_id_fkey FOREIGN KEY (soh_prd_id) REFERENCES mochi.product(prd_id);


--
-- Name: supplier supplier_role_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.supplier
    ADD CONSTRAINT supplier_role_id_fkey FOREIGN KEY (rle_id) REFERENCES mochi.role(rle_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: tag_attr_lcl tag_attr_lcl_lcl_cd_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.tag_attr_lcl
    ADD CONSTRAINT tag_attr_lcl_lcl_cd_fkey FOREIGN KEY (lcl_cd) REFERENCES mochi.locale(lcl_cd);


--
-- Name: tag_attr_lcl tag_attr_lcl_tag_id_fkey; Type: FK CONSTRAINT; Schema: mochi; Owner: mochidb_owner
--

ALTER TABLE ONLY mochi.tag_attr_lcl
    ADD CONSTRAINT tag_attr_lcl_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES mochi.tag(tag_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: new_location_token new_location_token_user_location; Type: FK CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.new_location_token
    ADD CONSTRAINT new_location_token_user_location FOREIGN KEY (user_location_id) REFERENCES security.user_location(id);


--
-- Name: password_reset_token password_reset_token_user; Type: FK CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.password_reset_token
    ADD CONSTRAINT password_reset_token_user FOREIGN KEY (pty_id) REFERENCES security.user_(pty_id);


--
-- Name: role_permission role_permission_permission; Type: FK CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.role_permission
    ADD CONSTRAINT role_permission_permission FOREIGN KEY (permission_id) REFERENCES security.permission(id);


--
-- Name: role_permission role_permission_role; Type: FK CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.role_permission
    ADD CONSTRAINT role_permission_role FOREIGN KEY (role_id) REFERENCES security.role(id);


--
-- Name: user_location user_location_user; Type: FK CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.user_location
    ADD CONSTRAINT user_location_user FOREIGN KEY (pty_id) REFERENCES security.user_(pty_id);


--
-- Name: user_role user_role_role; Type: FK CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.user_role
    ADD CONSTRAINT user_role_role FOREIGN KEY (role_id) REFERENCES security.role(id);


--
-- Name: user_role user_role_user_; Type: FK CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.user_role
    ADD CONSTRAINT user_role_user_ FOREIGN KEY (pty_id) REFERENCES security.user_(pty_id);


--
-- Name: verification_token verification_token_user; Type: FK CONSTRAINT; Schema: security; Owner: security_owner
--

ALTER TABLE ONLY security.verification_token
    ADD CONSTRAINT verification_token_user FOREIGN KEY (pty_id) REFERENCES security.user_(pty_id);


--
-- Name: DATABASE mochidb; Type: ACL; Schema: -; Owner: postgres
--

GRANT CREATE ON DATABASE mochidb TO security_owner;


--
-- Name: SCHEMA mochi; Type: ACL; Schema: -; Owner: mochidb_owner
--

GRANT USAGE ON SCHEMA mochi TO mochi_app;
GRANT USAGE ON SCHEMA mochi TO security_app;
GRANT ALL ON SCHEMA mochi TO security_owner;


--
-- Name: SCHEMA security; Type: ACL; Schema: -; Owner: security_owner
--

GRANT USAGE ON SCHEMA security TO security_app;
GRANT USAGE ON SCHEMA security TO mochi_app;


--
-- Name: SEQUENCE accessories_attr_lcl_prd_lcl_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.accessories_attr_lcl_prd_lcl_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.accessories_attr_lcl_prd_lcl_id_seq TO mochidb_owner;


--
-- Name: TABLE accessories_attr_lcl; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.accessories_attr_lcl TO mochi_app;


--
-- Name: SEQUENCE address_addr_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.address_addr_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.address_addr_id_seq TO mochidb_owner;


--
-- Name: TABLE address; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.address TO mochi_app;


--
-- Name: SEQUENCE address_type_addr_typ_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.address_type_addr_typ_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.address_type_addr_typ_id_seq TO mochidb_owner;


--
-- Name: TABLE address_type; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.address_type TO mochi_app;


--
-- Name: SEQUENCE bag_bag_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.bag_bag_id_seq TO mochi_app;


--
-- Name: TABLE bag; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.bag TO mochi_app;


--
-- Name: SEQUENCE bag_item_bag_item_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.bag_item_bag_item_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.bag_item_bag_item_id_seq TO mochidb_owner;


--
-- Name: TABLE bag_item; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.bag_item TO mochi_app;


--
-- Name: SEQUENCE bag_item_disc_bag_item_disc_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.bag_item_disc_bag_item_disc_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.bag_item_disc_bag_item_disc_id_seq TO mochidb_owner;


--
-- Name: TABLE bag_item_disc; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.bag_item_disc TO mochi_app;


--
-- Name: SEQUENCE bag_item_status_bag_item_sts_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.bag_item_status_bag_item_sts_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.bag_item_status_bag_item_sts_id_seq TO mochidb_owner;


--
-- Name: TABLE bag_item_status; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.bag_item_status TO mochi_app;


--
-- Name: SEQUENCE brand_bnd_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.brand_bnd_id_seq TO mochi_app;


--
-- Name: TABLE brand; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.brand TO mochi_app;


--
-- Name: SEQUENCE brand_attr_lcl_bnd_lcl_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.brand_attr_lcl_bnd_lcl_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.brand_attr_lcl_bnd_lcl_id_seq TO mochidb_owner;


--
-- Name: TABLE brand_attr_lcl; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.brand_attr_lcl TO mochi_app;


--
-- Name: SEQUENCE brand_attr_lcl_bnd_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.brand_attr_lcl_bnd_id_seq TO mochi_app;


--
-- Name: SEQUENCE brand_category_bnd_cat_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.brand_category_bnd_cat_id_seq TO mochi_app;


--
-- Name: TABLE brand_category; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.brand_category TO mochi_app;


--
-- Name: SEQUENCE brand_promotion_bnd_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.brand_promotion_bnd_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.brand_promotion_bnd_id_seq TO mochidb_owner;


--
-- Name: SEQUENCE brand_promotion_prm_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.brand_promotion_prm_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.brand_promotion_prm_id_seq TO mochidb_owner;


--
-- Name: SEQUENCE category_cat_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.category_cat_id_seq TO mochi_app;


--
-- Name: TABLE category; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.category TO mochi_app;


--
-- Name: SEQUENCE category_attr_lcl_cat_lcl_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.category_attr_lcl_cat_lcl_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.category_attr_lcl_cat_lcl_id_seq TO mochidb_owner;


--
-- Name: TABLE category_attr_lcl; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.category_attr_lcl TO mochi_app;


--
-- Name: SEQUENCE category_brand_cat_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.category_brand_cat_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.category_brand_cat_id_seq TO mochidb_owner;


--
-- Name: TABLE category_brand; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.category_brand TO mochi_app;


--
-- Name: SEQUENCE category_product_cat_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.category_product_cat_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.category_product_cat_id_seq TO mochidb_owner;


--
-- Name: TABLE category_product; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.category_product TO mochi_app;


--
-- Name: SEQUENCE category_promotion_cat_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.category_promotion_cat_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.category_promotion_cat_id_seq TO mochidb_owner;


--
-- Name: SEQUENCE category_promotion_prm_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.category_promotion_prm_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.category_promotion_prm_id_seq TO mochidb_owner;


--
-- Name: TABLE category_promotion; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.category_promotion TO mochi_app;


--
-- Name: SEQUENCE category_type_cat_typ_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.category_type_cat_typ_id_seq TO mochi_app;


--
-- Name: TABLE category_type; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.category_type TO mochi_app;


--
-- Name: SEQUENCE currency_ccy_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.currency_ccy_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.currency_ccy_id_seq TO mochidb_owner;


--
-- Name: TABLE currency; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.currency TO mochi_app;


--
-- Name: SEQUENCE customer_cst_num_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.customer_cst_num_seq TO mochi_app;


--
-- Name: SEQUENCE customer_rle_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.customer_rle_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.customer_rle_id_seq TO mochidb_owner;


--
-- Name: TABLE customer; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT ON TABLE mochi.customer TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.customer TO mochi_app;


--
-- Name: SEQUENCE department_dept_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.department_dept_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.department_dept_id_seq TO mochidb_owner;


--
-- Name: TABLE department; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.department TO mochi_app;


--
-- Name: SEQUENCE department_attr_lcl_dept_lcl_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.department_attr_lcl_dept_lcl_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.department_attr_lcl_dept_lcl_id_seq TO mochidb_owner;


--
-- Name: TABLE department_attr_lcl; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.department_attr_lcl TO mochi_app;


--
-- Name: SEQUENCE discount_dis_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.discount_dis_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.discount_dis_id_seq TO mochidb_owner;


--
-- Name: TABLE discount; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.discount TO mochi_app;


--
-- Name: SEQUENCE discount_type_dis_typ_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.discount_type_dis_typ_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.discount_type_dis_typ_id_seq TO mochidb_owner;


--
-- Name: TABLE discount_type; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.discount_type TO mochi_app;


--
-- Name: SEQUENCE inventory_location_inv_loc_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.inventory_location_inv_loc_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.inventory_location_inv_loc_id_seq TO mochidb_owner;


--
-- Name: TABLE inventory_location; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.inventory_location TO mochi_app;


--
-- Name: SEQUENCE inventory_transaction_inv_trx_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.inventory_transaction_inv_trx_id_seq TO mochi_app;


--
-- Name: TABLE inventory_transaction; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.inventory_transaction TO mochi_app;


--
-- Name: SEQUENCE inventory_transaction_type_inv_trx_typ_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.inventory_transaction_type_inv_trx_typ_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.inventory_transaction_type_inv_trx_typ_id_seq TO mochidb_owner;


--
-- Name: TABLE inventory_transaction_type; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.inventory_transaction_type TO mochi_app;


--
-- Name: SEQUENCE locale_lcl_cd_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.locale_lcl_cd_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.locale_lcl_cd_seq TO mochidb_owner;


--
-- Name: TABLE locale; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.locale TO mochi_app;


--
-- Name: SEQUENCE order_ord_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.order_ord_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.order_ord_id_seq TO mochidb_owner;


--
-- Name: TABLE "order"; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi."order" TO mochi_app;


--
-- Name: SEQUENCE order_line_ord_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.order_line_ord_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.order_line_ord_id_seq TO mochidb_owner;


--
-- Name: SEQUENCE order_line_ord_lne_no_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.order_line_ord_lne_no_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.order_line_ord_lne_no_seq TO mochidb_owner;


--
-- Name: SEQUENCE order_line_prd_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.order_line_prd_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.order_line_prd_id_seq TO mochidb_owner;


--
-- Name: TABLE order_line; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.order_line TO mochi_app;


--
-- Name: TABLE organisation; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT ON TABLE mochi.organisation TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.organisation TO mochi_app;


--
-- Name: TABLE party; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT ON TABLE mochi.party TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.party TO mochi_app;


--
-- Name: SEQUENCE party_pty_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.party_pty_id_seq TO mochi_app;


--
-- Name: TABLE party_type; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT ON TABLE mochi.party_type TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.party_type TO mochi_app;


--
-- Name: SEQUENCE party_type_pty_typ_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.party_type_pty_typ_id_seq TO mochi_app;


--
-- Name: TABLE person; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT ON TABLE mochi.person TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.person TO mochi_app;


--
-- Name: SEQUENCE price_prc_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.price_prc_id_seq TO mochi_app;


--
-- Name: TABLE price; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.price TO mochi_app;


--
-- Name: SEQUENCE price_type_prc_typ_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.price_type_prc_typ_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.price_type_prc_typ_id_seq TO mochidb_owner;


--
-- Name: TABLE price_type; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.price_type TO mochi_app;


--
-- Name: SEQUENCE product_prd_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.product_prd_id_seq TO mochi_app;


--
-- Name: TABLE product; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.product TO mochi_app;


--
-- Name: SEQUENCE product_attr_lcl_prd_lcl_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.product_attr_lcl_prd_lcl_id_seq TO mochi_app;


--
-- Name: TABLE product_attr_lcl; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.product_attr_lcl TO mochi_app;


--
-- Name: SEQUENCE product_basic_prd_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.product_basic_prd_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.product_basic_prd_id_seq TO mochidb_owner;


--
-- Name: TABLE product_basic; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.product_basic TO mochi_app;


--
-- Name: SEQUENCE product_category_prd_cat_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.product_category_prd_cat_id_seq TO mochi_app;


--
-- Name: TABLE product_category; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.product_category TO mochi_app;


--
-- Name: SEQUENCE product_promotion_prd_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.product_promotion_prd_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.product_promotion_prd_id_seq TO mochidb_owner;


--
-- Name: SEQUENCE product_promotion_prm_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.product_promotion_prm_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.product_promotion_prm_id_seq TO mochidb_owner;


--
-- Name: TABLE product_promotion; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.product_promotion TO mochi_app;


--
-- Name: SEQUENCE product_rating_prd_rat_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.product_rating_prd_rat_id_seq TO mochi_app;


--
-- Name: TABLE product_rating; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.product_rating TO mochi_app;


--
-- Name: SEQUENCE product_shipping_prd_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.product_shipping_prd_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.product_shipping_prd_id_seq TO mochidb_owner;


--
-- Name: TABLE product_shipping; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.product_shipping TO mochi_app;


--
-- Name: SEQUENCE product_shipping_attr_lcl_prd_lcl_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.product_shipping_attr_lcl_prd_lcl_id_seq TO mochi_app;


--
-- Name: TABLE product_shipping_attr_lcl; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.product_shipping_attr_lcl TO mochi_app;


--
-- Name: SEQUENCE product_status_prd_sts_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.product_status_prd_sts_id_seq TO mochi_app;


--
-- Name: TABLE product_status; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.product_status TO mochi_app;


--
-- Name: TABLE product_supplier; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.product_supplier TO mochi_app;


--
-- Name: SEQUENCE product_tag_prd_tag_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.product_tag_prd_tag_id_seq TO mochi_app;


--
-- Name: TABLE product_tag; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.product_tag TO mochi_app;


--
-- Name: SEQUENCE promotion_prm_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.promotion_prm_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.promotion_prm_id_seq TO mochidb_owner;


--
-- Name: TABLE promotion; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.promotion TO mochi_app;


--
-- Name: SEQUENCE promotion_attr_lcl_prm_lcl_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.promotion_attr_lcl_prm_lcl_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.promotion_attr_lcl_prm_lcl_id_seq TO mochidb_owner;


--
-- Name: TABLE promotion_attr_lcl; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.promotion_attr_lcl TO mochi_app;


--
-- Name: SEQUENCE promotion_level_prm_lvl_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.promotion_level_prm_lvl_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.promotion_level_prm_lvl_id_seq TO mochidb_owner;


--
-- Name: TABLE promotion_level; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.promotion_level TO mochi_app;


--
-- Name: SEQUENCE promotion_mechanic_prm_mec_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.promotion_mechanic_prm_mec_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.promotion_mechanic_prm_mec_id_seq TO mochidb_owner;


--
-- Name: TABLE promotion_mechanic; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.promotion_mechanic TO mochi_app;


--
-- Name: SEQUENCE promotion_order_prm_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.promotion_order_prm_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.promotion_order_prm_id_seq TO mochidb_owner;


--
-- Name: TABLE promotion_order; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.promotion_order TO mochi_app;


--
-- Name: SEQUENCE promotion_product_prm_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.promotion_product_prm_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.promotion_product_prm_id_seq TO mochidb_owner;


--
-- Name: TABLE promotion_product; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.promotion_product TO mochi_app;


--
-- Name: SEQUENCE promotion_type_prm_typ_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.promotion_type_prm_typ_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.promotion_type_prm_typ_id_seq TO mochidb_owner;


--
-- Name: TABLE promotion_type; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.promotion_type TO mochi_app;


--
-- Name: SEQUENCE rating_rat_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.rating_rat_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.rating_rat_id_seq TO mochidb_owner;


--
-- Name: TABLE rating; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.rating TO mochi_app;


--
-- Name: SEQUENCE role_rle_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.role_rle_id_seq TO mochi_app;


--
-- Name: TABLE role; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT ON TABLE mochi.role TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.role TO mochi_app;


--
-- Name: TABLE role_type; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT ON TABLE mochi.role_type TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.role_type TO mochi_app;


--
-- Name: SEQUENCE role_type_rle_typ_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.role_type_rle_typ_id_seq TO mochi_app;


--
-- Name: SEQUENCE stock_on_hand_soh_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.stock_on_hand_soh_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.stock_on_hand_soh_id_seq TO mochidb_owner;


--
-- Name: TABLE stock_on_hand; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.stock_on_hand TO mochi_app;


--
-- Name: SEQUENCE supplier_rle_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.supplier_rle_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.supplier_rle_id_seq TO mochidb_owner;


--
-- Name: SEQUENCE supplier_sup_num_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.supplier_sup_num_seq TO mochi_app;


--
-- Name: TABLE supplier; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.supplier TO mochi_app;


--
-- Name: SEQUENCE tag_tag_id_seq; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT ALL ON SEQUENCE mochi.tag_tag_id_seq TO mochi_app;


--
-- Name: TABLE tag; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.tag TO mochi_app;


--
-- Name: SEQUENCE tag_attr_lcl_tag_lcl_id_seq; Type: ACL; Schema: mochi; Owner: postgres
--

GRANT ALL ON SEQUENCE mochi.tag_attr_lcl_tag_lcl_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE mochi.tag_attr_lcl_tag_lcl_id_seq TO mochidb_owner;


--
-- Name: TABLE tag_attr_lcl; Type: ACL; Schema: mochi; Owner: mochidb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mochi.tag_attr_lcl TO mochi_app;


--
-- Name: TABLE permission; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.permission TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.permission TO mochi_app;


--
-- Name: SEQUENCE authority_id_seq; Type: ACL; Schema: security; Owner: security_owner
--

GRANT ALL ON SEQUENCE security.authority_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE security.authority_id_seq TO security_app;


--
-- Name: TABLE clientdetails; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.clientdetails TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.clientdetails TO mochi_app;


--
-- Name: TABLE device_metadata; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.device_metadata TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.device_metadata TO mochi_app;


--
-- Name: SEQUENCE hibernate_sequence; Type: ACL; Schema: security; Owner: security_owner
--

GRANT ALL ON SEQUENCE security.hibernate_sequence TO mochi_app;
GRANT ALL ON SEQUENCE security.hibernate_sequence TO security_app;


--
-- Name: TABLE new_location_token; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.new_location_token TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.new_location_token TO mochi_app;


--
-- Name: TABLE oauth_access_token; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.oauth_access_token TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.oauth_access_token TO mochi_app;


--
-- Name: TABLE oauth_approvals; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.oauth_approvals TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.oauth_approvals TO mochi_app;


--
-- Name: TABLE oauth_client_details; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.oauth_client_details TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.oauth_client_details TO mochi_app;


--
-- Name: TABLE oauth_client_token; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.oauth_client_token TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.oauth_client_token TO mochi_app;


--
-- Name: TABLE oauth_code; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.oauth_code TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.oauth_code TO mochi_app;


--
-- Name: TABLE oauth_refresh_token; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.oauth_refresh_token TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.oauth_refresh_token TO mochi_app;


--
-- Name: TABLE password_reset_token; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.password_reset_token TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.password_reset_token TO mochi_app;


--
-- Name: SEQUENCE role_id_seq; Type: ACL; Schema: security; Owner: security_owner
--

GRANT ALL ON SEQUENCE security.role_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE security.role_id_seq TO security_app;


--
-- Name: TABLE role; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.role TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.role TO mochi_app;


--
-- Name: SEQUENCE role_permission_id_seq; Type: ACL; Schema: security; Owner: security_owner
--

GRANT ALL ON SEQUENCE security.role_permission_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE security.role_permission_id_seq TO security_app;


--
-- Name: TABLE role_permission; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.role_permission TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.role_permission TO mochi_app;


--
-- Name: TABLE user_; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.user_ TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.user_ TO mochi_app;


--
-- Name: TABLE user_location; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.user_location TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.user_location TO mochi_app;


--
-- Name: SEQUENCE user_role_id_seq; Type: ACL; Schema: security; Owner: security_owner
--

GRANT ALL ON SEQUENCE security.user_role_id_seq TO mochi_app;
GRANT ALL ON SEQUENCE security.user_role_id_seq TO security_app;


--
-- Name: TABLE user_role; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.user_role TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.user_role TO mochi_app;


--
-- Name: TABLE verification_token; Type: ACL; Schema: security; Owner: security_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.verification_token TO security_app;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE security.verification_token TO mochi_app;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4 (Ubuntu 14.4-1.pgdg20.04+1)
-- Dumped by pg_dump version 14.4 (Ubuntu 14.4-1.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

