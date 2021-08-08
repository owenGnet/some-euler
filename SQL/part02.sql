-- problems 10 to 20

--Problem 11		Largest product in a grid
--In the 20×20 grid below, four numbers along a diagonal line have been marked in red.
--The product of these numbers is 26 × 63 × 78 × 14 = 1788696.
--What is the greatest product of four adjacent numbers in the same direction (up, down, left, right, or diagonally) in the 20×20 grid?
--OCG Note, below also contains two earlier, more verbose CTE versions, which are also much more readable

--final, compact cte
DECLARE @Matrix TABLE(ColNum INT, RowNum INT, Val BIGINT)
INSERT INTO @Matrix(ColNum,RowNum,Val)
VALUES
(1,1,8),	(2,1,2),	(3,1,22),	(4,1,97),	(5,1,38),	(6,1,15),	(7,1,0),	(8,1,40),	(9,1,0),	(10,1,75),	(11,1,4),	(12,1,5),	(13,1,7),	(14,1,78),	(15,1,52),	(16,1,12),	(17,1,50),	(18,1,77),	(19,1,91),	(20,1,8),
(1,2,49),	(2,2,49),	(3,2,99),	(4,2,40),	(5,2,17),	(6,2,81),	(7,2,18),	(8,2,57),	(9,2,60),	(10,2,87),	(11,2,17),	(12,2,40),	(13,2,98),	(14,2,43),	(15,2,69),	(16,2,48),	(17,2,4),	(18,2,56),	(19,2,62),	(20,2,0),
(1,3,81),	(2,3,49),	(3,3,31),	(4,3,73),	(5,3,55),	(6,3,79),	(7,3,14),	(8,3,29),	(9,3,93),	(10,3,71),	(11,3,40),	(12,3,67),	(13,3,53),	(14,3,88),	(15,3,30),	(16,3,3),	(17,3,49),	(18,3,13),	(19,3,36),	(20,3,65),
(1,4,52),	(2,4,70),	(3,4,95),	(4,4,23),	(5,4,4),	(6,4,60),	(7,4,11),	(8,4,42),	(9,4,69),	(10,4,24),	(11,4,68),	(12,4,56),	(13,4,1),	(14,4,32),	(15,4,56),	(16,4,71),	(17,4,37),	(18,4,2),	(19,4,36),	(20,4,91),
(1,5,22),	(2,5,31),	(3,5,16),	(4,5,71),	(5,5,51),	(6,5,67),	(7,5,63),	(8,5,89),	(9,5,41),	(10,5,92),	(11,5,36),	(12,5,54),	(13,5,22),	(14,5,40),	(15,5,40),	(16,5,28),	(17,5,66),	(18,5,33),	(19,5,13),	(20,5,80),
(1,6,24),	(2,6,47),	(3,6,32),	(4,6,60),	(5,6,99),	(6,6,3),	(7,6,45),	(8,6,2),	(9,6,44),	(10,6,75),	(11,6,33),	(12,6,53),	(13,6,78),	(14,6,36),	(15,6,84),	(16,6,20),	(17,6,35),	(18,6,17),	(19,6,12),	(20,6,50),
(1,7,32),	(2,7,98),	(3,7,81),	(4,7,28),	(5,7,64),	(6,7,23),	(7,7,67),	(8,7,10),	(9,7,26),	(10,7,38),	(11,7,40),	(12,7,67),	(13,7,59),	(14,7,54),	(15,7,70),	(16,7,66),	(17,7,18),	(18,7,38),	(19,7,64),	(20,7,70),
(1,8,67),	(2,8,26),	(3,8,20),	(4,8,68),	(5,8,2),	(6,8,62),	(7,8,12),	(8,8,20),	(9,8,95),	(10,8,63),	(11,8,94),	(12,8,39),	(13,8,63),	(14,8,8),	(15,8,40),	(16,8,91),	(17,8,66),	(18,8,49),	(19,8,94),	(20,8,21),
(1,9,24),	(2,9,55),	(3,9,58),	(4,9,5),	(5,9,66),	(6,9,73),	(7,9,99),	(8,9,26),	(9,9,97),	(10,9,17),	(11,9,78),	(12,9,78),	(13,9,96),	(14,9,83),	(15,9,14),	(16,9,88),	(17,9,34),	(18,9,89),	(19,9,63),	(20,9,72),
(1,10,21),	(2,10,36),	(3,10,23),	(4,10,9),	(5,10,75),	(6,10,0),	(7,10,76),	(8,10,44),	(9,10,20),	(10,10,45),	(11,10,35),	(12,10,14),	(13,10,0),	(14,10,61),	(15,10,33),	(16,10,97),	(17,10,34),	(18,10,31),	(19,10,33),	(20,10,95),
(1,11,78),	(2,11,17),	(3,11,53),	(4,11,28),	(5,11,22),	(6,11,75),	(7,11,31),	(8,11,67),	(9,11,15),	(10,11,94),	(11,11,3),	(12,11,80),	(13,11,4),	(14,11,62),	(15,11,16),	(16,11,14),	(17,11,9),	(18,11,53),	(19,11,56),	(20,11,92),
(1,12,16),	(2,12,39),	(3,12,5),	(4,12,42),	(5,12,96),	(6,12,35),	(7,12,31),	(8,12,47),	(9,12,55),	(10,12,58),	(11,12,88),	(12,12,24),	(13,12,0),	(14,12,17),	(15,12,54),	(16,12,24),	(17,12,36),	(18,12,29),	(19,12,85),	(20,12,57),
(1,13,86),	(2,13,56),	(3,13,0),	(4,13,48),	(5,13,35),	(6,13,71),	(7,13,89),	(8,13,7),	(9,13,5),	(10,13,44),	(11,13,44),	(12,13,37),	(13,13,44),	(14,13,60),	(15,13,21),	(16,13,58),	(17,13,51),	(18,13,54),	(19,13,17),	(20,13,58),
(1,14,19),	(2,14,80),	(3,14,81),	(4,14,68),	(5,14,5),	(6,14,94),	(7,14,47),	(8,14,69),	(9,14,28),	(10,14,73),	(11,14,92),	(12,14,13),	(13,14,86),	(14,14,52),	(15,14,17),	(16,14,77),	(17,14,4),	(18,14,89),	(19,14,55),	(20,14,40),
(1,15,4),	(2,15,52),	(3,15,8),	(4,15,83),	(5,15,97),	(6,15,35),	(7,15,99),	(8,15,16),	(9,15,7),	(10,15,97),	(11,15,57),	(12,15,32),	(13,15,16),	(14,15,26),	(15,15,26),	(16,15,79),	(17,15,33),	(18,15,27),	(19,15,98),	(20,15,66),
(1,16,88),	(2,16,36),	(3,16,68),	(4,16,87),	(5,16,57),	(6,16,62),	(7,16,20),	(8,16,72),	(9,16,3),	(10,16,46),	(11,16,33),	(12,16,67),	(13,16,46),	(14,16,55),	(15,16,12),	(16,16,32),	(17,16,63),	(18,16,93),	(19,16,53),	(20,16,69),
(1,17,4),	(2,17,42),	(3,17,16),	(4,17,73),	(5,17,38),	(6,17,25),	(7,17,39),	(8,17,11),	(9,17,24),	(10,17,94),	(11,17,72),	(12,17,18),	(13,17,8),	(14,17,46),	(15,17,29),	(16,17,32),	(17,17,40),	(18,17,62),	(19,17,76),	(20,17,36),
(1,18,20),	(2,18,69),	(3,18,36),	(4,18,41),	(5,18,72),	(6,18,30),	(7,18,23),	(8,18,88),	(9,18,34),	(10,18,62),	(11,18,99),	(12,18,69),	(13,18,82),	(14,18,67),	(15,18,59),	(16,18,85),	(17,18,74),	(18,18,4),	(19,18,36),	(20,18,16),
(1,19,20),	(2,19,73),	(3,19,35),	(4,19,29),	(5,19,78),	(6,19,31),	(7,19,90),	(8,19,1),	(9,19,74),	(10,19,31),	(11,19,49),	(12,19,71),	(13,19,48),	(14,19,86),	(15,19,81),	(16,19,16),	(17,19,23),	(18,19,57),	(19,19,5),	(20,19,54),
(1,20,1),	(2,20,70),	(3,20,54),	(4,20,71),	(5,20,83),	(6,20,51),	(7,20,54),	(8,20,69),	(9,20,16),	(10,20,92),	(11,20,33),	(12,20,48),	(13,20,61),	(14,20,43),	(15,20,52),	(16,20,1),	(17,20,89),	(18,20,19),	(19,20,67),	(20,20,48)
--get the answer, including returning the highest product in each direction
;WITH cteAll AS (
    SELECT A.Src, A.TotalProd, RANK() OVER (PARTITION BY A.Src ORDER BY A.TotalProd DESC) AS SrcRank
    FROM (
        SELECT CHOOSE(prodtype, 'LowerDiagProds', 'UpperDiagProds', 'colProds', 'rowProds') AS Src,
            val *
            (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + CHOOSE(prodtype, 1, -1, 1, 0) AND colNum = colIndex.Number
                + CHOOSE(prodtype, 1, 1, 0, 1))
            * (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + CHOOSE(prodtype, 2, -2, 2, 0) AND colNum = colIndex.Number
                + CHOOSE(prodtype, 2, 2, 0, 2))
            * (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + CHOOSE(prodtype, 3, -3, 3, 0) AND colNum = colIndex.Number
                + CHOOSE(prodtype, 3, 3, 0, 3)) AS TotalProd
        FROM @Matrix
            CROSS APPLY (SELECT Number FROM Numbers WHERE number between 1 and 20) AS colIndex
            CROSS APPLY (SELECT Number FROM Numbers WHERE number between 1 and 20) AS rowIndex
            --order of:  'LowerDiagProds', 'UpperDiagProds', 'colProds', 'rowProds'
            CROSS JOIN (VALUES (1), (2), (3), (4)) prods(prodtype)
        WHERE rowNum = rowIndex.Number AND colNum = colIndex.Number
    ) AS A
)
SELECT Src, TotalProd, MAX(TotalProd) OVER () AS answer
FROM cteAll
WHERE SrcRank = 1
ORDER BY TotalProd DESC

