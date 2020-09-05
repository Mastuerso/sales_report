import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';

final String scrawlImagePath = '/screen_shot_scraw.png';

screenshot(RenderRepaintBoundary boundary,
    {Function onSuccess, Function onError}) async {
  if (await Permission.storage.request().isGranted) {
    ui.Image image =
        await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var path = await FilePicker.getDirectoryPath();
    String imPath = '$path$scrawlImagePath';
    File imgFile = File(imPath);
    //handle errors
    imgFile.writeAsBytes(byteData.buffer.asUint8List()).then(
      (value) {
        try {
          onSuccess();
        } catch (_) {}
      },
      onError: (value) {
        try {
          onError();
        } catch (_) {}
      },
    );
  }
}
