# Changelog - Hệ thống Lịch sử Mua hàng

## Tổng quan
Đã cập nhật hệ thống để lưu lịch sử mua hàng vào OrderHistory thay vì Cart sau khi thanh toán thành công.

## Các thay đổi chính

### 1. Tạo PaymentServlet
- **File mới**: `src/main/java/controller/PaymentServlet.java`
- **Chức năng**: Xử lý thanh toán và lưu đơn hàng vào OrderHistory với status "paid"
- **URL Pattern**: `/payment`

### 2. Cập nhật payment.jsp
- Gọi PaymentServlet thay vì thêm vào Cart
- Gửi thông tin: itemType, itemId, itemName, price, quantity, paymentMethod
- Hiển thị modal thành công sau khi thanh toán

### 3. Cập nhật CartServlet
- **File**: `src/main/java/controller/CartServlet.java`
- **Thay đổi**: Load từ OrderHistory (status = "paid") thay vì Cart
- Hiển thị lịch sử mua hàng thay vì giỏ hàng tạm thời

### 4. Cập nhật UserDashboardServlet
- **File**: `src/main/java/controller/UserDashboardServlet.java`
- **Thay đổi**: 
  - Xóa import CartDAO
  - Load OrderHistory thay vì Cart
  - Tính tổng tiền đã chi từ OrderHistory

### 5. Cập nhật user-dashboard.jsp
- **Tab "My Cart"** → **"Lịch Sử Mua Hàng"**
- Hiển thị:
  - Tên sản phẩm (workout/coach)
  - Ngày mua
  - Phương thức thanh toán
  - Số lượng
  - Giá đơn vị
  - Tổng tiền
  - Tổng số tiền đã chi
- Xóa các hàm JavaScript không cần thiết (updateQuantity, removeFromCart, clearCart, checkout)

### 6. Database Schema
- **File mới**: `update_orderhistory_schema.sql`
- **Thay đổi**: Cập nhật CHECK constraint để thêm 'workout' vào item_type
- **Lưu ý**: Cần chạy script này để cập nhật database

## Các file có thể xóa (tùy chọn)

Các file sau vẫn có thể hữu ích nếu muốn thêm chức năng giỏ hàng tạm thời trong tương lai:
- `src/main/java/model/Cart.java` - Model cho Cart
- `src/main/java/dal/CartDAO.java` - DAO cho Cart

**Khuyến nghị**: Giữ lại các file này vì có thể cần dùng trong tương lai.

## Hướng dẫn sử dụng

1. **Chạy script cập nhật database**:
   ```sql
   -- Chạy file: update_orderhistory_schema.sql
   ```

2. **Khi người dùng mua workout hoặc thuê coach**:
   - Click "Buy Now" hoặc "Thuê Ngay"
   - Điền thông tin thanh toán
   - Click "Thanh Toán"
   - Đơn hàng được lưu vào OrderHistory với status "paid"

3. **Xem lịch sử mua hàng**:
   - Vào User Dashboard
   - Click tab "Lịch Sử Mua Hàng"
   - Xem tất cả đơn hàng đã thanh toán và tổng tiền đã chi

## Lưu ý

- Tất cả đơn hàng được lưu với payment_status = "paid" và order_status = "active"
- Lịch sử mua hàng chỉ hiển thị các đơn đã thanh toán thành công
- Tổng tiền được tính từ tất cả đơn hàng có payment_status = "paid"


