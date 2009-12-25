package 
{
	import com.flashartofwar.bootstrap.utils.TokenUtil;
	import camo.core.events.LoaderManagerEvent;
	import camo.core.managers.DecalSheetManager;

	import gs.TweenLite;

	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.flashartofwar.bootstrap.managers.SettingsManager;
	import com.flashartofwar.bootstrap.managers.URIManager;
	import com.flashartofwar.fcss.managers.StyleSheetManager;
	import com.flashbum.core.ICardboardVision;
	import com.flashbum.managers.GlobalDecalSheetManager;

	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class AbstractBumEngine extends Sprite 
	{

		protected var cardboardVision:ICardboardVision;
		protected var background:Sprite = new Sprite( );
		protected var decalSheetManager:DecalSheetManager;
		protected var location:String;
		protected var containerParams:Array;
		protected var preloaderGraphic:Shape;
		protected var defaultLocation:String;
		protected var uriManager:URIManager = URIManager.instance;
		protected var settings:SettingsManager;

		/**
		 * 
		 * 
		 */		
		public function AbstractBumEngine() 
		{
			configureFlashParams( );
			configureStage( );
		}

		protected function configureFlashParams():void
		{
			loadConfig( stage.loaderInfo.parameters.configURL );
		}

		private function loadConfig(url:String):void
		{
			var configLoader:URLLoader = new URLLoader( );
			configLoader.addEventListener( Event.COMPLETE, onConfigLoaded );
			configLoader.load( new URLRequest( url ) );
		}

		private function onConfigLoaded(event:Event):void
		{
			var loader:URLLoader = URLLoader( event.target );
			var xml:XML = XML( loader.data );
			activateBootstrap( xml );
			
			createPreloader( );
			loadFonts( );
		}

		protected function activateBootstrap(configXML:XML):void
		{
			var nodes:XMLList = configXML.*;
			var node:XML;
			var handler:String;
			for each(node in nodes)
			{
				try
				{
					handler = node.@handler;
					trace(handler, hasOwnProperty(handler));
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
			settings = SettingsManager.instance;
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

		protected function createPreloader():void 
		{
			preloaderGraphic = new Shape( );
			preloaderGraphic.graphics.beginFill( 0xffffff, .7 );
			preloaderGraphic.graphics.drawRect( 0, 0, stage.stageWidth, 10 );
			preloaderGraphic.graphics.endFill( );
			
			updatePreloader( .5 );
			
			addChild( preloaderGraphic );
		}

		protected function updatePreloader(percent:Number, animated:Boolean = true):void 
		{

			if(animated) 
			{
				TweenLite.to( preloaderGraphic, .3, {scaleX: percent} );	
			} 
			else 
			{
				preloaderGraphic.scaleX = percent;
			}
		}

		/**
		 * <p>This method handles splitting up a url give as a rest paramater,
		 * into chucks each part of the app can handle. In this controller we
		 * simply check the first item, we expect this to be the name of a
		 * location file, and load it up. If we do need to load the rest of the
		 * params are saved temporarly until the load is complete.</p> 
		 */
		public function goto( ...paths ):void 
		{
			var newLocal:String = paths.shift( );
			
			if(newLocal == null) newLocal = defaultLocation;
			
			containerParams = paths.slice( );
			
			if (newLocal != location) 
			{
				// We need to laod a new location
				location = newLocal;
				
				var token:Object = {filename:newLocal};
				
				loadXML( uriManager.getURI( "locations", token ) );//locationPath + location + locationFileExtension );
			} 
			else 
			{
				// We have recieved a change in the same location so just pass
				// down the remaining params.
				cardboardVision.gotoContainer.apply( null, containerParams );
			}
		}

		/**
		 * <p>This is the controller for SWFAddress. Once a chnage event is recieved
		 * it is passed off to the goto method then trickles down into the core
		 * of the application.</p>
		 * 
		 */
		protected function handleSWFAddress(event:SWFAddressEvent):void 
		{
			goto.apply( null, SWFAddress.getPathNames( ) );
		}

		/**
		 * <p>Configures the stage and sets the scale mode to keep visuals from
		 * distorting when resizing the browser window.</p>
		 * 
		 */			
		protected function configureStage():void 
		{  
			stage.align = StageAlign.TOP_LEFT; 
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener( Event.RESIZE, onStageResize );
		}

		protected function onStageResize(event:Event):void 
		{
			
			screenResizeRedraw( );
		}

		protected function screenResizeRedraw():void 
		{
			
			//TODO this is buggy and needs to be looked at.
			if(preloaderGraphic)
			{
				var curScale:Number = preloaderGraphic.scaleX;
				preloaderGraphic.width = stage.stageWidth;
				preloaderGraphic.scaleX = curScale;
			}
			redrawBackground( );
		}

		protected function loadFonts():void 
		{
			var fontLoader:Loader = new Loader( );
			fontLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onFontsLoaded );
			fontLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
			
			var uri:String = uriManager.getURI( "fonts", {filename: "FlashBumFontLibrary"} );
			
			fontLoader.load( new URLRequest( uri ) );
		}

		protected function onLoaderProgress(event:ProgressEvent):void 
		{
			updatePreloader( event.bytesLoaded / event.bytesTotal );
		}

		protected function onFontsLoaded(event:Event):void 
		{
			// Remove listeners
			var loader:Loader = event.target as Loader;
			//			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onFontsLoaded );
			//			loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
			updatePreloader( 0 );
			
			loadCSS( );
		}

		protected function loadCSS():void 
		{
			var urlLoader:URLLoader = new URLLoader( );
			urlLoader.addEventListener( Event.COMPLETE, onCSSLoad, false, 0, true );
			urlLoader.addEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
			
			var uri:String = uriManager.getURI( "css", {filename: "global.styles"} );
			urlLoader.load( new URLRequest( uri ) );//"css/global.styles.css" ) );
		}

		protected function onCSSLoad(event:Event):void 
		{
			event.target.removeEventListener( Event.COMPLETE, onCSSLoad );
			event.target.removeEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
			updatePreloader( 0 );
			
			StyleSheetManager.collection.parseCSS( event.target.data, true );
        	
			loadDecalXML( );
		}

		protected function loadDecalXML():void 
		{
			var urlLoader:URLLoader = new URLLoader( );
			urlLoader.addEventListener( Event.COMPLETE, onDecalXMLLoaded, false, 0, true );
			
			var uri:String = uriManager.getURI( "decalsheets", {filename:"decals"} );
			
			urlLoader.load( new URLRequest( uri ) );//"xml/decals.xml" ) );
		}

		protected function onDecalXMLLoaded(event:Event):void 
		{
			event.target.removeEventListener( Event.COMPLETE, onCSSLoad );
        	
			decalSheetManager = GlobalDecalSheetManager.instance;
			decalSheetManager.addEventListener( LoaderManagerEvent.PRELOAD_DONE, onDecalsLoaded );
			decalSheetManager.addEventListener( LoaderManagerEvent.COMPLETE, onDecalLoaded );
			decalSheetManager.addEventListener( LoaderManagerEvent.PROGRESS, onDecalSheetProgress );
			decalSheetManager.parseXML( XML( event.target.data ) );
		}

		protected function onDecalLoaded(event:LoaderManagerEvent):void 
		{
			updatePreloader( 0 );
		}

		protected function onDecalSheetProgress(event:LoaderManagerEvent):void 
		{
			updatePreloader( event.data.percent );
		}

		protected function onDecalsLoaded(event:LoaderManagerEvent):void 
		{
			decalSheetManager.removeEventListener( LoaderManagerEvent.PRELOAD_DONE, onDecalsLoaded );
			
			updatePreloader( 0 );
			init( );
		}

		/**
		 * 
		 * 
		 */        
		protected function init():void 
		{
			// Creates Background Button
			addChildAt( background, 0 );
			
			createCardboardVision( );
			
			screenResizeRedraw( );
			
			// Setup SWFAddress
			SWFAddress.addEventListener( SWFAddressEvent.CHANGE, handleSWFAddress );
		}

		protected function createCardboardVision():void 
		{
			throw new Error( "You must extend this class and create the correct 3d Engine. Example cardboardVision = new CardboardVisionPv3d()" );
		}

		/**
		 * <p>This acts as a large button you can use to deteck mouse clicks on the
		 * background inorder to pull back the camera.</p>
		 */
		protected function redrawBackground():void 
		{
			try
			{
				background.graphics.beginFill( settings.backgroundColor );
				background.graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
				background.graphics.endFill( );
				background.addEventListener( MouseEvent.CLICK, onBackgroundClick );
			}
			catch(error:Error)
			{
				// background couldn't be drawn
			}
		}

		/**
		 * <p>Loads in location XML to configure the 3d engine.</p>
		 */        
		protected function loadXML(url:String):void 
		{
			var urlLoader:URLLoader = new URLLoader( );
			urlLoader.addEventListener( Event.COMPLETE, onLoad, false, 0, true );
			urlLoader.load( new URLRequest( url ) );	
		}

		/**
		 * <p>When a location has been loaded we change the Title of the page
		 * via SWFAddress, have cardboardVision instance parse the xml, and
		 * activate the enterframe loop.</p>
		 */        
		protected function onLoad(event:Event):void 
		{
			updateTitle();
			
			cardboardVision.parseLocationXML( location, XML( event.target.data ), containerParams );
        	
			if(! hasEventListener( Event.ENTER_FRAME ))
        		addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		protected function updateTitle():void
		{
			var token:Object = {loctation: location};
			var title:String = TokenUtil.replaceTokens(settings.title, token);
			
			SWFAddress.setTitle( title );
			
		}
		
		/**
		 * <p>This is the main render loop for the app. It is responsible for 
		 * rendering out the carboardVision instance.</p>
		 */        
		protected function onEnterFrame(event:Event):void 
		{
			cardboardVision.render( );
		}

		/**
		 * <p>Pulls back the camera when a click is detected on the Background.</p>
		 */
		protected function onBackgroundClick(event:MouseEvent):void 
		{
			cardboardVision.pullBack( );
		}
	}
}
