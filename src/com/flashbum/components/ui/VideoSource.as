
package com.flashbum.components.ui 
{
import com.flashartofwar.fcss.behaviors.ApplyStyleBehavior;
import com.flashartofwar.fcss.styles.IStyle;

	import com.flashbum.components.IComponent;
	import com.flashbum.enum.VideoSourceModes;
	import com.flashbum.events.VideoSourceEvent;

	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * @author jessefreeman
	 */
	public class VideoSource extends EventDispatcher implements IComponent
	{

		protected var video : Video;
		protected var ns : NetStream;
		protected var nc : NetConnection;
		public var ready : Boolean = false;
		public var playing : Boolean = false;
		protected var _mode : String;
		protected var soundTransform : SoundTransform = new SoundTransform( );
		protected var styleBehavior : ApplyStyleBehavior;
		protected var _width : Number;
		protected var _height : Number;
		protected var _volume : Number = 1;
		public var loop : Boolean;

		public function VideoSource(id : String = "VideoSource", width : Number = 320, height : Number = 240)
		{
			styleBehavior = new ApplyStyleBehavior( this, id );
			_width = width;
			_height = height;
			
			init( );
		}

		protected function init() : void
		{
			//trace("VideoSource", id);
			styleBehavior.applyDefaultStyle( );
			
			var customClient : Object = new Object( );
			customClient.onMetaData = metaDataHandler;
 
			nc = new NetConnection( );
			nc.connect( null );
 
			ns = new NetStream( nc );
			ns.client = customClient;
			ns.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
			ns.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
			
			// Little bit of a hack but resets the volume if it wasn't set before
			volume = _volume;
			
			video = new Video( _width, _height );
			video.attachNetStream( ns );
		}

		public function get id() : String 
		{
			return styleBehavior.id;
		}

		/*public function set id(id : String) : void 
		{
			styleBehavior.id = id;
		}*/

		public function get className() : String
		{
			return styleBehavior.className;
		}

		public function get mode() : String
		{
			return _mode;
		}

		public function set volume(value : Number) : void
		{
			_volume = value;
			if(ns)
			{
				soundTransform.volume = value;
				ns.soundTransform = soundTransform;
			}		
		}

		public function set src(value : String) : void
		{
			ready = false;
			ns.play( value );
		}

		public function get videoDisplay() : Video
		{
			return video;
		}

		protected function securityErrorHandler(event : SecurityErrorEvent) : void 
		{
			trace( "securityErrorHandler: " + event );
		}

		public function stop() : void
		{
			ns.close( );
			video.clear( );
		}

		protected function metaDataHandler(infoObject : Object) : void 
		{
			//			video.width = infoObject.width;
			//			video.height = infoObject.height;
			ready = true;
		}

		public function togglePause() : void
		{
			ns.togglePause( );
			playing = ! playing;
			dispatchEvent( new VideoSourceEvent( (playing) ? VideoSourceEvent.PLAY : VideoSourceEvent.PAUSE, true, true ) );
				
			trace( "Playing", playing );
		}

		protected function netStatusHandler(event : NetStatusEvent) : void 
		{                  		
			trace( "Video Player", event.info.code );
			switch(event.info.code) 
			{
				case "NetConnection.Connect.Success":   
					//connectStream();           		      
					break;
				case "NetStream.Play.StreamNotFound":
					//_stream.play(_src);
					break;
				case 'NetStream.Seek.InvalidTime':
					//_stream.seek(lastkeyframe);
					break;
				case "NetStream.Play.Start":
					trace( "Video Start" );
					playing = true;
					_mode = VideoSourceModes.PLAY;
					dispatchEvent( new VideoSourceEvent( VideoSourceEvent.PLAY, true, true ) );
					//dispatchEvent(new Event("loadComplete"));
					break;	
				case "NetStream.Pause.Notify":
					trace( "Pause" );
					break;				
				case "NetStream.Play.Stop":
					trace( "Video Complete" );
					if(loop)
					{
						ns.seek(0);
					}
					else
					{
						playing = false;
						_mode = VideoSourceModes.STOP;
						dispatchEvent( new VideoSourceEvent( VideoSourceEvent.STOP, true, true ) );
					}
					break;
				default:						
			}
		}

		public function applyProperties(style : IStyle) : void
		{
			styleBehavior.applyStyle( style );
		}

		public function get width() : Number
		{
			return _width;
		}

		public function set width(width : Number) : void
		{
			_width = width;
		}

		public function get height() : Number
		{
			return _height;
		}

		public function set height(height : Number) : void
		{
			_height = height;
		}
	}
}
