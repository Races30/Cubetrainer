import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageUtils {
  static Future<Directory> getExportDirectory() async {
    Directory? baseDir;

    try {
      if (Platform.isAndroid) {
        // On Android, getExternalStorageDirectory usually points to /storage/emulated/0/Android/data/com.example.app/files
        // if we want the public Downloads folder, we might need to hardcode it or use a different approach.
        // For simplicity and to avoid complex permission issues, let's try to find the standard Downloads path.
        baseDir = Directory('/storage/emulated/0/Download');
        if (!await baseDir.exists()) {
          baseDir = await getExternalStorageDirectory();
        }
      } else {
        baseDir = await getDownloadsDirectory();
      }
    } catch (_) {
      // Fallback to documents if downloads is not available
    }

    baseDir ??= await getApplicationDocumentsDirectory();

    final exportDir = Directory('${baseDir.path}/CubeTrainer');
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }

    return exportDir;
  }
}
