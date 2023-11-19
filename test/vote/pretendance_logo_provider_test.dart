// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myecl/vote/providers/contender_logo_provider.dart';
import 'package:myecl/vote/repositories/contender_logo_repository.dart';

class MockContenderLogoRepository extends Mock
    implements ContenderLogoRepository {}

void main() {
  late ContenderLogoRepository repository;
  late ContenderLogoProvider provider;

  setUp(() {
    repository = MockContenderLogoRepository();
    provider = ContenderLogoProvider(repository: repository);
  });

  group('ContenderLogoProvider', () {
    test('initial state is loading', () {
      expect(provider.state, isA<AsyncLoading>());
    });

    test('getLogo returns Image', () async {
      const id = '123';
      final image = Image.network('https://example.com/image.png');
      when(() => repository.getPretendenceLogo(id))
          .thenAnswer((_) async => image);

      final result = await provider.getLogo(id);

      expect(result, equals(image));
    });

    test('updateLogo returns Image', () async {
      const id = '123';
      const path = '/path/to/image.png';
      final image = Image.network('https://example.com/image.png');
      when(() => repository.addPretendenceLogo(path, id))
          .thenAnswer((_) async => image);

      final result = await provider.updateLogo(id, path);

      expect(result, equals(image));
    });
  });
}
