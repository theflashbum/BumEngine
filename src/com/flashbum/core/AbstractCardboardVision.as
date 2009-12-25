package com.flashbum.core 
{
	import com.flashartofwar.bootstrap.managers.URIManager;

	import camo.core.utils.TypeHelperUtil;

	import com.asual.swfaddress.SWFAddress;
	import com.flashbum.components.containers.I3dContainer;
	import com.flashbum.components.containers.ISingleSidedContainer;
	import com.flashbum.components.layouts.ILayout;
	import com.flashbum.enum.Packages;
	import com.flashbum.enum.Sides;
	import com.flashbum.events.ContainerEvent;
	import com.flashbum.events.LoadEvent;
	import com.flashbum.utils.ArrayUtil;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	public class AbstractCardboardVision extends Sprite implements ICardboardVision
	{

		protected static const CONTAINER_PATH_NAME:String = "container";
		protected static const EDIT_PATH_NAME:String = "edit";
		protected static const ZOOM_PATH_NAME:String = "zoom";
		protected static const CONTAINER_VIEW_MODE:String = "view";
		//		protected static const ACTION_PARAM : Number = 0;
		//		protected static const CONTAINER_ID_PARAM : Number = 1;
		//		protected static const ZOOM_LEVEL_PARAM : Number = 1;
		//		protected static const CONTAINER_MODE_PARAM : Number = 2;
		//		protected static const CONTAINER_SIDE_PARAM : Number = 3;
		//		protected static const CONTAINER_EDIT_MODE : String = "edit";
		protected var containerInstances:Array = [];
		protected var zoomLevel:Number = 6;
		protected var maxZoomLevel:Number = 6;
		protected var zoomAmount:Number = - 1000;
		protected var currentContainer:I3dContainer;
		protected var layoutClassName:String;
		protected var randomizeLayout:Boolean = true;
		//protected var _containerMode : String;
		//protected var _sketchArea : AbstractSketchArea;
		protected var layout:ILayout;
		protected var indexByID:Array = [];
		protected var idByContainerInstance:Dictionary = new Dictionary( true );
		protected var mouseMovement:Boolean = true;
		protected var _defaultContainer:String;
		protected var totalContainers:int = 0;
		protected var debug:Boolean = false;
		protected var location:String;
		protected var containerBasePackage:String;
		protected var uriManager:URIManager = URIManager.instance;

		public function AbstractCardboardVision() 
		{
			init( );
		}

		protected function init():void
		{
			setup3dEngine( );
		}

		/**
		 * <p>This checks to see if there is a container in focus. If so it calcualtes
		 * the mouse movement then calls render on the container. Once that is
		 * compleate we render the scene.</p>
		 * 
		 */		
		public function render():void 
		{
			
			if(currentContainer && mouseMovement) 
			{	
				calculateMouseMovement( );
			}
		}

		/**
		 * <p>This goes to the next container.</p>
		 */
		public function next():void 
		{
			var currentID:Number = containerInstances.indexOf( currentContainer );
			if(currentID != - 1)
				selectContainerByIndex( (currentID < containerInstances.length - 1) ? currentID + 1 : currentID );
		}

		/**
		 * <p>This goes to the previous container.</p>
		 */
		public function back():void 
		{
			var currentID:Number = containerInstances.indexOf( currentContainer );
			if(currentID != - 1)
				selectContainerByIndex( (currentID > 0) ? currentID - 1 : currentID );
		}

		/**
		 * <p>Pulls the camera back by changing the zoom level url.</p>
		 */
		public function pullBack():void 
		{
			if(zoomLevel < maxZoomLevel) 
			{
				clearFocus( );
				
				var newZoomLevel:Number = zoomLevel + 1;
				SWFAddress.setValue( location + "/" + ZOOM_PATH_NAME + "/" + newZoomLevel + "x" );
			}
		}

		/**
		 * 
		 * @param xml
		 * 
		 */		
		public function parseLocationXML(location:String, xml:XML, containerParams:Array):void 
		{
			clearContainers( );
			
			this.location = location;
			layoutClassName = xml.@layout;
			randomizeLayout = TypeHelperUtil.stringToBoolean( xml.@random );
			if(xml.@defaultContainer)
				defaultContainer = xml.@defaultContainer;
			
			var containers:XMLList = xml.*;

			for each (var container:XML in containers) 
			{
				createContainer( container );
			}
			
			layoutContainers( );
			
			try
			{
				if((containerParams.length == 0))
				{
					selectContainer( idByContainerInstance[containerInstances[0].instance] );
				}
				else
				{
					gotoContainer.apply( null, containerParams );
				}
			}
			catch(error:Error)
			{
				trace( "There was a problem trying to load the default container." );	
			}
		}

		/**
		 * Navigates to a particular container.
		 */
		public function gotoContainer( ... params ):void 
		{
			var action:String = params.shift( );
			try
			{
				if(this.hasOwnProperty( action ))
				{
					this[action].apply( this, params );
				}
				else
				{
					trace( "Couldn't handle action", action );
				}
			}
			catch(error:Error)
			{
				trace( action, "is not supported" );
			}
			/*
			switch(action) 
			{
				case ZOOM_PATH_NAME:
					var zoomLevel : Number = Number( String( params[ZOOM_LEVEL_PARAM] ).substr( 0, - 1 ) );
					zoomOut( zoomLevel );
					break;
				
				case CONTAINER_PATH_NAME: 
					var containerIDParam : String = params[CONTAINER_ID_PARAM];
					var side : String = Sides.validateSide( params[CONTAINER_SIDE_PARAM] );
					var mode : String = ContainerModes.validateMode( params[CONTAINER_MODE_PARAM] );
					trace( "side", side, "mode", mode, params );	
					var container : I3dContainer = indexByID[containerIDParam];
					
					if(container) 
					{
						if(container == currentContainer) 
						{
							trace( "We are already looking at that container" );
							containerMode = mode;
							if(container is IDoubleSidedContainer) 
							{
								trace( "Container can be flipped", ISingleSidedContainer( container ).front, side );
								IDoubleSidedContainer( container ).flip( );
							}
						} 
						else 
						{
							moveToContainer( container.id, side, mode );
						}
					}
						
					break;

				default:
					trace( "Couldn't find that url" );
					break;
			}
			
			 */
		}

		/**
		 * Rest API for zooming.
		 */
		public function zoom( ... params ):void
		{
			var zoomLevel:Number = Number( String( params.shift( ) ).substr( 0, - 1 ) );
			zoomOut( zoomLevel );
		}

		/**
		 * Rest API for accessing the container
		 */
		public function container( ... params ):void
		{
			var containerID:String = params[0];
			
			if(currentContainer) 
			{
				if(containerID == currentContainer.id) 
				{
					//We are already looking at that container
					containerAction.apply( this, params.slice( 1 ) );
				}
				else
				{
					moveToContainer.apply( this, params );
				}
			}
			else
			{
				moveToContainer.apply( this, params );
			}
		}

		protected function containerAction(...params):void
		{
			trace( "AbstractCardboardVision.containerAction(", params, ")" );
			var action:String = params.shift( );
			try
			{
				currentContainer[action]( params );
			}
			catch(error:Error)
			{
				trace( "Can't call action", action, "on currentContaienr." );
			}
		}

		/**
		 * <p>This can select a container by it's index number.</p>
		 */
		protected function selectContainerByIndex(index:Number):void 
		{
			var containerInstance:I3dContainer = containerInstances[index];
			
			selectContainer( containerInstance.id );
		}

		/**
		 * <p>Sets up and configures papervision. This function can be overriden
		 * to accomidate any custom set ups you may need for your project.</p>
		 * 
		 */			
		protected function setup3dEngine():void 
		{
			// Override with your 3d engine of choice.
		}

		protected function clearContainers():void 
		{
			var total:int = containerInstances.length;
			var tempContainer:I3dContainer;
			
			for (var i:int = 0; i < total ; i ++) 
			{
				tempContainer = containerInstances[i];
			
				removeContainer( tempContainer );
			}
			
			containerInstances.length = 0;
			indexByID.length = 0;
			totalContainers = 0;
			idByContainerInstance = new Dictionary( true );
		}

		/**
		 * 
		 * @param data
		 * 
		 */		
		protected function createContainer(data:XML):I3dContainer 
		{
			var tempContainer:I3dContainer;
			var className:String = data.@["class"];
			               
			if(className) 
			{
				try 
				{
					var tempClass:Class = getDefinitionByName( containerBasePackage + className ) as Class;
					
					var id:String = data.@id || "container";
					var styleID:String = "";//data.@styleid + " " || "";
					tempContainer = new tempClass( styleID + id, data );
					
					containerInstances.push( tempContainer );
					
					attachContainer( id, tempContainer );
			
					// use this to find the container by id
					indexByID[id] = tempContainer;
					
					totalContainers ++;
				}
				catch(errObject:Error) 
				{
					trace( "Could not create container", containerBasePackage + className, ". Error:", errObject );
				}
			}
			return tempContainer;
		} 

		protected function attachContainer(id:String, target:I3dContainer):void
		{
		}

		protected function removeContainer(target:I3dContainer):void
		{
		}

		/**
		 * 
		 */
		protected function addContainerMouseListeners(target:IEventDispatcher):void 
		{
		}

		/**
		 * 
		 */
		protected function removeContainerMouseListeners(target:IEventDispatcher):void 
		{
		}

		/**
		 * 
		 */
		protected function onContainerOut(event:Event):void 
		{
			Mouse.cursor = MouseCursor.ARROW;
		}

		/**
		 * 
		 */
		protected function onContainerOver(event:Event):void 
		{
			Mouse.cursor = MouseCursor.BUTTON;
		}

		/**
		 * 
		 * @param event
		 * 
		 */		
		protected function onContainerClick(event:Event):void 
		{
		}

		/**
		 * <p>This creates a new Layout class based on the Class name in the location
		 * XML. It also shuffle's the containers.</p>
		 */
		protected function layoutContainers():void 
		{
			
			if(randomizeLayout)
				ArrayUtil.shuffle( containerInstances );

			var tempClass:Class = getDefinitionByName( Packages.LAYOUT_BASE_PACKAGE + layoutClassName ) as Class;
			layout = new tempClass( );

			layout.addContainers.apply( this, containerInstances.slice( ) );
		}

		/**
		 * <p>When a container is click on it is consider to be selected. Here we
		 * clear any previous focues, set the new swf address, and finally tween
		 * the camare to the new container's coordinates.</p>
		 */
		public function selectContainer(id:String, side:String = "front"):void 
		{
			
			var token:Object = {location: location, id: id, side:side};
			var url:String = uriManager.getURI("selectContainer", token);
			
			//SWFAddress.setValue( location + "/" + CONTAINER_PATH_NAME + "/" + id + "/" + CONTAINER_VIEW_MODE + "/" + Sides.FRONT );
			SWFAddress.setValue( url );
		}

		/**
		 * <p>This handles the actual tween to the new location. We use the
		 * passed in target's x,y and z to move the camera.</p>
		 */
		protected function moveToContainer( ...params ):void 
		{
			clearFocus( );
		}

		public function panCamera(x:Number, y:Number, z:Number, rotation:Number = 0, time:Number = 1, delay:Number = .5, completeParams:Array = null):void
		{
			// Put in logic to move the camera to target position. This is different
			// depending on the 3d Engine you will use.
		}

		/**
		 * <p>Once the camra is stopped moving we consider it in focus. Here we set
		 * the zoomLevel to 1, set the currentFocus to the target, remove press
		 * event listeners and finally call the active method on the container.</p>
		 */
		protected function onCameraFocused(id:String, side:String, mode:String):void 
		{
			zoomLevel = 1;
			mouseMovement = true;
			//currentDisplayObject3d = target;
			
			
			// Set a reference to the currentContainer
			currentContainer = indexByID[id] as I3dContainer;
			
			// Hnadle Event Listeners
			removeContainerMouseListeners( currentContainer.instance );
			addContainerEventListeners( currentContainer );
			
			// Activates the container
			currentContainer.active( true, side );
			
			//_containerMode = mode;
			removeOutOfViewContainers( );
		}

		/**
		 * <p>To cut down on render overhead we loop through all the continers off
		 * the stage and remove then frmo the scene.</p>
		 */
		protected function removeOutOfViewContainers():void 
		{
			var i:int;
			var total:int = totalContainers;
			var removed:int = 0;
			var tempContainer:I3dContainer;
			
			for (i = 0; i < total ; i ++) 
			{
				tempContainer = containerInstances[i];
				//TODO need to find the Away3d equivilent to culled;
//				if(testContainerisCulled( tempContainer )) 
//				{
//					removeContainer( tempContainer );
//					removed ++;
//				}
			}
			trace( "Removed", removed, "containers" );
		}

		protected function testContainerisCulled(target:I3dContainer):Boolean
		{
			return target.culled;
		}

		/**
		 * <p>When we are ready to move we put all the containers back on the scene.</p>
		 */
		protected function restoreContainers():void 
		{
			var i:int;
			var total:int = totalContainers;
			var tempContainer:I3dContainer;
			
			for (i = 0; i < total ; i ++) 
			{
				tempContainer = containerInstances[i];
				attachContainer( tempContainer.id, tempContainer );
			}
		}

		/**
		 * <p>We add listeners to each container to handle core logic such as 
		 * when to flip, location change requests, and mouse movement.</p>
		 */
		protected function addContainerEventListeners(target:IEventDispatcher):void 
		{
			target.addEventListener( ContainerEvent.FLIP, onContainerFlip );
			target.addEventListener( ContainerEvent.ENABLE_MOUSE_MOVEMENT, onEnableMouseMovement );
			target.addEventListener( ContainerEvent.DISSABLE_MOUSE_MOVEMENT, onDissableMouseMovement );
			target.addEventListener( LoadEvent.LOCATION, onLoadLocation );
		}

		/**
		 * <p>This is called when a new location is requested. We change the url
		 * and through SWFAddress and everything else is taken care of by the 
		 * main controller.</p>
		 */
		protected function onLoadLocation(event:LoadEvent):void 
		{
			SWFAddress.setValue( event.url );
		}

		/**
		 * <p>Here we remove all listerns when they are no longer needed.</p>
		 */
		protected function removeContainerEventListeners(target:IEventDispatcher):void 
		{
			target.removeEventListener( ContainerEvent.FLIP, onContainerFlip );
			target.removeEventListener( ContainerEvent.ENABLE_MOUSE_MOVEMENT, onEnableMouseMovement );
			target.removeEventListener( ContainerEvent.DISSABLE_MOUSE_MOVEMENT, onDissableMouseMovement );
			target.removeEventListener( LoadEvent.LOCATION, onLoadLocation );
		}

		protected function onEnableMouseMovement(event:ContainerEvent):void 
		{
			mouseMovement = true;
		}

		protected function onDissableMouseMovement(event:ContainerEvent):void 
		{
			mouseMovement = false;
		}

		protected function onContainerFlip(event:ContainerEvent):void 
		{
			var side:String = ISingleSidedContainer( event.target ).front ? Sides.BACK : Sides.FRONT;
			
			SWFAddress.setValue( location + "/" + CONTAINER_PATH_NAME + "/" + currentContainer.id + "/" + side );
		}

		/**
		 * This clears the currentFocus instance but readding mouse listener
		 * (so the engine can recieve click events) as well as resetting the
		 * container. Also the cama focus and currentFocus are set to null.
		 */
		protected function clearFocus():void 
		{
			if(currentContainer) 
			{
				removeContainerEventListeners( currentContainer );
				
				//containerMode = ContainerModes.NONE;
				addContainerMouseListeners( currentContainer.instance );
				
				currentContainer.active( false );
				
				//_containerMode = null;
				
				//currentDisplayObject3d = null;
				currentContainer = null;
				restoreContainers( );
			}	
		}	

		/**
		 * <p>Performs the actual zoom tween.</p>
		 */
		protected function zoomOut(overrideLevel:Number = NaN):void 
		{
			zoomLevel = isNaN( overrideLevel ) ? zoomLevel ++ : (overrideLevel <= maxZoomLevel) ? overrideLevel : maxZoomLevel;
			
			tweenCameraZ( (zoomLevel * zoomAmount) );
		}

		protected function tweenCameraZ(z:Number, speed:Number = 1, delay:Number = 0):void
		{
			//TweenLite.to( camera, speed, {z: z, delay:delay, ease: Quart.easeInOut} );
		}

		/**
		 * 
		 * <p>Here we take the mouse's movement to rotate the 3d instance.</p>
		 * 
		 */		
		protected function calculateMouseMovement():void 
		{
			if(stage) 
			{
				currentContainer.calculateMouseMovement( mouseX, mouseY, stage.stageWidth, stage.stageHeight );
			}
		}

		/**
		 * This sets the container mode and activates any special actions by the
		 * CarboardVision Engine.
		 */
		//		public function set containerMode(mode : String) : void
		//		{
		//			trace( "CardboardVision.containerMode(", mode, ")" );
		//			_containerMode = mode;
		//			switch (mode)
		//			{
		//				case(CONTAINER_EDIT_MODE):
		//									trace( "Ready to activate the Sketcher Controller" );
		//									// We need to activate the edit engine and pass it a container.
		//									if(currentContainer is ISketchable)
		//									{
		//										mouseMovement = false;
		//										currentContainer.resetXY( );
		//										
		//										createSketchArea();
		//										//_sketchArea.activateDraw( );
		//									}
		//									else
		//									{
		//										trace( "Current container could not be used with the SketchArea." );
		//									}
		//									break;
		//				
		//				default:
		//					removeSketchArea( );
		//					mouseMovement = false;
		//					
		//					 Do nothing, we just want to look but not touch.
		//					break;
		//			}
		//		}

		//		protected function createSketchArea() : void
		//		{
		//			// This needs to have a sketchArea instanciated.
		//			//_sketchArea = new AbstractSketchArea( currentContainer as ISketchable );
		//		}
		//
		//		protected function removeSketchArea() : void
		//		{
		////			if(_sketchArea)
		////			{
		////				_sketchArea.activateDraw( );
		////				_sketchArea = null;
		////			}
		//		}

		//		public function get sketchArea() : AbstractSketchArea
		//		{
		//			return _sketchArea;
		//		}
		public function get defaultContainer():String
		{
			return (doesContainerExist( _defaultContainer )) ? _defaultContainer : containerInstances[0];
		}

		public function set defaultContainer(defaultContainer:String):void
		{
			_defaultContainer = defaultContainer;
		}

		public function doesContainerExist(name:String):Boolean
		{
			return indexByID[name];
		}
		
		public function onStageResize(event : Event) : void {
			
		}
	}
}