import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _MockPathProvider extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {}

void setUpMockPathProvider() {
  final pathProviderPlatform = _MockPathProvider();
  PathProviderPlatform.instance = pathProviderPlatform;
  when(
    pathProviderPlatform.getApplicationSupportPath,
  ).thenAnswer((_) async => '.');
  when(pathProviderPlatform.getTemporaryPath).thenAnswer((_) async => '.');
}