--#pass #2
;WITH cteAll AS (
    SELECT MAX(A.LowerDiagProds) AS LowerLeftDiagMax, MAX(A.UpperDiagProds) AS UpperLeftDiagMax,
        MAX(A.colProds) AS colMax, MAX(A.rowProds) AS rowMax
    FROM (
        SELECT val *
            (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + 1 AND colNum = colIndex.Number + 1) *
            (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + 2 AND colNum = colIndex.Number + 2) *
            (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + 3 AND colNum = colIndex.Number + 3) AS LowerDiagProds,
        val *
            (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number - 1 AND colNum = colIndex.Number + 1) *
            (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number - 2 AND colNum = colIndex.Number + 2) *
            (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number - 3 AND colNum = colIndex.Number + 3) AS UpperDiagProds,
        val *
            (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + 1 AND colNum = colIndex.Number) *
            (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + 2 AND colNum = colIndex.Number) *
            (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + 3 AND colNum = colIndex.Number) AS colProds,
        val *
            (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number AND colNum = colIndex.Number + 1) *
            (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number AND colNum = colIndex.Number + 2) *
            (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number AND colNum = colIndex.Number + 3) AS rowProds
        FROM @Matrix
            CROSS APPLY (SELECT Number from Numbers WHERE number BETWEEN 1 AND 20) colIndex
            CROSS APPLY (SELECT Number from Numbers WHERE number BETWEEN 1 AND 20) rowIndex
        WHERE rowNum = rowIndex.Number AND colNum = colIndex.Number
    ) AS A
)
SELECT *
FROM cteAll

