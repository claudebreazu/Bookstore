-----------------------------------------
-- Lists all books in the bookstore, regardless of quantity.
-- This function is called by the Manager
------------------------------------------------------------------
CREATE OR REPLACE FUNCTION listAllBooks() 
   RETURNS TABLE (
	  "ID" integer,
      "Book Name" varchar,
	  "Author Name" varchar,
      "ISBN" varchar,
	  "Price" numeric(6,2),
	  "Number of Pages" integer,
	  "Genre" varchar,
	  "Publisher" varchar, 
	  "Stock Quantity" integer,
	  "Publisher Share" numeric(5,2),
	  "Retired From Sale" boolean
) 
AS $$

BEGIN
   RETURN QUERY 
   SELECT
   	  book.book_id,
      book.name, 
	  author.name,
	  book."ISBN", 
	  price, 
	  number_of_pages,
	  genre.name,
	  publisher.name,
	  quantity,
	  publisher_share,
	  retired_from_sale_yn
	  
   FROM book 
		  join publisher on book.publisher_id = publisher.publisher_id
		  join genre on book.genre_id = genre.genre_id
		  join author on book.author_id = author.author_id
	ORDER BY book.name;

END; 
$$ 
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- Search for a book by partial author name (pattern) or book name.
-- Allows searching on multiple fields: bookName, authorName, publisherName, genreName
-- Uses ILIKE for pattern matching
-- This function is called by the User
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION search_By_Author_Book_Publisher_Genre (p_search_criteria varchar) 
   RETURNS TABLE (
	  "ID" integer,
      "Book Name" varchar,
	  "Author Name" varchar,
      "ISBN" varchar,
	   "Price" numeric(6,2),
	   "Number of Pages" integer,
	   "Genre" varchar,
	   "Publisher" varchar, 
	   "Stock Quantity" integer
) 
AS $$

DECLARE temp_var varchar;

BEGIN
 
 temp_var := '%' || p_search_criteria || '%';
   
   RETURN QUERY 
	   SELECT DISTINCT
	   	  book.book_id,
		  book.name, 
		  author.name,
		  book."ISBN", 
		  price, 
		  number_of_pages,
		  genre.name,
		  publisher.name,
		  quantity
	   FROM book 
			  join publisher on book.publisher_id = publisher.publisher_id
			  join genre on book.genre_id = genre.genre_id
			  join author on book.author_id = author.author_id
		WHERE quantity > 0 AND 	
				(author.name ILIKE temp_var 
				OR book.name ILIKE temp_var
				OR Publisher.name ILIKE temp_var
				OR genre.name ILIKE temp_var);

END; 
$$ 
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- Update existing book.
-- The author and publisher will be created if it does not exist
-- Genre cannot be created and must already exist in bookstore
-- This function is called by the Manager
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION updateBook (
	p_book_id integer,
	p_book_name varchar,
	p_author_name varchar,
	p_publisher_name varchar,
	p_genre_name varchar,
	p_ISBN varchar,
	p_price numeric(6,2),
	p_number_of_pages integer,
	p_quantity integer,
	p_publisher_share numeric(5,2),
	p_retired_from_sale_yn boolean)
   RETURNS void
AS $$

DECLARE temp_count integer;
DECLARE temp_author_ID integer;
DECLARE temp_publisher_ID integer;

