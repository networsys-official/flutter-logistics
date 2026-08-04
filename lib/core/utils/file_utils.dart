import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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

    return await _compressImage(File(path));
  }

  /// Captures an image from the camera.
  static Future<File?> captureFromCamera() async {
    try {
      final picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1500,
        maxHeight: 1500,
      );

      if (image == null) return null;

      return await _compressImage(File(image.path));
    } catch (_) {
      return null;
    }
  }

  static Future<File?> _compressImage(File file) async {
    final targetPath =
        '${file.parent.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final compressed = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 70,
      minWidth: 1200,
      minHeight: 1200,
    );

    if (compressed == null) return null;

    return File(compressed.path);
  }

}
