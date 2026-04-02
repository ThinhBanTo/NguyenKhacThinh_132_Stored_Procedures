--A: Tao thong tin tai khoan
create or replace procedure thong_tin_tai_khoan(
    p_ma_tk VARCHAR,
    OUT p_ho_ten VARCHAR,
    OUT p_so_du DECIMAL,
    OUT p_so_giao_dich INTEGER
)
language plpgsql
as
    $$
    begin
        select ho_ten,taikhoan.so_du,count(giaodich.id) into p_ho_ten,p_so_du,p_so_giao_dich
        from taikhoan join khachhang on taikhoan.khach_hang_id = khachhang.id
                    left join giaodich on taikhoan.id = giaodich.tai_khoan_id
        where ma_tk=p_ma_tk
        group by taikhoan.id,ma_tk;

        if p_ho_ten is null then
            p_so_du:=0;
            p_so_giao_dich:=0;
            raise notice 'Khong tim thay thong tin cho tai khoan: %',p_ma_tk;
        end if;
    end;
    $$;
--goi
do $$
    declare
        v_ten varchar;
        v_du decimal;
        v_sl_gd int;
    begin
        call thong_tin_tai_khoan('TK001', v_ten, v_du, v_sl_gd);

        raise notice '--- THONG TIN TAI KHOAN ---';
        raise notice 'Chu tai khoan: %', v_ten;
        raise notice 'So du hien tai: %', v_du;
        raise notice 'Tong so giao dich: %', v_sl_gd;
    end;
$$;

--B: Tinh lai suat voi bien phuc tap
create or replace procedure tinh_lai_suat_thang(
    p_thang int,
    p_nam int
)
language plpgsql
as
$$
    declare
        v_tk_row record;
        v_lai_suat_thang decimal(5,4) :=0.005;  --doi gia tri lai
    begin
        for v_tk_row in
        select id,so_du
        from taikhoan
        where trang_thai='ACTIVE'

    loop
        update taikhoan
        set so_du=v_tk_row.so_du*(1+v_lai_suat_thang)
        where id=v_tk_row.id;
    end loop;
    raise notice 'Hoan thanh tinh lai cho thang % nam %',p_thang,p_nam;
    end;
    $$;
--goi
call tinh_lai_suat_thang(4,2026);