BEGIN

		-- Check if the author exists and if it does not, create it
		SELECT count(*) INTO temp_count
		FROM author 
		WHERE author.name = p_author_name;
		
		-- create author if he does not exist
		IF temp_count = 0 THEN
			INSERT INTO author (name) 
			VALUES (p_author_name)
			RETURNING author_id INTO temp_author_ID;
		ELSE
			SELECT author_id INTO temp_author_ID 
			FROM author WHERE author.name = p_author_name;
		END IF;
		
		-- Now the publisher
		SELECT count(*) INTO temp_count
		FROM publisher 
		WHERE publisher.name = p_publisher_name;
		
		-- create publisher if it does not exist
		IF temp_count = 0 THEN
			INSERT INTO publisher (name) 
			VALUES (p_publisher_name)
			RETURNING publisher_id INTO temp_publisher_ID;
		ELSE
			SELECT publisher_id INTO temp_publisher_ID 
			FROM publisher WHERE publisher.name = p_publisher_name;
		END IF;
	
		-- Update the book
		 UPDATE book 
			SET 
			author_id = temp_author_ID,
			publisher_id = temp_publisher_ID,
    		genre_id = (SELECT genre_id FROM genre WHERE genre.name = p_genre_name),
			name = p_book_name,
			"ISBN" = p_ISBN,
			price = p_price,
			number_of_pages = p_number_of_pages,
			quantity = p_quantity,
			publisher_share = p_publisher_share,
		 	retired_from_sale_yn = p_retired_from_sale_yn
		WHERE book.book_id = p_book_id;


 
END; 
$$ 
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- Creates a new book.
-- The author and publisher will be created if it does not exist
-- Genre cannot be created and must already exist in bookstore
-- This function is called by the Manager
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION createBook (
	p_book_name varchar,
	p_author_name varchar,
	p_publisher_name varchar,
	p_genre_name varchar,
	p_ISBN varchar,
	p_price numeric(6,2),
	p_number_of_pages integer,
	p_quantity integer,
	p_publisher_share numeric(5,2),
	p_retired_from_sale_yn boolean)
   RETURNS integer
AS $$

DECLARE temp_count integer;
DECLARE temp_author_ID integer;
DECLARE temp_publisher_ID integer;

BEGIN

		-- Check if the author exists and if it does not, create it
		SELECT count(*) INTO temp_count
		FROM author 
		WHERE author.name = p_author_name;
		
		-- create author if he does not exist
		IF temp_count = 0 THEN
			INSERT INTO author (name) 
			VALUES (p_author_name)
			RETURNING author_id INTO temp_author_ID;
		ELSE
			SELECT author_id INTO temp_author_ID 
			FROM author WHERE author.name = p_author_name;
		END IF;
		
		-- Now the publisher
		SELECT count(*) INTO temp_count
		FROM publisher 
		WHERE publisher.name = p_publisher_name;
		
		-- create publisher if it does not exist
		IF temp_count = 0 THEN
			INSERT INTO publisher (name) 
			VALUES (p_publisher_name)
			RETURNING publisher_id INTO temp_publisher_ID;
		ELSE
			SELECT publisher_id INTO temp_publisher_ID 
			FROM publisher WHERE publisher.name = p_publisher_name;
		END IF;
	
		-- Create the book
		 INSERT INTO book (
			author_id,
			publisher_id,
    		genre_id,
			name,
			"ISBN",
			price,
			number_of_pages,
			quantity,
			publisher_share,
		 	retired_from_sale_yn)
		VALUES 
		(
			temp_author_ID,
			temp_publisher_ID,
			(SELECT genre_id FROM genre WHERE genre.name = p_genre_name),
			p_book_name,
			p_ISBN,
			p_price,
			p_number_of_pages,
			p_quantity,
			p_publisher_share,
			p_retired_from_sale_yn
		 );

	
	RETURN 1;
 
END; 
$$ 
LANGUAGE 'plpgsql';



-----------------------------------------
-- Delete a book.
-- A book cannot be physically deleted if there is at least one order or one basket
-- referencing it, because in that case it would generate an error on the FK relationships.
-- The bookstore manager will be able to do one of 2 things:
-- 1. If there is no basket or order referencing the book, then we physically delete it
-- 2. Otherwise: we retire the book from sale by setting the flag "retired_from_sale"
-- This function is called by the Manager.
------------------------------------------------------------------
CREATE OR REPLACE FUNCTION deleteBook(p_book_id integer) 
  RETURNS integer 

AS $$
DECLARE tempCounter integer;

