package com.flashbum.components.ui 
{

import com.flashartofwar.fcss.behaviors.ApplyStyleBehavior;
import com.flashartofwar.fcss.styles.IStyle;

	import camo.core.decal.BaseDecal;

	import com.flashbum.components.IComponent;
	import com.flashbum.events.VideoSourceEvent;

	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author jessefreeman
	 */
	public class DecalVideoPlayer extends BaseDecal implements IComponent
	{

		protected var stateDecals:Array = [];
		protected var decalDisplay:BaseDecal = new BaseDecal( );
		protected var videoSrc:VideoSource;// = new VideoSource( );
		protected var renderLoop:Timer;
		protected var bitmapDisplayList:Array = new Array( );
		protected var displayItemsTotal:int = 0;
		protected var styleBehavior:ApplyStyleBehavior;

		public function DecalVideoPlayer(id:String = "DecalVideoPlayer", posterImage:BaseDecal = null, pixelSnapping:String = "auto", smoothing:Boolean = false)
		{
			styleBehavior = new ApplyStyleBehavior( this, id );
			
			super( new BitmapData( posterImage.width, posterImage.height, false, 0xFF0000 ), pixelSnapping, smoothing );
			
			if(posterImage)
			{
				addBitmap( posterImage );
				decalDisplay.bitmapData = new BitmapData( posterImage.width, posterImage.height, true, 0x000000 ); 
			}
			init( );
		}

		public function get id():String 
		{
			return styleBehavior.id;
		}

		/*public function set id(id:String):void
		{
			styleBehavior.id = id;
		}*/

		public function get className():String
		{
			return styleBehavior.className;
		}

		protected function init():void
		{
			styleBehavior.applyDefaultStyle();
			
			videoSrc = new VideoSource( id+"VideoSource", decalDisplay.width, decalDisplay.height );
			renderLoop = new Timer( 41 );
			
			redraw( );	
		}

		protected function onRenderTick(event:TimerEvent):void
		{
			try
			{
				decalDisplay.bitmapData.draw( videoSrc.videoDisplay );
				redraw( );
			}
			catch(error:Error)
			{
				trace( "Error: videoSrc could not be sampled", error );
			}
		}

		public function changeState(decalName:String):void
		{
			switch(decalName)
			{
			}
		}

		protected function addBitmap(target:IBitmapDrawable):void
		{
			displayItemsTotal = bitmapDisplayList.push( target );
		}

		protected function removeBitmap(target:IBitmapDrawable):void
		{
			bitmapDisplayList.splice( bitmapDisplayList.indexOf( target ) );
			displayItemsTotal --;
		}

		public function redraw():void 
		{
			
			redrawLoop( );
			
				
			dispatchEvent( new Event( Event.CHANGE ) );
		}

		protected function redrawLoop():void
		{
			var i:int = 0;
			
			for (i = 0; i < displayItemsTotal; i ++) 
			{
				bitmapData.draw( bitmapDisplayList[i] );
			}
		}

		public function set src(value:String):void
		{
			videoSrc.src = value;
			addVideoEventListeners( videoSrc );
		}

		public function togglePause():void
		{
			videoSrc.togglePause( );
		}

		public function stop():void
		{
			videoSrc.stop( );
			renderLoop.stop( );
			removeVideoEventListeners( videoSrc );
		}

		protected function addVideoEventListeners(target:IEventDispatcher):void
		{
			target.addEventListener( VideoSourceEvent.PLAY, onVideoPlay );
			target.addEventListener( VideoSourceEvent.PAUSE, onVideoPause );
			target.addEventListener( VideoSourceEvent.STOP, onVideoStop );
		}

		protected function onVideoStop(event:VideoSourceEvent):void
		{
		}

		protected function onVideoPause(event:VideoSourceEvent):void
		{
			renderLoop.stop( );	
			removeRenderLoopListeners( renderLoop );
		}

		protected function addRenderLoopListeners(target:IEventDispatcher):void
		{
			target.addEventListener( TimerEvent.TIMER, onRenderTick );
		}

		protected function removeRenderLoopListeners(target:IEventDispatcher):void
		{
			target.removeEventListener( TimerEvent.TIMER, onRenderTick );
		}

		protected function onVideoPlay(event:VideoSourceEvent):void
		{
			addBitmap( decalDisplay );
			
			addRenderLoopListeners( renderLoop );
			renderLoop.start( );
		}

		protected function removeVideoEventListeners(target:IEventDispatcher):void
		{
			target.removeEventListener( VideoSourceEvent.PLAY, onVideoPlay );
			target.removeEventListener( VideoSourceEvent.PAUSE, onVideoPause );
			target.removeEventListener( VideoSourceEvent.STOP, onVideoStop );
		}

		public function applyProperties(style:IStyle):void
		{
			styleBehavior.applyStyle(style);
		}
	}
}
