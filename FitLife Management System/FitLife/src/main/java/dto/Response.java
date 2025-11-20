/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

//Giúp phản hồi lại cho client về nội dung kết quả thông báo như thế nào
//Generics là kiểu DATA tạm, khi truyền vào Response data thì chữ T sẽ biết mất, thay class và data mà đang truyền vào
//Vì bên LoginService đã thay T = Account nên bây giờ T sẽ có DATA của Account
public class Response<T> {
    T data;
    boolean succes;
   String message;

    public Response(T data, boolean succes, String message) {
        this.data = data;
        this.succes = succes;
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public boolean isSucces() {
        return succes;
    }

    public void setSucces(boolean succes) {
        this.succes = succes;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
   
   
    
}
