import 'dart:math' as math;

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final vars = {...context.vars};

  context.logger.info('Building flavors...');

  final flavors = _areFlavorsConfigured(vars['flavors'])
      ? List.of(vars['flavors']).cast<Map>()
      : _configureFlavors(vars['flavors'].split(' '), context);

  // Add iOS build configuration variables.
  final flavorsWithBuildConfigurations = flavors.map((flavor) {
    return {
      ...flavor,
      'xcconfig_id': _generateRandomUUID(),
      'xcbuild_configuration_section_release_1_id': _generateRandomUUID(),
      'xcbuild_configuration_section_release_2_id': _generateRandomUUID(),
      'xcbuild_configuration_section_debug_1_id': _generateRandomUUID(),
      'xcbuild_configuration_section_debug_2_id': _generateRandomUUID()
    };
  }).toList();

  context.logger.info(flavorsWithBuildConfigurations.toString());

  vars['flavors'] = flavorsWithBuildConfigurations;
  context.vars = vars;
}

/// A map of required options per each flavor with their descriptions.
const _requiredFlavorOptions = {
  'name': 'name (e.g. development)',
  'suffix': 'suffix (e.g. dev)',
  'deep_link_domain': 'deep link domain (e.g. application.page.link)',
  'twitter_api_key': 'Twitter API key',
  'twitter_api_secret': 'Twitter API secret',
  'facebook_app_id': 'Facebook App ID',
  'facebook_client_token': 'Facebook Client Token',
  'facebook_display_name': 'Facebook Display Name',
  'ios_admob_app_id': 'AdMob App ID for iOS',
  'android_admob_app_id': 'AdMob App ID for Android',
};

/// Returns true if all flavors are configured, i.e.
/// each flavor has all [_requiredFlavorOptions].
bool _areFlavorsConfigured(dynamic flavors) =>
    flavors is List &&
    flavors.every(
      (flavor) =>
          flavor is Map &&
          _requiredFlavorOptions.keys.every(
            (flavorOption) => flavor.containsKey(flavorOption),
          ),
    );

/// Requests required options [_requiredFlavorOptions] for each flavor.
Iterable<Map> _configureFlavors(
  List<String> flavors,
  HookContext context,
) =>
    flavors.map((flavor) => {'name': flavor}).map(
          (flavor) => _requiredFlavorOptions.entries.fold<Map>(
            flavor,
            (configuredFlavor, requiredFlavorOption) {
              if (configuredFlavor.containsKey(requiredFlavorOption.key))
                return configuredFlavor;

              final flavorOption = context.logger.prompt(
                  '[${flavor['name']}] What is the flavor ${requiredFlavorOption.value}?');

              return {
                ...configuredFlavor,
                requiredFlavorOption.key: flavorOption,
              };
            },
          ),
        );

/// Generates a random UUID of length [length].
String _generateRandomUUID([int length = 24]) {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  const charactersLength = characters.length;
  final buffer = StringBuffer();
  for (var i = 0; i < length; i++) {
    buffer.write(characters[(math.Random().nextInt(charactersLength))]);
  }
  return buffer.toString();
}
