1、	通过https://github.com/Countly/countly-sdk-as3获取代码整合进要集成的项目。  
2、	调用Countly中的start(appKey:String, appVersion:String, appHost:String)进行初始化，其中appKey的值由奇酷分配，appVersion为当前应用版本号，appHost值为https://api.qiku.mobi。  
3、	调用Countly中的recordEvent或recordEventSegmentation方法发送行为事件。
