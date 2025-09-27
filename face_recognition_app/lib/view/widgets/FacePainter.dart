import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends CustomPainter {
  final List<Face> facesList;
  final ui.Image? imageFile;

  FacePainter({required this.facesList, required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile == null) return;

    // Draw the image to fit the widget size (BoxFit.cover style)
    final paintRect = _getFittedRect(
      srcWidth: imageFile!.width.toDouble(),
      srcHeight: imageFile!.height.toDouble(),
      dstWidth: size.width,
      dstHeight: size.height,
    );
    paintImage(
      canvas: canvas,
      rect: paintRect,
      image: imageFile!,
      fit: BoxFit.cover,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.red;

    // Calculate scaling and offset for bounding boxes
    final double scaleX = paintRect.width / imageFile!.width;
    final double scaleY = paintRect.height / imageFile!.height;
    final double offsetX = paintRect.left;
    final double offsetY = paintRect.top;

    for (final face in facesList) {
      final Rect rect = Rect.fromLTRB(
        face.boundingBox.left * scaleX + offsetX,
        face.boundingBox.top * scaleY + offsetY,
        face.boundingBox.right * scaleX + offsetX,
        face.boundingBox.bottom * scaleY + offsetY,
      );
      canvas.drawRect(rect, paint);
    }
  }

  // Helper to fit source image into widget size with BoxFit.cover logic
  Rect _getFittedRect({
    required double srcWidth,
    required double srcHeight,
    required double dstWidth,
    required double dstHeight,
  }) {
    final srcAspect = srcWidth / srcHeight;
    final dstAspect = dstWidth / dstHeight;

    double scale, offsetX = 0, offsetY = 0, outWidth, outHeight;

    if (srcAspect > dstAspect) {
      // Image is wider than destination: scale by height, crop width
      scale = dstHeight / srcHeight;
      outWidth = srcWidth * scale;
      outHeight = dstHeight;
      offsetX = (dstWidth - outWidth) / 2;
    } else {
      // Image is taller than destination: scale by width, crop height
      scale = dstWidth / srcWidth;
      outWidth = dstWidth;
      outHeight = srcHeight * scale;
      offsetY = (dstHeight - outHeight) / 2;
    }
    return Rect.fromLTWH(offsetX, offsetY, outWidth, outHeight);
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) =>
      oldDelegate.facesList != facesList ||
          oldDelegate.imageFile != imageFile;
}