import 'package:image_picker/image_picker.dart';

class ImageUtils {
  ImageUtils._();

  static final ImagePicker _picker = ImagePicker();

  /// Picks an image from the gallery.
  static Future<XFile?> pickImageFromGallery() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Optimize for upload
      );
    } catch (e) {
      return null;
    }
  }

  /// Picks an image from the camera.
  static Future<XFile?> pickImageFromCamera() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70, // Optimize for upload
      );
    } catch (e) {
      return null;
    }
  }
}
