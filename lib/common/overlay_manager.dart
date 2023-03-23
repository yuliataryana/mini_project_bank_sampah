import 'package:flutter/material.dart';

class OverlayManager {
  // Singleton
  OverlayManager._internal();
  static final _singleton = OverlayManager._internal();
  factory OverlayManager() => _singleton;

  OverlayEntry? _overlayEntry;

  void showOverlay(BuildContext context, Widget widget) {
    _overlayEntry = OverlayEntry(builder: (context) => widget);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void hideOverlay() {
    try {
      _overlayEntry?.remove();
    } catch (e) {}
  }
}
