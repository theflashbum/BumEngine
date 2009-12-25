
package com.flashbum.core 
{
	import camo.core.decal.IBaseDecal;

	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.Point;

	/**
	 * @author jessefreeman
	 */
	public interface IDecalMaterial extends IBitmapDrawable
	{

		function get buttonHitAreas() : Array;

		function set isInteractive(value : Boolean) : void;

		function get isInteractive() : Boolean;

		function set isDoubleSided(value : Boolean) : void;

		function get isDoubleSided() : Boolean;
		
		function get bitmapData() : BitmapData;
		function set bitmapData(value : BitmapData) : void;

		function addDecalBitmap(name : String, decal : IBaseDecal, position : Point, interactive : Boolean = false, render : Boolean = true, autoUpdate : Boolean = true) : IBaseDecal

		function removeDecalByName(name : String) : void;

		function removeDecalByInstance(decal : IBaseDecal) : void;

		function detachByInstance( ...decals ) : void;
		function detachByName( ...decalNames ) : void;

		function render() : void;
	}
}
