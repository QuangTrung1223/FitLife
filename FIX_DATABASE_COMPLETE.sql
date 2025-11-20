-- =========================================
-- SCRIPT FIX TOÀN BỘ DATABASE
-- Chạy script này để fix tất cả các vấn đề về database
-- =========================================

USE FitnessDB;
GO

PRINT '=========================================';
PRINT 'BẮT ĐẦU FIX DATABASE...';
PRINT '=========================================';
GO

-- =========================================
-- 1. TẠO BẢNG Orders (NẾU CHƯA TỒN TẠI)
-- =========================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type in (N'U'))
BEGIN
    PRINT 'Đang tạo bảng Orders...';
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

    CREATE INDEX IX_Orders_User ON Orders(user_id);
    CREATE INDEX IX_Orders_OrderDate ON Orders(order_date);
    CREATE INDEX IX_Orders_Status ON Orders(status);
    
    PRINT '✓ Bảng Orders đã được tạo thành công!';
END
ELSE
BEGIN
    PRINT '✓ Bảng Orders đã tồn tại.';
END
GO

-- =========================================
-- 2. FIX BẢNG Coach/Coaches
-- Kiểm tra và tạo view hoặc alias nếu cần
-- =========================================
-- Kiểm tra xem có bảng Coach không
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Coach]') AND type in (N'U'))
BEGIN
    PRINT '✓ Bảng Coach đã tồn tại.';
    
    -- Tạo view Coaches nếu code đang dùng Coaches
    IF NOT EXISTS (SELECT * FROM sys.views WHERE name = 'Coaches')
    BEGIN
        PRINT 'Đang tạo view Coaches...';
        EXEC('CREATE VIEW Coaches AS SELECT * FROM Coach');
        PRINT '✓ View Coaches đã được tạo thành công!';
    END
    ELSE
    BEGIN
        PRINT '✓ View Coaches đã tồn tại.';
    END
END
ELSE
BEGIN
    PRINT '⚠ CẢNH BÁO: Bảng Coach chưa tồn tại. Vui lòng chạy SQLQuery1.sql trước.';
END
GO

-- =========================================
-- 3. FIX OrderHistory - THÊM 'workout' VÀO item_type
-- =========================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderHistory]') AND type in (N'U'))
BEGIN
    PRINT 'Đang cập nhật OrderHistory để hỗ trợ workout...';
    
    -- Xóa constraint cũ nếu có
    DECLARE @constraintName NVARCHAR(200)
    SELECT @constraintName = name FROM sys.check_constraints 
    WHERE parent_object_id = OBJECT_ID('OrderHistory') 
    AND definition LIKE '%item_type%'
    AND definition NOT LIKE '%workout%'
    
    IF @constraintName IS NOT NULL
    BEGIN
        EXEC('ALTER TABLE OrderHistory DROP CONSTRAINT ' + @constraintName)
        PRINT '✓ Đã xóa constraint cũ của item_type.';
    END
    
    -- Kiểm tra xem constraint mới đã có chưa
    IF NOT EXISTS (
        SELECT * FROM sys.check_constraints 
        WHERE parent_object_id = OBJECT_ID('OrderHistory')
        AND definition LIKE '%workout%'
    )
    BEGIN
        -- Thêm constraint mới với 'workout'
        ALTER TABLE OrderHistory
        ADD CONSTRAINT CK_OrderHistory_item_type 
        CHECK (item_type IN ('course', 'coach', 'workout'))
        PRINT '✓ Đã thêm constraint mới hỗ trợ workout.';
    END
    ELSE
    BEGIN
        PRINT '✓ OrderHistory đã hỗ trợ workout.';
    END
END
ELSE
BEGIN
    PRINT '⚠ CẢNH BÁO: Bảng OrderHistory chưa tồn tại. Vui lòng chạy SQLQuery1.sql trước.';
END
GO

