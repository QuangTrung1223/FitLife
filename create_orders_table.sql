-- =========================================
-- CREATE TABLE: Orders
-- Bảng lưu thông tin đơn hàng chi tiết
-- =========================================

USE FitnessDB;
GO

-- Tạo bảng Orders nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type in (N'U'))
BEGIN
    CREATE TABLE Orders (
        order_id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NOT NULL,
        order_type NVARCHAR(20) NOT NULL CHECK (order_type IN ('workout', 'course', 'coach')),
        item_id INT NULL,
        item_name NVARCHAR(200) NOT NULL,
        price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
        full_name NVARCHAR(100) NOT NULL,
        email NVARCHAR(100) NOT NULL,
        phone NVARCHAR(20) NOT NULL,
        address NVARCHAR(500) NOT NULL,
        payment_method NVARCHAR(50) NOT NULL,
        status NVARCHAR(20) DEFAULT 'completed' CHECK (status IN ('pending', 'completed', 'cancelled')),
        order_date DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
    );

    -- Tạo indexes
    CREATE INDEX IX_Orders_User ON Orders(user_id);
    CREATE INDEX IX_Orders_OrderDate ON Orders(order_date);
    CREATE INDEX IX_Orders_Status ON Orders(status);
    
    PRINT 'Bảng Orders đã được tạo thành công!';
END
ELSE
BEGIN
    PRINT 'Bảng Orders đã tồn tại.';
END
GO

