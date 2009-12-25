package com.flashartofwar.bootstrap 
{
	import com.flashartofwar.bootstrap.managers.SettingsManager;
	import com.flashartofwar.bootstrap.managers.URIManager;

	import flash.events.EventDispatcher;

	/**
	 * @author jessefreeman
	 */
	public class Bootstrap extends EventDispatcher 
	{
		/**
		 * This is a sketch of a class. Do not use it because it will
		 * be moved out into its own project very soon!
		 */
		protected var settings:SettingsManager = SettingsManager.instance;
		protected var uriManager:URIManager = URIManager.instance;

		public function Bootstrap(data:XML = null)
		{

		}
		
		public function parseBootstrap(configXML:XML):void
		{
			var nodes:XMLList = configXML.*;
			var node:XML;
			var handler:String;
			for each(node in nodes)
			{
				try
				{
					handler = node.@handler;
					this[handler]( node );
				}catch(error:Error)
				{
					//Something failed.
					trace( "Error", error );
				}
			}
			
		}
		
		public function parseSettings(data:XML):void
		{
			settings.data = XML( data );
		}

		public function parseURIs(data:XML):void
		{
			var uris:XMLList = data.*;
			var uri:XML;
			for each(uri in uris)
			{
				uriManager.addURI( uri.@name, uri.toString( ) );
			}
			trace( "URI parse is done" );
		}
	}
}
