package com.flashartofwar.bootstrap.managers {
	import com.flashartofwar.fcss.utils.TypeHelperUtil;

	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	dynamic public class SettingsManager extends Proxy 
	{

		public static const INIT:String = "init";
		private static var _instance:SettingsManager;
		private var _data:XML;
		private var cache:Array = [];

		public function SettingsManager(enforcer:SingletonEnforcer) 
		{
			if (enforcer == null) 
			{
				throw new Error( "Error: Instantiation failed: Use GlobalDecalSheetManager.instance instead." );
			}
		}

		public static function get instance():SettingsManager
		{
			if(SettingsManager._instance == null) 
			{
				trace("SettingsManager.instance()");
				SettingsManager._instance = new SettingsManager( new SingletonEnforcer( ) );
			}
			return SettingsManager._instance;
		}

		flash_proxy override function getProperty(name:*):* 
		{
			var propName:String = String( name );
			
			if(cache[propName])
			{
				return cache[propName];
			}
			else
			{
				var temp_data:XML = data.property.(@id == propName)[0];
			
				var value:* = TypeHelperUtil.getType( temp_data.toString( ), temp_data.@type );
				cache[propName] = value;
				
				return value;
			}
		}

		public function get data():XML
		{
			return _data;
		}

		public function set data(data:XML):void
		{
			_data = data;
		}
	}
}

class SingletonEnforcer 
{
}