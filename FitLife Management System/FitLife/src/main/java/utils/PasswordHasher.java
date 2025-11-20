/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author Guang Trump
 */
public class PasswordHasher {
    //Ma hoa password
    //Nhập PW vào nó sẽ = với BCrypt để mã hóa password trong DB
    public static String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt(12));   
    }
    
    //Giải mã PW và so với với PW mà USER nhập vào
    public static boolean checkPassword(String password, String hashedPassword) {
        return BCrypt.checkpw(password, hashedPassword);
    }
    
}
