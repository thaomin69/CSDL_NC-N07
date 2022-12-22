CREATE DATABASE QL_HETHONGGIAONHANH
GO
USE QL_HETHONGGIAONHANH
GO

CREATE TABLE TAIKHOAN (
   ID char(5) not null,
   USERNAME varchar(20) not null,
   PASS varchar(20) not null,
   LOAITK int null,
   PRIMARY KEY (ID)
)

CREATE TABLE DOITAC 
(
	MADT varchar(10) NOT NULL,
	TAIKHOAN char(5) NOT NULL,
	MASOTHUE varchar(10) NOT NULL,
	EMAIL varchar(50),
	TENQUAN nvarchar(50),
	NGUOIDAIDIEN nvarchar(50),
	THANHPHO nvarchar(50),
	QUAN nvarchar(50),
	LOAIAMTHUC nvarchar(50),
	DIACHIKINHDOANH nvarchar(50),
	DIENTHOAI char(10),
	SOLUONGCUAHANG char(10),
	SOLUONGDHDUKIEN char(10)
	PRIMARY KEY (MADT,MASOTHUE)
)
CREATE TABLE TUYCHONMON
(
	TENMON nvarchar(80) NOT NULL,
	TUYCHON nvarchar(50) NOT NULL
	PRIMARY KEY (TENMON, TUYCHON)
)
CREATE TABLE MONAN
(
	TENMON nvarchar(80) NOT NULL,
	MIEUTAMON nvarchar(50),
	GIA float,
	TINHTRANGMONAN nvarchar(50)
	PRIMARY KEY (TENMON)
)
CREATE TABLE THUCDON
(
	MACUAHANG varchar(10) NOT NULL,
	MADT varchar(10) NOT NULL,
	MASOTHUE varchar(10) NOT NULL,
	TENMON nvarchar(80) NOT NULL,
	SOLUONGTON int,
	PRIMARY KEY (MACUAHANG,MADT,MASOTHUE,TENMON)
)
CREATE TABLE CUAHANG
(
	MACUAHANG varchar(10) NOT NULL,
	MADT varchar(10),
	MASOTHUE varchar(10) NOT NULL,
	TENCUAHANG nvarchar(50),
	DIACHI nvarchar(50),
	THOIGIANHOATDONG datetime,
	TINHTRANGCUAHANG nvarchar(50),
	PRIMARY KEY (MACUAHANG,MADT, MASOTHUE)
)
CREATE TABLE HOPDONG
(
	MASOHOPDONG varchar(10) NOT NULL,
	NGAYLAP datetime,
	THOIGIANHIEULUC datetime,
	TAIKHOANNGANHANG varchar(20),
	PHIHOAHONG float,
	MADT varchar(10),
	MASOTHUE varchar(10),
	MANV varchar(10),
	TINHTRANGDUYET int
	PRIMARY KEY (MASOHOPDONG)
)
create table KHACHHANG
(
    MAKHACH varchar(10) NOT NULL,
	TAIKHOAN char(5) NOT NULL,
    TENKHACH nvarchar(30),
    DIENTHOAI char(10),
    DIACHI nvarchar(300),
    EMAIL varchar(30),
    PRIMARY KEY (MAKHACH)
)

create table DONHANG
(
    MADON varchar(10) NOT NULL,
    NGAYLAP datetime,
    HINHTHUCTT nvarchar(50),
    DIACHIGIAO nvarchar(300),
    PHISP float,
    PHIVC float,
    TONGTIEN float,
	TINHTRANG nvarchar(50) NOT NULL,
	NGAYGIAO datetime,
    MAKHACH varchar(10),
    TAIXE varchar(12),
    PRIMARY KEY (MADON)
)

create table CT_DONHANG(
    MADON varchar(10) NOT NULL,
    TENMON nvarchar(80) NOT NULL,
	SOLUONG INT,
	THANHTIEN float,
    PRIMARY KEY (MADON,TENMON)
)
CREATE TABLE NHANVIEN
(
    CMND varchar(10) NOT NULL,
	TAIKHOAN char(5) NOT NULL,
    HOTEN nvarchar(30),
    DIENTHOAI char(10),
    DIACHI nvarchar(30),
    EMAIL varchar(20),
    PRIMARY KEY (CMND)
)
CREATE TABLE TAIXE
(
    CMND varchar(12) NOT NULL,
	TAIKHOAN char(5) NOT NULL,
    HOTEN nvarchar(30),
    DIENTHOAI char(10),
    DIACHI nvarchar(30),
    EMAIL varchar(20),
    BIENSOXE varchar(5),
    TAIKHOANNGANHANG char(15),
    KHUVUCHOATDONG nvarchar(20),
    PHITHECHAN float,
    PRIMARY KEY (CMND)
)
CREATE TABLE PHANHOI
(
	TENMON nvarchar(80) NOT NULL,
	MAKHACH varchar(10) NOT NULL,
	DANHGIA CHAR(7), -- LIKE OR DISLIKE
	BINHLUAN NVARCHAR(100)
	PRIMARY KEY(TENMON,MAKHACH)
)