--#Pass #1
WITH cteDiag1 AS (
    SELECT MAX(A.val1 * A.val2 * A.val3 * A.val4) AS maxVal
    FROM (
        SELECT val AS val1,
        (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + 1 AND colNum = colIndex.Number + 1) AS Val2,
        (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + 2 AND colNum = colIndex.Number + 2) AS Val3,
        (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + 3 AND colNum = colIndex.Number + 3) AS Val4,
        rowIndex.Number AS RowN, colIndex.Number AS ColN
        FROM @Matrix
            CROSS APPLY (SELECT number FROM Numbers WHERE number BETWEEN 1 AND 20) colIndex
            CROSS APPLY (SELECT TOP (20) number FROM Numbers WHERE number BETWEEN 1 AND 20 ORDER BY number DESC) rowIndex
        WHERE rowNum = rowIndex.Number AND colNum = colIndex.Number
    ) AS A
)
,cteDiag2 AS (
    SELECT MAX(A.val1 * A.val2 * A.val3 * A.val4) AS maxVal
    FROM (
        SELECT val AS val1,
        (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + 2 AND colNum = colIndex.Number + 1) AS Val2,
        (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + 1 AND colNum = colIndex.Number + 2) AS Val3,
        (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number AND colNum = colIndex.Number + 3) AS Val4
        FROM @Matrix
            CROSS APPLY (SELECT Number FROM Numbers WHERE number BETWEEN 1 AND 20) colIndex
            CROSS APPLY (SELECT Number FROM Numbers WHERE number BETWEEN 1 AND 20) rowIndex
        WHERE rowNum = rowIndex.Number + 3 AND colNum = colIndex.Number
    ) AS A
)
SELECT * FROM cteDiag2
,cteCol AS (
    SELECT MAX(colProds) AS maxVal
    FROM (
        SELECT val *
        (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + 1 AND colNum = colIndex.Number) *
        (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + 2 AND colNum = colIndex.Number) *
        (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number + 3 AND colNum = colIndex.Number) AS colProds
        FROM @Matrix
            CROSS APPLY (SELECT Number FROM Numbers WHERE number BETWEEN 1 AND 20) colIndex
            CROSS APPLY (SELECT Number FROM Numbers WHERE number BETWEEN 1 AND 20) rowIndex
        WHERE rowNum = rowIndex.Number AND colNum = colIndex.Number
    ) A
)
,cteRow AS (
SELECT MAX(rowProds) AS maxVal
    FROM (
        SELECT val *
        (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number AND colNum = colIndex.Number + 1) *
        (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number AND colNum = colIndex.Number + 2) *
        (SELECT val FROM @Matrix WHERE rowNum = rowIndex.Number AND colNum = colIndex.Number + 3) AS rowProds
        FROM @Matrix
            CROSS APPLY (SELECT Number FROM Numbers WHERE number BETWEEN 1 AND 20) colIndex
            CROSS APPLY (SELECT Number FROM Numbers WHERE number BETWEEN 1 AND 20) rowIndex
        WHERE rowNum = rowIndex.Number AND colNum = colIndex.Number
    ) A
)
,cteAgg AS(
    SELECT maxVal FROM cteDiag1
    UNION ALL
    SELECT maxVal FROM cteDiag2
    UNION ALL
    SELECT maxVal FROM cteCol
    UNION ALL
    SELECT maxVal FROM cteRow
)
SELECT MAX(maxVal) AS P11answer FROM cteAgg

--# a PIVOT on the grid, which didn't really help anything but looked pretty
SELECT [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [19], [20]
FROM (
    SELECT Val, ColNum, RowNum
    FROM @Matrix
) AS m
PIVOT (
    MAX(Val) FOR ColNum IN
    ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [19], [20])
) AS pvt



