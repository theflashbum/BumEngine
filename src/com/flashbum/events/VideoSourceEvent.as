
package com.flashbum.events 
{
	import flash.events.Event;

	/**
	 * @author jessefreeman
	 */
	public class VideoSourceEvent extends Event 
	{
		
		public static const PLAY:String = "play";
		public static const PAUSE:String = "pause";
		public static const STOP:String = "stop";
		
		public function VideoSourceEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}
