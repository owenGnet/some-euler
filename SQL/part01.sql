-- problems 1 to 10

--Problem 1		Multiples of 3 and 5
--If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
--Find the sum of all the multiples of 3 or 5 below 1000.
SELECT SUM(number)
FROM numbers
WHERE number < 1000 AND (number % 3 = 0 OR number % 5 = 0)



--Problem 2		Even Fibonacci numbers
--Each new term in the Fibonacci sequence is generated by adding the previous two terms.
-- By starting with 1 and 2, the first 10 terms will be:
--1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
--By considering the terms in the Fibonacci sequence whose values do not exceed four million, find the sum of the even-valued terms.
;WITH cteFib AS (
    SELECT
        1 AS num1,
        2 AS num2--, 1 as Level
    UNION ALL
    SELECT
        f1.num1 + f1.num2 AS num1,
        f1.num1 + f1.num2 + f1.num2 AS num2--, Level + 1 as Level
    FROM ctefib AS f1
    WHERE f1.num2 < 4000000
)
--select * from cteFib
SELECT SUM(A.num)
FROM (
    SELECT num1 AS num
    FROM cteFib
    WHERE num1 % 2 = 0
    UNION ALL
    SELECT num2
    FROM cteFib
    WHERE num2 % 2 = 0 AND num2 < 4000000
) AS A



--Problem 3		Largest prime factor
--The prime factors of 13195 are 5, 7, 13 and 29.
--What is the largest prime factor of the number 600851475143 ?
DECLARE @LargePrime NUMERIC(26,0) = 600851475143;
;WITH cteLargePrime AS (
    SELECT p.prime
    FROM primes AS p
        CROSS APPLY (SELECT @LargePrime % p.prime AS modu) AS div
    WHERE p.prime < 999999 AND modu = 0
)
SELECT MAX(prime) FROM cteLargePrime



--Problem 4		Largest palindrome product
--A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99.
--Find the largest palindrome made from the product of two 3-digit numbers.
;WITH cteProds AS (
    SELECT CAST(A.prod AS VARCHAR(6)) AS prod
    FROM (
        SELECT TOP 10000 prods.prod	--just assuming it will be in the top ten thousand
        FROM numbers AS n1
            CROSS APPLY (SELECT n1.number * n2.number AS prod
                         FROM Numbers n2 
                         WHERE number BETWEEN 100 AND 999) AS prods
        WHERE n1.number BETWEEN 100 AND 999
        ORDER BY prods.prod DESC
    ) AS A
)
SELECT TOP 1 prod
FROM cteProds
WHERE LEFT(prod, 3) = REVERSE(RIGHT(prod, 3)) -- top 10,000 products are all six characters long
ORDER BY prod DESC



--Problem 5		Smallest multiple
--2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.
--What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?
--OCG NOTE: this solution is good as long as the answer is < 1,000,000,000, which it is
--	(& there are 3 or 4 other, higher, numbers under 1 billion that are divis by 1-20)
CREATE TABLE #tmp
(
    id INT IDENTITY(2520, 2520) PRIMARY KEY,
    num INT
);
INSERT INTO #tmp
    SELECT number FROM numbers
    WHERE number < 400000

SELECT MIN(id) AS answer 
FROM #tmp
WHERE id % 20 = 0 AND id % 19 = 0 AND id % 18 = 0 AND id % 17 = 0
    AND id % 16 = 0 AND id % 15 = 0 AND id % 14 = 0
    AND id % 13 = 0 AND id % 12 = 0 AND id % 11 = 0

DROP TABLE #tmp



--Problem 6		Sum square difference
--The sum of the squares of the first ten natural numbers is,
--	1^2 + 2^2 + ... + 10^2 = 100 385
--The square of the sum of the first ten natural numbers is,
--	(1 + 2 + ... + 10)^2 = 55^2 = 3,025 3025
--Hence the difference between the sum of the squares of the first ten natural numbers and the square of the sum is 3025 - 385 = 2640.
--Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.
SELECT SQUARE(SUM(n.Number)) - SUM(SQUARE(n.number)) AS answer
FROM numbers AS n
WHERE n.number <= 100



--Problem 7		10001st prime
--By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.
--What is the 10,001st prime number?
SELECT A.prime
FROM (
    SELECT prime, ROW_NUMBER() OVER (ORDER BY prime) AS rwcnt
    FROM primes
) AS A
WHERE rwcnt = 10001



