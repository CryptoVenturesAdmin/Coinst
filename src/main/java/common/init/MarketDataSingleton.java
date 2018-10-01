package common.init;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class MarketDataSingleton {
    private volatile static MarketDataSingleton ourInstance;

    public static MarketDataSingleton getInstance() {
        if (ourInstance == null){
            synchronized (MarketDataSingleton.class){
                if(ourInstance == null){
                    ourInstance = new MarketDataSingleton();
                }
            }
        }

        return ourInstance;
    }
    public static List<HashMap<String,Object>> coinList = null;
    public static HashMap<String,Object> excMap = null;
    public static HashMap<String,HashMap<String,Object>> bithumbDataMap = null;
    public static HashMap<String,HashMap<String,Object>> upbitDataMap = null;
    public static HashMap<String,HashMap<String,Object>> binanceDataMap = null;
    public static HashMap<String,HashMap<String,Object>> coinoneDataMap = null;
    public static HashMap<String,HashMap<String,Object>> bitfinexDataMap = null;
    private MarketDataSingleton() {
        coinList = new ArrayList<HashMap<String,Object>>();
        excMap = new HashMap<String,Object>();
        bithumbDataMap = new HashMap<String,HashMap<String,Object>>();
        upbitDataMap = new HashMap<String,HashMap<String,Object>>();
        binanceDataMap = new HashMap<String,HashMap<String,Object>>();
        coinoneDataMap = new HashMap<String,HashMap<String,Object>>();
        bitfinexDataMap = new HashMap<String,HashMap<String,Object>>();
    }
    public void allDataClear(){
        bithumbDataMap.clear();
        upbitDataMap.clear();
        binanceDataMap.clear();
        coinoneDataMap.clear();
        bitfinexDataMap.clear();
    }
}
