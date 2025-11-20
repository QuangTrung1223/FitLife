/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import constant.MessageConstant;
import dto.Response;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.UserRole;
import util.DBContext;

/**
 *
 * @author Guang Trump
 */
public class UserRoleDAO extends DBContext {

    private final String ACCOUNT_ROLE_INSERT = "INSERT INTO [dbo]. [AccountRole]([AccountID], [RoleID]) VALUES(?,?)";
    private final String ACCOUNT_ROLE_CHECK_ROLE = "SELECT [Username], [RbleID] FROM [dbo]. [AccountRole] where Username = ?";
//Mặc định AUTO là CUSTOME

    public boolean addAccountRole(String username) {
        try {
            PreparedStatement ps = c.prepareStatement(ACCOUNT_ROLE_INSERT);
            ps.setString(1, username);
            ps.setInt(2, 1);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Response<UserRole> checkAccountRole(String username) {
        try {
            PreparedStatement ps = c.prepareStatement(ACCOUNT_ROLE_CHECK_ROLE);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Response(new UserRole(username, rs.getInt("RoleId")), true, MessageConstant.MESSAGE_SUCCESS);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return new Response<>(null,
                false,
                MessageConstant.MESSAGE_FAIL);

    }
}
