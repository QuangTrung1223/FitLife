-- =========================================
-- SCRIPT FIX NHANH: Thêm 'workout' vào OrderHistory
-- Chạy script này để fix ngay lập tức
-- =========================================

USE FitnessDB;
GO

PRINT 'Đang fix OrderHistory để hỗ trợ workout...';
GO

-- Xóa constraint cũ (nếu có)
DECLARE @constraintName NVARCHAR(200)
SELECT @constraintName = name 
FROM sys.check_constraints 
WHERE parent_object_id = OBJECT_ID('OrderHistory') 
AND definition LIKE '%item_type%'
AND definition NOT LIKE '%workout%'

IF @constraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE OrderHistory DROP CONSTRAINT ' + @constraintName)
    PRINT '✓ Đã xóa constraint cũ: ' + @constraintName
END
ELSE
BEGIN
    PRINT '✓ Không tìm thấy constraint cũ cần xóa'
END
GO

-- Thêm constraint mới với 'workout'
IF NOT EXISTS (
    SELECT * FROM sys.check_constraints 
    WHERE parent_object_id = OBJECT_ID('OrderHistory')
    AND definition LIKE '%workout%'
)
BEGIN
    ALTER TABLE OrderHistory
    ADD CONSTRAINT CK_OrderHistory_item_type 
    CHECK (item_type IN ('course', 'coach', 'workout'))
    PRINT '✓ Đã thêm constraint mới hỗ trợ workout'
END
ELSE
BEGIN
    PRINT '✓ Constraint đã hỗ trợ workout rồi'
END
GO

PRINT '';
PRINT '=========================================';
PRINT 'HOÀN TẤT! OrderHistory đã hỗ trợ workout';
PRINT '=========================================';
GO

