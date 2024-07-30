/**	PostgreSQL Quirks
	================================================
	This works:
		SELECT cast('tomorrow' as date) AS birthday;
	Set Auto Number after INSERTS:
		SELECT setval(pg_get_serial_sequence('customers', 'id'), max(id)) FROM customers;
	================================================ */

/**	Chapter 1: Sampler
	================================================
	================================================ */

/*	1.01: Basic SELECT
	================================================ */

	SELECT * FROM customers;

/*	1.02: Specific Columns
	================================================ */

	SELECT id, givenname, familyname
	FROM customers;

/*	1.03: Calculated Columns
	================================================ */

	SELECT
		id, givenname, familyname,
		height, height/2.54
	FROM customers;

/*	1.04: Aliases
	================================================ */

	SELECT
		id, givenname, familyname,
		height as centimetres,
		height/2.54 as inches
	FROM customers;

/*	1.05: Comments
	================================================ */

	SELECT
		id, givenname, familyname,
		height as centimetres,
		height/2.54 as inches	-- 1in = 2.54cm
	FROM customers;

/*	1.06: Filtering Rows
	================================================ */

	SELECT
		id, givenname,familyname,
		height/2.54 AS inches
	FROM customers
	WHERE state='NSW';

/*	1.07: Ordering the Results
	================================================ */

	SELECT
		id, givenname,familyname,
		height/2.54 AS inches
	FROM customers
	WHERE state='NSW'
	ORDER BY familyname, givenname;

/*	1.08: SELECT email
	================================================ */

	SELECT email FROM customers;

/*	1.09: SELECT State
	================================================ */

	SELECT state FROM customers;

/*	1.10: Select DISTINCT
	================================================ */

	SELECT DISTINCT state FROM customers;

/*	1.11: DISTINCT Multiple Columns
	================================================ */

	SELECT DISTINCT state,town FROM customers;

/*  1.12: SQL Sampler Summary
	================================================
	This is an introductory SELECT statement
	The rest of the book will go into more detail
	================================================ */

	SELECT
		id,
		--	email,
		givenname, familyname,
		height/2.54 as inches	-- 2.54 cm = 1 inch
	FROM customers
	WHERE state='NSW'
	ORDER BY familyname,givenname;

/**	Chapter 3: WHERE clause
	================================================
	================================================ */

/*	3.01: Shorter Customers
	================================================ */

	SELECT *
	FROM customers
	WHERE height<170;

/*	3.02: Not Shorter Customers
	================================================ */

	SELECT *
	FROM customers
	WHERE NOT height<170;

	SELECT *
	FROM customers
	WHERE height >= 170;

/*	3.03: Matching Customers
	================================================ */

	SELECT *
	FROM customers
	WHERE height=170;

	SELECT *
	FROM customers
	WHERE height<>170;

	SELECT *
	FROM customers
	WHERE NOT height=170;

/*	3.04: Unrelated Assertions
	================================================ */

	SELECT *
	FROM customers
	WHERE 1=1;		--	all rows

	SELECT *
	FROM customers
	WHERE 1=0;		--	no rows

/*	3.05: All and Nothing
	================================================ */

	SELECT * FROM customers WHERE id>0;	--	All rows
	SELECT * FROM customers WHERE id<0;	--	Nothing

/*	3.06: Null
	================================================ */

	SELECT *
	FROM customers
	WHERE height=NULL;	--	doesn’t work

	SELECT *
	FROM customers
	WHERE NULL=NULL;	--	doesn’t work

/*	3.07: Compare with NULLs
	================================================ */

	SELECT *
	FROM artists
	WHERE born=died;

/*	3.08: Finding NULLs
	================================================ */

	SELECT *
	FROM customers
	WHERE height IS NULL;		--	missing height

	SELECT *
	FROM customers
	WHERE height IS NOT NULL;	--	existing heights

/*	3.09: All Heights
	================================================ */

	SELECT * FROM customers WHERE height<170
	UNION
	SELECT * FROM customers WHERE NOT height<170;

	SELECT *
	FROM customers
	WHERE NOT height IS NULL;

/*	3.10: Discrete Years
	================================================ */

	SELECT *
	FROM artists
	WHERE born >= 1700;

	SELECT *
	FROM artists
	WHERE born > 1699;

/*	3.11: Continuous Heights
	================================================ */

	SELECT *
	FROM customers
	WHERE height >= 170;

	SELECT *
	FROM customers
	WHERE height > 169;

/*	3.12: Strings
	================================================ */

	SELECT *
	FROM customers
	WHERE state='VIC';

	SELECT *
	FROM customers
	WHERE state<>'VIC';

/*	3.13: Non Existant Values
	================================================ */

	SELECT *
	FROM customers
	WHERE state='XYZ';

/*	3.14: Unmatched Data Type
	================================================ */

	SELECT *
	FROM customers
	WHERE state=23;

/*	3.15: String Quotes
	================================================ */

	SELECT *
	FROM customers
	WHERE state="VIC";

/*	3.16: Single and Double Quotes
	================================================ */

	SELECT * FROM customers WHERE familyname='Town';
	SELECT * FROM customers WHERE familyname="town";

/*	3.17: Column Names
	================================================ */

	SELECT *
	FROM customers
	WHERE "state"='VIC';

/*	3.18: Bad Table
	================================================ */

	SELECT * FROM badtable;

/*	3.19: Bad Column Names
	================================================ */

	SELECT
		customer code,
		customer,
		order,
		1st,
		42,
		last-date
	FROM badtable;

/*	3.20: Quotes Column Names
	================================================ */

	SELECT
		"customer code",
		customer,
		"order",
		"1st",
		"42",
		"last-date"
	FROM badtable;

/*	3.21: Case Sensitivity
	================================================ */

	SELECT *
	FROM customers
	WHERE state='vic';

	SELECT *
	FROM sorting
	WHERE stringvalue='Apple';

/*	3.22: Testing Case
	================================================ */

	SELECT *
	FROM customers
	WHERE 'a'='A';

/*	3.23: Convert Case
	================================================ */

	SELECT *
	FROM customers
	WHERE lower(state)='vic';

/*	3.24: Extra Spaces
	================================================ */

	--	Trailing Spaces Significant
		SELECT *
		FROM customers
		WHERE state='VIC ';

	--	Leading Spaces Significant
		SELECT *
		FROM customers
		WHERE state=' VIC';

/*	3.25: String Functions
	================================================ */

	--	In WHERE clause
		SELECT *
		FROM customers
		WHERE length(familyname)<5;

	--	Also in SELECT
		SELECT *, length(familyname) AS size
		FROM customers
		WHERE length(familyname)<5;

	--	Cannot use alias in WHERE clause
		SELECT *, length(familyname) AS size
		FROM customers
		WHERE size<5;		--	ERROR

