import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () {
    final draggableFab = DraggableFab(
      child: FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: null,
      ),
    );
    expect(true, draggableFab.child is FloatingActionButton);
  });
}
