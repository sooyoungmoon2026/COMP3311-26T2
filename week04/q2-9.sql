create table Employees (
    eid     integer,
    ename   text,
    age     integer,
    salary  real check (salary >= 15000),
    primary key (eid)
    --   constraint SalaryCheck check (salary >= 15000)
);
create table Departments (
    did     integer,
    dname   text,
    budget  real,
    manager integer NOT NULL DEFAULT 0 references Employees(eid) ON DELETE SET DEFAULT,
    primary key (did)
);
create table WorksIn (
    eid     integer references Employees(eid) ON DELETE CASCADE,
    did     integer references Departments(did),
    percent real,
    primary key (eid,did)
    -- constraint MaxTime check (
    --     (
    --         select 
    --             sum(W.did)
    --         from
    --             WorksIn W
    --         where
    --             W.eid = eid
    --     ) + percent <= 1
    -- )
);

-- Q2
UPDATE
    Employees
SET
    salary = salary * 0.8
WHERE
    age < 25
;

-- Q3
UPDATE
    Employees
SET
    salary = salary * 1.1
WHERE
    eid in (
        select
            W.eid
        from
            WorksIn W
        join
            Departments D on (W.did = D.did)
        where
            D.dname = 'Sales'
    )
;

-- explicit join 
select
    W.eid
from
    WorksIn W
join
    Departments D on (W.did = D.did)
where
    D.dname = 'Sales'
;

-- implicit join
select
    W.eid
from
    WorksIn W, Departments D
where
    W.did = D.did and D.dname = 'Sales'
;
