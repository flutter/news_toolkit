---
sidebar_position: 11
description: Learn how the toolkit caches your news applications's state.
---

# Cache application state

[Hydrated Bloc](https://pub.dev/packages/hydrated_bloc) is a extension to the BLoC pattern. It helps automatically persist and restore bloc states, ensuring that the app's state is retained across app restarts or crashes.

The project relies on `hydrated_bloc` to persist the state of the following BLoCs:

- `feed_bloc`: Persists the feed state, which contains the list of feed articles fetched from the API.
- `article_bloc` : Persists each article information fetched from the API.
- `categories_bloc`: Persists all feed categories fetched from the API.
- `theme_mode_bloc` : Persists the theme mode of the app selected by the user.

## How it works

`hydrated_bloc` package uses their own `hydrated_storage` to persist the state of the BLoCs on the application's side. It's enabled per default.

Upon launching the application, if the feed state is empty, it retrieves the feed articles from the API. In contrast, if the feed state is not empty, it displays the cached feed articles. As the user scrolls to the end of the feed page, older feed articles are fetched from the API and added to the feed state that will be persisted.

Actions such as opening the app from background or terminated state will not affect the state of the BLoCs. Those will be persisted and restored when the user restarts the app.

In order for the user to see the most recent articles, they must refresh the feed by pulling down the feed page.

If there any errors while fetching the feed articles, the user will be notified by a 'Network Error' screen. The user can retry fetching the articles by tapping on the 'Retry' button.

## Debug mode caching

On the project, `hydrated_bloc`'s caching is automatically disabled for debug mode. Every restart of the application will clear the `hydrated_bloc`'s storage state. In order to enable it, the following code must be removed from the `bootstrap.dart` file:

```dart
if (kDebugMode) {
    await HydratedBloc.storage.clear();
}
```
