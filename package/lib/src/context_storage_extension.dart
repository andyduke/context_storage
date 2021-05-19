import 'package:context_storage/context_storage.dart';
import 'package:flutter/widgets.dart';

extension ContextStorageExtension on BuildContext {
  /// Returns the closest storage
  ContextStorageState? get storage => ContextStorage.of(this);

  /// Returns the closest storage by name
  ContextStorageState? storageOf(String name) => ContextStorage.of(this, name);
}
