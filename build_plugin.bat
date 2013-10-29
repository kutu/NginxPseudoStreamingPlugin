@call properties.bat

@call "%flex_bin%\mxmlc.bat" -o "%build_dir%\NginxPseudoStreamingPlugin.swf" ^
	-debug=%debug% ^
	-swf-version=11 ^
	-target-player=10.2 ^
	-sp src ^
	-l "%flex_sdk%\frameworks\libs" ^
	-define CONFIG::LOGGING %logging% ^
	src\ru\kutu\osmf\nginxpseudostreaming\NginxPseudoStreamingPlugin.as
