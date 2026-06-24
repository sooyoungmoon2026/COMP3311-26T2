-- Q12.  Find the sids and snames of suppliers who supply some red part. 
-- SELECT DISTINCT ON (col1) col1, col2 to distinct only specific cols
select distinct S.sid, S.sname
from   Suppliers S, Parts P, Catalog C
where  P.colour='red' and C.part=P.pid and C.supplier=S.sid
order  by S.sid
-------------------------------
select  distinct s.sid, s.sname
from    suppliers s
        join catalog c on (c.supplier = s.sid)
        join parts p on (c.part = p.pid)
where   p.colour = 'red'
order   by s.sid


-- Q13.  Find the sids and snames of suppliers who supply some red or green part. 
select  distinct s.sid, s.sname
from    catalog c
        join parts p on (c.part = p.pid)
        join suppliers s on (c.supplier = s.sid)
where   p.colour = 'red' or p.colour = 'green'
order   by s.sid


-- Q14.  Find the sids and snames of suppliers who supply some red part or whose address is 221 Packer Street. 
select S.sid, S.sname
from   Suppliers S
where  S.address='221 Packer Street'
       or S.sid in (select c.supplier
                    from   Parts P, Catalog C
                    where  P.colour='red' and P.pid=c.part
                   )
order   by S.sid
-------------------------------
(select  distinct s.sid, s.sname
from    catalog c
        join parts p on (c.part = p.pid)
        join suppliers s on (c.supplier = s.sid)
where   p.colour = 'red' or p.colour = 'green'
order   by s.sid)
union
(select S.sid, S.sname
from Suppliers S
where S.address = '221 Packer Street')


-- Q15.  Find the sids and snames of suppliers who supply some red part and some green part. 
(   
    -- Get suppliers who supply a red part
    select  s.sid, s.sname
    from    catalog c
            join parts p on (c.part = p.pid)
            join suppliers s on (s.sid = c.supplier)
    where   p.colour = 'red'
) intersect ( -- Get the set intersection of these two tables. Only suppliers who appear in both queries with be in the result.
    -- Get suppliers who supply a green part
    select  s.sid, s.sname
    from    catalog c
            join parts p on (c.part = p.pid)
            join suppliers s on (s.sid = c.supplier)
    where   p.colour = 'green'
)
-------------------------------
select distinct S.sid, S.sname
from   Parts P, Catalog C, Suppliers S
where  P.colour='red' and P.pid=C.part and S.sid=C.supplier
       and exists (select P2.pid
                   from   Parts P2, Catalog C2
                   where  P2.colour='green' and c2.supplier=c.supplier and P2.pid=C2.pid
                  )


-- Q16.  Find the sids and snames of suppliers who supply every part. 
-- A supplier supplies all parts => There is no part a supplier doesn't supply
-- Parts a supplier doesn't supply = All Parts - Parts the supplier supplies 
select  S.sid, S.sname
from    Suppliers S
where   not exists((select P.pid from Parts P)
                  except
                  (select c.part from Catalog C where C.supplier=S.sid) 
                 )
order   by s.sid
-------------------------------
-- Grab the number of parts per supplier, then filter for suppliers with the total number of parts in the database
select  s.sid, s.sname -- DISTINCT not necessary as query groups by these attributes
from    catalog c
        join suppliers s on (s.sid = c.supplier)
group   by s.sid, s.sname
having  count(distinct c.part) = (select count(*) from parts)
order   by s.sid


-- Q17.  Find the sids and snames of suppliers who supply every red part. 
select S.sid, S.sname
from   Suppliers S
where  not exists((select P.pid from Parts P where P.colour='red')
                  except
                  (select c.part from Catalog C where c.supplier=S.sid)
                 )
order   by S.sid
-------------------------------
select  s.sid, s.sname
from    catalog c
        join parts p on (c.part = p.pid)
        join suppliers s on (s.sid = c.supplier)
