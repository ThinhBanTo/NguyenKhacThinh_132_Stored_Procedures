create table employees(
    id serial primary key ,
    name varchar(100) not null ,
    department varchar(50),
    salary numeric(10,2),
    bonus numeric(10,2) default 0
);

insert into employees(name, department, salary)
values ('Nguyen Van A','HR',4000),
       ('Tran Thi B','IT',6000),
       ('Le Van C','Finance',10500),
       ('Pham Thi D','IT',8000),
       ('Do Van E','HR',12000);

create or replace procedure update_employee_status(
    in p_emp_id int,
    out p_status text
)
language plpgsql
as
$$
    declare p_salary numeric(10,2);
    begin
        select salary into p_salary
        from employees
        where id=p_emp_id;

        if p_salary isnull then raise exception 'Employee not found';
        elseif p_salary<5000 then p_status:='Junior';
        elseif p_salary between 5000 and 10000 then p_status:='Mid-level';
        elseif p_salary>10000 then p_status:='Senior';
        end if;
    end;
    $$;

do $$
    declare
        p_status text;
        p_id int :=1;
    begin
        call update_employee_status(p_id,p_status);
        raise notice 'Nhân viên có id % là %',p_id,p_status;
    end;
    $$;