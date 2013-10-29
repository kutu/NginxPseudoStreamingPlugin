package ru.kutu.osmf.nginxpseudostreaming {
	
	import org.osmf.elements.VideoElement;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.net.NetLoader;
	import org.osmf.net.NetStreamLoadTrait;
	import org.osmf.traits.MediaTraitBase;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.TimeTrait;
	
	public class NginxPseudoStreamingVideoElement extends VideoElement {
		
		public function NginxPseudoStreamingVideoElement(resource:MediaResourceBase=null, loader:NetLoader=null) {
			super(resource, loader);
		}
		
		override protected function addTrait(type:String, trait:MediaTraitBase):void {
			var loadTrait:NetStreamLoadTrait, timeTrait:TimeTrait;
			
			switch (type) {
				case MediaTraitType.BUFFER:
					loadTrait = getTrait(MediaTraitType.LOAD) as NetStreamLoadTrait;
					trait = new NginxPseudoStreamingBufferTrait(loadTrait.netStream);
					break;
				case MediaTraitType.SEEK:
					if (hasTrait(MediaTraitType.TIME)) {
						timeTrait = getTrait(MediaTraitType.TIME) as TimeTrait;
						loadTrait = getTrait(MediaTraitType.LOAD) as NetStreamLoadTrait;
						trait = new NginxPseudoStreamingSeekTrait(timeTrait, loadTrait.netStream, resource);
					}
					break;
				case MediaTraitType.TIME:
					loadTrait = getTrait(MediaTraitType.LOAD) as NetStreamLoadTrait;
					trait = new NginxPseudoStreamingTimeTrait(loadTrait.netStream, resource);
					break;
			}
			
			super.addTrait(type, trait);
		}
		
	}
	
}
