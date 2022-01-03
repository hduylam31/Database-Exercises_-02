CREATE DATABASE WEBBANHANG
GO
USE WEBBANHANG
GO

CREATE TABLE NHANVIEN (
	MANV INT, 
	HOTEN NVARCHAR (20) NOT NULL,
	MATKHAU VARCHAR(50) NOT NULL,
	LOAINV NVARCHAR(20) NOT NULL,
	MACH INT NOT NULL

	PRIMARY KEY(MANV)
)


CREATE TABLE TT_NHANVIEN (
	MANV INT, 
	EMAIL VARCHAR(20) NOT NULL UNIQUE,
	GIOITINH BIT NOT NULL,
	LUONG MONEY DEFAULT 0,
	SDT CHAR(11) NOT NULL,
	DIACHI NVARCHAR(50) NOT NULL,
	NGAYSINH DATETIME NOT NULL

	PRIMARY KEY(MANV)
)

CREATE TABLE NVGIAOHANG(
	MANV INT,
	SODONDAGIAO INT DEFAULT 0,
	BIENSO VARCHAR(20)

	PRIMARY KEY(MANV)
)

ALTER TABLE NHANVIEN
ADD CONSTRAINT FK_NHANVIEN_CUAHANG
FOREIGN KEY (MACH) REFERENCES CUAHANG(MACH)

ALTER TABLE TT_NHANVIEN
ADD CONSTRAINT FK_NHANVIEN_TT_NHANVIEN
FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV)

ALTER TABLE NVGIAOHANG
ADD CONSTRAINT FK_NVGIAOHANG_NHANVIEN
FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV)


