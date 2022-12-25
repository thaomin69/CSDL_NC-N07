﻿--DOITAC
use QL_HETHONGGIAONHANH
--Đăng kí thông tin đối tác
DROP PROC IF EXISTS USP_DKDOITAC
GO
CREATE PROC USP_DKDOITAC
	@MADT varchar(10) ,
	@TAIKHOAN char(5),
	@MASOTHUE varchar(10),
	@EMAIL varchar(50),
	@TENQUAN nvarchar(50),
	@NGUOIDAIDIEN nvarchar(50),
	@THANHPHO nvarchar(50),
	@QUAN nvarchar(50),
	@LOAIAMTHUC nvarchar(50),
	@DIACHIKINHDOANH nvarchar(50),
	@DIENTHOAI char(10),
	@SOLUONGCUAHANG char(10),
	@SOLUONGDHDUKIEN char(10)
AS
BEGIN 
	IF EXISTS (SELECT * FROM DOITAC WHERE MADT=@MADT OR MASOTHUE= @MASOTHUE)
	BEGIN
		PRINT N'dữ liệu đã tồn tại'
		RETURN 0
	END
	INSERT INTO DOITAC (MADT,TAIKHOAN, MASOTHUE, TENQUAN, NGUOIDAIDIEN,THANHPHO, QUAN, LOAIAMTHUC, DIACHIKINHDOANH, DIENTHOAI, SOLUONGCUAHANG, SOLUONGDHDUKIEN)
	VALUES(@MADT,@TAIKHOAN, @MASOTHUE, @TENQUAN, @NGUOIDAIDIEN,@THANHPHO, @QUAN, @LOAIAMTHUC, @DIACHIKINHDOANH, @DIENTHOAI, @SOLUONGCUAHANG, @SOLUONGDHDUKIEN)
	RETURN 1
END 
GO
--SELECT * FROM DOITAC
--exec USP_DKDOITAC 'DT006','TK006','829','yzh44188@nezi8.com','American BluAs',N'Lê văn tanh',N'Hồ Na minh','',N'ăn vặt',N'100 tr?n hung d?o, hà n?i',093736656,5,8        

--đăng kí để lập hợp đồng
DROP PROC IF EXISTS USP_DT_DKHOPDONG
GO
CREATE PROC USP_DT_DKHOPDONG
	@MASOHOPDONG varchar(10),
	@NGAYLAP datetime,
	@THOIGIANHIEULUC datetime,
	@TAIKHOANNGANHANG varchar(20),
	@PHIHOAHONG float,
	@MADT varchar(10)
	--@ID_KHUVUC char(10)
	--@MASOTHUE varchar(10),
	--@MANV varchar(10),
	--@TINHTRANGDUYET int
AS
BEGIN 
	IF EXISTS (SELECT * FROM HOPDONG WHERE MASOHOPDONG=@MASOHOPDONG	AND @MADT=MADT)
	BEGIN
		PRINT N'Thông tin không phù hợp'
		RETURN -1
	END
	DECLARE @MASOTHUE varchar(10)
	SET @MASOTHUE = (SELECT MASOTHUE FROM DOITAC WHERE MADT = @MADT)
	INSERT INTO HOPDONG --(MASOHOPDONG, NGAYLAP, THOIGIANHIEULUC, TAIKHOANNGANHANG,PHIHOAHONG,MADT,MASOTHUE,MANV,TINHTRANGDUYET)
	VALUES(@MASOHOPDONG, @NGAYLAP, @THOIGIANHIEULUC, @TAIKHOANNGANHANG,@PHIHOAHONG,@MADT,@MASOTHUE,NULL,0)--ID_KHUVUC)
	RETURN 1
END
GO
--SELECT * FROM DOITAC
--SELECT * FROM HOPDONG
--exec USP_DT_DKHOPDONG 'HD006','20220918','20230222','050776527354',150.000,'DT006',NULL,1
--thêm cửa hàng
DROP PROC IF EXISTS USP_THEMCUAHANG
GO
CREATE PROC USP_THEMCUAHANG
	@MACUAHANG varchar(10),
	@MADT varchar(10),
	@TENCUAHANG nvarchar(50),
	@DIACHI nvarchar(50),
	@THOIGIANHOATDONG datetime,
	@TINHTRANGCUAHANG nvarchar(50),
	@ID_KHUVUC char(10)
