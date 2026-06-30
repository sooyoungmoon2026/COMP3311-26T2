

create or replace function seq(n integer) returns setof integer
as $$
DECLARE
    i   integer;
BEGIN
    for i in 1 .. n
    loop
        return next i;
    end loop;

END;
$$ language plpgsql;