package common.init;


import common.util.DateUtil;
import org.json.simple.JSONObject;

import java.sql.*;
import java.util.List;

public class CoinMarketCapApiLastUpdatedThread implements Runnable{
    private List<Object> capList;
    private Connection commonConn;
    private volatile boolean done = false;

    public PreparedStatement pstmt = null;
    private ResultSet commonRs = null;
    private DateUtil dateUtil = new DateUtil();
    public CoinMarketCapApiLastUpdatedThread(List<Object> capList, Connection commonConn){
        this.capList = capList;
        this.commonConn = commonConn;
    }

    public void run(){
        try {
//            commonConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/crypto", "crypto", "P@ssw0rd");
            commonConn.setAutoCommit(false);
            updateLastUpdateDate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        done = true;
        synchronized (this){
            this.notifyAll();
        }
    }

    public void updateLastUpdateDate(){
        String query = "";
        int id = 0;
        String last_updated = "";
        long last_updated_long = 0;
        try {
            for (int i = 0; i< capList.size(); i++) {
                JSONObject obj = (JSONObject) capList.get(i);
                if(obj.get("id") != null) {
                    id = Integer.parseInt(obj.get("id").toString());
                }
                if(obj.get("last_updated") != null){
                    last_updated = obj.get("last_updated").toString();
                    last_updated = last_updated.substring(0,10)+" "+last_updated.substring(11,19);
                    last_updated_long = dateUtil.toNumber(last_updated);
                }
                query = "select cast(last_updated as char) as last_updated from coin where coin_id = ?";
                pstmt = commonConn.prepareStatement(query);
                pstmt.setInt(1,id);
                commonRs = pstmt.executeQuery();
                if(commonRs.next()){
                    long saved_last_updated = 0;
                    if(commonRs.getString(1) != null){
                        saved_last_updated = dateUtil.toNumber(commonRs.getString(1));
                    }
                    if(last_updated_long > saved_last_updated) {
                        query = "update coin set last_updated = ? where coin_id = ?";
                        pstmt = commonConn.prepareStatement(query);
                        pstmt.setString(1,last_updated);
                        pstmt.setInt(2,id);
                        pstmt.executeUpdate();
                    }
                }
            }
            /*try {
                commonConn.commit();
            }catch (SQLException e){
                commonConn.rollback();
                e.printStackTrace();
            }*/
        } catch (SQLException e) {
            System.out.println(e.toString());
            System.out.println(query);
        }
    }

    public void checkLastUpdatedEnd(){
        if (!done){
            synchronized (this){
                try {
                    this.wait();
                }catch (InterruptedException e){
                    e.printStackTrace();
                }
            }
        }
    }
}