BEGIN

	-- Check orders
	SELECT count(*) INTO tempCounter 
	FROM order_book 
	WHERE book_id = p_book_id;
	
	-- Check baskets
	IF tempCounter = 0 THEN
		SELECT count(*) INTO tempCounter 
		FROM user_basket 
		WHERE book_id = p_book_id;
	END IF;

	-- Delete or update retired_from_sale_yn 
	IF tempCounter = 0 THEN
		DELETE FROM book 
		WHERE book_id = p_book_id;
	ELSE
		UPDATE book 
		SET retired_from_sale_yn = true
		WHERE book_id = p_book_id;
	END IF;
	
	RETURN tempCounter;
END; 
$$ 
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- Lists all books in the bookstore where quantity >= 10
-- This function is called by the User
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION listAllBooksAvailableToBuy() 
   RETURNS TABLE (
	  "ID" integer,
      "Book Name" varchar,
	  "Author Name" varchar,
      "ISBN" varchar,
	   "Price" numeric(6,2),
	   "Number of Pages" integer,
	   "Genre" varchar,
	   "Publisher" varchar
) 
AS $$

BEGIN

   RETURN QUERY 
   SELECT
   	  book.book_id,
      book.name, 
	  author.name,
	  book."ISBN", 
	  price, 
	  number_of_pages,
	  genre.name,
	  publisher.name
   	FROM book 
		  join publisher on book.publisher_id = publisher.publisher_id
		  join genre on book.genre_id = genre.genre_id
		  join author on book.author_id = author.author_id
	WHERE quantity > 0 AND retired_from_sale_yn = false
	ORDER BY  book.name; 

END; 
$$ 
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- Lists all orders
-- This function is called by the Manager
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION listAllOrders ()
   RETURNS TABLE (
      "ID" integer,
 "Customer Name" varchar,
 "Order State" varchar,
 "Books on Order" varchar,
      "Order Date" date,
  "Tracking Number" integer,
  "Shipping Date" date,
  "Delivery Date" date,
  "Delivery Address" varchar,
  "Publisher Paid" boolean

)
AS $$

BEGIN
   
   RETURN QUERY
      SELECT
 "order".order_id,
 "user".full_name,
 order_state.name,
 getListOfBookNames("order".order_id), --Function Call
 "order".order_date,
 "order".tracking_number,
 "order".shipping_date,
 "order".delivery_date,
 CAST(CONCAT (street_line1, ', ', city, ', ', province, ' ', postal_code) as varchar),
 publisher_paid_yn
FROM "order"
JOIN "user" on "order".user_id = "user".user_id
JOIN order_state ON "order".order_state_id = order_state.order_state_id;


END; 
$$
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- List user order based on user_id
-- This function is called by the Manager
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION listUserOrders(p_user_id integer)

   RETURNS TABLE (
      "ID" integer,
	  "Customer Name" varchar,
	  "Order State" varchar,
	  "Books on Order" varchar,
      "Order Date" date,
	  "Tracking Number" integer,
	  "Shipping Date" date,
	  "Delivery Date" date
) 
AS $$

BEGIN
    
   RETURN QUERY 
   	   SELECT
		  "order".order_id, 
		  "user".full_name,
		  order_state.name,
		  getListOfBookNames("order".order_id),	--Function Call
		  "order".order_date, 
		  "order".tracking_number, 
		  "order".shipping_date,
		  "order".delivery_date	
		FROM "order"
			JOIN "user" on "order".user_id = "user".user_id
			JOIN order_state ON "order".order_state_id = order_state.order_state_id
			WHERE "order".user_id = p_user_id;

END; 
$$ 
LANGUAGE 'plpgsql';


----------------------------------------------------------------------------------
-- Searches order by various fields
-- Search by: order_id, trackingNumber, custName, orderStatus
-- This function is called by the Manager
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION searchOrderByMany (	
	p_search_criteria varchar,
	p_search_token varchar)

RETURNS TABLE (
      "Order ID" integer,
	  "Customer Name" varchar,
	  "Order State" varchar,
	  "Books on Order" varchar,
      "Order Date" date,
	   "Tracking Number" integer,
	   "Shipping Date" date,
	   "Delivery Date" date,
	   "Cancellation Date" date,
	   "Delivery Address" varchar
) 
AS $$

