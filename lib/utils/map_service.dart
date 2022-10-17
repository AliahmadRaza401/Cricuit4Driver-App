
import 'dart:ui' as ui;
import 'package:circuit4driver/utils/app_images.dart';
import 'package:flutter/services.dart';

class MapServices {
  static Future<Uint8List> getMarkerWithSizeandWithoutContedt(int width,String img) async {
    ByteData data = await rootBundle.load(img);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }



    static Future<Uint8List> getMarkerWithSize(int width) async {
    ByteData data = await rootBundle.load(AppImages.markerDefaultImage);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
