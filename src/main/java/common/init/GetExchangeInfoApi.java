package common.init;

import common.util.DateUtil;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.omg.PortableInterceptor.SYSTEM_EXCEPTION;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import sun.net.www.protocol.http.HttpURLConnection;

import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.sql.*;
import java.util.HashMap;

@Component
public class GetExchangeInfoApi {
    public static Connection commonConn = null;
    public static PreparedStatement pstmt = null;
    public static ResultSet commonRs = null;
    public static Connection commonConn1 = null;
    public static PreparedStatement pstmt1 = null;
    public static ResultSet commonRs1 = null;


    public void main(){
        System.out.println("#GetExchangeInfoApi Thread START !!!");
        try {
            commonConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/crypto", "crypto", "P@ssw0rd");
            commonConn.setAutoCommit(false);
            getExchangeInfoToApi();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        finally {
            if(commonRs != null) {
                try {
                    commonRs.close();
                } catch(SQLException e) {}
            }
            commonRs = null;
            if(pstmt != null) {
                try {
                    pstmt.close();
                } catch(SQLException e) {}
            }
            pstmt = null;
            if(commonConn != null) {
                try {
                    commonConn.close();
                } catch(SQLException e) {}
            }
            commonConn = null;
            if(pstmt1 != null) {
                try {
                    pstmt1.close();
                } catch(SQLException e) {}
            }
            pstmt1 = null;
            if(commonConn1 != null) {
                try {
                    commonConn1.close();
                } catch(SQLException e) {}
            }
            commonConn1 = null;
        }
    }

    public String getExchangeInfoToApi(){
        OutputStreamWriter wr = null;
        BufferedReader rd = null;
        String excRate = null;
        String query = null;
        int excId = 0;
        String excName = null;
        try {
            URL url = new URL("https://openexchangerates.org/api/latest.json?app_id=515d339c6b0642e09e947dd1128739e1&base=USD");
            HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            con.setDoOutput(true);
            con.connect();
            int responseCode = con.getResponseCode();
            boolean isOk = false;
            if (responseCode == HttpURLConnection.HTTP_OK) {
                rd = new BufferedReader(new InputStreamReader(con.getInputStream()));
                isOk = true;
            } else {
                rd = new BufferedReader(new InputStreamReader(con.getErrorStream()));
            }
            String line = null;
            StringBuilder sb = new StringBuilder();
            while ((line = rd.readLine()) != null) {
                sb.append(line);
            }
            rd.close();
            rd = null;
            if(isOk) {
                JSONParser parser = new JSONParser();
                JSONObject jsonResult = (JSONObject) parser.parse(sb.toString());
                DateUtil dateUtil = new DateUtil();
                String today = dateUtil.dateEx(null,0,0,0,0,0,0,"yyyy-MM-dd HH:mm:ss");
                if(jsonResult != null) {
                    long timeStamp = 0;
                    if(jsonResult.get("timestamp") != null){
                        timeStamp = Integer.parseInt(jsonResult.get("timestamp").toString());
                    }
                    if(jsonResult.get("rates") != null){
                        System.out.println(today);
                        HashMap<String,Object> exchangeMap = (HashMap<String, Object>) jsonResult.get("rates");
                        query = "select exc_id, exc_name from coin_exchange";
                        pstmt = commonConn.prepareStatement(query);
                        commonRs = pstmt.executeQuery();
                        query = "insert into coin_exchange_info(exc_id, exc_name, exc_rate, last_updated, input_date) " +
                                "values(?, ?, ?, from_unixtime(?,'%Y-%c-%e %h:%i:%s'), ?)";
                        pstmt1 = commonConn.prepareStatement(query);
                        while(commonRs.next()){
                            excId = commonRs.getInt(1);
                            excName = commonRs.getString(2);
                            if(exchangeMap.get(excName) != null){
                                excRate = exchangeMap.get(excName).toString();
                                pstmt1.setInt(1,excId);
                                pstmt1.setString(2,excName);
                                pstmt1.setString(3,excRate);
                                pstmt1.setLong(4,timeStamp);
                                pstmt1.setString(5,today);
                                pstmt1.addBatch();
                            }
                        }
                        try {
                            pstmt1.executeBatch();
                            commonConn.commit();
                        }catch (SQLException e){
                            commonConn.rollback();
                            System.out.println(query);
                            e.printStackTrace();
                        }
                    }
                }
            }
            else {
                System.out.print("response fail \n" +sb.toString());
            }
        }
        catch(Exception e) {
            System.out.println(e.toString());
        }
        finally {
            try {
                if(wr != null) {
                    wr.close();
                    wr = null;
                }
            }
            catch(IOException ex) {
                System.out.print(ex.toString());
                ex.printStackTrace();
            }
        }

        return excRate;
    }


}
