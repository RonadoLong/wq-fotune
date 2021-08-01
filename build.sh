#!/bin/bash
echo '<============== begin build web ==============>'
flutter build web
echo '<============== end build web ================>'

echo '<============== begin build android ==============>'
flutter build apk 
echo '<============== end build android ================>'

#build ios
echo '<============== begin build ios ==================>'
#flutter build ios --release
#rm -rf /Users/m/Desktop/Runner.app
#mv /Users/m/code/app_code/fotune_app/build/ios/iphoneos/Runner.app /Users/m/Desktop/Runner.app
echo '<============== end build ios ====================>'
