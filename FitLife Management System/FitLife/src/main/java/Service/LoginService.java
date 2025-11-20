/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Service;

import dal.UserDAO;
import dto.Response;
import model.User;
import constant.MessageConstant;

/**
 *
 * @author Guang Trump
 */ 
//Service như là trung gian, lấy data của controller để giao cho DAO thực hiện vì DAO kết nối với DB
public class LoginService {
    
    UserDAO accountDAO;
    
    public LoginService(){
        accountDAO = new UserDAO();
    }
    
//Account sẽ được ném vào generics, thay T bằng account
    public Response<User> checkLogin(String username, String password){
        User account =  accountDAO.checkLogin(username, password);
        if(account != null){
            return new Response<>(account, true, MessageConstant.LOGIN_SUCCESS);
        } else {
            return new Response<>(null, false, MessageConstant.LOGIN_FAIL);
        }
    }
}
