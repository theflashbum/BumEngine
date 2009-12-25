
package com.flashbum.utils 
{

	/**
	 * @author jessefreeman
	 */
	public class ArrayUtil 
	{

		public static function randomizeArray(array : Array) : Array 
		{
			var newArray : Array = new Array( );
			while(array.length > 0) 
			{
				newArray.push( array.splice( Math.floor( Math.random( ) * array.length ), 1 ) );
			}
			return newArray;
		}

		/**
		 * 
		 */
		public static function shuffle(a : Array) : Array 
		{
			var len : int = a.length;
			var temp : *;
			
			for (var i : int = len - 1; i > 0 ; i --) 
			{
				var rand : int = Math.floor( Math.random( ) * len );
				
				temp = a[i];
				a[i] = a[rand];
				a[rand] = temp;
			}
			
			return a;
		}
		
		public static function uniqueConcat(...args):Array
		{
		    var retArr:Array = new Array();
		    for each (var arg:* in args)
		    {
		        if (arg is Array)
		        {
		            for each (var value:* in arg)
		            {
		                if (retArr.indexOf(value) == -1)
		                    retArr.push(value);
		            }
		        }
		    }
		    return retArr;
		}
	}
}
