package common.init;

import common.util.CommonUtil;
import common.util.DBConnection;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import service.ApiService;
import sun.net.www.protocol.http.HttpURLConnection;

import javax.annotation.PostConstruct;
import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.sql.*;
import java.util.HashMap;

@Component
public class CoinMarketCalApi{
    public static ResultSet commonRs = null;
    public static Connection commonConn = null;
    public static PreparedStatement pstmt = null;
    public static PreparedStatement pstmt1 = null;
    private static CommonUtil commonUtil = new CommonUtil();
    private static DBConnection DBConn = DBConnection.getInstance();

    public void main(){
        System.out.println("#CoinMarketCalApi Thread START !!!");
        try {
            commonConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/crypto", "crypto", "P@ssw0rd");
            commonConn.setAutoCommit(false);
//            commonConn = DriverManager.getConnection("jdbc:mysql://106.10.40.9:3306/crypto", "crypto", "P@ssw0rd");
            String query = "";
            getData(getAccessToken());

        }catch(Exception e) {
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
        }
    }
    private String getAccessToken(){
        //
        OutputStreamWriter wr = null;
        BufferedReader rd = null;
        String accessToken = null;

        try {
            URL url = new URL("https://api.coinmarketcal.com/oauth/v2/token?grant_type=client_credentials&client_id=1058_27717qjnjlc04ww4c80k4gwkg0g4wk8g88wk4kcssg8s8owgkg&client_secret=47knyiyobj0gk4wk08o40c4wocgc44g8wc40scg8o8g4o0g8g8");
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
                if(jsonResult != null) {
                    accessToken = jsonResult.get("access_token").toString();
                }
            }
            else {
                System.out.print("response fail \n" +sb.toString());
            }
        }catch(Exception e) {
            System.out.println(e.toString());
        }finally {
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
        return accessToken;
    }
    private void getData(String token){
        OutputStreamWriter wr = null;
        BufferedReader rd = null;
        Statement s;
        String query = "";
        String notExistQuery = "";
        if(token == null){
            return;
        }
        try{
            for(int j = 1; ;j++){
                URL url = new URL("https://api.coinmarketcal.com/v1/events?access_token="+token+"&page="+j+"&max=100&showOnly=hot_events");
                HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
                con.setRequestMethod("GET");
                con.setDoOutput(true);
                con.connect();
                int responseCode = con.getResponseCode();
                if(responseCode == 404){
                    break;
                }
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
                    JSONArray jsonArray = (JSONArray) parser.parse(sb.toString());
                    if (jsonArray != null) {
                        System.out.print("size " + jsonArray.size());
                        int id = 0;
                        String name = null;
                        String symbol = null;
                        String title = null;
                        String  source = null;
                        String dateEvent = null;

                        int ico_id = 0;
                        for (int i = 0; i < jsonArray.size(); i++) {
                            JSONObject obj = (JSONObject) jsonArray.get(i);
                            JSONArray coinArray = null;
                            if(obj.get("id") != null) {
                                id = Integer.parseInt(obj.get("id").toString());
                            }
                            if(obj.get("coins") != null) {
                                coinArray = (JSONArray) obj.get("coins");
                            }
                            for(int k = 0; k < coinArray.size(); k++) {
                                JSONObject coinObj = (JSONObject) coinArray.get(k);     //

                                if(coinObj.get("name") != null) {
                                    name = coinObj.get("name").toString();
                                }
                                if(coinObj.get("symbol") != null) {
                                    symbol = coinObj.get("symbol").toString();
                                }
                            }
                            if(obj.get("title") != null) {
                                title = obj.get("title").toString();
                            }
                            if(obj.get("date_event") != null) {
                                dateEvent = obj.get("date_event").toString().substring(0, 10);
                            }
                            if(obj.get("source") != null) {
                                source = obj.get("source").toString();
                            }
                            /*if(obj.get("vote_count") != null) {
                                voteCount = Integer.parseInt(obj.get("vote_count").toString());
                            }
                            if(obj.get("percentage") != null){
                                percentage = Integer.parseInt(obj.get("percentage").toString());
                            }*/
                            notExistQuery += id+",";
                            query = "select ico_id from ico where ico_name = ? and ico_symbol = ?";
                            pstmt = commonConn.prepareStatement(query);
                            pstmt.setString(1,name);
                            pstmt.setString(2,symbol);
                            commonRs = pstmt.executeQuery();
                            pstmt.clearParameters();
                            if(commonRs.next()) {
                                ico_id = commonRs.getInt(1);
                                query = "select 1 from coin_event where event_id = ?";
                                pstmt = commonConn.prepareStatement(query);
                                pstmt.setInt(1,id);
                                commonRs = pstmt.executeQuery();
                                pstmt.clearParameters();
                                if (commonRs.next()) {
                                    query = "update coin_event set is_expose = 'Y' where event_id = ?";
                                    pstmt1 = commonConn.prepareStatement(query);
                                    pstmt1.setInt(1,id);
                                } else {
                                    String sql = "insert into coin_event(event_id, ico_id, coin_event, source, event_date) values (?, ?, ?, ?, ?)";
                                    pstmt1 = commonConn.prepareStatement(sql);
                                    pstmt1.setInt(1,id);
                                    pstmt1.setInt(2,ico_id);
                                    pstmt1.setString(3,title);
                                    pstmt1.setString(4,source);
                                    pstmt1.setString(5,dateEvent);
                                }
                                try {
                                    pstmt1.executeUpdate();
                                    pstmt1.clearParameters();
                                } catch (SQLException e) {
                                    System.out.println(e.toString());
                                    System.out.println(query);
                                }
                            }
//                            System.out.println("#" + i + ".\tid : " + id + "\tname : " + name + "\tsymbol : " + symbol);
                        }

                    }
                }
                else {
                    System.out.print("response fail \n" +sb.toString());
                }
                notExistQuery = notExistQuery.substring(0,notExistQuery.length()-1);
                query = "update coin_event set is_expose = 'N' where event_id not in ("+notExistQuery+")";          //CoinMarketCal 에서 존재하지 않는 값 표시X
                pstmt = commonConn.prepareStatement(query);
                try {
                    pstmt.executeUpdate();
                } catch (SQLException e) {
                    System.out.println(e.toString());
                    System.out.println(query);
                }
            }
            try {
                commonConn.commit();
            }catch (SQLException e){
                commonConn.rollback();
                e.printStackTrace();
            }
        }catch(Exception e) {
            System.out.println(e.toString());
        }finally {
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
    }
}
