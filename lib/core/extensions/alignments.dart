import 'package:flutter/material.dart';

/// An extension on [Widget] that provides convenient alignment helpers.
///
/// This allows you to easily align any widget without wrapping it
/// manually in an [Align] widget each time.
///
/// Example:
/// ```dart
/// Text('Hello').center();
/// Container(height: 50, width: 50, color: Colors.red).bottomRight();
/// ```
extension AlignWidget on Widget {
  /// Aligns the widget to the **center-left** of its parent.
  ///
  /// Equivalent to:
  /// ```dart
  /// Align(alignment: Alignment.centerLeft, child: widget)
  /// ```
  Align left() {
    return Align(alignment: Alignment.centerLeft, child: this);
  }

  /// Aligns the widget to the **center-right** of its parent.
  ///
  /// Equivalent to:
  /// ```dart
  /// Align(alignment: Alignment.centerRight, child: widget)
  /// ```
  Align right() {
    return Align(alignment: Alignment.centerRight, child: this);
  }

  /// Aligns the widget to the **bottom-center** of its parent.
  ///
  /// Equivalent to:
  /// ```dart
  /// Align(alignment: Alignment.bottomCenter, child: widget)
  /// ```
  Align bottom() {
    return Align(alignment: Alignment.bottomCenter, child: this);
  }

  /// Aligns the widget to the **top-center** of its parent.
  ///
  /// Equivalent to:
  /// ```dart
  /// Align(alignment: Alignment.topCenter, child: widget)
  /// ```
  Align top() {
    return Align(alignment: Alignment.topCenter, child: this);
  }

  /// Aligns the widget to the **center** of its parent.
  ///
  /// Equivalent to:
  /// ```dart
  /// Align(alignment: Alignment.center, child: widget)
  /// ```
  Align center() {
    return Align(alignment: Alignment.center, child: this);
  }

  /// Aligns the widget to the **top-right** corner of its parent.
  ///
  /// Equivalent to:
  /// ```dart
  /// Align(alignment: Alignment.topRight, child: widget)
  /// ```
  Align topRight() {
    return Align(alignment: Alignment.topRight, child: this);
  }

  /// Aligns the widget to the **top-left** corner of its parent.
  ///
  /// Equivalent to:
  /// ```dart
  /// Align(alignment: Alignment.topLeft, child: widget)
  /// ```
  Align topLeft() {
    return Align(alignment: Alignment.topLeft, child: this);
  }

  /// Aligns the widget to the **bottom-right** corner of its parent.
  ///
  /// Equivalent to:
  /// ```dart
  /// Align(alignment: Alignment.bottomRight, child: widget)
  /// ```
  Align bottomRight() {
    return Align(alignment: Alignment.bottomRight, child: this);
  }

  /// Aligns the widget to the **bottom-left** corner of its parent.
  ///
  /// Equivalent to:
  /// ```dart
  /// Align(alignment: Alignment.bottomLeft, child: widget)
  /// ```
  Align bottomLeft() {
    return Align(alignment: Alignment.bottomLeft, child: this);
  }
}
