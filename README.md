
# some-euler

![alt text](https://projecteuler.net/profile/oweng.png "owenG profile badge")

According to my account on https://projecteuler.net I had solved up to
problem 60, with that last one being solved ... some time ago. Going to post some of
the SQL and R solutions for kicks, though the original pattern had actually
involved solving in Python first, followed by C#. Then at some point did
a subset in SQL (technically T-SQL as they were solved using SQL Server
and if nothing else there are a few `IS NULL`s in there).
And later again a much smaller number in R.

## SQL/T-SQL

Solutions are written in T-SQL, fairly certain they were worked
against SQL Server 2012, has been some years since creation.
Two cheats are used for some of the problems:
- prerequisite of a simple Numbers table, from 1 to 10 million
- likewise, a Primes table holding all prime numbers < 3 million

As noted above most were solved in Python and/or C# first, which ranged
from being quite helpful to not at all helpful in terms of coming up with
a T-SQL solution. For this set I began with 51 and 53, then went back
and started from beginning.

#### [problems 1 to 10](SQL/part01.sql)
#### [problems 11 to 20](SQL/part02.sql)
#### [problems 21 to 24, 51, 53](SQL/part03.sql)

# R

First 10, stored in a Jupyter notebook.
#### [problems 1 to 10](R/part01_R.ipynb)