function sendToken(token){
    alert(token);
    document.getElementById("returnValue").value = token;
}

function showText(showText){
    alert(showText);
}

function btnClick() {
    window.webkit.messageHandlers.iOS.postMessage({body: 'this is web data!'});
    let data = localStorage["data"];
    alert(data);
}
