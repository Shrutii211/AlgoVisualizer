import 'package:algovisualizer/BinarySearchTree.dart';
import 'package:algovisualizer/BubbleSortVisualizer.dart';
import 'package:algovisualizer/Preorder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Inorder.dart';
import 'Postorder.dart';
void _preorderTraversal(TreeNode? node, List<int> values) {
  if (node == null) return;
  values.add(node.value);
  _preorderTraversal(node.left, values);
  _preorderTraversal(node.right, values);
}

void _inorderTraversal(TreeNode2? node, List<int> values) {
  if (node == null) return;
  _inorderTraversal(node.left, values);
  values.add(node.value);
  _inorderTraversal(node.right, values);
}


void _postorderTraversal(TreeNode3? node, List<int> values) {
  if (node == null) return;
  _postorderTraversal(node.left, values);
  _postorderTraversal(node.right, values);
  values.add(node.value);
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const TreeOptions(),
    );
  }
}

class TreeOptions extends StatefulWidget {
  const TreeOptions({Key? key});

  @override
  State<TreeOptions> createState() => _TreeOptionsState();
}

class _TreeOptionsState extends State<TreeOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(90),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text(
                    'Algorithm Visualizer',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Visualize, Understand, Excel',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.only(top: 100),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      itemDashboard(
                        'Binary Search Tree Construction',
                        CupertinoIcons.sort_down_circle,
                        Colors.deepOrange,
                            () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BinarySearchTree(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 80), // Increased spacing between rows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      itemDashboard(
                        'Pre-order Traversal',
                        CupertinoIcons.sort_down_circle,
                        Colors.green,
                            () {
                              TreeNode root = TreeNode(1, left: TreeNode(2), right: TreeNode(3));
                              root.left!.left = TreeNode(4);
                              root.left!.right = TreeNode(5);
                              List<int> preorderValues = [];
                              _preorderTraversal(root, preorderValues);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Preorder(root: root, preorderValues: preorderValues),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 80), // Increased spacing between rows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      itemDashboard(
                        'Inorder Traversal',
                        CupertinoIcons.sort_down_circle,
                        Colors.red,
                            () {
                              TreeNode2 root = TreeNode2(1, left: TreeNode2(2), right: TreeNode2(3));
                              root.left!.left = TreeNode2(4);
                              root.left!.right = TreeNode2(5);

                              List<int> inorderValues = [];
                              _inorderTraversal(root, inorderValues);

                              Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Inorder(root: root, inorderValues: inorderValues),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 80), // Increased spacing between rows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      itemDashboard(
                        'Post order',
                        CupertinoIcons.sort_down_circle,
                        Colors.lightGreen,
                            () {

                              TreeNode3 root = TreeNode3(1, left: TreeNode3(2), right: TreeNode3(3));
                              root.left!.left = TreeNode3(4);
                              root.left!.right = TreeNode3(5);

                              List<int> postorderValues = [];
                              _postorderTraversal(root, postorderValues);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Postorder(root: root, postorderValues: postorderValues),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemDashboard(
      String title,
      IconData iconData,
      Color background,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 350,
          maxWidth: 400,
          minHeight: 100, // Increased minimum height of each item
          maxHeight: 190, // Increased maximum height of each item
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 10),
                blurRadius: 5,
                blurStyle: BlurStyle.normal,
                spreadRadius: 2,
                color: Theme.of(context).hoverColor.withOpacity(.2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
