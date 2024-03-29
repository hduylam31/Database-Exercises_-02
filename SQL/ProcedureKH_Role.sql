﻿USE HoaYeuThuong
GO

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