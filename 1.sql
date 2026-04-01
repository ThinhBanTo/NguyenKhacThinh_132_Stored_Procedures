create table order_detail(
    id serial primary key ,
    order_id int,
    product_name varchar(100),
    quantity int,
    unit_price numeric
);

create or replace procedure calculate_order_total(
    order_id_input int,
    out total numeric
)
language plpgsql
as $$
    begin
        select sum(quantity*unit_price) into total
        from order_detail
        where order_id=order_id_input;
    end;
    $$;

do $$
    declare total_2 numeric;
        begin
        call calculate_order_total(1,total_2);
        raise notice 'tổng tiền theo đơn hàng 1 là: %',total_2;
    end;
    $$;