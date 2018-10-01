package common.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DBConnection {
    public static Connection commonConn = null;

    private static DBConnection connection = new DBConnection();

    private DBConnection(){
        try {
            commonConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/crypto", "crypto", "P@ssw0rd");
        }catch (Exception e){
            System.out.println(e.toString());
        }
    }
    public static DBConnection getInstance(){
        return connection;
    }




}
