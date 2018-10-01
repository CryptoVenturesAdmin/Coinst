function isNull(object){
    var res = false;
    if(object == undefined || object == null ||  object  == '' || object.length == 0){
        res = true;
    }
    return res;
}

function CommonForm(id){
    this.id = id
    var $form = $("<form id='"+id+"' method='post'></form>");
    $form.appendTo('body');
    this.setUrl = function(url){
        $('#'+this.id).attr('action',url);
    }
    this.addParam = function(name,value){
        $('#'+this.id).append("<input type='hidden' name='"+name+"' value='"+value+"'>");
    }
    this.submit = function(){
        $('#'+this.id).submit();
    }
}

function checkID(id){
    var idVal = id.val();
    var idReg = /^[a-z]+[a-z0-9]{5,19}$/g;
    var res = false;
    if(!idReg.test(idVal)){
        alert("ID는 영문자로 시작하는 6~20자 영문자 또는 숫자이어야 합니다.");
        id.focus();
        res = true;
    }
    return res;
}
function checkPASS(pass1,pass2){
    var passVal1 = pass1.val();
    var passVal2 = pass2.val();
    var passReg = /^.*(?=.{8,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
    var res = false;
    if(passVal1 != passVal2){
        alert("비밀번호가 동일하지않습니다.");
        pass1.focus();
        res = true;
    }

    if(!passReg.test(passVal1)){
        alert("비밀번호를 확인하세요.\n(영문,숫자를 혼합하여 6~20자 이내)");
        pass1.focus();
        res = true;
    }
    return res
}
function common_init(){
    $('.onlyKor').keydown(function(){
        return is_val('han',event,this);
    });
    $('.onlyNum').keydown(function(e){
        e = window.event || e || e.which;
        if(e.ctrlKey && e.keyCode == 8){
            return;
        }
        var inputVal = $(this).val();
        $(this).val(inputVal.replace(/[^0-9]/gi,''));
    })
    //reflash
    if(false) {
        $("*").keydown(function (e) {
            e = window.event || e || e.which;
            if (
                (e.ctrlKey &&e.keyCode == 8)  //back
                || e.keyCode == 116    //F5
                || e.keyCode == 112    // F1 new
                || (e.ctrlKey && e.keyCode == 82) // ctrl+R
                || (e.ctrlKey && e.keyCode == 78) // ctrl + n
                || (e.shiftKey && e.keyCode == 121) //shift+F10
            ) {
                e.keyCode = 0;
                return false;
            }
        });
    }
    //right mouse
    if(false){
        $(document).on("contextmenu",function(e){return false;});
    }

    $('.dateFormat').each(function(){
        var dateFormat = $(this).text();
        if(dateFormat.length > 0){
            $(this).text(dateFormat.substring(5,7)+'월 '+dateFormat.substring(8,10)+'일');
        }
    });
    $('.dateFormatAddYear').each(function(){
        var dateFormatAddYear = $(this).text();
        if(dateFormatAddYear.length > 0){
            $(this).text(dateFormatAddYear.substring(0,4)+'년 '+dateFormatAddYear.substring(5,7)+'월 '+dateFormatAddYear.substring(8,10)+'일');
        }
    });
    $('.prefixZeroDot').each(function(){
       var prefixZeroDot = $.trim($(this).text());
       var prefixLoc = 0;
       if(prefixZeroDot.length > 0) {
           var count = 0;
           for (var i = (prefixZeroDot.length - 1); i >= 0; i--) {
               if (prefixZeroDot.substring(i, prefixZeroDot.length - count) != '0') {
                   if (prefixZeroDot.substring(i, prefixZeroDot.length - count) == '.') {
                       prefixLoc = i;
                   } else if (prefixZeroDot.substring(i, prefixZeroDot.length - count) == '-') {

                   } else {
                       prefixLoc = i + 1;
                   }
                   break;
               }
               count++;
           }
           if (prefixLoc != 0) {
               $(this).text(prefixZeroDot.substring(0, prefixLoc));
           }
       }
    });


}
function fnGetEvent(e) {
    if (navigator.appName == 'Netscape') {
        keyVal = e.which;   //Netscape, CHROME
    } else if (navigator.appName == 'Microsoft Internet Explorer'){
        keyVal = e.keyCode ;   //MS
    }
    else{
        keyVal = e.which ;   //OPERA
    }
    return keyVal;
}
//key 값 체크 함수 -Type: han,eng,no

var k= new Array();
k= [8,9,13,16, 17, 18, 20,35,36,37,38,39,40,46, 112,113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123];

function is_val(type, e, obj){
    keyVal=fnGetEvent(e);
    for (i=0; i<k.length; i++)
    {
        if( keyVal == k[i]) return true;
    }
    if(type=="han") {
        if( keyVal==229 || keyVal==197) return true;
        else return false;
    }
    else if(type=="eng"){
        if( 65 <= keyVal && keyVal <=90) return true;
        else return false;
    }
    else if(type=="haneng"){
        if( 65 <= keyVal && keyVal <=90 || keyVal==229 || keyVal==197) return true;
        else return false;
    }
    else if(type=="no"){
        if( (48 <= keyVal && keyVal <=57) || ( 96<=keyVal && keyVal <=105 ) ) return true;
        else return false;
    }
    else if(type=="engNo"){
        if (is_val("eng", e, obj) )return true;
        else if( is_val("no",e, obj) )  return true;
        alert("영어와 숫자만 입력이 가능합니다.");
        return false;
    }
}
function openTab(url){
    window.open(url);
}
function searchCoin(){
    var id = "";
    var search_name = $('#search_name').val();
    var search_symbol = "";
    var state = "";
    var url =  "/coin/coinDetail";
    if(!isNull(arguments[0])){
        id = arguments[0];
    }
    if(!isNull(arguments[1])){
        state = arguments[1];
    }

    if(isNull(search_name)){
        alert('검색할 코인을 입력해주세요.');
        return;
    }

    if(id == "" && state == ""){
        $.ajax({
            type:"GET",
            data:{'search_name':search_name,'type':'info'},
            url:"/coin/searchCoinAjax",
            cache:"false",
            dataType:"JSON",
            success: function(coinList){
                if(coinList.length == 0){
                    alert("일치하는 결과가 없습니다.");
                }else{
                    id = coinList[0]['id'];
                    search_name = coinList[0]['name'];
                    search_symbol = coinList[0]['symbol'];
                    state = coinList[0]['state'];

                    if(state == 2){
                        url = "/ico/icoDetail";
                    }else if(state == 10){
                        url = "/company/companyDetail";
                    }else if(state == 20){
                        url = "/reviewer/reviewerDetail";
                    }

                    /*var comForm = new CommonForm('commonForm');
                    comForm.addParam('id',id);
                    comForm.setUrl(url);
                    comForm.submit();*/
                    location.href=url+"?id="+id;
                }
            }/*,
            error:function(request,status,error){
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }*/
        });
    }else{
        if(state == 2){
            url = "/ico/icoDetail";
        }else if(state == 10){
            url = "/company/companyDetail";
        }else if(state == 20){
            url = "/reviewer/reviewerDetail";
        }

        /*var comForm = new CommonForm('commonForm');
        comForm.addParam('id',id);
        comForm.setUrl(url);
        comForm.submit();*/
        location.href=url+"?id="+id;
    }
}
function searchCoinAjax(){
    var search_name = $('#search_name').val();
    $.ajax({
        type:"POST",
        data:{'search_name':search_name,'type':'list'},
        url:"/coin/searchCoinAjax",
        cache:"false",
        dataType:"JSON",
        success: function(coinList){
            $('#search_coin_result ul:eq(0)').empty();
            $('#search_coin_result ul:eq(1)').empty();
            $('#search_coin_result ul:eq(2)').empty();
            $('#search_coin_result ul:eq(3)').empty();
            var htm_0 = "";
            var htm_1 = "";
            var htm_2 = "";
            var htm_3 = "";
            var count_0 = 0;
            var count_1 = 0;
            var count_2 = 0;
            var count_3 = 0;
            for(var i=0; i<coinList.length; i++){
                if(coinList[i]['state'] <= 1){
                    if(count_0 == 0){
                        $('#search_coin_result ul:eq(0)').append("<li class='result_head'>상장된 코인</li>");
                    }
                    htm_0 += "<li onclick='searchCoin(\""+coinList[i]['id']+"\",\""+coinList[i]['state']+"\")'>"+coinList[i]['name']+" ("+coinList[i]['symbol']+")</li>"
                    count_0 = count_0 + 1;
                }else if(coinList[i]['state'] == 2){
                    if(count_1 == 0) {
                        $('#search_coin_result ul:eq(1)').append("<li class='result_head'>ICO 코인</li>");
                    }
                    htm_1 += "<li onclick='searchCoin(\""+coinList[i]['id']+"\",\""+coinList[i]['state']+"\")'>"+coinList[i]['name']+" ("+coinList[i]['symbol']+")</li>"
                    count_1 = count_1 + 1;
                }/*else if(coinList[i]['state'] == 10){
                    if(count_2 == 0){
                        $('#search_coin_result ul:eq(2)').append("<li class='result_head'>투자사</li>");
                        htm_2 += "<li onclick='searchCoin(\""+coinList[i]['id']+"\",\""+coinList[i]['state']+"\")'>"+coinList[i]['name']+"</li>"
                        count_2 = count_2 + 1;
                    }
                }*/else if(coinList[i]['state'] == 20){
                    if(count_3 == 0){
                        $('#search_coin_result ul:eq(3)').append("<li class='result_head'>리뷰어</li>");
                        htm_3 += "<li onclick='searchCoin(\""+coinList[i]['id']+"\",\""+coinList[i]['state']+"\")'>"+coinList[i]['name']+"</li>"
                        count_3 = count_3 + 1;
                    }
                }
            }
            $('#search_coin_result ul:eq(0)').append(htm_0);
            $('#search_coin_result ul:eq(1)').append(htm_1);
            $('#search_coin_result ul:eq(2)').append(htm_2);
            $('#search_coin_result ul:eq(3)').append(htm_3);
        }/*,
        error:function(request,status,error){
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }*/
    });
}
function searchCoinOutFocus(){
    $('#search_coin_result ul:eq(0)').empty();
    $('#search_coin_result ul:eq(1)').empty();
    $('#search_coin_result ul:eq(2)').empty();
    $('#search_coin_result ul:eq(3)').empty();
}

function setBookmark(id){
    $.ajax({
        type:"POST",
        data:{'id':id},
        url:"/coin/setBookmarkAjax",
        cache:"false",
        dataType:"JSON",
        success: function(data){
            if(data){
                window.location.reload(true);
            }else{
                alert('에러!! 관리자에게 문의하세요.');
            }
        },
        error:function(request,status,error){
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
    });
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function changeRate(map){
    var exc_id = $('#exc_name option:selected').val();
    var form = new CommonForm('chgRateForm');
    form.addParam("exc_id",exc_id);
    if(!isNull(map)){
        map.forEach(function(value, key){
           if(key != 'exc_id'){
               form.addParam(key,value);
           }
        });
    }
    form.submit();
}

function imgError(image,ctx) {
    image.onerror = "";
    image.src = ctx+"/resources/image/Logoimg.png";
    return true;
}

function toDateString(datetime){
    var parts = datetime.split(" ");
    var date = parts[0].split("-");
    var time = parts[1].split(":");
    return new Date(date[0],date[1],date[2],time[0],time[1],time[2]);
}


function sleep (delay) {
    var start = new Date().getTime();
    while (new Date().getTime() < start + delay);
}
