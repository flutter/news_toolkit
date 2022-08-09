import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}

Storage createMockStorage() {
  final storage = MockStorage();
  when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
  return storage;
}

FutureOr<T> mockHydratedStorage<T>(
  FutureOr<T> Function() body, {
  Storage? storage,
}) {
  return HydratedBlocOverrides.runZoned(
    body,
    createStorage: () => storage ?? createMockStorage(),
  );
}
