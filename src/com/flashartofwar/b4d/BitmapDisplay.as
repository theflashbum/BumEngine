package com.flashartofwar.b4d 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * @author jessefreeman
	 */
	public class BitmapDisplay extends Bitmap 
	{

		public function BitmapDisplay(bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = false)
		{
			super( bitmapData, pixelSnapping, smoothing );
		}
	}
}
