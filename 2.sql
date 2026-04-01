create table inventory(
    product_id serial primary key ,
    product_name varchar(100),
    quantity int
);

--1
create or replace procedure check_stock(
    p_id int,
    p_qty int
)
language plpgsql
as $$
    declare v_current_qty int;
    begin
        select quantity into v_current_qty
        from inventory
        where product_id=p_id;

        if v_current_qty<p_qty then
            raise notice 'Không đủ hàng trong kho';
        else raise notice 'Đủ hàng';
        end if;
    end;
    $$;
--2
insert into inventory(product_name, quantity)
values ('dien thoai',10),
       ('may tinh',100),
       ('tai nghe',103),
       ('quat dien',101);

call check_stock(1,100);
call check_stock(1,10);
