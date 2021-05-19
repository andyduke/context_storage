# ContextStorage

A widget for creating a key-value **storage** in the **widget tree**, accessible to child widgets through the `InheritedWidget` mechanism.

## Usage

Use case: in your application you have a bottom tab navigation with global sections, and inside the bottom tabs there is a nested navigation with its own tabs.

If you want to store some data for nested tabs, but clear the storage when switching global sections, then ContextStorage will help.

Wrap nested tabs in context storage:
```dart
@override
Widget build(BuildContext context) {
  return ContextStorage(
    child: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          bottom: TabBar(
            tabs: [
              // Tab definitions here...
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab bodies here...
          ],
        ),
      ),
    ),
  );
}
```

Now inside the tab body widgets you can read the value from the storage...
```dart
_value = context.storage?.get<int>('counter') ?? 0;
```

...and write the value to the storage.
```dart
context.storage?.set('counter', _value);
```

## Access & Name

To access the storage, you can use the `ContextStorage.of(context)`, or import an extension `import 'package:context_storage/extension.dart';` and shorten this to: `context.storage`.

Stores can be nested within each other at different levels of the widget tree. When accessing the storage through the context, the nearest storage will be found.

The storage can be named, then it is possible to refer to the nearest storage with this name, even if there is another storage closer, but with a different name.

The storage name is specified in the constructor:
```dart
ContextStorage(
  name: 'tab-cache',
  child: TabbedWidget(),
)
```

To access the named storage, you must specify the second parameter in the `of()` method:
```dart
ContextStorage.of(context, 'tab-cache)
```
...or use the `storageOf()` method in the `BuildContext` extension:
```dart
context.storageOf('tab-cache')
```

## Storage API

### Get value

To get a value from storage, use the `get()` method; to cast a value to the required type, you can pass this type to `get()`:
```dart
context.storage?.get<int>('tab-index');
```
You can also specify a default value in the second parameter:
```dart
context.storage?.get<int>('tab-index', 3);
```

### Set/Update value

To save or update a value in the storage, use the `set()` method:
```dart
context.storage?.set('tab-index', tabIndex);
```

### Remove value

To remove a value from storage, use the `remove()` method:
```dart
context.storage?.remove('tab-index');
```

### Clearing the entire storage

To remove all values from storage, use the `clear()` method:
```dart
context.storage?.clear();
```
