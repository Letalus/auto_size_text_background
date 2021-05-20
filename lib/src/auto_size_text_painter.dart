import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutoSizeTextPainter extends CustomPainter {
  final List<LineMetrics> lineMetrics;
  final Color backgroundColor;

  ///Capped to lineHeight*.3
  /// Any larger borderRadius will be ignored
  final Radius radius;
  final EdgeInsets padding;
  final TextAlign textAlign;

  AutoSizeTextPainter(
      {this.lineMetrics = const [],
      this.backgroundColor = const Color(0x00FFFFFF),
      this.radius = const Radius.circular(20),
      this.padding = const EdgeInsets.all(8),
      this.textAlign = TextAlign.center});

  final _backgroundPath = Path();

  @override
  void paint(Canvas canvas, Size size) {
    final _paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final _defaultArcVal = radius.x<lineMetrics.first.height*0.2?radius.x:lineMetrics.first.height*0.2;

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

    //Draw paths depending on the textAlign property
    switch (textAlign) {
      case TextAlign.left:
      case TextAlign.start:
        _drawRightPath(_defaultArcVal, _originLineMetric, _endLineMetric, size);
        canvas.drawPath(_backgroundPath, _paint);
        break;
      case TextAlign.right:
      case TextAlign.end:
        _drawLeftPath(_defaultArcVal, _originLineMetric, _endLineMetric, size);
        canvas.drawPath(_backgroundPath, _paint);
        break;
      case TextAlign.center:
        _drawLeftPath(_defaultArcVal, _originLineMetric, _endLineMetric, size);
        _drawRightPath(_defaultArcVal, _originLineMetric, _endLineMetric, size);
        canvas.drawPath(_backgroundPath, _paint);
        break;
      case TextAlign.justify:
        canvas.drawRRect(
            RRect.fromLTRBR(-padding.left, -padding.top, size.width + padding.left, size.height + padding.top, radius),
            _paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate!=this;
  }

  void _drawLeftPath(
      double _defaultArcVal, LineMetrics _originLineMetric, LineMetrics _endLineMetric, Size widgetSize) {
    //Draw left Path, start is middle top, end is middle bottom
    for (var i = 0; i < lineMetrics.length; i++) {
      final lineMetric = lineMetrics[i];
      final _leftX = lineMetric.left - padding.left;
      final _lineTopY = lineMetric.height * lineMetric.lineNumber - (i == 0 ? padding.top : 0);
      final _lineBottomY =
          lineMetric.height * (lineMetric.lineNumber + 1) + (i == lineMetrics.length - 1 ? padding.bottom : 0);

      final _previousLine = i != 0 ? lineMetrics[i - 1] : _originLineMetric;
      final _nextLine = i != lineMetrics.length - 1 ? lineMetrics[i + 1] : _endLineMetric;

      final _isTopArcClockWise = lineMetric.width < _previousLine.width;
      final _isBottomArcClockWise = lineMetric.width < _nextLine.width;

      final _arcTopOffset = _getArcTopValues(_isTopArcClockWise, _previousLine, lineMetric, _defaultArcVal);
      final _arcBottomOffset = _getArcBottomValues(_isBottomArcClockWise, _nextLine, lineMetric, _defaultArcVal);

      final _arcTopY = _arcTopOffset.dy;
      final _arcTopX = _arcTopOffset.dx;

      final _arcBottomY = _arcBottomOffset.dy;
      final _arcBottomX = _arcBottomOffset.dx;

      if (i == 0) {
        _moveToOriginPath(widgetSize, _defaultArcVal, _lineTopY);
      }

      _backgroundPath.lineTo(_leftX - _arcTopY + _arcTopX, _lineTopY);
      _backgroundPath.arcToPoint(Offset(_leftX, _lineTopY + _arcTopY + _arcTopX),
          radius: radius, clockwise: _isTopArcClockWise);
      _backgroundPath.lineTo(_leftX, _lineBottomY - _arcBottomY - _arcBottomX);
      _backgroundPath.arcToPoint(Offset(_leftX - _arcBottomY + _arcBottomX, _lineBottomY),
          radius: radius, clockwise: _isBottomArcClockWise);

      if (i == lineMetrics.length - 1) {
        _drawFinishPath(widgetSize, _defaultArcVal, _lineTopY, _lineBottomY);
      }
    }
  }

  void _drawRightPath(
      double _defaultArcVal, LineMetrics _originLineMetric, LineMetrics _endLineMetric, Size widgetSize) {
    //Draw left Path, start is middle top, end is middle bottom
    for (var i = 0; i < lineMetrics.length; i++) {
      final lineMetric = lineMetrics[i];
      final _rightX = lineMetric.left + lineMetric.width + padding.left;
      final _lineTopY = lineMetric.height * lineMetric.lineNumber - (i == 0 ? padding.top :0);
      final _lineBottomY =
          lineMetric.height * (lineMetric.lineNumber + 1) + (i == lineMetrics.length - 1 ? padding.bottom : 0);

      final _previousLine = i != 0 ? lineMetrics[i - 1] : _originLineMetric;
      final _nextLine = i != lineMetrics.length - 1 ? lineMetrics[i + 1] : _endLineMetric;

      final _isTopArcClockWise = lineMetric.width > _previousLine.width;
      final _isBottomArcClockWise = lineMetric.width > _nextLine.width;

      final _arcTopOffset = _getArcTopValues(_isTopArcClockWise, lineMetric, _previousLine, _defaultArcVal);
      final _arcBottomOffset = _getArcBottomValues(_isBottomArcClockWise, lineMetric, _nextLine, _defaultArcVal);
      final _arcTopY = _arcTopOffset.dy;
      final _arcTopX = _arcTopOffset.dx;
      final _arcBottomY = _arcBottomOffset.dy;
      final _arcBottomX = _arcBottomOffset.dx;

      if (i == 0) {
        _moveToOriginPath(widgetSize, _defaultArcVal, _lineTopY);
      }

      _backgroundPath.lineTo(_rightX - _arcTopY + _arcTopX, _lineTopY);
      _backgroundPath.arcToPoint(Offset(_rightX, _lineTopY + _arcTopY + _arcTopX),
          radius: radius, clockwise: _isTopArcClockWise);
      _backgroundPath.lineTo(_rightX, _lineBottomY - _arcBottomY - _arcBottomX);
      _backgroundPath.arcToPoint(Offset(_rightX - _arcBottomY + _arcBottomX, _lineBottomY),
          radius: radius, clockwise: _isBottomArcClockWise);

      if (i == lineMetrics.length - 1) {
        _drawFinishPath(widgetSize, _defaultArcVal, _lineTopY, _lineBottomY);
      }
    }
  }



  Offset _getArcTopValues(
      bool _isTopArcClockWise, LineMetrics firstLineMetric, LineMetrics secondLineMetric, double _defaultArcVal) {
    var _arcTopX = 0.0;
    var _arcTopY = 0.0;
    if (_isTopArcClockWise) {
      final _currentToPreviousLineDifference = (firstLineMetric.width - secondLineMetric.width) / 2;
      final isTopLineSmallerAsDefaultArc = _defaultArcVal > _currentToPreviousLineDifference;
      if (isTopLineSmallerAsDefaultArc) {
        _arcTopY = _currentToPreviousLineDifference/2;
      } else {
        _arcTopY = _defaultArcVal;
      }
      _arcTopX = 0;
    } else {
      final _previousToCurrentLineDifference = (secondLineMetric.width - firstLineMetric.width) / 2;
      final isTopLineSmallerAsDefaultArc = _defaultArcVal > _previousToCurrentLineDifference;
      if (isTopLineSmallerAsDefaultArc) {
        _arcTopX = _previousToCurrentLineDifference/2;
      } else {
        _arcTopX = _defaultArcVal;
      }
      _arcTopY = 0;
    }

    return Offset(_arcTopX, _arcTopY);
  }

  Offset _getArcBottomValues(
      bool _isBottomArcClockWise, LineMetrics firstLineMetric, LineMetrics secondLineMetric, double _defaultArcVal) {
    var _arcBottomY = 0.0;
    var _arcBottomX = 0.0;

    if (_isBottomArcClockWise) {
      final _currentToNextLineDifference = (firstLineMetric.width - secondLineMetric.width) / 2;
      final isBottomLineSmallerAsDefaultArc = _defaultArcVal > _currentToNextLineDifference;
      if (isBottomLineSmallerAsDefaultArc) {
        _arcBottomY = _currentToNextLineDifference / 2;
      } else{
        _arcBottomY = _defaultArcVal;
      }
      _arcBottomX = 0;
    } else {
      final _currentToNextLineDifference = (secondLineMetric.width - firstLineMetric.width) / 2;
      final isBottomLineSmallerAsDefaultArc = _defaultArcVal > _currentToNextLineDifference;
      if (isBottomLineSmallerAsDefaultArc) {
        _arcBottomX = _currentToNextLineDifference / 2;
      }else{
        _arcBottomX = _defaultArcVal;
      }
      _arcBottomY = 0;
    }

    return Offset(_arcBottomX, _arcBottomY);
  }

  void _moveToOriginPath(Size widgetSize, double _defaultArcVal, double _lineTopY) {
    switch (textAlign) {
      case TextAlign.left:
      case TextAlign.start:
        _backgroundPath.moveTo(_defaultArcVal, _lineTopY);
        break;
      case TextAlign.right:
      case TextAlign.end:
        _backgroundPath.moveTo(widgetSize.width - _defaultArcVal, _lineTopY);
        break;
      case TextAlign.center:
        _backgroundPath.moveTo(widgetSize.width / 2, _lineTopY);
        break;
      case TextAlign.justify:
        break;
    }
  }

  void _drawFinishPath(Size widgetSize, double _defaultArcVal, double _lineTopY, double _lineBottomY) {
    switch (textAlign) {
      case TextAlign.left:
      case TextAlign.start:
        _backgroundPath.lineTo(_defaultArcVal - padding.left, _lineBottomY);
        _backgroundPath.arcToPoint(Offset(-padding.left, _lineBottomY - _defaultArcVal),
            radius: radius, clockwise: true);
        _backgroundPath.lineTo(-padding.left, _defaultArcVal - padding.top);
        _backgroundPath.arcToPoint(Offset(-padding.left + _defaultArcVal, -padding.top),
            radius: radius, clockwise: true);
        _backgroundPath.close();
        break;
      case TextAlign.right:
      case TextAlign.end:
        _backgroundPath.lineTo(widgetSize.width + padding.right - _defaultArcVal, _lineBottomY);
        _backgroundPath.arcToPoint(Offset(widgetSize.width + padding.right, _lineBottomY - _defaultArcVal),
            radius: radius, clockwise: false);
        _backgroundPath.lineTo(widgetSize.width + padding.right, _defaultArcVal - padding.top);
        _backgroundPath.arcToPoint(Offset(widgetSize.width + padding.right - _defaultArcVal, -padding.top),
            radius: radius, clockwise: false);
        _backgroundPath.close();
        break;
      case TextAlign.center:
        _backgroundPath.lineTo(widgetSize.width / 2, _lineBottomY);
        break;
      case TextAlign.justify:
        break;
    }
  }
}
