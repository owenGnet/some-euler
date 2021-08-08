-- problems 21 to 24, 51 & 53

--Problem 21		Amicable numbers
--Let d(n) be defined as the sum of proper divisors of n (numbers less than n which divide evenly into n).
-- If d(a) = b and d(b) = a, where a != b, then a and b are an amicable pair and each of a and b are called amicable numbers.
--For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20, 22, 44, 55 and 110; therefore d(220) = 284.
--The proper divisors of 284 are 1, 2, 4, 71 and 142; so d(284) = 220.
--Evaluate the sum of all the amicable numbers under 10000.
;WITH cte1 AS (
    SELECT Number, SQRT(Number) + 1 AS NumTo
    FROM Numbers
    WHERE Number <= 10000
)
,cte2 AS (
    SELECT N1.Number, SUM(N2.Number + N1.Number / N2.Number) + 1 AS DivSum
    FROM cte1 AS N1
    CROSS JOIN cte1 AS N2
    WHERE N1.Number BETWEEN 1 AND 10000
        AND N2.Number BETWEEN 2 AND N1.numTo AND N1.Number % N2.Number = 0
    GROUP BY N1.Number
)
SELECT SUM(c1.Number) AS Answer21
FROM cte1 AS c1
INNER JOIN cte2 AS c2 ON c2.DivSum = c1.Number
WHERE c1.Number != c2.Number AND c2.Number = (SELECT DivSum FROM cte2 WHERE Number = c1.Number)



--Problem 22		Names scores
--Using names.txt (right click and 'Save Link/Target As...'), a 46K text file containing over five-thousand first names, begin by
--sorting it into alphabetical order. Then working out the alphabetical value for each name, multiply this value by its alphabetical
--position in the list to obtain a name score.
--For example, when the list is sorted into alphabetical order, COLIN, which is worth 3 + 15 + 12 + 9 + 14 = 53,
--is the 938th name in the list.
--So, COLIN would obtain a score of 938 × 53 = 49714.
--What is the total of all the name scores in the file?
DECLARE @Alphabet CHAR(26) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
DECLARE @Names VARCHAR(MAX)
SELECT @Names = REPLACE(BulkColumn, '"','')
FROM OPENROWSET(BULK 'C:\temp\p022_names.txt', SINGLE_BLOB) AS N
--There are other, presumably more performant, T-SQL split algorithms out there but everthing completes in
--	a couple of seconds so I did't bother investigating (and that way I only needed to look up the OPENROWSET syntax)
;WITH cte1 AS (
    SELECT SUBSTRING(@Names, 0, CHARINDEX(',',@Names)) AS Name, RIGHT(@Names, LEN(@Names) - CHARINDEX(',',@Names)) AS Names,
        CAST(1 AS BIGINT) AS chrIndex
    UNION ALL
    SELECT CASE WHEN CHARINDEX(',', Names) > 1
            THEN SUBSTRING(Names, 0, CHARINDEX(',', Names))
            ELSE Names END AS Name,
        RIGHT(Names, LEN(Names) - CHARINDEX(',', Names)) AS Names, CHARINDEX(',', Names) AS chrIndex
    FROM cte1
    WHERE chrIndex >= 1
)
,cte2 AS (
    SELECT A.Name, SUM(A.Val) AS Total
    FROM (
        SELECT Name, SUBSTRING(Name, Number, 1) AS Letter, CHARINDEX(SUBSTRING(Name, Number, 1), @Alphabet) AS Val
        FROM cte1
            CROSS APPLY (SELECT Number FROM Numbers WHERE Number < LEN(Name) + 1) AS N
    ) AS A
    GROUP BY A.Name
)
SELECT SUM(A.Total * A.alphaOrder)
FROM (
    SELECT Name, Total, ROW_NUMBER() OVER(ORDER BY Name) AS alphaOrder
    FROM cte2
) AS A
OPTION (MAXRECURSION 0)


--Problem 23		Non-abundant Sums
--A perfect number is a number for which the sum of its proper divisors is exactly equal to the number.
--For example, the sum of the proper divisors of 28 would be 1 + 2 + 4 + 7 + 14 = 28, which means that 28 is a perfect number.
--A number n is called deficient if the sum of its proper divisors is less than n and it is called abundant if this sum exceeds n.
--As 12 is the smallest abundant number, 1 + 2 + 3 + 4 + 6 = 16, the smallest number that can be written as the sum of two abundant
-- numbers is 24.
--By mathematical analysis, it can be shown that all integers greater than 28123 can be written as the sum of two abundant numbers.
--However, this upper limit cannot be reduced any further by analysis even though it is known that the greatest number that cannot be
--expressed as the sum of two abundant numbers is less than this limit.
--Find the sum of all the positive integers which cannot be written as the sum of two abundant numbers.

