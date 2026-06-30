create or replace function facultyOf(_ouid integer) returns integer
as $$
DECLARE
    _orgType    text;
    _member     integer;
    _parent     integer;
BEGIN 
    perform
        *
    from
        OrgUnit
    where
        id = _ouid
    ;
    if not found then
        raise exception 'No such unit: %', _ouid;
    end if;

    select
        OT.name
    into
        _orgType
    from
        OrgUnit OU
    join
        OrgUnitType OT on (OU.utype = OT.id)
    where OU.id = _ouid
    ;
    if _orgType = 'Faculty' then
        return _ouid;
    elsif _orgType = 'University' then
        return NULL;
    elsif _orgType = NULL then
        return NULL;
    end if;

    _member = _ouid;
    while found loop
        select
            U.owner, OT.name
        into
            _parent, _orgType
        from
            UnitGroups U
        join
            OrgUnit OU on (OU.id = U.owner)
        join
            OrgUnitType OT on (OU.utype = OT.id)
        where member = _member
        ;

        if _orgType = 'Faculty' then
            return _parent;
        end if;

        _member = _parent;
    end loop;

    return null;
END;
$$ language plpgsql;