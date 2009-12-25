package com.flashartofwar.bootstrap.managers 
{
	import com.flashartofwar.bootstrap.utils.TokenUtil;

	/**
	 * 
	 */
	public class URIManager
	{

		//--------------------------------------------------------------------------------
		//
		//	Private Static Member Variables
		//
		//--------------------------------------------------------------------------------
		private static var __instance:URIManager;
		//--------------------------------------------------------------------------------
		//
		//	Private Member Variables
		//
		//--------------------------------------------------------------------------------
		private var apis:Array = [];

		//--------------------------------------------------------------------------------
		//
		//	Constructor
		//	NOTE: AS3 does not allow for private or protected constructors
		//
		//--------------------------------------------------------------------------------
	
		/**
		 * Constructor can only be called by the static instance method.
		 * 
		 * @param caller	The function to call the APIManager constructor function
		 */
		public function URIManager(enforcer:SingletonEnforcer)
		{	
			if (enforcer == null) 
			{
				throw new Error( "Error: Instantiation failed: Use GlobalDecalSheetManager.instance instead." );
			}
		}

		//--------------------------------------------------------------------------------
		//
		//	Public Static Functions
		//
		//-------------------------------------------------------------------------------- 
        
		/**
		 * Creates a new instance of APIManager if one does not currently exist.
		 * 
		 * @return APIManager
		 */   
		public static function get instance():URIManager
		{
			if(URIManager.__instance == null) 
			{
				URIManager.__instance = new URIManager( new SingletonEnforcer( ) );
			}
			return URIManager.__instance;
		}

		//--------------------------------------------------------------------------------
		//
		//	Public Functions
		//
		//-------------------------------------------------------------------------------- 
		public function addURI( name:String, method:String ):void
		{
			trace("URIManager.addURI(",name,",",method,")");
			apis[ name ] = method;
		}	

		public function getURI( name:String, token:Object = null ):String
		{
			var apiMethod:String = "";
			
			apiMethod = apis[ name ] ? apis[ name ] : "";
			
			return TokenUtil.replaceTokens( apiMethod, token );
		}		
	}
}

internal class SingletonEnforcer 
{
}