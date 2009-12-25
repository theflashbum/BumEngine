
package com.flashbum.components.layouts 
{
	import com.flashbum.components.containers.I3dContainer;
	import com.flashbum.components.layouts.AbstractLayout;

	/**
	 * @author jessefreeman
	 */
	public class HorizontalLayout extends AbstractLayout 
	{

		public function HorizontalLayout()
		{
			super( );
		}
		
		override protected function layoutContainers():void
		{
			var total : int = containerInstances.length;
			var nextX : Number = 0;
			
			for (var i:int = 0; i < total; i++)
			{
				var tempItem:I3dContainer = containerInstances[i];
				tempItem.x = nextX;
				
				nextX += tempItem.width + space;
			}
		}
	}
}
