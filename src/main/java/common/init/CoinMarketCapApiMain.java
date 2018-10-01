package common.init;


import common.util.CommonUtil;
import common.util.DBConnection;
import common.util.DateUtil;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.omg.PortableInterceptor.SYSTEM_EXCEPTION;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import service.ApiService;
import sun.net.www.protocol.http.HttpURLConnection;

import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;

@Component
public class CoinMarketCapApiMain{
	public static ResultSet commonRs = null;
	public static Connection commonConn = null;
	public static PreparedStatement pstmt = null;
	public static ResultSet commonRs1 = null;
	public static Connection commonConn1 = null;
	public static PreparedStatement pstmt1 = null;

	public static final String API_KEY = "1f5a88a5-3120-492a-a320-b544ad836d10";
//	public static final String API_KEY = "f0812c40-0468-4290-a9c9-0d7c46226085";
//	private static final String[] SPRING_CONFIG_XML = new String[] {"dispatcher-servlet.xml"};
	private static CommonUtil commonUtil = new CommonUtil();
	private static DBConnection DBConn = DBConnection.getInstance();

	/*private int startNum;
	private int endNum;
	private int size;*/

	//쓰레드로 만들어서 10개정도를 동시에 돌려보자.
	/*public CoinMarketCapApiMain(int startNum, int endNum, int size){
		this.startNum = startNum;
		this.endNum = endNum;
		this.size = size;
	}*/
	private int listSize = 0;
	public void main() {		//시간당으로 coinMarketCap에서 데이터 받아오기
		System.out.println("#CoinMarketCapApiMain Thread START !!!");
		try {
			Class.forName("org.gjt.mm.mysql.Driver");
			commonConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/crypto", "crypto", "P@ssw0rd");
			commonConn.setAutoCommit(false);			//오토 커밋 false
			try {
				getCoinList();
				List<Object> capList = new ArrayList<Object>();
				/*List<CoinMarketCapApiListThread> marketcapApiThreadList = new ArrayList<CoinMarketCapApiListThread>();
				List<Thread> threadList = new ArrayList<Thread>();*/
				CoinMarketCapApiListThread coinMarketThread = new CoinMarketCapApiListThread(this.listSize);
				Thread capRank = new Thread(coinMarketThread);
				capRank.start();
				capList.addAll(coinMarketThread.getRtnArray());
				/*threadList.add(capRank);
				marketcapApiThreadList.add(coinMarketThread);*/
				/*for(Thread t : threadList) {									//marketcap 페이지 접근 스레드 start
					t.start();
				}
				for(CoinMarketCapApiListThread c: marketcapApiThreadList){			//받아온 marketcap 랭크순 리스트
					capList.addAll(c.getRtnArray());
				}*/
				getCoinValueList(capList);
				commonConn.commit();
			}catch(SQLException e){
				commonConn.rollback();
				System.out.println(e.toString());
			}

		}
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			if (commonRs != null) {
				try {
					commonRs.close();
				} catch (SQLException e) {
				}
			}
			commonRs = null;
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (SQLException e) {
				}
			}
			pstmt = null;
			if (pstmt1 != null){
				try {
					pstmt1.close();
				}catch (SQLException e){
				}
			}
			pstmt1 = null;
			if (commonConn != null) {
				try {
					commonConn.close();
				} catch (SQLException e) {
				}
			}
			commonConn = null;
		}
	}


	private static String validateStr(String str) {
		if(str.indexOf("\'") >=  0) {
			str = str.replace("\'", "");
		}
		return str;
	}
	private static boolean checkSchedule() {
		String query = "";
		try {
			//TODO 스케쥴링 결과 확인.
			//TODO 텔레그램 봇으로 결과 쏴주기.
			query = "select startflag";
			pstmt.executeUpdate(query);
		}
		catch(SQLException e) {
			System.out.println(e.toString());
			System.out.println(query);
		}
		return true;
	}
	private static void getGlobalData() {
		OutputStreamWriter wr = null;
		BufferedReader rd = null;
		String query = "";
		try {
			URL url = new URL("https://api.coinmarketcap.com/v2/global/");
			HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			con.setDoOutput(true);
			con.connect();
			int responseCode = con.getResponseCode();
			boolean isOk = false;
			if(responseCode == HttpURLConnection.HTTP_OK) {
				rd = new BufferedReader(new InputStreamReader(con.getInputStream()));
				isOk = true;
			}
			else {
				rd = new BufferedReader(new InputStreamReader(con.getErrorStream()));				
			}
			String line = null;
			StringBuilder sb = new StringBuilder();
			while((line = rd.readLine()) != null) {
				sb.append(line);
			}
			rd.close();
			rd = null;
			if(isOk) {
				JSONParser parser = new JSONParser();
				JSONObject jsonResult = (JSONObject) parser.parse(sb.toString());
				Object errorObj = ((JSONObject)jsonResult.get("metadata")).get("error");
				if(errorObj == null) {
					JSONObject obj = (JSONObject)jsonResult.get("data");
					int marketCount, currencyCount = 0;
					float bitPer = 0;
					double vol24Usd, marketcapUsd = 0;
					
					marketCount = Integer.parseInt(obj.get("active_markets").toString());
					currencyCount = Integer.parseInt(obj.get("active_cryptocurrencies").toString());
					bitPer = Float.parseFloat(obj.get("bitcoin_percentage_of_market_cap").toString());
					JSONObject quotes = (JSONObject)obj.get("quotes");
					JSONObject usdObj = (JSONObject)quotes.get("USD");
					vol24Usd = Double.parseDouble(usdObj.get("total_volume_24h").toString());
					marketcapUsd = Double.parseDouble(usdObj.get("total_market_cap").toString());
					query = "insert into totalcap (regdate, marketcap_usd, vol_24_usd, bit_per, currencycount, marketcount) "
							+ "values(now(), "+marketcapUsd+","+vol24Usd+","+bitPer+","+currencyCount+","+marketCount+")";
					try {
						pstmt = commonConn.prepareStatement(query);
						pstmt.executeUpdate(query);
					} catch(SQLException e) {

						System.out.println(e.toString());
						System.out.println(query);
					}
				}
			}
			else {
				System.out.print("response fail \n" +sb.toString());
			}
		}
		catch(Exception e) {
			System.out.println(e.toString());
			System.out.println(query);
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
	}
	private void getCoinList(){
		OutputStreamWriter wr = null;
		BufferedReader rd = null;
		String query = "";
		try {
			URL url = new URL("https://pro-api.coinmarketcap.com/v1/cryptocurrency/map?listing_status=active&CMC_PRO_API_KEY="+API_KEY);
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
			if (isOk) {
				JSONParser parser = new JSONParser();
				JSONObject jsonResult = (JSONObject) parser.parse(sb.toString());
				Object errorObj = ((JSONObject)jsonResult.get("status")).get("error_code");
				if(errorObj.toString().equals("0")) {
					JSONArray array = (JSONArray)jsonResult.get("data");
					System.out.print("# size " +array.size());
					listSize = array.size();
					DateUtil dateUtil = new DateUtil();
					String time = dateUtil.dateEx(null,0,0,0,0,0,0,"yyyy-MM-dd HH:mm:ss");
					System.out.println(time);
					String name, symbol, siteName;
					int id = 0;
					String notExistQuery = "";
					for(int i = 0; i < array.size(); i++) {
						JSONObject obj = (JSONObject)array.get(i);
						id = Integer.parseInt(obj.get("id").toString());
						name = obj.get("name").toString();
						symbol = obj.get("symbol").toString();
						siteName = obj.get("slug").toString();
						name = validateStr(name);
						notExistQuery += id+",";
						String telegramText = name+"%20("+symbol+")%20%EC%9D%B4%20%EC%83%81%EC%9E%A5%EB%90%98%EC%97%88%EC%8A%B5%EB%8B%88%EB%8B%A4.%0A%EC%83%81%EC%9E%A5%EC%A0%95%EB%B3%B4%20%ED%99%95%EC%9D%B8%20http://www.coinst.kr/coin/coinDetail?id=";
						query = "select coin_name, coin_symbol,site_symbol from coin where coin_id = ?";
						pstmt = commonConn.prepareStatement(query);
						pstmt.setInt(1,id);
						commonRs = pstmt.executeQuery();
						pstmt.clearParameters();
						if(!commonRs.next()) {
							query = "select ico_id from ico where ico_name = ? and ico_symbol = ? and ico_state = 2";
							pstmt = commonConn.prepareStatement(query);
							pstmt.setString(1,name);
							pstmt.setString(2,symbol);
							commonRs = pstmt.executeQuery();
							pstmt.clearParameters();
							int ico_id = 0;
							if(commonRs.next()){
								ico_id = commonRs.getInt(1);
								/*query = "insert into coin (coin_id, coin_name, coin_symbol, site_symbol, coin_state, ico_id) " +
										"values("+id+",'"+name+"', '"+symbol+"', '"+siteName+"', 0, "+ico_id+"); ";*/
								query = "insert into coin (coin_id, coin_name, coin_symbol, site_symbol, coin_state, ico_id) " +
										"values(?, ?, ?, ?, 0, ?); ";
								pstmt = commonConn.prepareStatement(query);
								pstmt.setInt(1,id);
								pstmt.setString(2,name);
								pstmt.setString(3,symbol);
								pstmt.setString(4,siteName);
								pstmt.setInt(5,ico_id);
								pstmt.executeUpdate();
								pstmt.clearParameters();
								query = "update ico set ico_state = 1 where ico_id = ?;";
								pstmt = commonConn.prepareStatement(query);
								pstmt.setInt(1,ico_id);
								pstmt.executeUpdate();
								pstmt.clearParameters();
							}else {
								query = "select (ifnull(max(ico_id),0)+1) as ico_id from ico";
								pstmt = commonConn.prepareStatement(query);
								commonRs = pstmt.executeQuery();
								if(commonRs.next()){ ico_id = commonRs.getInt(1); }
								query = "insert into ico (ico_id, ico_name, ico_symbol, ico_type) " +
										"values(?, ?, ?, null); ";
								pstmt = commonConn.prepareStatement(query);
								pstmt.setInt(1,ico_id);
								pstmt.setString(2,name);
								pstmt.setString(3,symbol);
								pstmt.executeUpdate();
								pstmt.clearParameters();
								query = "insert into coin (coin_id, coin_name, coin_symbol, site_symbol, coin_state, ico_id) " +
										"values(?, ?, ?, ?, 0, ?);";
								pstmt = commonConn.prepareStatement(query);
								pstmt.setInt(1,id);
								pstmt.setString(2,name);
								pstmt.setString(3,symbol);
								pstmt.setString(4,siteName);
								pstmt.setInt(5,ico_id);
								pstmt.executeUpdate();
								pstmt.clearParameters();
							}

							// 텔레그램 메시지
							URL telegramUrl = new URL("https://api.telegram.org/bot675599484:AAHDKwAKg5YRM7sFcXs918w3JuInRNmbMNg/sendMessage?chat_id=-1001295217972&text="+telegramText+ico_id);
							HttpsURLConnection telegramCon = (HttpsURLConnection) telegramUrl.openConnection();
							telegramCon.setRequestMethod("GET");
							telegramCon.setDoOutput(true);
							telegramCon.connect();

							int resCode = telegramCon.getResponseCode();
							if (resCode == HttpURLConnection.HTTP_OK) {
								System.out.println(telegramText);
							} else {
								System.out.println("Error : "+telegramText);
							}
						}else{
							String coin_name = commonRs.getString(1);
							String coin_symbol = commonRs.getString(2);
							String site_symbol = commonRs.getString(3);

							if(!coin_name.equals(name) || !coin_symbol.equals(symbol) || !site_symbol.equals(siteName) ){
								query = "update coin set coin_name = ?, coin_symbol = ?, site_symbol = ? where coin_id = ?";
								pstmt = commonConn.prepareStatement(query);
								pstmt.setString(1,name);
								pstmt.setString(2,symbol);
								pstmt.setString(3,siteName);
								pstmt.setInt(4,id);
								pstmt.executeUpdate();
								pstmt.clearParameters();
								query = "update ico set ico_name = ?, ico_symbol = ? where ico_id = (select ico_id from coin where coin_id = ?)";
								pstmt = commonConn.prepareStatement(query);
								pstmt.setString(1,name);
								pstmt.setString(2,symbol);
								pstmt.setInt(3,id);
								pstmt.executeUpdate();
								pstmt.clearParameters();
							}
						}
					}
					notExistQuery = notExistQuery.substring(0,notExistQuery.length() - 1);
					query = "update coin set coin_state = 1 where coin_id not in ("+notExistQuery+"); ";
					pstmt = commonConn.prepareStatement(query);
					pstmt.executeUpdate();
					query = "update coin set coin_state = 0 where coin_id in ("+notExistQuery+");";
					pstmt = commonConn.prepareStatement(query);
					pstmt.executeUpdate();
					/*try {
						commonConn.commit();
					}catch(SQLException e){
						commonConn.rollback();
						System.out.println(e.toString());
						System.out.println(query);
					}*/
				}
			} else {
				System.out.print("response fail \n" + sb.toString());
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
	
	private void getCoinValueList(List<Object> capList){
		OutputStreamWriter wr = null;
		BufferedReader rd = null;
		String query = "";
		DateUtil dateUtil = new DateUtil();
		String today = dateUtil.dateEx(null,0,0,0,0,0,0,"yyyy-MM-dd HH:00:00");
		try {
			String name, symbol, siteName;
			String last_updated = "";
			int id = 0;
			int rank = 0;
			float cirSup = 0;
			float totalSup = 0;
			float maxSup = 0;
			float priceUsd = 0;
			float priceBtc = 0;
			double vol24Usd = 0;
			double vol24Btc = 0;
			double marketcap = 0;
			float change1UsdPercent = 0;
			float change24UsdPercent = 0;
			float change7dUsdPercent = 0;
			float change24BtcPercent = 0;

			System.out.println("# size " +capList.size());
			CoinMarketCapApiLastUpdatedThread lastUpdatedThread = new CoinMarketCapApiLastUpdatedThread(capList, commonConn);		//Coin테이블 last_updated 수정 Thread로 처리
			Thread lastUpdated = new Thread(lastUpdatedThread);
			lastUpdated.start();
			lastUpdatedThread.checkLastUpdatedEnd();

			query = "insert into coin_info (coin_id, input_date,  rank, before_1m_rank, circulating_supply, total_supply , max_supply, price_usd,"
					+ " price_btc, volume_24h_usd, volume_24h_btc, market_cap_usd, percent_change_24h_usd, percent_change_24h_btc, "
					+ " percent_change_7d_usd, last_updated) "
					+ "values(?, ?, ?, ifnull(?,0),?, ?, ?, ?"
					+ ", ?, ?, ?, ?, ?, ?"
					+ ", ?, ?);";
			pstmt1 = commonConn.prepareStatement(query);

			for(int i = 0; i < capList.size(); i++) {
				JSONObject obj = (JSONObject) capList.get(i);
				id = Integer.parseInt(obj.get("id").toString());
				name = obj.get("name").toString();
				symbol = obj.get("symbol").toString();
				siteName = obj.get("slug").toString();
				rank = Integer.parseInt(obj.get("cmc_rank").toString());
				if (obj.get("circulating_supply") != null) {
					cirSup = Float.parseFloat(obj.get("circulating_supply").toString());
				} else {
					cirSup = 0;
				}
				if (obj.get("total_supply") != null){
					totalSup = Float.parseFloat(obj.get("total_supply").toString());
				} else {
					totalSup = 0;
				}
				if (obj.get("max_supply") != null) {
					maxSup = Float.parseFloat(obj.get("max_supply").toString());
				} else {
					maxSup = 0;
				}
				JSONObject quotes = (JSONObject) obj.get("quote");
				if (quotes.get("USD") != null) {
					JSONObject usdObj = (JSONObject) quotes.get("USD");
					if (usdObj.get("price") != null){
						priceUsd = Float.parseFloat(usdObj.get("price").toString());
					} else {
						priceUsd = 0;
					}
					if (usdObj.get("volume_24h") != null) {
						vol24Usd = Double.parseDouble(usdObj.get("volume_24h").toString());
					} else {
						vol24Usd = 0;
					}
					if (usdObj.get("market_cap") != null){
						marketcap = Double.parseDouble(usdObj.get("market_cap").toString());
					} else {
						marketcap = 0;
					}
					if (usdObj.get("percent_change_1h") != null){
						change1UsdPercent = Float.parseFloat(usdObj.get("percent_change_1h").toString());
					} else {
						change1UsdPercent = 0;
					}
					if (usdObj.get("percent_change_24h") != null){
						change24UsdPercent = Float.parseFloat(usdObj.get("percent_change_24h").toString());
					} else {
						change24UsdPercent = 0;
					}
					if (usdObj.get("percent_change_7d") != null) {
						change7dUsdPercent = Float.parseFloat(usdObj.get("percent_change_7d").toString());
					} else {
						change7dUsdPercent = 0;
					}
				}
				if(obj.get("last_updated") != null){
					last_updated = obj.get("last_updated").toString();
					last_updated = last_updated.substring(0,10)+" "+last_updated.substring(11,19);
				}



//							System.out.println(rank + " ,"+symbol+ ","+cirSup+ ","+totalSup+ ","+maxSup+ ","+priceUsd+ ","+vol24Usd+ ","+marketcap+ ","+change24UsdPercent+ ","+priceBtc);
				name = validateStr(name);
				String before_1m = dateUtil.dateEx(today, 0, -1, 0, 0, 0, 0, "yyyy-MM-dd HH:00:00");
				int before_1m_rank = 0;
				query = "select rank from coin_info where coin_id = ? and input_date = ? limit 0,1; ";
				pstmt = commonConn.prepareStatement(query);
				pstmt.setInt(1,id);
				pstmt.setString(2,before_1m);
				commonRs = pstmt.executeQuery();
				if(commonRs.next()){
					before_1m_rank = commonRs.getInt(1);
				}
				pstmt.clearParameters();

				pstmt1.setInt(1,id);
				pstmt1.setString(2,today);
				pstmt1.setInt(3,rank);
				pstmt1.setInt(4,before_1m_rank);
				pstmt1.setDouble(5,cirSup);
				pstmt1.setDouble(6,totalSup);
				pstmt1.setDouble(7,maxSup);
				pstmt1.setDouble(8,priceUsd);
				pstmt1.setDouble(9,priceBtc);
				pstmt1.setDouble(10,vol24Usd);
				pstmt1.setDouble(11,vol24Btc);
				pstmt1.setDouble(12,marketcap);
				pstmt1.setDouble(13,change24UsdPercent);
				pstmt1.setDouble(14,change24BtcPercent);
				pstmt1.setDouble(15,change7dUsdPercent);
				pstmt1.setString(16,last_updated);
				pstmt1.addBatch();
				pstmt1.clearParameters();
			}
			pstmt1.executeBatch();
			pstmt1.clearBatch();
			query = "select price_usd,input_date from coin_info where input_date = (select max(input_date) from coin_info) and coin_id = 1 limit 0,1";
			pstmt = commonConn.prepareStatement(query);
			commonRs = pstmt.executeQuery();
			double btc_price = 0;
			String max_date = "";
			if(commonRs.next()){
				btc_price = commonRs.getDouble(1);
				max_date = commonRs.getString(2);
				query = "update coin_info set price_btc = price_usd/? where input_date = ?";
				pstmt1 = commonConn.prepareStatement(query);
				pstmt1.setDouble(1,btc_price);
				pstmt1.setString(2,max_date);
			}
			pstmt1.executeUpdate();
			/*ry {
				commonConn.commit();
			}catch (SQLException e){
				commonConn.rollback();
				e.printStackTrace();
			}*/
			String time = dateUtil.dateEx(null,0,0,0,0,0,0,"yyyy-MM-dd HH:mm:ss");
			System.out.println(time);
		}
		catch(Exception e) {

			System.out.println(e.toString());
			e.printStackTrace();
			System.out.println(query);
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
	}
}
