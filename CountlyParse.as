/**
 * User: emrahgunduz
 * Date: 2/8/13
 * Time: 12:34 PM
 */
package com.countly
{

	import flash.events.Event;
	import flash.external.ExternalInterface;

	public class CountlyParse
	{
		/**
		 * Returns the unix time from internal Date methods.
		 * AS3 normally returns time in milliseconds.
		 * @return Number
		 */
		public static function unixTime():Number
		{
			var d:Date = new Date();
			var m:Number = Math.floor(d.time / 1000);
			return m;
		}

		/**
		 * Returns the unix time in milliseconds.
		 * @return Number
		 */
		public static function unixTimeMillisec():Number
		{
			var d:Date = new Date();
			return d.time;
		}

		/**
		 * Creates an external event listener by using javascript and
		 * as3 ExternalInterface method.
		 *
		 * An example can be listening for window.onblur / window.onfocus
		 * events, which can tell if the browser or tab has lost the focus.
		 *
		 * @param eventName This is the JS event we will be watching
		 * @param callBack The AS3 callback function
		 * @param callBackAlias Alias for the AS3 callback function
		 * @return Returns and Event for internal compatibility
		 */
		public static function addExternalEventListener(eventName:String, callBack:Function, callBackAlias:String):Event
		{
			ExternalInterface.addCallback(callBackAlias, callBack);
			var jsImplementInterfaceCallBack:String = "document.getElementsByName('" + ExternalInterface.objectID + "')[0]." + callBackAlias + "()";
			var jsBindEvent:String = "function(){" + eventName + " = function(){ " + jsImplementInterfaceCallBack + " };}";
			ExternalInterface.call(jsBindEvent);
			return new Event(Event.COMPLETE);
		}
	}
}
