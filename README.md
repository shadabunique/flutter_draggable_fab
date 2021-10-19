# draggable_fab

A Draggable FAB wrapper widget which can dragged to any edge of the screen.

## Installation

Add `draggable_fab: ^0.1.4` in your `pubspec.yaml` dependencies. And import it:

```dart
import 'package:draggable_fab/draggable_fab.dart';
```

## How to use
Create a standalone widget e.g. Floating Action Bar widget :

```dart
DraggableFab(
        child: FloatingActionButton(
          onPressed: _incrementCounter,
          child: Icon(Icons.add),
        ),
      );
```

![demo.gif](https://github.com/shadabunique/flutter_draggable_fab/blob/master/example/screenshots/demo.gif)