import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(BinarySearchVisualizer());
}

class BinarySearchVisualizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binary Search Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Binary Search Visualizer')),
        ),
        body: BinarySearchPage(),
      ),
    );
  }
}

class BinarySearchPage extends StatefulWidget {
  @override
  _BinarySearchPageState createState() => _BinarySearchPageState();
}

class _BinarySearchPageState extends State<BinarySearchPage> {
  TextEditingController arrayController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  late List<int> _numbers = [];
  late int _targetValue;
  late bool _isSearching = false;
  late int _comparisonIndex = -1;
  late String _searchStatus = '';
  late bool _isFound = false;
  late List<String> _algorithmSteps = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: arrayController,
            decoration: InputDecoration(
              labelText: 'Enter Array(comma seperated numbers) ',
              hintText: 'Type here...',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 30,),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Enter search values',
              hintText: 'Type here...',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                startSearch(
                    arrayController.text.split(',').map(int.parse).toList(),
                    int.parse(searchController.text));
              },
              child: Text('Search'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.cyan,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            _searchStatus,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      _numbers.length,
                          (index) => AnimatedSearchWidget(
                        number: _numbers[index],
                        isSearching: _isSearching,
                        targetValue: _targetValue,
                        comparisonIndex: _comparisonIndex,
                        currentIndex: index,
                        isFound: _isFound,
                        animationDuration: Duration(milliseconds: 500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startSearch(List<int> numbers, int searchValue) async {
    _numbers = numbers;
    _targetValue = searchValue;
    _isSearching = true;
    _isFound = false;
    _comparisonIndex = -1;
    _searchStatus = 'Searching...';
    _algorithmSteps.clear();

    int low = 0;
    int high = _numbers.length - 1;

    while (low <= high) {
      int mid = (low + high) ~/ 2;
      _comparisonIndex = mid;
      if (_numbers[mid] == _targetValue) {
        _searchStatus = 'Value found at index $mid.';
        _isFound = true;
        break;
      } else if (_numbers[mid] < _targetValue) {
        _searchStatus = 'Comparing with element at index $mid (mid), searching in the right half...';
        low = mid + 1;
      } else {
        _searchStatus = 'Comparing with element at index $mid (mid), searching in the left half...';
        high = mid - 1;
      }
      setState(() {}); // Trigger UI update
      await Future.delayed(Duration(milliseconds: 2000));
    }

    if (!_isFound) {
      _searchStatus = 'Value not found in the array.';
    }

    _isSearching = false;
    setState(() {}); // Trigger UI update
  }
}

class AnimatedSearchWidget extends StatefulWidget {
  final int number;
  final bool isSearching;
  final int targetValue;
  final int comparisonIndex;
  final int currentIndex;
  final bool isFound;
  final Duration animationDuration;

  AnimatedSearchWidget({
    required this.number,
    required this.isSearching,
    required this.targetValue,
    required this.comparisonIndex,
    required this.currentIndex,
    required this.isFound,
    required this.animationDuration,
  });

  @override
  _AnimatedSearchWidgetState createState() => _AnimatedSearchWidgetState();
}

class _AnimatedSearchWidgetState extends State<AnimatedSearchWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _scale;
  late Color _backgroundColor;
  late String _stepText;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _scale = 1.0;
    _backgroundColor = Colors.blue; // Initialize with default color
    _stepText = ''; // Initialize with an empty string
    _controller.addListener(() {
      setState(() {
        _scale = 1.0 + _animation.value * 0.2; // Increase size gradually
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedSearchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.comparisonIndex != widget.comparisonIndex ||
        oldWidget.isSearching != widget.isSearching) {
      if (widget.isSearching && widget.currentIndex == widget.comparisonIndex) {
        setState(() {
          _backgroundColor = Colors.pink; // Highlight the element being compared
          _stepText = 'Comparing with element at index ${widget.comparisonIndex}, searching...';
        });
        _controller.forward(from: 0); // Start animation
      } else if (widget.isFound && widget.currentIndex == widget.comparisonIndex) {
        setState(() {
          _backgroundColor = Colors.green; // Highlight the found element
          _stepText = 'Value found at index ${widget.comparisonIndex}.';
        });
      } else {
        setState(() {
          _backgroundColor = Colors.cyan; // Reset color when not comparing or found
          _stepText = ''; // Clear the step text
        });
        _controller.reset(); // Reset animation
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.animationDuration,
      curve: Curves.easeInOut,
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      transform: Matrix4.identity()..scale(_scale),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.number.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            if (_stepText.isNotEmpty) // Display step text if not empty
              Text(
                _stepText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
      width: 50,
      height: 70, // Increased height to accommodate step text
    );
  }
}
