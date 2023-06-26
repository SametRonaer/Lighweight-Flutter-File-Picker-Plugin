import 'package:light_weight_picker/selected_file.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'light_weight_picker_method_channel.dart';

abstract class LightWeightPickerPlatform extends PlatformInterface {
  /// Constructs a LightWeightPickerPlatform.
  LightWeightPickerPlatform() : super(token: _token);

  static final Object _token = Object();

  static LightWeightPickerPlatform _instance = MethodChannelLightWeightPicker();

  /// The default instance of [LightWeightPickerPlatform] to use.
  ///
  /// Defaults to [MethodChannelLightWeightPicker].
  static LightWeightPickerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LightWeightPickerPlatform] when
  /// they register themselves.
  static set instance(LightWeightPickerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<SelectedFile?> browseAndGetFile({List<FileTypes>? fileType}) {
    throw UnimplementedError('browseAndGetFile() has not been implemented.');
  }
}
