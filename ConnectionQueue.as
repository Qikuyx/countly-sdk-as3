/**
 * User: emrahgunduz
 * Date: 2/6/13
 * Time: 3:09 PM
 */
package com.countly
{

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class ConnectionQueue
	{
		private static var instance:ConnectionQueue;
		private static var allowInstantiation:Boolean;

		private var queue:Array;
		private var connection:URLLoader;
		private var _appKey:String;
		private var _appHost:String;

		private static var COUNTLY_VERSION:String = "1.0";

		public function ConnectionQueue ()
		{
			if ( !allowInstantiation )
				throw new Error( "Error: Call ConnectionQueue.sharedInstance() to use this singleton" );

			// Init
			queue = [];
			connection = null;
			appKey = null;
			appHost = null;
		}

		public static function sharedInstance ():ConnectionQueue
		{
			if ( instance == null ) {
				allowInstantiation = true;
				instance = new ConnectionQueue();
				allowInstantiation = false;
			}
			return instance;
		}

		public function get appKey ():String
		{
			return _appKey;
		}

		public function set appKey ( value:String ):void
		{
			_appKey = value;
		}

		public function get appHost ():String
		{
			return _appHost;
		}

		public function set appHost ( value:String ):void
		{
			_appHost = value;
		}

		private function tick():void
		{
			if(connection != null || queue.length == 0) {
				return;
			}

			var data:Object = queue[0];

			var variables:String = "?";
			for ( var keym:String in data ) {
				if(data.hasOwnProperty(keym)) {
					variables += keym + "=" + data[keym] + "&";
				}
			}
			variables = variables.slice(0, -1);

			var request:URLRequest = new URLRequest(appHost + "/i" + variables);
			request.method = URLRequestMethod.GET;

			connection = new URLLoader();
			connection.addEventListener(Event.COMPLETE, connectionDidFinishLoading);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, connectionDidFinishWithErrorSEC);
			connection.addEventListener(IOErrorEvent.IO_ERROR, connectionDidFinishWithErrorIO);

			connection.load(request);
		}

		public function beginSession():void
		{
			var data:Object = {
			  app_key : appKey,
				device_id : DeviceInfo.udid(),
				timestamp : CountlyParse.unixTime(),
				sdk_version : COUNTLY_VERSION,
				begin_session : 1,
				metrics : DeviceInfo.metrics()
			};
			queue.push(data);

			tick();
		}

		public function updateSessionWithDuration(duration:int):void
		{
			var data:Object = {
				app_key : appKey,
				device_id : DeviceInfo.udid(),
				timestamp : CountlyParse.unixTime(),
				session_duration : duration
			};
			queue.push(data);

			tick();
		}

		public function endSessionWithDuration(duration:int):void
		{
			var data:Object = {
				app_key : appKey,
				device_id : DeviceInfo.udid(),
				timestamp : CountlyParse.unixTime(),
				end_session : 1,
				session_duration : duration
			};
			queue.push(data);

			tick();
		}

		public function recordEvents(events:String):void
		{
			var data:Object = {
				app_key : appKey,
				device_id : DeviceInfo.udid(),
				timestamp : CountlyParse.unixTime(),
				events : events
			};
			queue.push(data);

			tick();
		}

		public function connectionDidFinishLoading(event:Event):void
		{
			connection = null;
			queue.splice(0, 1); // removeObjectAtIndex:0

			tick();
		}

		public function connectionDidFinishWithErrorSEC(event:SecurityErrorEvent):void
		{
			connection = null;
		}

		public function connectionDidFinishWithErrorIO(event:IOErrorEvent):void
		{
			connection = null;
		}
	}
}

