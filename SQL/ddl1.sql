-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.3-alpha_snapshot20200131
-- PostgreSQL version: 12.0
-- Project Site: pgmodeler.io
-- Model Author: Claude Breazu (100860542)


-- Database creation must be done outside a multicommand file.
-- These commands were put in this file only as a convenience.
-- -- object: "Bookstore_02" | type: DATABASE --
-- -- DROP DATABASE IF EXISTS "Bookstore_02";
-- CREATE DATABASE "Bookstore_02";
-- -- ddl-end --
-- 

-- object: public.book | type: TABLE --
-- DROP TABLE IF EXISTS public.book CASCADE;
CREATE TABLE public.book (
	book_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	publisher_id integer NOT NULL,
	author_id integer NOT NULL,
	genre_id smallint NOT NULL,
	name varchar(100) NOT NULL,
	"ISBN" varchar(50) NOT NULL,
	price numeric(6,2) NOT NULL,
	number_of_pages integer NOT NULL,
	quantity integer,
	publisher_share numeric(5,2) NOT NULL,
	retired_from_sale_yn boolean,
	CONSTRAINT "Book_pk" PRIMARY KEY (book_id)

);
-- ddl-end --
ALTER TABLE public.book OWNER TO postgres;
-- ddl-end --

-- object: public.genre | type: TABLE --
-- DROP TABLE IF EXISTS public.genre CASCADE;
CREATE TABLE public.genre (
	genre_id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	name varchar(100) NOT NULL,
	CONSTRAINT genre_type_pk PRIMARY KEY (genre_id)

);
-- ddl-end --
ALTER TABLE public.genre OWNER TO postgres;
-- ddl-end --