--Problem 12		Highly divisible triangular number
--The sequence of triangle numbers is generated by adding the natural numbers.
--	So the 7th triangle number would be 1 + 2 + 3 + 4 + 5 + 6 + 7 = 28. The first ten terms would be:
--	1, 3, 6, 10, 15, 21, 28, 36, 45, 55, ...
--Let us list the factors of the first seven triangle numbers:
-- 1: 1
-- 3: 1,3
-- 6: 1,2,3,6
--10: 1,2,5,10
--15: 1,3,5,15
--21: 1,3,7,21
--28: 1,2,4,7,14,28
--We can see that 28 is the first triangle number to have over five divisors.
--What is the value of the first triangle number to have over five hundred divisors?
;WITH cteTri AS (
    SELECT Number - 1 AS triNum, 1 AS Level
    FROM Numbers
    WHERE Number = 1
    UNION ALL
    SELECT triNum + Level, t.Level + 1 AS Level
    FROM cteTri AS t
    WHERE t.triNum < 500000000	--43 seconds, of course 100000000 would be good enough to get answer & a lot quicker
)
SELECT triNum, fact.ApproxFactorCount, MIN(triNum) OVER () AS Answer
FROM cteTri AS t
CROSS APPLY (SELECT COUNT(n2.Number) * 2 AS ApproxFactorCount FROM Numbers AS n2
        WHERE n2.Number < SQRT(t.triNum) + 1 AND t.triNum % n2.Number = 0) AS fact
WHERE fact.ApproxFactorCount > 500
OPTION (MAXRECURSION 0)
----earlier pass, a more accurate read on the FactorCount
    --SELECT triNum, COUNT(fact.Factor) AS factorCount
    --FROM cteTri t
    --CROSS APPLY (SELECT Number as Factor from Numbers WHERE Number < SQRT(t.triNum) + 1 AND t.triNum % Number = 0
    --			UNION
    --			SELECT t.triNum/Number from Numbers WHERE Number < SQRT(t.triNum) + 1 AND t.triNum % Number = 0
    --			) fact
    --GROUP BY triNum
    --HAVING COUNT(fact.Factor) > 500
    --OPTION (MAXRECURSION 0)



--Problem 13		Large sum
--Work out the first ten digits of the sum of the following one-hundred 50-digit numbers.
DECLARE @Nums TABLE (num char(50))
INSERT INTO @Nums
VALUES
('37107287533902102798797998220837590246510135740250'), ('46376937677490009712648124896970078050417018260538'),
('74324986199524741059474233309513058123726617309629'), ('91942213363574161572522430563301811072406154908250')
--, and another 96 numbers, see orig problem page
SELECT LEFT(SUM(CAST(LEFT(num, 15) AS BIGINT)), 10) as Answer
FROM @Nums



--Problem 14		Longest Collatz sequence
--The following iterative sequence is defined for the set of positive integers:
--	n -> n/2 (n is even)
--	n -> 3n + 1 (n is odd)
--Using the rule above and starting with 13, we generate the following sequence:
--13 -> 40 -> 20 -> 10 -> 5 -> 16 -> 8 -> 4 -> 2 -> 1
--It can be seen that this sequence (starting at 13 and finishing at 1) contains 10 terms.
--Although it has not been proved yet (Collatz Problem), it is thought that all starting numbers finish at 1.
--Which starting number, under one million, produces the longest chain?
--NOTE: Once the chain starts the terms are allowed to go above one million.
--OCG Note: tried many versions & adjustments to below but below is the best I got to, about 3.5 minutes on my laptop
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
GO
CREATE Table #temp(coll BIGINT, LevelsRemaining INT) --, PRIMARY KEY (coll, LevelsRemaining))

DECLARE @c1_Beg INT =  10000, @c1_End  INT = 20000
DECLARE @c2_Beg INT =  90000, @c2_End  INT = 100000
DECLARE @c2a_Beg INT = 100000, @c2a_End INT = 110000
DECLARE @c2b_Beg INT = 200000, @c2b_End INT = 210000
DECLARE @c3_Beg INT = 500000, @c3_End INT = 1000000

;WITH cteColl AS (
    SELECT nums.Number AS n, CAST(nums.Number AS BIGINT) AS coll, 2 AS Level --final Level will now = the Collatz count
    FROM Numbers AS nums
    WHERE nums.Number BETWEEN @c1_Beg AND @c1_End  --10,000 in 16 seconds, 7 seconds w/only testing odds
UNION ALL
    SELECT n, CASE WHEN c.coll % 2 = 0 THEN  c.coll / 2
                    ELSE 3 * c.coll + 1 END AS coll,
            Level + 1 AS Level
    FROM cteColl AS c
    WHERE coll > 2
)
INSERT INTO #temp
    SELECT DISTINCT coll, MAX(Level) OVER (PARTITION BY n) - Level AS LevelsRemaining
    FROM cteColl
    OPTION (MAXRECURSION 0)

