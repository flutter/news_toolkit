import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

/// Class to mock the methods related to url_launcher package.
class MockUrlLauncher extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  /// The string url.
  String? url;

  /// Bool to know if is used Safari.
  bool? useSafariVC;

  /// Bool to know if is used a web view.
  bool? useWebView;

  /// Bool to know if javascript is enabled.
  bool? enableJavaScript;

  /// Bool to know if dom storage is enabled.
  bool? enableDomStorage;

  /// Map of headers.
  Map<String, String>? headers;

  /// String of the web only window name.
  String? webOnlyWindowName;

  /// Bool to know the response of the method.
  bool? response;

  /// Bool to close the web view.
  bool closeWebViewCalled = false;

  /// Bool to know if a URI can be launch.
  bool canLaunchCalled = false;

  /// Bool to know if the URI was launched.
  bool launchCalled = false;

  /// Method to set the URL of the method `canLaunch`.
  void setCanLaunchUrl(String url) {
    this.url = url;
  }

  /// Method to set the needed variables to use the `launchURL`method.
  void setLaunchExpectations({
    required String url,
    required bool? useSafariVC,
    required bool useWebView,
    required bool enableJavaScript,
    required bool enableDomStorage,
    required bool universalLinksOnly,
    required Map<String, String> headers,
    required String? webOnlyWindowName,
  }) {
    this.url = url;
    this.useSafariVC = useSafariVC;
    this.useWebView = useWebView;
    this.enableJavaScript = enableJavaScript;
    this.enableDomStorage = enableDomStorage;
    this.headers = headers;
    this.webOnlyWindowName = webOnlyWindowName;
  }

  /// Method to set the result of the response.
  /// Use to determinate if `canLaunch` or `launchURL` returns
  /// `true` or `false`.
  void setResponse(bool response) {
    this.response = response;
  }

  @override
  Future<bool> canLaunch(String url) async {
    expect(url, this.url);
    canLaunchCalled = true;
    return response!;
  }

  @override
  Future<bool> launch(
    String url, {
    required bool useSafariVC,
    required bool useWebView,
    required bool enableJavaScript,
    required bool enableDomStorage,
    required bool universalLinksOnly,
    required Map<String, String> headers,
    String? webOnlyWindowName,
  }) async {
    expect(url, this.url);
    expect(useSafariVC, this.useSafariVC);
    expect(useWebView, this.useWebView);
    expect(enableJavaScript, this.enableJavaScript);
    expect(enableDomStorage, this.enableDomStorage);
    expect(headers, this.headers);
    expect(webOnlyWindowName, this.webOnlyWindowName);
    launchCalled = true;
    return response!;
  }
}
