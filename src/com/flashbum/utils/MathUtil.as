package com.flashbum.utils 
{

	/**
	 * @author jessefreeman
	 */
	public class MathUtil 
	{

		public static function randRange(minNum : Number, maxNum : Number) : Number 
		{
			return (Math.floor( Math.random( ) * (maxNum - minNum + 1) ) + minNum);
		}

		public static function compareValues(valueA : Number, valueB : Number) : Number 
		{
			return (valueA > valueB) ? valueA : valueB;
		}
	}
}