BEGIN    
	-- create a temporary table.
	-- it looks that the <RETURN QUERY> does not work with IF or CASE statements
	-- one workaround is:
	--1. create a temp table
	--2. insert what we get from the functions
	--3. use the <RETURN QUERY> on the temp table
	
	DROP TABLE IF EXISTS mytemp;
	CREATE TEMP TABLE mytemp(
			"Order ID" integer,
			"Customer Name" varchar,
			"Order State" varchar,
			"Books on Order" varchar,
			"Order Date" date,
			"Tracking Number" integer,
			"Shipping Date" date,
			"Delivery Date" date,
			"Cancellation Date" date,
			"Delivery Address" varchar);

	-- Based on p_search_criteria, decide which search we need to do
	-- Depending on the criteria, we choose the correct function to call
	IF UPPER(p_search_criteria) = 'ORDER ID' THEN
   		INSERT INTO myTemp
	   		SELECT * FROM searchOrderByID(CAST(p_search_token as integer));
	ELSIF UPPER(p_search_criteria) = 'TRACKING NUMBER' THEN
	   	INSERT INTO myTemp
	   		SELECT * FROM searchOrderByTrackingNumber(CAST(p_search_token as integer));
	ELSIF UPPER(p_search_criteria) = 'CUSTOMER NAME' THEN
	   	INSERT INTO myTemp
	   		SELECT * FROM searchOrderByUserName(p_search_token);
	ELSIF UPPER(p_search_criteria) = 'ORDER STATUS' THEN
	   	INSERT INTO myTemp
	   		SELECT * FROM searchOrderByOrderState(p_search_token);
	END IF;
	

RETURN QUERY 
		SELECT * FROM mytemp;

END; 
$$ 
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- Search order by order id
-- This function is called by Manager
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION searchOrderByID (
p_order_id integer)

RETURNS TABLE (
      "Order ID" integer,
	  "Customer Name" varchar,
	  "Order State" varchar,
	  "Books on Order" varchar,
      "Order Date" date,
	   "Tracking Number" integer,
	   "Shipping Date" date,
	   "Delivery Date" date,
	   "Cancellation Date" date,
	   "Delivery Address" varchar
) 
AS $$

BEGIN    

   RETURN QUERY 
   	   SELECT
		  "order".order_id, 
		  "user".full_name,
		  order_state.name,
		  getListOfBookNames("order".order_id),	--Function Call
		  "order".order_date, 
		  "order".tracking_number, 
		  "order".shipping_date,
		  "order".delivery_date,
		  "order".cancellation_date,
		  CAST(CONCAT("order".street_line1, ', ', "order".city, ', ', "order".province, ', ', "order".postal_code ) AS varchar)
		FROM "order"
			JOIN "user" on "order".user_id = "user".user_id
			JOIN order_state ON "order".order_state_id = order_state.order_state_id
		WHERE order_id = p_order_id;


END; 
$$ 
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- Search order by tracking number
-- This function is called by Manager
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION searchOrderByTrackingNumber (
p_tracking_number integer)

RETURNS TABLE (
      "Order ID" integer,
	  "Customer Name" varchar,
	  "Order State" varchar,
	  "Books on Order" varchar,
      "Order Date" date,
	   "Tracking Number" integer,
	   "Shipping Date" date,
	   "Delivery Date" date,
	   "Cancellation Date" date,
	   "Delivery Address" varchar
) 
AS $$

BEGIN    

   RETURN QUERY 
   	   SELECT
		  "order".order_id, 
		  "user".full_name,
		  order_state.name,
		  getListOfBookNames("order".order_id),	--Function Call
		  "order".order_date, 
		  "order".tracking_number, 
		  "order".shipping_date,
		  "order".delivery_date,
		  "order".cancellation_date,
		  CAST(CONCAT("order".street_line1, ', ', "order".city, ', ', "order".province, ', ', "order".postal_code ) AS varchar)
		FROM "order"
			join "user" on "order".user_id = "user".user_id
			JOIN order_state ON "order".order_state_id = order_state.order_state_id
		WHERE tracking_number = p_tracking_number;


