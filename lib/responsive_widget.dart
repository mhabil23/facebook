import 'package:flutter/material.dart';

typedef WidgetBuilderCallback = Widget Function();

class ResponsiveWidget extends StatelessWidget {
  final WidgetBuilderCallback mobileBuilder;
  final WidgetBuilderCallback desktopBuilder;
  final double breakpoint;

  const ResponsiveWidget({
    super.key,
    required this.mobileBuilder,
    required this.desktopBuilder,
    this.breakpoint = 600,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return mobileBuilder();
        } else {
          return desktopBuilder();
        }
      },
    );
  }
}