AS
BEGIN 
	IF EXISTS (SELECT * FROM CUAHANG WHERE @MACUAHANG=MACUAHANG )
		BEGIN
			PRINT N'mã cửa hàng đã tồn tại'
			RETURN -1
		END
		INSERT INTO CUAHANG(MACUAHANG,MADT,TENCUAHANG,DIACHI,THOIGIANHOATDONG,TINHTRANGCUAHANG,ID_KHUVUC)
		VALUES (@MACUAHANG,@MADT,@TENCUAHANG,@DIACHI,@THOIGIANHOATDONG,@TINHTRANGCUAHANG,@ID_KHUVUC)
		RETURN 1
END
GO
--SELECT * FROM CUAHANG
--exec USP_THEMCUAHANG '009','DT001',N'mm',N'23 lê lợi, Quận 10','20220518 00:00:00',''
--Cập nhật thông tin cửa hàng đã đăng kí
DROP PROC IF EXISTS USP_CAPNHATCUAHANG
GO
CREATE PROC USP_CAPNHATCUAHANG
	@MACUAHANG varchar(10),
	@MADT varchar(10),
	--@MASOTHUE varchar(10),
	@TENCUAHANG nvarchar(50),
	@DIACHI nvarchar(50),
	@THOIGIANHOATDONG datetime,
	@TINHTRANGCUAHANG nvarchar(50),
	@ID_KHUVUC char(10)
AS
BEGIN 
	IF NOT EXISTS (SELECT * FROM CUAHANG WHERE @MACUAHANG=MACUAHANG AND @MADT=MADT )
		BEGIN
			PRINT N'dữ liệu không tồn tại'
			RETURN -1
		END
	UPDATE CUAHANG
	SET --MACUAHANG=@MACUAHANG,
		--MADT=@MADT,
		TENCUAHANG=@TENCUAHANG,
		DIACHI=@DIACHI,
		THOIGIANHOATDONG=@THOIGIANHOATDONG,
		TINHTRANGCUAHANG=@TINHTRANGCUAHANG,
		ID_KHUVUC = @ID_KHUVUC
	WHERE MACUAHANG=@MACUAHANG
	RETURN 1
END
GO
SELECT * FROM CUAHANG
--exec USP_CAPNHATCUAHANG '001','DT001','Soul spectrum',N'18 lê lợi, Quận 9','20220518 00:00:00',''

--Thêm món ăn
DROP PROC IF EXISTS USP_THEMMONAN
GO
CREATE PROC USP_THEMMONAN
	@TENMON nvarchar(80),
	@MIEUTAMON nvarchar(50),
	@GIA float,
	@TINHTRANGMONAN nvarchar(50)
AS
BEGIN 
	IF EXISTS (SELECT * FROM MONAN WHERE TENMON=@TENMON)
		BEGIN
			PRINT N'dữ liệu đã tồn tại'
			RETURN -1
		END
	INSERT INTO MONAN (TENMON,MIEUTAMON,GIA,TINHTRANGMONAN)
	VALUES (@TENMON,@MIEUTAMON,@GIA,@TINHTRANGMONAN)
	RETURN 1
END 
GO
--exec USP_THEMMONAN N'Cánh gà','',30.000,N'Đã xử lý'
--SELECT * FROM MONAN
--Xóa món ăn
DROP PROC IF EXISTS USP_XOAMONAN
GO
CREATE PROC USP_XOAMONAN 
	@TENMON nvarchar(80),
	@MIEUTAMON nvarchar(50),
	@GIA float,
	@TINHTRANGMONAN nvarchar(50)
AS
BEGIN 
	IF NOT EXISTS (SELECT TENMON FROM MONAN WHERE TENMON=@TENMON)
		BEGIN 
			PRINT N'Tên món không tồn tại'
			RETURN
		END
	DELETE MONAN WHERE TENMON =@TENMON AND @MIEUTAMON=MIEUTAMON and GIA=@GIA and @TINHTRANGMONAN=TINHTRANGMONAN
END
GO 
--exec USP_XOAMONAN N'Cánh gà','',30.000,N'Đã xử lý'
--Cập nhật món ăn
DROP PROC IF EXISTS USP_CAPNHATMONAN
GO
CREATE PROC USP_CAPNHATMONAN
	@TENMON nvarchar(80),
	@MIEUTAMON nvarchar(50),
	@GIA float,
	@TINHTRANGMONAN nvarchar(50)