where   p.colour = 'red'
group   by s.sid, s.sname
having  count(distinct c.part) = (select count(*) from parts where colour = 'red')
order   by s.sid


-- Q18.  Find the sids and snames of suppliers who supply every red or green part (supply every red part and supply every green part). 
select S.sid, S.sname
from   Suppliers S
where  not exists((select P.pid from Parts P
                   where P.colour='red' or P.colour='green')
                  except
                  (select c.part from Catalog C where c.supplier=S.sid)
                 )
order   by S.sid
-------------------------------
select  s.sid, s.sname
from    catalog c
        join parts p on (c.part = p.pid)
        join suppliers s on (s.sid = c.supplier)
where   p.colour = 'red' or p.colour = 'green'
group   by s.sid, s.sname
having  count(p.pid) = (select count(*) from parts where colour = 'red' or colour = 'green')
order   by S.sid
-------------------------------
(
    select  s.sid, s.sname
    from    catalog c
            join parts p on (c.part = p.pid)
            join suppliers s on (s.sid = c.supplier)
    where   p.colour = 'red'
    group   by s.sid, s.sname
    having  count(distinct c.part) = (select count(*) from parts where colour = 'red')
) intersect (
    select  s.sid, s.sname
    from    catalog c
            join parts p on (c.part = p.pid)
            join suppliers s on (s.sid = c.supplier)
    where   p.colour = 'green'
    group   by s.sid, s.sname
    having  count(distinct c.part) = (select count(*) from parts where colour = 'green')
)
order   by S.sid


-- Q19.  Find the sids and snames of suppliers who supply every red part or supply every green part. 
(select S.sid, S.sname
 from   Suppliers S
 where  not exists((select P.pid from Parts P where P.colour='red')
                   except
                   (select c.part from Catalog C where c.supplier=S.sid)
                  )
)
union
(select S.sid, S.sname
 from   Suppliers S
 where  not exists((select P.pid from Parts P where P.colour='green')
                   except
                   (select c.part from Catalog C where c.supplier=S.sid)
                  )
)


-- Q20.  Find pairs of (sid, sname) such that the supplier with the first sid charges more for some part than the supplier with the second sid. 
select  distinct c1.supplier as sid1, s1.sname as sname1, c2.supplier as sid2, s2.sname as sname2
from    catalog c1
        join catalog c2 on (c1.part = c2.part and c1.supplier != c2.supplier)
        join suppliers s1 on (c1.supplier = s1.sid)
        join suppliers s2 on (c2.supplier = s2.sid)
where   c1.cost > c2.cost
order   by sid1, sid2


-- Q21.  Find the pids and pnames of parts that are supplied by at least two different suppliers. 
select  p.pid, p.pname
from    Catalog c
        join parts p on (c.part = p.pid)
group   by p.pid, p.pname
having  count(distinct c.supplier) >= 2
order   by p.pid 


-- Q22.  Find the pids and pnames of the most expensive part(s) supplied by suppliers named "Yosemite Sham". 
select  p.pid, p.pname
from    catalog c
        join suppliers s on (c.supplier = s.sid)
        join parts p on (c.part = p.pid)
where   S.sname = 'Yosemite Sham'
        and C.cost >= (
            select  max(c2.cost)
            from    catalog c2
                    join suppliers s2 on (catalog.c2 = s2.sid)
            where   s2.sname = 'Yosemite Sham' and c2.supplier = s2.sid
        )
order   by p.pid


-- Q23.  Find the pids and pnames of parts supplied by every supplier at a price less than 200 dollars (if any supplier either does not supply the part or charges more than 200 dollars for it, the part should not be selected). 
select  p.pid, p.pname
from    catalog c
        join parts p on (c.part = p.pid)
where   C.cost < 200.00 -- Happens before GROUP BY
group   by p.pid, p.pname
having  count(*) = (select count(*) from Suppliers) -- Happens after GROUP BY
order   by p.pid