--#only looking at <= 28123, cause euler doesn't care about anything greater
--#wolfram/wiki: Every number greater than 20161 can be expressed as a sum of two abundant numbers.
--#euler: all integers greater than 28123 can be written as the sum of two abundant numbers.
--2015.04.14, looking at 11 seconds on a fresh query, prototyped w/CTE but temp table made a big difference

IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp;
GO
DECLARE @StopValue INT = 28123;
CREATE Table #temp(Number INT NOT NULL, NumTo INT, SumOfDivisors INT, PRIMARY KEY (Number));
INSERT INTO #temp
    SELECT Number, CASE WHEN Number % 2 = 0 THEN Number/2
                        WHEN Number % 5 = 0 THEN Number/5
                        ELSE SQRT(Number) + 1 END AS NumTo,
            NULL AS SumOfDivisors
            --would an OddEven column here help in having odd numbers skip division-by-even attempts?
    FROM Numbers
    WHERE Number BETWEEN 2 AND @StopValue;

;WITH cteDivSums AS (
    SELECT N1.Number, SUM(N1.Number / N2.Number) + 1 AS DivSum
    FROM #temp AS N1
    CROSS JOIN #temp N2
    WHERE N1.Number % N2.Number = 0 AND N2.Number <= N1.NumTo
    GROUP BY N1.Number
    HAVING SUM(N1.Number / N2.Number) + 1 > N1.Number
)
--SELECT * FROM cteDivSums
UPDATE T
SET T.SumOfDivisors = c2.DivSum
FROM #temp AS T
INNER JOIN cteDivSums c2 ON c2.Number = T.Number;

DELETE FROM #temp WHERE SumOfDivisors IS NULL;

SELECT SUM(Number) AS Problem23_Answer
FROM Numbers
WHERE Number < @StopValue AND Number NOT IN (
    SELECT c.Number + cc.Number AS IsAbundantSum
    FROM #temp AS c
    INNER JOIN #temp cc ON cc.Number <= c.Number
    WHERE c.Number + cc.Number < @StopValue
);

DROP TABLE #temp;



--Problem 24	Lexicographic permutations
--A permutation is an ordered arrangement of objects. For example, 3124 is one possible permutation of the digits 1, 2, 3 and 4.
--If all of the permutations are listed numerically or alphabetically, we call it lexicographic order.
--The lexicographic permutations of 0, 1 and 2 are:
--	012   021   102   120   201   210
--What is the millionth lexicographic permutation of the digits 0, 1, 2, 3, 4, 5, 6, 7, 8 and 9?
--NOTE: 10! = 3628800
;WITH cteOne AS (
    SELECT CONCAT(aN, bN, cN, dN, eN, fN, gN, hN, [iN], jN) AS fullNum
        --RowNum solution taking a few seconds longer
        --,ROW_NUMBER() OVER (ORDER BY aN, bN, cN, dN, eN, fN, gN, hN, [iN], jN) AS RowNum
    FROM
    (
        SELECT a.N AS aN, b.n AS bN, c.n AS cN, d.n AS dN, e.n AS eN, f.n AS fN, g.n AS gN, h.n AS hN, i.n AS [iN], j.n AS jN
        --try belwo with 0,1,2, AS only nums for a(n) ??
        FROM (VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) a(n)
            CROSS JOIN (VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) b(n)
            CROSS JOIN (VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) c(n)
            CROSS JOIN (VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) d(n)
            CROSS JOIN (VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) e(n)
            CROSS JOIN (VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) f(n)
            CROSS JOIN (VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) g(n)
            CROSS JOIN (VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) h(n)
            CROSS JOIN (VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) i(n)
            CROSS JOIN (VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) j(n)
        WHERE a.n < 3 --started off w/10 but if 10!/3,628,800 combos, safe to assume the answer will begin with 0/1/2
    ) AS A
    WHERE aN NOT IN (bN, cN, dN, eN, fN, gN, hN, [iN], jN)
        AND bN NOT IN (aN, cN, dN, eN, fN, gN, hN, [iN], jN)
        AND cN NOT IN (aN, bN, dN, eN, fN, gN, hN, [iN], jN)
        AND dN NOT IN (aN, cN, bN, eN, fN, gN, hN, [iN], jN)
        AND eN NOT IN (aN, cN, dN, bN, fN, gN, hN, [iN], jN)
        AND fN NOT IN (aN, cN, dN, eN, bN, gN, hN, [iN], jN)
        AND gN NOT IN (aN, cN, dN, eN, fN, bN, hN, [iN], jN)
        AND hN NOT IN (aN, cN, dN, eN, fN, gN, bN, [iN], jN)
        AND [iN] NOT IN (aN, cN, dN, eN, fN, gN, hN, [bN], jN)
        AND jN NOT IN (aN, cN, dN, eN, fN, gN, hN, [iN], bN)
)
SELECT fullNum
FROM cteOne
ORDER BY fullNum
OFFSET 999999 ROWS FETCH NEXT 1 ROWS ONLY


