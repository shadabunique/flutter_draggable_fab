library draggable_fab;

import 'dart:math';

import 'package:flutter/material.dart';

/// Draggable FAB widget which is always aligned to
/// the edge of the screen - be it left,top, right,bottom
class DraggableFab extends StatefulWidget {
  ///
  const DraggableFab({
    Key? key,
    required this.child,
    this.onDragStarted,
    this.onDragUpdate,
    this.onDraggableCanceled,
    this.onDragEnd,
    this.onDragCompleted,
    this.initPosition,
    this.securityBottom = 0,
  }) : super(key: key);

  /// The FAB
  final FloatingActionButton child;

  /// Called when the draggable starts being dragged.
  final VoidCallback? onDragStarted;

  /// Called when the draggable is dragged.
  final DragUpdateCallback? onDragUpdate;

  /// Called when the draggable is dropped without being accepted by a DragTarget.
  final DraggableCanceledCallback? onDraggableCanceled;

  /// Called when the draggable is dropped and accepted by a DragTarget
  final VoidCallback? onDragCompleted;

  /// Signature for when the draggable is dropped.
  final DragEndCallback? onDragEnd;

  ///
  final Offset? initPosition;

  ///
  final double? securityBottom;

  @override
  _DraggableFabState createState() => _DraggableFabState();
}

class _DraggableFabState extends State<DraggableFab> {
  //
  late Size widgetSize;
  late double securityBottom;
  double? left, top;
  double screenWidth = 0, screenHeight = 0;
  double? screenWidthMid, screenHeightMid;

  @override
  void initState() {
    super.initState();
    // Schedule a callback for the end of this frame.
    // Prevents the error: Cannot get size during build.
    WidgetsBinding.instance.addPostFrameCallback((_) => getWidgetSize(context));
    // In case null was explicitly passed
    securityBottom = widget.securityBottom ?? 0;
  }

  void getWidgetSize(BuildContext context) {
    //
    widgetSize = context.size!;
    if (widget.initPosition != null) {
      calculatePosition(widget.initPosition!);
      // Call build()
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Stack(children: [
        Positioned(
          left: left,
          top: top,
          child: Draggable(
            feedback: widget.child,
            onDragStarted: widget.onDragStarted,
            onDragUpdate: widget.onDragUpdate,
            onDraggableCanceled: widget.onDraggableCanceled,
            onDragEnd: handleDragEnded,
            onDragCompleted: widget.onDragCompleted,
            childWhenDragging: const SizedBox(),
            child: widget.child,
          ),
        )
      ]);

  void handleDragEnded(DraggableDetails draggableDetails) {
    //
    calculatePosition(draggableDetails.offset);
    // If a 'drag end' function was provided
    if (widget.onDragEnd != null) {
      widget.onDragEnd!(draggableDetails);
    }
    // Call build()
    setState(() {});
  }

  // top left is calculated
  void calculatePosition(Offset targetOffset) {
    //
    if (screenWidthMid == null) {
      final Size screenSize = MediaQuery.of(context).size;
      screenWidth = screenSize.width;
      screenHeight = screenSize.height;
      screenWidthMid = screenWidth / 2;
      screenHeightMid = screenHeight / 2;
    }

    switch (getAnchor(targetOffset)) {
      case FabAnchor.LEFT_FIRST:
        left = widgetSize.width / 2;
        top = max(widgetSize.height / 2, targetOffset.dy);
        break;
      case FabAnchor.TOP_FIRST:
        left = max(widgetSize.width / 2, targetOffset.dx);
        top = widgetSize.height / 2;
        break;
      case FabAnchor.RIGHT_SECOND:
        left = screenWidth - widgetSize.width;
        top = max(widgetSize.height, targetOffset.dy);
        break;
      case FabAnchor.TOP_SECOND:
        left = min(screenWidth - widgetSize.width, targetOffset.dx);
        top = widgetSize.height / 2;
        break;
      case FabAnchor.LEFT_THIRD:
        left = widgetSize.width / 2;
        top = min(
            screenHeight - widgetSize.height - securityBottom, targetOffset.dy);
        break;
      case FabAnchor.BOTTOM_THIRD:
        left = widgetSize.width / 2;
        top = screenHeight - widgetSize.height - securityBottom;
        break;
      case FabAnchor.RIGHT_FOURTH:
        left = screenWidth - widgetSize.width;
        top = min(
            screenHeight - widgetSize.height - securityBottom, targetOffset.dy);
        break;
      case FabAnchor.BOTTOM_FOURTH:
        left = screenWidth - widgetSize.width;
        top = screenHeight - widgetSize.height - securityBottom;
        break;
    }
  }

  /// Computes the appropriate anchor screen edge for the widget
  FabAnchor getAnchor(Offset position) {
    //
    if (position.dx < screenWidthMid! && position.dy < screenHeightMid!) {
      return position.dx < position.dy
          ? FabAnchor.LEFT_FIRST
          : FabAnchor.TOP_FIRST;
    } else if (position.dx >= screenWidthMid! &&
        position.dy < screenHeightMid!) {
      return screenWidth - position.dx < position.dy
          ? FabAnchor.RIGHT_SECOND
          : FabAnchor.TOP_SECOND;
    } else if (position.dx < screenWidthMid! &&
        position.dy >= screenHeightMid!) {
      return position.dx < screenHeight - position.dy
          ? FabAnchor.LEFT_THIRD
          : FabAnchor.BOTTOM_THIRD;
    } else {
      return screenWidth - position.dx < screenHeight - position.dy
          ? FabAnchor.RIGHT_FOURTH
          : FabAnchor.BOTTOM_FOURTH;
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
enum FabAnchor {
  ///
  LEFT_FIRST,

  ///
  TOP_FIRST,

  ///
  RIGHT_SECOND,

  ///
  TOP_SECOND,

  ///
  LEFT_THIRD,

  ///
  BOTTOM_THIRD,

  ///
  RIGHT_FOURTH,

  ///
  BOTTOM_FOURTH
}
