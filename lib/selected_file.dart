import 'dart:typed_data';

enum FileTypes {
  All,
  Audio,
  Image,
  Jpeg,
  Png,
  Pdf,
  Documents,
  Video,
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
