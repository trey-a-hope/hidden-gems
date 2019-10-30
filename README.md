# HiddenGems.Flutter

Mobile application for Dayton artists.

## Create keystore file.
- Command [keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key]

## Build Android APK
- Command [flutter clean]
- Command [flutter build apk --release]
- Located [build/app/outputs/apk/release/app-release.apk]

## Build iOS IPA
- Command [flutter clean]
- Command [flutter build ios --release]
- Then go to PRODUCT -> ARCHIVE in XCODE

# Create Angular App
- npm install -g @angular/cli
- ng new web
- cd web
- sudo ng serve --open
- sudo npm install
- sudo ng build --prod
- sudo npm install -g firebase-tools
- sudo firebase login
- sudo firebase init
- "(public directory) dist/web" 
- "(dist/web/index.html already exists, overwrite?) NO"
sudo ng generate component widgets/footer

## Angular, Create Service
- ng g s services/user

## Angular, Create Component
- ng g c views/about --module app

## Angular, Create Routing
- ng generate module app-routing --flat --module=app

## Angular, Run Locally
- ng serve --open

## Splash Screen
- mipmap-xxxhdpi in the Android folder when using App Icon tends to work best for both platforms.

## How to Add Local Project to Bit Bucket
git init
git remote add origin [my-repo]
git fetch
git checkout origin/master -ft

## Remove file.
rm -rf stripe_functions.js

## Remove git
rm -rf .git

