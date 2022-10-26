import 'dart:io';
import 'package:path/path.dart' as path;

final _staticDir = path.join('tool', 'generator', 'static');
final _sourcePath = path.join('flutter_news_example${path.separator}');
final _templatePath = path.join(
  'flutter_news_template',
  '__brick__',
);
final _targetPath = path.join(
  _templatePath,
  '{{project_name.snakeCase()}}',
);
final _targetProjectWorkflow = path.join(
  _targetPath,
  '.github',
  'workflows',
  'flutter_news_template.yaml',
);
final _targetProjectApiClient = path.join(
  _targetPath,
  'api',
  'lib',
  'src',
  'client',
  'flutter_news_template_api_client.dart',
);
final _targetProjectApiClientTests = path.join(
  _targetPath,
  'api',
  'test',
  'src',
  'client',
  'flutter_news_template_api_client_test.dart',
);
final _targetProjectDependabotConfiguration = path.join(
  _targetPath,
  '.github',
  'dependabot.yaml',
);
final _targetPubspec = path.join(_targetPath, 'pubspec.yaml');
final _targetCodemagic = path.join(_targetPath, 'codemagic.yaml');
final _encryptedRegExp = RegExp(r'Encrypted\(([^)]+)\)');
final _targetCodeOwners = path.join(_targetPath, '.github', 'CODEOWNERS');
final _targetReadme = path.join(_targetPath, 'README.md');
final _targetMain = path.join(
  _targetPath,
  'lib',
  'main',
  'main_development.dart',
);
final _targetIosProject = path.join(
  _targetPath,
  'ios',
  'Runner.xcodeproj',
  'project.pbxproj',
);

final _flutterVersionRegExp = RegExp(r'flutter: (.*)');
final _vgWorkflowFlutterVersionRegExp = RegExp(r'flutter_version: (.*)');
final _mustacheCaseRegExp = RegExp(r'\${{([^{}]*)}}');
final _workflowFlutterVersionRegExp = RegExp(r'flutter-version: (.*)');
final _apiClientRegExp =
    RegExp('google-news-template-api-q66trdlzja-uc.a.run.app');
final _workflowWorkingDirectoryRegExp = RegExp(
  r'\s+defaults:(.*?)flutter_news_example',
  multiLine: true,
  dotAll: true,
);
final xcBuildConfigurationRegExp = RegExp(
  r'/\* Begin XCBuildConfiguration section \*/(.*?)/\* End XCBuildConfiguration section \*/',
  dotAll: true,
);
final xcConfigurationListRegExp = RegExp(
  r'/\* Begin XCConfigurationList section \*/(.*?)/\* End XCConfigurationList section \*/',
  dotAll: true,
);

final _blackList = <String>[
  path.join(
    _targetPath,
    '.github',
    'workflows',
    'verify_flutter_news_template.yaml',
  ),
  path.join(
    _targetPath,
    '.github',
    'workflows',
    'generate_flutter_news_template.yaml',
  ),
  path.join(_targetPath, 'lib', 'main', 'main_production.dart'),
  path.join(_targetPath, '.idea', 'runConfigurations', 'development.xml'),
  path.join(_targetPath, '.idea', 'runConfigurations', 'production.xml'),
  path.join(
    _targetPath,
    'ios',
    'Runner.xcodeproj',
    'xcshareddata',
    'xcschemes',
  ),
  path.join(
    _targetPath,
    'ios',
    'Runner',
    'development',
    'GoogleService-Info.plist',
  ),
  path.join(
    _targetPath,
    'android',
    'app',
    'src',
    'development',
    'google-services.json',
  ),
  path.join(
    _targetPath,
    'android',
    'app',
    'src',
    'development',
    'res',
    'values',
    'strings.xml',
  ),
  path.join(
    _targetPath,
    'ios',
    'Runner',
    'production',
    'GoogleService-Info.plist',
  ),
  path.join(
    _targetPath,
    'android',
    'app',
    'src',
    'production',
    'google-services.json',
  ),
  path.join(
    _targetPath,
    'packages',
    'app_ui',
    'gallery',
    '.firebaserc',
  ),
  path.join(
    _targetPath,
    'packages',
    'app_ui',
    'gallery',
    '.firebase.json',
  ),
];

