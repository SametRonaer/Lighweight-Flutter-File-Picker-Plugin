import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:light_weight_picker/selected_file.dart';

import 'light_weight_picker_platform_interface.dart';

/// An implementation of [LightWeightPickerPlatform] that uses method channels.
class MethodChannelLightWeightPicker extends LightWeightPickerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('light_weight_picker');
  @override
  Future<SelectedFile?> browseAndGetFile({List<FileTypes>? fileType}) async {
    final data = await methodChannel.invokeMethod<dynamic>(
      'browseAndGetFile',
      {
        "fileTypes": _getFileTypes(fileTypes: fileType),
      },
    );
    if (data != null) {
      return _mapData(data);
    }
    return null;
  }

  _getFileTypes({List<FileTypes>? fileTypes}) {
    List<String> fileTypeData = [];
    if (fileTypes == null ||
        fileTypes.contains(FileTypes.All) ||
        fileTypes.isEmpty) {
      fileTypeData.add("All");
      return fileTypeData;
    }
    if (fileTypes.contains(FileTypes.Audio)) {
      fileTypeData.add("Audios");
    }
    if (fileTypes.contains(FileTypes.Image)) {
      fileTypeData.add("Images");
    }
    if (fileTypes.contains(FileTypes.Video)) {
      fileTypeData.add("Videos");
    }
    if (fileTypes.contains(FileTypes.Documents)) {
      fileTypeData.add("Documents");
    }
    if (fileTypes.contains(FileTypes.Jpeg)) {
      fileTypeData.add("Jpg");
    }
    if (fileTypes.contains(FileTypes.Png)) {
      fileTypeData.add("Png");
    }
    if (fileTypes.contains(FileTypes.Pdf)) {
      fileTypeData.add("Pdf");
    }
    return fileTypeData;
  }

  SelectedFile? _mapData(dynamic data) {
    Uint8List? fileBytes;
    String? fileName;
    String? fileExtension;
    if (Platform.isAndroid) {
      try {
        var json = jsonDecode(data);
        fileName = json['fileName'];
        fileExtension = json['fileExtension'];
        fileBytes = base64Decode(json["fileBytes"]);
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    } else if (Platform.isIOS) {
      try {
        fileBytes = base64Decode(data["fileBytes"]);
        fileExtension = data['fileExtension'];
        fileName = data['fileName'];
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    }
    return SelectedFile(
      fileName: fileName!,
      fileExtension: fileExtension!,
      fileBytes: fileBytes!,
    );
  }
}
