<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>demo</title>
<style>  
video {  
    border: 1px solid #ccc;  
    display: block;  
    margin: 0 0 20px 0;  
    float:left;  
}  
#canvas {  
    margin-top: 20px;  
    border: 1px solid #ccc;  
    display: block;  
}  
</style>
</head>
<body>
    <video id="video" width="500" height="400" autoplay></video>  
    <canvas id="canvas" width="500" height="400"></canvas>  
    <button id="snap">拍照</button>  
    <script type="text/javascript">  
        var context = canvas.getContext("2d");  
        //当DOM树构建完成的时候就会执行DOMContentLoaded事件  
        window.addEventListener("DOMContentLoaded", function() {  
            //获得Canvas对象  
            var canvas = document.getElementById("canvas");  
            //获得video摄像头区域  
            var video = document.getElementById("video");  
            var videoObj = {  
                "video" : true  
            };  
            var errBack = function(error) {  
                console.log("Video capture error: ", error.code);  
            };  
            //获得摄像头并显示到video区域  
            if (navigator.getUserMedia) { // Standard  
                navigator.getUserMedia(videoObj, function(stream) {  
                    video.src = stream;  
                    video.play();  
                }, errBack);  
            } else if (navigator.webkitGetUserMedia) { // WebKit-prefixed  
                navigator.webkitGetUserMedia(videoObj, function(stream) {  
                    video.src = window.webkitURL.createObjectURL(stream);  
                    video.play();  
                }, errBack);  
            } else if (navigator.mozGetUserMedia) { // Firefox-prefixed  
                navigator.mozGetUserMedia(videoObj, function(stream) {  
                    video.src = window.URL.createObjectURL(stream);  
                    video.play();  
                }, errBack);  
            }  
        }, false);  
        // 触发拍照动作  
        document.getElementById("snap").addEventListener("click", function() {  
            context.drawImage(video, 0, 0, 640, 480);  
        });  
    </script>
</body>
</html>