END; 
$$ 
LANGUAGE 'plpgsql';

			

----------------------------------------------------------------------------------
-- Search order by user name
-- This function is called by Manager
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION searchOrderByUserName (	
	p_username varchar)

RETURNS TABLE (
      	"Order ID" integer,
	  	"Customer Name" varchar,
		"Order State" varchar,
	  	"Books on Order" varchar,
      	"Order Date" date,
	   	"Tracking Number" integer,
	   	"Shipping Date" date,
	   	"Delivery Date" date,
	   	"Cancellation Date" date,
	   	"Delivery Address" varchar
) 
AS $$

BEGIN 
   
   RETURN QUERY 
   	   SELECT
		  "order".order_id, 
		  "user".full_name,
		  order_state.name,
		  getListOfBookNames("order".order_id),	--Function Call
		  "order".order_date, 
		  "order".tracking_number, 
		  "order".shipping_date,
		  "order".delivery_date,
		  "order".cancellation_date,
		  CAST(CONCAT("order".street_line1, ', ', "order".city, ', ', "order".province, ', ', "order".postal_code ) AS varchar)
		FROM "order"
			join "user" on "order".user_id = "user".user_id
			JOIN order_state ON "order".order_state_id = order_state.order_state_id
		WHERE "user".full_name = p_username;


END; 
$$ 
LANGUAGE 'plpgsql';


----------------------------------------------------------------------------------
-- Search order by order state
-- This function is called by Manager
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION searchOrderByOrderState (	
	p_order_state varchar)

RETURNS TABLE (
      	"Order ID" integer,
	  	"Customer Name" varchar,
		"order State" varchar,
	  	"Books on Order" varchar,
      	"Order Date" date,
	   	"Tracking Number" integer,
	   	"Shipping Date" date,
	   	"Delivery Date" date,
	   	"Cancellation Date" date,
	   	"Delivery Address" varchar
) 
AS $$

BEGIN    

   RETURN QUERY 
   	   SELECT
		  "order".order_id, 
		  "user".full_name,
		  order_state.name,
		  getListOfBookNames("order".order_id),	--Function Call
		  "order".order_date, 
		  "order".tracking_number, 
		  "order".shipping_date,
		  "order".delivery_date,
		  "order".cancellation_date,
		  CAST(CONCAT("order".street_line1, ', ', "order".city, ', ', "order".province, ', ', "order".postal_code ) AS varchar)
		FROM "order"
			JOIN "user" ON "order".user_id = "user".user_id
			JOIN order_state ON "order".order_state_id = order_state.order_state_id
		WHERE UPPER(order_state.name) = UPPER(p_order_state);


END; 
$$ 
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- Scans the list of books on an order and build a list of names as a string 
-- This function is called by Manager
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION getListOfBookNames (	
	p_order_id integer)
	
   RETURNS varchar
AS $$

DECLARE 
	accum varchar;
	vRec record;

BEGIN

	-- for each each record vRec, add the book name to the list
	-- seperated by &
	FOR vRec IN
		(SELECT  book.name 
		FROM book
			JOIN order_book ON book.book_id  = order_book.book_id
		WHERE order_book.order_id = p_order_id)
	LOOP
		IF accum IS NULL THEN	
			accum := vRec.name;
		ELSE
			accum := CONCAT(accum, ' & ', vRec.name);
		END IF;
	END LOOP;

	RETURN accum;

END; 
$$ 
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- Build the full address as a single string.
-- The user's Shipping Address is the one we are looking for 
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION getFullAddress (	
	p_order_id integer)
   RETURNS varchar
AS $$

DECLARE accum varchar;

BEGIN

SELECT concat(street_line1, ', ', city, ', ', province, ', ', address.postal_code) INTO accum
FROM "order"
	JOIN "user" ON "order".user_id  = "user".user_id
	JOIN address on "user".user_id = address.user_id
