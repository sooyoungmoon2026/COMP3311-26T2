create or replace function sqr(n Numeric) returns Numeric
as $$
BEGIN
    return n * n;
END;
$$ language plpgsql;