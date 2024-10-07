import 'dart:collection'; // Import the dart:collection library for Queue

import 'package:flutter/material.dart';

class TreeNode {
  final String value;
  final List<TreeNode> children;

  TreeNode(this.value, [this.children = const []]);
}

class TreeTraversalBFS extends StatefulWidget {
  @override
  _TreeTraversalAnimationState createState() => _TreeTraversalAnimationState();
}

class _TreeTraversalAnimationState extends State<TreeTraversalBFS>
    with SingleTickerProviderStateMixin {
  List<String> traversalPath = [];
  late AnimationController _controller;
  late Animation<double> _animation;

  // Simulated tree structure
  final TreeNode tree = TreeNode(
    'A',
    [
      TreeNode('B', [
        TreeNode('D'),
        TreeNode('E'),
      ]),
      TreeNode('C', [
        TreeNode('F'),
        TreeNode('G'),
      ]),
    ],
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Adjust animation duration as needed
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void bfs(TreeNode root, VoidCallback onDone) async {
    final Queue<TreeNode> queue = Queue();
    queue.add(root);

    while (queue.isNotEmpty) {
      final node = queue.removeFirst();
      setState(() {
        traversalPath.add(node.value);
      });

      _controller.forward(); // Start animation for current node
      await Future.delayed(Duration(milliseconds: 600)); // Wait for animation

      for (final child in node.children) {
        queue.add(child);
      }
      _controller.reverse(); // Reverse animation after processing children
    }

    await Future.delayed(Duration(milliseconds: 600 * traversalPath.length)); // Wait for final animation
    onDone();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BFS Traversal'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: TreePainter(traversalPath, _animation.value, tree),
                    size: Size(300, 300),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 150),
            child: Text(
              'Traversal Path: ${traversalPath.join(" -> ")}',
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            traversalPath = [];
          });
          bfs(tree, () {});
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}

class TreePainter extends CustomPainter {
  final List<String> traversalPath;
  final double animationValue;
  final TreeNode tree;
  final double nodeRadius = 20.0;
  final double edgeThickness = 2.0;

  TreePainter(this.traversalPath, this.animationValue, this.tree);

  @override
  void paint(Canvas canvas, Size size) {
    final double startX = size.width / 2;
    final double startY = 50;
    final double levelHeight = 100;
    final double horizontalSpacing = 100;

    // Draw edges and nodes
    _drawEdgesAndNodes(canvas, startX, startY, levelHeight, horizontalSpacing, tree);
  }

  void _drawEdgesAndNodes(Canvas canvas, double x, double y, double levelHeight, double horizontalSpacing, TreeNode node) {
    if (node.children.isNotEmpty) {
      final double startY = y + levelHeight;
      final double startXLeft = x - horizontalSpacing / 2;
      final double startXRight = x + horizontalSpacing / 2;

      // Draw edges
      _drawEdge(canvas, x, y , startXLeft, startY - nodeRadius);
      _drawEdge(canvas, x, y , startXRight, startY - nodeRadius);

      // Draw nodes
      _drawNode(canvas, x, y, node.value);
      _drawEdgesAndNodes(canvas, startXLeft, startY, levelHeight, horizontalSpacing / 2, node.children[0]);
      _drawEdgesAndNodes(canvas, startXRight, startY, levelHeight, horizontalSpacing / 2, node.children[1]);
    } else {
      // Draw leaf node
      _drawNode(canvas, x, y, node.value);
    }
  }

  void _drawNode(Canvas canvas, double x, double y, String value) {
    final Paint paint = Paint()
      ..color = traversalPath.contains(value) ? Colors.green : Colors.blue;

    final double nodeX = x ;
    final double nodeY = y - nodeRadius;

    canvas.drawCircle(Offset(nodeX, nodeY), nodeRadius, paint);

    final TextSpan span = TextSpan(
      text: value,
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
    final TextPainter textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(nodeX - nodeRadius / 2, nodeY - nodeRadius / 2));
  }

  void _drawEdge(Canvas canvas, double startX, double startY, double endX, double endY) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = edgeThickness;

    canvas.drawLine(
      Offset(startX, startY),
      Offset(endX, endY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

void main() {
  runApp(MaterialApp(
    home: TreeTraversalBFS(),
  ));
}