WHERE address.address_type_id = 1  
		AND "order".order_id = p_order_id;


RETURN accum;

END; 
$$ 
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- Pay the publisher for the books on this order.
-- Calculated as a percentage of the sale price.
-- It adds the resulted amount to the Publisher Bank Account
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION payPublisher (
p_order_id integer)
   RETURNS void
AS $$

DECLARE accum varchar;
DECLARE vRec record;

BEGIN

FOR vRec IN
(SELECT publisher_id, book.price, book.publisher_share
FROM book
JOIN order_book ON book.book_id  = order_book.book_id
JOIN "order" ON order_book.order_id = "order".order_id
WHERE "order".order_id = p_order_id  AND "order".publisher_paid_yn = false)
LOOP
UPDATE publisher
SET bank_account  = bank_account + vRec.price * vRec.publisher_share/100
WHERE publisher.publisher_id = vRec.publisher_id;
END LOOP;

-- set the flag indicating the publishers were paid
UPDATE "order"
SET publisher_paid_yn = true
WHERE order_id = p_order_id;


RETURN;

END;
$$
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- Delete an order based on order id
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION deleteOrder (	
	p_order_id integer)
   RETURNS void
AS $$

BEGIN

	DELETE FROM order_book WHERE order_id = p_order_id;
	DELETE FROM "order" WHERE order_id = p_order_id;
		

RETURN ;

END; 
$$ 
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- Delete all orders
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION deleteAllOrders ()
   RETURNS void
AS $$

BEGIN
	DELETE FROM order_book;
	DELETE FROM "order";
RETURN ;

END; 
$$ 
LANGUAGE 'plpgsql';



---------------------------------------------------------------
-- Add book to basket
-- This function is called by user
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION addBookToBasket (	
	p_user_id integer, 
	p_book_id integer) 
   RETURNS integer
AS $$



BEGIN

	-- insert book in basket and do nothing if the same book is added
	-- for the same user (already exists)
	INSERT INTO user_basket (book_id, user_id)
	VALUES (p_book_id, p_user_id)
	ON CONFLICT ON CONSTRAINT basket_unique_user_and_book 
	DO NOTHING;
	
	-- decrease the number of books in the warehouse by one.
	-- We do it here because in real world case all active baskets could become 
	-- orders the and store must be able to complete the transaction for the user
	
	UPDATE book
	SET quantity = quantity - 1
	WHERE book.book_id = p_book_id
			AND quantity > 0;
	
	RETURN (SELECT quantity FROM book WHERE book.book_id = p_book_id);

END; 
$$ 
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- Empty the whole basket and return the books to the warehouse 
-- Also must update quantity of book again in warehouse 
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION emptyBasket (	
	p_user_id integer) 
   RETURNS void
AS $$

BEGIN

	-- update the stock in the warehouse for all books in basket belonging to the user
	UPDATE book
	SET quantity = quantity +  1
	WHERE book.book_id IN
			(SELECT book_id 
			FROM user_basket
			WHERE user_id = p_user_id);	
			
	-- delete from basket for the user
	DELETE FROM user_basket
	WHERE user_id = p_user_id;
		
	
END; 
$$ 
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- Return individual book from the basket to the warehouse 
-- Update warehouse quantity as well
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION removeBookFromBasket (	
	p_user_id integer,
	p_book_id integer) 
   RETURNS void
AS $$

BEGIN

	-- update the stock in the warehouse for single book in basket belonging to the user
	UPDATE book
	SET quantity = quantity +  1
	WHERE book.book_id = p_book_id;
	
			
	-- delete from basket
	DELETE FROM user_basket
	WHERE user_id = p_user_id AND book_id = p_book_id;
		
	
END; 
$$ 
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- List books in user Basket
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION  listBooksInBasket(p_user_id integer) 
   RETURNS TABLE (
      "ID" integer,
	  "Book Name" varchar,
	  "Author" varchar,
      "Publisher" varchar,
	   "ISBN" varchar,
	   "Price" numeric(6,2)
) 
AS $$

