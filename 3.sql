create table employees(
    emp_id serial primary key ,
    emp_name varchar(100),
    job_level int,
    salary numeric
);

create or replace procedure adjust_salary(
    p_emp_id int,
    out p_new_salary numeric
)
language plpgsql
as
$$
    declare
        v_job_level int;
        v_salary numeric;
    begin
        select job_level,salary into v_job_level,v_salary
        from employees
        where emp_id=p_emp_id;

        if v_job_level=1 then p_new_salary:=v_salary*1.05;
        elseif v_job_level=2 then p_new_salary:=v_salary*1.1;
        else p_new_salary=v_salary*1.5;
        end if;

        update employees
        set salary=p_new_salary
        where emp_id=p_emp_id;
    end;
    $$;