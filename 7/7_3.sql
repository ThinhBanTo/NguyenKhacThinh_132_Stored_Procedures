--A: phan loai khach hang
create or replace procedure phan_loai_khach_hang()
language plpgsql
as $$
    declare
        v_row_khachhang record;
        v_status text;
    begin
        for v_row_khachhang in
        select ma_kh,so_du from khachhang
        loop
            if v_row_khachhang.so_du>1000000000 then v_status:='VIP';
            elseif v_row_khachhang.so_du>100000000 then v_status:='GOLD';
            elseif v_row_khachhang.so_du>10000000 then v_status:='SILVER';
            else v_status:='STANDARD';
            end if;

            raise notice 'Khach hang co ma % la %',v_row_khachhang.ma_kh,v_status;
            end loop;
    end;
    $$;
call phan_loai_khach_hang();

--B: xu ly phi giao dich
create or replace procedure ap_dung_phi_giao_dich(
    p_ma_gd varchar
)
language plpgsql
as $$
    declare
    begin

    end;
    $$