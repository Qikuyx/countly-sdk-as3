/**
 * User: emrahgunduz
 * Date: 2/6/13
 * Time: 3:55 PM
 */
package com.countly
{
	public class EventCountly
	{
		private var _key:String;
		private var _segmentationKey:String;
		private var _segmentationValue:String;
		private var _count:int;
		private var _sum:Number;
		private var _timestamp:Number;

		public function EventCountly ()
		{
			_key               = null;
			_segmentationKey   = null;
			_segmentationValue = null;
			_count             = 0;
			_sum               = 0;
			_timestamp         = 0;
		}

		public function get key():String
		{
			return _key;
		}

		public function set key ( value:String ):void
		{
			_key = value;
		}

		public function get segmentationKey():String
		{
			return _segmentationKey;
		}

		public function set segmentationKey ( value:String ):void
		{
			_segmentationKey = value;
		}

		public function get segmentationValue():String
		{
			return _segmentationValue;
		}

		public function set segmentationValue ( value:String ):void
		{
			_segmentationValue = value;
		}

		public function get count():int
		{
			return _count;
		}

		public function set count ( value:int ):void
		{
			_count = value;
		}

		public function get sum():Number
		{
			return _sum;
		}

		public function set sum ( value:Number ):void
		{
			_sum = value;
		}

		public function get timestamp():Number
		{
			return _timestamp;
		}

		public function set timestamp ( value:Number ):void
		{
			_timestamp = value;
		}
	}
}
