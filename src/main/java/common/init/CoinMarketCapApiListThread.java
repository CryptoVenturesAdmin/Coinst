package common.init;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import sun.net.www.protocol.http.HttpURLConnection;

import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

public class CoinMarketCapApiListThread implements Runnable {

    private int listSize;
    private static final String API_KEY = "1f5a88a5-3120-492a-a320-b544ad836d10";
//    private static final String API_KEY = "f0812c40-0468-4290-a9c9-0d7c46226085";
    private volatile boolean done = false;
    private List<Object> array = new ArrayList<Object>();
    public CoinMarketCapApiListThread(int listSize){
        this.listSize = listSize;
    }
    public void run(){
        getCoinListByRanking(this.listSize);
        done = true;
        synchronized (this){
            this.notifyAll();
        }
    }

    public void getCoinListByRanking(int listSize){
        String urlStr = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?CMC_PRO_API_KEY="+API_KEY+"&limit="+listSize;
        List<HashMap<String,Object>> returnList = null;
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
                Object errorObj = ((JSONObject)jsonResult.get("status")).get("error_code");
                if(errorObj.toString().equals("0")) {
                    JSONArray dataArray = (JSONArray) jsonResult.get("data");
                    this.array.addAll(new ArrayList(Arrays.asList(dataArray.toArray())));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public List<Object> getRtnArray(){
        if (!done){
            synchronized (this){
                try {
                    this.wait();
                }catch (InterruptedException e){
                    e.printStackTrace();
                }
            }
        }
        return this.array;
    }

}
