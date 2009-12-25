
package com.flashbum.enum 
{

	/**
	 * @author jessefreeman
	 */
	public final class Sides 
	{
		public static const FRONT : String = "front";
		public static const BACK : String = "back";
		
		/**
		 * Makes sure you only pass in a side value that is supported but the 
		 * engine.
		 */
		public static function validateSide(side : String) : String
		{
			switch(side)
			{
				case Sides.BACK:
					return Sides.BACK;
					break;
				
				default:
					return Sides.FRONT;
					break;
			}
		}
	}
}
