import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () {
    const draggableFab = DraggableFab(
      child: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.chat),
      ),
    );
    expect(true, draggableFab.child is FloatingActionButton);
  });
}