BEGIN
    
   RETURN QUERY 
   	   SELECT
		  book.book_id, 
		  book.name,
		  author.name,	
		  publisher.name, 
		  book."ISBN", 
		  book.price
		  
		FROM book
			JOIN author ON book.author_id = author.author_id
			JOIN publisher ON book.publisher_id = publisher.publisher_id
			JOIN user_basket ON book.book_id = user_basket.book_id
		WHERE user_basket.user_id = p_user_id;

END; 
$$ 
LANGUAGE 'plpgsql';



----------------------------------------------------------------------------------
-- List users, ids, and if they are registered
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION  listUsers() 

   RETURNS TABLE (
      "ID" integer,
	  UserName varchar,
	  Registration boolean
) 
AS $$

BEGIN
    
   RETURN QUERY 
   	   SELECT
		  user_id, 
		  full_name,
		  registered_YN
		FROM "user";

END; 
$$ 
LANGUAGE 'plpgsql';


----------------------------------------------------------------------------------
-- Gets user address
-- Either registration or shipping based on address_type
----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION  getUserAddress(
	p_user_Id integer,
	p_address_type_id integer) 
	
   RETURNS TABLE (
      Street varchar,
	  City varchar,
	  Province varchar,
	  "Postal Code" varchar
) 
AS $$

BEGIN
    
   RETURN QUERY 
   	   SELECT
		  street_line1, 
		  address.city,
		  address.province,
		  postal_code
		FROM address 
		WHERE user_id = p_user_Id AND address_type_id = p_address_type_id ;

END; 
$$ 
LANGUAGE 'plpgsql';



--------------------------------------------------------------
-- Create an order
-- The following steps are being performed:
-- 1. Create Order record in the state "Initiated"
-- 2. Create records in <order_book> table based on the basket records
-- 3. Copy the shipping address fields from the basket to the Order. This must be 
-- done because the user could change his address, however an older order must
-- remain with the same shipping address that it had started with.
-- 4. Delete the records from the basket for the current user
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION createOrder (	
	p_user_id integer,
	p_street varchar,
	p_city varchar,
	p_province varchar,
	p_postal_code varchar) 
   RETURNS integer
AS $$

DECLARE temp_order_id integer;
DECLARE temp_count integer;

BEGIN
		-- Create an order and keep its ID
		INSERT INTO "order" 
			(user_id,
			 street_line1,
			 city,
			 province,
			 postal_code,
			 order_state_id,
			 order_date)
		VALUES 
			(p_user_id,
			 p_street,
			 p_city,
			 p_province,
			 p_postal_code,
			 1,
			 CURRENT_DATE)
		RETURNING order_id INTO temp_order_id;

		-- Create order in order_book table based on the basket
		-- Insert into Select used (instead of insert into values)
		INSERT INTO order_book 
			(book_id,
			 order_id)
			SELECT 
				book_id, 
				temp_order_id
			FROM user_basket
			WHERE user_basket.user_id = p_user_id;
				
		-- Delete from basket all the records belonging to the user
		DELETE FROM user_basket 
		WHERE user_id = p_user_id;

	RETURN temp_order_id;

	

END; 
$$ 
LANGUAGE 'plpgsql';



--------------------------------------------------------------
-- Set the order status
-- There are 3 states for the order: Initiated, Shipped and Delivered. 
-- Once order is received the User must confirms it was Delivered
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION setOrderStatus (	
	p_order_id integer,
	p_order_state_id integer) 
   RETURNS void
AS $$

BEGIN
	
		IF p_order_state_id = 2  THEN  -- Shipped
			
			-- update order state and assign random tracking number + shipping date
			UPDATE "order"
			SET order_state_id = p_order_state_id,
				tracking_number = FLOOR(random()* (1000000-10000 + 1) + 10000), 
				shipping_date = CURRENT_DATE  
			WHERE order_id = p_order_id;	
			
		ELSEIF p_order_state_id = 3  THEN  -- Delivered
		
		-- update order state and remove the tracking number because it was delivered + delivery date
			UPDATE "order"
			SET order_state_id = p_order_state_id,
				tracking_number = null,
				delivery_date = CURRENT_DATE
			WHERE order_id = p_order_id;

		END IF;
	
