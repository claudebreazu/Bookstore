TRUNCATE TABLE phone_number RESTART IDENTITY CASCADE;
TRUNCATE TABLE user_basket RESTART IDENTITY CASCADE;
TRUNCATE TABLE order_book RESTART IDENTITY CASCADE;
TRUNCATE TABLE book RESTART IDENTITY CASCADE;
TRUNCATE TABLE publisher RESTART IDENTITY CASCADE;
TRUNCATE TABLE genre RESTART IDENTITY CASCADE;
TRUNCATE TABLE author RESTART IDENTITY CASCADE;
TRUNCATE TABLE order_state RESTART IDENTITY CASCADE;
TRUNCATE TABLE address RESTART IDENTITY CASCADE;
TRUNCATE TABLE address_type RESTART IDENTITY CASCADE;
TRUNCATE TABLE public."user" RESTART IDENTITY CASCADE;
TRUNCATE TABLE public."order" RESTART IDENTITY CASCADE;



-- address_type ----------------------------------
INSERT INTO public.address_type (name) VALUES ('Registration'); --1
INSERT INTO public.address_type (name) VALUES ('Mailing');		--2
INSERT INTO public.address_type (name) VALUES ('Billing');		--3

---- order_state -----
INSERT INTO public.order_state (name) VALUES ('Initiated');	--1
INSERT INTO public.order_state (name) VALUES ('Shipped');	--2
INSERT INTO public.order_state (name) VALUES ('Delivered');	--3

---- genre type ----
INSERT INTO public.genre (name) VALUES ('Adventure');	--1
INSERT INTO public.genre (name) VALUES ('Romance');		--2
INSERT INTO public.genre (name) VALUES ('Travel');		--3
INSERT INTO public.genre (name) VALUES ('Gardening');	--4

--- publisher
INSERT INTO public.publisher (name, bank_account, email_address, address_line1, city, province, postal_code) VALUES ('Amazon', 0, 'amazon@amazon.com', '100 Amazon Way', 'Montreal', 'Quebec', 'L5D3V3');
INSERT INTO public.publisher (name, bank_account, email_address, address_line1, city, province, postal_code) VALUES ('Indigo', 0, 'indigo@indigo.com', '200 Indigo Way', 'Toronto', 'Ontario', 'G3Q9F4');
INSERT INTO public.publisher (name, bank_account, email_address, address_line1, city, province, postal_code) VALUES ('Microsoft Press', 0, 'mp@microsoft.com', '50 Microsoft Way', 'Ottawa', 'Ontario', 'K4C5G8');



---- phone_number ------
insert into phone_number (publisher_id, phone_number) values (1, '6135999342');
insert into phone_number (publisher_id, phone_number) values (1, '6135999343');
insert into phone_number (publisher_id, phone_number) values (2, '6139999999');
insert into phone_number (publisher_id, phone_number) values (3, '6135551540');
insert into phone_number (publisher_id, phone_number) values (3, '6135551541');



--- author  ---------
INSERT INTO public.author (name) VALUES ('Ionut Filip');
INSERT INTO public.author (name) VALUES ('Petru Acsinte');
INSERT INTO public.author (name) VALUES ('Claude Breazu');
INSERT INTO public.author (name) VALUES ('Roxana Manoiu');
INSERT INTO public.author (name) VALUES ('Andrei Georgescu');
INSERT INTO public.author (name) VALUES ('Andrew Tricomi');
INSERT INTO public.author (name) VALUES ('Teddy Bear');
INSERT INTO public.author (name) VALUES ('Tom Cruise');

--- book -----
INSERT INTO public.book (publisher_id, author_id, genre_id, name, "ISBN", price, number_of_pages, quantity, publisher_share, retired_from_sale_yn) VALUES (1, 1, 1, 'The Way Back', 'ISBN 100', 50, 500, 100, 20, false);
INSERT INTO public.book (publisher_id, author_id, genre_id, name, "ISBN", price, number_of_pages, quantity, publisher_share, retired_from_sale_yn) VALUES (2, 2, 2, 'Love story', 'ISBN 110', 60, 300, 100, 20, false);
INSERT INTO public.book (publisher_id, author_id, genre_id, name, "ISBN", price, number_of_pages, quantity, publisher_share, retired_from_sale_yn) VALUES (3, 3, 3, 'Travelling Alone', 'ISBN 200', 70, 400, 100, 20, false);
INSERT INTO public.book (publisher_id, author_id, genre_id, name, "ISBN", price, number_of_pages, quantity, publisher_share, retired_from_sale_yn) VALUES (1, 4, 4, 'Growing Flowers', 'ISBN 210', 80, 100, 100, 20, false);
INSERT INTO public.book (publisher_id, author_id, genre_id, name, "ISBN", price, number_of_pages, quantity, publisher_share, retired_from_sale_yn) VALUES (1, 5, 1, 'Difficult Road', 'ISBN 300', 45, 400, 100, 20, false);
INSERT INTO public.book (publisher_id, author_id, genre_id, name, "ISBN", price, number_of_pages, quantity, publisher_share, retired_from_sale_yn) VALUES (3, 5, 1, 'Life of Ion', 'ISBN 303', 30, 410, 100, 20, false);