void main() async {
  // Remove Previously Generated Files
  final templateDir = Directory(_templatePath);
  if (templateDir.existsSync()) await templateDir.delete(recursive: true);
  final targetDir = Directory(_targetPath);
  await targetDir.create(recursive: true);

  // Copy Project Files
  await Shell.cp('$_sourcePath', _targetPath);
  await Shell.cp('.github${path.separator}', path.join(_targetPath, '.github'));
  await Shell.cp(
    path.join(_staticDir, 'launch.json'),
    path.join(_targetPath, '.vscode', 'launch.json'),
  );
  await Shell.cp(
    path.join(_staticDir, 'build.gradle'),
    path.join(_targetPath, 'android', 'app', 'build.gradle'),
  );
  await Shell.cp('codemagic.yaml', _targetCodemagic);

  // Remove Black Listed Files
  await Future.wait(_blackList.map((path) async {
    final file = File(path);
    if (file.existsSync()) {
      return file.delete();
    }
    final directory = Directory(path);
    if (directory.existsSync()) {
      return directory.delete(recursive: true);
    }
  }));

  // Convert Values to Variables
  await Future.wait(
    Directory(_targetPath)
        .listSync(recursive: true)
        .whereType<File>()
        .map((_) async {
      var file = _;
      if (path.isWithin(
        path.join(_targetPath, '.github', 'workflows'),
        file.path,
      )) {
        final contents = file.readAsStringSync();
        file.writeAsStringSync(
          contents
              .replaceFirst(
                _workflowFlutterVersionRegExp,
                'flutter-version: {{flutter_version}}',
              )
              .replaceFirst(
                _vgWorkflowFlutterVersionRegExp,
                'flutter_version: {{flutter_version}}',
              )
              .replaceAllMapped(
                _mustacheCaseRegExp,
                (match) =>
                    "\${{#mustacheCase}}${match.group(1)?.trim()}{{/mustacheCase}}",
              )
              .replaceAll('flutter_news_example/', ''),
        );
      }
      if (file.path == _targetProjectWorkflow) {
        file.writeAsStringSync(
          file
              .readAsStringSync()
              .replaceFirst(_workflowWorkingDirectoryRegExp, ''),
        );
      }

      if (file.path == _targetProjectDependabotConfiguration) {
        file.writeAsStringSync(
          file.readAsStringSync().replaceFirst('''
  - package-ecosystem: "pub"
    directory: "/tool/generator"
    schedule:
      interval: "daily"
''', '').replaceAll('/flutter_news_example/', '/'),
        );
      }

      if (file.path == _targetPubspec) {
        file.writeAsStringSync(
          file.readAsStringSync().replaceFirst(
              _flutterVersionRegExp, 'flutter: {{flutter_version}}'),
        );
      }

      if (file.path == _targetCodemagic) {
        file.writeAsStringSync(
          file.readAsStringSync().replaceFirst(
              _flutterVersionRegExp, 'flutter: {{flutter_version}}'),
        );

        file.writeAsStringSync(
          file.readAsStringSync().replaceAll(
              RegExp('com.flutter.news.toolkit'), '{{reverse_domain}}'),
        );

        file.writeAsStringSync(
          file.readAsStringSync().replaceAll(_encryptedRegExp, 'TODO'),
        );
      }

      if (file.path == _targetCodeOwners) {
        file.writeAsStringSync(
          file.readAsStringSync().replaceFirst(
                // cspell:disable-next-line
                '@felangel @AnnaPS @simpson-peter',
                '{{code_owners}}',
              ),
        );
      }

      if (file.path == _targetReadme) {
        file.writeAsStringSync(
          file.readAsStringSync().replaceFirst(
            '''- development\n- production''',
            '''{{#flavors}}- {{{name}}}\n{{/flavors}}''',
          ),
        );
        file.writeAsStringSync(
          file.readAsStringSync().replaceFirst(
            '''# Development\n\$ flutter run --flavor development --target lib/main/main_development.dart\n\n# Production\n\$ flutter run --flavor production --target lib/main/main_production.dart''',
            '''{{#flavors}}# {{{name}}}\n\$ flutter run --flavor {{{name}}} --target lib/main/main_{{{name}}}.dart\n{{/flavors}}''',
          ),
        );
      }

      if (file.path == _targetProjectApiClient) {
        file.writeAsStringSync(
          file.readAsStringSync().replaceAll(_apiClientRegExp, '{{api_url}}'),
        );
      }

      if (file.path == _targetProjectApiClientTests) {
        file.writeAsStringSync(
          file.readAsStringSync().replaceAll(_apiClientRegExp, '{{api_url}}'),
        );
      }

      try {
        final contents = await file.readAsString();

        await file.writeAsString(contents
            .replaceAll(
              'flutter_news_template',
              '{{project_name.snakeCase()}}',
            )
            .replaceAll(
              'GoogleNewsTemplate',
              '{{project_name.pascalCase()}}',
            )
            .replaceAll(
              'google-news-template',
              '{{project_name.paramCase()}}',
            )
            .replaceAll('Flutter News Toolkit', '{{app_name}}')
            .replaceAll('com.flutter.news.toolkit', '{{reverse_domain}}'));
      } on Exception {}

      if (path.basename(file.path).contains('flutter_news_template')) {
        final newPath = path.join(
          file.parent.path,
          '{{#snakeCase}}{{project_name}}{{',
        );
        await Shell.mkdir(newPath);
        file = file.renameSync(
          path.join(
            file.parent.path,
            path
                .basename(file.path)
                .replaceAll('flutter_news_template', "snakeCase}}"),
          ),
        );
        await Shell.cp(file.path, newPath);
        file.deleteSync();
      }

      if (file.path == _targetMain) {
        final target = File(
          path.join(
            _targetPath,
            'lib',
            'main',
            '{{#flavors}}main_{{{name}}}.dart{{',
            'flavors}}',
          ),
        );
        await Shell.mkdir(target.parent.path);
        file = file.renameSync(target.path);
      }
    }),
  );

  final intelliJRunConfiguration = File(
    path.join(
      _targetPath,
      '.idea',
      'runConfigurations',
      '{{#flavors}}{{{name}}}.xml{{',
      'flavors}}',
    ),
  );
  await Shell.mkdir(intelliJRunConfiguration.parent.path);
  await Shell.cp(
    path.join(_staticDir, 'intellij_run_configuration.xml'),
    intelliJRunConfiguration.path,
  );

  final xcschemes = File(
    path.join(
      _targetPath,
      'ios',
      'Runner.xcodeproj',
      'xcshareddata',
      'xcschemes',
      '{{#flavors}}{{{name}}}.xcscheme{{',
      'flavors}}',
    ),
  );
  await Shell.mkdir(xcschemes.parent.path);
  await Shell.cp(path.join(_staticDir, 'ios_flavor.xcscheme'), xcschemes.path);

  final androidStringXMLs = File(
    path.join(
      _targetPath,
      'android',
      'app/src',
      '{{#flavors}}{{{name}}}{{',
      'flavors}}',
      'res',
      'values',
      'strings.xml',
    ),
  );
  await Shell.mkdir(androidStringXMLs.parent.path);
  await Shell.cp(path.join(_staticDir, 'strings.xml'), androidStringXMLs.path);

  final googleServiceInfoPlists = File(
    path.join(
      _targetPath,
      'ios',
      'Runner',
      '{{#flavors}}{{{name}}}{{',
      'flavors}}',
      'GoogleService-Info.plist',
    ),
  );
  await Shell.mkdir(googleServiceInfoPlists.parent.path);
  await Shell.cp(
    path.join(_staticDir, 'GoogleService-Info.plist'),
    googleServiceInfoPlists.path,
  );

  final googleServicesJson = File(
    path.join(
      _targetPath,
      'android',
      'app',
      'src',
      '{{#flavors}}{{{name}}}{{',
      'flavors}}',
      'google-services.json',
    ),
  );
  await Shell.mkdir(googleServicesJson.parent.path);
  await Shell.cp(
    path.join(_staticDir, 'google-services.json'),
    googleServicesJson.path,
  );

  final iosProjectFile = File(_targetIosProject);
  const xcBuildConfigurationTemplate = r'''
    {{#flavors}}
    {{xcbuild_configuration_section_debug_1_id}} /* Debug-{{name}} */ = {
      isa = XCBuildConfiguration;
      baseConfigurationReference = 9740EEB21CF90195004384FC /* Debug.xcconfig */;
      buildSettings = {
        ALWAYS_SEARCH_USER_PATHS = NO;
        CLANG_ANALYZER_NONNULL = YES;
        CLANG_CXX_LANGUAGE_STANDARD = "gnu++0x";
        CLANG_CXX_LIBRARY = "libc++";
        CLANG_ENABLE_MODULES = YES;
        CLANG_ENABLE_OBJC_ARC = YES;
        CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
        CLANG_WARN_BOOL_CONVERSION = YES;
        CLANG_WARN_COMMA = YES;
        CLANG_WARN_CONSTANT_CONVERSION = YES;
        CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
        CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
        CLANG_WARN_EMPTY_BODY = YES;
        CLANG_WARN_ENUM_CONVERSION = YES;
        CLANG_WARN_INFINITE_RECURSION = YES;
        CLANG_WARN_INT_CONVERSION = YES;
        CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
        CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
        CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
        CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
        CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
        CLANG_WARN_STRICT_PROTOTYPES = YES;
        CLANG_WARN_SUSPICIOUS_MOVE = YES;
        CLANG_WARN_UNREACHABLE_CODE = YES;
        CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
        "CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer";
        COPY_PHASE_STRIP = NO;
        DEBUG_INFORMATION_FORMAT = dwarf;
        ENABLE_STRICT_OBJC_MSGSEND = YES;
        ENABLE_TESTABILITY = YES;
        GCC_C_LANGUAGE_STANDARD = gnu99;
        GCC_DYNAMIC_NO_PIC = NO;
        GCC_NO_COMMON_BLOCKS = YES;
        GCC_OPTIMIZATION_LEVEL = 0;
        GCC_PREPROCESSOR_DEFINITIONS = (
          "DEBUG=1",
          "$(inherited)",
        );
        GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
        GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
        GCC_WARN_UNDECLARED_SELECTOR = YES;
        GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
        GCC_WARN_UNUSED_FUNCTION = YES;
        GCC_WARN_UNUSED_VARIABLE = YES;
        IPHONEOS_DEPLOYMENT_TARGET = 11.0;
        MTL_ENABLE_DEBUG_INFO = YES;
        ONLY_ACTIVE_ARCH = YES;
        SDKROOT = iphoneos;
        TARGETED_DEVICE_FAMILY = "1,2";
      };
      name = "Debug-{{name}}";
    };
    {{xcbuild_configuration_section_debug_2_id}} /* Debug-{{name}} */ = {
      isa = XCBuildConfiguration;
      baseConfigurationReference = {{xcconfig_id}} /* {{name}}.xcconfig */;
      buildSettings = {
        ADMOB_APP_ID = "{{ios_ads_app_id}}";
        ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
        CLANG_ENABLE_MODULES = YES;
        CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements;
        CURRENT_PROJECT_VERSION = "$(FLUTTER_BUILD_NUMBER)";
        DEVELOPMENT_TEAM = 42QKVF5N7J;
        ENABLE_BITCODE = NO;
        "EXCLUDED_ARCHS[sdk=iphonesimulator*]" = "i386 arm64";
        FACEBOOK_APP_ID = "{{facebook_app_id}}";
        FACEBOOK_CLIENT_TOKEN = "{{facebook_client_token}}";
        FACEBOOK_DISPLAY_NAME = "{{facebook_display_name}}";
        FLAVOR_APP_NAME = "{{app_name}} [{{suffix.upperCase()}}]";
        FLAVOR_DEEP_LINK_DOMAIN = "{{deep_link_domain}}";
        FRAMEWORK_SEARCH_PATHS = (
          "$(inherited)",
          "$(PROJECT_DIR)/Flutter",
        );
        INFOPLIST_FILE = Runner/Info.plist;
        LD_RUNPATH_SEARCH_PATHS = (
          "$(inherited)",
          "@executable_path/Frameworks",
        );
        LIBRARY_SEARCH_PATHS = (
          "$(inherited)",
          "$(PROJECT_DIR)/Flutter",
        );
        PRODUCT_BUNDLE_IDENTIFIER = "{{reverse_domain}}.{{suffix.lowerCase()}}";
        PRODUCT_NAME = "$(TARGET_NAME)";
        REVERSED_CLIENT_ID = "<PASTE-REVERSED-CLIENT-ID-HERE>";
        SWIFT_OBJC_BRIDGING_HEADER = "Runner/Runner-Bridging-Header.h";
        SWIFT_OPTIMIZATION_LEVEL = "-Onone";
        SWIFT_VERSION = 5.0;
        TWITTER_REDIRECT_URI_SCHEME = "{{project_name.paramCase()}}";
        VERSIONING_SYSTEM = "apple-generic";
      };
      name = "Debug-{{name}}";
    };
    {{xcbuild_configuration_section_release_1_id}} /* Release-{{name}} */ = {
      isa = XCBuildConfiguration;
      baseConfigurationReference = 7AFA3C8E1D35360C0083082E /* Release.xcconfig */;
      buildSettings = {
        ALWAYS_SEARCH_USER_PATHS = NO;
        CLANG_ANALYZER_NONNULL = YES;
        CLANG_CXX_LANGUAGE_STANDARD = "gnu++0x";
        CLANG_CXX_LIBRARY = "libc++";
        CLANG_ENABLE_MODULES = YES;
        CLANG_ENABLE_OBJC_ARC = YES;
        CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
        CLANG_WARN_BOOL_CONVERSION = YES;
        CLANG_WARN_COMMA = YES;
        CLANG_WARN_CONSTANT_CONVERSION = YES;
        CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
        CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
        CLANG_WARN_EMPTY_BODY = YES;
        CLANG_WARN_ENUM_CONVERSION = YES;
        CLANG_WARN_INFINITE_RECURSION = YES;
        CLANG_WARN_INT_CONVERSION = YES;
        CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
        CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
        CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
        CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
        CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
        CLANG_WARN_STRICT_PROTOTYPES = YES;
        CLANG_WARN_SUSPICIOUS_MOVE = YES;
        CLANG_WARN_UNREACHABLE_CODE = YES;
        CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
        "CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer";
        COPY_PHASE_STRIP = NO;
        DEBUG_INFORMATION_FORMAT = dwarf;
        ENABLE_STRICT_OBJC_MSGSEND = YES;
        ENABLE_TESTABILITY = YES;
        GCC_C_LANGUAGE_STANDARD = gnu99;
        GCC_DYNAMIC_NO_PIC = NO;
        GCC_NO_COMMON_BLOCKS = YES;
        GCC_OPTIMIZATION_LEVEL = 0;
        GCC_PREPROCESSOR_DEFINITIONS = (
          "DEBUG=1",
          "$(inherited)",
        );
        GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
        GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
        GCC_WARN_UNDECLARED_SELECTOR = YES;
        GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
        GCC_WARN_UNUSED_FUNCTION = YES;
        GCC_WARN_UNUSED_VARIABLE = YES;
        IPHONEOS_DEPLOYMENT_TARGET = 9.0;
        MTL_ENABLE_DEBUG_INFO = YES;
        ONLY_ACTIVE_ARCH = YES;
        SDKROOT = iphoneos;
        SWIFT_COMPILATION_MODE = wholemodule;
        TARGETED_DEVICE_FAMILY = "1,2";
      };
      name = "Release-{{name}}";
    };
    {{xcbuild_configuration_section_release_2_id}} /* Release-{{name}} */ = {
      isa = XCBuildConfiguration;
      baseConfigurationReference = 7AFA3C8E1D35360C0083082E /* Release.xcconfig */;
      buildSettings = {
        ADMOB_APP_ID = "{{ios_ads_app_id}}";
        ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
        CLANG_ENABLE_MODULES = YES;
        CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements;
        CURRENT_PROJECT_VERSION = "$(FLUTTER_BUILD_NUMBER)";
        DEVELOPMENT_TEAM = 42QKVF5N7J;
        ENABLE_BITCODE = NO;
        "EXCLUDED_ARCHS[sdk=iphonesimulator*]" = "i386 arm64";
        FACEBOOK_APP_ID = "{{facebook_app_id}}";
        FACEBOOK_CLIENT_TOKEN = "{{facebook_client_token}}";
        FACEBOOK_DISPLAY_NAME = "{{facebook_display_name}}";
        FLAVOR_APP_NAME = "{{app_name}} [{{suffix.upperCase()}}]";
        FLAVOR_DEEP_LINK_DOMAIN = "{{deep_link_domain}}";
        FRAMEWORK_SEARCH_PATHS = (
          "$(inherited)",
          "$(PROJECT_DIR)/Flutter",
        );
        INFOPLIST_FILE = Runner/Info.plist;
        LD_RUNPATH_SEARCH_PATHS = (
          "$(inherited)",
          "@executable_path/Frameworks",
        );
        LIBRARY_SEARCH_PATHS = (
          "$(inherited)",
          "$(PROJECT_DIR)/Flutter",
        );
        PRODUCT_BUNDLE_IDENTIFIER = "{{reverse_domain}}.{{suffix.lowerCase()}}";
        PRODUCT_NAME = "$(TARGET_NAME)";
        REVERSED_CLIENT_ID = "<PASTE-REVERSED-CLIENT-ID-HERE>";
        SWIFT_OBJC_BRIDGING_HEADER = "Runner/Runner-Bridging-Header.h";
        SWIFT_VERSION = 5.0;
        TWITTER_REDIRECT_URI_SCHEME = "{{project_name.paramCase()}}";
      };
      name = "Release-{{name}}";
    };
    {{/flavors}}
  ''';
  const xcConfigurationListTemplate = r'''
      97C146E91CF9000F007C117D /* Build configuration list for PBXProject "Runner" */ = {
        isa = XCConfigurationList;
        buildConfigurations = (
          {{#flavors}}
          {{xcbuild_configuration_section_debug_1_id}} /* Debug-{{name}} */,
          {{xcbuild_configuration_section_release_1_id}} /* Release-{{name}} */,
          {{/flavors}}
        );
        defaultConfigurationIsVisible = 0;
        defaultConfigurationName = "Debug-{{name}}";
      };
      97C147051CF9000F007C117D /* Build configuration list for PBXNativeTarget "Runner" */ = {
        isa = XCConfigurationList;
        buildConfigurations = (
          {{#flavors}}
          {{xcbuild_configuration_section_debug_2_id}} /* Debug-{{name}} */,
          {{xcbuild_configuration_section_release_2_id}} /* Release-{{name}} */,
          {{/flavors}}
        );
        defaultConfigurationIsVisible = 0;
        defaultConfigurationName = "Release-{{name}}";
      };
  ''';
  try {
    final contents = await iosProjectFile.readAsString();
    iosProjectFile.writeAsStringSync(
      contents
          .replaceFirst(
            xcBuildConfigurationRegExp,
            '/* Begin XCBuildConfiguration section */\n$xcBuildConfigurationTemplate\n/* End XCBuildConfiguration section */',
          )
          .replaceFirst(
            xcConfigurationListRegExp,
            '/* Begin XCConfigurationList section */\n$xcConfigurationListTemplate\n/* End XCConfigurationList section */',
          ),
    );
  } on Exception {}
}