-- =========================================
-- 4. FIX Cart - THÊM 'workout' VÀO item_type (NẾU CẦN)
-- =========================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cart]') AND type in (N'U'))
BEGIN
    PRINT 'Đang kiểm tra Cart table...';
    
    -- Xóa constraint cũ nếu có và không hỗ trợ workout
    DECLARE @cartConstraintName NVARCHAR(200)
    SELECT @cartConstraintName = name FROM sys.check_constraints 
    WHERE parent_object_id = OBJECT_ID('Cart') 
    AND definition LIKE '%item_type%'
    AND definition NOT LIKE '%workout%'
    
    IF @cartConstraintName IS NOT NULL
    BEGIN
        EXEC('ALTER TABLE Cart DROP CONSTRAINT ' + @cartConstraintName)
        PRINT '✓ Đã xóa constraint cũ của Cart.item_type.';
        
        -- Thêm constraint mới với 'workout'
        ALTER TABLE Cart
        ADD CONSTRAINT CK_Cart_item_type 
        CHECK (item_type IN ('course', 'coach', 'workout'))
        PRINT '✓ Đã cập nhật Cart để hỗ trợ workout.';
    END
    ELSE
    BEGIN
        PRINT '✓ Cart đã hỗ trợ workout hoặc không có constraint.';
    END
END
ELSE
BEGIN
    PRINT '⚠ CẢNH BÁO: Bảng Cart chưa tồn tại. Vui lòng chạy SQLQuery1.sql trước.';
END
GO

-- =========================================
-- 5. KIỂM TRA VÀ TẠO CÁC INDEX CẦN THIẾT
-- =========================================
PRINT 'Đang kiểm tra các index...';

-- Index cho Orders
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Orders_User' AND object_id = OBJECT_ID('Orders'))
BEGIN
    CREATE INDEX IX_Orders_User ON Orders(user_id);
    PRINT '✓ Đã tạo index IX_Orders_User.';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Orders_OrderDate' AND object_id = OBJECT_ID('Orders'))
BEGIN
    CREATE INDEX IX_Orders_OrderDate ON Orders(order_date);
    PRINT '✓ Đã tạo index IX_Orders_OrderDate.';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Orders_Status' AND object_id = OBJECT_ID('Orders'))
BEGIN
    CREATE INDEX IX_Orders_Status ON Orders(status);
    PRINT '✓ Đã tạo index IX_Orders_Status.';
END

-- Index cho OrderHistory (nếu chưa có)
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderHistory]') AND type in (N'U'))
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_OrderHistory_User' AND object_id = OBJECT_ID('OrderHistory'))
    BEGIN
        CREATE INDEX IX_OrderHistory_User ON OrderHistory(user_id);
        PRINT '✓ Đã tạo index IX_OrderHistory_User.';
    END
    
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_OrderHistory_OrderDate' AND object_id = OBJECT_ID('OrderHistory'))
    BEGIN
        CREATE INDEX IX_OrderHistory_OrderDate ON OrderHistory(order_date);
        PRINT '✓ Đã tạo index IX_OrderHistory_OrderDate.';
    END
    
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_OrderHistory_PaymentStatus' AND object_id = OBJECT_ID('OrderHistory'))
    BEGIN
        CREATE INDEX IX_OrderHistory_PaymentStatus ON OrderHistory(payment_status);
        PRINT '✓ Đã tạo index IX_OrderHistory_PaymentStatus.';
    END
    
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_OrderHistory_OrderStatus' AND object_id = OBJECT_ID('OrderHistory'))
    BEGIN
        CREATE INDEX IX_OrderHistory_OrderStatus ON OrderHistory(order_status);
        PRINT '✓ Đã tạo index IX_OrderHistory_OrderStatus.';
    END
END

GO

-- =========================================
-- 6. KIỂM TRA TẤT CẢ CÁC BẢNG
-- =========================================
PRINT '';
PRINT '=========================================';
PRINT 'KIỂM TRA CÁC BẢNG:';
PRINT '=========================================';

DECLARE @tableCount INT = 0;

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
    PRINT '✓ Users';
    SET @tableCount = @tableCount + 1;