AS
BEGIN 
	IF NOT EXISTS (SELECT * FROM MONAN WHERE TENMON=@TENMON)
		BEGIN 
			PRINT N'Tên món không tồn tại'
			RETURN -1
		END

	UPDATE MONAN
	SET MIEUTAMON = @MIEUTAMON,
		GIA =@GIA,
		TINHTRANGMONAN= @TINHTRANGMONAN
	WHERE TENMON = @TENMON 
	return 1
END 
GO
SELECT * FROM MONAN
exec USP_CAPNHATMONAN N'Bún riêu','',10.000,N'Chưa xử lý'


--Xem đơn hàng
DROP PROC IF EXISTS USP_DOITACXEMDONHANG
GO
CREATE PROC USP_DOITACXEMDONHANG
	@MADT varchar(10)
AS
BEGIN TRAN
	SELECT * FROM DONHANG 
COMMIT TRAN
GO
--Cập nhật tình trạng đơn hàng
DROP PROC IF EXISTS USP_DOITACAPNHATDONHANG
GO
CREATE PROC USP_DOITACAPNHATDONHANG
	@MADON varchar(5)
	--@TINHTRANG nvarchar(50)
AS
BEGIN 
	IF NOT EXISTS (SELECT * FROM DONHANG WHERE MADON = @MADON)
	BEGIN
		PRINT @MADON + N' Không tồn tại'
		RETURN -1
	END
	UPDATE DONHANG 
	SET TINHTRANG = N'Đang chuẩn bị'
	WHERE MADON = @MADON AND TINHTRANG = N'Đã xác nhận'
	RETURN 1
END
GO
select * from MONAN
select * from DONHANG
exec USP_DOITACAPNHATDONHANG DH001
--select * from DONHANG
--EXEC USP_DOITACAPNHATDONHANG DH001, N'Đang giao'
--Xem danh sách đơn hàng đã nhận
DROP PROC IF EXISTS USP_DOITAXEMDONHANGDANHAN
GO
CREATE PROC USP_DOITAXEMDONHANGDANHAN
AS
BEGIN
	SELECT * FROM DONHANG 
	WHERE TINHTRANG =N'Đang chuẩn bị'
END
--EXEC USP_DOITAXEMDONHANGDANHAN
--Xem đơn hàng theo ngày tháng năm
GO
DROP PROC IF EXISTS USP_DOITAC_XEMDSDONHANG
GO
CREATE PROC USP_DOITAC_XEMDSDONHANG
	@NGAYLAP DATETIME
AS
BEGIN 
	SELECT * FROM DONHANG WHERE NGAYLAP= @NGAYLAP AND TINHTRANG = N'Đã giao'
END

exec USP_DOITAC_XEMDSDONHANG '2021-06-18'
-- Xem số lượng đơn theo ngày, tháng năm
GO
DROP PROC IF EXISTS USP_DOITAC_XEMSLDONHANG
GO
CREATE PROC USP_DOITAC_XEMSLDONHANG
	@NGAYLAP DATETIME
AS
BEGIN 
	SELECT COUNT (MADON) AS 'Số lượng đơn hàng trong ngày' FROM DONHANG WHERE NGAYLAP=@NGAYLAP AND TINHTRANG = N'Đã giao'
END
--exec USP_DOITAC_XEMSLDONHANG '2021-05-09 00:00:00.000'
--theo dõi doanh thu theo ngày
GO
DROP PROC IF EXISTS USP_DOITAC_DOANHTHU_NGAY
GO
CREATE PROC USP_DOITAC_DOANHTHU_NGAY
	@NGAYLAP DATETIME
AS
BEGIN 
	
	IF NOT EXISTS (SELECT * FROM DONHANG WHERE NGAYLAP=@NGAYLAP)
	BEGIN	
		PRINT N'Ngày lập không hợp lệ!!'
		--ROLLBACK TRAN
		RETURN
	END
	DECLARE @TONGDOANHTHU FLOAT
	SET @TONGDOANHTHU = (SELECT SUM (TONGTIEN) FROM DONHANG WHERE @NGAYLAP=NGAYLAP AND TINHTRANG = N'Đã giao' )
	SELECT @TONGDOANHTHU
END
--exec USP_DOITAC_DOANHTHU_NGAY '2022-04-07 00:00:00.000'
--XEM DANH SÁCH ĐƠN HÀNG ĐÃ HỦY
--DROP PROC IF EXISTS USP_DOITAXEMDONHANGDAHUY
--GO
--CREATE PROC USP_DOITAXEMDONHANGDAHUY
--AS
--BEGIN
--	SELECT * FROM DONHANG 
--	WHERE TINHTRANG =N'Đã hủy'
--END
SELECT * FROM DONHANG
--XEM PHẢN HỒI CỦA KHÁCH HÀNG
GO
DROP PROC IF EXISTS USP_XEMPHANHOI
GO
CREATE PROC USP_XEMPHANHOI
AS
BEGIN
	SELECT * FROM PHANHOI 
