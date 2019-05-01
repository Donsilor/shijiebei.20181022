<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="format-detection" content="telephone=no">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-transform"/>

    <title>卡卡买世界杯竞猜-赛事竞猜</title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/ss.css">
</head>
<body>
<div class="clf content">
    <img src="images/logo.png" alt="" class="logo">
    <img src="images/jinCai_img_1.png" alt="" class="titleImg">
    <div class="main">
        <ul id="gamesList">
            <!--<div class="t_logo r_win">-->
            <!--<div><img src="images/logo_8.png" alt=""></div>-->
            <!--<h6>西班牙</h6>-->
            <!--</div>-->
            <!--<div class="time">6月23日</div>-->
            <!--<span></span>-->
            <!--</li>-->
        </ul>
    </div>
</div>
<div class="fixedMenu">
    <a href="ss.html" class="icon_1 active">赛事竞猜</a>
    <a href="userCenter.html" class="icon_4">赚取积分</a>
    <a href="luckyDraw.html" class="icon_2">积分兑换</a>
    <a href="ranking.html" class="icon_3">排行榜</a>
    
</div>


<script src="js/jquery-1.8.0.min.js"></script>
<script src="js/common.js"></script>
<script src="http://momentjs.cn/downloads/moment-with-locales.js"></script>
<script src="https://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
<script>
    $(function () {
        //checkLogin();
        moment.locale('zh_CN');
        const user = JSON.parse(getCookie("userdata"));
        const hh_id = getCookie("hh_id");
        $.ajax({
            type: "GET", //提交方式
            url: getUrl("/games"),
            data: {},
            success: function (games, status) {//返回数据根据结果进行相应的处理
                if (games !== undefined) {
                    const gamesList = $("#gamesList");
                    for (var i = 0; i < games.length; i++) {
                        const d = games[i];
                        var win = 0;
                        if (d.leftPoint > d.rightPoint) {
                            win = 1
                        } else if (d.leftPoint < d.rightPoint) {
                            win = -1
                        }
                        const guess = user.guesses[d.id];
                        var c = 0;
                        if (guess !== undefined) {
                            if (guess.choose) {
                                c = 1;
                            } else {
                                c = -1;
                            }
                        }

                        gamesList.append("<li class=\"clf " + (win > 0 ? "zhuShen" : win < 0 ? "keShen" : "") + "\">" +
                            "<div onclick='xiazhu(\"" + d.id + "\"," + d.comTime + ",true)' class=\"t_logo " + (c > 0 ? "l_win" : "") + " \">" +
                            "<div><img src=\"" + d.leftPic + "\"></div><h6>" + d.leftName + "(" + d.leftScore + ")</h6></div>" +
                            "<div class=\"vs\"><h6>vs</h6><h6>" + d.leftPoint + ":" + d.rightPoint + "</h6></div>" +
                            "<div onclick='xiazhu(\"" + d.id + "\"," + d.comTime + ",false)' class=\"t_logo " + (c < 0 ? "r_win" : "") + "\">" +
                            "<div><img src=\"" + d.rightPic + "\"></div><h6>" + d.rightName + "(" + d.rightScore + ")</h6></div>" +
                            "<div class=\"time\">" + moment(d.comTime).format("MM.DD HH时") + "</div><span></span></li>")
                    }

                } else {
                    alert(data.message)
                }
            }
        });
    })

    function xiazhu(gameId, comTime, choose) {

        if (moment().valueOf() - comTime > 0) {
            alert("本赛事已经停止下注咯");
            return
        }
        const hh_id = getCookie("hh_id");
        const user = JSON.parse(getCookie("userdata"));
        if (user.score < 100) {
            alert("您的积分不足");
            return
        }
        $.ajax({
            type: "PUT", //提交方式
            url: getUrl("/users/" + hh_id + "/games"),
            dataType: 'json',
            data: JSON.stringify({
                gameId: gameId,
                choose: choose
            }),
            success: function (data, status) {//返回数据根据结果进行相应的处理
                if (data !== undefined) {
                    getUsers(hh_id);
                } else {
                    alert(data.message)
                }
            },
            error: function (err) {
                if (err.status !== 200) {
                    const res = JSON.parse(err.responseText);
                    alert(res.message);
                }
            }
        });
    }

</script>
<script>
    $.ajax({
        url: getUrl("/sign?url=" + window.location.href),
        type: "get",
        dataType: "json",
        async: false,
        success: function (data) {
            console.log(data);
            var appIdVal = data.appId;
            var timestampVal = data.timestamp;
            var nonceStrVal = data.nonceStr;
            var signatureVal = encodeURIComponent(data.signature);
            wx.config({
                debug: false,
                // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
                appId: appIdVal,
                // 必填，公众号的唯一标识
                timestamp: timestampVal,
                // 必填，生成签名的时间戳
                nonceStr: nonceStrVal,
                // 必填，生成签名的随机串
                signature: signatureVal,
                // 必填，签名
                jsApiList: [
                    'onMenuShareAppMessage',//分享给好友
                    'onMenuShareTimeline',//分享到朋友圈
                    'onMenuShareQQ',//分享到QQ好友
                    'onMenuShareWeibo',//分享到微博
                    'onMenuShareQZone'//分享QQ空间
                ] // 必填，需要使用的JS接口列表
            });
        },
        error: function () {
            alert("您好，服务器繁忙中，请稍后重试  ");
        }
    })
    const hh_id = getCookie("hh_id");
    wx.ready(function () {
        var shareTitle = "竞猜世界杯胜负，赢华为Mate10手机";
        var shareDesc = "这次你不要再去朋友圈“跳楼”了";
        // var linkUrl="http://ceibs.54jj.cn/zhongou/index.html";
        var linkUrl = "http://ceibs.54jj.cn/shijiebei/index.html?agent=A" + hh_id;
        var imgUrl = "http://ceibs.54jj.cn/shijiebei/images/sharelogo.jpg";

        // 分享给微信好友
        wx.onMenuShareAppMessage({
            title: shareTitle,
            // 分享标题
            desc: shareDesc,
            // 分享描述
            link: linkUrl,
            // 分享链接
            imgUrl: imgUrl,
            // 分享图标
            type: 'link',
            // 分享类型,music、video或link，不填默认为link
            dataUrl: '',
            // 如果type是music或video，则要提供数据链接，默认为空
            success: function () {
            },
            cancel: function () {
                // 用户取消分享后执行的回调函数
            }
        });

        // 分享到朋友圈
        wx.onMenuShareTimeline({
            title: shareTitle,
            // 分享标题
            desc: shareDesc,
            // 分享描述
            link: linkUrl,
            // 分享链接
            imgUrl: imgUrl,
            // 分享图标
            type: 'link',
            // 分享类型,music、video或link，不填默认为link
            dataUrl: '',
            // 如果type是music或video，则要提供数据链接，默认为空
            success: function (res) {
            },
            cancel: function (res) {
                // 用户取消分享后执行的回调函数
            },
            fail: function (res) {
                // 用户取消分享后执行的回调函数
            }
        });
        wx.error(function (res) {
            // config信息验证失败会执行error函数，如签名过期导致验证失败
        });
    });
</script>

</body>
</html>