/*	3.26: Containing Quotes
	================================================
	This doesn’t work:

	SELECT *
	FROM customers
	WHERE familyname = 'O'Toole' OR town=''s-Gravenhage';
	================================================ */

	SELECT *
	FROM customers
	WHERE familyname = 'O''Shea' OR town='''s-Gravenhage';

/*	3.27: ‘Typographic’ Quotes
	================================================ */

	SELECT *
	FROM customers
	WHERE familyname = 'O’Shea' OR town='’s-Gravenhage';

/*	3.28: Before Strings
	================================================ */

	SELECT *
	FROM customers
	WHERE familyname<'K';

/*	3.29: Dates - ISO 8601
	================================================ */

	SELECT *
	FROM customers
	WHERE dob='1989-11-09';

/*	3.30: Dates with Extra Spaces
	================================================ */

	SELECT *
	FROM customers
	WHERE dob=' 1989-11-09 ';

/*	3.31: Compact ISO 8601
	================================================ */

	SELECT *
	FROM customers
	WHERE dob='19891109';	--	Same as '1989-11-09'

/*	3.32: Date Variations
	================================================ */

	SELECT *
	FROM customers
	WHERE dob='9 Nov 1989';

	SELECT *
	FROM customers
	WHERE dob='November 9, 1989';

	--	Don’t do this:
		SELECT *
		FROM customers
		WHERE dob='9/11/1989';	--	d/m or m/d ?

/*	3.33: Date Before & After
	================================================ */

	--	Born BEFORE 1 Jan 1980
		SELECT *
		FROM customers
		WHERE dob<'1980-01-01';

	--	Born FROM 1 Jan 1980
		SELECT *
		FROM customers
		WHERE dob>='1980-01-01';

/*	3.34: BETWEEN
	================================================ */

	--	Born in the 1980s
		SELECT *
		FROM customers
		WHERE dob BETWEEN '1980-01-01' AND '1989-12-31';

	--	Born in the 1980s
		SELECT *
		FROM customers
		WHERE dob NOT BETWEEN '1980-01-01' AND '1989-12-31';

/*	3.35: Date Calculation
	================================================ */

	SELECT * FROM customers WHERE dob<current_timestamp -	INTERVAL '40' YEAR;

/*	3.36: Rewritten BETWEEN
	================================================ */

	--	Born in the 1980s
		SELECT *
		FROM customers
		WHERE dob>='1980-01-01' AND dob<='1989-12-31';

/*	3.37: Rewritten BETWEEN Variations
	================================================ */

	SELECT *
	FROM artists
	WHERE born>=1700 AND born<=1799;

	SELECT *
	FROM artists
	WHERE born>1699 AND born<1801;

	SELECT *
	FROM artists
	WHERE born>1699 AND born<=1799;

/*	3.38: Multiple ANDs
	================================================ */

	SELECT *
	FROM customers
	WHERE state='VIC' AND height>170 AND dob<'1980-01-01';

/*	3.39: OR
	================================================ */

	SELECT *
	FROM customers
	WHERE state='VIC' OR state='QLD';

/*	3.40: AND vs OR
	================================================ */

	--	ALL must be true:
		SELECT *
		FROM customers
		WHERE state='QLD' AND dob<'1980-01-01';

	--	ANY (or ALL) must be true:
		SELECT *
		FROM customers
		WHERE state='QLD' OR dob<'1980-01-01';

/*	3.41: AND and OR
	================================================ */
	SELECT *
	FROM customers
	WHERE state='QLD' OR state='VIC' AND dob<'1980-01-01';

	SELECT *
	FROM customers
	WHERE state='QLD' OR (state='VIC' AND dob<'1980-01-01');

	SELECT *
	FROM customers
	WHERE (state='QLD' OR state='VIC') AND dob<'1980-01-01';

/*	3.42: IN expression
	================================================ */

	SELECT *
	FROM customers
	WHERE state='VIC' OR state='QLD' OR state='WA';	--	etc

	SELECT *
	FROM customers
	WHERE state IN ('VIC','QLD','WA');

/*	3.43: IN Variations
	================================================ */

	SELECT *
	FROM customers
	WHERE state IN ('VIC','QLD','VIC','ETC');

/*	3.44: NOT IN
	================================================ */

	SELECT *
	FROM customers
	WHERE state NOT IN ('VIC','QLD','WA');

/*	3.45: Big Spenders
	================================================ */

	--	Customer ids
		SELECT customerid
		FROM sales
		WHERE total>1200;

	--	Customer Details
		SELECT *
		FROM customers
		WHERE id IN(SELECT customerid FROM sales WHERE total>1200);

/*	3.46: ANY expression
	================================================ */

	SELECT *
	FROM customers
	WHERE id = ANY(SELECT customerid FROM sales WHERE total>1200);

/*	3.47: Dutch Paintings
	================================================ */

	SELECT *
	FROM paintings
	WHERE artistid IN (SELECT id FROM artists WHERE nationality='Dutch');

	SELECT *
	FROM paintings
	WHERE artistid=ANY(SELECT id FROM artists WHERE nationality='Dutch');

/*	3.48: Dutch & Netherlandish
	================================================ */

	SELECT *
	FROM paintings
	WHERE artistid IN (SELECT id FROM artists WHERE nationality='Dutch'
		OR nationality='Netherlandish');

	SELECT *
	FROM paintings
	WHERE artistid IN (SELECT id FROM artists
		WHERE nationality IN ('Dutch','Netherlandish'));

/*	3.49: Wildcard %
	================================================ */

	SELECT *
	FROM customers
	WHERE familyname LIKE 'Ring%';

/*	3.50: LIKE and Wildcards
	================================================ */

	SELECT *
	FROM customers
	WHERE familyname LIKE 'Ring';

	SELECT *
	FROM customers
	WHERE familyname='Ring';

	SELECT *
	FROM customers
	WHERE familyname='Ring%';

/*	3.51: Case Sensitivity
	================================================ */

	SELECT *
	FROM customers
	WHERE familyname LIKE 'ring%';

	SELECT *
	FROM customers
	WHERE lower(familyname) LIKE 'ring%';

/*	3.52: Single Characters
	================================================ */

	SELECT *
	FROM customers
	WHERE familyname LIKE 'R__e';	--	Rate, Rise, Rice, Rowe

/*	3.53: More Examples with %
	================================================ */

	--	At least 4 characters, starting with S:
		SELECT *
		FROM customers
		WHERE familyname LIKE 'S___%';

	--	Begins with Ring
		SELECT *
		FROM customers
		WHERE familyname LIKE 'Ring%';

	--	Ends with ring
		SELECT *
		FROM customers
		WHERE lower(familyname) LIKE '%ring';

	--	Contains ring
		SELECT *
		FROM customers
		WHERE lower(familyname) LIKE '%ring%';

	--	Begins with S and Ends with e
		SELECT *
		FROM customers
		WHERE familyname LIKE 'S%e';

/*	3.54: More Examples with _
	================================================ */

	--	Wholly Contains s
		SELECT *
		FROM customers
		WHERE familyname LIKE '%_s_%';

	--	Exactly 4 characters
		SELECT *
		FROM customers
		WHERE familyname LIKE '____';

	--	Exactly 4 characters, starting with R
		SELECT *
		FROM customers
		WHERE familyname LIKE 'R___';

	--	At least 4 characters
		SELECT *
		FROM customers
		WHERE familyname LIKE '____%';

	--	At least 4 characters, starting with S
		SELECT *
		FROM customers
		WHERE familyname LIKE 'S___%';

/*	3.55: Wildcards with Numbers
	================================================
	Not PostgreSQL
	================================================ */

		--	Doesn’t Work:		SELECT *
		FROM customers
		WHERE height LIKE '17%';

	SELECT *
	FROM customers
	WHERE cast(height AS VARCHAR(255)) LIKE '17%';

/*	3.56: Wildcards with Dates
	================================================ */

	--	Doesn’t Work:
		SELECT *
		FROM customers
		WHERE dob LIKE '19%';

	SELECT *
	FROM customers
	WHERE cast(dob AS VARCHAR(255)) LIKE '19%';

/*	3.57: Regular Expressions
	================================================ */

	SELECT *
	FROM customers
	WHERE familyname ~ '^[A-K][^hy].*';
	SELECT *
	FROM customers
	WHERE lower(familyname) ~ '^[a-k][^hy].*';

	SELECT *
	FROM customers
	WHERE familyname SIMILAR TO '[A-K][^hy]%';
	SELECT *
	FROM customers
	WHERE lower(familyname) SIMILAR TO '[a-k][^hy]%';

/*	3.58: Matching “portrait”
	================================================ */

	SELECT *
	FROM paintings
	WHERE title ILIKE '%portrait%';

	SELECT *
	FROM paintings
	WHERE lower(title) LIKE '%portrait%';

/*	3.59: Matching “self?portrait”
	================================================ */

	SELECT *
	FROM paintings
	WHERE title ILIKE '%self_portrait%';

	SELECT *
	FROM paintings
	WHERE lower(title) LIKE '%self_portrait%';

/**	Chapter 4: ORDER BY clause
	================================================
	================================================ */

/*	4.01: ORDER BY clause
	================================================ */

	SELECT *
	FROM customers
	ORDER BY id;

/*	4.02: Independant of Columns
	================================================ */

	SELECT familyname, givenname
	FROM customers
	ORDER BY id;

/*	4.03: Include Sorted Column
	================================================ */

	SELECT id, familyname, givenname
	FROM customers
	ORDER BY id;

/*	4.04: Sort Direction
	================================================ */

	SELECT *
	FROM customers
	ORDER BY id DESC;

/*	4.05: Sorting with NULLs
	================================================ */

	SELECT *
	FROM customers
	ORDER BY height;

	SELECT *
	FROM customers
	ORDER BY height DESC;

/*	4.06: NULLS FIRST | LAST
	================================================
--	PostgreSQL, Oracle & SQLite:
	SELECT *
	FROM customers
	ORDER BY height NULLS FIRST;    --	or NULLS LAST
	================================================ */

	SELECT *
	FROM customers
	ORDER BY height NULLS FIRST;
	SELECT *
	FROM customers
	ORDER BY height NULLS LAST;

	--	Pseudo NULLS FIRST
		SELECT *
		FROM customers
		ORDER BY coalesce(height,0);
	--	Pseudo NULLS LAST
		SELECT *
		FROM customers
		ORDER BY coalesce(height,1000);

/*	4.07: Sorting Table
	================================================ */

	SELECT * FROM sorting;

/*	4.08: Sorting Numbers
	================================================ */

	SELECT * FROM sorting ORDER BY numbervalue;
	SELECT * FROM sorting ORDER BY numberstring;
	SELECT * FROM sorting ORDER BY cast(numberstring as integer);

/*	4.09: Sorting Dates
	================================================ */

	SELECT * FROM sorting ORDER BY datevalue;
	SELECT * FROM sorting ORDER BY datestring;
	SELECT * FROM sorting ORDER BY cast(datestring as date);

/*	4.10: Sorting Strings
	================================================ */

	SELECT * FROM sorting ORDER BY stringvalue;

/*	4.11: Sorting Compound Column
	================================================ */

	SELECT id, firstname, lastname, fullname
	FROM sorting
	ORDER BY fullname;

/*	4.12: Sorting Separate Columns
	================================================ */

	SELECT id, firstname, lastname, fullname
	FROM sorting
	ORDER BY lastname, firstname;

/*	4.13: Sorting Independant Columns
	================================================ */

	SELECT *
	FROM paintings
	ORDER BY price, title;

	SELECT *
	FROM paintings
	ORDER BY price, title, id;

/*	4.14: Sorting Dependant Columns
	================================================ */

	SELECT *
	FROM customers
	ORDER BY state, town;

/*	4.15: Sorting Names
	================================================ */

	SELECT *
	FROM customers
	ORDER BY familyname, givenname;

/*	4.16: Sort Direction on Multiple Columns
	================================================ */

	SELECT *
	FROM paintings
	ORDER BY price, title DESC;

	SELECT *
	FROM paintings
	ORDER BY price DESC, title DESC;

/*	4.17: Sorting on Calculation
	================================================ */

	SELECT id, givenname, familyname
	FROM artists
	ORDER BY died - born;

/*	4.18: Include Calculated Column
	================================================ */

	SELECT id, givenname, familyname, died-born
	FROM artists
	ORDER BY died - born;

/*	4.19: Sorting on Alias
	================================================ */

	SELECT id, givenname, familyname, died-born AS age
	FROM artists
	ORDER BY died - born;

	SELECT id, givenname, familyname, died-born AS age
	FROM artists
	ORDER BY age;

	SELECT id, givenname, familyname, died-born AS age
	FROM artists
	WHERE died-born<50	--	not age<50 ∵ age not (yet) available
	ORDER BY age;

/*	4.20: Another Calculated Column
	================================================ */

	SELECT *, length(familyname) AS ln
	FROM customers
	ORDER BY ln;

/*	4.21: Limiting Results
	================================================ */

	SELECT *
	FROM customers
	WHERE dob IS NOT NULL
	ORDER BY dob OFFSET 0 ROWS FETCH FIRST 5 ROWS ONLY;

	SELECT *	FROM customers	WHERE dob IS NOT NULL	ORDER BY dob LIMIT 5 OFFSET 0;/*	4.22: Paged Results
	================================================ */

	--	First Page
		SELECT * FROM paintings
		ORDER BY title OFFSET 0 ROWS FETCH FIRST 20 ROWS ONLY;
	--	Page 4 (skip 3 pages)
		SELECT * FROM paintings
		ORDER BY title OFFSET (3*20) ROWS FETCH FIRST 20 ROWS ONLY;
		SELECT * FROM paintings
		ORDER BY title OFFSET 60 ROWS FETCH FIRST 20 ROWS ONLY;
	--	Reverse Order: Last page first
		SELECT * FROM paintings
		ORDER BY title DESC
		OFFSET 0 ROWS FETCH FIRST 20 ROWS ONLY;

/*	4.23: MSSQL Only - TOP
	================================================ */

/*	4.24: Random Sort
	================================================ */

	SELECT * FROM customers
	ORDER BY random();

/*	4.25: Arbitrary String Sort
	================================================ */

	SELECT *
	FROM sorting
	ORDER BY POSITION(numbername IN 'One,Two,Three,Four,Five,Six,Seven,Eight,Nine');

/**	Chapter 5: Calculations
	================================================ */

/*	5.01: Testing Calculations
	================================================ */

	SELECT 2+5 AS result;

/*	5.02: Dummy Table
	================================================ */

	SELECT count(*);

/*	5.03: Emulating Variables
	================================================ */

	WITH vars AS (SELECT 0.1 AS taxrate)
	SELECT
		id, title, price, price*taxrate AS tax
	FROM paintings, vars;

/*	5.04: Basic Calculations
	================================================ */

	SELECT id, title, price, price*0.1 AS tax
	FROM paintings;

/*	5.05: Basic String Calculations
	================================================ */

	SELECT givenname || ' ' || familyname AS fullname
	FROM customers;

/*	5.06: Working with NULL
	================================================ */

	--	NULLs
		SELECT
			id, givenname, familyname,
			height/2.54 as inches
		FROM customers;

	--	Filter
		SELECT
			id, givenname, familyname,
			height/2.54 as inches
		FROM customers
		WHERE height IS NOT NULL;

/*	5.07: Coalesce
	================================================ */

	SELECT
		id, givenname, familyname,
		phone
	FROM employees;

	SELECT
		id, givenname, familyname,
		coalesce(phone,'1300975707')
	FROM employees;

/*	5.08: Coalesce Number
	================================================ */

	SELECT
		id, saleid, paintingid,
		quantity, price
	FROM saleitems;

	SELECT
		id, saleid, paintingid,
		coalesce(quantity,1), price
	FROM saleitems;

/*	5.09: Coalesce Missing String
	================================================ */

	SELECT
		id, givenname, familyname,
		givenname||' '||familyname AS fullname
	FROM artists;

	SELECT
		id, givenname, familyname,
		coalesce(givenname||' ','') || familyname AS fullname
	FROM artists;

/*	5.10: Using an Alias
	================================================ */

	SELECT
		id, givenname, familyname,
		height/2.54 AS inches
	FROM customers;

/*	5.11: Alias to Another Column
	================================================ */

	SELECT
		id, givenname, familyname,
		height/2.54 AS email	--	probably a bad idea
	FROM customers;

	SELECT
		id,
		givenname AS firstname, familyname AS lastname,
		height/2.54 AS email	--	still probably a bad idea
	FROM customers;

/*	5.12: Alias without AS
	================================================ */

	SELECT
		id,
		givenname firstname, familyname lastname,
		height/2.54 email		--	seriously, probably a bad idea
	FROM customers;

/*	5.13: Errors with Aliases
	================================================ */

	--	Trailing Comma:
		SELECT
			id,
			givenname,
			familyname,
		FROM customers;

	--	Missing Comma:
		SELECT
			id
			givenname,
			familyname
		FROM customers;

/*	5.14: Alias with "quotes"
	================================================ */

	SELECT
		id,
		givenname firstname, familyname lastname,
		height/2.54 AS "inches"
	FROM customers;

/*	5.15: Calculating with Numbers
	================================================ */

	SELECT 1+2*3;						--  1+6 = 7		NOT 9
	SELECT 12/2*3;						--  6*3 = 18	NOT 2
	SELECT (1+2)*3;						--  3*3 = 9		NOT 7
	SELECT 12/(2*3);					--  12/6 = 2    NOT 18
	SELECT 2 * (3 + 4) + 3 * (4 + 5);	--  2*7+3*9 = 14+27 = 41

/*	5.16: Integer Division
	================================================ */

	SELECT 200/7;
	SELECT 	id, quantity, quantity/3 FROM saleitems;

	SELECT 200/7 AS plain, 200.0/7 as decimalised;

	SELECT cast(200 as float)/cast(7 as float);
	SELECT cast(6.5 as int);

/*	5.17: Remainder
	================================================ */

	SELECT 200/7, 200.0/7, 200%7;

/*	5.18: Extra Decimals
	================================================ */

	SELECT
		id, givenname, familyname,
		height/2.54 as inches
	FROM customers;

	SELECT
		id, givenname, familyname,
		round(height/2.54,2) as inches
	FROM customers;

/*	5.19: Mathematical Functions
	================================================ */

	SELECT
		pi() AS pi,
		sin(radians(45)) AS sin45,	--	Trig uses Radians
		sqrt(2) AS root2,			--	√2
		log10(3) AS log3,
		ln(10) AS ln10,			 --	Natural Logarithm
		power(4,3) AS four_cubed	--	4³
	;

/*	5.20: Approximation Functions
	================================================ */

	SELECT
		200/7 AS integer_result,
		200/7.0 AS decimal_result,
		ceiling(200/7.0) AS ceiling,
		floor(200/7.0) AS floor,
		round(200/7.0,0) AS rounded_integer,
		round(200/7.0,2) AS rounded_decimal
	;

/*	5.21: Number Formatting
	================================================ */

	--	Current Locale
		SELECT to_char(total,'FML999G999G999D00')
		FROM sales;
	--	Manual Locale
		SELECT to_char(total,'FM$999,999,999.00')
		FROM sales;

/*	5.22: Current Date & Time
	================================================ */

	SELECT current_date;
	SELECT current_timestamp;

/*	5.23: Date Calculations
	================================================ */

	SELECT		date '2015-10-31' + interval '4 months',		current_timestamp + interval '4 months',		current_timestamp + interval '4' month	--	same	;
/*	5.24: Age Calculations
	================================================ */

	SELECT
		id, givenname, familyname, dob,
		age(dob) AS interval,
		extract(year from age(dob)) AS age
	FROM customers;

/*	5.25: Extracting Parts of a Date
	================================================ */

	WITH moonshot AS (	SELECT		timestamp '1969-07-20 20:17:40' AS datetime		--	FROM dual	--	(Oracle)	)	SELECT		datetime,		EXTRACT(year FROM datetime) AS year,		--	1969		EXTRACT(month FROM datetime) AS month,		--	7		EXTRACT(day FROM datetime) AS day,			--	20		-- not Oracle or MariaDB/MySQL:		EXTRACT(dow FROM datetime) AS weekday,		--	0		EXTRACT(hour FROM datetime) AS hour,		--	20		EXTRACT(minute FROM datetime) AS minute,	--	17		EXTRACT(second FROM datetime) AS second,		--	40		cast(datetime AS DATE) AS thedate	FROM moonshot;

/*	5.26: Formatting a Date
	================================================ */

	WITH vars AS (
		SELECT timestamp '1969-07-20 20:17:40' AS moonshot
	)
	SELECT
		moonshot,
		to_char(moonshot,'FMDay, DDth FMMonth YYYY') AS full,
		to_char(moonshot,'Dy DD Mon YYYY') AS short
	FROM vars;

/*	5.27: Formatting a Month
	================================================ */

	SELECT id, ordered, to_char(ordered,'YYYY-MM') AS month
	FROM sales;

/*	5.28: Formatting a Week Day
	================================================ */

	SELECT
		id, ordered,
		to_char(ordered,'Dy') AS weekday		--	or 'Day'
	FROM sales;

/*	5.29: String Length
	================================================ */

	SELECT length('abcde');

/*	5.30: Search for Substring
	================================================
	POSITION(value IN 'values')
	================================================ */

	SELECT position('m' in 'abcdefghijklmnop');

/*	5.31: Replace String
	================================================
	replace(original,search,replace)
	================================================ */

	SELECT replace('text with spaces',' ','-');

/*	5.32: Change Case
	================================================ */

	SELECT lower('mIxEd cAsE'), upper('mIxEd cAsE'), initcap('mIxEd cAsE');

/*	5.33: Trim
	================================================ */

	SELECT rtrim(ltrim(' abcdefghijklmnop '));
	SELECT trim(' abcdefghijklmnop ');

/*	5.34: Substring
	================================================
	AKA substring()
	================================================ */

	SELECT substr('abcdefghijklmnop',3,5);	--	Results in: cdefg

/*	5.35: Left & Right
	================================================ */

	SELECT left('abcdefghijklmnop',5);	--	Can also use substr(string,1,n)
	SELECT right('abcdefghijklmnop',4);

/*	5.36: Format Phone Number
	================================================
	Format: 00 0000 0000
	================================================ */

	SELECT		id, givenname, familyname,		left(phone,2)||' '||substr(phone,3,4)||' '||right(phone,4) AS phone	FROM customers;

/*	5.37: Sub Queries
	================================================ */

	SELECT (SELECT title FROM paintings WHERE id=123);

/*	5.38: Subquery to get Artist
	================================================ */

	SELECT
		id,
		artistid,
		title, price,
		(SELECT nationality FROM artists WHERE id=artistid) AS nationality
	FROM paintings;

/*	5.39: Multiple Subqueries
	================================================ */

	--	Doesn’t work:
		SELECT
			id,
			(SELECT givenname, familyname FROM artists WHERE  artists.id=paintings.artistid),
			title, price,
			(SELECT nationality FROM artists WHERE artists.id=paintings.artistid) AS nationality
		FROM paintings;

	--	This works:
		SELECT
			id,
			(SELECT givenname||' '||familyname FROM artists WHERE  artists.id=paintings.artistid) AS artist,
			title, price,
			(SELECT nationality FROM artists WHERE artists.id=paintings.artistid) AS nationality
		FROM paintings;

/*	5.40: CASE
	================================================ */

	SELECT
		id, title, price,	--	basic values
		CASE
			WHEN price<130 THEN 'cheap'
		END AS price_group
	FROM paintings;

	SELECT
		id, title, price,	--	basic values
		CASE
			WHEN price<130 THEN 'cheap'
			WHEN price<=170 THEN 'reasonable'
		END AS price_group
	FROM paintings;

	SELECT
		id, title, price,	--	basic values
		CASE
			WHEN price<130 THEN 'cheap'
			WHEN price<=170 THEN 'reasonable'
			WHEN price>170 THEN 'luxury'
		END AS price_group
	FROM paintings;

/*	5.41: Simple CASE
	================================================ */

	SELECT
		id, email,
		CASE
			WHEN spam=1 THEN 'yes'
			WHEN spam=0 THEN 'no'
			ELSE ''					--	empty string
		END AS spam
	FROM customers;

	SELECT
		id, email,
		CASE spam
			WHEN 1 THEN 'yes'
			WHEN 0 THEN 'no'
			ELSE ''					--	empty string
		END AS spam
	FROM customers;

/*	5.42: Cast to String
	================================================ */

	--	Mixed Types
		SELECT
			id || ': ' || givenname || ' ' || familyname || ' - ' || dob
			AS info
		FROM customers;

	--	Using Cast
		SELECT
			cast(id AS varchar(5))||': '||givenname||' '
				||familyname||' - '||cast(dob as varchar(12))
			AS info
		FROM customers;

/*	5.43: Cast with Coalesce
	================================================
	================================================ */

	SELECT
		cast(id AS varchar(5))||': '||givenname||' '||familyname
		||coalesce(' - '||cast(dob as varchar(12)),'') AS info
	FROM customers;

/*	5.44: Cast to Date
	================================================ */

	--	This works
		SELECT cast('20 Jul 1969' as date) AS moon_landing;

	--	This may:
		SELECT cast('tomorrow' as date) AS birthday;

	--	This doesn’t
		SELECT cast('whatever' as date) AS birthday;

/*	5.45: Price List
	================================================ */

	SELECT
		id,
		(SELECT givenname||' '||familyname FROM artists WHERE artists.id=paintings.artistid) AS artist,
		title,
		price, price*0.1 AS tax, price*1.1 AS inc,
		CASE
			WHEN price<130 THEN 'cheap'
			WHEN price<=170 THEN 'reasonable'
			WHEN price>170 THEN 'expensive'
			ELSE ''
		END AS pricegroup,
		(SELECT nationality FROM artists WHERE artists.id=paintings.artistid) AS nationality
	FROM paintings;

/*	5.46: Create View
	================================================
	CREATE VIEW pricelist AS
	SELECT
		id,
		(SELECT givenname||' '||familyname FROM artists WHERE artists.id=paintings.artistid) AS artist,
		title,
		price, price*0.1 AS tax, price*1.1 AS inc,
		CASE
			WHEN price<130 THEN 'cheap'
			WHEN price<=170 THEN 'reasonable'
			WHEN price>170 THEN 'expensive'
			ELSE ''
		END AS pricegroup,
		(SELECT nationality FROM artists WHERE artists.id=paintings.artistid) AS nationality
	FROM paintings;
	================================================ */

	CREATE VIEW pricelist AS
	SELECT
		id,
		(SELECT givenname||' '||familyname FROM artists WHERE artists.id=paintings.artistid) AS artist,
		title,
		price, price*0.1 AS tax, price*1.1 AS inc,
		CASE
			WHEN price<130 THEN 'cheap'
			WHEN price<=170 THEN 'reasonable'
			WHEN price>170 THEN 'expensive'
			ELSE ''
		END AS pricegroup,
		(SELECT nationality FROM artists WHERE artists.id=paintings.artistid) AS nationality
	FROM paintings;

	SELECT * FROM pricelist;

/*	5.47: DROP VIEW
	================================================ */

	DROP VIEW IF EXISTS pricelist;

/**	Chapter 6: Joining Tables
	================================================
	================================================ */

/*	6.01: Basic JOIN
	================================================ */

	SELECT *
	FROM paintings JOIN artists ON paintings.artistid=artists.id;

	SELECT *
	FROM artists JOIN paintings ON paintings.artistid=artists.id;

	SELECT *
	FROM paintings,artists WHERE paintings.artistid=artists.id;

/*	6.02: Filtered JOIN
	================================================ */

	SELECT *
	FROM paintings JOIN artists ON paintings.artistid=artists.id
	WHERE price<150;

	SELECT *
	FROM paintings,artists WHERE paintings.artistid=artists.id
		AND price<150;

/*	6.03: Selecting Columns
	================================================ */

	--	This won’t work:
		SELECT
			id,
			title,
			givenname, familyname
		FROM paintings JOIN artists ON paintings.artistid=artists.id;

	--	This will:
		SELECT
			paintings.id,
			title,
			givenname, familyname
		FROM paintings JOIN artists ON paintings.artistid=artists.id;

	--	This is better:
		SELECT
			paintings.id,
			paintings.title,
			artists.givenname, artists.familyname
		FROM paintings JOIN artists ON paintings.artistid=artists.id;

/*	6.04: Aliasing Tables
	================================================ */

	--	Standard
		SELECT
			p.id,
			p.title,
			a.givenname, a.familyname
		FROM paintings AS p JOIN artists AS a ON p.artistid=a.id;

	--	Without table AS
		SELECT
			p.id,
			p.title,
			a.givenname, a.familyname
		FROM paintings p JOIN artists a ON p.artistid=a.id;

/*	6.05: Developing a Price List
	================================================ */

	SELECT
		p.id,
		p.title,
		a.givenname||' '||a.familyname AS artist,
		a.nationality,
		p.price, p.price*0.1 AS tax, p.price*1.1 AS total
	FROM paintings AS p JOIN artists AS a ON p.artistid=a.id;

/*	6.06: Unmatched Paintings
	================================================ */

	SELECT *
	FROM paintings
	WHERE artistid IS NULL;

/*	6.07: Unmatched Artists
	================================================ */

	SELECT *
	FROM artists
	WHERE id NOT IN (SELECT artistid FROM paintings WHERE artistid IS NOT NULL);


/*	6.08: INNER JOIN
	================================================ */

	SELECT *
	FROM minipaintings AS p INNER JOIN miniartists AS a ON p.artistid=a.id;

/*	6.09: OUTER JOINs
	================================================ */

	--	minipaintings on left
		SELECT *
		FROM minipaintings AS p LEFT OUTER JOIN miniartists AS a ON p.artistid=a.id;

	--	minipaintings on right
		SELECT *
		FROM miniartists AS a RIGHT OUTER JOIN minipaintings AS p ON a.id=p.artistid;

	--	without OUTER
		SELECT *
		FROM minipaintings AS p LEFT JOIN miniartists AS a ON p.artistid=a.id;

		SELECT *
		FROM miniartists AS a RIGHT JOIN minipaintings AS p ON a.id=p.artistid;

/*	6.10: Parent OUTER JOIN
	================================================ */

	SELECT *
	FROM minipaintings AS p RIGHT JOIN miniartists AS a ON p.artistid=a.id;

	SELECT *
	FROM miniartists AS a LEFT JOIN minipaintings AS p ON a.id=p.artistid;

/*	6.11: Unmatched Parents
	================================================ */

	SELECT a.*
	FROM minipaintings AS p RIGHT JOIN miniartists AS a ON p.artistid=a.id
	WHERE p.id IS NULL;

/*	6.12: VIEW with JOIN
	================================================
	================================================ */

	DROP VIEW IF EXISTS pricelist;

	CREATE VIEW pricelist AS
	SELECT
		p.id,
		p.title,
		a.givenname||' '||a.familyname AS artist,
		a.nationality,
		p.price, p.price*0.1 AS tax, p.price*1.1 AS total
	FROM paintings AS p LEFT JOIN artists AS a ON p.artistid=a.id
	WHERE p.price IS NULL;

	SELECT * FROM pricelist;

/*	6.13: Joining Many Tables
	================================================ */

	SELECT *
	FROM
		customers AS c
		JOIN sales AS s ON c.id=s.customerid
		JOIN saleitems AS si ON s.id=si.saleid
		JOIN paintings AS p ON si.paintingid=p.id
		JOIN artists AS a ON p.artistid=a.id;

/*	6.14: Refining the Query
	================================================ */

	SELECT
		c.id,
		c.givenname, c.familyname,
		s.id,
		a.givenname||' '||a.familyname AS artist
	FROM
		customers AS c
		JOIN sales AS s ON c.id=s.customerid
		JOIN saleitems AS si ON s.id=si.saleid
		JOIN paintings AS p ON si.paintingid=p.id
		JOIN artists AS a ON p.artistid=a.id;

/*	6.15: Alias for s.id
	================================================ */

	SELECT
		c.id,
		c.givenname, c.familyname,
		s.id AS sid,
		a.givenname||' '||a.familyname AS artist
	FROM
		customers AS c
		JOIN sales AS s ON c.id=s.customerid
		JOIN saleitems AS si ON s.id=si.saleid
		JOIN paintings AS p ON si.paintingid=p.id
		JOIN artists AS a ON p.artistid=a.id;

/*	6.16: Ordering the Result
	================================================ */

	SELECT		c.id,		c.givenname, c.familyname,		s.id AS sid,		a.givenname||' '||a.familyname AS artist	FROM		customers AS c		JOIN sales AS s ON c.id=s.customerid		JOIN saleitems AS si ON s.id=si.saleid		JOIN paintings AS p ON si.paintingid=p.id		JOIN artists AS a ON p.artistid=a.id	 ORDER BY c.familyname, c.givenname;

/*	6.17: Using DISTINCT
	================================================ */

	SELECT DISTINCT		c.id,		c.givenname, c.familyname,		s.id AS sid,		a.givenname||' '||a.familyname AS artist	FROM		customers AS c		JOIN sales AS s ON c.id=s.customerid		JOIN saleitems AS si ON s.id=si.saleid		JOIN paintings AS p ON si.paintingid=p.id		JOIN artists AS a ON p.artistid=a.id	 ORDER BY c.familyname, c.givenname;

/*	6.18: Not using c.id
	================================================ */

	SELECT DISTINCT
	--	c.id,
		c.givenname, c.familyname,
		s.id AS sid,
		a.givenname||' '||a.familyname AS artist
	FROM
		customers AS c
		JOIN sales AS s ON c.id=s.customerid
		JOIN saleitems AS si ON s.id=si.saleid
		JOIN paintings AS p ON si.paintingid=p.id
		JOIN artists AS a ON p.artistid=a.id
	 ORDER BY c.familyname, c.givenname;

/*	6.19: Big Spenders Again
	================================================ */

	--	Sub Query
		SELECT *
		FROM customers
		WHERE id IN(SELECT customerid FROM sales WHERE total>1200);

	--	Using JOIN
		SELECT DISTINCT c.*
		FROM customers AS c JOIN sales AS s on c.id=s.customerid
		WHERE s.total>1200;

	--	Using DISTINCT
		SELECT DISTINCT c.*, s.total
		FROM customers AS c JOIN sales AS s on c.id=s.customerid
		WHERE s.total>1200;

/*	6.20: Dutch Artists Again
	================================================ */

	--	Sub Query
		SELECT *
		FROM paintings
		WHERE artistid IN (
			SELECT id FROM artists  WHERE nationality IN ('Dutch','Netherlandish')
		);

	--	Using JOIN
		SELECT p.*
		FROM paintings AS p JOIN artists AS a on p.artistid=a.id
		WHERE a.nationality IN ('Dutch','Netherlandish');

/*	6.21: One to One JOIN
	================================================ */

	--	artistsdates Table
		SELECT * FROM artistsdates;

	--	JOIN Tables
		SELECT *
		FROM artists JOIN artistsdates ON artists.id=artistsdates.id;

	--	Select Columns
		SELECT a.id, a.givenname, a.familyname, ad.borndate
		FROM artists AS a JOIN artistsdates AS ad ON a.id=ad.id;

	--	Natural Join
		SELECT *
		FROM artists NATURAL JOIN artistsdates;

/*	6.22: Format as Birthday
	================================================ */

	SELECT to_char(dob,'MM-DD') AS birthday FROM customers;

/*	6.23: JOIN on Birthday
	================================================ */

	SELECT
		c.id, c.givenname, c.familyname, c.dob,
		a.id, a.givenname, a.familyname, ad.borndate
	FROM
		artists AS a
		JOIN artistsdates AS ad ON a.id=ad.id
		JOIN customers AS c ON
			to_char(ad.borndate,'MM-DD')=
			to_char(c.dob,'MM-DD');

/*	6.24: Employees Table
	================================================ */

	SELECT * FROM employees ORDER BY id;

/*	6.25: Supervisor as Sub Query
	================================================ */

	--	This won’t work:		SELECT			id, supervisorid, givenname, familyname,			(				SELECT givenname||' '||familyname FROM employees				WHERE employees.supervisorid=employees.id			) as supervisor		FROM employees		ORDER BY id;	--	This will work		SELECT			id, supervisorid, givenname, familyname,			(				SELECT givenname||' '||familyname				FROM employees AS supervisors				WHERE employees.supervisorid=supervisors.id			) as supervisor		FROM employees		ORDER BY id;

/*	6.26: Supervisor as JOIN
	================================================ */

	--	This won’t work either:
		SELECT
			id, supervisorid, givenname, familyname,
			givenname||' '||familyname as supervisor
		FROM employees AS e JOIN employees AS s
			ON e.supervisorid=s.id
		ORDER BY id;

	--	This Works
		SELECT
			e.id, e.supervisorid, e.givenname, e.familyname,
			s.givenname||' '||s.familyname as supervisor
		FROM employees AS e JOIN employees AS s ON e.supervisorid=s.id
		ORDER BY e.id;

	--	Include Top Level
		SELECT
			e.id, e.supervisorid, e.givenname, e.familyname,
			s.givenname||' '||s.familyname as supervisor
		FROM employees AS e LEFT JOIN employees AS s
			ON e.supervisorid=s.id
		ORDER BY e.id;


/**	Chapter 7: Aggregating Data
	================================================
	================================================ */

/*	7.01: Count
	================================================ */

	SELECT count(*) FROM customers;

/*	7.02: Filtered
	================================================ */

	SELECT count(*) AS countrows
	FROM customers
	WHERE height<160.5;

/*	7.03: Counting Values
	================================================ */

	SELECT
		count(*) as countrows,
		count(id) as ids,					--	same
		count(email) as emails,				--	same again
		count(familyname) as familynames,	--	same again
		count(phone) as phones,
		count(state) as states
	FROM customers;

/*	7.04: GROUP BY ()
	================================================ */

	--	GROUP BY ()
		SELECT
			count(*) as countrows,
			count(phone) as phones,
			count(dob) as dobs
		FROM customers
		GROUP BY ()
		--	SELECT
		;

	--	This won’t work:
		SELECT
			id, givenname, familyname,		--	etc, it doesn’t matter
			count(*) as countrows,
			count(phone) as phones,
			count(dob) as dobs
		FROM customers
		--	GROUP BY ()
		;


/*	7.05: Counting Selectively
	================================================ */

	--	Count All
		SELECT count(price) FROM paintings;

	--	Filter
		SELECT count(price) FROM paintings WHERE price<130;

	--	This won’t work as expected:
		SELECT count(price<130) FROM paintings;

	--	Aggregate Filter
		SELECT count(price) FILTER (WHERE price<130) FROM paintings;/*	7.06: CASE
	================================================ */

	SELECT
		id, title, price,
		CASE
			WHEN price<130 THEN 'inexpensive'
			WHEN price<=170 THEN 'reasonable'
			WHEN price>170 THEN 'prestige'
		END as pricegroup
	FROM paintings;

	SELECT
		id, title, price,
		CASE WHEN price<130 THEN 'cheap' END as status
	FROM paintings;

	SELECT count(CASE WHEN price<130 THEN 1 END) AS cheap
	FROM paintings;

/*	7.07: count(CASE)
	================================================ */

	SELECT
		count(CASE WHEN price<130 THEN 1 END) AS cheap,
		count(CASE WHEN price BETWEEN 130 AND 170 THEN 1 END) AS reasonable,
		count(CASE WHEN price>=170 THEN 1 END) AS expensive
	FROM paintings;

/*	7.08: count(spam)
	================================================ */

	SELECT
		count(*) AS total,
		count(spam) AS known,
		count(CASE spam WHEN true THEN 1 END) AS yes,
		count(CASE spam WHEN false THEN 1 END) AS no
	FROM customers;

/*	7.09: Count NULLs
	================================================ */

	SELECT count(*)-count(spam) AS nulls FROM customers;

	SELECT
		count(*) AS total,
		--	etc
		count(CASE WHEN spam IS NULL THEN 1 END) AS unknown
	FROM customers;

/*	7.10: count(DISTINCT)
	================================================ */

	--	Probably not correct:
		SELECT
			count(state) AS states
		FROM customers;

	--	List distinct states:
		SELECT DISTINCT state
		FROM customers;

	--	Count distinct states:
		SELECT
			count(state) AS addresses,
			count(DISTINCT state) AS states
		FROM customers;

/*	7.11: Summarising Numbers
	================================================ */

	SELECT
		count(height) as heights,
		sum(height) AS total,
		avg(height) AS average,
		sum(height)/count(height) AS computed_average,
		stddev(height) AS sd,
		sum(height)/count(*) AS not_ca,
		avg(coalesce(height,0)) AS not_ca_again
	FROM customers;

/*	7.12: Bad Example
	================================================ */

	--	Dont do any of this:
		SELECT
			sum(id) AS total_id,
			sum(price) AS total_price,
			sum(year) AS total_year
		FROM paintings;

/*	7.13: Aggregating Calculated
	================================================ */

	SELECT * FROM saleitems;

	SELECT
		sum(quantity) AS total_copies,
		sum(quantity*price) AS total_value
	FROM saleitems;

	SELECT
		sum(coalesce(quantity,1)) AS total_copies,
		sum(coalesce(quantity,1)*price) AS total_value
	FROM saleitems;

	SELECT sum(total) FROM sales;

/*	7.14: Other Aggregate Functions
	================================================ */

	SELECT
		min(height) as shortest, max(height) as tallest,
		min(dob) as oldest, max(dob) as youngest,
		min(familyname) as first, max(familyname) as last
	FROM customers;

/*	7.15: Min & Max on Data Types
	================================================ */

	SELECT
		count(*) AS countrows,
		max(numbervalue) AS most, min(numbervalue) AS least,
		max(datevalue) AS latest, min(datevalue) AS earliest,
		max(stringvalue) AS last, min(stringvalue) AS first
	FROM sorting;

/*	7.16: Oldest Customer
	================================================ */

	SELECT min(dob) FROM customers;

	SELECT * FROM customers
	WHERE dob=(SELECT min(dob) FROM customers);

/*	7.17: Customer with Largest Sale
	================================================ */

	--	Customer id
		SELECT customerid FROM sales
		WHERE total=(SELECT max(total) FROM sales);

	--	Customer Details
		SELECT *
		FROM customers
		WHERE id IN (
			SELECT customerid FROM sales
			WHERE total=(SELECT max(total) FROM sales)
		);

/*	7.18: Shorter than Average
	================================================ */

	SELECT * FROM customers
	WHERE height<(SELECT avg(height) FROM customers);

	SELECT * FROM customers
	WHERE height<(SELECT avg(height)-stddev(height) FROM customers);

/*	7.19: Multiple Individual Groups
	================================================ */

	SELECT count(*) FROM customers WHERE state='VIC';
	SELECT count(*) FROM customers WHERE state='NSW';
	SELECT count(*) FROM customers WHERE state='QLD';

/*	7.20: Combined Groups
	================================================ */

	SELECT count(*) AS countrows FROM customers WHERE state='VIC'
	UNION ALL
	SELECT count(*) AS countrows FROM customers WHERE state='NSW'
	UNION ALL
	SELECT count(*) AS countrows FROM customers WHERE state='QLD';

	SELECT 'vic' AS state, count(*) AS countrows FROM customers WHERE state='VIC'
	UNION ALL
	SELECT 'nsw' AS state, count(*) AS countrows FROM customers WHERE state='NSW'
	UNION ALL
	SELECT 'qld' AS state, count(*) AS countrows FROM customers WHERE state='QLD';

/*	7.21: GROUP BY
	================================================ */

	SELECT count(*) AS countrows
	FROM customers
	GROUP BY state;

	SELECT state, count(*) AS countrows
	FROM customers
	GROUP BY state;

/*	7.22: GROUP BY Multiple Columns
	================================================ */

	SELECT state, town, count(*) AS countrows
	FROM customers
	GROUP BY state, town;

	SELECT state, town, count(*) AS countrows
	FROM customers
	GROUP BY state, town
	ORDER BY state, town;

	SELECT town, state, count(*) AS countrows
	FROM customers
	GROUP BY state, town
	ORDER BY state, town;

/*	7.23: Sales per Customer
	================================================ */

	SELECT customerid, sum(total) as total, count(*) AS countrows
	FROM sales
	GROUP BY customerid
	ORDER BY customerid;

/*	7.24: GROUP BY vs DISTINCT
	================================================ */

	SELECT state, town
	FROM customers
	GROUP BY state, town
	ORDER BY state, town;

	SELECT DISTINCT state, town	--	same result
	FROM customers
	ORDER BY state, town;

/*	7.25: Grouping with Multiple Tables
	================================================ */

	--	Just customer id
		SELECT
			customerid,
			count(*) AS number_of_sales,
			sum(total) AS total
		FROM sales
		GROUP BY customerid
		ORDER BY total, customerid;

	--	Sub Query
		SELECT
			customerid,
			(SELECT givenname||' '||familyname FROM customers WHERE customers.id = sales.customerid ) AS customer,
			count(*) AS number_of_sales, sum(total) AS total
		FROM sales
		GROUP BY customerid
		ORDER BY total, customerid;

	--	Join
		SELECT
			c.id, c.givenname||' '||c.familyname AS customer,
			count(*) AS number_of_sales, sum(s.total) AS total
		FROM sales AS s JOIN customers AS c ON s.customerid=c.id
		GROUP BY c.id, c.givenname,c.familyname
		ORDER BY total, c.id;

	--	using CTE
		WITH cte AS (
			SELECT
				c.id, c.givenname||' '||c.familyname AS customer,
				s.total
			FROM customers AS c JOIN sales AS s ON c.id=s.customerid
		)
		SELECT id, customer, count(*) AS number_of_sales, sum(total) AS total
		FROM cte
		GROUP BY id, customer
		ORDER BY total, id;

/*	7.26: Redundant Groups
	================================================ */

	SELECT state, count(*) AS countrows
	FROM customers
	GROUP BY state, state;

	SELECT to_char(ordered,'FMDay') AS dayname,		sum(total) AS total	FROM sales	GROUP BY to_char(ordered,'FMDay'), to_char(ordered,'D')	ORDER BY to_char(ordered,'D');

/*	7.27: Using Dummy Aggregate
	================================================ */

	WITH cte AS (
		SELECT c.id, c.givenname||' '||c.familyname AS customer, s.total
		FROM customers AS c JOIN sales AS s ON c.id=s.customerid
	)
	SELECT id, min(customer), count(*) AS number_of_sales, sum(total) AS total
	FROM cte
	GROUP BY id
	ORDER BY total, id;

/*	7.28: Preparing Data for Aggregating
	================================================ */

	SELECT * FROM sales;

	SELECT cast(ordered as date) as ordered, total FROM sales;

	WITH data AS (
		SELECT cast(ordered as date) as ordered, total FROM sales
	)
	SELECT ordered, sum(total) AS total
	FROM data
	GROUP BY ordered;

	--	Sub Query Version
		SELECT ordered, sum(total) AS total
		FROM (
			SELECT cast(ordered as date) as ordered, total FROM sales
		) AS data
		GROUP BY ordered;

/*	7.29: Using CASE in a CTE
	================================================ */

	SELECT
		id, title,
		CASE
			WHEN price < 130 THEN 'cheap'
			WHEN price <= 170 THEN 'reasonable'
			WHEN price IS NOT NULL THEN 'expensive'
			ELSE 'unpriced'
		END AS price_category
	FROM paintings;

	WITH cte AS (
		SELECT
			id, title,
			CASE
				WHEN price < 130 THEN 'cheap'
				WHEN price <= 170 THEN 'reasonable'
				WHEN price IS NOT NULL THEN 'expensive'
				ELSE 'unpriced'
			END AS price_category
		FROM paintings
	)
	SELECT price_category, count(*) AS count
	FROM cte
	GROUP BY price_category;

/*	7.30: Using a Join in the CTE
	================================================ */

	SELECT c.state, s.total
	FROM customers AS c JOIN sales AS s ON c.id=s.customerid;

	WITH cte AS (
		SELECT c.state, s.total
		FROM customers AS c JOIN sales AS s ON c.id=s.customerid
	)
	SELECT state, sum(total) AS total
	FROM cte
	GROUP BY state;

/*	7.31: Summarising Strings
	================================================ */

	WITH cte AS (
		SELECT DISTINCT
			c.id,
			c.givenname, c.familyname,
			s.id AS sid,
			a.givenname||' '||a.familyname AS artist
		FROM
			customers AS c
			JOIN sales AS s ON c.id=s.customerid
			JOIN saleitems AS si ON s.id=si.saleid
			JOIN paintings AS p ON si.paintingid=p.id
			JOIN artists AS a ON p.artistid=a.id
	)
	SELECT id, givenname, familyname, string_agg(artist, ', ')
	FROM cte
	GROUP BY id, givenname, familyname
	ORDER BY familyname, givenname, id;

/*	7.32 Filtering with HAVING
	================================================ */

	SELECT customerid, sum(total) AS total, count(*) AS countrows
	FROM sales
	GROUP BY customerid
	HAVING sum(total)>2000
	--	SELECT
	ORDER BY customerid;

/*	7.33: Using WHERE and HAVING
	================================================
	--	PostgreSQL
		WHERE ordered>current_timestamp - INTERVAL '1' MONTH
	--	MSSQL
		WHERE ordered>dateadd(month,-1,current_timestamp)
	--	SQLite:
		WHERE ordered>date('now','-1 month')
	--	OracleOracle:
		WHERE ordered>add_months(current_timestamp,-1)
	================================================ */

	SELECT customerid, sum(total) AS total, count(*) AS countrows
	FROM sales
	WHERE ordered>current_timestamp - INTERVAL '1' MONTH
	GROUP BY customerid
	HAVING sum(total)>2000
	--	SELECT
	ORDER BY customerid;

	WITH cte AS (
		SELECT customerid, sum(total) AS total
		FROM sales
		WHERE ordered>current_timestamp - INTERVAL '1' MONTH
		GROUP BY customerid
		HAVING sum(total)>2000
	)
	SELECT *
	FROM customers JOIN cte ON customers.id=cte.customerid
	ORDER BY customers.id;

/*	7.34: Duplicate Dates of Birth
	================================================ */

	SELECT dob FROM customers GROUP BY dob HAVING count(*)>1;

	WITH cte AS (
		SELECT dob FROM customers GROUP BY dob HAVING count(*)>1
	)
	SELECT *
	FROM customers AS c JOIN cte ON c.dob=cte.dob
	ORDER BY c.dob;

/*	7.35: Duplicate Names
	================================================ */

	SELECT familyname, givenname
	FROM customers
	GROUP BY familyname, givenname
	HAVING count(*)>1;

	WITH cte AS (
		SELECT familyname, givenname
		FROM customers
		GROUP BY familyname, givenname HAVING count(*)>1
	)
	SELECT *
	FROM
		customers AS c JOIN cte ON c.givenname=cte.givenname AND c.familyname=cte.familyname
	ORDER BY c.familyname, c.givenname;

/*	7.36: Aggregates in Aggregates
	================================================
	The Most Popular Paintings
	================================================ */

	SELECT paintingid, count(*) AS countrows
	FROM saleitems
	GROUP BY paintingid;

	SELECT paintingid, sum(coalesce(quantity,1)) AS quantity
	FROM saleitems
	GROUP BY paintingid;

	WITH quantities AS (
		SELECT paintingid, sum(coalesce(quantity,1)) AS quantity
		FROM saleitems
		GROUP BY paintingid
	)
	SELECT paintingid, quantity
	FROM quantities
	GROUP BY paintingid, quantity;

	WITH quantities AS (
		SELECT paintingid, sum(coalesce(quantity,1)) AS quantity
		FROM saleitems
		GROUP BY paintingid
	)
	SELECT paintingid, quantity
	FROM quantities
	GROUP BY paintingid, quantity
	HAVING quantity=(SELECT max(quantity) FROM quantities);


/*	7.37: Popular Paintings with Details
	================================================ */

	WITH
		quantities AS (
			SELECT paintingid, sum(coalesce(quantity,1)) AS quantity
			FROM saleitems
			GROUP BY paintingid
		),
		favourites AS (
			SELECT paintingid, quantity
			FROM quantities
			GROUP BY paintingid, quantity
			HAVING quantity=(SELECT max(quantity) FROM quantities)
		)
	SELECT *
	FROM paintings
	JOIN favourites ON paintings.id=favourites.paintingid;


/**	Chapter 8: Working with Tables
	================================================
	================================================ */

/*	8.01: Adding a Row
	================================================
	oops!
	================================================ */

	SELECT setval(pg_get_serial_sequence('customers', 'id'), max(id)) FROM customers;

	INSERT INTO customers(givenname, familyname, email, registered)
	VALUES ('Norris', 'Lurker', 'norris.lurker@example.com', current_timestamp);

	INSERT INTO customers(givenname, familyname, email, registered)
	VALUES ('Norris', 'Lurker', 'norris.lurker@example.net', current_timestamp);

/*	8.02: Selecting Rows
	================================================ */

	SELECT * FROM customers ORDER BY id DESC;

/*	8.03: Test Delete with Transaction
	================================================
	MySQL / MariaDB:
		START TRANSACTION;
		…
		ROLLBACK;
	SQLite, Oracle
		Can’t run one line at a time
	================================================ */

	BEGIN TRANSACTION;
	DELETE FROM minipaintings;
	SELECT * FROM minipaintings;
	ROLLBACK;
	SELECT * FROM minipaintings;

/*	8.04: Delete Customer
	================================================
	Get latest id
	================================================ */

	DELETE
	FROM customers
	WHERE id= … ;

	SELECT * FROM customers;

/*	8.05: Adding More Rows
	================================================
	Not Oracle:
		INSERT INTO customers(givenname, familyname, email, registered)
		VALUES
		  ('Sylvia','Nurke', 'sylvia.nurke@example.com', current_date),
		  ('Murgatroyd','Murdoch', 'murgatroyd.murdoch@example.com', current_timestamp)
		  --	etc
		  ;
	================================================ */

	INSERT INTO customers(givenname, familyname, email, registered)
	VALUES
	  ('Sylvia','Nurke', 'sylvia.nurke@example.com', current_date),
	  ('Murgatroyd','Murdoch', 'murgatroyd.murdoch@example.com', current_timestamp)
	  --	etc
	 ;

	INSERT INTO customers(givenname, familyname, email, registered)
	VALUES ('Sylvia','Nurke', 'sylvia.nurke@example.com', current_timestamp);
	INSERT INTO customers(givenname, familyname, email, registered)
	VALUES ('Murgatroyd','Murdoch', 'murgatroyd.murdoch@example.com', current_timestamp);
	--	etc
	;

/*	8.06: Add Phone Number
	================================================ */

	UPDATE customers
	SET phone='0370101234'
	WHERE id= … ;
	--	Don’t do this!
		UPDATE customers
		SET phone='0370101234';

/*	8.07: Price Increase
	================================================ */

	--	Don’t run this unless you really want to:
		UPDATE paintings SET price=price*0.1;

/*	8.08: Add Unique Index
	================================================
	CREATE UNIQUE INDEX uq_customers_phone ON customers(phone);
	================================================ */

	CREATE UNIQUE INDEX uq_customers_phone ON customers(phone)
	WHERE phone IS NOT NULL;

/*	8.09:	Altering the Table
	================================================
	--	MySQL / MariaDB
		ALTER TABLE customers
		ADD country varchar(48)
		AFTER postcode;
	================================================ */

	ALTER TABLE customers
	ADD country varchar(48);

/*	8.10: Set Country
	================================================ */

	UPDATE customers
	SET country='Australia'		--	or whatever
	WHERE state IS NOT NULL;

/**	Chapter 9: Set Operations
	================================================
	================================================ */

/*	9.01: Two Sets
	================================================ */

	SELECT givenname, familyname FROM customers;
	SELECT givenname, familyname FROM employees;

/*	9.02: UNION
	================================================ */

	SELECT givenname, familyname FROM customers
	UNION
	SELECT givenname, familyname FROM employees;

/*	9.03: UNION ALL
	================================================ */

	SELECT givenname, familyname FROM customers
	UNION ALL
	SELECT givenname, familyname FROM employees;

/*	9.04: UNION with Extra Columns
	================================================ */

	SELECT givenname, familyname, email FROM customers
	UNION ALL
	SELECT givenname, familyname, email FROM employees ;

/*	9.05: Additional SELECTs
	================================================ */

	SELECT givenname, familyname FROM customers
	UNION ALL
	SELECT givenname, familyname FROM employees
	UNION ALL
	SELECT givenname, familyname FROM artists ;

/*	9.06: Selective Unions
	================================================ */

	SELECT givenname, familyname, email FROM customers WHERE state='VIC'
	UNION ALL
	SELECT givenname, familyname, email FROM employees ;

	SELECT givenname, familyname, email FROM customers WHERE state='VIC'
	UNION ALL
	SELECT givenname, familyname, email FROM customers WHERE dob<'1980-01-01';

	SELECT givenname, familyname, email FROM customers
	WHERE state='VIC' OR dob<'1980-01-01';

/*	9.07: Compatible SELECTs
	================================================
	MySQL / MariaDB will match types
	SQLite Ignores Types
	================================================ */

	--	Wrong Number of Columns:
		SELECT givenname, familyname, email	--	3 columns
		FROM customers
		UNION ALL
		SELECT givenname, familyname		--	2 columns
		FROM employees;

	--	Incompatible Types
		SELECT /* string: */ email, givenname, familyname
		FROM customers
		UNION ALL
		SELECT /* number: */ id, givenname, familyname
		FROM employees;

	--	Use Cast to Match Types
		SELECT email, givenname, familyname FROM customers
		UNION ALL
		SELECT cast(id as varchar(4)), givenname, familyname FROM employees ;

/*	9.08: Column Names don’t matter
	================================================ */

	--  Problem: Reversed Columns
		SELECT givenname, familyname FROM customers
		UNION ALL
		SELECT familyname, givenname FROM employees;

	--  Problem: Mis-aligned Columns
		SELECT email, givenname, familyname FROM customers
		UNION ALL
		SELECT givenname, familyname, email FROM employees;

	--	This is OK:
		SELECT givenname, familyname FROM customers
		UNION ALL
		SELECT firstname, lastname FROM sorting ;

/*	9.09: Column Names
	================================================ */

	SELECT givenname AS gn, familyname FROM customers
	UNION ALL
	SELECT givenname, familyname AS fn FROM employees;

/*	9.10: Sorting
	================================================ */

	--	Doomed to failure
		SELECT givenname, familyname, email FROM customers
			ORDER BY familyname, givenname
		UNION ALL
		SELECT givenname, familyname, email FROM employees
			ORDER BY familyname, givenname
		;

	--	This works:
		SELECT givenname, familyname, email FROM customers
		UNION ALL
		SELECT givenname, familyname, email FROM employees
		ORDER BY familyname, givenname;

	--	Better Layout:
		SELECT givenname, familyname, email FROM customers
		UNION ALL
		SELECT givenname, familyname, email FROM employees

		ORDER BY familyname, givenname;

	--	Fill in Empty Line:
		SELECT givenname, familyname, email FROM customers
		UNION ALL
		SELECT givenname, familyname, email FROM employees
		--	Sort Results:
		ORDER BY familyname, givenname;

/*	9.11: Intersect
	================================================ */

	SELECT givenname, familyname FROM customers
	INTERSECT
	SELECT givenname, familyname FROM employees;

/*	9.12: Popular Paintings
	================================================
	Oracle: Dont’t use AS
	================================================ */

	--	Paintings & States
		SELECT p.id, c.state,p.title
		FROM
			customers AS c
			JOIN sales AS s ON c.id=s.customerid
			JOIN saleitems AS si ON s.id=si.saleid
			JOIN paintings AS p ON si.paintingid=p.id ;

	--	Intersect for each state
		WITH cte AS (
			SELECT p.id, c.state, p.title
			FROM
				customers AS c
				JOIN sales AS s ON c.id=s.customerid
				JOIN saleitems AS si ON s.id=si.saleid
				JOIN paintings AS p ON si.paintingid=p.id
		)
		SELECT id, title FROM cte WHERE state='NSW'
		INTERSECT
		SELECT id, title FROM cte WHERE state='VIC'
		INTERSECT
		SELECT id, title FROM cte WHERE state='QLD'

		ORDER BY title;

/*	9.13: Difference
	================================================
	Oracle: MINUS
	================================================ */

	--	Employees not matching Customers:
		SELECT givenname, familyname FROM employees
		EXCEPT
		SELECT givenname, familyname FROM customers

		ORDER BY familyname, givenname;

	--	Customers not matching Employees:
		SELECT givenname, familyname FROM customers
		EXCEPT
		SELECT givenname, familyname FROM employees

		ORDER BY familyname, givenname;

/*	9.14: Customers without Sales
	================================================
	Oracle: MINUS
	================================================ */

	SELECT id FROM customers
	EXCEPT
	SELECT customerid FROM sales;

	--	Alternative with more detail:
		SELECT c.id, c.givenname, c.familyname	--	etc
		FROM customers AS c LEFT JOIN sales AS s ON s.customerid=c.id
		WHERE s.id IS NULL;

/*	9.15: Artists without Paintings
	================================================
	Oracle: MINUS
	================================================ */

	--	EXCEPT
		SELECT id FROM artists
		EXCEPT
		SELECT artistid FROM paintings;

	--	Using OUTER JOIN
		SELECT a.id, a.givenname, a.familyname	--	etc
		FROM paintings AS p RIGHT JOIN artists AS a ON p.artistid=a.id
		WHERE p.id IS NULL;

/*	9.16: Comparing Sales per Customer
	================================================
	Other DBMSs: givenname||' '||familyname
	Oracle: use MINUS
	================================================ */

	--	Sub Query
		SELECT
			customerid,
			(SELECT givenname+' '+familyname FROM customers WHERE customers.id = sales.customerid ) AS customer,
			count(*) AS number_of_sales,
			sum(total) AS total
		FROM sales
		GROUP BY customerid

		UNION
		--	INTERSECT
		--	EXCEPT

	--	Join
		SELECT
			c.id, c.givenname+' '+c.familyname AS customer,
			count(*) AS number_of_sales, sum(s.total) AS total
		FROM sales AS s JOIN customers AS c ON s.customerid=c.id
		GROUP BY c.id, c.givenname,c.familyname;
/*	9.18: Virtual Tables
	================================================
	--	PostgreSQL, MSSQL, MySQL / MariaDB
		SELECT 'one' AS test, cast('2020-01-29' as date) AS testdate
		UNION
		SELECT 'two', cast('2020-02-28' as date)
		UNION
		SELECT 'three', cast('2020-03-30' as date)
		;

	--	SQLite
		SELECT 'one' AS test, '2020-01-29' AS testdate
		UNION
		SELECT 'two', '2020-02-28'
		UNION
		SELECT 'three', '2020-03-30'
		;

	--	Oracle
		SELECT 'one' AS test,
			cast('29 Jan 2020' as date) AS testdate
		FROM dual
		UNION
		SELECT 'two', cast('28 Feb 2020' as date)
		FROM dual
		UNION
		SELECT 'three', cast('30 Mar 2020' as date)
		FROM dual
		;
	================================================ */

	SELECT 'one' AS test, cast('2020-01-29' as date) AS testdate
	UNION
	SELECT 'two', cast('2020-02-28' as date)
	UNION
	SELECT 'three', cast('2020-03-30' as date)
	;



/*	9.19: Using Virtual Table
	================================================
	--	PostgreSQL, MySQL / MariaDB, Oracle
		WITH samples AS (
			…
		)
		SELECT test, testdate, testdate+interval '30' day
		FROM samples;
	--	MSSQL
		WITH samples AS (
			…
		)
		SELECT test, testdate, dateadd(day,30,testdate)
		FROM samples;
	--	SQLite
		WITH samples AS (
			…
		)
		SELECT test, testdate,
			strftime('%Y-%m-%d',testdate,'+30 day')
		FROM samples;

	--	Table Literal: PostgreSQL, MySQL / MariaDB, SQLite
		WITH samples(test, testdate) AS (
			VALUES('one','2020-01-29'),('two','2020-02-28')
				('three', '2020-03-30')
		)
		SELECT …
		FROM samples;
	================================================ */

	WITH samples AS (
		SELECT 'one' AS test, cast('2020-01-29' as date) AS testdate
		UNION
		SELECT 'two', cast('2020-02-28' as date)
		UNION
		SELECT 'three', cast('2020-03-30' as date)
	)
	SELECT test, testdate, dateadd(day,30,testdate)
	FROM samples;

/*	9.20: Various Aggregates
	================================================ */

	--	Town Totals
		SELECT state, town, count(*) AS count
		FROM customers
		GROUP BY state, town
		ORDER BY state, town;

	--	State totals
		SELECT state, count(*) AS count
		FROM customers
		GROUP BY state
		ORDER BY state;

	--	Grand total
		SELECT count(*) AS count FROM customers;


/*	9.21: Combined Totals
	================================================ */

	--	Mixed In
		SELECT state, count(*) AS count
		FROM customers
		GROUP BY state
		UNION
		SELECT 'total', count(*)
		FROM customers;

	--	With Levels
		SELECT 0 AS statelevel, state, count(*) AS count
		FROM customers
		GROUP BY state
		UNION
		SELECT 1 AS statelevel, 'total', count(*)
		FROM customers

		ORDER BY statelevel, state;

/*	9.22: State & Grand Totals
	================================================ */

	SELECT
		0 AS statelevel, 0 as townlevel,
		state, town, count(*) AS count
	FROM customers GROUP BY state, town
	UNION
	SELECT
		0, 1,
		state, 'total', count(*) AS count
	FROM customers
	GROUP BY state
	UNION
	SELECT
		1, 1,
		'national', 'total', count(*)
	FROM customers
	--	Sort Results:
	ORDER BY statelevel, state, townlevel, town;

/*	9.23: Rollup
	================================================
	--	PostgreSQL, MSSQL, Oracle
		SELECT state, town, count(*) AS count
		FROM customers GROUP BY rollup(state, town)
		ORDER BY grouping(state),state, grouping(town), town;
	--	MSSQL, MySQL / MariaDB
		SELECT state, town, count(*) AS count
		FROM customers
		GROUP BY state, town WITH rollup;
	================================================ */

	--	Flexible Version
		SELECT state, town, count(*) AS count
		FROM customers GROUP BY rollup(state, town)
		ORDER BY grouping(state),state, grouping(town), town;
	--	Short Version
		SELECT state, town, count(*) AS count
		FROM customers
		GROUP BY state, town WITH rollup;