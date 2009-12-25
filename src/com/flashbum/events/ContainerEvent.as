
package com.flashbum.events 
{
	import Boolean;
	import String;
	import flash.events.Event;

	/**
	 * @author jessefreeman
	 */
	public class ContainerEvent extends Event 
	{
		
		public static const FLIP:String = "startFlip";		public static const END_FLIP:String = "endFlip";
		public static const EDIT:String = "edit";
		public static const FREEZE:String = "freeze";
		public static const UNFREEZE:String = "unfreeze";
		public static const FRONT_SIDE:String = "frontSide";		public static const BACK_SIDE:String = "backSide";
		public static const CENTER:String = "center";
		public static const EDIT_DONE : String = "editDone";
		public static const ENABLE_MOUSE_MOVEMENT : String = "enableMouseMovement";		public static const DISSABLE_MOUSE_MOVEMENT : String = "dissableMouseMovement";

		public function ContainerEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}
