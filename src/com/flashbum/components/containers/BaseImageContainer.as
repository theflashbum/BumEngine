
package com.flashbum.components.containers
{
	import camo.core.decal.BaseDecal;

	import com.flashbum.core.IDecalMaterial;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class BaseImageContainer extends AbstractSingleSidedContainer
	{

		protected var _src : String;
		protected var loaded : Boolean;
		protected var imageDecal : BaseDecal;
		public var backgroundColor : uint = 0x000000;
		public var imageDecalTransparent : Boolean = false;

		/**
		 * 
		 */
		public function BaseImageContainer(id : String, xmlData : XML = null)
		{
			super( id, xmlData );
		}

		/**
		 * 
		 */
		override public function parseXML(data : XML) : void
		{
			_src = data.@src;
			$parseXML(data);
		}
		
		protected function $parseXML(data:XML):void
		{
			super.parseXML( data );			
		}
		
		/**
		 * 
		 */
		override protected function createFrontMaterial() : void
		{
			
			var loader : Loader = new Loader( );
			addLoadEventListeners( loader.contentLoaderInfo );
			
			imageDecal = new BaseDecal( new BitmapData( width, height, imageDecalTransparent, backgroundColor ) );
			
			frontMaterial = createDecalMaterial( imageDecal );
			
			frontMaterial.isInteractive = true;
			
			loader.load( new URLRequest( _src ) );
		}

		/**
		 * 
		 */
		protected function addLoadEventListeners(contentLoaderInfo : LoaderInfo) : void
		{
			contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadComplete );
		}

		/**
		 * 
		 */
		protected function removeLoadEventListeners(contentLoaderInfo : LoaderInfo) : void
		{
			contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoadComplete );
		}

		/**
		 * 
		 */
		protected function onLoadComplete(event : Event) : void
		{
			var bitmap : Bitmap = LoaderInfo( event.target ).content as Bitmap;
			
			imageDecal.bitmapData = bitmap.bitmapData;
			
			removeLoadEventListeners( event.target as LoaderInfo );
		}

		/**
		 * 
		 * 
		 */		
		override protected function createObject() : void
		{
			
			createFrontMaterial( );

			_instance = create3dObject( );
			
			_instance.rotationZ = Number( _rotationZ );
			//_instance.useOwnContainer = _useOwnContainer;
		}
	}
}