﻿USE QL_HETHONGGIAONHANH

--TỔNG TIỀN HÓA ĐƠN LÀ TỔNG TIỀN CÁC CHI TIẾT ĐƠN HÀNG
GO 
DROP TRIGGER IF EXISTS TRIGGER_TONGTIEN
GO 
CREATE TRIGGER TRIGGER_TONGTIEN		
ON CT_DONHANG
FOR INSERT, DELETE, UPDATE	AS
BEGIN

	UPDATE DONHANG 
	SET TONGTIEN = PHIVC + PHISP + (SELECT SUM(THANHTIEN) FROM CT_DONHANG
	WHERE DONHANG.MADON= CT_DONHANG.MADON)
	WHERE 
	EXISTS (SELECT * FROM DELETED D	 WHERE D.MADON = DONHANG.MADON) OR
	EXISTS (SELECT * FROM INSERTED I WHERE I.MADON = DONHANG.MADON) 
END
GO


--THÀNH TIỀN TRONG CHI TIẾT HÓA ĐƠN LÀ GIÁ * SỐ LƯỢNG MÓN
GO
DROP TRIGGER IF EXISTS TRIGGER_THANHTIEN
GO
CREATE TRIGGER TRIGGER_THANHTIEN	
ON CT_DONHANG
FOR INSERT, UPDATE, DELETE	AS
BEGIN
IF UPDATE (SOLUONG)
	IF EXISTS (SELECT SOLUONG FROM CT_DONHANG WHERE SOLUONG < 0) 
	BEGIN
		RAISERROR (N'SỐ LƯỢNG SẢN PHẨM KHÔNG HỢP LỆ', 10, 1)
		ROLLBACK TRANSACTION
	END

	UPDATE CT_DONHANG
	SET THANHTIEN = CTDH.SOLUONG * (SELECT GIA FROM MONAN WHERE MONAN.TENMON = CTDH.TENMON)
	FROM INSERTED I, MONAN MA, CT_DONHANG CTDH
	WHERE 
		MA.TENMON = I.TENMON AND
		MA.TENMON = CTDH.TENMON
END

--KH ĐẶT HÀNG THÌ UPDATE TĂNG SỐ LƯỢNG TỒN TRONG THỰC ĐƠN
GO 
DROP TRIGGER IF EXISTS KH_DATHANG_UPDATELUONGTON
GO
CREATE TRIGGER KH_DATHANG_UPDATELUONGTON
ON CT_DONHANG
FOR INSERT
AS
BEGIN
    -- UPDATE SO LUONG TON
    UPDATE THUCDON
    SET SOLUONGTON = SOLUONGTON - I.SOLUONG
    FROM INSERTED I, CT_DONHANG CTDH, MONAN MA, THUCDON TD
	WHERE CTDH.MADT = TD.MADT AND CTDH.MACUAHANG = TD.MACUAHANG AND CTDH.TENMON=TD.TENMON
	AND I.MADT = TD.MADT AND TD.MACUAHANG = I.MACUAHANG AND I.TENMON=TD.TENMON
		
END 
  

--KH HỦY HÀNG THÌ UPDATE TĂNG SỐ LƯỢNG TỒN TRONG THỰC ĐƠN
GO 
DROP TRIGGER  IF EXISTS KH_HUYDON_UPDATELUONGTON
GO
CREATE TRIGGER KH_HUYDON_UPDATELUONGTON
ON CT_DONHANG
FOR DELETE
AS
BEGIN	
	UPDATE THUCDON
	SET SOLUONGTON = SOLUONGTON + D.SOLUONG
    FROM THUCDON TD  JOIN DELETED D ON D.MADT = TD.MADT AND TD.MACUAHANG = D.MACUAHANG AND D.TENMON=TD.TENMON
END 
