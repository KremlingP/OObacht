import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerGenerator {
  final double _markerSize;
  late double _circleStrokeWidth;
  late double _circleOffset;
  late double _outlineCircleWidth;
  late double _fillCircleWidth;
  late double _iconSize;
  late double _iconOffset;

  MarkerGenerator(this._markerSize) {
    // calculate marker dimensions
    _circleStrokeWidth = _markerSize / 10.0;
    _circleOffset = _markerSize / 2;
    _outlineCircleWidth = _circleOffset - (_circleStrokeWidth / 2);
    _fillCircleWidth = _markerSize / 2;
    final outlineCircleInnerWidth = _markerSize - (2 * _circleStrokeWidth);
    _iconSize = sqrt(pow(outlineCircleInnerWidth, 2) / 2);
    final rectDiagonal = sqrt(2 * pow(_markerSize, 2));
    final circleDistanceToCorners =
        (rectDiagonal - outlineCircleInnerWidth) / 2;
    _iconOffset = sqrt(pow(circleDistanceToCorners, 2) / 2);
  }

  /// Creates a BitmapDescriptor from an IconData
  Future<BitmapDescriptor> createBitmapDescriptorFromIconData(ImageProvider imageProvider,
      Color iconColor, Color circleColor, Color backgroundColor) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    _paintCircleFill(canvas, backgroundColor);
    _paintCircleStroke(canvas, circleColor);
    await _paintIcon(canvas, iconColor, imageProvider);

    final picture = pictureRecorder.endRecording();
    final image =
        await picture.toImage(_markerSize.round(), _markerSize.round());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// Paints the icon background
  void _paintCircleFill(Canvas canvas, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawCircle(
        Offset(_circleOffset, _circleOffset), _fillCircleWidth, paint);
  }

  /// Paints a circle around the icon
  void _paintCircleStroke(Canvas canvas, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = _circleStrokeWidth;
    canvas.drawCircle(
        Offset(_circleOffset, _circleOffset), _outlineCircleWidth, paint);
  }

  /// Paints the icon
  Future<void> _paintIcon(Canvas canvas, Color color, ImageProvider imageProvider) async {
    final paint = Paint()
      ..color = color
      ..filterQuality = FilterQuality.high;
    ui.Image uiImage = await getImage(imageProvider);
    canvas.drawImageRect(
        uiImage,
        Rect.fromLTRB(0, 0, uiImage.width.toDouble(), uiImage.height.toDouble()),
        Rect.fromLTWH(_iconOffset, _iconOffset, _iconSize, _iconSize),
        paint);
  }

  Future<ui.Image> getImage(ImageProvider img) async {
    var completer = Completer<ImageInfo>();
    img.resolve(const ImageConfiguration()).addListener(ImageStreamListener((info, _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }
}
