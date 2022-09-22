# Google News Template

## Google News Project

[Google News Project](./google_news_project/README.md) is a news application template built as a Flutter app with a [dart_frog](https://pub.dev/packages/dart_frog) backend.

## Google News Mason Template

[Google News Template](./google_news_template/README.md) is a [mason](https://pub.dev/packages/mason) template generated from google_news_project.

## Updating the App Typography

### Fonts

For general details regarding font customization, reference Flutter's [Use a Custom Font](https://docs.flutter.dev/cookbook/design/fonts) documentation. 

To change the fonts used in your app, first add your font assets inside `packages/app_ui/assets/fonts`, then list the added fonts under the `fonts` section of `packages/app_ui/pubspec.yaml`.

You can specify which fonts you want to be used in different elements in your app in the `packages/app_ui/lib/src/typography/app_text_styles.dart` file.

You can specify the fonts used in your app by changing the `fontFamily` value at the following locations inside the `app_text_styles.dart` file to match the name of your desired font family:

- `UITextStyle._baseTextStyle`
	- Specifies the default font used in UI elements.
- `ContentTextStyle._baseTextStyle`
	- Specifies the default font used in news content.
- `button`
	- Specifies the font used in buttons.
- `caption`
	- Specifies the font used in your caption text.
- `overline`
	- Specifies the font used in overline text elements such as category labels.
- `labelSmall`
	- Specifies the font used in label text (*not referenced in the template out-of-the-box*).

### Text Appearance

In order to further customize your app's typography, you can add and edit the various `TextStyle` values such as `fontWeight`, `fontSize`, and others in the `packages/app_ui/lib/src/typography/app_text_styles.dart` file. 
The correspondence between selected `TextStyles` and visual elements in the app is illustrated below.

For styling text contained in `HtmlBlocks`, you can edit the `style` map in `packages/news_blocks_ui/lib/src/html.dart` to associate HTML selectors with the `TextStyle` you want to be utilized when the HTML is rendered.

### Illustrating Where App `TextStyles` are Used

<img src="https://user-images.githubusercontent.com/61138206/191820826-7ef6c873-94ee-49e8-bcd6-25e35421c055.png">
