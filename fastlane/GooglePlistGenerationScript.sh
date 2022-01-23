#!/bin/bash
# Google plist generation script for working in CI

cat << EOF > ../GoogleService-Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CLIENT_ID</key>
	<string>$GOOGLE_CLIENT_ID</string>
	<key>REVERSED_CLIENT_ID</key>
	<string>$GOOGLE_REVERSED_CLIENT_ID</string>
	<key>API_KEY</key>
	<string>$GOOGLE_API_KEY</string>
	<key>GCM_SENDER_ID</key>
	<string>$GOOGLE_GCM_SENDER_ID</string>
	<key>PLIST_VERSION</key>
	<string>$GOOGLE_PLIST_VERSION</string>
	<key>BUNDLE_ID</key>
	<string>$GOOGLE_BUNDLE_ID</string>
	<key>PROJECT_ID</key>
	<string>$GOOGLE_PROJECT_ID</string>
	<key>STORAGE_BUCKET</key>
	<string>$GOOGLE_STORAGE_BUCKET</string>
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
	<string>$GOOGLE_APP_ID</string>
</dict>
</plist>
EOF