# Google News Template

## Google News Project

[Google News Project](./google_news_project/README.md) is a news application template built as a Flutter app with a [dart_frog](https://pub.dev/packages/dart_frog) backend.

## Google News Mason Template

[Google News Template](./google_news_template/README.md) is a [mason](https://pub.dev/packages/mason) template generated from google_news_project.

## Implementing an API Data Source

The template's [Dart Frog](https://dartfrog.vgv.dev) API acts as an intermediary between your CMS and the client application, organizing your content into the [blocks](#working-with-blocks) that form the basis of content organization within the app.

If you don't intend to write custom code to support the necessary block-organized endpoints from your CMS, you should create and deploy an API which uses the `NewsDataSource` interface to collect and transform data.

Your implementation of the `NewsDataSource` will be called by the route handlers laid out in the `api/routes` directory. The data source will then request data from your CMS and organize it into the block-based data expected by the client before returning it to the route handler to be served to your client application. For more information about the structure and capabilities of the Dart Frog server that will be utilizing your data source, please consult the [Dart Frog documentation](https://dartfrog.vgv.dev/docs/category/basics).

The `NewsDataSource` class found in `api/lib/src/data/news_data_source.dart` provides an interface which your data source must implement. Feel free to remove methods which provide data that you don't intend to use in the client app, or to add methods to provide data for functionality which you intend on adding to your app.

### Creating a New Data Source

Begin by defining a new class which implements `NewsDataSource`. 

    class YourCustomDataSource implements NewsDataSource

Your data source should have a means of interacting with your CMS as a field such as an [HTTP](https://pub.dev/packages/http) or [Dio](https://pub.dev/packages/dio) client, and you may want to create separate named constructors if you have different CMS URLs for different flavors, such as development and production.

### Implementing Backend Adapters

After creating your data source class, you should implement the methods defined in `NewsDataSource`:

```dart
/// {@template news_data_source}
/// An interface for a news content data source.
/// {@endtemplate}
abstract class NewsDataSource {
	/// {@macro news_data_source}
	const NewsDataSource();
	
	/// Returns a news [Article] for the provided article [id].
	///
	/// In addition, the contents can be paginated by supplying
	/// [limit] and [offset].
	///
	/// * [limit] - The number of content blocks to return.
	/// * [offset] - The (zero-based) offset of the first item
	/// in the collection to return.
	Future<Article?> getArticle({
		required String id,
		int limit = 20,
		int offset = 0,
	});

	/// Returns a list of current popular topics.
	Future<List<String>> getPopularTopics();

	/// Returns a list of current relevant topics
	/// based on the provided [term].
	Future<List<String>> getRelevantTopics({required String term});

	/// Returns a list of current popular article blocks.
	Future<List<NewsBlock>> getPopularArticles();

	/// Returns a list of relevant article blocks
	/// based on the provided [term].
	Future<List<NewsBlock>> getRelevantArticles({required String term});

	/// Returns [RelatedArticles] for the provided article [id].
	///
	/// In addition, the contents can be paginated by supplying
	/// [limit] and [offset].
	///
	/// * [limit] - The number of content blocks to return.
	/// * [offset] - The (zero-based) offset of the first item
	/// in the collection to return.
	Future<RelatedArticles> getRelatedArticles({
		required String id,
		int limit = 20,
		int offset = 0,
	});

	/// Returns a news [Feed] for the provided [category].
	/// By default [Category.top] is used.
	///
	/// In addition, the feed can be paginated by supplying
	/// [limit] and [offset].
	///
	/// * [limit] - The number of results to return.
	/// * [offset] - The (zero-based) offset of the first item
	/// in the collection to return.
	Future<Feed> getFeed({
		Category category = Category.top,
		int limit = 20,
		int offset = 0,
	});
	  
	/// Returns a list of all available news categories.
	Future<List<Category>> getCategories();
}
``` 

For example, an implementation of `getArticle()` might look like:
```dart
@override
Future<Article?> getArticle({
  required String id,
  int limit = 20,
  int offset = 0,
  bool preview = false,
}) async {
  final uri = Uri.parse('$YOUR_CMS_BASE_URL/posts/$id');
  final response = await httpClient.get(uri);

  if (response.statusCode != HttpStatus.ok) {
    throw YourAppApiFailureException(
      body: response.body,
      statusCode: response.statusCode,
    );
  }

  final responseJson = response.jsonMap();
  if (responseJson.isNotFound) return null;

  final post = Post.fromJson(responseJson);
  final article = post.toArticle();

  return article;
}
```

The above example references a class not included in the template, `Post`: 

```dart
class Post {
  const Post({
    required this.id,
    required this.date,
    required this.link,
    required this.title,
    required this.content,
    required this.author,
    required this.image,
    required this.category,
  });
  
  final int id;
  final DateTime date;
  final String link;
  final String title;
  final String content;
  final Author author;
  final String image;
  final HespressPostCategory category;
}
```

Since your CMS presumably doesn't respond with data in the block-based format used by the `Article` class, you may want to define classes like `Post` which mirror the data types and formats which your CMS returns. 

You can use a package like [json_serializable](https://pub.dev/packages/json_serializable) to generate code to create a `Post` object from the JSON returned from your CMS (see [JSON and serialization - Flutter Documentation](https://docs.flutter.dev/development/data-and-backend/json)). 

You can then [add an extension method](https://dart.dev/guides/language/extension-methods) such as `toArticle()` on your `Post` class which uses the relevant data from the `Post` object and to create and return an `Article` object which will be served to your client app.

This structure of `JSON -> Intermediary Object -> API Model` can be repeated in implementing any data source method which receives data from your CMS that differs from what the method is expected to return.

### Using Your Data Source Within the API

After creating your data source, inject it into your API route handler through the [Dart Frog middleware](https://dartfrog.vgv.dev/docs/basics/dependency-injection).

First instantiate your data source:

`final yourCustomDataSource = YourCustomDataSource();`

Then inject it through the middleware as a `NewsDataSource`:

`handler.use(provider<NewsDataSource>((_) =>  yourCustomDataSource));`

As the template already contains a `NewsDataSource` dependency injection, you can simply instantiate your data source and then replace `inMemoryNewsDataSource` with `yourCustomDataSource`.
