# Google News Template

## Google News Project

[Google News Project](./google_news_project/README.md) is a news application template built as a Flutter app with a [dart_frog](https://pub.dev/packages/dart_frog) backend.

## Google News Mason Template

[Google News Template](./google_news_template/README.md) is a [mason](https://pub.dev/packages/mason) template generated from google_news_project.

## Updating App Colors

The colors used throughout your app are specified in the `app_colors.dart` file found in `packages/app_ui/lib/src/colors`. Add custom colors to this file and reference them as an attribute of the `AppColors` class inside your app (e.g. `AppColors.orange`). The role of colors within your app can be specified as either theme information or as an inline color.

### Updating Theme Colors

Some colors are assigned to themes, which allow colors to be shared throughout your app based on their intended role in the user interface. For additional information on specifying theme colors, reference the Flutter [Use Themes to Share Colors and Font Styles](https://docs.flutter.dev/cookbook/design/themes) cookbook.

App themes are laid out in the `app_theme.dart` file inside the `packages/app_ui/lib/src/theme` folder. For example, the widget-specific theme `_appBarTheme` allow you to specify the colors and theme information for your [AppBar](https://api.flutter.dev/flutter/material/AppBar-class.html).

### Updating Inline Colors

Not all of your desired color assignments can be specified by changing the app's theme data. You may want to use a color only on certain instances of a widget or specify colors with more granularity than the theme information supports. There are several existing inline color specifications in your app:

*Specifying Button Colors*

The colors of an app button are specified by the named constructors laid out in `packages/app_ui/lib/src/widgets/app_button.dart`. To specify new button colors, create a new color constructor. For example, to create an orange app button create the constructor

```dart
const AppButton.orange({
  Key? key,
  VoidCallback? onPressed,
  double? elevation,
  TextStyle? textStyle,
  required Widget child,
}) : this._(
        key: key,
        onPressed: onPressed,
        buttonColor: AppColors.orange,
        child: child,
        foregroundColor: AppColors.white,
        elevation: elevation,
        textStyle: textStyle,
     );
```

You can then call the new `AppButton.orange` constructor in your app wherever you want to add an orange button, or replace an existing constructor call such as `AppButton.redWine` with your new constructor to update the button color.

*Specifying TabBar Colors*

The `TabBarTheme` specified in `app_theme.dart` does not provide a `backgroundColor` property. To specify a specific color for the `CategoriesTabBar` rendered below the `AppBar`, edit `CategoriesTabBar`'s `build()` method inside `lib/categories/widgets/categories_tab_bar.dart` to place the `TabBar` widget inside a `ColoredBox`:

```dart
return ColoredBox(
  color: AppColors.organge,
  child: TabBar(
    controller: controller,
    isScrollable: true,
    tabs: tabs,
  ),
);
```

Other widgets with in-line specified colors include:
- `PostContentPremiumCategory`
- `SlideshowCategory`
- `PostContentCategory`
- `MagicLinkPromptSubtitle`
- `ManageSubscriptionView`
- `AppTextField`
- `ArticleIntroduction`

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
