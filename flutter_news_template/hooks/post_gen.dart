import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final configureFirebaseLink = link(
    uri: Uri.parse(
      'https://flutter.github.io/news_toolkit/#configure-firebase',
    ),
  );

  context.logger
    ..info('\n')
    ..info(lightCyan.wrap(
      'Congrats! You generated a new app with the Flutter News Toolkit!',
    ))
    ..info('\n')
    ..info(
      'Before running your app, make sure to configure firebase ($configureFirebaseLink).',
    );
}
