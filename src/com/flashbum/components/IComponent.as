package com.flashbum.components 
{
	import com.flashartofwar.fcss.styles.IStyle;

	/**
	 * @author jessefreeman
	 */
	public interface IComponent 
	{

		function get id():String;

		//function set id(value:String):void;

		function get className():String;
		
		function applyProperties(style : IStyle) : void;
	}
}
