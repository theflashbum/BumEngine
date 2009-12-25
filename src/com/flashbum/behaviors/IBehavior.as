package com.flashbum.behaviors
{

	public interface IBehavior
	{
		function set observableComponent(target:*):void ;
		function get observableComponent():*;
		function get active():Boolean;
		function set active(value : Boolean) : void;
	}
}