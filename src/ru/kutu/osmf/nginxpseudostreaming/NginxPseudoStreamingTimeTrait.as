package ru.kutu.osmf.nginxpseudostreaming {
	
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	
	import org.osmf.media.MediaResourceBase;
	import org.osmf.net.NetClient;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.net.NetStreamUtils;
	import org.osmf.traits.TimeTrait;
	
	public class NginxPseudoStreamingTimeTrait extends TimeTrait {
		
		private var durationOffset:Number = 0;
		private var audioDelay:Number = 0;
		private var netStream:NetStream;
		private var resource:MediaResourceBase;
		
		private var _duration:Number;
		private var _startPositionOffset:Number = 0;
		
		public function NginxPseudoStreamingTimeTrait(netStream:NetStream, resource:MediaResourceBase, defaultDuration:Number=NaN) {
			this.netStream = netStream;
			this.resource = resource;
			
			if (netStream) {
				netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
				if (netStream.client) {
					NetClient(netStream.client).addHandler(NetStreamCodes.ON_META_DATA, onMetaData);
					NetClient(netStream.client).addHandler(NetStreamCodes.ON_PLAY_STATUS, onPlayStatus);
				}
			}
			
			if (!isNaN(defaultDuration)) {
				setDuration(defaultDuration);
			}
		}
		
		public function set startPositionOffset(value:Number):void {
			_startPositionOffset = value;
		}
		
		public function get startPositionOffset():Number {
			return _startPositionOffset;
		}
		
		override public function get currentTime():Number {
			return _startPositionOffset + netStream.time; 
		}
		
		override public function get duration():Number {
			return !isNaN(_duration) ? _duration : super.duration;
		}
		
		override protected function durationChangeStart(newDuration:Number):void {
			if (isNaN(_duration)) {
				_duration = newDuration;
			}
			super.durationChangeStart(newDuration);
		}
		
		private function onMetaData(value:Object):void {
			if (isNaN(_duration)) {
				setDuration(value.duration);
			}
		}
		
		private function onPlayStatus(event:Object):void {
			switch(event.code) {
				case NetStreamCodes.NETSTREAM_PLAY_COMPLETE:
					signalComplete();
					break;
			}
		}
		
		private function onNetStatus(event:NetStatusEvent):void {
			switch (event.info.code) {
				case NetStreamCodes.NETSTREAM_PLAY_STOP:
					if (!NetStreamUtils.isStreamingResource(resource)) {
						signalComplete();
					}
					break;
				case NetStreamCodes.NETSTREAM_PLAY_UNPUBLISH_NOTIFY:
					signalComplete();
					break;
			}
		}
		
	}
	
}
