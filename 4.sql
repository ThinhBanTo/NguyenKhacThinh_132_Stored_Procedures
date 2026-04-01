create table products(
    id serial primary key ,
    name varchar(100),
    price numeric,
    discount_percent int
);

create or replace procedure calculate_discount(p_id INT, OUT p_final_price NUMERIC)
language plpgsql
as
$$
    declare
        p_price numeric;
        p_dp int;
    begin
        select price,discount_percent into p_price,p_dp
        from products
        where id=p_id;

        if p_dp>50 then p_dp:=50;
        end if;

        p_final_price:=p_price-(p_price*p_dp/100);

        update products
        set price=p_final_price
        where id=p_id;
    end;
    $$;

do
$$
    declare p_final_price numeric;
    begin
        call calculate_discount(2,p_final_price);
        raise notice 'Giá cuối cùng của sản phẩm id 2 là: %',p_final_price;
    end;
$$;