--Problem 51		Prime digit replacements
--By replacing the 1st digit of the 2-digit number *3, it turns out that six of the nine possible values:
--	13, 23, 43, 53, 73, and 83, are all prime.
--By replacing the 3rd and 4th digits of 56**3 with the same digit, this 5-digit number is the first example HAVING seven primes
--	among the ten generated numbers, yielding the family: 56003, 56113, 56333, 56443, 56663, 56773, and 56993.
--	Consequently 56003, being the first member of this family, is the smallest prime with this property.
-- Find the smallest prime which, by replacing part of the number (not necessarily adjacent digits) with the same digit,
--	is part of an eight prime value family.
;WITH ctePrimes AS (
    SELECT A.prime AS primeNumber, A.primeLength, A.primeString
    FROM (
        SELECT prime, LEN(prime) AS primeLength, CAST(prime AS varchar) AS primeString
        FROM primes	-- prime number table, mine was only populated w/primes < 3,000,000
        WHERE prime > 1000) AS A
)
,cteDupeyPrimes AS ( --return all primes w/at least one repeated digit, onerow for each repeated digit
    SELECT p.primeNumber, p.primeString, p.primeLength, d.digit
    FROM ctePrimes AS p
    CROSS APPLY (SELECT SUBSTRING(p.primeString, p.primeLength, 1) AS digit
        UNION ALL SELECT SUBSTRING(p.primeString, p.primeLength - 1, 1)
        UNION ALL SELECT SUBSTRING(p.primeString, p.primeLength - 2, 1)
        UNION ALL SELECT SUBSTRING(p.primeString, p.primeLength - 3, 1)
        UNION ALL SELECT SUBSTRING(p.primeString, p.primeLength - 4, 1)
        UNION ALL SELECT SUBSTRING(p.primeString, p.primeLength - 5, 1)
        UNION ALL SELECT SUBSTRING(p.primeString, p.primeLength - 6, 1)
        ) d
    WHERE d.digit != ''
    GROUP BY p.primeNumber, p.primeString, p.primeLength, d.digit
    HAVING COUNT(d.digit) > 1
)
,cteDigits AS (  -- digits 0-9
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS replaceDigit
    FROM (VALUES(0), (0), (0), (0), (0), (0), (0), (0), (0), (0)) AS digits(d)
)
,cteCheck AS ( -- all families with 8 prime value members (where of course all are < 3,000,000 due to initial primes table)
    SELECT A.primeNumber, A.cand, ROW_NUMBER() OVER (ORDER BY A.primeNumber) AS rowNum
    FROM (	
        SELECT dp.primeNumber, dp.primeString, dp.digit, d.replaceDigit, REPLACE(dp.primeString, dp.digit,
            CAST(d.replaceDigit AS char(1))) AS cand,
            COUNT(dp.primeNumber) OVER (PARTITION BY dp.primeNumber, dp.digit) AS familyCount
        FROM cteDupeyPrimes AS dp
        CROSS JOIN cteDigits AS d
        WHERE EXISTS (
                    SELECT p.primeNumber
                    FROM ctePrimes AS p
                    WHERE p.primeLength = dp.primeLength
                    AND p.primeNumber = CAST(REPLACE(dp.primeString, dp.digit, CAST(d.replaceDigit AS char(1))) AS INT))
    ) AS A
    WHERE familyCount = 8
)
SELECT CASE WHEN rowNum = 1 THEN 'ANSWER: ' ELSE 'Family member: ' END AS textKey, cand
FROM cteCheck
WHERE rowNum <= 8


--Problem 53		Combinatoric selections
--There are exactly ten ways of selecting three from five, 12345:
--    123, 124, 125, 134, 135, 145, 234, 235, 245, and 345
--In combinatorics, we use the notation, 5-C-3 = 10
-- as a theorum: n-C-r = n! / r!(n-r)!  where r <= n		... n!/r! * n!/(n-r)! ?
--It is not until n = 23, that a value exceeds one-million: 23-C-10= 1144066.
--How many, not necessarily distinct, values of  n-C-r, for 1 <= n <= 100, are greater than one-million?
;WITH cteFact AS (
    SELECT CAST(1 AS float) AS fact, 1 AS Level
    UNION ALL
    SELECT fact * CAST(Level + 1 AS float) AS fact, Level + 1 AS Level
    FROM cteFact AS f
    WHERE f.Level < 100
)
,cteCalc AS (
    SELECT n.Level AS N_number, r.Level AS R_number, n.fact / (r.fact * d.nMinusRfact) AS val
    FROM cteFact AS n
    CROSS JOIN cteFact AS r
        OUTER APPLY (SELECT c.fact AS nMinusRfact FROM cteFact c WHERE c.Level = (n.Level - r.Level)) AS d
    WHERE r.Level <= n.Level
)
SELECT COUNT(*) AS Answer
FROM cteCalc
WHERE val > 1000000
