import 'dart:io';
import 'dart:math' as math;

import 'package:mason/mason.dart';

const _supportedFlavors = {
  'development': {
    'name': "development",
    "suffix": "dev",
  },
  'integration': {
    'name': "integration",
    "suffix": "int",
  },
  'staging': {
    'name': "staging",
    "suffix": "stg",
  },
  'production': {
    'name': "production",
    "suffix": "",
  },
};
const _exampleAndroidAdsId = 'ca-app-pub-3940256099942544~3347511713';
const _exampleiOSAdsId = 'ca-app-pub-3940256099942544~1458002511';
const _supportedFlutterVersion = '3.10.2';

Future<void> run(HookContext context) async {
  final vars = {...context.vars};
  final flavors = vars['flavors'].map((flavor) {
    if (!_supportedFlavors.keys.contains(flavor)) {
      context.logger.err('Unsupported flavor: $flavor');
      exit(1);
    }
    return {
      ..._supportedFlavors[flavor]!,
      'android_ads_app_id': _exampleAndroidAdsId,
      'ios_ads_app_id': _exampleiOSAdsId,
      'xcconfig_id': _generateRandomUUID(),
      'xcbuild_configuration_section_release_1_id': _generateRandomUUID(),
      'xcbuild_configuration_section_release_2_id': _generateRandomUUID(),
      'xcbuild_configuration_section_debug_1_id': _generateRandomUUID(),
      'xcbuild_configuration_section_debug_2_id': _generateRandomUUID()
    };
  }).toList();
  final appName = vars['app_name'] as String;
  context.vars = {
    ...vars,
    'project_name': appName.snakeCase,
    'flavors': flavors,
    'flutter_version': _supportedFlutterVersion,
  };
}

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
