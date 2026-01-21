import 'package:flutter/material.dart';
import '../utils/responsive_layout.dart';

class ResponsiveBody extends StatelessWidget {
  final Widget child;
  final bool includeScroll;
  final EdgeInsets? padding;

  const ResponsiveBody({
    super.key,
    required this.child,
    this.includeScroll = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveLayout.maxContentWidth(context);
    final contentPadding =
        padding ?? ResponsiveLayout.screenPadding(context);

    Widget constrainedChild = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );

    Widget content = Padding(
      padding: contentPadding,
      child: constrainedChild,
    );

    if (includeScroll) {
      content = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: content,
      );
    }

    return SafeArea(child: content);
  }
}

