import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutoSizeTextPainter extends CustomPainter {
  final List<LineMetrics> lineMetrics;
  final Color backgroundColor;
  final Radius radius;
  final EdgeInsets padding;
  final TextAlign textAlign;

  AutoSizeTextPainter({
    this.lineMetrics = const [],
    this.backgroundColor = const Color(0x00FFFFFF),
    this.radius = const Radius.circular(20),
    this.padding = const EdgeInsets.all(8),
    this.textAlign = TextAlign.center
  });

  final _backgroundPath = Path();

  @override
  void paint(Canvas canvas, Size size) {
    final _paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final _defaultArcVal = lineMetrics.first.height * .2;

    ///Top and bottom lineMetrics are need to draw the start and end correctly
    final _originLineMetric = LineMetrics(
        hardBreak: lineMetrics.first.hardBreak,
        height: 0,
        width: 0,
        left: size.width / 2,
        lineNumber: 0,
        ascent: lineMetrics.first.ascent,
        descent: lineMetrics.first.descent,
        baseline: lineMetrics.first.baseline,
        unscaledAscent: lineMetrics.first.unscaledAscent);
    final _endLineMetric = LineMetrics(
        hardBreak: lineMetrics.last.hardBreak,
        height: 0,
        width: 0,
        left: size.width / 2,
        lineNumber: 0,
        ascent: lineMetrics.last.ascent,
        descent: lineMetrics.last.descent,
        baseline: lineMetrics.last.baseline,
        unscaledAscent: lineMetrics.last.unscaledAscent);

    switch(textAlign){
      case TextAlign.left:
      case TextAlign.start:
        _drawVerticalStraightPath(true, _defaultArcVal, size);
      _drawRightPath(_defaultArcVal, _originLineMetric, _endLineMetric);
      canvas.drawPath(_backgroundPath, _paint);
        break;
      case TextAlign.right:
      case TextAlign.end:
      _drawVerticalStraightPath(false, _defaultArcVal, size);
      _drawLeftPath(_defaultArcVal, _originLineMetric, _endLineMetric);
      canvas.drawPath(_backgroundPath, _paint);
        break;
      case TextAlign.center:
        _drawLeftPath(_defaultArcVal, _originLineMetric, _endLineMetric);
        _drawRightPath(_defaultArcVal, _originLineMetric, _endLineMetric);
        canvas.drawPath(_backgroundPath, _paint);
        break;
      case TextAlign.justify:
        canvas.drawRRect(RRect.fromLTRBR(-padding.left, -padding.top, size.width+padding.left, size.height+padding.top, radius), _paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawLeftPath(double _defaultArcVal, LineMetrics _originLineMetric, LineMetrics _endLineMetric) {
    //Draw left Path, start is middle top, end is middle bottom
    for (var i = 0; i < lineMetrics.length; i++) {
      final lineMetric = lineMetrics[i];
      final _leftX = lineMetric.left - padding.left;
      final _lineTopY = lineMetric.height * lineMetric.lineNumber-(i==0?padding.top:0);
      final _lineBottomY = lineMetric.height * (lineMetric.lineNumber + 1)+ (i==lineMetrics.length-1?padding.bottom:0);

      final _previousLine = i != 0 ? lineMetrics[i - 1] : _originLineMetric;
      final _nextLine = i != lineMetrics.length - 1 ? lineMetrics[i + 1] : _endLineMetric;

      var _arcTopY = _defaultArcVal;
      var _arcTopX = _defaultArcVal;
      var _arcBottomY = _defaultArcVal;
      var _arcBottomX = _defaultArcVal;
      final _isTopArcClockWise = lineMetric.width < _previousLine.width;
      final _isBottomArcClockWise = lineMetric.width < _nextLine.width;

      if (_isTopArcClockWise) {
        final _currentToPreviousLineDifference = (_previousLine.width-lineMetric.width)/2;
        final isTopLineSmallerAsDefaultArc = _defaultArcVal > _currentToPreviousLineDifference;
        if (isTopLineSmallerAsDefaultArc) _arcTopY = _currentToPreviousLineDifference;
        _arcTopX = 0;
      } else {
        final _previousToCurrentLineDifference = (lineMetric.width-_previousLine.width)/2;
        final isTopLineSmallerAsDefaultArc = _defaultArcVal > _previousToCurrentLineDifference;
        if (isTopLineSmallerAsDefaultArc) _arcTopX = _previousToCurrentLineDifference;
        _arcTopY = 0;
      }

      if (_isBottomArcClockWise) {
        final _currentToNextLineDifference = (_nextLine.width-lineMetric.width)/2;
        final isBottomLineSmallerAsDefaultArc = _defaultArcVal > _currentToNextLineDifference;
        if (isBottomLineSmallerAsDefaultArc) _arcBottomY = _currentToNextLineDifference;
        _arcBottomX = 0;
      } else {
        final _currentToNextLineDifference = (lineMetric.width-_nextLine.width)/2;
        final isBottomLineSmallerAsDefaultArc = _defaultArcVal > _currentToNextLineDifference;
        if (isBottomLineSmallerAsDefaultArc) _arcBottomX = _currentToNextLineDifference;
        _arcBottomY = 0;
      }

      if (i == 0) {
        _backgroundPath.moveTo(_originLineMetric.left, _lineTopY);
      }

      _backgroundPath.lineTo(_leftX - _arcTopY + _arcTopX, _lineTopY);
      _backgroundPath.arcToPoint(Offset(_leftX, _lineTopY + _arcTopY + _arcTopX),
          radius: radius, clockwise: _isTopArcClockWise);
      _backgroundPath.lineTo(_leftX, _lineBottomY - _arcBottomY - _arcBottomX);
      _backgroundPath.arcToPoint(Offset(_leftX - _arcBottomY + _arcBottomX, _lineBottomY),
          radius: radius, clockwise: _isBottomArcClockWise);

      if (i == lineMetrics.length - 1) {
        _backgroundPath.lineTo(_endLineMetric.left, _lineBottomY);
        _backgroundPath.close();
      }
    }
  }

  void _drawRightPath(double _defaultArcVal, LineMetrics _originLineMetric, LineMetrics _endLineMetric) {
    //Draw left Path, start is middle top, end is middle bottom
    for (var i = 0; i < lineMetrics.length; i++) {
      final lineMetric = lineMetrics[i];
      final _rightX = lineMetric.left + lineMetric.width + padding.left;
      final _lineTopY = lineMetric.height * lineMetric.lineNumber-(i==0?padding.top:0);
      final _lineBottomY = lineMetric.height * (lineMetric.lineNumber + 1)+ (i==lineMetrics.length-1?padding.bottom:0);

      final _previousLine = i != 0 ? lineMetrics[i - 1] : _originLineMetric;
      final _nextLine = i != lineMetrics.length - 1 ? lineMetrics[i + 1] : _endLineMetric;

      var _arcTopY = _defaultArcVal;
      var _arcTopX = _defaultArcVal;
      var _arcBottomY = _defaultArcVal;
      var _arcBottomX = _defaultArcVal;
      final _isTopArcClockWise = lineMetric.width > _previousLine.width;
      final _isBottomArcClockWise = lineMetric.width > _nextLine.width;

      if (_isTopArcClockWise) {
        final _currentToPreviousLineDifference = (lineMetric.width-_previousLine.width)/2;
        final isTopLineSmallerAsDefaultArc = _defaultArcVal > _currentToPreviousLineDifference;
        if (isTopLineSmallerAsDefaultArc) _arcTopY = _currentToPreviousLineDifference;
        _arcTopX = 0;
      } else {
        final _previousToCurrentLineDifference = (_previousLine.width-lineMetric.width)/2;
        final isTopLineSmallerAsDefaultArc = _defaultArcVal > _previousToCurrentLineDifference;
        if (isTopLineSmallerAsDefaultArc) _arcTopX = _previousToCurrentLineDifference;
        _arcTopY = 0;
      }

      if (_isBottomArcClockWise) {
        final _currentToNextLineDifference = (lineMetric.width-_nextLine.width)/2;
        final isBottomLineSmallerAsDefaultArc = _defaultArcVal > _currentToNextLineDifference;
        if (isBottomLineSmallerAsDefaultArc) _arcBottomY = _currentToNextLineDifference;
        _arcBottomX = 0;
      } else {
        final _currentToNextLineDifference = (_nextLine.width-lineMetric.width)/2;
        final isBottomLineSmallerAsDefaultArc = _defaultArcVal > _currentToNextLineDifference;
        if (isBottomLineSmallerAsDefaultArc) _arcBottomX = _currentToNextLineDifference;
        _arcBottomY = 0;
      }

      if (i == 0) {
        _backgroundPath.moveTo(_originLineMetric.left, _lineTopY);
      }

      _backgroundPath.lineTo(_rightX - _arcTopY + _arcTopX, _lineTopY);
      _backgroundPath.arcToPoint(Offset(_rightX, _lineTopY + _arcTopY + _arcTopX),
          radius: radius, clockwise: _isTopArcClockWise);
      _backgroundPath.lineTo(_rightX, _lineBottomY - _arcBottomY - _arcBottomX);
      _backgroundPath.arcToPoint(Offset(_rightX - _arcBottomY + _arcBottomX, _lineBottomY),
          radius: radius, clockwise: _isBottomArcClockWise);

      if (i == lineMetrics.length - 1) {
        _backgroundPath.lineTo(_endLineMetric.left, _lineBottomY);
        _backgroundPath.close();
      }
    }
  }

  void _drawVerticalStraightPath(bool isLeft, double _defaultArcVal, Size size){
    final _lineTopX = isLeft?-padding.left+_defaultArcVal:size.width;
    final _arcTopX = isLeft?-padding.left:size.width+padding.right;
    final _lineBottomX = isLeft?-padding.left: size.width+padding.right;
    final _arcBottomX = isLeft?0.0:size.width;
    final _isClockWise = isLeft?false:true;

    _backgroundPath.moveTo(size.width/2, -padding.top);

    _backgroundPath.lineTo(_lineTopX, -padding.top);
    _backgroundPath.arcToPoint(Offset(_arcTopX, _defaultArcVal), radius: radius, clockwise: _isClockWise);

    _backgroundPath.lineTo(_lineBottomX, size.height+padding.bottom-_defaultArcVal);
    _backgroundPath.arcToPoint(Offset(_arcBottomX, size.height+padding.bottom), radius: radius, clockwise: _isClockWise);

    _backgroundPath.lineTo(size.width/2, size.height+padding.bottom);
    _backgroundPath.close();
  }
}
