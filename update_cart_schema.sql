-- =========================================
-- SCRIPT CẬP NHẬT DATABASE SCHEMA
-- Thêm hỗ trợ 'workout' vào item_type cho Cart và OrderHistory
-- =========================================

USE FitnessDB;
GO

-- =========================================
-- CẬP NHẬT BẢNG Cart
-- =========================================
-- Xóa constraint cũ
IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Cart_item_type')
BEGIN
    ALTER TABLE Cart DROP CONSTRAINT CK_Cart_item_type;
END
GO

-- Thêm constraint mới với 'workout'
ALTER TABLE Cart
ADD CONSTRAINT CK_Cart_item_type CHECK (item_type IN ('course', 'coach', 'workout'));
GO

-- =========================================
-- CẬP NHẬT BẢNG OrderHistory
-- =========================================
-- Xóa constraint cũ
IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_OrderHistory_item_type')
BEGIN
    ALTER TABLE OrderHistory DROP CONSTRAINT CK_OrderHistory_item_type;
END
GO

-- Thêm constraint mới với 'workout'
ALTER TABLE OrderHistory
ADD CONSTRAINT CK_OrderHistory_item_type CHECK (item_type IN ('course', 'coach', 'workout'));
GO

PRINT '=========================================';
PRINT 'ĐÃ CẬP NHẬT SCHEMA THÀNH CÔNG';
PRINT 'Cart và OrderHistory giờ hỗ trợ:';
PRINT '  - course';
PRINT '  - coach';
PRINT '  - workout';
PRINT '=========================================';
GO







