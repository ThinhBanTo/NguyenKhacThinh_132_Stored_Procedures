--CHUYEN TIEN
create or replace procedure chuyen_tien(
    p_ma_tk_nguoi_gui varchar,
    p_ma_tk_nguoi_nhan varchar,
    p_so_tien decimal,
    p_noi_dung text default null
)
language plpgsql
as $$
    declare
        p_id_tk_nguoi_gui int;
        p_id_tk_nguoi_nhan int;
        p_trang_thai_nguoi_gui varchar(20);
        p_trang_thai_nguoi_nhan varchar(20);
        so_du_nguoi_gui decimal(15,2);
        so_du_con_lai_nguoi_gui decimal(15,2);
        so_du_nguoi_nhan decimal(15,2);
        so_du_con_lai_nguoi_nhan decimal(15,2);
    begin
        select id,trang_thai,so_du into p_id_tk_nguoi_gui,p_trang_thai_nguoi_gui,so_du_nguoi_gui
        from taikhoan
        where ma_tk=p_ma_tk_nguoi_gui;

        select id,trang_thai,so_du into p_id_tk_nguoi_nhan,p_trang_thai_nguoi_nhan,so_du_nguoi_nhan
        from taikhoan
        where ma_tk=p_id_tk_nguoi_nhan;

        if
            p_id_tk_nguoi_gui is not null and
            p_id_tk_nguoi_nhan is not null and
            p_trang_thai_nguoi_gui='ACTIVE' and
            p_trang_thai_nguoi_nhan='ACTIVE' and
            so_du_nguoi_gui>=p_so_tien
            then
                insert into giaodich(tai_khoan_id, loai_gd, so_tien, tai_khoan_doi_tac, noi_dung)
                values (p_id_tk_nguoi_gui,'CHUYEN TIEN',p_so_tien,p_id_tk_nguoi_nhan,p_noi_dung);

                so_du_con_lai_nguoi_gui:=so_du_nguoi_gui-p_so_tien;
                update taikhoan
                set so_du=so_du_con_lai_nguoi_gui
                where id=p_id_tk_nguoi_gui;

                so_du_con_lai_nguoi_nhan:=so_du_nguoi_nhan+p_so_tien;
                update taikhoan
                set so_du=so_du_con_lai_nguoi_nhan
                where id=p_id_tk_nguoi_nhan;

        else raise exception 'Giao dich khong hop le (Sai tai khoan, bi khoa hoac khong du so du';
        end if;
    exception
        when others then
            raise notice 'Giao dich that bai';
            raise;
    end;
    $$;

--RUT TIEN
create or replace procedure rut_tien(
    p_ma_tk varchar,
    p_so_tien decimal
)
language plpgsql
as
$$
    declare
        id_nguoi_gui int;
        trang_thai_nguoi_gui varchar(20);
        so_du_nguoi_gui numeric;
    begin
        select id,trang_thai,so_du into id_nguoi_gui,trang_thai_nguoi_gui,so_du_nguoi_gui
        from taikhoan
        where ma_tk=p_ma_tk;

        if
            id_nguoi_gui is not null and
            trang_thai_nguoi_gui='ACTIVE' and
            so_du_nguoi_gui>=p_so_tien
        then
            insert into giaodich(tai_khoan_id,loai_gd,so_tien)
            values (id_nguoi_gui,'RUT TIEN',p_so_tien);

            update taikhoan
            set so_du=so_du_nguoi_gui-p_so_tien
            where ma_tk=p_ma_tk;
        else raise exception 'Giao dich khong hop le';
        end if;

    exception
        when others then
            raise notice 'Giao dich that bai';
            raise;
    end;
    $$;