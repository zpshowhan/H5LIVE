<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
<title>H5直播和拍照 (支持火狐、谷歌、IE9+)</title>
</head>
<body>
<input type="button" title="开启摄像头" value="开启摄像头" onclick="getMedia();" /><br />  
    <video height="120px" autoplay="autoplay"></video><hr />  
    <input type="button" title="拍照" value="拍照" onclick="getPhoto();" />
    <button onClick="saveFile();" type="button">下载图片</button> <br />  
    <canvas id="canvas1" height="120px" width="120px"></canvas><hr />  
    <input type="button" title="视频" value="视频" onclick="getVedio();" /><br />  
    <canvas id="canvas2" height="120px" width="120px"></canvas>  
  
    <script type="text/javascript"> 
    
    	//摄像头图像
        var video = document.querySelector('video');  
        var audio, audioType;  
  
        //拍照幕布
        var canvas1 = document.getElementById('canvas1');  
        var context1 = canvas1.getContext('2d');  
  		//视频幕布
        var canvas2 = document.getElementById('canvas2');  
        var context2 = canvas2.getContext('2d');  
  
        navigator.getUserMedia = navigator.getUserMedia // Standard
        						|| navigator.webkitGetUserMedia // WebKit-prefixed
        						|| navigator.mozGetUserMedia // Firefox-prefixed
        						|| navigator.msGetUserMedia; // IE 
        window.URL = window.URL 
        			|| window.webkitURL 
        			|| window.mozURL 
        			|| window.msURL;  
  
        var exArray = []; //存储设备源ID  
        MediaStreamTrack.getSources(function (sourceInfos) {  
            for (var i = 0; i != sourceInfos.length; ++i) {  
                var sourceInfo = sourceInfos[i];  
                //这里会遍历audio,video，所以要加以区分  
                if (sourceInfo.kind === 'video') {  
                    exArray.push(sourceInfo.id);  
                }  
            }  
        });  
  
        function getMedia() {  
            if (navigator.getUserMedia) {  
                navigator.getUserMedia({  
                    'video': {  
                        'optional': [{  
                            'sourceId': exArray[1] //0为前置摄像头，1为后置  
                        }]  
                    },  
                    'audio':true  
                }, successFunc, errorFunc);    //success是获取成功的回调函数  
            }  
            else {  
                alert('Native device media streaming (getUserMedia) not supported in this browser.');  
            }  
        }  
  
        function successFunc(stream) {  
            //alert('Succeed to get media!');  
            if (video.mozSrcObject !== undefined) {  
                //Firefox中，video.mozSrcObject最初为null，而不是未定义的，我们可以靠这个来检测Firefox的支持  
                video.mozSrcObject = stream;  
            }  
            else {  
                video.src = window.URL && window.URL.createObjectURL(stream) || stream;  
            }  
  
            video.play();  
  
            // 音频  
            audio = new Audio();  
            audioType = getAudioType(audio);  
            if (audioType) {  
                audio.src = 'polaroid.' + audioType;  
                audio.play();  
            }  
        }  
        function errorFunc(e) {  
            alert('Error！'+e);  
        }  
  
          
        // 将视频帧绘制到Canvas对象上,Canvas每60ms切换帧，形成肉眼视频效果  
        function drawVideoAtCanvas(video,context) {  
            window.setInterval(function () {  
                context.drawImage(video, 0, 0,120,120);  
            }, 60);  
        }  
  
        //获取音频格式  
        function getAudioType(element) {  
            if (element.canPlayType) {  
                if (element.canPlayType('audio/mp4; codecs="mp4a.40.5"') !== '') {  
                    return ('aac');  
                } else if (element.canPlayType('audio/ogg; codecs="vorbis"') !== '') {  
                    return ("ogg");  
                }  
            }  
            return false;  
        }  
  
        // vedio播放时触发，绘制vedio帧图像到canvas  
       video.addEventListener('play', function () {  
           drawVideoAtCanvas(video, context2);  
       }, false);  
  
        //拍照  
        function getPhoto() {  
            context1.drawImage(video, 0, 0,120,120); //将video对象内指定的区域捕捉绘制到画布上指定的区域，实现拍照。  
        }  
  
        //视频  
        function getVedio() {  
            drawVideoAtCanvas(video, context2);  
        }  
        //下面的代码是保存canvas标签里的图片并且将其按一定的规则重命名  
        var type = 'png';  
        function _fixType(type) {  
        type = type.toLowerCase().replace(/jpg/i, 'jpeg');  
        var r = type.match(/png|jpeg|bmp|gif/)[0];  
        return 'image/' + r;  
    	};  
    	//下载拍照
        function saveFile(){  
    	 // 下载后的文件名规则  
         var filename = (new Date()).getTime() + '.' + 'png';
        //获取canvas标签里的图片内容  
        var imgData = document.getElementById('canvas1').toDataURL("png");  
        imgData = imgData.replace('image/png','image/octet-stream');  
          
        var save_link = document.createElementNS('http://www.w3.org/1999/xhtml', 'a');  
        save_link.href = imgData;  
        save_link.download = filename;  
         
        var event = document.createEvent('MouseEvents');  
        event.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);  
        save_link.dispatchEvent(event);  
    };  
         

    </script>
</body>
</html>