END
ELSE
    PRINT '✗ Users - CHƯA TỒN TẠI!';

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Workouts]') AND type in (N'U'))
BEGIN
    PRINT '✓ Workouts';
    SET @tableCount = @tableCount + 1;
END
ELSE
    PRINT '✗ Workouts - CHƯA TỒN TẠI!';

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Diets]') AND type in (N'U'))
BEGIN
    PRINT '✓ Diets';
    SET @tableCount = @tableCount + 1;
END
ELSE
    PRINT '✗ Diets - CHƯA TỒN TẠI!';

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Progress]') AND type in (N'U'))
BEGIN
    PRINT '✓ Progress';
    SET @tableCount = @tableCount + 1;
END
ELSE
    PRINT '✗ Progress - CHƯA TỒN TẠI!';

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Courses]') AND type in (N'U'))
BEGIN
    PRINT '✓ Courses';
    SET @tableCount = @tableCount + 1;
END
ELSE
    PRINT '✗ Courses - CHƯA TỒN TẠI!';

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Coach]') AND type in (N'U'))
BEGIN
    PRINT '✓ Coach';
    SET @tableCount = @tableCount + 1;
END
ELSE
    PRINT '✗ Coach - CHƯA TỒN TẠI!';

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cart]') AND type in (N'U'))
BEGIN
    PRINT '✓ Cart';
    SET @tableCount = @tableCount + 1;
END
ELSE
    PRINT '✗ Cart - CHƯA TỒN TẠI!';

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderHistory]') AND type in (N'U'))
BEGIN
    PRINT '✓ OrderHistory';
    SET @tableCount = @tableCount + 1;
END
ELSE
    PRINT '✗ OrderHistory - CHƯA TỒN TẠI!';

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type in (N'U'))
BEGIN
    PRINT '✓ Orders';
    SET @tableCount = @tableCount + 1;
END
ELSE
    PRINT '✗ Orders - CHƯA TỒN TẠI!';

GO

-- =========================================
-- 7. KIỂM TRA CONSTRAINT CỦA OrderHistory
-- =========================================
PRINT '';
PRINT '=========================================';
PRINT 'KIỂM TRA CONSTRAINT OrderHistory:';
PRINT '=========================================';

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderHistory]') AND type in (N'U'))
BEGIN
    DECLARE @constraintDef NVARCHAR(MAX)
    SELECT @constraintDef = definition 
    FROM sys.check_constraints 
    WHERE parent_object_id = OBJECT_ID('OrderHistory')
    AND definition LIKE '%item_type%'
    
    IF @constraintDef IS NOT NULL
    BEGIN
        PRINT 'Constraint hiện tại: ' + @constraintDef;
        IF @constraintDef LIKE '%workout%'
            PRINT '✓ OrderHistory đã hỗ trợ workout';
        ELSE
            PRINT '⚠ OrderHistory CHƯA hỗ trợ workout';
    END
    ELSE
        PRINT '⚠ Không tìm thấy constraint cho item_type';
END

GO

-- =========================================
-- HOÀN TẤT
-- =========================================
PRINT '';
PRINT '=========================================';
PRINT 'FIX DATABASE HOÀN TẤT!';
PRINT '=========================================';
PRINT '';
PRINT 'CÁC THAY ĐỔI ĐÃ THỰC HIỆN:';
PRINT '  1. ✓ Kiểm tra và tạo bảng Orders';
PRINT '  2. ✓ Tạo view Coaches (nếu cần)';
PRINT '  3. ✓ Cập nhật OrderHistory để hỗ trợ workout';
PRINT '  4. ✓ Cập nhật Cart để hỗ trợ workout (nếu cần)';
PRINT '  5. ✓ Tạo các index cần thiết';
PRINT '';
PRINT 'LƯU Ý:';
PRINT '  - Nếu có bảng nào chưa tồn tại, vui lòng chạy SQLQuery1.sql trước';
PRINT '  - Sau khi chạy script này, hãy test lại chức năng thanh toán';
PRINT '=========================================';
GO

