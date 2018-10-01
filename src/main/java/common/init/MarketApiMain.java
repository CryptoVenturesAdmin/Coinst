package common.init;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import service.CoinService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

@Component
public class MarketApiMain extends Thread{

    @Autowired private CoinService coinService;
    @Autowired private MarketCoinThread marketCoinThread;
    private MarketDataSingleton marketDataSingleton = MarketDataSingleton.getInstance();
    public void run(){
        List<MarketThread> marketThreadList = new ArrayList<MarketThread>();
        List<Thread> threadList = new ArrayList<Thread>();

        /*List<String> symbolList = new ArrayList<String>();
        symbolList.add("BTC");
        symbolList.add("ETH");
        symbolList.add("XRP");*/
        marketCoinThread.start();
        marketCoinThread.rtnCoinForMarketDataList();

        final ScheduledThreadPoolExecutor execMarket = new ScheduledThreadPoolExecutor(1);
        execMarket.scheduleAtFixedRate(new Thread(() -> {
            for(HashMap<String,Object> symbolMap: marketDataSingleton.coinList) {
//                String symbolName = symbolMap.get("coin_symbol").toString();
                MarketThread upbitApi = new MarketThread("Upbit",symbolMap,marketDataSingleton.coinList);               //업비트 api Thread
                Thread upbitTread = new Thread(upbitApi);
                marketThreadList.add(upbitApi);
                threadList.add(upbitTread);

                MarketThread binanceApi = new MarketThread("Binance",symbolMap,marketDataSingleton.coinList);         //바이낸스 api Thread
                Thread binanceTread = new Thread(binanceApi);
                marketThreadList.add(binanceApi);
                threadList.add(binanceTread);
            }

            for (Thread t : threadList){
                t.start();
            }

            MarketThread bitfinexApi = new MarketThread("Bitfinex",null,marketDataSingleton.coinList);         //bitfinex api Thread
            Thread bitfinexTread = new Thread(bitfinexApi);
            bitfinexTread.start();
            MarketThread bithumbApi = new MarketThread("Bithumb",null,marketDataSingleton.coinList);         //빗썸 api Thread
            Thread bithumbTread = new Thread(bithumbApi);
            bithumbTread.start();
            MarketThread coinoneApi = new MarketThread("Coinone",null,marketDataSingleton.coinList);         //코인원 api Thread
            Thread coinoneTread = new Thread(coinoneApi);
            coinoneTread.start();


            bitfinexApi.getRtnArray();

            for(MarketThread m : marketThreadList){
                m.getRtnArray();
            }
            bithumbApi.getRtnArray();
            coinoneApi.getRtnArray();

            threadList.clear();

        }),0,3, TimeUnit.SECONDS);
    }
}
