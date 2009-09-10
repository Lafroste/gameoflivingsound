﻿package com.mewdriller.sound
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;

	public class Tone extends EventDispatcher
	{
		public static const SAMPLING_RATE:Number = 44100;
		public static const BUFFER_SIZE:int = 8192;
		
		public static const UNIT:int = 10;
		
		private var s_length:Number;
		private var s_volume:Number;
		private var s_attack:Number;
		private var s_decay:Number;
		private var s_sustain:Number;
		private var s_release:Number;
		
		public function Tone(length:Number, volume:Number, attack:Number, decay:Number, sustain:Number, release:Number, isOn:Vector.<Boolean>)
		{	
			s_length = length;
			s_volume = volume;
			s_attack = attack;
			s_decay = decay;
			s_sustain = sustain;
			s_release = release;
			this.isOn = isOn; 
			
			reset();
		}
		
		private var sound:Sound;
		
		private var phase:Number = 0;
		private var phase2:Number = 0;
		private var phase3:Number = 0;
		private var phase4:Number = 0;
		private var phase5:Number = 0;
		private var phase6:Number = 0;
		private var phase7:Number = 0;
		private var phase8:Number = 0;
		private var phase9:Number = 0;
		private var phase10:Number = 0;
		private var phase11:Number = 0;
		private var phase12:Number = 0;
		private var phase13:Number = 0;
		private var phase14:Number = 0;
		private var phase15:Number = 0;
		private var phase16:Number = 0;
		
		private var sample:Number = 0;
		private var sample2:Number = 0;
		private var sample3:Number = 0;
		private var sample4:Number = 0;
		private var sample5:Number = 0;
		private var sample6:Number = 0;
		private var sample7:Number = 0;
		private var sample8:Number = 0;
		private var sample9:Number = 0;
		private var sample10:Number = 0;
		private var sample11:Number = 0;
		private var sample12:Number = 0;
		private var sample13:Number = 0;
		private var sample14:Number = 0;
		private var sample15:Number = 0;
		private var sample16:Number = 0;
		
		private var amplify:Number = 0;
		
		private var state:int = 1; // 1: Attack, 2: Decay, 3: Release
		
		private var frequency:Number;
		private var length:Number;
		private var volume:Number;
		private var attack:Number;
		private var decay:Number;
		private var sustain:Number;
		private var release:Number;
		private var isOn:Vector.<Boolean>;
		private var step:Vector.<Number> = new Vector.<Number>();
		private var toner:Array = [220, 246.942, 293.665, 329.628, 369.994, 440, 493.883, 587.33, 659.255, 739.989, 880, 987.767, 1174.656, 1318.51, 1479.978, 1760];
		
		private var v1:Number;
		private var v2:Number;
		private var v3:Number;
		
		private function check():void
		{
			if (attack + decay + release != UNIT)
			{
				attack = 0;
				decay = 5;
				release = 5;
			}
				
			if (volume > UNIT)
				volume = UNIT;
			
			if (volume < 0)
				volume = 0;
				
			if (sustain > UNIT)
				sustain = UNIT;
				
			if (sustain < 0)
				sustain = 0;
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
			reset();
			
			buildChord();				
			sound = new Sound();
			sound.addEventListener(SampleDataEvent.SAMPLE_DATA, soundSampleDataHandler);
			sound.play();
		}
		
		private function buildChord():void
		{
			
			
			for (var i:Number = 0; i < 16; i++)
			{
				if (isOn[i])
				{
					step.push(toner[i]);
					
				}
				else step.push(0);
				
			}
		}
		
		private function reset():void 
		{
			step = new Vector.<Number>;
			phase = phase2 = phase3 = phase4 = phase5 = phase6 = phase7 = phase8 = phase9 = phase10 = phase11 = phase12 = phase13 = phase14 = phase15 = phase16 = 0;
			sample = sample2 = sample3 = sample4 = sample5 = sample6 = sample7 = sample8 = sample9 = sample10 = sample11 = sample12 = sample13 = sample14 = sample15 = sample16 = 0;
			
			attack = s_attack;
			decay = s_decay;
			length = s_length;
			release = s_release;
			sustain = s_sustain;
			volume = s_volume;
			
			check();
			initializeVelocity();
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
				phase += step[0] / SAMPLING_RATE;
				phase2 += step[1] / SAMPLING_RATE;
				phase3 += step[2] / SAMPLING_RATE;
				phase4 += step[3] / SAMPLING_RATE;
				phase5 += step[4] / SAMPLING_RATE;
				phase6 += step[5] / SAMPLING_RATE;
				phase7 += step[6] / SAMPLING_RATE;
				phase8 += step[7] / SAMPLING_RATE;
				phase9 += step[8] / SAMPLING_RATE;
				phase10 += step[9] / SAMPLING_RATE;
				phase11 += step[10] / SAMPLING_RATE;
				phase12 += step[11] / SAMPLING_RATE;
				phase13 += step[12] / SAMPLING_RATE;
				phase14 += step[13] / SAMPLING_RATE;
				phase15 += step[14] / SAMPLING_RATE;
				phase16 += step[15] / SAMPLING_RATE;
					
				var phaseAngle:Number = phase * Math.PI * 2;
				var phaseAngle2:Number = phase2 * Math.PI * 2;
				var phaseAngle3:Number = phase3 * Math.PI * 2;
				var phaseAngle4:Number = phase4 * Math.PI * 2;
				var phaseAngle5:Number = phase5 * Math.PI * 2;
				var phaseAngle6:Number = phase6 * Math.PI * 2;
				var phaseAngle7:Number = phase7 * Math.PI * 2;
				var phaseAngle8:Number = phase8 * Math.PI * 2;
				var phaseAngle9:Number = phase9 * Math.PI * 2;
				var phaseAngle10:Number = phase10 * Math.PI * 2;
				var phaseAngle11:Number = phase11 * Math.PI * 2;
				var phaseAngle12:Number = phase12 * Math.PI * 2;
				var phaseAngle13:Number = phase13 * Math.PI * 2;
				var phaseAngle14:Number = phase14 * Math.PI * 2;
				var phaseAngle15:Number = phase15 * Math.PI * 2;
				var phaseAngle16:Number = phase16 * Math.PI * 2;
				
				sample = Math.sin(phaseAngle) * amplify / UNIT;
				sample2 = Math.sin(phaseAngle2) * amplify / UNIT;
				sample3 = Math.sin(phaseAngle3) * amplify / UNIT;
				sample4 = Math.sin(phaseAngle4) * amplify / UNIT;
				sample5 = Math.sin(phaseAngle5) * amplify / UNIT;
				sample6 = Math.sin(phaseAngle6) * amplify / UNIT;
				sample7 = Math.sin(phaseAngle7) * amplify / UNIT;
				sample8 = Math.sin(phaseAngle8) * amplify / UNIT;
				sample9 = Math.sin(phaseAngle9) * amplify / UNIT;
				sample10 = Math.sin(phaseAngle10) * amplify / UNIT;
				sample11 = Math.sin(phaseAngle11) * amplify / UNIT;
				sample12 = Math.sin(phaseAngle12) * amplify / UNIT;
				sample13 = Math.sin(phaseAngle13) * amplify / UNIT;
				sample14 = Math.sin(phaseAngle14) * amplify / UNIT;
				sample15 = Math.sin(phaseAngle15) * amplify / UNIT;
				sample16 = Math.sin(phaseAngle16) * amplify / UNIT;
				
				bytes.writeFloat(.2 * (sample + sample2 + sample3 + sample4+sample5+sample6+sample7+sample8+sample9+sample10+sample11+sample12+sample13+sample14+sample15+sample16)/2);
				bytes.writeFloat(.2 * (sample + sample2 + sample3 + sample4+sample5+sample6+sample7+sample8+sample9+sample10+sample11+sample12+sample13+sample14+sample15+sample16)/2);
				
				updateAmplify();
			}
			
			event.data.writeBytes(bytes);
		}
	}
}