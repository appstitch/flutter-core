import 'package:flutter_test/flutter_test.dart';

import 'package:appstitch_core/core.dart';
import 'package:appstitch_core/options.dart';

void main() {
  final core = Core();

  final options = Options(appStitchKey: "key", clientID: "client");

  test("initialize", () async {
    core.initialize(options);
    expect(core.options().appStitchKey, "key");
  });

  test("set token", () async {
    core.initialize(options);
    core.setAuthToken("token");

    expect(core.options().auth_token, "token");
  });

  test("clear token", () async {
    core.initialize(options);

    await core.clearAuthToken();

    expect(core.options().auth_token, null);
  });

  test('Test Request', () async {
    core.initialize(options);
  });
}
