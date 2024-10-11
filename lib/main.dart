import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

void main() {
  runApp(MaterialApp(
      home: Scaffold(
          body: HorizontalZoomListener(
              zoomValue: 0.5,
              onSetZoomValue: (double zoomValue) {},
              child: const TableExample()))));
}

class HorizontalZoomListener extends StatefulWidget {
  final double zoomValue;
  final void Function(double zoomValue) onSetZoomValue;
  final Widget child;

  const HorizontalZoomListener({
    super.key,
    required this.zoomValue,
    required this.onSetZoomValue,
    required this.child,
  });

  @override
  State<HorizontalZoomListener> createState() => _HorizontalZoomListenerState();
}

class _HorizontalZoomListenerState extends State<HorizontalZoomListener> {
  final touchPoints = <int>{};
  late double originalZoomValue;
  bool isZooming = false;

  @override
  Widget build(BuildContext context) => Listener(
      onPointerDown: (event) {
        originalZoomValue = widget.zoomValue;
        touchPoints.add(event.pointer);
        setState(() => isZooming = touchPoints.length > 1);
      },
      onPointerUp: (event) {
        touchPoints.remove(event.pointer);
        setState(() => isZooming = touchPoints.length > 1);
      },
      child: GestureDetector(
        onScaleUpdate: (details) {
          if (isZooming) {
            widget.onSetZoomValue(originalZoomValue / details.horizontalScale);
          }
        },
        child: AbsorbPointer(
            key: Key("HorizontalZoomListener_$isZooming"),
            absorbing: isZooming,
            child: widget.child),
      ),
    );
}

class TableExample extends StatefulWidget {
  /// Creates a screen that demonstrates the TableView widget.
  const TableExample({super.key});

  @override
  State<TableExample> createState() => _TableExampleState();
}

class _TableExampleState extends State<TableExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: TableView.builder(
          diagonalDragBehavior: DiagonalDragBehavior.free,
          cellBuilder: _buildCell,
          columnCount: 20,
          columnBuilder: _buildColumnSpan,
          rowCount: 20,
          rowBuilder: _buildRowSpan,
        ),
      ),
    );
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity vicinity) => TableViewCell(
      child: Center(
        child: Text('Tile c: ${vicinity.column}, r: ${vicinity.row}'),
      ),
    );

  TableSpan _buildColumnSpan(int index) => const TableSpan(
      extent: FixedTableSpanExtent(200),
    );

  TableSpan _buildRowSpan(int index) => const TableSpan(
      extent: FixedTableSpanExtent(200),
    );
}
