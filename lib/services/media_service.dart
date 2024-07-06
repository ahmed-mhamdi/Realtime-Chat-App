import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MediaService {
  final ImagePicker _imagePicker = ImagePicker();
  MediaService() {}

  Future<File?> selectImageFromGallery() async {
    final XFile? _file =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    return _file != null ? File(_file.path) : null;
  }
}