class Shell {
  static Future<void> cp(String source, String destination) {
    return _Cmd.run('cp', ['-rf', source, destination]);
  }

  static Future<void> mkdir(String destination) {
    return _Cmd.run('mkdir', ['-p', destination]);
  }
}

class _Cmd {
  static Future<ProcessResult> run(
    String cmd,
    List<String> args, {
    bool throwOnError = true,
    String? processWorkingDir,
  }) async {
    final result = await Process.run(cmd, args,
        workingDirectory: processWorkingDir, runInShell: true);

    if (throwOnError) {
      _throwIfProcessFailed(result, cmd, args);
    }
    return result;
  }

  static void _throwIfProcessFailed(
    ProcessResult pr,
    String process,
    List<String> args,
  ) {
    if (pr.exitCode != 0) {
      final values = {
        'Standard out': pr.stdout.toString().trim(),
        'Standard error': pr.stderr.toString().trim()
      }..removeWhere((k, v) => v.isEmpty);

      String message;
      if (values.isEmpty) {
        message = 'Unknown error';
      } else if (values.length == 1) {
        message = values.values.single;
      } else {
        message = values.entries.map((e) => '${e.key}\n${e.value}').join('\n');
      }

      throw ProcessException(process, args, message, pr.exitCode);
    }
  }
}
