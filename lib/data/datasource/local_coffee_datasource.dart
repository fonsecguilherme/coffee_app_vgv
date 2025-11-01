import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../domain/model/coffee_model.dart';

abstract class ILocalDataSource {
  Future<void> save(CoffeeModel coffee);
  Future<List<CoffeeModel>> getAll();
  Future<void> clear();
  Future<void> remove(String path);
}

//Adicionar o try catch em cada operação

class LocalCoffeeDataSource implements ILocalDataSource {
  @override
  Future<void> save(CoffeeModel coffee) async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      final uri = Uri.parse(coffee.file);
      final fileName = uri.pathSegments.last;

      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        return;
      }

      await file.writeAsBytes(coffee.bytes!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CoffeeModel>> getAll() async {
    try {
      final favorites = <CoffeeModel>[];
      final List<File> files = await _getImageFiles();

      files.sort((a, b) => a.path.compareTo(b.path));

      for (final file in files) {
        try {
          final bytes = await file.readAsBytes();
          favorites.add(
            CoffeeModel(file: file.path, bytes: bytes, localPath: file.path),
          );
        } catch (e) {
          continue;
        }
      }

      return favorites;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> clear() async {
    try {
      final files = await _getImageFiles();

      for (final file in files) {
        try {
          await file.delete();
        } catch (e) {
          continue;
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> remove(String path) async {
    try {
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
      } else {
        throw Exception('File not found: $path');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<File>> _getImageFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final dir = Directory(directory.path);

      final files = dir
          .listSync()
          .whereType<File>()
          .where(
            (file) => RegExp(
              r'\.(jpg|png)$',
              caseSensitive: false,
            ).hasMatch(file.path),
          )
          .toList();

      return files;
    } catch (e) {
      return [];
    }
  }
}
