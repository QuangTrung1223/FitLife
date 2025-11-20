/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package test;

import util.DBContext;



public class testDBConnection {
    public static void main(String[] args) {
        // Tạo đối tượng DBContext để test kết nối
        DBContext db = new DBContext();

        // Kiểm tra xem có kết nối thành công hay không
        if (db.getConnection() != null) {
            System.out.println("Database connection test successful!");
        } else {
            System.out.println("Database connection failed!");
        }

        // Đóng kết nối
        db.closeConnection();
    }
}

