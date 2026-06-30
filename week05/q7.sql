create or replace function hotelsIn(_addr text) returns text
as $$
DECLARE
    _barName    text;
    _ret        text := '';
BEGIN
    for _barName in (
        select
            name
        from
            Bars
        where
            addr = _addr
    )
    loop
        _ret := _ret || _barName || e'\n';
    end loop;
    
    return _ret;
END;
$$ language plpgsql;