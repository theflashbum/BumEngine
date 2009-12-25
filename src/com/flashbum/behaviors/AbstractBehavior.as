package com.flashbum.behaviors 
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;

	/**
	 * @author jessefreeman
	 */
	public class AbstractBehavior extends EventDispatcher implements IBehavior
	{

		protected static const OBSERVABLE_ERROR:String = "Target can not be observed";
		protected static const NOTHING_TO_OBSERVE_ERROR:String = "No observable component was set to listen to.";
		protected var _observableComponent:*;
		protected var _active:Boolean;

		public function get active():Boolean
		{
			return _active;	
		}

		/**
		 * 
		 * @param target
		 * 
		 */		
		public function set observableComponent(target:*):void
		{
			_observableComponent = target;
			active = true;
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get observableComponent():*
		{
			return _observableComponent;
		}

		/**
		 * <p>Toggles active state of the Controller. Once active listeners
		 * are added to the observable component, when deactivated they are
		 * removed. This is automated to help keep listeners in check to
		 * help avoid memory leaks.</p>
		 * @param value Boolean that represents the state the controller
		 * should be in. True is active and False is inactive.
		 */
		public function set active(value:Boolean):void 
		{
			if(observableComponent) 
			{
				if(value)
					registerEventListeners( observableComponent );
				else
					removeEventListeners( observableComponent );
				
				_active = value;
			}
			else 
			{
				throw new Error( NOTHING_TO_OBSERVE_ERROR );	
			}	
		}

		/**
		 * <p>The AbstractController contains core logic for any type of Controller
		 * in the framework. Controllers apply I/O logic to any supplied
		 * Component. Use controllers to add state and visual management in places
		 * where you would like to have reusable and portable logic. Sliders, State
		 * Managers and input forms are all kinds of controllers that can be created
		 * from this AbstractClass.</p>
		 * <p>Its also important to note that this class cannot be directly constructed,
		 * it should be extended by a concrete class.</p>
		 * 
		 * @param self Reference of an AcbstarctController, this is used to keep the
		 * AbstractController from directly being instanciated.
		 * @param target This should be any class that extends the AbstractComponent.
		 * This is the main target, or observable, that the controler will manage.
		 */
		public function AbstractBehavior(self:AbstractBehavior, target:* = null) 
		{
			if(self != this) 
			{
				throw new IllegalOperationError( "AbstractController cannot be instantiated directly." );
			}
			else 
			{
				if(target)
					observableComponent = target;
				//TODO should we passing in active and make target manditory?
			}
		}

		/**
		 * <p>In this default setup the Controller will listen to any Component 
		 * Action Event passed up from the observed target (observableComponent).
		 * When an Event is received it is passed to the onEventReceived function.</p>
		 * 
		 * @param target AbstractComponent passed in from the activate setter.
		 */
		protected function registerEventListeners(target:EventDispatcher):void 
		{
			// Override with custome event listeners
		}

		/**
		 * <p>This is the default remover of any listeners on the observable component.</p>
		 * 
		 * @param target AbstractComponent passed in from the activate setter.
		 */
		protected function removeEventListeners(target:EventDispatcher):void 
		{
			// Remove custome event listeners
		}
	}
}