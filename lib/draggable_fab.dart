library draggable_fab;

import 'dart:math';

import 'package:flutter/material.dart';

/// Draggable FAB widget which is always aligned to
/// the edge of the screen - be it left,top, right,bottom
class DraggableFab extends StatefulWidget {
  final Widget child;

  const DraggableFab({Key key, this.child})
      : assert(child != null),
        super(key: key);

  @override
  _DraggableFabState createState() => _DraggableFabState();
}

class _DraggableFabState extends State<DraggableFab> {
  Size _widgetSize;
  double _left, _top;
  double _screenWidth, _screenHeight;
  double _screenWidthMid, _screenHeightMid;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _getWidgetSize(context));
  }

  void _getWidgetSize(BuildContext context) {
    _widgetSize = context.size;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        left: this._left,
        top: this._top,
        child: Draggable(
          child: widget.child,
          feedback: widget.child,
          onDragEnd: _handleDragEnded,
          childWhenDragging: Container(
            width: 0.0,
            height: 0.0,
          ),
        ),
      )
    ]);
  }

  void _handleDragEnded(DraggableDetails draggableDetails) {
    if (_screenWidthMid == null || _screenHeightMid == null) {
      Size screenSize = MediaQuery.of(context).size;
      _screenWidth = screenSize.width;
      _screenHeight = screenSize.height;
      _screenWidthMid = _screenWidth / 2;
      _screenHeightMid = _screenHeight / 2;
    }

    switch (_getAnchor(draggableDetails.offset)) {
      case Anchor.LEFT_FIRST:
        this._left = _widgetSize.width / 2;
        this._top = max(_widgetSize.height / 2, draggableDetails.offset.dy);
        break;
      case Anchor.TOP_FIRST:
        this._left = max(_widgetSize.width / 2, draggableDetails.offset.dx);
        this._top = _widgetSize.height / 2;
        break;
      case Anchor.RIGHT_SECOND:
        this._left = _screenWidth - _widgetSize.width;
        this._top = max(_widgetSize.height, draggableDetails.offset.dy);
        break;
      case Anchor.TOP_SECOND:
        this._left =
            min(_screenWidth - _widgetSize.width, draggableDetails.offset.dx);
        this._top = _widgetSize.height / 2;
        break;
      case Anchor.LEFT_THIRD:
        this._left = _widgetSize.width / 2;
        this._top =
            min(_screenHeight - _widgetSize.height, draggableDetails.offset.dy);
        break;
      case Anchor.BOTTOM_THIRD:
        this._left = max(_widgetSize.width / 2, draggableDetails.offset.dx);
        this._top = _screenHeight - _widgetSize.height;
        break;
      case Anchor.RIGHT_FOURTH:
        this._left = _screenWidth - _widgetSize.width;
        this._top =
            min(_screenHeight - _widgetSize.height, draggableDetails.offset.dy);
        break;
      case Anchor.BOTTOM_FOURTH:
        this._left =
            min(_screenWidth - _widgetSize.width, draggableDetails.offset.dx);
        this._top = _screenHeight - _widgetSize.height;
        break;
    }

    setState(() {});
  }

  /// Computes the appropriate anchor screen edge for the widget
  Anchor _getAnchor(Offset position) {
    if (position.dx < _screenWidthMid && position.dy < _screenHeightMid) {
      return position.dx < position.dy ? Anchor.LEFT_FIRST : Anchor.TOP_FIRST;
    } else if (position.dx >= _screenWidthMid &&
        position.dy < _screenHeightMid) {
      return _screenWidth - position.dx < position.dy
          ? Anchor.RIGHT_SECOND
          : Anchor.TOP_SECOND;
    } else if (position.dx < _screenWidthMid &&
        position.dy >= _screenHeightMid) {
      return position.dx < _screenHeight - position.dy
          ? Anchor.LEFT_THIRD
          : Anchor.BOTTOM_THIRD;
    } else {
      return _screenWidth - position.dx < _screenHeight - position.dy
          ? Anchor.RIGHT_FOURTH
          : Anchor.BOTTOM_FOURTH;
    }
  }
}

/// #######################################
/// #       |          #        |         #
/// #    TOP_FIRST     #  TOP_SECOND      #
/// # - LEFT_FIRST     #  RIGHT_SECOND -  #
/// #######################################
/// # - LEFT_THIRD     #   RIGHT_FOURTH - #
/// #  BOTTOM_THIRD    #   BOTTOM_FOURTH  #
/// #     |            #       |          #
/// #######################################
enum Anchor {
  LEFT_FIRST,
  TOP_FIRST,
  RIGHT_SECOND,
  TOP_SECOND,
  LEFT_THIRD,
  BOTTOM_THIRD,
  RIGHT_FOURTH,
  BOTTOM_FOURTH
}
