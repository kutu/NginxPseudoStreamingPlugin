package ru.kutu.osmf.nginxpseudostreaming {

	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	
	import org.osmf.net.NetStreamCodes;
	import org.osmf.traits.BufferTrait;

	public class NginxPseudoStreamingBufferTrait extends BufferTrait {

		private var netStream:NetStream;

		public function NginxPseudoStreamingBufferTrait(netStream:NetStream) {
			this.netStream = netStream;
			if (netStream) {
				netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
			}
			setBuffering(true);
		}

		override public function get bufferLength():Number {
			return netStream.bufferLength;
		}

		override protected function bufferTimeChangeStart(newTime:Number):void {
			netStream.bufferTime = newTime;
		}

		private function onNetStatus(event:NetStatusEvent):void {
			switch (event.info.code) {
				case NetStreamCodes.NETSTREAM_PLAY_START:
				case NetStreamCodes.NETSTREAM_BUFFER_EMPTY:
					bufferTime = netStream.bufferTime;
					setBuffering(true);

					if (netStream.bufferTime == 0) {
						setBuffering(false);
					}
					break;

				case NetStreamCodes.NETSTREAM_BUFFER_FULL:
					setBuffering(false);
					break;
			}
		}

	}

}
