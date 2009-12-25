
package com.flashbum.core {
	import flash.events.Event;

	/**
	 * @author jessefreeman
	 */
	public interface ICardboardVision {
		function onStageResize(event : Event) : void;
		
		function gotoContainer( ... params ) : void;
		function next() : void;
		function back() : void;
		function selectContainer(id:String, side:String = "front"):void;
		function parseLocationXML(location : String, xml : XML, containerParams : Array) : void;
		function render() : void;
		function pullBack() : void;
	}
}
