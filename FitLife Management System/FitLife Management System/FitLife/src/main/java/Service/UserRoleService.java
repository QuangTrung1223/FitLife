/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Service;

import dal.UserRoleDAO;
import dto.Response;
import model.UserRole;

/**
 *
 * @author Guang Trump
 */
public class UserRoleService {
    UserRoleDAO accountRoleDAO;
    
    public UserRoleService(){
        accountRoleDAO = new UserRoleDAO();
    }
    
    public boolean isAdmin(String username) {
    Response<UserRole> accountRole = accountRoleDAO.checkAccountRole(username);

    // Kiểm tra có dữ liệu không
    if (accountRole == null || accountRole.getData() == null) {
        System.out.println(" No role found for username: " + username);
        return false; // không phải admin hoặc chưa có role
    }

    return accountRole.getData().getRoleId() == 1;
}

    
}
