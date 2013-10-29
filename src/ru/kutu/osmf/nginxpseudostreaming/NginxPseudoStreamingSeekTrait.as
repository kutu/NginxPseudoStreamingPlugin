package ru.kutu.osmf.nginxpseudostreaming {
	
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetClient;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.traits.SeekTrait;
	import org.osmf.traits.TimeTrait;
	
	public class NginxPseudoStreamingSeekTrait extends SeekTrait {
		
		private var netStream:NetStream;
		private var resource:URLResource;
		private var pseudoTimeTrait:NginxPseudoStreamingTimeTrait;
		private var metadata:Object;
		
		private var previousTime:Number;
		private var expectedTime:Number;
		
		public function NginxPseudoStreamingSeekTrait(timeTrait:TimeTrait, netStream:NetStream, resource:MediaResourceBase) {
			super(timeTrait);
			pseudoTimeTrait = timeTrait as NginxPseudoStreamingTimeTrait;
			this.netStream = netStream;
			this.resource = resource as URLResource;
			if (netStream) {
				netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				if (netStream.client) {
					NetClient(netStream.client).addHandler(NetStreamCodes.ON_META_DATA, onMetaData);
				}
			}
		}
		
		override public function canSeekTo(time:Number):Boolean {
			return !isNaN(time)
				&& pseudoTimeTrait
				&& time >= 0
				&& time < pseudoTimeTrait.startPositionOffset + pseudoTimeTrait.duration;
		}
		
		override protected function seekingChangeStart(newSeeking:Boolean, time:Number):void {
			if (newSeeking) {
				previousTime = netStream.time;
				expectedTime = time;
				
				var bufferLength:Number = metadata.duration * netStream.bytesLoaded / netStream.bytesTotal;
				
				if (time > pseudoTimeTrait.startPositionOffset + bufferLength || time < pseudoTimeTrait.startPositionOffset) {
					var seekPoint:Object = findSeekPoint(time);
					if (!seekPoint) return;
					var pseudoStreamingQuery:String = resource.getMetadataValue(NginxPseudoStreamingPluginInfo.NGINX_PSEUDO_STREAMING_QUERY) as String;
					if (!pseudoStreamingQuery || !pseudoStreamingQuery.length) return;
					pseudoStreamingQuery = pseudoStreamingQuery.replace("{0}", seekPoint.time.toString());
					
					var url:String = resource.url;
					if (url.search(/\.mp4$/) != -1) {
						url += "?" + pseudoStreamingQuery;
					} else if (url.search(/\.mp4\?.+/) != -1) {
						url += "&" + pseudoStreamingQuery;
					} else {
						return;
					}
					netStream.play(url);
					
					pseudoTimeTrait.startPositionOffset = seekPoint.time;
				} else {
					netStream.seek(time - pseudoTimeTrait.startPositionOffset);
				}
			}
		}
		
		private function onNetStatus(event:NetStatusEvent):void {
			switch (event.info.code) {
				case NetStreamCodes.NETSTREAM_SEEK_INVALIDTIME:
				case NetStreamCodes.NETSTREAM_SEEK_FAILED:
					setSeeking(false, previousTime);
					break;
				case NetStreamCodes.NETSTREAM_PLAY_START:
				case NetStreamCodes.NETSTREAM_PLAY_RESET:
				case NetStreamCodes.NETSTREAM_PAUSE_NOTIFY:
				case NetStreamCodes.NETSTREAM_PLAY_STOP:
				case NetStreamCodes.NETSTREAM_UNPAUSE_NOTIFY:
					if (seeking) {
						setSeeking(false, expectedTime);
					}
					break;
			}
		}
		
		private function onMetaData(metadata:Object):void {
			this.metadata = metadata;
			NetClient(netStream.client).removeHandler(NetStreamCodes.ON_META_DATA, onMetaData);
		}
		
		private function findSeekPoint(time:Number):Object {
			if (!metadata && !("seekpoints" in metadata)) return null;
			
			var seekPoints:Array = metadata.seekpoints;
			if (!seekPoints.length) return null;
			if (seekPoints.length == 1) return seekPoints[0];
			
			var len:int = seekPoints.length;
			var min:int, max:int = len - 1;
			var index:int;
			
			while (max - min > 1) {
				index = min + (max - min) / 2;
				var point:Object = seekPoints[index];
				if (point.time > time) {
					max = index;
				} else {
					min = index;
				}
			}
			
			point = Math.abs(time - seekPoints[max].time) < Math.abs(time - seekPoints[min].time)
				? seekPoints[max]
				: seekPoints[min]
			
			return point;
		}
		
	}
	
}
