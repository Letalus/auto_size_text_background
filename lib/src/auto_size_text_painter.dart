import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutoSizeTextPainter extends CustomPainter {
  final List<LineMetrics> lineMetrics;
  late Color backgroundColor;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  AutoSizeTextPainter({
    this.lineMetrics = const [],
    this.backgroundColor = const Color(0x00FFFFFF),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding = const EdgeInsets.all(8),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final _paint = Paint()..color = backgroundColor
    ..style = PaintingStyle.fill;

    final _backgroundPath = Path();

    //Draw left Path, start is middle top, end is middle bottom
    for(var i = 0; i<lineMetrics.length;i++){
      final lineMetric = lineMetrics[i];
      final _leftX = lineMetric.left-padding.left;
      final _lineTopY = lineMetric.height*lineMetric.lineNumber;
      final _lineBottomY = lineMetric.height*(lineMetric.lineNumber+1);

      if(i==0){
        final _topMiddleX = lineMetric.left+lineMetric.width/2;
        _backgroundPath.moveTo(_topMiddleX, -padding.top);
        _backgroundPath.lineTo(_leftX, -padding.top);
        _backgroundPath.lineTo(_leftX, lineMetric.height);
      }else if(i==lineMetrics.length-1){
        final _bottomMiddleX = lineMetric.left+lineMetric.width/2;
        _backgroundPath.lineTo(_leftX, _lineTopY);
        _backgroundPath.lineTo(_leftX, _lineBottomY+padding.bottom);
        _backgroundPath.lineTo(_bottomMiddleX, _lineBottomY+padding.bottom);
      }else{
        _backgroundPath.lineTo(_leftX, _lineTopY);
        _backgroundPath.lineTo(_leftX, _lineBottomY);
      }
    }

    //Draw right Path, start is middle bottom, end is middle top
    for(var i = lineMetrics.length-1; i>=0;i--){
      final lineMetric = lineMetrics[i];
      final _leftX = lineMetric.left+lineMetric.width+padding.right;
      final _lineTopY = lineMetric.height*lineMetric.lineNumber;
      final _lineBottomY = lineMetric.height*(lineMetric.lineNumber+1);

      if(i==lineMetrics.length-1){
        final _bottomMiddleX = lineMetric.left+lineMetric.width/2;
        _backgroundPath.lineTo(_bottomMiddleX, _lineBottomY+padding.bottom);
        _backgroundPath.lineTo(_leftX, _lineBottomY+padding.bottom);
        _backgroundPath.lineTo(_leftX, _lineTopY);
      }else if(i==0){
        _backgroundPath.lineTo(_leftX, lineMetric.height);
        _backgroundPath.lineTo(_leftX, -padding.top);
        _backgroundPath.close();
      }else{
        _backgroundPath.lineTo(_leftX, _lineBottomY);
        _backgroundPath.lineTo(_leftX, _lineTopY);
      }
    }


    canvas.drawPath(_backgroundPath, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
