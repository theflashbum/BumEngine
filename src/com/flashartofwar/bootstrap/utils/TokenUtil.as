package com.flashartofwar.bootstrap.utils
{

	public class TokenUtil
	{

		public static function replaceTokens( text:String, paramObj:Object = null, replaceUndefineds:String = "" ):String
		{
			if( ! paramObj )
			{
				return text;
			}
			else
			{
				var regExp:RegExp = /\$\{([\w'-]+)\}/g;	//token structure ${tokenName}'
				var cleanText:String = text.replace( regExp, function():*
				{ 
					return paramObj[ arguments[1] ]; 
				} );
				
				return cleanText.replace( /undefined/gi, replaceUndefineds );
			}
		}

		public static function mergeTokens( ... rest ):Object
		{
			var token:Object = {};
			
			for( var i:int = 0; i < rest.length; i ++ )
			{
				for( var j:String in rest[i] )
				{
					token[j] = rest[i][j];
				}
			}
			
			return token;
		}
	}
}