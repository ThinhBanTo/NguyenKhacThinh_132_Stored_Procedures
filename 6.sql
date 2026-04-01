create or replace procedure calculate_bonus(
    p_emp_id int,
    p_percent numeric,
    out p_bonus numeric
)
language plpgsql
as $$
    declare
        p_salary numeric;
    begin
        select salary into p_salary
        from employees
        where id=p_emp_id;

        if p_salary isnull then raise exception 'Employee not found';
        elseif p_percent<=0 then p_bonus:=0;
        else p_bonus:=p_salary*p_percent/100;
        end if;

        update employees
        set bonus=p_bonus
        where id=p_emp_id;
    end;
$$;
