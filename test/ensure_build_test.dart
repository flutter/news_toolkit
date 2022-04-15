@Tags(['presubmit-only'])
import 'package:build_verify/build_verify.dart';
import 'package:test/test.dart';

void main() {
  test(
    'ensure_build',
    () {
      expectBuildClean(
        packageRelativeDirectory: 'google_news_template',
        customCommand: [
          'flutter',
          'pub',
          'run',
          'build_runner',
          'build',
          '--delete-conflicting-outputs'
        ],
      );
    },
  );
}
