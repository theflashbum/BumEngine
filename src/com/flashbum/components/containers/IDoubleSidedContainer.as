
package com.flashbum.components.containers 
{

	/**
	 * @author jessefreeman
	 */
	public interface IDoubleSidedContainer extends ISingleSidedContainer 
	{

		function set front(value : Boolean) : void;

		function flip(animated : Boolean = true, recenterRotationX:Boolean = false) : void;

		function get flipping() : Boolean;
	}
}
