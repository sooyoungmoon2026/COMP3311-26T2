create table R (
   id    serial,
   name  text,
   d_o_b date,
   primary key (id)
);

create table S (
    r   integer,
    foreign key (r) references R(id)
);