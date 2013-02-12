/**
 * User: emrahgunduz
 * Date: 2/6/13
 * Time: 3:33 PM
 */
package com.countly
{

	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	public class DeviceInfo
	{
		private static const ALPHA_CHAR_CODES:Array = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70];

		/**
		 * There is no original way to create a UDID in AS3.
		 * We have some UDID creating classes around, but they just
		 * create it randomly. A real UDID must remain the same
		 * whatever the conditions are.
		 *
		 * OpenUDID has a great way of doing this by checking some
		 * system variables (mac ids, etc...)
		 *
		 * However, actionscript has no way to communicate with
		 * hardware, plus we have no low level apis. And we are most
		 * certainly running in a web browser, sandboxed.
		 *
		 * So, we are left with what limited environment offers to
		 * us and try to create a unique ID each time the app
		 * starts from zero.
		 * 
		 * @return String
		 */
		public static function udid():String
		{
			// Check for saved UDID
			var udid:SharedObject = SharedObject.getLocal( "udid" );
			if(udid.data.hasOwnProperty("udid")) {
				var udidExisting:String = udid.data["udid"] as String;
				if(!(udidExisting.length > 32)) {
					return udidExisting;
				}
			}

			var capabilities:String = Capabilities.serverString;

			// Create the buffer
			var buffer:ByteArray = new ByteArray();
			// Randomness
			buffer.writeDouble(Math.random() ^ (CountlyParse.unixTimeMillisec()));
			// Get time
			buffer.writeUnsignedInt(CountlyParse.unixTimeMillisec());
			// Add capabilities to buffer
			buffer.writeMultiByte(capabilities, "us-ascii");

			// Convert buffer to string representation
			buffer.position = 0;
			var chars:Array = new Array(32);
			var cIndex:uint = 0;
			for(var i:uint = 0; i < 16; i++) {
				var b:int = buffer.readByte();
				chars[cIndex++] = ALPHA_CHAR_CODES[(b & 0xF0) >>> 4];
				chars[cIndex++] = ALPHA_CHAR_CODES[(b & 0x0F)];
			}

			var finalUDID:String = String.fromCharCode.apply(null, chars);
			udid.data["udid"] = finalUDID;
			udid.flush();

			return finalUDID;
		}

		public static function device():String
		{
			// Manufacturer is formatted as "Adobe OSName"
			var manufacturer:String = Capabilities.manufacturer;
			// Explode the text
			var deviceArr:Array = manufacturer.split(" ");
			// Last part is the device information
			return deviceArr[deviceArr.length-1];
		}

		public static function os():String
		{
			var os:String = Capabilities.os;
			// First part is the OS name
			var osArr:Array = os.split(" ");
			return osArr[0];
		}

		public static function osVersion():String
		{
			// We are getting the os
			var os:String = Capabilities.os;
			// First part is the os name
			var osArr:Array = os.split(" ");
			// Remove the os name
			var osVersion:String = os.split( osArr[0]+" " ).join();
			// Clean the version text
			osVersion = osVersion.replace(/[^0-9._-]+/gi, "");
			// Return the version
			return osVersion;
		}

		public static function carrier():String
		{
			// There is no carrier information in here
			// If you have any use for this method, return your desired information
			return null;
		}

		public static function resolution():String
		{
			return Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY;
		}

		public static function locale():String
		{
			return Capabilities.language;
		}

		public static function appVersion():String
		{
			return Countly.sharedInstance().version;
		}

		public static function metrics():String
		{
			var result:String = "{";
			result += '"_device":"' + DeviceInfo.device() + '",';
			result += '"_os":"' + DeviceInfo.os() + '",';
			result += '"_os_version":"' + DeviceInfo.osVersion() + '",';

			if(DeviceInfo.carrier()) {
				result += '"_carrier":"' + DeviceInfo.carrier() + '",';
			}

			result += '"_resolution":"' + DeviceInfo.resolution() + '",';
			result += '"_locate":"' + DeviceInfo.locale() + '",';
			result += '"_app_version":"' + DeviceInfo.appVersion() + '"';
			result += "}";

			return encodeURIComponent(result);
		}
	}
}