--Problem 8		Largest product in a series
--The four adjacent digits in the 1000-digit number that have the greatest product are 9 × 9 × 8 × 9 = 5832.
--		73167176531330624919225119674426574742355349194934
--		969835203127745063262395783180169848018694788.....
--		..
--Find the thirteen adjacent digits in the 1000-digit number that have the greatest product. What is the value of this product?
-- ** each line has 50 char

DECLARE @BigNum varchar(1000) = '73167176531330624919225119674426574742355349194934' +
 '96983520312774506326239578318016984801869478851843' +
 '85861560789112949495459501737958331952853208805511' +
 '12540698747158523863050715693290963295227443043557' +
 '66896648950445244523161731856403098711121722383113' +
 '62229893423380308135336276614282806444486645238749' +
 '30358907296290491560440772390713810515859307960866' +
 '70172427121883998797908792274921901699720888093776' +
 '65727333001053367881220235421809751254540594752243' +
 '52584907711670556013604839586446706324415722155397' +
 '53697817977846174064955149290862569321978468622482' +
 '83972241375657056057490261407972968652414535100474' +
 '82166370484403199890008895243450658541227588666881' +
 '16427171479924442928230863465674813919123162824586' +
 '17866458359124566529476545682848912883142607690042' +
 '24219022671055626321111109370544217506941658960408' +
 '07198403850962455444362981230987879927244284909188' +
 '84580156166097919133875499200524063689912560717606' +
 '05886116467109405077541002256983155200055935729725' +
 '71636269561882670428252483600823257530420752963450'

 --;
 WITH cteSubs AS (
    SELECT sub.part, n.Number AS PartNo
    FROM Numbers AS n
    --	CROSS JOIN Numbers n
        CROSS APPLY (SELECT SUBSTRING(@BigNum, n.Number, 13) AS part) AS sub
    WHERE n.Number <= LEN(@BigNum) AND CHARINDEX('0', sub.part) = 0
)
--SELECT * FROM cteSubs
,cteDigits AS (
    SELECT part, digits.digit, n.Number AS nthDigit
    FROM cteSubs
    CROSS JOIN Numbers n
        CROSS APPLY (SELECT CAST(SUBSTRING(part, n.Number, 1) AS BIGINT) AS digit) AS digits
    WHERE n.Number < 14
    --	AND part = '1112172238311'
)
--SELECT * FROM cteDigits order by part, nthDigit
,cteRec AS
(
    SELECT d.part, CAST(1 as BIGINT) as prevDigit, digit as currDigit, 1 AS lvl
    FROM cteDigits d
    WHERE nthDigit = 1
    UNION ALL
    SELECT r.part, r.currDigit as prevDigit, d.digit * currDigit, lvl + 1 AS lvl
    FROM cteRec r
    INNER JOIN cteDigits d ON d.part = r.part
    WHERE nthDigit = lvl + 1 AND nthDigit < 14
)
--SELECT * FROM cteRec ORDER BY currDigit DESC
SELECT MAX(currDigit) AS answer
FROM cteRec


--Problem 9		Special Pythagorean triplet
--A Pythagorean triplet is a set of three natural numbers, a < b < c, for which,
--	a^2 + b^2 = c^2
--	For example, 3^2 + 4^2 = 9 + 16 = 25 = 5^2.
--There exists exactly one Pythagorean triplet for which a + b + c = 1000.
--Find the product abc.
-- * 500 would be max c^2 ie c <= 22 (22^2 = 529)
SELECT A.a, A.b, A.c, A.a * A.b * A.c AS answer
FROM (
    SELECT n1.number AS a, n2.number AS b, n3.number AS c
    FROM numbers AS n1
    CROSS JOIN numbers AS n2
    CROSS JOIN numbers AS n3
    WHERE n1.Number BETWEEN 100 AND 400 AND n1.number <= n2.number
        AND n2.number BETWEEN 100 AND 400
        AND n3.number BETWEEN 100 AND 500 AND n3.number > n1.number AND n3.number > n2.number
        AND n1.number + n2.number + n3.number = 1000
) AS A
WHERE SQUARE(A.a) + SQUARE(A.b) = SQUARE(A.c)



--Problem 10		Summation of primes
--The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.
--Find the sum of all the primes below two million.
SELECT SUM(CAST(prime AS BIGINT)) AS answer
FROM primes
WHERE prime < 2000000


