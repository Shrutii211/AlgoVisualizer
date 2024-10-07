import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(LinearSearchVisualizer());
}

class LinearSearchVisualizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linear Search Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Linear Search Visualizer')),
        ),
        body: LinearSearchPage(),
      ),
    );
  }
}

class LinearSearchPage extends StatefulWidget {
  @override
  _LinearSearchPageState createState() => _LinearSearchPageState();
}

class _LinearSearchPageState extends State<LinearSearchPage> {
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
              labelText: 'Enter Array(comma seperated numbers )',
              hintText: 'Type here...',
              border: OutlineInputBorder(),
            ),
          ),

          SizedBox(height: 30,),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Enter Search Value (number)',
              hintText: 'Type here...',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(

              onPressed: () {
                startSearch(arrayController.text.split(',').map(int.parse).toList(), int.parse(searchController.text));
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

    int i;
    for (i = 0; i < _numbers.length; i++) {
      _comparisonIndex = i;
      if (_numbers[i] == _targetValue) {
        _searchStatus = 'Value found at index $i.';
        _isFound = true;
        break;
      }
      _searchStatus = 'Comparing ${_numbers[i]} with ${_targetValue}';
      _algorithmSteps.add(_searchStatus);
      setState(() {}); // Trigger UI update
      await Future.delayed(Duration(milliseconds: 1500));
    }

    if (i == _numbers.length) {
      _searchStatus = 'Value not found in the array.';
      _algorithmSteps.add(_searchStatus);
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
          _backgroundColor =
              Colors.pink; // Highlight the element being compared
        });
        _controller.forward(from: 0); // Start animation
      } else
      if (widget.isFound && widget.currentIndex == widget.comparisonIndex) {
        setState(() {
          _backgroundColor = Colors.green; // Highlight the found element
        });
      } else {
        setState(() {
          _backgroundColor =
              Colors.cyan; // Reset color when not comparing or found
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
      // Adjust padding as needed
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      transform: Matrix4.identity()
        ..scale(_scale),
      child: Center( // Center the text within the container
        child: Text(
          widget.number.toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      width: 50,
      // Set a fixed width for each box
      height: 50, // Set a fixed height for each box
    );
  }
}
