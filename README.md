# light_weight_picker

A file picker plugin without any dependencies.

## Getting Started

This plugin allows developers to use native file picker api on Android and iOS without any dependencies.

## Usage

```dart

import 'package:light_weight_picker/light_weight_picker.dart';
import 'package:light_weight_picker/selected_file.dart';

class _MyAppState extends State<MyApp> {
  final lightWeightPickerPlugin = LightWeightPicker();

  pickFile() async {
    SelectedFile? selectedFile = await lightWeightPickerPlugin
        .browseAndGetFile(fileType: [FileTypes.All]);
    if (selectedFile != null) {
      debugPrint(selectedFile.fileName.toString());
      debugPrint(selectedFile.fileExtension.toString());
      debugPrint(selectedFile.fileBytes.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: pickFile,
            child: const Text("Browse"),
          ),
        ),
      ),
    );
  }
}
```