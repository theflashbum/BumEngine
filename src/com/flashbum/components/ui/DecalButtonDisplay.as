package com.flashbum.components.ui 
{
	import camo.core.decal.BaseDecal;
	import camo.core.decal.Decal;
	import camo.core.managers.DecalSheetManager;

	import com.flashbum.managers.GlobalDecalSheetManager;

	import flash.events.Event;

	/**
	 * @author jessefreeman
	 */
	public class DecalButtonDisplay extends BaseDecal 
	{

		protected var stateDecals : Array = [];
		public static const UP : String = "up";
		public static const DOWN : String = "down";
		public static const OVER : String = "over";
		public static const HIGHLIGHT : String = "highlight";
		public static const DISSABLED : String = "dissabled";
		protected var currentStateDecal : Decal;
		protected var decalManager : DecalSheetManager = GlobalDecalSheetManager.instance;

		public function DecalButtonDisplay(id:String, decalNames : * = null, pixelSnapping : String = "auto", smoothing : Boolean = false) 
		{

			super( null, pixelSnapping, smoothing );
			
			if( decalNames )
			{
				if( decalNames is Array )
				{
					for( var i:String in decalNames )
					{
						registerDecal( decalNames[i] );
					}
				}
	            else if( decalNames is Object )
				{
					for( var name:String in decalNames )
					{
						registerDecal( decalNames[ name ], name );
					}
				}
			}			

			init( );
		}

		protected function registerDecal(decalName : String, stateName : String = null) : void
		{
			if(! stateName) stateName = decalName;
			
			stateDecals[stateName] = decalManager.getDecal( decalName );
		}

		protected function init() : void 
		{
			changeDecal( UP );
		}

		public function changeDecal(decalName : String) : void 
		{
			if(currentStateDecal)
				removeListeners( currentStateDecal );
			
			currentStateDecal = Decal( stateDecals[validateState( decalName )] );
			try
			{
				addListeners( currentStateDecal );
			
				redraw( );
			}
			catch(error : Error)
			{
				trace( "Error - Couldn't find the requested decal", error );
			}
		}

		protected function addListeners(currentStateDecal : Decal) : void 
		{
			currentStateDecal.addEventListener( Event.CHANGE, onStateDecalChange );
		}

		protected function removeListeners(currentStateDecal : Decal) : void 
		{
			currentStateDecal.removeEventListener( Event.CHANGE, onStateDecalChange );
		}

		protected function onStateDecalChange(event : Event) : void 
		{
			event.stopImmediatePropagation( );
			redraw( );	
		}

		public function redraw() : void 
		{
			bitmapData = currentStateDecal.bitmapData.clone( );
		}

		protected function validateState(state : String) : String 
		{
			switch(state) 
			{
				case UP: 
				case DOWN: 
				case OVER: 
				case HIGHLIGHT: 
				case DISSABLED:
					return state;
					break;	
				default:
					return UP;
			}
		}
	}
}
