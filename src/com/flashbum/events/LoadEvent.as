package com.flashbum.events 
{
	import flash.events.Event;

	/**
	 * @author jessefreeman
	 */
	public class LoadEvent extends Event {
		public static const LOCATION : String = "location";
		public var url : String;

		public function LoadEvent(type : String, url:String, bubbles : Boolean = false, cancelable : Boolean = false) {
			this.url = url;
			super(type, bubbles, cancelable);
		}
	}
}
