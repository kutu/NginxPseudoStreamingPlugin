package ru.kutu.osmf.nginxpseudostreaming {
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.PluginInfo;
	import org.osmf.media.URLResource;
	
	public class NginxPseudoStreamingPluginInfo extends PluginInfo {
		
		public static const NGINX_PSEUDO_STREAMING_QUERY:String = "nginxPseudoStreamingQuery";
		
		public function NginxPseudoStreamingPluginInfo() {
			super(
				new <MediaFactoryItem>[
					new MediaFactoryItem(
						"ru.kutu.osmf.NginxPseudoStreamingPlugin",
						function(resource:MediaResourceBase):Boolean {
							return resource.getMetadataValue(NGINX_PSEUDO_STREAMING_QUERY)
								&& (resource as URLResource).url.search(/^https?:\/\/.*?\/.*?\.mp4(\?.+|$)/) == 0;
						},
						function():MediaElement {
							return new NginxPseudoStreamingVideoElement();
						}
					)
				]
			);
		}
		
	}
	
}
