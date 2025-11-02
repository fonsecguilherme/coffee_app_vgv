import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';

import '../../domain/model/coffee_model.dart';

abstract class ILocalDataSource {
  Future<bool> save(CoffeeModel coffee);
  Future<List<CoffeeModel>> getAll();
  Future<void> clear();
  Future<void> remove(String path);
  Future<String> getSingleImagePath();
}

class LocalCoffeeDataSource implements ILocalDataSource {
  @override
  Future<bool> save(CoffeeModel coffee) async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      final uri = Uri.parse(coffee.file);
      final fileName = uri.pathSegments.last;

      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        return false;
      }

      await file.writeAsBytes(coffee.bytes!);
      return true;
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

  @override
  Future<String> getSingleImagePath() async {
    try {
      final files = await _getImageFiles();
      if (files.isEmpty) throw Exception('No images available');

      final random = Random();
      final selectedFile = files[random.nextInt(files.length)];

      final baseDir = await getApplicationDocumentsDirectory();
      final tempDir = Directory('${baseDir.path}/notifications_temp');

      if (!await tempDir.exists()) {
        await tempDir.create(recursive: true);
      }

      final tempFileName =
          'notification_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = File('${tempDir.path}/$tempFileName');

      await selectedFile.copy(tempFile.path);

      _cleanupOldTempFiles(tempDir);

      return tempFile.path;
    } catch (e) {
      throw Exception('Error retrieving image path: $e');
    }
  }

  Future<void> _cleanupOldTempFiles(Directory tempDir) async {
    try {
      final files = tempDir.listSync().whereType<File>().toList();

      if (files.length > 5) {
        files.sort(
          (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
        );
        final oldFiles = files.skip(5);
        for (final file in oldFiles) {
          await file.delete();
        }
      }
    } catch (_) {}
  }
}
