create or replace function happyHourPrice(_hotel text, _beer text, _discount real) returns text
as $$
DECLARE
    _price  real;
    _newPrice real;
BEGIN
    perform
        *
    from
        Bars
    where
        name = _hotel
    ;
    if not found then
        return 'There is no hotel called ' || _hotel;
    end if;

    perform
        *
    from
        Beers
    where
        name = _beer
    ;
    if not found then
        return 'There is no beer called ' || _beer;
    end if;

    select
        price
    into
        _price
    from
        Sells
    where
        bar = _hotel and beer = _beer
    ;
    if not found then
        return _hotel || ' does not serve ' || _beer;
    end if;

    if _price < _discount then
        return 'Price reduction is too large; ' || _beer || 
                ' only costs $ ' || _price;
    end if;

    _newPrice = _price - _discount;
    return 'Happy hour price for ' || _beer || ' at ' || 
            _hotel || ' is $ ' || _newPrice;
END;
$$ language plpgsql;