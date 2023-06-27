import 'dart:typed_data';

enum FileTypes {
  all,
  audio,
  image,
  jpeg,
  png,
  pdf,
  documents,
  video,
}

class SelectedFile {
  String fileName;
  String fileExtension;
  Uint8List fileBytes;

  SelectedFile({
    required this.fileName,
    required this.fileExtension,
    required this.fileBytes,
  });
}
