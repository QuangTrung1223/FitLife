/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Service;

import constant.MessageConstant;
import dal.UserDAO;
import dal.UserRoleDAO;
import dto.RegisterRequest;
import dto.Response;
import model.User;
import utils.PasswordHasher;

/**
 *
 * @author Guang Trump
 */
public class UserService {
    
    UserDAO accountDAO;
    UserRoleDAO accountRoleDAO;
    
    public UserService(){
        accountDAO = new UserDAO();
        accountRoleDAO = new UserRoleDAO();
    }
    
//Account sẽ được ném vào generics, thay T bằng account
    public Response<User> checkLogin(String username, String password){
        User account =  accountDAO.getAccountByUsername(username);
        if(account != null){
            String storedPassword = account.getPassword();
            boolean passwordMatch = false;
            
            // Thử kiểm tra bằng BCrypt trước
            try {
                passwordMatch = PasswordHasher.checkPassword(password, storedPassword);
            } catch (Exception e) {
                // Nếu BCrypt fail, thử so sánh plain text
                passwordMatch = password.equals(storedPassword);
            }
            
            if(passwordMatch){
                return new Response<>(account, true, MessageConstant.LOGIN_SUCCESS);
            }
        }
        return new Response<>(null, false, MessageConstant.LOGIN_FAIL);
    }
    
    public boolean register(RegisterRequest request) {
        String hashedPassword = PasswordHasher.hashPassword(request.getPassword());

        // Log thông tin kiểm tra và đăng ký
        System.out.println("UserService: Kiểm tra username: " + request.getUsername());
        if (accountDAO.isUsernameExists(request.getUsername())) {
            System.out.println("UserService: Username đã tồn tại: " + request.getUsername());
            return false;
        }

        System.out.println("UserService: Đăng ký user với email: " + request.getEmail());
        return accountDAO.register(request.getUsername(), hashedPassword, request.getEmail());
    }
    
    

}
