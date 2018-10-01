package common.init;

import common.util.DateUtil;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import service.CoinService;
import sun.net.www.protocol.http.HttpURLConnection;

import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.util.HashMap;
import java.util.List;

public class MarketThread implements Runnable{

    private HashMap<String,Object> symbolMap;
    private List<HashMap<String,Object>> symbolList;
    private String marketName;
    private double exc_rate = 1;
    private volatile boolean done = false;

    public HashMap<String, Object> tempMap = new HashMap<String, Object>();
    private MarketDataSingleton marketDataSingleton = MarketDataSingleton.getInstance();

    public MarketThread(String marketName, HashMap<String,Object> symbolMap,List<HashMap<String,Object>> symbolList){
        this.marketName = marketName;
        this.symbolMap = symbolMap;
        this.symbolList = symbolList;
    }
    public void run(){
        HashMap<String,Object> excMap = marketDataSingleton.excMap;
        if(excMap.get("exc_rate") != null) {
            exc_rate = Double.parseDouble(excMap.get("exc_rate").toString());
        }
        if(marketName != null) {
            if (marketName.equals("Bithumb")) {
                getBithumbApiDataList(symbolList);
            }else if (marketName.equals("Upbit")) {
                getUpbitDataList(symbolMap);
            }else if (marketName.equals("Binance")) {
                getBinanceDataList(symbolMap);
            }else if (marketName.equals("Coinone")) {
                getCoinoneApiDataList(symbolList);
            }else if (marketName.equals("Bitfinex")) {
                getBitfinexApiDataList(symbolList);
            }
        }
        done = true;
        synchronized (this){
            this.notifyAll();
        }
    }