END

--SELECT * FROM HOPDONG
--exec USP_DKHOPDONG 'HD006','20220918 00:00:00','20230222 00:00:00','050776527354',150.000,'DT006','811','241782293',1

GO
DROP PROC IF EXISTS USP_DKHOPDONG
GO
CREATE PROC USP_DKHOPDONG
	@MASOHOPDONG varchar(10),
	@NGAYLAP datetime,
	@THOIGIANHIEULUC datetime,
	@TAIKHOANNGANHANG varchar(20),
	@PHIHOAHONG float,
	@MADT varchar(10),
	@MASOTHUE varchar(10),
	@MANV varchar(10),
	@TINHTRANGDUYET int
AS
BEGIN 
	IF EXISTS (SELECT * FROM HOPDONG WHERE MASOHOPDONG=@MASOHOPDONG	OR @MADT=MADT OR @MASOTHUE =MASOTHUE)
	BEGIN
		PRINT N'Thông tin không phù hợp'
		RETURN -1
	END
	INSERT INTO HOPDONG (MASOHOPDONG, NGAYLAP, THOIGIANHIEULUC, TAIKHOANNGANHANG,PHIHOAHONG,MADT,MASOTHUE,MANV,TINHTRANGDUYET)
	VALUES(@MASOHOPDONG, @NGAYLAP, @THOIGIANHIEULUC, @TAIKHOANNGANHANG,@PHIHOAHONG,@MADT,@MASOTHUE,@MANV,@TINHTRANGDUYET)
	RETURN 1
END
GO







--KHACH HANG
-- 1 được 0 lỗi
--kiểm tra tên đăng nhập
GO
DROP PROC IF EXISTS USP_CHECKUSERNAME
GO
CREATE PROC USP_CHECKUSERNAME
	@username VARCHAR(20)
AS
BEGIN
	IF EXISTS (SELECT * FROM TAIKHOAN WHERE USERNAME = @username)
	RETURN 1
	ELSE RETURN 0
END
GO

-- DROP PROC SP_KTMatKhau
-- Kiểm tra mật khẩu
GO
DROP PROC IF EXISTS USP_CHECKPASS
GO
CREATE PROC USP_CHECKPASS
	@username VARCHAR(20),
	@pass  VARCHAR(20)
AS
BEGIN	
	-- kiểm tra	
	IF EXISTS (SELECT * FROM TAIKHOAN WHERE  USERNAME = @username AND PASS = @pass)
	RETURN 1
	ELSE RETURN 0
END


--VÔ DANH
--đăng nhập
GO
DROP PROC IF EXISTS USP_LOGIN
GO
CREATE PROC USP_LOGIN
	@USERNAME VARCHAR(20),
	@PASS VARCHAR(20),
	@ID CHAR(5) OUTPUT,
	@LOAITK INT OUTPUT
AS
BEGIN	
	SET @ID = 'NULL'

	-- lấy mã tài khoản		
	SET @ID = (SELECT ID
				FROM TAIKHOAN
				WHERE USERNAME = @USERNAME
				AND PASS = @PASS)

	-- lấy loại tài khoản		
	SET @LOAITK = (SELECT LOAITK
				FROM TAIKHOAN
				WHERE USERNAME = @USERNAME
				AND PASS = @PASS)
	--print @id + @loaitk
	-- xử lí đăng nhập
	if (@ID != 'NULL')
	BEGIN
		PRINT N'Đăng nhập thành công'
		RETURN 1
	END
	ELSE RETURN 0	
END
GO

--SELECT *
--				FROM TAIKHOAN

--				declare @tong varchar(10)
--				declare @t int
--EXEC USP_LOGIN 'kh1','123456789',@tong,@t
 

--thêm tài khoản khách hàng
GO
DROP PROC IF EXISTS USP_TAOTK_KHACHHANG
GO
CREATE PROC USP_TAOTK_KHACHHANG
	@id VARCHAR(10),
	@username VARCHAR(20) ,
	@pass VARCHAR(20) ,
	@loaitk INT,
	@makhach VARCHAR(10),
	@tenkhach nvarchar(30),
	@sdt CHAR(10) ,
	@email VARCHAR(30),
	@diachi nvarchar(300)
