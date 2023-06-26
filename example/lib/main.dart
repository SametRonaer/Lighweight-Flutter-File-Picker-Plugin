import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:light_weight_picker/light_weight_picker.dart';
import 'package:light_weight_picker/selected_file.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _lightWeightPickerPlugin = LightWeightPicker();

  _pickFile() async {
    SelectedFile? selectedFile = await _lightWeightPickerPlugin
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
            onPressed: _pickFile,
            child: const Text("Browse"),
          ),
        ),
      ),
    );
  }
}
