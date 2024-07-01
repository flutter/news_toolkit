import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class _TolerantGoldenFileComparator extends LocalFileComparator {
  _TolerantGoldenFileComparator(
    super.testFile,
  );

  /// How much the golden image can differ from the test image.
  ///
  /// It is expected to be between 0 and 1.
  /// Where 0 is no difference (same image)
  /// and 1 is the maximum difference (completely different images).
  static const double _precisionTolerance = .06;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    final passed = result.passed || result.diffPercent <= _precisionTolerance;
    if (passed) {
      result.dispose();
      return true;
    }

    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}

/// Sets [_TolerantGoldenFileComparator] as the default golden file comparator
/// in tests.
void setUpTolerantComparator(String testPath) {
  final oldComparator = goldenFileComparator;
  final newComparator = _TolerantGoldenFileComparator(Uri.parse(testPath));

  goldenFileComparator = newComparator;

  addTearDown(() => goldenFileComparator = oldComparator);
}