AS
BEGIN	
	--Kiểm tra mã KH
	IF EXISTS (SELECT MAKHACH FROM KHACHHANG WHERE MAKHACH = @makhach)
	BEGIN
		PRINT N'MÃ KH ĐÃ TỒN TẠI'
		RETURN 0
	END

	--Kiểm tra ID
	IF EXISTS (SELECT ID FROM TAIKHOAN WHERE ID = @ID)
	BEGIN
		PRINT N'ID ĐÃ TỒN TẠI'
		RETURN -1
	END
	
	-- xử lí thêm bảng TAIKHOAN
	INSERT INTO TAIKHOAN
	VALUES
	(@id,@username,@pass,@loaitk)

	-- xử lí thêm bảng KHACHHANG
	INSERT INTO KHACHHANG
	VALUES
	(@makhach,@id,@tenkhach,@sdt,@diachi,@email)

	RETURN 1

END

--PHÂN HỆ KHÁCH HÀNG

--Khách hàng xem danh sách món ăn
GO
DROP PROC IF EXISTS USP_KH_XEMDSMON
GO
CREATE PROC USP_KH_XEMDSMON
AS
BEGIN
	SELECT * FROM MONAN
END
GO


--Khách hàng tìm món ăn theo tên
GO
DROP PROC IF EXISTS USP_KH_TIMMONAN 
GO
CREATE PROC USP_KH_TIMMONAN
	@tenmon nvarchar(80)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM MONAN WHERE TENMON = @tenmon)
	BEGIN
		PRINT @tenmon + N' Không tồn tại'
		RETURN
	END
	SELECT TD.MADT, TD.MACUAHANG, TD.TENMON, MA.GIA, SOLUONGTON, MIEUTAMON, TINHTRANGMONAN
	FROM THUCDON TD
	JOIN MONAN MA ON TD.TENMON = MA.TENMON
	WHERE TD.TENMON LIKE N'%'+ @tenmon + '%'
	--WHERE TENMON LIKE @tenmon
END

--exec USP_KH_TIMMONAN N'cHÁO gà'


--Khách hàng xem danh sách đối tác
GO
DROP PROC IF EXISTS USP_KH_XEMDSDOITAC 
GO
CREATE PROC USP_KH_XEMDSDOITAC
AS
BEGIN
	SELECT MADT, TENQUAN, THANHPHO, QUAN, LOAIAMTHUC, DIENTHOAI, EMAIL, SOLUONGCUAHANG FROM DOITAC
END


--Khách hàng xem danh sách cửa hàng của đối tác.
GO
DROP PROC IF EXISTS USP_KH_XEMDSCUAHANGCUADT 
GO
CREATE PROC USP_KH_XEMDSCUAHANGCUADT
	@madt varchar(10)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM DOITAC WHERE MADT = @madt)
	BEGIN
		PRINT @madt + N' Không tồn tại'
		RETURN
	END

	 SELECT MADT, MACUAHANG, TENCUAHANG, DIACHI, THOIGIANHOATDONG, TINHTRANGCUAHANG FROM CUAHANG  WHERE MADT = @madt
END

GO
DROP PROC IF EXISTS USP_KH_XEMTHUCDON
GO
CREATE PROC USP_KH_XEMTHUCDON
	@madt varchar(10),
	@mach varchar(10)
AS
BEGIN
	 SELECT MONAN.TENMON, GIA, SOLUONGTON, MIEUTAMON , TINHTRANGMONAN FROM THUCDON JOIN MONAN ON MONAN.TENMON = THUCDON.TENMON  
	 WHERE MADT = @madt AND MACUAHANG = @mach 
END


--Khách hàng đặt hàng

GO
DROP PROC IF EXISTS USP_KH_DATHANG
GO
CREATE PROC USP_KH_DATHANG
	@mach varchar(10),
	@madon varchar(10),
	@ngaymua datetime,
	@ngaygiao datetime,
	@makh varchar(10),
	@hinhthuctt nvarchar(50),
	@diachigiaohang nvarchar(300),
	@phisp float,
	@phivc float,
	@tongtien float

