#!/bin/bash
# Google plist generation script for working in CI

cat << EOF > Missions/GoogleService-Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CLIENT_ID</key>
	<string>550786922979-vo4p5n88rr9pv15tuarb8k89vskp5apk.apps.googleusercontent.com</string>
	<key>REVERSED_CLIENT_ID</key>
	<string>com.googleusercontent.apps.550786922979-vo4p5n88rr9pv15tuarb8k89vskp5apk</string>
	<key>API_KEY</key>
	<string>AIzaSyCCT5fuoN9i-C7ZNTXuwH6qtbf3bslu45c</string>
	<key>GCM_SENDER_ID</key>
	<string>550786922979</string>
	<key>PLIST_VERSION</key>
	<string>1</string>
	<key>BUNDLE_ID</key>
	<string>com.IamGoodBad.Missions</string>
	<key>PROJECT_ID</key>
	<string>missions-62207</string>
	<key>STORAGE_BUCKET</key>
	<string>missions-62207.appspot.com</string>
	<key>IS_ADS_ENABLED</key>
	<false></false>
	<key>IS_ANALYTICS_ENABLED</key>
	<false></false>
	<key>IS_APPINVITE_ENABLED</key>
	<true></true>
	<key>IS_GCM_ENABLED</key>
	<true></true>
	<key>IS_SIGNIN_ENABLED</key>
	<true></true>
	<key>GOOGLE_APP_ID</key>
	<string>1:550786922979:ios:50d1ead6b82a15c51e48d6</string>
</dict>
</plist>
EOF