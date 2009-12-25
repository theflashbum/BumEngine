
package com.flashbum.components.containers 
{
	import camo.core.decal.IBaseDecal;

	import com.flashbum.core.IDecalMaterial;

	/**
	 * @author jessefreeman
	 */
	public class AbstractSingleSidedContainer extends Abstract3dContainer implements ISingleSidedContainer/*, ISketchable*/
	{

		protected var frontMaterial : IDecalMaterial;
		protected var _percise : Boolean;
		
		public function AbstractSingleSidedContainer(id : String, xmlData : XML = null)
		{
			super( id, xmlData );
		}
		
		override public function get buttonHitAreas() : Array
		{
			return frontMaterial.buttonHitAreas;
		}
		
		/**
		 * Returns a Shape instance that can be drawn on.
		 */
		public function get sketchLayer() : IDecalMaterial
		{
			return frontMaterial;
		}

		public function get front() : Boolean
		{
			return true;
		}

		protected function createFrontMaterial() : void
		{
		}

		protected function addFrontEventListeners() : void
		{
		}

		protected function removeFrontEventListeners() : void
		{
		}
		
		protected function createDecalMaterial(decal:IBaseDecal) : IDecalMaterial
		{
			return null;
		}
		
		public function get material() : *
		{
			return frontMaterial;
		}
		
		/**
		 * 
		 */
		public function set percise(percise : Boolean) : void
		{
			_percise = percise;
		}
		
		protected function create3dObject() : *
		{
			return null;
		}
	}
}
