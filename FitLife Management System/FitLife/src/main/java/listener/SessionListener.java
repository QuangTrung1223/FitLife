package listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.ConcurrentHashMap;

@WebListener
public class SessionListener implements HttpSessionListener {
    
    private static final String ONLINE_USERS_COUNT = "onlineUsersCount";
    private static final String ONLINE_USERS_MAP = "onlineUsersMap";
    
    @Override
    public void sessionCreated(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        ServletContext context = session.getServletContext();
        
        // Tăng số lượng user online
        AtomicInteger onlineCount = (AtomicInteger) context.getAttribute(ONLINE_USERS_COUNT);
        if (onlineCount == null) {
            onlineCount = new AtomicInteger(0);
            context.setAttribute(ONLINE_USERS_COUNT, onlineCount);
        }
        
        int currentCount = onlineCount.incrementAndGet();
        System.out.println("[SessionListener] New session created. Total online users: " + currentCount);
        
        // Lưu thông tin session vào context để theo dõi
        session.setAttribute("sessionCreatedTime", System.currentTimeMillis());
    }
    
    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        ServletContext context = session.getServletContext();
        
        // Giảm số lượng user online
        AtomicInteger onlineCount = (AtomicInteger) context.getAttribute(ONLINE_USERS_COUNT);
        if (onlineCount != null) {
            int currentCount = onlineCount.decrementAndGet();
            System.out.println("[SessionListener] Session destroyed. Total online users: " + currentCount);
            
            // Đảm bảo không âm
            if (currentCount < 0) {
                onlineCount.set(0);
            }
        }
        
        // Log thông tin session
        String username = (String) session.getAttribute("session_login");
        Long createdTime = (Long) session.getAttribute("sessionCreatedTime");
        if (username != null) {
            long sessionDuration = System.currentTimeMillis() - (createdTime != null ? createdTime : System.currentTimeMillis());
            System.out.println("[SessionListener] User '" + username + "' logged out. Session duration: " + (sessionDuration / 1000) + " seconds");
        }
    }
    
    /**
     * Lấy số lượng user đang online
     */
    public static int getOnlineUsersCount(ServletContext context) {
        AtomicInteger onlineCount = (AtomicInteger) context.getAttribute(ONLINE_USERS_COUNT);
        return onlineCount != null ? onlineCount.get() : 0;
    }
    
    /**
     * Thêm user vào danh sách online (khi login thành công)
     */
    @SuppressWarnings("unchecked")
    public static void addOnlineUser(ServletContext context, String username) {
        ConcurrentHashMap<String, Boolean> onlineUsersMap = (ConcurrentHashMap<String, Boolean>) context.getAttribute(ONLINE_USERS_MAP);
        if (onlineUsersMap == null) {
            onlineUsersMap = new ConcurrentHashMap<>();
            context.setAttribute(ONLINE_USERS_MAP, onlineUsersMap);
        }
        onlineUsersMap.put(username, true);
        System.out.println("[SessionListener] User '" + username + "' added to online list. Total online: " + onlineUsersMap.size());
    }
    
    /**
     * Xóa user khỏi danh sách online (khi logout)
     */
    @SuppressWarnings("unchecked")
    public static void removeOnlineUser(ServletContext context, String username) {
        ConcurrentHashMap<String, Boolean> onlineUsersMap = (ConcurrentHashMap<String, Boolean>) context.getAttribute(ONLINE_USERS_MAP);
        if (onlineUsersMap != null) {
            onlineUsersMap.remove(username);
            System.out.println("[SessionListener] User '" + username + "' removed from online list. Total online: " + onlineUsersMap.size());
        }
    }
    
    /**
     * Lấy danh sách user đang online
     */
    @SuppressWarnings("unchecked")
    public static java.util.Set<String> getOnlineUsers(ServletContext context) {
        ConcurrentHashMap<String, Boolean> onlineUsersMap = (ConcurrentHashMap<String, Boolean>) context.getAttribute(ONLINE_USERS_MAP);
        return onlineUsersMap != null ? onlineUsersMap.keySet() : new java.util.HashSet<>();
    }
}
