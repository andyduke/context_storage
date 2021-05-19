import 'package:context_storage/src/context_storage.dart';
import 'package:flutter/widgets.dart';

class ContextStorageScope extends InheritedWidget {
  final ContextStorageState state;

  ContextStorageScope({
    Key? key,
    required Widget child,
    required this.state,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(covariant ContextStorageScope oldWidget) => oldWidget.state != state;
}
