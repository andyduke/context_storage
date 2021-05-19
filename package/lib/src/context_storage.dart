import 'package:context_storage/src/context_storage_scope.dart';
import 'package:flutter/widgets.dart';

/// A widget for creating a **storage** in the **widget tree**, accessible to child
/// widgets through the [InheritedWidget] mechanism.
///
/// Use case: in your application you have a bottom tab navigation with global sections,
/// and inside the bottom tabs there is a nested navigation with its own tabs.
/// If you want to store some data for nested tabs, but clear the storage when
/// switching global sections, then ContextStorage will help.
///
/// Example:
/// ```dart
/// // Wrap nested tabs in context storage:
/// @override
/// Widget build(BuildContext context) {
///   return ContextStorage(
///     child: DefaultTabController(
///       length: 2,
///       child: Scaffold(
///         appBar: AppBar(
///           title: Text('Home'),
///           bottom: TabBar(
///             tabs: [
///               // Tab definitions here...
///             ],
///           ),
///         ),
///         body: TabBarView(
///           children: [
///             // Tab bodies here...
///           ],
///         ),
///       ),
///     ),
///   );
/// }
///
/// // Now inside the tab body widgets you can read
/// // the value from the storage...
/// _value = context.storage?.get<int>('counter') ?? 0;
///
/// // ...and write the value to the storage.
/// context.storage?.set('counter', _value);
/// ```
class ContextStorage extends StatefulWidget {
  /// Name for the storage, optional.
  final String? name;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Creates a ContextStorage widget.
  const ContextStorage({
    Key? key,
    this.name,
    required this.child,
  }) : super(key: key);

  @override
  ContextStorageState createState() => ContextStorageState();

  /// Returns the closest [ContextStorageState] which encloses the given context.
  ///
  /// In the second parameter, you can pass the name of the storage, which must be found in the widget tree.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ContextStorage.of(context).get<int>('pageIndex');
  /// // or
  /// ContextStorage.of(context).set('pageIndex', _pageIndex);
  /// ```
  static ContextStorageState? of(BuildContext context, [String? name]) {
    if (name != null) {
      final InheritedElement? element = context
          .getElementForInheritedWidgetOfExactType<ContextStorageScope>();
      if (element != null) {
        final ContextStorageScope scope = element.widget as ContextStorageScope;
        final state = scope.state;
        if (state.name == name) return state;

        final parent = ContextStorage.of(state.context, name);
        return parent;
      } else {
        return null;
      }
    } else {
      final InheritedElement? element = context
          .getElementForInheritedWidgetOfExactType<ContextStorageScope>();
      if (element != null) {
        final ContextStorageScope scope = element.widget as ContextStorageScope;
        final state = scope.state;
        return state;
      }
    }
  }
}

/// State associated with a [ContextStorage] widget.
///
/// A [ContextStorageState] object can be used to [get], [set], [remove], and [clear] values
/// in the storage.
///
/// Typically obtained via [ContextStorage.of].
///
class ContextStorageState extends State<ContextStorage> {
  final Map<String, dynamic> _storage = {};

  /// Returns the name of the storage, if set
  String? get name => widget.name;

  /// Returns the value of the [key] from the storage if found, or [defaultValue] or `null` if not found
  T? get<T>(String key, [T? defaultValue]) {
    return _storage.containsKey(key) ? (_storage[key] as T) : defaultValue;
  }

  /// Puts the [key] [value] in the storage
  void set(String key, dynamic value) => _storage[key] = value;

  /// Removes a [key] value from the storage
  void remove(String key) => _storage.remove(key);

  /// Clears the storage
  void clear() => _storage.clear();

  @override
  Widget build(BuildContext context) {
    return ContextStorageScope(
      child: widget.child,
      state: this,
    );
  }
}