-- object: genre_fk | type: CONSTRAINT --
-- ALTER TABLE public.book DROP CONSTRAINT IF EXISTS genre_fk CASCADE;
ALTER TABLE public.book ADD CONSTRAINT genre_fk FOREIGN KEY (genre_id)
REFERENCES public.genre (genre_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.author | type: TABLE --
-- DROP TABLE IF EXISTS public.author CASCADE;
CREATE TABLE public.author (
	author_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	name varchar(100) NOT NULL,
	CONSTRAINT author_pk PRIMARY KEY (author_id)

);
-- ddl-end --
ALTER TABLE public.author OWNER TO postgres;
-- ddl-end --

-- object: public.publisher | type: TABLE --
-- DROP TABLE IF EXISTS public.publisher CASCADE;
CREATE TABLE public.publisher (
	publisher_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	name varchar(100),
	bank_account numeric(20,2),
	email_address varchar(20),
	address_line1 varchar(20),
	city varchar(50),
	province varchar(50),
	postal_code varchar(6),
	CONSTRAINT publisher_pk PRIMARY KEY (publisher_id)

);
-- ddl-end --
ALTER TABLE public.publisher OWNER TO postgres;
-- ddl-end --

-- object: publisher_fk | type: CONSTRAINT --
-- ALTER TABLE public.book DROP CONSTRAINT IF EXISTS publisher_fk CASCADE;
ALTER TABLE public.book ADD CONSTRAINT publisher_fk FOREIGN KEY (publisher_id)
REFERENCES public.publisher (publisher_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public."user" | type: TABLE --
-- DROP TABLE IF EXISTS public."user" CASCADE;
CREATE TABLE public."user" (
	user_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	full_name varchar(100),
	registered_yn boolean,
	CONSTRAINT user_pk PRIMARY KEY (user_id)

);
-- ddl-end --
ALTER TABLE public."user" OWNER TO postgres;
-- ddl-end --

-- object: public.address | type: TABLE --
-- DROP TABLE IF EXISTS public.address CASCADE;
CREATE TABLE public.address (
	address_type_id smallint NOT NULL,
	user_id integer NOT NULL,
	street_line1 varchar(100) NOT NULL,
	city varchar(50),
	province varchar(50),
	postal_code varchar(6) NOT NULL,
	CONSTRAINT address_pk PRIMARY KEY (address_type_id,user_id)

);
-- ddl-end --
ALTER TABLE public.address OWNER TO postgres;
-- ddl-end --

-- object: public.address_type | type: TABLE --
-- DROP TABLE IF EXISTS public.address_type CASCADE;
CREATE TABLE public.address_type (
	address_type_id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	name varchar(100) NOT NULL,
	CONSTRAINT address_type_pk PRIMARY KEY (address_type_id)

);
-- ddl-end --
ALTER TABLE public.address_type OWNER TO postgres;
-- ddl-end --

-- object: address_type_fk | type: CONSTRAINT --
-- ALTER TABLE public.address DROP CONSTRAINT IF EXISTS address_type_fk CASCADE;
ALTER TABLE public.address ADD CONSTRAINT address_type_fk FOREIGN KEY (address_type_id)
REFERENCES public.address_type (address_type_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: user_fk | type: CONSTRAINT --
-- ALTER TABLE public.address DROP CONSTRAINT IF EXISTS user_fk CASCADE;
ALTER TABLE public.address ADD CONSTRAINT user_fk FOREIGN KEY (user_id)
REFERENCES public."user" (user_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: public."order" | type: TABLE --
-- DROP TABLE IF EXISTS public."order" CASCADE;
CREATE TABLE public."order" (
	order_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	user_id integer NOT NULL,
	order_state_id smallint NOT NULL,
	order_date date NOT NULL,
	tracking_number integer,
	shipping_date date,
	delivery_date date,
	cancellation_date date,
	publisher_paid_yn boolean DEFAULT false,
	street_line1 varchar(100),
	city varchar(50),
	province varchar(50),
	postal_code varchar(6),
	CONSTRAINT order_pk PRIMARY KEY (order_id)

);
-- ddl-end --
ALTER TABLE public."order" OWNER TO postgres;
-- ddl-end --

-- object: user_fk | type: CONSTRAINT --
-- ALTER TABLE public."order" DROP CONSTRAINT IF EXISTS user_fk CASCADE;
ALTER TABLE public."order" ADD CONSTRAINT user_fk FOREIGN KEY (user_id)
REFERENCES public."user" (user_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.order_state | type: TABLE --
-- DROP TABLE IF EXISTS public.order_state CASCADE;
CREATE TABLE public.order_state (
	order_state_id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	name varchar(50) NOT NULL,
	CONSTRAINT order_state_pk PRIMARY KEY (order_state_id)

);
-- ddl-end --
ALTER TABLE public.order_state OWNER TO postgres;
-- ddl-end --

-- object: order_state_fk | type: CONSTRAINT --
-- ALTER TABLE public."order" DROP CONSTRAINT IF EXISTS order_state_fk CASCADE;
ALTER TABLE public."order" ADD CONSTRAINT order_state_fk FOREIGN KEY (order_state_id)
REFERENCES public.order_state (order_state_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.user_basket | type: TABLE --
-- DROP TABLE IF EXISTS public.user_basket CASCADE;
CREATE TABLE public.user_basket (
	book_id integer NOT NULL,
	user_id integer NOT NULL,
	CONSTRAINT user_basket_pk PRIMARY KEY (book_id,user_id)

);
-- ddl-end --
ALTER TABLE public.user_basket OWNER TO postgres;
-- ddl-end --

-- object: book_fk | type: CONSTRAINT --
-- ALTER TABLE public.user_basket DROP CONSTRAINT IF EXISTS book_fk CASCADE;
ALTER TABLE public.user_basket ADD CONSTRAINT book_fk FOREIGN KEY (book_id)
REFERENCES public.book (book_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: public.tracking_number | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.tracking_number CASCADE;
CREATE SEQUENCE public.tracking_number
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE public.tracking_number OWNER TO postgres;
-- ddl-end --

-- object: public.phone_number | type: TABLE --
-- DROP TABLE IF EXISTS public.phone_number CASCADE;
CREATE TABLE public.phone_number (
	phone_number_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	publisher_id integer NOT NULL,
	phone_number varchar(10),
	CONSTRAINT phone_number_pk PRIMARY KEY (phone_number_id)

);
-- ddl-end --
ALTER TABLE public.phone_number OWNER TO postgres;
-- ddl-end --

-- object: publisher_fk | type: CONSTRAINT --
-- ALTER TABLE public.phone_number DROP CONSTRAINT IF EXISTS publisher_fk CASCADE;
ALTER TABLE public.phone_number ADD CONSTRAINT publisher_fk FOREIGN KEY (publisher_id)
REFERENCES public.publisher (publisher_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: author_fk | type: CONSTRAINT --
-- ALTER TABLE public.book DROP CONSTRAINT IF EXISTS author_fk CASCADE;
ALTER TABLE public.book ADD CONSTRAINT author_fk FOREIGN KEY (author_id)
REFERENCES public.author (author_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: user_fk | type: CONSTRAINT --
-- ALTER TABLE public.user_basket DROP CONSTRAINT IF EXISTS user_fk CASCADE;
ALTER TABLE public.user_basket ADD CONSTRAINT user_fk FOREIGN KEY (user_id)
REFERENCES public."user" (user_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: basket_unique_user_and_book | type: CONSTRAINT --
-- ALTER TABLE public.user_basket DROP CONSTRAINT IF EXISTS basket_unique_user_and_book CASCADE;
ALTER TABLE public.user_basket ADD CONSTRAINT basket_unique_user_and_book UNIQUE (book_id,user_id);
-- ddl-end --

-- object: public.order_book | type: TABLE --
-- DROP TABLE IF EXISTS public.order_book CASCADE;
CREATE TABLE public.order_book (
	order_id integer NOT NULL,
	book_id integer NOT NULL,
	CONSTRAINT order_book_pk PRIMARY KEY (order_id,book_id)

);
-- ddl-end --
ALTER TABLE public.order_book OWNER TO postgres;
-- ddl-end --

-- object: order_fk | type: CONSTRAINT --
-- ALTER TABLE public.order_book DROP CONSTRAINT IF EXISTS order_fk CASCADE;
ALTER TABLE public.order_book ADD CONSTRAINT order_fk FOREIGN KEY (order_id)
REFERENCES public."order" (order_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: book_fk | type: CONSTRAINT --
-- ALTER TABLE public.order_book DROP CONSTRAINT IF EXISTS book_fk CASCADE;
ALTER TABLE public.order_book ADD CONSTRAINT book_fk FOREIGN KEY (book_id)
REFERENCES public.book (book_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --


