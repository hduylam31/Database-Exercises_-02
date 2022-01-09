﻿use HoaYeuThuongIndex
go
--Xem danh sách sản phẩm cửa hàng
CREATE PROCEDURE XEM_DS_SP
(
	@TENCH NVARCHAR(50)
)
AS 
	BEGIN TRAN
		SELECT SP.TENSP,SP.GIABAN,SP.CHUDE FROM SANPHAM SP, SANPHAM_CUAHANG SPCH, CUAHANG CH WHERE SP.MASP = SPCH.MASP and SPCH.MACH = CH.MACH and CH.TENCH = @TENCH
	COMMIT TRAN
GO

--Tìm kiếm sản phẩm của cửa hàng
CREATE PROCEDURE TIM_SP
(
	@TENCH NVARCHAR(50),
	@TENSP NVARCHAR(50)
)
AS 
	BEGIN TRAN
		SELECT SP.TENSP,SP.GIABAN,SP.CHUDE FROM SANPHAM SP, SANPHAM_CUAHANG SPCH, CUAHANG CH WHERE SP.MASP = SPCH.MASP and SPCH.MACH = CH.MACH and CH.TENCH = @TENCH and SP.TENSP = @TENSP
	COMMIT TRAN
GO
--So sánh doanh thu của cửa hàng
CREATE PROCEDURE SOSANHDOANHTHU_CH
(
	@TENCH NVARCHAR(50),
	@THANG1 int,
	@THANG2 int,
	@NAM1 int,
	@NAM2 int
)
AS 
	BEGIN TRAN
		SELECT MONTH(DH.NGAYDAT) AS THANG,YEAR(DH.NGAYDAT)AS NAM ,SUM(TONGTIENTHUC) AS DOANHTHU 
		FROM DONDATHANG DH, CUAHANG CH,SANPHAM_CUAHANG SPCH, CT_DONDATHANG CTDH, SANPHAM SP
		WHERE SPCH.MACH = CH.MACH and SPCH.MASP = SP.MASP and CTDH.MASP = SP.MASP and DH.MADH = CTDH.MADH
		and CH.TENCH = @TENCH and MONTH(DH.NGAYDAT) = @THANG1 and YEAR(DH.NGAYDAT) = @NAM1
		GROUP BY MONTH(DH.NGAYDAT),YEAR(DH.NGAYDAT)
		UNION
		SELECT MONTH(DH.NGAYDAT) AS THANG,YEAR(DH.NGAYDAT)AS NAM ,SUM(TONGTIENTHUC) AS DOANHTHU 
		FROM DONDATHANG DH, CUAHANG CH,SANPHAM_CUAHANG SPCH, CT_DONDATHANG CTDH, SANPHAM SP
		WHERE SPCH.MACH = CH.MACH and SPCH.MASP = SP.MASP and CTDH.MASP = SP.MASP and DH.MADH = CTDH.MADH
		and CH.TENCH = @TENCH and MONTH(DH.NGAYDAT) = @THANG2 and YEAR(DH.NGAYDAT) = @NAM2
		GROUP BY MONTH(DH.NGAYDAT),YEAR(DH.NGAYDAT)
		
	COMMIT TRAN
GO

--Thêm sản phẩm mới
CREATE PROCEDURE THEMSANPHAM
(
	@TENSP NVARCHAR(50),
	@CHUDE NVARCHAR(50),
	@GIABAN MONEY,
	@MALOAI int
)
AS 
	BEGIN TRAN
	IF EXISTS (SELECT * FROM SANPHAM WHERE TenSP = @TENSP)
	BEGIN
		PRINT N'Sản phẩm đã tồn tại'
		ROLLBACK TRAN
		RETURN
	END
	ELSE
	BEGIN
		INSERT INTO SANPHAM(TENSP, CHUDE, GIABAN, MALOAI) VALUES (@TENSP,@CHUDE,@GIABAN,@MALOAI)
	END
	COMMIT
GO
--Sửa sản phẩm
CREATE PROCEDURE SUASANPHAM
(
	@TENSP NVARCHAR(50),
	@CHUDE NVARCHAR(50),
	@GIABAN MONEY,
	@MALOAI int
)
AS 
	BEGIN TRAN
	IF EXISTS (SELECT * FROM SANPHAM WHERE TenSP = @TENSP)
	BEGIN
		UPDATE SANPHAM SET CHUDE = @CHUDE, GIABAN = @GIABAN , MALOAI = @MALOAI WHERE TENSP = @TENSP	
	END
	ELSE
	BEGIN
		PRINT N'Sản phẩm không tồn tại'
		ROLLBACK TRAN
		RETURN
	END
	COMMIT
GO
--Xóa sản phẩm
CREATE PROCEDURE XOASANPHAM
(
	@TENSP NVARCHAR(50)
)
AS 
	BEGIN TRAN
	IF EXISTS (SELECT * FROM SANPHAM WHERE TenSP = @TENSP)
	BEGIN
		DELETE FROM SANPHAM WHERE TENSP = @TENSP	
	END
	ELSE
	BEGIN
		PRINT N'Sản phẩm không tồn tại'
		ROLLBACK TRAN
		RETURN
	END
	COMMIT
GO


--Lưu vết giá sản phẩm
CREATE PROCEDURE LUUVETGIA
(
	@TENSP NVARCHAR(50)
)
AS 
	BEGIN TRAN
	IF EXISTS(SELECT DISTINCT SP.TENSP
	    FROM SANPHAM SP, CT_DONDATHANG CTDH
	    WHERE SP.MASP = CTDH.MASP and SP.TENSP = @TENSP)
	BEGIN
		SELECT SP.TENSP, CTDH.DONGIA 
	    FROM SANPHAM SP, CT_DONDATHANG CTDH
	    WHERE SP.MASP = CTDH.MASP and SP.TENSP = @TENSP
	END
	ELSE
	BEGIN
		PRINT N'Sản phẩm không tồn tại'
		ROLLBACK TRAN
		RETURN
	END
	COMMIT TRAN
GO
DROP PROCEDURE LUUVETGIA
 
--Lich su nhap hang
CREATE PROCEDURE LICHSUNHAP
(
	@TENCH NVARCHAR(50),
	@MONTH int,
	@YEAR int
)
AS 
	BEGIN TRAN
		SELECT DISTINCT SP.TENSP, CTGH.NGAYGIAO, CTGH.SLGIAO
	     FROM CUAHANG CH, DONNHAPHANG DNH, DONGIAOHANG DGH, CT_GIAOHANG CTGH, CT_DONNHAP CTDN, SANPHAM SP
	     WHERE CH.MACH = DNH.MACH and CTGH.MADGH = DGH.MADGH and DGH.MADNH = DNH.MADNH and CH.TENCH = @TENCH  and month(CTGH.NGAYGIAO) = @MONTH and year(CTGH.NGAYGIAO) = @YEAR 
	COMMIT
GO

--Lich su giao hang
CREATE PROCEDURE LICHSUGIAO
(
	@TENCH NVARCHAR(50),
	@MONTH int,
	@YEAR int
)
AS 
	BEGIN TRAN
		SELECT SP.TENSP, CTDH.SOLUONG, DH.NGAYGIAO
	     FROM CUAHANG CH, SANPHAM_CUAHANG SPCH, SANPHAM SP, CT_DONDATHANG CTDH, DONDATHANG DH    
		 WHERE SPCH.MACH = CH.MACH and SPCH.MASP = SP.MASP and CTDH.MASP = SP.MASP and DH.MADH = CTDH.MADH and CH.TENCH = @TENCH and month(DH.NGAYGIAO) = @MONTH and year(DH.NGAYGIAO) = @YEAR
	COMMIT
GO

--DiemDanh
CREATE PROCEDURE DIEMDANH
(
	@MANV INT, @NGAY DATE
)
AS 
	BEGIN TRAN
		INSERT INTO DIEMDANH VALUES(@MANV, @NGAY)
	COMMIT
GO
---Xem lich su luong thuong cua nhan vien
CREATE PROCEDURE XEMLUONGTHUONG

AS 
	BEGIN TRAN
		SELECT * FROM LUONGTHUONG GROUP BY MANV
	COMMIT
GO

--Xem so luong ton
create proc sp_XemSLTonSP
	@MACH int
as
begin tran
	Select * from SANPHAM_CUAHANG where MACH = @MACH
commit tran

go

--Xem CT nhap hang
create proc sp_XemCTNhapHang
	@MADNH int
as
begin tran
	Select * from CT_DONNHAP where MADNH = @MADNH
commit tran

go

--Xem CT giao hang
create proc sp_XemCTGiaoHang
	@MADGH int
as
begin tran
	Select * from CT_GIAOHANG where MADGH = @MADGH
commit tran

go






EXECUTE sp_addrole 'KhachHang_role'

GRANT SELECT ON CUAHANG TO KhachHang_role;
GRANT SELECT ON SANPHAM TO KhachHang_role;
GRANT SELECT ON SANPHAM_CUAHANG TO KhachHang_role;
GRANT SELECT, INSERT ON DONDATHANG TO KhachHang_role
GRANT SELECT, INSERT ON CT_DONDATHANG TO KhachHang_role
GO

CREATE PROCEDURE TimTenSanPham_CuaHang @MaCuaHang int, @TenSanPham nvarchar(30)
AS
BEGIN TRAN
	BEGIN TRY
	IF NOT EXISTS (SELECT * FROM SANPHAM_CUAHANG JOIN SANPHAM ON SANPHAM_CUAHANG.MASP = SANPHAM.MASP
							WHERE TENSP LIKE N'% '+@TenSanPham+'%')
	BEGIN
		PRINT N'Không tồn tại sản phẩm'
		ROLLBACK TRAN 
		RETURN 1
	END   
	ELSE
		SELECT * FROM SANPHAM_CUAHANG JOIN SANPHAM ON SANPHAM_CUAHANG.MASP = SANPHAM.MASP WHERE TENSP LIKE N'% '+@TenSanPham+'%'
	END TRY

	BEGIN CATCH  
		PRINT N'Lỗi hệ thống!'
		ROLLBACK TRAN 
		RETURN 1
	END CATCH
COMMIT TRAN
RETURN 0
GO

CREATE PROCEDURE TimLoaiSanPham_CuaHang @MaCuaHang int, @TenLoaiSanPham nvarchar(30)
AS
BEGIN TRAN
	BEGIN TRY
	IF NOT EXISTS (SELECT * FROM SANPHAM_CUAHANG JOIN SANPHAM ON SANPHAM_CUAHANG.MASP = SANPHAM.MASP JOIN LOAISP ON SANPHAM.MALOAI = LOAISP.MALOAI
							WHERE TENLOAI LIKE N'% '+@TenLoaiSanPham+'%')
	BEGIN
		PRINT N'Không tồn tại loại sản phẩm'
		ROLLBACK TRAN 
		RETURN 1
	END   
	ELSE
		SELECT * 
		FROM SANPHAM_CUAHANG JOIN SANPHAM ON SANPHAM_CUAHANG.MASP = SANPHAM.MASP JOIN LOAISP ON SANPHAM.MALOAI = LOAISP.MALOAI
		WHERE TENLOAI LIKE N'% '+@TenLoaiSanPham+'%'
	END TRY

	BEGIN CATCH  
		PRINT N'Lỗi hệ thống!'
		ROLLBACK TRAN 
		RETURN 1
	END CATCH
COMMIT TRAN
RETURN 0
GO

--Thống kế doanh thu của cửa hàng
CREATE PROCEDURE DOANHTHU_CH
(
	@TENCH NVARCHAR(50),
	@THANG int,
	@NAM int
)
AS 
	BEGIN TRAN
		SELECT  SUM(TONGTIENTHUC) AS DOANHTHU 
		FROM DONDATHANG DH, CUAHANG CH,SANPHAM_CUAHANG SPCH, CT_DONDATHANG CTDH, SANPHAM SP
		WHERE SPCH.MACH = CH.MACH and SPCH.MASP = SP.MASP and CTDH.MASP = SP.MASP and DH.MADH = CTDH.MADH and CH.TENCH = @TENCH and MONTH(DH.NGAYDAT) = @THANG and YEAR(DH.NGAYDAT) = @NAM
	COMMIT TRAN
GO
Exec DOANHTHU_CH N'Shop hoa tươi số 1',1,2020

--Xem san pham ban chay
create proc sp_XemSanPhamBanChay
(
	@TENCH NVARCHAR(50),
	@THANG int,
	@NAM int
)
as
begin tran
	SELECT  TOP 20 SP.TENSP, SUM(CTDH.SOLUONG) as TONGSOBAN
	FROM DONDATHANG DH, CUAHANG CH,SANPHAM_CUAHANG SPCH, CT_DONDATHANG CTDH, SANPHAM SP
	WHERE SPCH.MACH = CH.MACH and SPCH.MASP = SP.MASP and CTDH.MASP = SP.MASP and DH.MADH = CTDH.MADH and CH.TENCH = @TENCH and MONTH(DH.NGAYDAT) = @THANG and YEAR(DH.NGAYDAT) = @NAM
	GROUP BY TENSP
	Order by TONGSOBAN DESC
commit
go
exec sp_XemSanPhamBanChay N'Shop hoa tươi số 1',1,2020

--Xem san pham ban cham
create proc sp_XemSanPhamBanCham
(
	@TENCH NVARCHAR(50),
	@THANG int,
	@NAM int
)
as
begin tran
	SELECT  TOP 20 SP.TENSP, SUM(CTDH.SOLUONG) as TONGSOBAN
	FROM DONDATHANG DH, CUAHANG CH,SANPHAM_CUAHANG SPCH, CT_DONDATHANG CTDH, SANPHAM SP
	WHERE SPCH.MACH = CH.MACH and SPCH.MASP = SP.MASP and CTDH.MASP = SP.MASP and DH.MADH = CTDH.MADH and CH.TENCH = @TENCH and MONTH(DH.NGAYDAT) = @THANG and YEAR(DH.NGAYDAT) = @NAM
	GROUP BY TENSP
	Order by TONGSOBAN ASC
commit
go

--Xem so luong hang
create proc sp_XemTongSoLuongHang
as
begin tran
	Select sp.MASP, sp.TENSP, SUM(sc.SLTON)
	From SANPHAM sp, SANPHAM_CUAHANG sc
	Where sp.MASP = sc.MASP
	Group by sp.MASP, sp.TENSP
commit

go
CREATE NONCLUSTERED INDEX IX_CUAHANG_TENCH ON CUAHANG(MACH,TENCH)
CREATE NONCLUSTERED INDEX IX_DONDAT_NGAYDAT ON DONDATHANG( NGAYDAT desc, tongtienthuc)
DROP INDEX IX_CUAHANG_TENCH ON CUAHANG
DROP INDEX IX_DONDAT_NGAYDAT ON DONDATHANG