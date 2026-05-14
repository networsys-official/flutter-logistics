import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileUtils {
  FileUtils._();

  /// Picks a document (jpg, jpeg, png, pdf) from device storage.
  /// Returns a [File] with a proper path and extension.
  static Future<File?> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: false, // stream from path, don't load bytes into memory
    );

    if (result == null || result.files.isEmpty) return null;

    final path = result.files.single.path;
    if (path == null) return null;

    return File(path);
  }

  /// Picks an image from device storage.
  static Future<File?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: false,
    );

    if (result == null || result.files.isEmpty) return null;

    final path = result.files.single.path;
    if (path == null) return null;

    return File(path);
  }
}
