
package com.flashbum.components.containers 
{
	import gs.TweenLite;
	import gs.easing.Elastic;

	import com.flashbum.core.IDecalMaterial;
	import com.flashbum.enum.Sides;
	import com.flashbum.events.ContainerEvent;

	/**
	 * @author jessefreeman
	 */
	public class AbstractDoubleSidedContainer extends AbstractSingleSidedContainer implements IDoubleSidedContainer
	{

		protected var _front : Boolean = true;
		protected var flipBendFlag : Boolean;
		public var canFlip : Boolean = true;		protected var backMaterial : IDecalMaterial;
		protected var _flipping : Boolean;

		public function AbstractDoubleSidedContainer(id : String, xmlData : XML = null)
		{
			super( id, xmlData );
		}

		/**
		 * <p>Manages the rotation of the object and flags if the front/back is
		 * showing.</p>
		 */
		override public function set rotationY(value : Number) : void
		{
			super.rotationY = value;
			
			if(rotationY >= - 90 && rotationY <= 90)
			{
				if(! front) front = true;
			}
			else
			{
				if(front) front = false;
			}
		}

		/**
		 * <p>Returns the active BitmapMaterial so it can be drawn on.</p> 
		 */
		override public function get sketchLayer() : IDecalMaterial
		{
			if(front)
			{
				return super.sketchLayer;
			}
			else
			{
				return backMaterial;
			}
		}

		public function flip(animated : Boolean = true, recenterRotationX : Boolean = false) : void
		{
			if(canFlip)
			{
				_flipping = true;
				currentFocus = null;
								var newRotationY : Number = front ? - 180 : 0;
				
				if(animated)
				{
					//TODO replace with TweenLite
					if(recenterRotationX)
					{
						TweenLite.to(this, 1.5, {rotationX: 0, ease: Elastic.easeInOut, onUpdate: onFlipUpdate, onComplete: onFlipComplete, overwrite:false});
						//Tweener.addTween( this, {rotationX: 0, time: 1.5, transition: "easeInOutElastic", onUpdate: onFlipUpdate, onComplete: onFlipComplete} );					}
					//Tweener.addTween( this, {rotationY: newRotationY, time: 1.5, transition: "easeInOutElastic", onUpdate: onFlipUpdate, onComplete: onFlipComplete} );
					TweenLite.to(this, 1.5, {rotationY: newRotationY, ease: Elastic.easeInOut, onUpdate: onFlipUpdate, onComplete: onFlipComplete, overwrite:false});
					flipBend( );
				}
				else
				{
					if(recenterRotationX) rotationX = 0;					rotationY = newRotationY;
				}
			}
		}

		protected function flipBend() : void
		{
			//TODO replace with TweenLite
			TweenLite.to(this, 1.5, {bend: (this.bend * - 1), ease: Elastic.easeInOut, delay: .5});
			//Tweener.addTween( this, {bend: (this.bend * - 1), transition: "easeInOutElastic", time: 1.5, delay: .5} );
		}

		/**
		 * This method is called everytime Tweener updates while flipping.
		 * 
		 */
		protected function onFlipUpdate() : void
		{
		}

		/**
		 * 
		 */
		protected function onFlipComplete() : void
		{
			_flipping = false;
			dispatchEvent( new ContainerEvent( ContainerEvent.END_FLIP, true, true ) );
		}

		protected function onFront() : void
		{
			dispatchEvent( new ContainerEvent( ContainerEvent.FRONT_SIDE, true, true ) );
		}

		protected function onBack() : void
		{
			dispatchEvent( new ContainerEvent( ContainerEvent.BACK_SIDE, true, true ) );			
		}

		protected function redrawBack() : void
		{
		}

		protected function redrawFront() : void
		{
		}

		override public function get front() : Boolean
		{
			return _front;
		}

		public function set front(value : Boolean) : void
		{
			if(_front != value)
			{
				_front = value;
				if(_front)
				{
					onFront( );
				}
				else
				{
					onBack( );	
				}
				if(flipBendFlag)
				{
					flipBend( );
					flipBendFlag = false;	
				}
			}
		}

		protected function createBackMaterial() : void
		{
			// This needs to be overriden
		}

		override protected function rotateInstance(rotX : Number, rotY : Number) : void
		{
			if(! front)
			{
				rotX = rotX * - 1;
				rotY -= 180;
			}
			
			// TODO May want to clean this up so it is smart enough to tween to the right mouse position?
			calculateXRotation( rotX );
			if(! flipping)
				calculateYRotation( rotY );
		}

		public function get flipping() : Boolean
		{
			return _flipping;
		}

		public function set flipping(flipping : Boolean) : void
		{
			_flipping = flipping;
		}

		override public function active(value : Boolean, side : String = Sides.FRONT) : void
		{
			
			super.active( value );
			
			activateSide( side );
		}

		protected function activateSide(side : String) : void
		{
			switch (side)
			{
				case Sides.BACK:
					flip( );
					break;
				default:
					onFront( );
			}
		}

		override public function get buttonHitAreas() : Array
		{
			return front ? frontMaterial.buttonHitAreas : backMaterial.buttonHitAreas;
		}

		override public function view(...params) : void
		{
			var side : String = params.shift( );
			var newRotationY : Number;
			if(side == "front")
			{
				newRotationY = 0;
			}
			else
			{
				newRotationY = - 180;
			}
			TweenLite.to(this, 1.5, {rotationY: newRotationY, ease: Elastic.easeInOut, onUpdate: onFlipUpdate, onComplete: onFlipComplete, overwrite:false});
			//Tweener.addTween( this, {rotationY: newRotationY, time: 1.5, transition: "easeInOutElastic", onUpdate: onFlipUpdate, onComplete: onFlipComplete} );
		}
	}
}
