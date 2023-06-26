import 'package:light_weight_picker/light_weight_picker_platform_interface.dart';
import 'package:light_weight_picker/selected_file.dart';

class LightWeightPicker {
  Future<dynamic> browseAndGetFile({List<FileTypes>? fileType}) {
    return LightWeightPickerPlatform.instance
        .browseAndGetFile(fileType: fileType);
  }
}