;WITH cteColl2 AS (
    SELECT nums.Number AS n, CAST(nums.Number AS BIGINT) AS coll, 2  AS Level,
        (SELECT nu.LevelsRemaining FROM #temp AS nu WHERE nu.coll = nums.Number) AS RemainingLevels
    FROM Numbers AS nums
    WHERE nums.Number
    BETWEEN @c2_beg AND @c2_End
UNION ALL
    SELECT n , CASE WHEN ISNULL(RemainingLevels, 0) != 0 THEN 2
                    WHEN c.coll % 2 = 0 THEN  c.coll / 2
                    ELSE 3 * c.coll + 1 END AS coll,
            ISNULL(RemainingLevels, 0) + 1 + Level AS Level,
            (SELECT nu.LevelsRemaining FROM #temp nu 
                WHERE nu.coll = CASE WHEN c.coll % 2 = 0
                                    THEN c.coll / 2 
                                    ELSE 3 * c.coll + 1 END
            ) AS RemainingLevels
    FROM cteColl2 c
    WHERE c.coll > 2
)
INSERT INTO #temp
SELECT A.coll, A.LevelsRemaining
FROM (--need subquery so that the window partition operates on the full n set
    SELECT DISTINCT coll, MAX(Level) OVER (PARTITION BY n) - Level - 1  AS LevelsRemaining, RemainingLevels
    FROM cteColl2 ) AS A
    WHERE A.RemainingLevels IS NULL
    OPTION (MAXRECURSION 0)

;WITH
cteColl2A AS (
    SELECT nums.Number AS n, CAST(nums.Number AS BIGINT) AS coll, 2 AS Level, --final Level will now = the Collatz count
        (SELECT nu.LevelsRemaining FROM #temp nu WHERE nu.coll = nums.Number) AS RemainingLevels
    FROM Numbers AS nums
    WHERE nums.Number
        BETWEEN @c2a_beg AND @c2a_End
UNION ALL
    SELECT n, CASE WHEN ISNULL(RemainingLevels, 0) != 0 THEN 2
                    WHEN c.coll % 2 = 0 THEN c.coll / 2
                    ELSE 3 * c.coll + 1 END AS coll,
            ISNULL(RemainingLevels, 0) + 1 + Level AS Level,
            (SELECT nu.LevelsRemaining FROM #temp nu 
             WHERE nu.coll = CASE WHEN c.coll % 2 = 0
                                THEN c.coll / 2
                                ELSE 3 * c.coll + 1 END
            ) AS RemainingLevels
    FROM cteColl2A AS c
    WHERE c.coll > 2
)
INSERT INTO #temp
SELECT A.coll, A.LevelsRemaining
FROM ( --need subquery so that the window partition operates on the full n set
    SELECT DISTINCT coll, MAX(Level) OVER (PARTITION BY n) - Level - 1 AS LevelsRemaining, RemainingLevels
    FROM cteColl2A ) AS A
    WHERE A.RemainingLevels IS NULL
    OPTION (MAXRECURSION 0)

;WITH cteColl2B AS (
    SELECT nums.Number AS n, CAST(nums.Number AS BIGINT) AS coll, 2 AS Level,
        (SELECT nu.LevelsRemaining FROM #temp nu WHERE nu.coll = nums.Number) AS RemainingLevels
    FROM Numbers AS nums
    WHERE nums.Number
    BETWEEN @c2b_beg AND @c2b_End
UNION ALL
    SELECT n, CASE WHEN ISNULL(RemainingLevels, 0) != 0 THEN 2
                    WHEN c.coll % 2 = 0 THEN c.coll / 2
                    ELSE 3 * c.coll + 1 END AS coll,
            ISNULL(RemainingLevels, 0) + 1 + Level AS Level,
            (SELECT nu.LevelsRemaining FROM #temp nu 
             WHERE nu.coll = CASE WHEN c.coll % 2 = 0
                                THEN c.coll / 2
                                ELSE 3 * c.coll + 1 END
            ) AS RemainingLevels
    FROM cteColl2B AS c
    WHERE c.coll > 2
)
INSERT INTO #temp
SELECT A.coll, A.LevelsRemaining
FROM ( --need subquery so that the window partition operates on the full n set
    SELECT DISTINCT coll, MAX(Level) OVER (PARTITION BY n) - Level - 1 AS LevelsRemaining, RemainingLevels
    FROM cteColl2B ) AS A
    WHERE A.RemainingLevels IS NULL
    OPTION (MAXRECURSION 0)

;WITH cteColl3 AS
(
    SELECT nums.Number AS n, CAST(nums.Number AS BIGINT) AS coll, 2 AS Level, --final Level will now = the Collatz count
        (SELECT nu.LevelsRemaining FROM #temp nu WHERE nu.coll = nums.Number) AS RemainingLevels
    FROM Numbers nums
    WHERE nums.Number BETWEEN @c3_beg AND @c3_End AND nums.Number % 2 != 0 OR nums.Number = 13
UNION ALL
    SELECT n, CASE WHEN ISNULL(RemainingLevels, 0) != 0 THEN 2
                    WHEN c.coll % 2 = 0 THEN c.coll / 2
                    ELSE 3 * c.coll + 1 END AS coll,
            ISNULL(RemainingLevels - 1, 0) + 1 + Level AS Level,
            (SELECT nu.LevelsRemaining FROM #temp nu WHERE nu.coll = CASE WHEN c.coll % 2 = 0
                THEN c.coll / 2 ELSE 3 * c.coll + 1 END
            ) AS RemainingLevels
    FROM cteColl3 AS c
    WHERE c.coll > 2
)
SELECT TOP 1 c.*
FROM cteColl3 c
ORDER BY Level DESC, c.n
OPTION (MAXRECURSION 0)

DROP TABLE #temp

-- end of Problem 14


--Problem 15		Lattice paths
--Starting in the top left corner of a 2×2 grid, and only being able to move to the right and down,
--there are exactly 6 routes to the bottom right corner.
--How many such routes are there through a 20×20 grid?
;WITH cteFactorial AS (
    SELECT 1 AS num1, CAST(1 AS float) AS factorial
    UNION ALL
    SELECT cte.num1 + 1, (cte.num1 + 1) * cte.factorial
    FROM cteFactorial AS cte
    WHERE cte.num1 < 40
)
SELECT dbl.factorial / (POWER(sngl.factorial, 2)) AS Paths
--SELECT Number, sngl.factorial as NumFact, dbl.factorial as TwoTimesNumFact, dbl.factorial  as numerator,
--  POWER(sngl.factorial, 2) as denominator, dbl.factorial / (POWER(sngl.factorial, 2)) as Paths
FROM Numbers AS N
INNER JOIN cteFactorial AS sngl ON sngl.num1 = N.Number
INNER JOIN cteFactorial AS dbl ON dbl.num1 = (N.Number * 2)
WHERE N.Number = 20



--Problem 16		Power digit sum
--2^15 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.
--What is the sum of the digits of the number 2^1000?
--OCG Note: doing mathematically first in cteLowSquares to max saves a second vs. doing everything via Function = fnSquareProblem16
DECLARE @Num VARCHAR(MAX)
;WITH cteLowSquares AS (
    SELECT CAST(2 AS DECIMAL(38,0)) AS val, 1 AS pwr
    UNION ALL
    SELECT val * 2 AS val, pwr + 1 AS pwr
    FROM cteLowSquares
    WHERE pwr < 126
)
,cteSquares AS (
    SELECT CAST(MAX(val) AS VARCHAR(MAX)) AS Num, MAX(pwr) AS Level
    FROM cteLowSquares
    UNION ALL
    SELECT dbo.fnSquareProblem16(Num), Level + 1
    FROM cteSquares
    WHERE Level < 1000
)
SELECT @Num = Num
FROM cteSquares
WHERE Level = 1000
OPTION (MAXRECURSION 0)

SELECT SUM(c.digit) AS Total
FROM Numbers
    CROSS APPLY (SELECT CAST(SUBSTRING(@Num, Number, 1) AS INT) AS digit) AS c
WHERE Number <= LEN(@Num)

----- this one requires a function
		CREATE FUNCTION dbo.fnSquareProblem16( @Num VARCHAR(MAX))
		RETURNS VARCHAR(MAX)
		AS
		BEGIN

		DECLARE @ReturnValue VARCHAR(MAX)

        ;WITH cteDigits AS (
            SELECT c.digit, c.digit + c.digit AS summed, LEN(c.digit + c.digit) AS lenSummed, Number -1 AS digitIndex,
                LEN(@Num) - 1 AS upperBound
            FROM Numbers
                CROSS APPLY (SELECT (CAST(SUBSTRING(@Num, LEN(@Num) - Number + 1, 1) AS INT)) AS digit) AS c
            WHERE Number <= LEN(@Num)
        )
        ,cteCalc AS (
            SELECT c.digit AS currDigit, c.summed AS currSummed, p.digit AS prevDigit, p.summed AS prevSummed,
                c.digit + ISNULL(p.digit, 0) currPlusPrevDigit,
                CAST(RIGHT(CAST(c.summed AS varchar(2)), 1) AS INT)
                    + CASE
                        WHEN c.digitIndex = 0 AND c.lenSummed = 2 AND c.upperBound = 0 THEN 10
                        WHEN c.digitIndex = c.upperBound AND c.lenSummed = 1 and p.lenSummed = 2 THEN 1
                        WHEN c.digitIndex = c.upperBound AND c.lenSummed = 2 AND p.lenSummed = 2 THEN 11
                        WHEN c.digitIndex = c.upperBound AND c.lenSummed = 2 THEN 10
                        WHEN p.lenSummed = 2 THEN 1
                        ELSE 0 END AS newDigit,
                c.digitIndex AS currDigitIndex,
                c.upperBound
            FROM cteDigits c
            LEFT JOIN cteDigits p on p.digitIndex + 1 = c.digitIndex
        )
        SELECT @ReturnValue = (
                SELECT
                CAST(newDigit AS varchar(2))
                FROM cteCalc
                ORDER by currDigitIndex desc
                FOR XML PATH('')
        )
		RETURN @ReturnValue

		END;
---- end Function
--- End Problem 16



--Problem 17		Number letter counts
--If the numbers 1 to 5 are written out in words: one, two, three, four, five, then there are
--	3 + 3 + 5 + 4 + 4 = 19 letters used in total.
--If all the numbers from 1 to 1000 (one thousand) inclusive were written out in words, how many letters would be used?
--NOTE: Do not count spaces or hyphens. For example, 342 (three hundred and forty-two) contains 23 letters
--	and 115 (one hundred and fifteen) contains 20 letters.
--	The use of "and" when writing out numbers is in compliance with British usage.
--OCG Note: almost entirely unreadable but it gets the answer
;WITH cte AS (
    SELECT Number, ca.isHundreds, ca.TrueNumber, ca.NumLength, ca.NumLengthHundreds, ca.Base,
        SUM(ca.NumLength + ca.NumLengthHundreds) OVER (ORDER BY Number) AS RunSummed,
        SUM(ca.NumLength + ca.NumLengthHundreds) OVER () AS Summed
    FROM Numbers
        CROSS APPLY (
        SELECT A.Base, IsHundreds, TrueNumber,
        CASE WHEN IsHundreds = 1 THEN
            CASE WHEN TrueNumber % 100 = 0 THEN CHOOSE(TrueNumber/100, 10, 10, 12, 11, 11, 10, 12, 12, 11)
                ELSE CHOOSE(CAST(LEFT(NumberString, 1) AS INT), 3, 3, 5, 4, 4, 3, 5, 5, 4) + 10 --hundredand
                END
            ELSE 0
            END AS NumLengthHundreds,
        CASE WHEN TrueNumber = 1000 THEN 11
            WHEN Number < 10 THEN ISNULL(CHOOSE(Number, 3, 3, 5, 4, 4, 3, 5, 5, 4), 0)
            WHEN Number BETWEEN 11 AND 19 THEN CHOOSE(Number-10, 6, 6, 8, 8, 7, 7, 9, 8, 8)
            --WHEN Number = 1000 THEN 11
            WHEN Number % 10 = 0 AND Number < 100 THEN CHOOSE(Number/10, 3, 6, 6, 5, 5, 5, 7, 6, 6)
            --handle 21-29, 31-39 etc.
            WHEN LEN(Number) = 2 THEN CHOOSE(Base, 3, 6, 6, 5, 5, 5, 7, 6, 6) -- pulls out twenty/thirty etc. lengths
                + ISNULL(CHOOSE( CAST(RIGHT(NumberString, 1) AS INT), 3, 3, 5, 4, 4, 3, 5, 5, 4), 3)--ISNULL if final digit = 0
            ELSE 0 END AS NumLength
        FROM (
        SELECT CASE WHEN LEN(Number) <= 2 THEN Number ELSE CAST(RIGHT(CAST(Number AS VARCHAR(4)), 2) AS INT) END AS Number,
            Number AS TrueNumber,
            CAST(Number AS VARCHAR(4)) AS NumberString,
            CASE WHEN LEN(Number) = 2 THEN Number/10
                WHEN LEN(Number) = 3 THEN CAST(RIGHT(CAST(Number AS VARCHAR(4)), 2) AS INT)/10
                END AS Base,
            CASE WHEN LEN(Number) = 3 THEN 1 ELSE 0 END AS IsHundreds
            ) AS A
        ) AS ca
    WHERE Number < 1001
)
SELECT MAX(c.Summed)
FROM cte AS c




--Problem 18	Maximum path sum I
-- the pyramid looking one....
--Find the maximum total from top to bottom of the triangle below:
--OCG Note: first one to involve dynamic SQL, general algorithm is based off a common solution going from bottom-up,
--	initial py code got the answer but was painfully slow
DECLARE @data VARCHAR(MAX) =
'DECLARE @Nums TABLE(R INT IDENTITY(0,1), [0] INT, [1] INT,[2] INT,[3] INT,[4] INT,[5] INT,[6] INT,[7] INT,[8] INT,[9] INT, [10] INT, [11] INT, [12] INT, [13] INT, [14] INT);' +
'INSERT INTO @Nums ([0]) VALUES (75);' +
'INSERT INTO @Nums ([0],[1]) VALUES (95, 64);' +
'INSERT INTO @Nums ([0],[1],[2]) VALUES (17, 47, 82);' +
'INSERT INTO @Nums ([0],[1],[2],[3]) VALUES (18, 35, 87, 10);' +
'INSERT INTO @Nums ([0],[1],[2],[3],[4]) VALUES (20, 4, 82, 47, 65);' +
'INSERT INTO @Nums ([0],[1],[2],[3],[4],[5]) VALUES (19, 1, 23, 75, 3, 34);' +
'INSERT INTO @Nums ([0],[1],[2],[3],[4],[5],[6]) VALUES (88, 2, 77, 73, 7, 63, 67);' +
'INSERT INTO @Nums ([0],[1],[2],[3],[4],[5],[6],[7]) VALUES (99, 65, 4, 28, 6, 16, 70, 92);' +
'INSERT INTO @Nums ([0],[1],[2],[3],[4],[5],[6],[7],[8]) VALUES (41, 41, 26, 56, 83, 40, 80, 70, 33);' +
'INSERT INTO @Nums ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9]) VALUES (41, 48, 72, 33, 47, 32, 37, 16, 94, 29);' +
'INSERT INTO @Nums ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10]) VALUES (53, 71, 44, 65, 25, 43, 91, 52, 97, 51, 14);' +
'INSERT INTO @Nums ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11]) VALUES (70, 11, 33, 28, 77, 73, 17, 78, 39, 68, 17, 57);' +
'INSERT INTO @Nums ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]) VALUES (91, 71, 52, 38, 17, 14, 91, 43, 58, 50, 27, 29, 48);' +
'INSERT INTO @Nums ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13]) VALUES (63, 66, 4, 68, 89, 53, 67, 30, 73, 16, 69, 87, 40, 31);' +
'INSERT INTO @Nums ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14]) VALUES (04, 62, 98, 27, 23, 9, 70, 98, 73, 93, 38, 53, 60, 4, 23);'
DECLARE @UpdateLines VARCHAR(MAX);
;WITH cte1 AS (
    SELECT CONCAT('update @Nums SET [', N.Number - 1, '] += (SELECT CASE WHEN [', N.Number - 1, '] > [', N.Number, '] THEN [', N.Number - 1,
        '] ELSE [', N.Number, '] END FROM @Nums WHERE R = ', N2.Number, ') WHERE R = ', N2.Number - 1, ';') AS UpdateLine,
        N.Number AS N_Number, N2.Number AS N2_Number
    FROM Numbers AS N
        CROSS APPLY (SELECT Number FROM Numbers WHERE Number < 15 ) AS N2
    WHERE N.Number < 15
)
SELECT @UpdateLines =
    REPLACE((SELECT CAST(UpdateLine AS VARCHAR(200))
            FROM cte1
            ORDER BY N2_Number DESC, N_Number
            FOR XML Path('')), '&gt;', '>')
DECLARE @Answer VARCHAR(100) = 'SELECT MAX([0]) AS Answer FROM @Nums'
EXEC(@data+@UpdateLines+@Answer)



--Problem 19		Counting Sundays
--You are given the following information, but you may prefer to do some research for yourself.
--- 1 Jan 1900 was a Monday.
--- Thirty days has September,
-- April, June and November.
-- All the rest have thirty-one,
-- Saving February alone,
-- Which has twenty-eight, rain or shine.
-- And on leap years, twenty-nine.
--- A leap year occurs on any year evenly divisible by 4, but not on a century unless it is divisible by 400.
--How many Sundays fell on the first of the month during the twentieth century (1 Jan 1901 to 31 Dec 2000)?
SELECT COUNT(*) AS Answer
FROM Numbers AS M
    CROSS APPLY (SELECT Number FROM Numbers WHERE Number BETWEEN 1901 and 2000) AS Y
WHERE M.Number <= 12 AND DATEPART(WEEKDAY, DATEFROMPARTS(Y.Number, M.Number, 1)) = 1

-- ALTERNATE, practice using a WHILE loop
DECLARE @DateBegin DATE = '1901-01-01', @DateEnd DATE = '2000-12-31';
DECLARE @SundayCount INT = 0;
WHILE @DateBegin <= @DateEnd
BEGIN
    IF DATEPART(WEEKDAY, @DateBegin) = 1
        SET @SundayCount = @SundayCount + 1
    IF DATEPART(MONTH, @DateBegin) = 12
        SET @DateBegin = DATEFROMPARTS(DATEPART(YEAR, @DateBegin) + 1, 1, 1)
    ELSE
        SET @DateBegin = DATEFROMPARTS(DATEPART(YEAR, @DateBegin), DATEPART(MONTH, @DateBegin) + 1, 1)
END
SELECT @SundayCount



--Problem 20		Factorial digit sum
--n! means n × (n - 1) x ... x 3 x 2 x 1
--For example, 10! = 10 x 9 x ... x 3 x 2 x 1 = 3628800,
--and the sum of the digits in the number 10! is 3 + 6 + 2 + 8 + 8 + 0 + 0 = 27.
--Find the sum of the digits in the number 100!
--OCG Note: wasn't getting anywhere with pure T-SQL solution, so went with a rather partial solution
--	assuming the final factorial value was available
DECLARE @Fact100 VARCHAR(200) = '93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000'
SELECT Number, SUM(CAST(SUBSTRING(@Fact100, Number, 1) AS INT) ) OVER () AS Answer
FROM Numbers
WHERE Number <= LEN(@Fact100)

--OCG Note: unsatisfied with that I was able to find a more common C solution and at least translate that to T-SQL
DECLARE @est_digit_count INT;
DECLARE @factorial INT = 100;
--use recursive cte to get the digit count/table size so we don't waste iterations later, float ain't gonna help directly w/answer
;WITH cteFact AS (
    SELECT CAST(1 AS float) AS fact, 1 AS Level
    UNION ALL
    SELECT fact * CAST(Level + 1 AS float) AS fact, Level + 1 AS Level
    FROM cteFact AS f
    WHERE f.Level < @factorial
)
SELECT @est_digit_count = MAX(LEN(RTRIM(LTRIM(STR(fact, 500)))))
FROM cteFact;

DECLARE @i INT = @est_digit_count;
DECLARE @total INT = 0;
DECLARE @count INT = 2;
DECLARE @remainder INT = 0;

DECLARE @arr TABLE(id INT IDENTITY, i INT);
INSERT INTO @arr(i)
    SELECT 0
    FROM Numbers
    WHERE Number <= @i - 1;
INSERT INTO @arr VALUES (1);

WHILE @count <= @factorial
BEGIN
    WHILE @i > 0
    BEGIN
        SET @total = ((SELECT i FROM @arr WHERE id = @i) * @count) + @remainder;
        SET @remainder = 0;
        IF @total >= 10
        BEGIN
            UPDATE @arr SET i = @total % 10 WHERE id = @i;
            SET @remainder = @total / 10;
        END
        ELSE
        BEGIN
            UPDATE @arr SET i = @total WHERE id = @i;
        END
        SET @i -= 1;
    END

    SET @remainder = 0;
    SET @total = 0;
    SET @i = @est_digit_count;
    SET @count += 1;
END
SELECT SUM(i) AS Answer20 FROM @arr
---- use below instead below for details
--select *, SUM(i) OVER () AS Answer20, (SELECT CAST( (select CAST(i AS VARCHAR(1))
--	FROM @arr
--	FOR XML PATH('')) AS VARCHAR(100))
--	)
--from @arr;