ALTER TABLE KHACHHANG
ADD CONSTRAINT FK_KHACHHANG_TAIKHOAN 
FOREIGN KEY (TAIKHOAN)
REFERENCES TAIKHOAN (ID)

ALTER TABLE DOITAC
ADD CONSTRAINT FK_DOITAC_TAIKHOAN 
FOREIGN KEY (TAIKHOAN)
REFERENCES TAIKHOAN (ID)

ALTER TABLE NHANVIEN
ADD CONSTRAINT FK_NHANVIEN_TAIKHOAN 
FOREIGN KEY (TAIKHOAN)
REFERENCES TAIKHOAN (ID)

ALTER TABLE TAIXE
ADD CONSTRAINT FK_TAIXE_TAIKHOAN 
FOREIGN KEY (TAIKHOAN)
REFERENCES TAIKHOAN (ID)

ALTER TABLE DONHANG ADD CHECK (TINHTRANG IN (N'Chờ xác nhận',N'Đang chuẩn bị', N'Chờ lấy hàng', N'Đang giao', N'Đã giao'))

ALTER TABLE DONHANG
ADD CONSTRAINT FK_DONHANG_KHACHHANG
FOREIGN KEY (MAKHACH)
REFERENCES KHACHHANG(MAKHACH)

ALTER TABLE DONHANG
ADD CONSTRAINT FK_DONHANG_TAIXE
FOREIGN KEY (TAIXE)
REFERENCES TAIXE(CMND)

ALTER TABLE CT_DONHANG
ADD CONSTRAINT FK_CT_DONHANG_DONHANG
FOREIGN KEY (MADON)
REFERENCES DONHANG(MADON)

ALTER TABLE CT_DONHANG
ADD CONSTRAINT FK_CT_DONHANG_MONAN
FOREIGN KEY (TENMON)
REFERENCES MONAN(TENMON) ON DELETE CASCADE

ALTER TABLE CUAHANG
ADD CONSTRAINT FK_CUAHANG_DOITAC
FOREIGN KEY (MADT,MASOTHUE)
REFERENCES DOITAC(MADT,MASOTHUE)

ALTER TABLE HOPDONG
ADD CONSTRAINT FK_HOPDONG_DOITAC
FOREIGN KEY (MADT,MASOTHUE)
REFERENCES DOITAC(MADT,MASOTHUE)

ALTER TABLE THUCDON
ADD CONSTRAINT FK_THUCDON_CUAHANG
FOREIGN KEY (MACUAHANG,MADT,MASOTHUE)
REFERENCES CUAHANG(MACUAHANG,MADT,MASOTHUE)

ALTER TABLE THUCDON
ADD CONSTRAINT FK_THUCDON_MONAN
FOREIGN KEY (TENMON)
REFERENCES MONAN(TENMON) ON DELETE CASCADE

ALTER TABLE TUYCHONMON
ADD CONSTRAINT FK_TUYCHONMON_MONAN
FOREIGN KEY (TENMON)
REFERENCES MONAN(TENMON)

ALTER TABLE HOPDONG
ADD CONSTRAINT FK_HOPDONG_NHANVIEN
FOREIGN KEY (MANV)
REFERENCES NHANVIEN(CMND) ON DELETE CASCADE

ALTER TABLE PHANHOI 
ADD CONSTRAINT FK_MONAN_PHANHOI 
FOREIGN KEY (TENMON) 
REFERENCES MONAN(TENMON)

ALTER TABLE PHANHOI 
ADD CONSTRAINT FK_KHACHHANG_PHANHOI 
FOREIGN KEY (MAKHACH) 
REFERENCES KHACHHANG(MAKHACH)

ALTER TABLE PHANHOI ADD CHECK (DANHGIA = 'LIKE' OR DANHGIA = 'DISLIKE')

--trigger
--Tổng tiền hóa đơn là tổng tiền các chi tiết đơn hàng
go
create trigger trigger_TongTien		
on CT_DONHANG
for insert, delete, update	as
begin

	update DONHANG 
	set TongTien = PHIVC + PHISP + (select sum(ThanhTien) from CT_DONHANG
	where DONHANG.MADON= CT_DONHANG.MADON)
	where 
	exists (select * from deleted d	 where d.MADON = DONHANG.MADON) or
	exists (select * from inserted i where i.MADON = DONHANG.MADON) 
end
go

go
--Thành tiền trong chi tiết hóa đơn là giá * số lượng món
create trigger trigger_ThanhTien	
on CT_DONHANG
for insert, update, delete	as
begin
if update (SoLuong)
	if exists (select SoLuong from CT_DONHANG where SoLuong < 0) 
	begin
		raiserror (N'Số lượng sản phẩm không hợp lệ', 10, 1)
		rollback transaction
	end

	update CT_DONHANG
	set THANHTIEN = ctdh.SoLuong * (select Gia from MONAN where MONAN.TENMON = ctdh.TENMON)
	from inserted i, MONAN ma, CT_DONHANG ctdh
	where 
		ma.TENMON = i.TENMON and
		ma.TENMON = ctdh.TENMON
end

