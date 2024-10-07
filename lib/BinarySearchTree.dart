import 'dart:async';
import 'package:flutter/material.dart';

class TreeNode1 {
  int value;
  TreeNode1? left;
  TreeNode1? right;
  String? logic;

  TreeNode1(this.value);
}

class BinarySearchTree extends StatefulWidget {
  @override
  _BinarySearchTreeState createState() => _BinarySearchTreeState();
}

class _BinarySearchTreeState extends State<BinarySearchTree> {
  List<_Step> steps = [];
  TextEditingController controller = TextEditingController();
  Timer? timer;
  int currentIndex = 0;
  TreeNode1? root; // Store the root node of the tree

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildStepsList() {
      return Expanded(
        child: ListView.builder(
          itemCount: steps.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(steps[index].logic),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Binary Search Tree Construction'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter comma-separated values',
                hintText: 'Enter first node as root node',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              List<int> values = controller.text.split(',').map((e) => int.tryParse(e) ?? 0).toList();
              _constructTree(values);
            },
            child: Text('Construct Tree'),
                  style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.cyan,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  ),
                  ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (steps.isNotEmpty && currentIndex < steps.length)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Step ${currentIndex + 1}: ${steps[currentIndex].logic}',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                SizedBox(height: 20),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CustomPaint(
                      size: Size(300, 300),
                      painter: BinarySearchTreePainter(
                        steps.isNotEmpty && currentIndex < steps.length
                            ? steps[currentIndex].root ?? TreeNode1(0)
                            : null, // Pass null if root is null
                      ),
                    ),
                  ),
                ),
                //Text("All the steps to construct tree", style: TextStyle(fontSize: 20)),
                //_buildStepsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _constructTree(List<int> values) {
    steps.clear();
    List<String> insertionSteps = [];
    root = null; // Reset root node

    for (int value in values) {
      root = _insert(root, value, insertionSteps);
      steps.add(_Step(_copyTree(root), insertionSteps.join('\n')));
      insertionSteps.clear(); // Clear steps for the next iteration
    }

    // Start displaying steps immediately
    _startTimer();

    setState(() {});
  }

  TreeNode1? _insert(TreeNode1? node, int value, List<String> steps) {
    if (node == null) {
      steps.add('Inserted $value as a new node');
      return TreeNode1(value); // Create a new node if the current node is null
    }
    var node_val = node.value;
    // If the value is less than the current node's value, move to the left child
    if (value < node.value) {
      steps.add('$value is less than $node_val: Moving to the left child of ${node.value}');
      node.left = _insert(node.left, value, steps);
    }
    // If the value is greater than the current node's value, move to the right child
    else if (value > node.value) {
      steps.add('$value is greater than $node_val: Moving to the right child of ${node.value}');
      node.right = _insert(node.right, value, steps);
    }
    // If the value already exists, do nothing (or handle as needed)
    else {
      steps.add('$value already exists in the tree');
      // Do nothing for duplicates
    }

    return node;
  }

  TreeNode1? _copyTree(TreeNode1? node) {
    if (node == null) {
      return null;
    }

    TreeNode1 copyNode = TreeNode1(node.value);
    copyNode.left = _copyTree(node.left);
    copyNode.right = _copyTree(node.right);
    return copyNode;
  }

  void _startTimer() {
    currentIndex = 0;
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        currentIndex++;
        if (currentIndex >= steps.length-1) {
          timer.cancel();
        }
      });
    });
  }
}

class BinarySearchTreePainter extends CustomPainter {
  final TreeNode1? root; // Root can be null
  final Paint nodePaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  BinarySearchTreePainter(this.root)
      : nodePaint = Paint()..color = Colors.blue,
        textPainter = TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        textStyle = TextStyle(color: Colors.white);

  @override
  void paint(Canvas canvas, Size size) {
    if (root == null) {
      // Draw a placeholder or empty state
      _drawEmptyTree(canvas, size);
    } else {
      _drawNode(canvas, root!, size.width / 2, 50, size.width / 4);
    }
  }

  void _drawNode(Canvas canvas, TreeNode1 node, double x, double y, double dx) {
    // Draw the node
    canvas.drawCircle(Offset(x, y), 20, nodePaint);
    textPainter.text = TextSpan(
      text: node.value.toString(),
      style: textStyle,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));

    // Draw left child
    if (node.left != null) {
      canvas.drawLine(Offset(x, y + 20), Offset(x - dx, y + 100), nodePaint);
      _drawNode(canvas, node.left!, x - dx, y + 100, dx / 2);
    }

    // Draw right child
    if (node.right != null) {
      canvas.drawLine(Offset(x, y + 20), Offset(x + dx, y + 100), nodePaint);
      _drawNode(canvas, node.right!, x + dx, y + 100, dx / 2);
    }
  }

  void _drawEmptyTree(Canvas canvas, Size size) {
    // Draw a placeholder tree (e.g., an empty state)
    // For simplicity, let's draw a single node indicating an empty state
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 20, nodePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _Step {
  final TreeNode1? root;
  final String logic;

  _Step(this.root, this.logic);
}

void main() {
  runApp(MaterialApp(
    home: BinarySearchTree(),
  ));
}