import 'dart:math' as math;

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final vars = {...context.vars};

  context.logger.info('Building flavors...');

  final flavors = vars['flavors'].toString().split(' ').map((flavorName) {
    // Request additional metadata for each flavor.
    final suffix = context.logger
        .prompt('[$flavorName] What is the flavor suffix (e.g. dev)?');

    final deepLinkDomain = context.logger.prompt(
      '[$flavorName] What is the flavor deep link domain (e.g. application.page.link)?',
    );

    final twitterApiKey = context.logger
        .prompt('[$flavorName] What is the flavor Twitter API key?');

    final twitterApiSecret = context.logger
        .prompt('[$flavorName] What is the flavor Twitter API secret?');

    final facebookAppId = context.logger
        .prompt('[$flavorName] What is the flavor Facebook App ID?');

    final facebookClientToken = context.logger
        .prompt('[$flavorName] What is the flavor Facebook Client Token?');

    final facebookDisplayName = context.logger
        .prompt('[$flavorName] What is the flavor Facebook Display Name?');

    final adMobAppIdIOS = context.logger
        .prompt('[$flavorName] What is the flavor AdMob App ID for iOS?');

    final adMobAppIdAndroid = context.logger
        .prompt('[$flavorName] What is the flavor AdMob App ID for Android?');

    return {
      'name': flavorName,
      'suffix': suffix,
      'deep_link_domain': deepLinkDomain,
      'twitter_api_key': twitterApiKey,
      'twitter_api_secret': twitterApiSecret,
      'facebook_app_id': facebookAppId,
      'facebook_client_token': facebookClientToken,
      'facebook_display_name': facebookDisplayName,
      'ios_admob_app_id': adMobAppIdIOS,
      'android_admob_app_id': adMobAppIdAndroid,
    };
  }).map((flavor) {
    // Add iOS build configuration variables.
    return {
      ...flavor,
      'xcconfig_id': _generateRandomUUID(),
      'xcbuild_configuration_section_release_1_id': _generateRandomUUID(),
      'xcbuild_configuration_section_release_2_id': _generateRandomUUID(),
      'xcbuild_configuration_section_debug_1_id': _generateRandomUUID(),
      'xcbuild_configuration_section_debug_2_id': _generateRandomUUID()
    };
  }).toList();

  vars['flavors'] = flavors;
  context.vars = vars;
}

String _generateRandomUUID([int length = 24]) {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  const charactersLength = characters.length;
  final buffer = StringBuffer();
  for (var i = 0; i < length; i++) {
    buffer.write(characters[(math.Random().nextInt(charactersLength))]);
  }
  return buffer.toString();
}
