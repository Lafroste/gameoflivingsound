package com.mewdriller.sound 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * 
	 * @author amiller
	 * @version 1.0
	 */
	public class Tone extends EventDispatcher
	{
		public static const SAMPLING_RATE:Number = 44100;
		public static const BUFFER_SIZE:int = 8192;
		
		public static const UNIT:int = 10;
		
		private var sound:Sound;
		
		private var phase:Number = 0;
		private var amplify:Number = 0;
		
		private var state:int = 1; // 1: Attack, 2: Decay, 3: Release
		
		private var frequency:Number;
		private var length:Number;
		private var volume:Number;
		private var attack:Number;
		private var decay:Number;
		private var sustain:Number;
		private var release:Number;
		
		private var v1:Number;
		private var v2:Number;
		private var v3:Number;
		
		public function Tone(noteNumber:uint, length:Number, volume:Number, attack:Number, decay:Number, sustain:Number, release:Number)
		{    
			this.frequency = noteNumber2frequency(noteNumber);
			this.length = length;
			this.volume = volume;
			this.attack = attack;
			this.decay = decay;
			this.sustain = sustain;
			this.release = release;
			
			check();
			initializeVelocity();
		}
		
		private function check():void
		{
			if (attack + decay + release != UNIT)
			{
				attack = 0;
				decay = 5;
				release = 5;
			}
			
			if (volume > UNIT) volume = UNIT;
			
			if (volume < 0) volume = 0;
			
			if (sustain > UNIT) sustain = UNIT;
			
			if (sustain < 0) sustain = 0;
		}
		
		private function initializeVelocity():void
		{            
			v1 = volume / (SAMPLING_RATE * length * attack / UNIT);
			v2 = (volume - sustain) / (SAMPLING_RATE * length * decay / UNIT);
			v3 = sustain / (SAMPLING_RATE * length * release / UNIT);
		}
		
		private function updateAmplify():void
		{
			if (state == 1)
			{
				amplify += v1;
				
				if (amplify >= volume)
				{
					amplify = volume;
					state = 2;
				}
			}
			else if (state == 2)
			{
				amplify -= v2;
				
				if (volume < sustain)
				{
					if (amplify >= sustain)
					{
						amplify = sustain;
						state = 3;
					}
				}
				else
				{
					if (amplify <= sustain)
					{
						amplify = sustain;
						state = 3;
					}
				}    
			}
			else if (state == 3)
			{
				amplify -= v3;
				
				if (amplify <= 0)
				{
					amplify = 0;	
					stop();
				}
			}
		}
		
		public function start():void
		{                    
			sound = new Sound();
			sound.addEventListener(SampleDataEvent.SAMPLE_DATA, soundSampleDataHandler);
			sound.play();
		}
		
		public function stop():void
		{
			sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, soundSampleDataHandler);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function soundSampleDataHandler(event:SampleDataEvent):void
		{    
			var bytes:ByteArray = new ByteArray();
			
			for (var i:int = 0; i < BUFFER_SIZE; ++i)
			{
				phase += frequency / SAMPLING_RATE;  
				
				var phaseAngle:Number = phase * Math.PI * 2;
				var sample:Number = Math.sin(phaseAngle) * amplify / UNIT;
				
				sample *= 0.2;
				
				bytes.writeFloat(sample);
				bytes.writeFloat(sample);
				
				updateAmplify();
			}
			
			event.data.writeBytes(bytes);
		}
		
		private function noteNumber2frequency(value:uint):Number
		{
			if (value > 127) value = 127;
			return 440 * Math.pow(2, (value - 69) / 12);
		}
	}
}