import 'dart:io';
import 'dart:typed_data';

import 'package:coffee_app_vgv/data/datasource/local_coffee_datasource.dart';
import 'package:coffee_app_vgv/domain/model/coffee_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class FakePathProviderPlatform extends PathProviderPlatform {
  final String tempPath;

  FakePathProviderPlatform(this.tempPath);

  @override
  Future<String?> getApplicationDocumentsPath() async => tempPath;
}

void main() {
  late LocalCoffeeDataSource dataSource;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('local_coffee_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir.path);
    dataSource = LocalCoffeeDataSource();
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('LocalCoffeeDataSource |', () {
    group('Success cases', () {
      test(
        'Save function should store the coffee and getAll should retrieve it',
        () async {
          final bytes = Uint8List.fromList([1, 2, 3]);
          final coffee = CoffeeModel(
            file: 'https://example.com/coffee.jpg',
            bytes: bytes,
          );

          await dataSource.save(coffee);
          final result = await dataSource.getAll();

          expect(result.length, 1);
          expect(result.first.localPath, contains('coffee.jpg'));
          expect(File(result.first.localPath!).existsSync(), true);
        },
      );

      test('Clear function should remove all files', () async {
        final bytes = Uint8List.fromList([1, 2, 3]);
        await dataSource.save(
          CoffeeModel(file: 'https://example.com/a.png', bytes: bytes),
        );
        await dataSource.save(
          CoffeeModel(file: 'https://example.com/b.jpg', bytes: bytes),
        );

        expect((await dataSource.getAll()).length, 2);

        await dataSource.clear();

        expect((await dataSource.getAll()).isEmpty, true);
      });

      test('Remove function should remove a specific item', () async {
        final bytes = Uint8List.fromList([1, 2, 3]);
        final coffee = CoffeeModel(
          file: 'https://example.com/test.png',
          bytes: bytes,
        );

        await dataSource.save(coffee);

        final saved = await dataSource.getAll();
        final path = saved.first.localPath!;

        await dataSource.remove(path);

        expect(File(path).existsSync(), false);
      });

      test('GetSingleImagePath return single image', () async {
        final bytes = Uint8List.fromList([1, 2, 3]);

        final coffee = CoffeeModel(
          file: 'https://example.com/coffee.jpg',
          bytes: bytes,
        );
        final coffee2 = CoffeeModel(
          file: 'https://example.com/coffee2.jpg',
          bytes: bytes,
        );

        await dataSource.save(coffee);
        await dataSource.save(coffee2);

        final result = await dataSource.getSingleImagePath();

        expect(result, isA<String>());
      });
    });

    group('Exception cases | ', () {
      test(
        'Remove function throws an exception case item not exists',
        () async {
          expect(
            () => dataSource.remove('${tempDir.path}/nonexistent.png'),
            throwsException,
          );
        },
      );
    });
  });
}
