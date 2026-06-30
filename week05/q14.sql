create or replace function unitName(_ouid integer) returns text
as $$
DECLARE
    _orgName    text;
    _orgType    text;
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
        OU.longname, OT.name
    into
        _orgName, _orgType
    from
        OrgUnit OU
    join
        OrgUnitType OT on (OU.utype = OT.id)
    where
        OU.id = _ouid
    ;

    if _orgType = 'University' then
        return 'UNSW';
    elsif _orgType = 'Faculty' then
        return _orgName;
    elsif _orgType in ('School', 'Department', 'Centre', 'Institute') then
        return _orgType || ' of ' || _orgName;
    else
        return NULL;
    end if;
END;
$$ language plpgsql