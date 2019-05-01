function getCookie(name) {
    var arr, reg = new RegExp("(^| )" + name + "=([^;]*)(;|$)");

    if (arr = document.cookie.match(reg))

        return unescape(arr[2]);
    else
        return null;
}


function setCookie(name, value) {
    var Days = 30;
    var exp = new Date();
    exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000);
    document.cookie = name + "=" + escape(value) + ";expires=" + exp.toGMTString();
}


function delCookie(name) {
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    var cval = getCookie(name);
    if (cval != null)
        document.cookie = name + "=" + cval + ";expires=" + exp.toGMTString();
}


function getQueryString(name) {
    var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i');
    var r = window.location.search.substr(1).match(reg);
    if (r != null) {
        return decodeURI(r[2]);
    }
    return null;
}

function getUrl(path) {
    //return "http://localhost:8009/api" + path;
    return "http://ceibs.54jj.cn/shijiebei/api" + path;
}

function getUsers(userId) {
    $.ajax({
        type: "GET", //提交方式
        url: getUrl("/users/" + userId),
        dataType: 'json',
        data: {},
        success: function (data, status) {//返回数据根据结果进行相应的处理
            if (data !== undefined) {
                setCookie("userdata", JSON.stringify(data));
                location.reload()
            } else {
                console.log(data)
            }
        },
        error: function (e) {
            console.log('error', e);
            if (e.status == 404) {
                wxLogin()
            } else {
                alert("网络错误:" + e.statusText)
            }
        }
    });
}

function checkLogin() {
    const hh_id = getCookie("hh_id");
    if (hh_id == undefined || hh_id == "") {
        location.href = "index.html" + location.search;
    }
}
