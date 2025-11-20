
package constant;

/**
 *
 * @author Guang Trump
 */
// Dùng để chứa các thông báo, và có thể thay đổi tại đây thay vì vào từng class và package để thay đổi dòng message
public class MessageConstant {
    public static final String LOGIN_SUCCESS = "Login Succesfully";
    public static final String LOGIN_FAIL = "Login Failed";
    public static final String MESSAGE_SUCCESS = "Sucessfully !";
    public static final String MESSAGE_FAIL = "Failed !";
}

/*B1: Tạo file Maven web, vào file pom.xml để add các thư viện chưa có sẵn
B2: Tạo DB
B3: Tạo package dal gồm có DBContext để CONNECT DB và tạo AccountDAO để lấy DATA từ DBContext
B4: Tạo package model gồm có Account để lấy các thuộc tính từ DB
B5: Tạo package Service gồm có LoginService đây sẽ là class trung gian để giải quyết
cách mà AccuntDAO lấy DATA từ DBContext để xử lý
B6: Tạo package dto gồm có Response để in ra thông báo cho CLIENT, 
ngoài ra trong Response còn tạo GENERICS để có thể thay đổi biển
như trong LoginService sẽ tạo ra Account và Account sẽ thay thế T trong Response
nên T sẽ nhận mọi thuộc tính của Account
B7: Tạo package constant chứa MessageConstant để tạo ra những biến cố định nhằm in ra các
MESSAGE và khi muôn thay đổi dòng MESSAGE thì có thể vào lại MessageConstant để thay đổi
thay vì phải vào từng class để thay đổi (Đây là thuộc tính đa hình của OOP)

42:05


*/
