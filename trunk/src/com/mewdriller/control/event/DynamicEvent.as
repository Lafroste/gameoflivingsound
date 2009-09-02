package com.mewdriller.control.event 
{
	import flash.events.Event;
	
	/**
	 * 
	 * 
	 * @author amiller
	 * @version 1.0
	 */
	public dynamic class DynamicEvent extends Event 
	{
		public function DynamicEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new DynamicEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DynamicEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}