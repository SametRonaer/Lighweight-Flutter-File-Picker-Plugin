import 'package:flutter_test/flutter_test.dart';
import 'package:light_weight_picker/light_weight_picker.dart';
import 'package:light_weight_picker/light_weight_picker_platform_interface.dart';
import 'package:light_weight_picker/light_weight_picker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLightWeightPickerPlatform
    with MockPlatformInterfaceMixin
    implements LightWeightPickerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LightWeightPickerPlatform initialPlatform = LightWeightPickerPlatform.instance;

  test('$MethodChannelLightWeightPicker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLightWeightPicker>());
  });

  test('getPlatformVersion', () async {
    LightWeightPicker lightWeightPickerPlugin = LightWeightPicker();
    MockLightWeightPickerPlatform fakePlatform = MockLightWeightPickerPlatform();
    LightWeightPickerPlatform.instance = fakePlatform;

    expect(await lightWeightPickerPlugin.getPlatformVersion(), '42');
  });
}
