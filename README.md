# Google News Template

## Google News Project

[Google News Project](./google_news_project/README.md) is a news application template built as a Flutter app with a [dart_frog](https://pub.dev/packages/dart_frog) backend.

## Google News Mason Template

[Google News Template](./google_news_template/README.md) is a [mason](https://pub.dev/packages/mason) template generated from google_news_project.

## Generating Your Codebase With Mason

[Mason](https://pub.dev/packages/mason) is a command line application which allows you to generate a customized codebase based on your specifications. To generate your app using Mason, follow the steps below.

### Activate Mason

```sh
dart pub global activate mason_cli
```

### Add the Google News Template Brick

When using user/password authentication:

```sh
mason add google_news_template -g --git-url https://github.com/VGVentures/google_news_template --git-path google_news_template
```

When using ssh authentication:

```sh
mason add google_news_template -g --git-url git@github.com:VGVentures/google_news_template.git --git-path google_news_template
```

### Generate

```sh
mason make google_news_template -c template.json
```

For additional usage information and information about how to create custom templates refer to the [mason documentation](https://github.com/felangel/mason).

## Updating the App Splash Screen

Flutter's [Adding a Splash Screen to Your Mobile App](https://docs.flutter.dev/development/ui/advanced/splash-screen) documentation provides the most up-to-date and in-depth guidance on customizing the splash screen in your mobile app.

### Android Splash Screen

Within the `android/app/src/main/res` folder, replace `launch_image.png` inside the 

 - `mipmap-mdpi` 
 - `mipmap-hdpi` 
 - `mipmap-xhdpi` 
 - `mipmap-xxhdpi`
 
folders with the image asset you want featured on your Android splash screen. The `launch_image.png` you provide inside the `mipmap` folders should have an appropriate size for that folder.

The background color of your splash screen can be changed by editing the hex code value with `name="splash_background"` in `android/app/src/main/res/values/colors.xml`.

### iOS Splash Screen

You should configure your iOS splash screen using an Xcode storyboard. To begin, add your splash screen image assets named 

 - `LaunchImage.png` 
 - `LaunchImage@2x.png`  
 - `LaunchImage@3x.png`

 with sizes corresponding to the filename inside the  `ios/Runner/Assets.xcassets/LaunchImage.imageset` folder. 

Open your project's `ios` folder in Xcode and open `Runner/LaunchScreen.storyboard` in the editor. Specify your desired splash screen image and background by selecting those elements and editing their properties in the Xcode inspectors window. Feel free to further edit the splash screen properties in the Xcode inspectors window to customize the exact look of your splash screen.
