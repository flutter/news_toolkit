import 'dart:math' as math;

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final vars = {...context.vars};

  context.logger.info('Building flavors...');

  final flavors = _configureFlavors(
    (vars['flavors'] is String
            ? List.of(vars['flavors'].split(' '))
                .map((flavor) => {'name': flavor})
                .toList()
            : List.of(vars['flavors']))
        .cast<Map>(),
    context,
  );

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

  vars['flavors'] = flavorsWithBuildConfigurations;
  context.vars = vars;
}

/// A list of required options per each flavor with their descriptions.
const _requiredFlavorOptions = [
  _FlavorOption(
    name: 'name',
    description: 'name',
    defaultValue: 'development',
  ),
  _FlavorOption(
    name: 'suffix',
    description: 'suffix',
  ),
  _FlavorOption(
    name: 'deep_link_domain',
    description: 'deep link domain',
    defaultValue: 'googlenewstemplate.page.link',
  ),
  _FlavorOption(
    name: 'twitter_api_key',
    description: 'Twitter API key',
  ),
  _FlavorOption(
    name: 'twitter_api_secret',
    description: 'Twitter API secret',
  ),
  _FlavorOption(
    name: 'facebook_app_id',
    description: 'Facebook App ID',
  ),
  _FlavorOption(
    name: 'facebook_client_token',
    description: 'Facebook Client Token',
  ),
  _FlavorOption(
    name: 'facebook_display_name',
    description: 'Facebook Display Name',
  ),
  _FlavorOption(
    name: 'ios_admob_app_id',
    description: 'AdMob App ID for iOS',
  ),
  _FlavorOption(
    name: 'android_admob_app_id',
    description: 'AdMob App ID for Android',
  ),
];

class _FlavorOption {
  const _FlavorOption({
    required this.name,
    required this.description,
    this.defaultValue,
  });

  /// The name of this flavor option.
  final String name;

  /// The description of this flavor option.
  final String description;

  /// The default value of this flavor option.
  final String? defaultValue;
}

/// Configures each flavor of [flavors] based on [_requiredFlavorOptions].
Iterable<Map> _configureFlavors(
  Iterable<Map> flavors,
  HookContext context,
) =>
    flavors.map(
      (flavor) => _requiredFlavorOptions.fold<Map>(
        flavor,
        (configuredFlavor, requiredFlavorOption) {
          if (configuredFlavor.containsKey(requiredFlavorOption.name)) {
            return configuredFlavor;
          }

          final flavorOption = context.logger.prompt(
            '[${flavor['name']}] What is the flavor ${requiredFlavorOption.description}?',
            defaultValue: requiredFlavorOption.defaultValue,
          );

          return {
            ...configuredFlavor,
            requiredFlavorOption.name: flavorOption,
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
