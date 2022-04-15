@Tags(['presubmit-only'])
import 'package:build_verify/build_verify.dart';
import 'package:test/test.dart';

void main() {
  test(
    'ensure_build',
    () {
      expectBuildClean(
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
