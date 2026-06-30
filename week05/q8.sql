create or replace function hotelsIn(_addr text) returns text
as $$
DECLARE
    _barName    text;
    _ret        text := 'Hotels in ';
    _howmany    integer;
BEGIN
    -- _howmany := (select
    --                 count(*)
    --             from
    --                 Bars
    --             where addr = _addr);

    -- select
    --     count(*)
    -- into
    --     _howmany
    -- from
    --     Bars
    -- where
    --     addr = _addr
    -- ;
    -- if _howmany = 0 then
    --     return 'There are no hotels in ' || _addr;
    -- end if;

    perform
        *
    from
        Bars
    where
        addr = _addr
    ;
    if not found then
        return 'There are no hotels in ' || _addr;
    end if;

    _ret = _ret || _addr || ':  ';

    for _barName in (
        select
            name
        from
            Bars
        where
            addr = _addr
    )
    loop
        _ret := _ret || _barName || '  ';
    end loop;
    
    return _ret;
END;
$$ language plpgsql;