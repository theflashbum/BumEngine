
package com.flashbum.components.containers 
{
import camo.core.managers.DecalSheetManager;

import com.flashartofwar.fcss.behaviors.ApplyStyleBehavior;
import com.flashartofwar.fcss.managers.StyleSheetManager;
import com.flashartofwar.fcss.styles.IStyle;
import com.flashartofwar.fcss.stylesheets.IStyleSheetCollection;
import com.flashbum.components.IComponent;
import com.flashbum.enum.Sides;
import com.flashbum.events.ContainerEvent;
import com.flashbum.managers.GlobalDecalSheetManager;

import flash.display.Shape;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

import gs.TweenLite;

public class Abstract3dContainer extends EventDispatcher implements IComponent,I3dContainer
	{

		protected var _x : Number = 0;
		protected var _y : Number = 0;
		protected var _z : Number = 0;
		protected var _width : Number = 0;
		protected var _height : Number = 0;
		protected var _rotationX : Number = 0;
		protected var _rotationY : Number = 0;
		protected var _rotationZ : Number = 0;
		protected var _segmentsW : Number = 4;
		protected var _segmentsH : Number = 4;
		protected var _segmentsD : Number = 4;
		protected var _bend : Number = 0;
		protected var currentPoint : Point = new Point( );
		protected var currentFocus : String;
		protected var hasFocus : Boolean;
		protected var xmlData : XML;
		protected static var mousePoint : Point = new Point( );
		protected var _useOwnContainer : Boolean = true;
		public var depth : Number = 0;
		protected var decalSheetManager : DecalSheetManager;

		//TODO need to use a setter for this that validates the correct 3d engine display3D
		protected var _instance:*;
		protected var styleSheetCollection:IStyleSheetCollection = StyleSheetManager.collection;
		private var styleBehavior : ApplyStyleBehavior;
		public var useMoudeControls : Boolean = true;

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

		public function get bend() : Number
		{
			return _bend;
		}

		public function set x(value : Number) : void 
		{
			_x = value;
			if(_instance)
				instance.x = value;
		}

		public function get x() : Number 
		{
			return _instance ? _instance.x : _x;
		}

		public function set y(value : Number) : void 
		{
			_y = value;
			if(_instance)
				instance.y = value;
		}

		public function get y() : Number 
		{
			return _instance ? _instance.y : _y;
		}

		public function set z(value : Number) : void 
		{
			_z = value;
			if(_instance)
				instance.z = value;
		}

		public function get z() : Number 
		{
			return _instance ? _instance.z : _z;
		}

		public function set rotationX(value : Number) : void 
		{
			_rotationX = value;
			if(_instance)
				instance.rotationX = value;
		}

		public function get rotationX() : Number 
		{
			return _instance ? _instance.rotationX : _rotationX;
		}

		public function set rotationY(value : Number) : void 
		{
			_rotationY = value;
			if(_instance)
				instance.rotationY = value;
		}

		public function get rotationY() : Number 
		{
			return _instance ? _instance.rotationY : _rotationY;
		}

		//TODO thinking of using these to modify the rotation without affecting the actual rotation on mouse movement
		public function set rotationYOffset(value : Number) : void
		{
		}

		public function set rotationXOffset(value : Number) : void
		{
		}

		public function set rotationZ(value : Number) : void 
		{
			_rotationZ = value;
			if(_instance)
				instance.rotationZ = value;
		}

		public function get rotationZ() : Number 
		{
			return _instance ? _instance.rotationZ : _rotationZ;
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get instance() : * 
		{
			return _instance;	
		}

		/**
		 * 
		 * @param id
		 * @param xmlData
		 * 
		 */		
		public function Abstract3dContainer(id : String, xmlData : XML = null) 
		{
			if(xmlData)
				this.xmlData = xmlData;

			styleBehavior = new ApplyStyleBehavior(this, id);
			
			init( );
		}

		protected function init() : void 
		{
			decalSheetManager = GlobalDecalSheetManager.instance;
						
			styleBehavior.applyDefaultStyle();

			if(xmlData)
				parseXML( xmlData );
							
			createObject( );

		}

		/**
		 * 
		 * @param style
		 * @param autoRefresh
		 * 
		 */		
		public function applyProperties(style : IStyle) : void 
		{	
			styleBehavior.applyStyle(style);
		}

		/**
		 * 
		 * 
		 */		
		protected function createObject() : void 
		{
		}

		public function parseXML(data : XML) : void 
		{
			width = Number( data.@w ) || 0;
			height = Number( data.@h ) || 0;
			depth = Number( data.@d ) || 0;	
		}

//		public function getProperties() : String 
//		{
//			return "{}";
//		}

		public function active(value : Boolean, side : String = Sides.FRONT) : void
		{
			if(value)
			{
				onActive( );
			}
			else
			{
				onDeactivate( );
			}
		}

		protected function onActive() : void
		{
			//TODO need to add logic to make sure we even need to run this loop
			Mouse.cursor = MouseCursor.ARROW;
			addButtonHitAreaListeners( );
		}

		protected function onDeactivate() : void
		{
			removeButtonHitAreaListeners( );
			resetXY( );
		}

		public function resetXY() : void
		{
			TweenLite.to( this, .5, { rotationX: 0, rotationY: 0, overwrite:false} );
			//Tweener.addTween( this, { rotationX: 0, rotationY: 0, time: .5 } );
		}

		public function edit() : void
		{
			dispatchEvent( new ContainerEvent( ContainerEvent.EDIT, true, true ) );
		}

		/**
		 * This override makes sure that the normal refesh method from a 
		 * CamoDisplay is not called. Override to add your own redraw logic.
		 * 
		 * Do not call this method it is not needed in an AbstractContainer	
		 */
		public function refresh() : void
		{
			// This is a dead end. 
		}

		/**
		 * Calcualtes the orientation of the instance based on the width/height 
		 * of the stage along with the width/heigh of the object.
		 */
		public function calculateMouseMovement(mouseX : Number, mouseY : Number, stageWidth : int, stageHeight : int) : void
		{
			if(useMoudeControls)
			{
				var rotY : Number = (mouseX - (stageWidth * .5)) / (640 * .5) * (- 20);
				var rotX : Number = (mouseY - (stageHeight * .5)) / (480 * .5) * (- 20);
			
				rotateInstance( rotX, rotY );
			}
		}

		protected function rotateInstance(rotX : Number, rotY : Number) : void
		{
			calculateXRotation( rotX );
			calculateYRotation( rotY );
		}

		protected function calculateXRotation(rotX : Number) : void
		{
			rotationX = rotationX + (rotX - rotationX) * .5;
		}

		protected function calculateYRotation(rotY : Number) : void
		{
			rotationY = (rotationY + ((rotY) - rotationY) * .5) ;
		}

		// Default Interactive Methods
		
		/**
		 * 
		 */
		protected function onRollOver(event : MouseEvent = null) : void
		{
			Mouse.cursor = MouseCursor.BUTTON;
		}

		/**
		 * 
		 */
		protected function onRollOut(event : MouseEvent = null) : void
		{
			Mouse.cursor = MouseCursor.ARROW;
		}

		/**
		 * This is a debug function to visually display the rectangles we are
		 * testing for.
		 */
		protected function displayHitArea() : Shape 
		{
			var rectangle : Rectangle;
			var key : String;
			var shape : Shape = new Shape( );
 
			for (key in buttonHitAreas) 
			{
				rectangle = buttonHitAreas[key];
				shape.graphics.beginFill( Math.random( ) * 0xffffff, .5 );
				shape.graphics.drawRect( rectangle.x, rectangle.y, rectangle.width, rectangle.height );
				shape.graphics.endFill( );
			}
			return shape;
		}

		/**
		 * This method checks that we don't have a currentFocus (name of the
		 * rectangle last rolled over). If a currentFocus is set we test to see
		 * if the mouse has moved out of the rectangle. When this happens we set
		 * the currentFocus to null.
		 * 
		 * If no currentFocus exists we loop through the rectangles dictionary
		 * and cal container on each rect instance and compare to the mouse x,y.
		 * When a collision is detected we set the currentFocus to the key of the
		 * rectangle the detection happen in.
		 */
		protected function detectHit(point : Point) : void 
		{
			var rectangle : Rectangle;
			var key : String;
 			
			//			try
			//			{
				
			// Check to see if anything currently has focus
			if(currentFocus) 
			{
				if(! withinHitarea( Rectangle( buttonHitAreas[currentFocus] ), point )) 
				{
					//Rectangle(rectangles[currentFocus]).contains(x, y)) {
					handleMouseOutHitarea( currentFocus );
					currentFocus = null;
 						
					// This is a FP 10 feature that allows us to set the mouse display
					Mouse.cursor = MouseCursor.ARROW;
				}
			} 
			else 
			{
 
				for (key in buttonHitAreas) 
				{
					rectangle = buttonHitAreas[key];
					if(withinHitarea( rectangle, point )) 
					{
						currentFocus = key;
						handleMouseInHitarea( key );
						// This is a FP 10 feature that allows us to set the mouse display
						Mouse.cursor = MouseCursor.BUTTON;
					}
				}
			}

		}

		protected function handleMouseInHitarea(targetName : String) : void
		{
			trace( "New Focus", targetName );
		}

		protected function handleMouseOutHitarea(targetName : String) : void
		{
			trace( "Lost Focus", targetName );			
		}

		/**
		 * Core hit test logic. Takes a rectangle and a point then tests if the
		 * point is within the target.
		 */
		protected function withinHitarea(target : Rectangle, point : Point) : Boolean 
		{
			return target.containsPoint( point );
		}

		protected function addButtonHitAreaListeners() : void
		{
//			instance.addEventListener( InteractiveScene3DEvent.OBJECT_MOVE, handleMouseMove );
//			instance.addEventListener( InteractiveScene3DEvent.OBJECT_PRESS, handleMouseDown );
//			instance.addEventListener( InteractiveScene3DEvent.OBJECT_OUT, onMouseOut );
		}

		protected function removeButtonHitAreaListeners() : void
		{
		}

		public function get buttonHitAreas() : Array
		{
			// This needs to be overriden with a way to acces the dictonary where hitAreas are registered.
			return null;
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

		public function destroy() : void
		{
		}

		public function set segmentsW(segmentsW : Number) : void
		{
			_segmentsW = segmentsW;
		}

		public function set segmentsH(segmentsH : Number) : void
		{
			_segmentsH = segmentsH;
		}

		public function set segmentsD(segmentsD : Number) : void
		{
			_segmentsD = segmentsD;
		}

		public function set useOwnContainer(useOwnContainer : Boolean) : void
		{
			_useOwnContainer = useOwnContainer;
		}

		public function get culled() : Boolean
		{
			return instance.culled;
		}

		/**
		 * 
		 * @param target
		 * 
		 */		
		public function attachTo(target : *) : Boolean
		{

			if(_instance) 
			{
				
				if(target.hasOwnProperty( "addChild" ))
				{
					target.addChild( _instance );
					return true;
				}
				else
				{
					return false;
				}
			} 
			else 
			{
				return false;
			}
		}

		public function removeFrom(target : *) : Boolean 
		{
			if(_instance) 
			{
				if(target.hasOwnProperty( "removeChild" ))
				{
					target.removeChild( _instance );
					return true;
				}
				else
				{
					return false;
				}
			} 
			else 
			{
				return false;
			}
		}

		/**
		 * When the mouse leaves the 3d object we kill any focus it may have had.
		 */
		protected function onMouseOut(event : Event) : void 
		{
			if(currentFocus) 
			{
				currentFocus = null;
				Mouse.cursor = MouseCursor.ARROW;
			}
		}

		/**
		 * Here we test that we have focus to determin of a buttonclick is valid.
		 */
		protected function handleMouseDown(event : Event) : void 
		{
			//
		}

		/**
		 * When we get a mouse move event from a 3d object we save out the x,y
		 * to our mousePoint and call detectHit.
		 */
		protected function handleMouseMove(event : Event) : void 
		{        
			if(event.hasOwnProperty( "x" ) && event.hasOwnProperty( "y" ))
			{
				mousePoint.x = event["x"];
				mousePoint.y = event["y"];
			
				detectHit( mousePoint );
			}
		}

		public function view(...params) : void
		{
			trace( "Abstract3dContainer.view(", params, ")" );
		}
	}
}