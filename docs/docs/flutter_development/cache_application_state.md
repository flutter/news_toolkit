---
sidebar_position: 10
description: Learn how the toolkit caches your news application's state.
---

# Cache your application state

[Hydrated Bloc](https://pub.dev/packages/hydrated_bloc) is an extension to the BLoC pattern. It helps automatically persist and restore bloc states, ensuring that the app's state is retained across app restarts or crashes.

The project relies on `hydrated_bloc` to persist the state of the following blocs:

- `feed_bloc`: Persists the feed state. It contains the list of feed articles fetched from the API.
- `article_bloc` : Persists each article information fetched from the API.
- `categories_bloc`: Persists all feed categories fetched from the API.
- `theme_mode_bloc` : Persists the theme mode of the app selected by the user.

## How it works

The `hydrated_bloc` package uses its own `hydrated_storage` to persist the state of blocs on the application's side. It is enabled by default.

Upon launching the application, if the feed state is empty, it retrieves the feed articles from the API. If the feed state is not empty, it displays the cached feed articles. As the user scrolls to the end of the feed page, older feed articles are fetched from the API and added to the feed state that will be persisted.

Actions such as opening the app from background or terminated state will not affect the state of the blocs. Those will be persisted and restored when the user restarts the app.

In order for the user to see the most recent articles, they must refresh the feed by pulling down the feed page.

If there are any errors while fetching the feed articles, the user will be notified by a 'Network Error' screen. The user can retry fetching the articles by tapping on the 'Retry' button.

## Debug mode caching

In this project, `hydrated_bloc` caching is automatically disabled for debug mode. Every restart of the application will clear the `hydrated_bloc` storage state, so no state will be restored. In order to enable it, the following code must be removed from the `bootstrap.dart` file:

```dart
if (kDebugMode) {
    await HydratedBloc.storage.clear();
}
```
