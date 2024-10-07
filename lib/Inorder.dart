import 'dart:async';
import 'package:flutter/material.dart';

class TreeNode2 {
  int value;
  TreeNode2? left;
  TreeNode2? right;

  TreeNode2(this.value, {this.left, this.right});
}

class Inorder extends StatefulWidget {
  final TreeNode2 root;
  final List<int> inorderValues;

  Inorder({required this.root, required this.inorderValues});

  @override
  _BinaryTreeViewState createState() => _BinaryTreeViewState();
}

class _BinaryTreeViewState extends State<Inorder> {
  late List<int> _currentTraversal;
  late int _currentIndex;
  late Timer _timer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentTraversal = [];
    _currentIndex = 0;
  }

  void _startTraversal() {
    _currentTraversal.clear(); // Clear previous traversal
    _currentIndex = 0;
    _timer = Timer.periodic(Duration(milliseconds: 1500), (timer) {
      setState(() {
        if (_currentIndex < widget.inorderValues.length) {
          _currentTraversal.add(widget.inorderValues[_currentIndex]);
          _currentIndex++;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Binary Tree Visualization (In-order)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: CustomPaint(
                  size: Size(300, _calculateHeight(widget.root)),
                  painter: BinaryTreePainter(
                    root: widget.root,
                    traversalValues: _currentTraversal,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'In-order Traversal: ${_currentTraversal.join(", ")}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 20),
            Center(
              child: Text(
                'Algorithm: Inorder Traversal\n'
                    '1. Visit the left subtree.\n'
                    '2. Visit the current node.\n'
                    '3. Visit the right subtree.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _startTraversal,

              child: Text('Start Traversal'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.cyan,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateHeight(TreeNode2 node) {
    int height = _getHeight(node);
    return 60 * height.toDouble(); // Adjust height based on depth of the tree
  }

  int _getHeight(TreeNode2? node) {
    if (node == null) return 0;
    int leftHeight = _getHeight(node.left);
    int rightHeight = _getHeight(node.right);
    return 1 + (leftHeight > rightHeight ? leftHeight : rightHeight);
  }
}

class BinaryTreePainter extends CustomPainter {
  final TreeNode2 root;
  final List<int> traversalValues;

  BinaryTreePainter({required this.root, required this.traversalValues});

  @override
  void paint(Canvas canvas, Size size) {
    _drawNode(canvas, root, size.width / 2, 50, size.width / 4);
  }

  void _drawNode(Canvas canvas, TreeNode2 node, double x, double y, double dx) {
    if (node == null) return;

    Paint paint = Paint()
      ..color = Colors.cyan
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    if (traversalValues.contains(node.value)) {
      paint.color = Colors.green; // Highlight visited nodes
    }

    // Draw the node
    canvas.drawCircle(Offset(x, y), 20, paint);
    TextSpan span = TextSpan(
      style: TextStyle(color: Colors.white),
      text: node.value.toString(),
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));

    // Draw left child
    if (node.left != null) {
      canvas.drawLine(Offset(x, y + 20), Offset(x - dx, y + 100), paint);
      _drawNode(canvas, node.left!, x - dx, y + 100, dx / 2);
    }

    // Draw right child
    if (node.right != null) {
      canvas.drawLine(Offset(x, y + 20), Offset(x + dx, y + 100), paint);
      _drawNode(canvas, node.right!, x + dx, y + 100, dx / 2);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

void main() {
  TreeNode2 root = TreeNode2(1, left: TreeNode2(2), right: TreeNode2(3));
  root.left!.left = TreeNode2(4);
  root.left!.right = TreeNode2(5);

  List<int> inorderValues = [];
  _inorderTraversal(root, inorderValues);

  runApp(MaterialApp(
    home: Inorder(root: root, inorderValues: inorderValues),
  ));
}

void _inorderTraversal(TreeNode2? node, List<int> values) {
  if (node == null) return;
  _inorderTraversal(node.left, values);
  values.add(node.value);
  _inorderTraversal(node.right, values);
}
