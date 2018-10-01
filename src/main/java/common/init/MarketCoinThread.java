package common.init;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import service.CoinService;

import java.util.HashMap;

@Component
public class MarketCoinThread extends Thread{


    private static final int HOUR = 60 * 60;
    private volatile boolean done = false;

    @Autowired private CoinService coinService;
    private MarketDataSingleton marketDataSingleton = MarketDataSingleton.getInstance();

    public void run(){
        getCoinForMarketData();
        done = true;
        synchronized (this){
            this.notifyAll();
        }
        while(true){
            try{
                Thread.sleep(HOUR * 1000);
            }catch (InterruptedException e){
                e.printStackTrace();
            }
            getCoinForMarketData();
        }
    }
    private void getCoinForMarketData(){
        marketDataSingleton.coinList = coinService.selectCoinSymbolForMarketData();
        HashMap<String,Object> paramMap = new HashMap<String,Object>();
        paramMap.put("exc_id",2);       //KRW 환율 가져오기
        marketDataSingleton.excMap = coinService.selectExchangeInfo(paramMap);
    }

    public void rtnCoinForMarketDataList(){
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
