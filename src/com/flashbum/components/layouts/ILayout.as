
package com.flashbum.components.layouts 
{
	import flash.events.IEventDispatcher;

	/**
	 * @author jessefreeman
	 */
	public interface ILayout extends IEventDispatcher 
	{

		function get width() : Number;

		function get height() : Number

		function addContainers(...containers) : void;

		function removeContainers(...containers) : void
	}
}
