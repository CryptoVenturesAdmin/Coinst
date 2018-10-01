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

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

@Component
public class GetCoinMarketCapHistory {
	public static ResultSet commonRs = null;
	public static Connection commonConn = null;
	public static Statement commonS = null;
	public static Connection commonConn1 = null;
	public static Statement commonS1 = null;

	private  CommonUtil commonUtil = new CommonUtil();
	private static DBConnection DBConn = DBConnection.getInstance();

	//쓰레드로 만들어서 10개정도를 동시에 돌려보자.
//	@PostConstruct
	public void main() {
		System.out.println("#GetCoinMarketCapHistory START !!!");
		try {
			commonConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/crypto", "crypto", "P@ssw0rd");;
//			commonConn = DriverManager.getConnection("jdbc:mysql://106.10.40.9:3306/crypto", "crypto", "P@ssw0rd");;
			commonS = commonConn.createStatement();
			commonConn1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/crypto", "crypto", "P@ssw0rd");
//			commonConn1 = DriverManager.getConnection("jdbc:mysql://106.10.40.9:3306/crypto", "crypto", "P@ssw0rd");;
			commonS1 = commonConn1.createStatement();
			getHistoryData();
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
	private void getHistoryData() {
		String siteName = "eos";
		int coin_id = 0;
		String query = "";
		try {
			query = "select site_symbol, coin_id from coin where site_symbol is not null";
//			query = "select sitesymbol, coin_name, coin_symbol from coin";
			commonRs = commonS.executeQuery(query);
			while(commonRs.next()) {
				siteName = commonRs.getString(1);
				coin_id = commonRs.getInt(2);
				org.jsoup.Connection.Response response = null;
				try {
					response = Jsoup.connect("https://coinmarketcap.com/currencies/" + siteName + "/historical-data/?start=20130428&end=20201231")
							.method(org.jsoup.Connection.Method.GET)
							.execute();
				} catch (HttpStatusException e) {
					System.out.println(e.toString());
					e.printStackTrace();
				}
				boolean isOk = false;
				isOk = (response != null) && (response.statusCode() == HttpURLConnection.HTTP_OK);
				if (isOk) {
					String dateStr = "";
					float openPrice, highPrice, lowPrice, closePrice = 0;
					double vol24, marketcap = 0;
					Document document = response.parse();
					Elements eles = document.getElementsByTag("tbody").get(0).getElementsByTag("tr");

					Iterator<Element> itr = eles.iterator();
					while (itr.hasNext()) {
						Element ele = itr.next();
						String val = "0";
						Elements tdEles = ele.getElementsByTag("td");
						dateStr = tdEles.get(0).text();
						val = tdEles.get(1).attr("data-format-value");
						if (val.equals("-"))
							val = "0";
						openPrice = Float.parseFloat(val);
						val = tdEles.get(2).attr("data-format-value");
						if (val.equals("-"))
							val = "0";
						highPrice = Float.parseFloat(val);
						val = tdEles.get(3).attr("data-format-value");
						if (val.equals("-"))
							val = "0";
						lowPrice = Float.parseFloat(val);
						val = tdEles.get(4).attr("data-format-value");
						if (val.equals("-"))
							val = "0";
						closePrice = Float.parseFloat(val);
						val = tdEles.get(5).attr("data-format-value");
						if (val.equals("-"))
							val = "0";
						vol24 = Double.parseDouble(val);
						val = tdEles.get(6).attr("data-format-value");
						if (val.equals("-"))
							val = "0";
						marketcap = Double.parseDouble(val);

						SimpleDateFormat format = new SimpleDateFormat("MMM dd, yyyy", new Locale("en", "US"));
						Date date = format.parse(dateStr);
						date.setHours(23);
						date.setMinutes(00);
						date.setSeconds(00);
						SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						String convertedDateStr = format1.format(date);
						query = "insert into coin_info (coin_id, market_cap_usd, price_usd, volume_24h_usd, input_date, rank, last_updated)" +
								" values ('" + coin_id + "', '" + marketcap + "', '" + closePrice + "', '" + vol24 + "', '" + convertedDateStr + "', 0, '"+convertedDateStr+"')";
						try {
							commonS1.executeUpdate(query);
						} catch (SQLException e) {
							System.out.println(e.toString());
							System.out.println(query);
						}
					}
				} else {
					System.out.println("response fail " + siteName);
				}
			}
		}
		catch(Exception e) {
			System.out.println(e.toString());
			e.printStackTrace();
			System.out.println(query);
		}
		finally {

		}
	}
	
}
