package com.flashbum.managers 
{
	import camo.core.managers.DecalSheetManager;

	public class GlobalDecalSheetManager
	{

		public static const INIT:String = "init";
		private static var __instance:DecalSheetManager;

		/**
		 * 
		 * @param enforcer
		 * 
		 */		
		public function GlobalDecalSheetManager(enforcer:SingletonEnforcer) 
		{
			if (enforcer == null) 
			{
				throw new Error( "Error: Instantiation failed: Use GlobalDecalSheetManager.instance instead." );
			}
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function get instance():DecalSheetManager
		{
			if(GlobalDecalSheetManager.__instance == null) 
			{
				GlobalDecalSheetManager.__instance = new DecalSheetManager( );
			}
			return GlobalDecalSheetManager.__instance;
		}
	}
}

internal class SingletonEnforcer 
{
}