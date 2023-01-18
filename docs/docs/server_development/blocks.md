---
sidebar_position: 4
description: Learn how to work with blocks to customize your news content.
---

# Working with blocks

## What are blocks?

_Note: `blocks` are distinct from [`blocs`](https://bloclibrary.dev/#/), which are also used in this application._

Blocks are the data format used by the Flutter News Template to ensure that a variety of news content can be displayed in a consistent manner. The client application expects to receive data from the server in a block-based format. For example, the `Article` model class contains a list of blocks.

These blocks contain the data that the app requires to render a corresponding widget.

As described in [Implementing an API Data Source](/server_development/connecting_your_data_source#implementing-your-data-source), your backend is responsible for transforming data from your CMS into the block-based format expected by the app. The app then displays the data according to its own internal rendering rules.

The following diagram provides an overview of how blocks are used in the example template application:

![block-diagram](https://user-images.githubusercontent.com/61138206/192628148-e1af73e4-4b81-4dff-8926-c411294b4b86.png)

In this example, data from the CMS is transformed by the Dart Frog server into a `PostLargeBlock` instance to respond to a request from the app. The `CategoryFeed` widget receives the data from the app's `FeedBloc` and gives the `PostLargeBlock` to a newly-constructed `PostLarge` widget to dictate what data the widget should render on-screen.

## Using blocks

You can view the relationship between blocks and their corresponding widgets in `lib/article/widgets/article_content_item.dart` and `lib/article/widgets/category_feed_item.dart`.

`ArticleContentItem` specifies how a block is rendered inside an article view, while `CategoryFeedItem` specifies how a block is rendered inside the feed view. Both classes also provide callbacks to widgets that exhibit behavior on an interaction, such as a press or tap by the user. Look through those files to review the available blocks that can feed into your app out of the box.

Note that if your CMS returns content in an HTML format, you might want to segment your articles and provide the content to the app inside an `HtmlBlock`, which renders the content inside an [`Html`](https://pub.dev/packages/flutter_html) widget. Styling for HTML content is covered in the [Updating the App Typography](/flutter_development/theming#typography) section of this document.

Also note that many block files have an additional `.g` file in the same folder that shares its name. For example, there is both `banner_ad_block.dart` and `banner_ad_block.g.dart`. The `.g` file contains generated code to support functionality such as JSON serialization. When you change any file with associated generated code, [make sure code generation runs and is kept up-to-date with your source code content](https://docs.flutter.dev/development/data-and-backend/json#running-the-code-generation-utility).

## Customizing blocks

Blocks are the basic organizational components of your app's news content. Re-arranging the order of blocks allows you to control how and where your content is displayed.

Block organization typically occurs within your API and is then served to your app.

Reference the `article_content_item.dart` and `category_feed_item.dart` files to understand the relationship between blocks and their corresponding widgets.

Placing ads is covered in the [Updating Ads Placement](/flutter_development/ads#ads-placement) section, but you might want to control the placement of other widgets such as the `NewsletterBlock`, which allows a user to subscribe to a mailing list. One way to arrange a block is to edit your news data source implementation's `getFeed` or `getArticle` methods to insert a `NewsletterBlock` at the 15th block in the returned list, for example. This same approach can be used to introduce blocks such as the `DividerHorizontalBlock`, `TextLeadParagraphBlock`, and the `SpacerBlock` into the feed of blocks that your app receives, all of which allows you to further customize the look and content of your app.
