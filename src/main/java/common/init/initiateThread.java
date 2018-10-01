package common.init;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

@Component
public class initiateThread extends Thread {
    private static final int HOUR = 60 * 60;
    private static final int DAY = 60 * 60 * 24;

    @Autowired private CoinMarketCapApiMain capApi;
    @Autowired private CoinMarketCalApi calApi;
    @Autowired private GetCoinMarketCapLink capLink;
    @Autowired private GetCoinMarketCapHistory capHistory;
    @Autowired private GetExchangeInfoApi excApi;
    @Autowired private MarketApiMain market;

    @PostConstruct
    public void apiRun(){
        this.start();
    }

    public void run(){		//일당으로 coinMarketCal에서 데이터 받아오기

        /*long startTime = 0;
        long capApiEndTime = 0;
        long calApiStartTime = 0;
        long calApiTerm = 0;
        long capApiTerm = 0;
        int count = 0;*/

        market.start();
        //capLink.main();
//        capHistory.main();
//        System.out.println("Link END!!!!");
//        calApi.main();

        final ScheduledThreadPoolExecutor execCap = new ScheduledThreadPoolExecutor(1);
        execCap.scheduleAtFixedRate(new Thread(() -> {
            excApi.main();
            capApi.main();
        }),0,3, TimeUnit.HOURS);

        final ScheduledThreadPoolExecutor execCal = new ScheduledThreadPoolExecutor(1);
        execCal.scheduleAtFixedRate(new Thread(() -> {
            calApi.main();        //coinmarketcal API 가져오기
        }),1,1,TimeUnit.DAYS);

        /*while(true) {
            count = 0;
            while(true){
                startTime = System.currentTimeMillis();     //cap 시작시간
                if(calApiStartTime != 0) {
                    startTime = calApiStartTime;
                    calApiStartTime = 0;
                }
//                excApi.main();
                capApi.main();
                capApiEndTime = System.currentTimeMillis();             //cap 종료시간
                capApiTerm = capApiEndTime - startTime;
//                if(capApiTerm < HOUR * 1000){
                if(capApiTerm < HOUR*1000){
                    try {
                        Thread.sleep((HOUR*1000) - capApiTerm);       //cap term시간 제외하고 sleep
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                if(count == 23) {       //24시간에 1번 break
                    break;
                }
                count ++;
            }
            calApiStartTime = System.currentTimeMillis();       //cal 시작시간
            calApi.main();        //coinmarketcal API 가져오기
        }*/
    }
}
