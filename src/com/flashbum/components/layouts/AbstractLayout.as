
package com.flashbum.components.layouts 
{
	import com.adobe.utils.ArrayUtil;

	import flash.events.EventDispatcher;

	/**
	 * @author jessefreeman
	 */
	public class AbstractLayout extends EventDispatcher implements ILayout
	{
		protected var containerInstances : Array = new Array( );
		protected var space : Number = 600;
		protected var maxHeight : Number = 0;
		protected var maxWidth : Number = 0;

		public function get width() : Number
		{
			return maxWidth;	
		}

		public function get height() : Number
		{
			return maxHeight;
		}
		
		public function AbstractLayout()
		{
			
		}
		
		public function addContainers(...containers):void
		{
			containerInstances = ArrayUtil.createUniqueCopy(containerInstances.concat(containers));
			indexContainers( );
			layoutContainers( );
		}
		
		public function removeContainers(...containers):void
		{
			
		}
		
		protected function indexContainers() : void 
		{
			//
		}
		
		protected function layoutContainers() : void
		{
			//
		}
	}
}
