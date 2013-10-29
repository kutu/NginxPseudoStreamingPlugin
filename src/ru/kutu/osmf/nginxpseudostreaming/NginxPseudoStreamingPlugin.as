package ru.kutu.osmf.nginxpseudostreaming {
	
	import flash.display.Sprite;
	
	import org.osmf.media.PluginInfo;
	
	public class NginxPseudoStreamingPlugin extends Sprite {
	
	    private var _pluginInfo:NginxPseudoStreamingPluginInfo;
	
	    public function NginxPseudoStreamingPlugin() {
	        _pluginInfo = new NginxPseudoStreamingPluginInfo();
	    }
	
	    public function get pluginInfo():PluginInfo {
	        return _pluginInfo;
	    }
		
	}
	
}