---- user ----------------------------------------------
INSERT INTO public."user" (full_name, registered_yn) VALUES ('John Travolta', true);
INSERT INTO public."user" (full_name, registered_yn) VALUES ('Justin Beber', false);
INSERT INTO public."user" (full_name, registered_yn) VALUES ('John Klein', true);
INSERT INTO public."user" (full_name, registered_yn) VALUES ('Robert De Niro', true);
INSERT INTO public."user" (full_name, registered_yn) VALUES ('James Bond', true);
INSERT INTO public."user" (full_name, registered_yn) VALUES ('Tricky Tricomi', true);
INSERT INTO public."user" (full_name, registered_yn) VALUES ('Danny Panaite', true);

---- address ------
insert into address (street_line1, city, province, postal_code, user_id, address_type_id) values ('420 Warmstone','Ottawa', 'Ontario', 'K2S0W2', 1, 1);
insert into address (street_line1, city, province, postal_code, user_id, address_type_id) values ('7 Cecil Walden Ridge', 'Kanata', 'Ontario', 'K2S0W2', 2, 1);
insert into address (street_line1, city, province, postal_code, user_id, address_type_id) values ('1200 Gouin',  'Montreal', 'Quebec', 'K2S0W2', 3, 1);
insert into address (street_line1, city, province, postal_code, user_id, address_type_id) values ('120 Gladstone','Ottawa', 'Ontario', 'K2S0T4', 4, 1);
insert into address (street_line1, city, province, postal_code, user_id, address_type_id) values ('180 Kent', 'Ottawa', 'Ontario', 'K2S0E4', 5, 1);
insert into address (street_line1, city, province, postal_code, user_id, address_type_id) values ('300 Laurier',  'Montreal', 'Quebec', 'J2S0W2', 6, 1);
insert into address (street_line1, city, province, postal_code, user_id, address_type_id) values ('300 Qeen',  'Montreal', 'Quebec', 'J9S0W2', 7, 1);

select * from public.user;

--- order ----
--->> John Travolta ------------------
-- OCT 2019
INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (1, 3, '2019/10/01', 68395, '2019/10/01', '2019/10/05', null, false, '420 Warmstone','Ottawa', 'Ontario', 'K2S0W2');
INSERT INTO public.order_book (order_id, book_id) VALUES (1,1);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (1, 3, '2019/10/02', 68397, '2019/10/02', '2019/10/06', null, false, '420 Warmstone','Ottawa', 'Ontario', 'K2S0W2');
INSERT INTO public.order_book (order_id, book_id) VALUES (2,2);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (1, 3, '2019/10/03', 68398, '2019/10/03', '2019/10/07', null, false, '420 Warmstone','Ottawa', 'Ontario', 'K2S0W2');
INSERT INTO public.order_book (order_id, book_id) VALUES (3,3);


--NOV 2019
INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (1, 3, '2019/11/01', 68399, '2019/11/01', '2019/11/05', null, false, '420 Warmstone','Ottawa', 'Ontario', 'K2S0W2');
INSERT INTO public.order_book (order_id, book_id) VALUES (4,4);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (1, 3, '2019/11/02', 68400, '2019/10/02', '2019/10/06', null, false, '420 Warmstone','Ottawa', 'Ontario', 'K2S0W2');
INSERT INTO public.order_book (order_id, book_id) VALUES (5,5);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (1, 3, '2019/11/03', 68401, '2019/11/03', '2019/11/07', null, false, '420 Warmstone','Ottawa', 'Ontario', 'K2S0W2');
INSERT INTO public.order_book (order_id, book_id) VALUES (6,6);


--->> John Kline
-- OCT 2019
INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (3, 3, '2019/10/05', 68402, '2019/10/05', '2019/10/13', null, false, '1200 Gouin',  'Montreal', 'Quebec', 'K2S0W2');
INSERT INTO public.order_book (order_id, book_id) VALUES (7,1);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (3, 3, '2019/10/07', 68403, '2019/10/07', '2019/10/12', null, false, '1200 Gouin',  'Montreal', 'Quebec', 'K2S0W2');
INSERT INTO public.order_book (order_id, book_id) VALUES (8,3);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (3, 3, '2019/10/03', 68404, '2019/10/03', '2019/10/07', null, false, '1200 Gouin',  'Montreal', 'Quebec', 'K2S0W2');
INSERT INTO public.order_book (order_id, book_id) VALUES (9,6);