END; 
$$ 
LANGUAGE 'plpgsql';



--------------------------------------------------------------
-- Return individual book from the basket to the warehouse 
-- Update warehouse quantity as well and delete from order_book
-- Note: this function might not have been implemented in the java code 
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION returnBookToStock (p_order_id integer)
   RETURNS void
AS $$

BEGIN
	UPDATE book
	SET quantity = quantity + 1
	WHERE book_id IN 
		(SELECT book_id
		FROM order_book
		WHERE order_id = p_order_id);

	-- delete the records in order_book
	DELETE from order_book 
	WHERE order_id = p_order_id;

END; 
$$ 
LANGUAGE 'plpgsql';



-----------------------------------------------------------
-- List Publishers
-----------------------------------------------------------
CREATE OR REPLACE FUNCTION listPublishers ()

RETURNS TABLE (
      "ID" integer,
	  "Publisher Name" varchar,
	  "Bank Account" numeric,
      "Email" varchar,
	   "Street" varchar,
	   "City" varchar,
	   "Province" varchar,
	   "Postal Code" varchar
	
) 
AS $$

BEGIN    
   RETURN QUERY 
   	   SELECT
		  publisher_id, 
		  "name",
		  bank_account,
		  email_address, 
		  address_line1, 
		  city,
		  province,
		  postal_code		
		FROM publisher;


END; 
$$ 
LANGUAGE 'plpgsql';


-----------------------------------------------------------
-- Calculate total sales by author
-----------------------------------------------------------
CREATE OR REPLACE FUNCTION salesByAuthor ()

RETURNS TABLE (
      "Author Name" varchar,
	  "Books Sold" bigint,
	  "Total Sales" numeric
	
) 
AS $$

BEGIN    
   RETURN QUERY 
   	   select "author".name, count (*) as books_sold, sum(book.price) from "order"
			join "order_book" on "order".order_id = "order_book".order_id
			join "book" on "order_book".book_id = "book".book_id
			join "author" on "book".author_id = "author".author_id
		group by "author".name;


END; 
$$ 
LANGUAGE 'plpgsql';

-----------------------------------------------------------
-- Calculate total sales by genre
-----------------------------------------------------------
CREATE OR REPLACE FUNCTION salesByGenre ()

RETURNS TABLE (
      "Genre Name" varchar,
	  "Books Sold" bigint,
	  "Total Sales" numeric
	
) 
AS $$

BEGIN    
   RETURN QUERY 
   	   select "genre".name, count (*) as books_sold, sum(book.price) from "order"
			join "order_book" on "order".order_id = "order_book".order_id
			join "book" on "order_book".book_id = "book".book_id
			join "genre" on "book".genre_id = "genre".genre_id
		group by "genre".name;


END; 
$$ 
LANGUAGE 'plpgsql';



-----------------------------------------------------------
-- Calculate total sales by Net Sales for the whole warehouse
-----------------------------------------------------------
CREATE OR REPLACE FUNCTION warehouseNetSales ()

RETURNS TABLE (
      "Gross Sales" numeric(6,2),
	  "Expenditures" numeric(6,2),
	  "Profit (Net Sales)" numeric(6,2)
	
) 
AS $$

BEGIN    
   RETURN QUERY 
   	   select cast(sum(book.price) as numeric(6,2)),
	   		  cast(sum(book.publisher_share*book.price/100) as numeric(6,2)),
			  cast(sum(book.price - (book.publisher_share*book.price/100)) as numeric(6,2))
		from "order"
			join "order_book" on "order".order_id = "order_book".order_id
			join "book" on "order_book".book_id = "book".book_id;

END; 
$$ 
LANGUAGE 'plpgsql';

--drop function warehouseNetSales()
--select * from warehouseNetSales()