    private void getBithumbApiDataList(List<HashMap<String,Object>> symbolList){        //KRW 로 가져옴
        if (symbolList == null){
            return;
        }
        String urlStr = "https://api.bithumb.com/public/ticker/ALL";
        OutputStreamWriter wr = null;
        BufferedReader rd = null;
        try {
            URL url = new URL(urlStr);
            HttpsURLConnection con = null;
            con = (HttpsURLConnection) url.openConnection();
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
                if (jsonResult.get("status") != null) {
                    HashMap<String,Object> bithumbMap = null;
                    String status = jsonResult.get("status").toString();
                    if (status.equals("0000")) {
                        for (HashMap<String,Object> symbolMap : symbolList) {
                            String symbol = symbolMap.get("coin_symbol").toString();
                            bithumbMap = new HashMap<String, Object>();
                            JSONObject resObj = (JSONObject) jsonResult.get("data");
                            JSONObject dataObj = (JSONObject) resObj.get(symbol);
                            if(dataObj != null) {
                                long opening_price = 0;
                                long closing_price = 0;
                                long buy_price = 0;
                                double average_price = 0;
                                double volume_1day = 0;
                                long fluctate_24h = 0;
                                double fluctate_rate_24h = 0;
                                double percent_change_24h = Double.parseDouble(symbolMap.get("percent_change_24h_usd").toString());

                                opening_price = Integer.parseInt(dataObj.get("opening_price").toString());
                                closing_price = Integer.parseInt(dataObj.get("closing_price").toString());
                                buy_price = Integer.parseInt(dataObj.get("buy_price").toString());
                                average_price = Double.parseDouble(dataObj.get("average_price").toString());
                                volume_1day = Double.parseDouble(dataObj.get("volume_1day").toString());
                                fluctate_24h = Integer.parseInt(dataObj.get("24H_fluctate").toString());
                                fluctate_rate_24h = Double.parseDouble(dataObj.get("24H_fluctate_rate").toString());

                                bithumbMap.put("marketName", marketName);
                                bithumbMap.put("symbol", symbol);
                                bithumbMap.put("price", buy_price);
                                bithumbMap.put("volume_1d", volume_1day);
                                bithumbMap.put("volume_1d_krw", volume_1day * buy_price);
                                bithumbMap.put("fluctate_24h", fluctate_24h);
                                bithumbMap.put("fluctate_rate_24h", fluctate_rate_24h);
                                bithumbMap.put("percent_change_24h",percent_change_24h);
                                if (marketDataSingleton.bithumbDataMap.size() != symbolList.size()) {
                                    marketDataSingleton.bithumbDataMap.put(symbol, bithumbMap);
                                } else {
                                    marketDataSingleton.bithumbDataMap.replace(symbol, bithumbMap);
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void getUpbitDataList(HashMap<String,Object> symbolMap){            //KRW 로 가져옴
        String symbol = symbolMap.get("coin_symbol").toString();
        if (symbol == null){
            return;
        }
        DateUtil dateUtil = new DateUtil();
        String yesterday = dateUtil.dateEx(null,0,0,-1,0,0,0,"yyyy-MM-dd HH:mm:ss");
        String[] arrDate = yesterday.split(" ");
        String urlStr = "https://api.upbit.com/v1/ticker?markets=KRW-"+symbol;
        String subUrlStr = "https://api.upbit.com/v1/candles/minutes/1?market=KRW-"+symbol+"&to="+arrDate[0]+"T"+arrDate[1]+"-00:00";

        try {
            StringBuilder sb = getJsonResult(urlStr);
            StringBuilder subSb = getJsonResult(subUrlStr);

            if(sb != null && subSb != null) {
                JSONParser parser = new JSONParser();
                JSONArray jsonArray = (JSONArray) parser.parse(subSb.toString());

                double trade_price_1d = 0;
                for(int j = 0; j < jsonArray.size(); j++){
                    JSONObject dataObj = (JSONObject) jsonArray.get(j);
                    if(dataObj != null){
                        trade_price_1d = Double.parseDouble(dataObj.get("trade_price").toString());
                    }
                }
                jsonArray = (JSONArray) parser.parse(sb.toString());
                HashMap<String,Object> upbitMap = null;
                for (int i = 0; i < jsonArray.size(); i++) {
                    JSONObject dataObj = (JSONObject) jsonArray.get(i);
                    upbitMap = new HashMap<String,Object>();
                    if (dataObj != null) {
                        double opening_price = 0;
                        double trade_price = 0;
                        double average_price = 0;
                        double acc_trade_volume_24h = 0;
                        double change_price = 0;
                        double change_rate = 0;
                        double percent_change_24h = Double.parseDouble(symbolMap.get("percent_change_24h_usd").toString());

                        opening_price = Double.parseDouble(dataObj.get("opening_price").toString());
                        trade_price = Double.parseDouble(dataObj.get("trade_price").toString());
                        acc_trade_volume_24h = Double.parseDouble(dataObj.get("acc_trade_volume_24h").toString());
                        change_price = Double.parseDouble(dataObj.get("signed_change_price").toString());
                        change_rate = Double.parseDouble(dataObj.get("signed_change_rate").toString());


                        upbitMap.put("marketName", marketName);
                        upbitMap.put("symbol", symbol);
                        upbitMap.put("price", trade_price);
                        upbitMap.put("volume_1d", acc_trade_volume_24h);
                        upbitMap.put("volume_1d_krw", acc_trade_volume_24h * trade_price);
                        upbitMap.put("fluctate_24h", trade_price - trade_price_1d);
                        upbitMap.put("fluctate_rate_24h", (trade_price - trade_price_1d) / trade_price_1d * 100);
                        upbitMap.put("percent_change_24h",percent_change_24h);

                        if(marketDataSingleton.upbitDataMap.size() != symbolList.size()){
                            marketDataSingleton.upbitDataMap.put(symbol,upbitMap);
                        }else {
                            marketDataSingleton.upbitDataMap.replace(symbol, upbitMap);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
    private void getBinanceDataList(HashMap<String,Object> symbolMap){      //USD 로 가져옴
        String symbol = symbolMap.get("coin_symbol").toString();
        if (symbol == null){
            return;
        }
        String urlStr = "https://www.binance.com/api/v1/ticker/24hr?symbol="+symbol+"USDT";
        OutputStreamWriter wr = null;
        BufferedReader rd = null;
        try {
            URL url = new URL(urlStr);
            HttpsURLConnection con = null;
            con = (HttpsURLConnection) url.openConnection();
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
                JSONObject dataObj = (JSONObject) parser.parse(sb.toString());
                HashMap<String,Object> binanceMap = null;
                if (dataObj.get("code") == null) {
                    binanceMap = new HashMap<String, Object>();
                    double closing_price = 0;
                    double lastPrice = 0;
                    double volume = 0;
                    double priceChange = 0;
                    double priceChangePercent = 0;
                    double percent_change_24h = Double.parseDouble(symbolMap.get("percent_change_24h_usd").toString());

                    closing_price = Double.parseDouble(dataObj.get("prevClosePrice").toString());
                    lastPrice = Double.parseDouble(dataObj.get("lastPrice").toString());
                    volume = Double.parseDouble(dataObj.get("volume").toString());
                    priceChange = Double.parseDouble(dataObj.get("priceChange").toString());
                    priceChangePercent = Double.parseDouble(dataObj.get("priceChangePercent").toString());


                    binanceMap.put("marketName", marketName);
                    binanceMap.put("symbol", symbol);
                    binanceMap.put("price", lastPrice * exc_rate);
                    binanceMap.put("volume_1d", volume);
                    binanceMap.put("volume_1d_krw", volume * lastPrice * exc_rate);
                    binanceMap.put("fluctate_24h", priceChange * exc_rate);
                    binanceMap.put("fluctate_rate_24h", priceChangePercent);
                    binanceMap.put("percent_change_24h",percent_change_24h);

                    if (marketDataSingleton.binanceDataMap.size() != symbolList.size()) {
                        marketDataSingleton.binanceDataMap.put(symbol, binanceMap);
                    } else {
                        marketDataSingleton.binanceDataMap.replace(symbol, binanceMap);
                    }

                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void getCoinoneApiDataList(List<HashMap<String,Object>> symbolList){        //KRW 로 가져옴
        if (symbolList == null){
            return;
        }
        String urlStr = "https://api.coinone.co.kr/ticker?format=json&currency=all";
        OutputStreamWriter wr = null;
        BufferedReader rd = null;
        try {
            URL url = new URL(urlStr);
            HttpsURLConnection con = null;
            con = (HttpsURLConnection) url.openConnection();
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
                HashMap<String,Object> coinoneMap = null;
                if(jsonResult.get("result") != null) {
                    for (HashMap<String,Object> symbolMap : symbolList) {
                        String symbol = symbolMap.get("coin_symbol").toString();
                        JSONObject dataObj = (JSONObject) jsonResult.get(symbol.toLowerCase());
                        coinoneMap = new HashMap<String,Object>();
                        if (dataObj != null) {
                            String currency = null;
                            long yesterday_last = 0;
                            long lastPrice = 0;
                            double volume = 0;
                            long priceChange = 0;
                            double priceChangePercent = 0;
                            double percent_change_24h = Double.parseDouble(symbolMap.get("percent_change_24h_usd").toString());

                            yesterday_last = Integer.parseInt(dataObj.get("yesterday_last").toString());
                            lastPrice = Integer.parseInt(dataObj.get("last").toString());
                            volume = Double.parseDouble(dataObj.get("volume").toString());
                            priceChange = lastPrice - yesterday_last;
                            priceChangePercent = ((double) priceChange / yesterday_last) * 100;


                            coinoneMap.put("marketName", marketName);
                            coinoneMap.put("symbol", symbol);
                            coinoneMap.put("price", lastPrice);
                            coinoneMap.put("volume_1d", volume);
                            coinoneMap.put("volume_1d_krw", volume * lastPrice);
                            coinoneMap.put("fluctate_24h", priceChange);
                            coinoneMap.put("fluctate_rate_24h", priceChangePercent);
                            coinoneMap.put("percent_change_24h",percent_change_24h);

                            if(marketDataSingleton.coinoneDataMap.size() != symbolList.size()){
                                marketDataSingleton.coinoneDataMap.put(symbol,coinoneMap);
                            }else {
                                marketDataSingleton.coinoneDataMap.replace(symbol, coinoneMap);
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void getBitfinexApiDataList(List<HashMap<String,Object>> symbolList){           //USD 로 가져옴
        if (symbolList == null){
            return;
        }
        String symbolStr = "";
        for (HashMap<String,Object> symbolMap : symbolList){
            String symbolName = symbolMap.get("coin_symbol").toString();
            symbolStr += "t" + symbolName + "USD,";
        }
        if(!symbolStr.equals("")) {
            symbolStr = symbolStr.substring(0, symbolStr.length() - 1);
        }

        String urlStr = "https://api.bitfinex.com/v2/tickers?symbols="+symbolStr;        //https://api.bitfinex.com/v2/tickers?symbols=tBTCUSD,tLTCUSD
        OutputStreamWriter wr = null;
        BufferedReader rd = null;
        try {
            URL url = new URL(urlStr);
            HttpsURLConnection con = null;
            con = (HttpsURLConnection) url.openConnection();
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
                JSONArray jsonArray = (JSONArray) parser.parse(sb.toString());
                if(jsonArray.size() != 0) {
                    for(int i = 0; i < jsonArray.size(); i++) {
                        HashMap<String,Object> bitfinexMap = new HashMap<String,Object>();
                        JSONArray dataArray = (JSONArray) jsonArray.get(i);
                        String symbol = dataArray.get(0).toString().substring(1,4);
                        double daily_change = Double.parseDouble(dataArray.get(5).toString());
                        double daily_change_perc = Double.parseDouble(dataArray.get(6).toString());
                        double last_price = Double.parseDouble(dataArray.get(7).toString());
                        double volume = Double.parseDouble(dataArray.get(8).toString());
                        double percent_change_24h = 0;
                        for(HashMap<String,Object> symbolMap : symbolList){
                            if(symbol.equals(symbolMap.get("coin_symbol").toString())) {
                                percent_change_24h = Double.parseDouble(symbolMap.get("percent_change_24h_usd").toString());
                            }
                        }

                        bitfinexMap.put("marketName", marketName);
                        bitfinexMap.put("symbol", symbol);
                        bitfinexMap.put("price", last_price * exc_rate);
                        bitfinexMap.put("volume_1d", volume);
                        bitfinexMap.put("volume_1d_krw", volume * last_price * exc_rate);
                        bitfinexMap.put("fluctate_24h", daily_change * exc_rate);
                        bitfinexMap.put("fluctate_rate_24h", daily_change_perc * 100);
                        bitfinexMap.put("percent_change_24h",percent_change_24h);

                        if(marketDataSingleton.bitfinexDataMap.size() != symbolList.size()){
                            marketDataSingleton.bitfinexDataMap.put(symbol,bitfinexMap);
                        }else{
                            marketDataSingleton.bitfinexDataMap.replace(symbol,bitfinexMap);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private StringBuilder getJsonResult(String urlStr){
        OutputStreamWriter wr = null;
        BufferedReader rd = null;
        HashMap<String,Object> rtnMap = new HashMap<String,Object>();
        StringBuilder sb = new StringBuilder();
        boolean isOk = false;
        try {
            URL url = new URL(urlStr);
            HttpsURLConnection con = null;
            con = (HttpsURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            con.setDoOutput(true);
            con.connect();
            int responseCode = con.getResponseCode();

            if (responseCode == HttpURLConnection.HTTP_OK) {
                rd = new BufferedReader(new InputStreamReader(con.getInputStream()));
                isOk = true;
            } else {
                rd = new BufferedReader(new InputStreamReader(con.getErrorStream()));
            }
            String line = null;
            while ((line = rd.readLine()) != null) {
                sb.append(line);
            }
            rd.close();
            rd = null;
        } catch (Exception e) {
            e.printStackTrace();
        }
        if(!isOk){
            sb = null;
        }
        return sb;
    }

    public void getRtnArray(){
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