--->> Robert De Niro ------------------
-- OCT 2019
INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (4, 3, '2019/10/01', 68405, '2019/10/01', '2019/10/05', null, false, '120 Gladstone','Ottawa', 'Ontario', 'K2S0T4');
INSERT INTO public.order_book (order_id, book_id) VALUES (10,3);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (4, 3, '2019/10/02', 68406, '2019/10/02', '2019/10/06', null, false, '120 Gladstone','Ottawa', 'Ontario', 'K2S0T4');
INSERT INTO public.order_book (order_id, book_id) VALUES (11,4);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (4, 3, '2019/10/03', 68407, '2019/10/03', '2019/10/07', null, false, '120 Gladstone','Ottawa', 'Ontario', 'K2S0T4');
INSERT INTO public.order_book (order_id, book_id) VALUES (12,1);


--DEC 2019
INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (4, 3, '2019/12/01', 68408, '2019/12/01', '2019/12/05', null, false, '120 Gladstone','Ottawa', 'Ontario', 'K2S0T4');
INSERT INTO public.order_book (order_id, book_id) VALUES (13,4);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (4, 3, '2019/12/02', 68409, '2019/12/02', '2019/12/06', null, false, '120 Gladstone','Ottawa', 'Ontario', 'K2S0T4');
INSERT INTO public.order_book (order_id, book_id) VALUES (14,5);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (4, 3, '2019/12/03', 68410, '2019/12/03', '2019/12/07', null, false, '120 Gladstone','Ottawa', 'Ontario', 'K2S0T4');
INSERT INTO public.order_book (order_id, book_id) VALUES (15,1);

--->> James Bond ------------------
-- OCT 2019
INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (5, 3, '2019/10/01', 68411, '2019/10/01', '2019/10/05', null, false, '120 Gladstone','Ottawa', 'Ontario', 'K2S0T4');
INSERT INTO public.order_book (order_id, book_id) VALUES (16,2);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (5, 3, '2019/10/02', 68412, '2019/10/02', '2019/10/06', null, false, '120 Gladstone','Ottawa', 'Ontario', 'K2S0T4');
INSERT INTO public.order_book (order_id, book_id) VALUES (17,3);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (5, 3, '2019/10/03', 68413, '2019/10/03', '2019/10/07', null, false, '120 Gladstone','Ottawa', 'Ontario', 'K2S0T4');
INSERT INTO public.order_book (order_id, book_id) VALUES (18,6);


--JAN 2020
INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (5, 3, '2020/01/01', 68414, '2020/01/01', '2020/01/05', null, false, '120 Gladstone','Ottawa', 'Ontario', 'K2S0T4');
INSERT INTO public.order_book (order_id, book_id) VALUES (19,6);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (5, 3, '2020/01/05', 68415, '2020/01/05', '2020/01/12', null, false, '120 Gladstone','Ottawa', 'Ontario', 'K2S0T4');
INSERT INTO public.order_book (order_id, book_id) VALUES (20,3);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (5, 3, '2020/01/20', 68416, '2020/01/21', '2020/01/26', null, false, '120 Gladstone','Ottawa', 'Ontario', 'K2S0T4');
INSERT INTO public.order_book (order_id, book_id) VALUES (21,4);



--->> Tricky Tricomi------------------
--JAN 2020
INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (6, 3, '2020/01/01', 68417, '2020/01/01', '2020/01/05', null, false, '300 Laurier',  'Montreal', 'Quebec', 'J2S0W2');
INSERT INTO public.order_book (order_id, book_id) VALUES (22,6);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (6, 3, '2020/01/05', 68418, '2020/01/05', '2020/01/12', null, false, '300 Laurier',  'Montreal', 'Quebec', 'J2S0W2');
INSERT INTO public.order_book (order_id, book_id) VALUES (23,3);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (6, 3, '2020/01/20', 68419, '2020/01/21', '2020/01/26', null, false, '300 Laurier',  'Montreal', 'Quebec', 'J2S0W2');
INSERT INTO public.order_book (order_id, book_id) VALUES (24,4);

--FEB 2020
INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (6, 3, '2020/02/01', 68420, '2020/02/01', '2020/02/05', null, false, '300 Laurier',  'Montreal', 'Quebec', 'J2S0W2');
INSERT INTO public.order_book (order_id, book_id) VALUES (25,1);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (6, 3, '2020/02/05', 68421, '2020/02/05', '2020/02/12', null, false, '300 Laurier',  'Montreal', 'Quebec', 'J2S0W2');
INSERT INTO public.order_book (order_id, book_id) VALUES (26,3);

INSERT INTO public."order"(
	user_id, order_state_id, order_date, tracking_number, shipping_date, delivery_date, cancellation_date, publisher_paid_yn, street_line1, city, province, postal_code)
	VALUES (6, 3, '2020/02/20', 68422, '2020/02/21', '2020/02/26', null, false, '300 Laurier',  'Montreal', 'Quebec', 'J2S0W2');
INSERT INTO public.order_book (order_id, book_id) VALUES (27,5);






