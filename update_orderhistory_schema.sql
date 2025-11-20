-- Cập nhật OrderHistory table để thêm 'workout' vào item_type
-- Chạy script này để cập nhật database schema

-- Xóa constraint cũ
IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK__OrderHist__item_t__[A-Z0-9]*')
BEGIN
    DECLARE @constraintName NVARCHAR(200)
    SELECT @constraintName = name FROM sys.check_constraints 
    WHERE parent_object_id = OBJECT_ID('OrderHistory') 
    AND definition LIKE '%item_type%'
    
    IF @constraintName IS NOT NULL
    BEGIN
        EXEC('ALTER TABLE OrderHistory DROP CONSTRAINT ' + @constraintName)
    END
END
GO

-- Thêm constraint mới với 'workout'
ALTER TABLE OrderHistory
ADD CONSTRAINT CK_OrderHistory_item_type 
CHECK (item_type IN ('course', 'coach', 'workout'))
GO

-- Kiểm tra constraint đã được tạo
SELECT name, definition 
FROM sys.check_constraints 
WHERE parent_object_id = OBJECT_ID('OrderHistory')
AND name = 'CK_OrderHistory_item_type'
GO


