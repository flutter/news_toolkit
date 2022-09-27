# Google News Template

## Google News Project

[Google News Project](./google_news_project/README.md) is a news application template built as a Flutter app with a [dart_frog](https://pub.dev/packages/dart_frog) backend.

## Google News Mason Template

[Google News Template](./google_news_template/README.md) is a [mason](https://pub.dev/packages/mason) template generated from google_news_project.

## Working with Blocks

### What are Blocks?

*Note: `blocks` are distinct from [`blocs`](https://bloclibrary.dev/#/), which are also used in this application.*

Blocks are the data format used by Google News Template to ensure that a variety of news content can be displayed in a consistent manner. The client application expects to receive data from the server in a block-based format. For example, the `Article` model class contains a list of blocks. 

These blocks contain the data which the app requires to render a corresponding widget.

As described in [Implementing an API Data Source](#implementing-an-api-data-source), your backend is responsible for transforming data from your CMS into the block-based format expected by the app. The app will then display the data according to its own internal rendering rules.

### Using Blocks

You can view the relationship between blocks and their corresponding widgets in `lib/article/widgets/article_content_item.dart` and `lib/article/widgets/category_feed_item.dart`. 

`ArticleContentItem` specifies how a block will be rendered inside an article view, while `CategoryFeedItem` specifies how a block will be rendered inside the feed view. Both classes also provide callbacks to widgets which exhibit behavior on an interaction, such as a press or tap by the user. Look through those files to review the available blocks that can feed into your app out-of-the-box.

Note that if your CMS returns content in an HTML format, you may want to break you article into chunks and provide it to the app inside an `HtmlBlock`, which will render the content inside a [`Html`](https://pub.dev/packages/flutter_html) widget. Styling for HTML content is covered in the [Updating the App Typography](#updating-the-app-typography) section of this document.

Also note that many block files have an additional `.g` file in the same folder which shares its name. For example, there is both `banner_ad_block.dart` and `banner_ad_block.g.dart`. The `.g` file contains generated code to support functionality such as JSON serialization. When you change any file with associated generated code, [make sure code generation runs and is kept up-to-date with your source code content](https://docs.flutter.dev/development/data-and-backend/json#running-the-code-generation-utility).
