package com.flashbum.components.containers 
{
	import flash.events.IEventDispatcher;

	/**
	 * @author jessefreeman
	 */
	public interface I3dContainer extends IEventDispatcher
	{

		function get id() : String;

		function calculateMouseMovement(mouseX : Number, mouseY : Number, stageWidth : int, stageHeight : int) : void;

		function active(value : Boolean, side : String = "front") : void;

		function get width() : Number;

		function get height() : Number;

		function resetXY() : void;

		function destroy() : void;

		function get culled() : Boolean;

		function get instance() : *;

		function get x() : Number;

		function set x(value : Number) : void

		function get z() : Number;

		function set z(value : Number) : void

		function get y() : Number;

		function set y(value : Number) : void

		function get rotationX() : Number;

		function set rotationX(value : Number) : void

		function get rotationY() : Number;

		function set rotationY(value : Number) : void

		function get rotationZ() : Number;

		function set rotationZ(value : Number) : void

		function attachTo(target : *) : Boolean;

		function removeFrom(target : *) : Boolean;

		function view( ...params) : void;
	}
}
