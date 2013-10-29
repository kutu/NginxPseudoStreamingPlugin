# About

Nginx Pseudo Streaming Plugin - is a plugin for OSMF framework that adds capability to playback pseudo streaming mp4 files.

This plugin is part of [Grind Player](https://github.com/kutu/GrindPlayer) project.

[Documentation &rarr;](http://osmfhls.kutu.ru/docs/grind/#pseudo)

# Build

1. Install [Flex 4.11.0+ &rarr;](http://flex.apache.org/installer.html)
2. Download [playerglobal.swc 10.2 &rarr;](http://helpx.adobe.com/flash-player/kb/archived-flash-player-versions.html#playerglobal) and put it in
	`flex_sdk\frameworks\libs\player\10.2\playerglobal.swc`

3. Clone
	`git clone git://github.com/kutu/NginxPseudoStreamingPlugin.git`

4. `cd NginxPseudoStreamingPlugin && copy properties.bat.tmpl properties.bat`
5. Change `flex_sdk` path in `properties.bat`
6. `build_plugin.bat`

### Known issues

- Mp4 URL must be absolute
- Will not properly show loaded bar in SMP or custom osmf-based player (need some customization)
