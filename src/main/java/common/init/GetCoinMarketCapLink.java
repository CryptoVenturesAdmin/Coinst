package common.init;

import common.util.CommonUtil;
import common.util.DBConnection;
import org.jsoup.HttpStatusException;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import service.ApiService;
import sun.net.www.protocol.http.HttpURLConnection;

import javax.annotation.PostConstruct;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

@Component
public class GetCoinMarketCapLink{
    public static Connection commonConn = null;
    public static Statement commonS = null;
    public static ResultSet commonRs = null;
    public static Connection commonConn1 = null;
    public static Statement commonS1 = null;
    public static ResultSet commonRs1 = null;

    private static CommonUtil commonUtil = new CommonUtil();
    private static DBConnection DBConn = DBConnection.getInstance();


    public void main() {		//시간당으로 coinMarketCap에서 데이터 받아오기
        System.out.println("#GetCoinMarketCapLink Thread START !!!");
        try {
            commonConn = DriverManager.getConnection("jdbc:mysql://106.10.40.9:3306/crypto", "crypto", "P@ssw0rd");
            commonS = commonConn.createStatement();
            commonConn1 = DriverManager.getConnection("jdbc:mysql://106.10.40.9:3306/crypto", "crypto", "P@ssw0rd");
            commonS1 = commonConn.createStatement();
            getCoinLink();
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
            if(commonS != null) {
                try {
                    commonS.close();
                } catch(SQLException e) {}
            }
            commonS = null;
            if(commonConn != null) {
                try {
                    commonConn.close();
                } catch(SQLException e) {}
            }
            commonConn = null;
            if(commonS1 != null) {
                try {
                    commonS1.close();
                } catch(SQLException e) {}
            }
            commonS1 = null;
            if(commonConn1 != null) {
                try {
                    commonConn1.close();
                } catch(SQLException e) {}
            }
            commonConn1 = null;
        }
    }

    private void getCoinLink() {
        String siteName = "eos";
        int ico_id = 0;
        String query = "";
        HashMap<String,Object> paramMap = new HashMap<String, Object>();
        try {
            query = "select site_symbol, ico_id from coin where site_symbol is not null";
//			query = "select sitesymbol, coin_name, coin_symbol from coin";
            commonRs = commonS.executeQuery(query);
            while(commonRs.next()) {
                siteName = commonRs.getString(1);
                ico_id = commonRs.getInt(2);
                org.jsoup.Connection.Response response = null;
                try {
                    response = Jsoup.connect("https://coinmarketcap.com/currencies/"+siteName+"/")
                            .method(org.jsoup.Connection.Method.GET)
                            .execute();

                }
                catch(HttpStatusException e) {
                    System.out.println(e.toString());
                    e.printStackTrace();
                }

                boolean isOk = false;
                isOk = (response != null) && (response.statusCode() == HttpURLConnection.HTTP_OK);
                if(isOk) {
                    Document document = response.parse();
                    Elements eles = document.getElementsByClass("list-unstyled details-panel-item--links").get(0).getElementsByTag("li");

                    Iterator<Element> itr = eles.iterator();
                    int count = 0;
                    System.out.println(siteName);

                    while(itr.hasNext()) {
                        Element ele = itr.next();
                        if(count == 1) {
                            String siteLink = null;
                            Elements aEles = ele.getElementsByTag("a");
                            if(aEles != null) {
                                siteLink = aEles.attr("href");
                                System.out.println(ico_id);
                                query = "select 1 from coin_link where ico_id = '"+ico_id+"' and link_type = '웹사이트' and link_url is not null limit 0,1";
                                commonRs1 = commonS1.executeQuery(query);
                                if(!commonRs1.next()){
                                    query = "insert into coin_link (ico_id,  link_type, link_url, sort_id) " +
                                            "values('"+ico_id+"', '웹사이트', '"+siteLink+"', 1)";

                                    try {
                                        commonS1.executeUpdate(query);
//                                        commonRs1.close();
                                    } catch(SQLException e) {
                                        System.out.println(e.toString());
                                        System.out.println(query);
                                    }
                                }
                                break;
                            }
                        }
                        count++;
                    }
                } else {
                    System.out.println("response fail "+siteName);
                }
            }

        }
        catch(Exception e) {
            System.out.println(e.toString());
            e.printStackTrace();
        }
        finally {

        }
    }
}