AS
BEGIN 
	IF EXISTS (SELECT * FROM DONHANG WHERE MADON = @madon)
	BEGIN
		PRINT N'MÃ ĐƠN HÀNG ĐÃ TỒN TẠI'
		RETURN 0
	END

	--Kiểm tra mã KH	
	IF (@MAKH != NULL)
		IF (@MAKH != NULL AND NOT EXISTS (SELECT MAKHACH FROM KHACHHANG WHERE MAKHACH = @MAKH))
		BEGIN
			PRINT N'MÃ KHÁCH KHÔNG TỒN TẠI'
			RETURN -1
		END
	DECLARE @IDKV VARCHAR(10)
	SET @IDKV = (SELECT ID_KHUVUC FROM CUAHANG WHERE MACUAHANG=@mach)
	INSERT INTO DONHANG VALUES(@madon,@ngaymua,@hinhthuctt,@diachigiaohang,@phisp,@phivc,@tongtien,N'Chờ xác nhận',@ngaygiao,@makh,NULL,@IDKV)
	RETURN 1
END
GO

--Thêm sản phẩm vào chi tiết hóa đơn
GO
DROP PROC IF EXISTS USP_KH_DATHANG_CTDH
GO
CREATE PROC USP_KH_DATHANG_CTDH
	@tenmon nvarchar(80),
	@madon varchar(10),
	@soluong int,
	@madt varchar(10),
	@mach varchar(10),
	@thanhtien float
AS
BEGIN 

	IF NOT EXISTS (SELECT TENMON FROM MONAN WHERE TENMON LIKE N'%'+ @tenmon + '%')
	BEGIN
		PRINT N'MÓN ĂN KHÔNG TỒN TẠI'
		RETURN 0
	END

	IF NOT EXISTS (SELECT MADON FROM DONHANG WHERE MADON = @madon)
	BEGIN
		PRINT N'MÃ ĐƠN HÀNG KHÔNG TỒN TẠI'
		RETURN -1
	END

	
	INSERT INTO CT_DONHANG
	VALUES (@madon,@mach, @madt,@tenmon,@soluong,@thanhtien)

	RETURN 1
END
GO


--Khách hàng xác nhận đơn
----CHỖ NÀY KO CHẤC********************************
DROP PROC IF EXISTS USP_KH_XACNHANDON
GO
CREATE PROC USP_KH_XACNHANDON
	@madon varchar(10)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM DONHANG WHERE MADON = @madon)
	BEGIN
		PRINT @madon + N' Không tồn tại'
		RETURN -1
	END

	UPDATE DONHANG
	SET TINHTRANG =  N'Đã xác nhận'
	WHERE MADON = @madon
	RETURN 1
END

--GO

--khách hàng hủy đơn
GO
DROP PROC IF EXISTS USP_KH_HUYDON
GO
CREATE PROC USP_KH_HUYDON
	@madon varchar(5)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM DONHANG WHERE MADON = @madon)
	BEGIN
		PRINT @madon + N' Không tồn tại'
		RETURN -1
	END
	
	DELETE 
	FROM CT_DONHANG
	WHERE MADON = @madon

	DELETE  
	FROM DONHANG
	WHERE MADON = @madon

	RETURN 1
END


--khách hàng theo dõi đơn hàng
GO
DROP PROC IF EXISTS USP_KH_THEODOIDH 
GO
CREATE PROC USP_KH_THEODOIDH
	@makhach varchar(10)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM DONHANG WHERE MAKHACH = @makhach)
	BEGIN
		PRINT @makhach + N' Không Có Đơn Hàng'
		RETURN
	END

	SELECT MADON, NGAYLAP, HINHTHUCTT, DIACHIGIAO, PHISP, PHIVC, TONGTIEN, TINHTRANG, NGAYGIAO, TAIXE FROM DONHANG
	WHERE  MAKHACH = @makhach
END
GO

--khách hàng xem chi tiết đơn hàng
GO
DROP PROC IF EXISTS USP_KH_XEMCTDH
GO
CREATE PROC USP_KH_XEMCTDH
	@madon VARCHAR(15)	
AS
BEGIN	
	--Kiểm tra mã DH
	IF NOT EXISTS (SELECT MADON FROM DONHANG WHERE MADON = @madon)
	BEGIN
		PRINT N'MÃ ĐƠN KHÔNG TỒN TẠI'
		RETURN 0
	END

	-- lấy thông tin 
	SELECT CTDH.MADON, CTDH.MADT, CTDH.MACUAHANG,CTDH.TENMON, MA.GIA, CTDH.SOLUONG, CTDH.THANHTIEN 
	FROM CT_DONHANG CTDH JOIN MONAN MA ON CTDH.TENMON = MA.TENMON
	WHERE CTDH.MADON = @madon
	
	RETURN 1
END
GO
