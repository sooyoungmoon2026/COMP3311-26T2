--- different types

create table Person (
    streetNo    integer,
    street      varchar(40),
    suburb      varchar(20),
    family      varchar(30),
    first       varchar(30),
    initial     char(1),    ' '
    birthdate   date,

    primary key (family, first, initial)
);

text
char(8)     'hello   '
varchar(8)  'hello' 5