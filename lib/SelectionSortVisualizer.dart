import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Selection Sort',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SelectionSortVisualizer(),
    );
  }
}

class SelectionSortVisualizer extends StatefulWidget {
  @override
  _SelectionSortVisualizerState createState() => _SelectionSortVisualizerState();
}

class _SelectionSortVisualizerState extends State
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  List<int> numbers = [];
  List<Color> boxColors = [];
  late AnimationController _controller;
  late Animation<double> _animation;

  TextEditingController _controllerInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String status = ''; // Initialize status string

  void _sortNumbers() async {
    for (int i = 0; i < numbers.length - 1; i++) {
      int minIndex = i;
      for (int j = i + 1; j < numbers.length; j++) {
        setState(() {
          boxColors = List.filled(numbers.length, Colors.blue); // Reset colors
          boxColors[j] = Colors.orangeAccent; // Highlight current compared element
          boxColors[minIndex] = Colors.orangeAccent;
          status = 'Comparing elements $minIndex and $j...'; // Update status during comparison
        });

        await Future.delayed(Duration(milliseconds: 1600)); // Delay for visualization

        if (numbers[j] < numbers[minIndex]) {
          minIndex = j;
        }
      }

      if (minIndex != i) {
        setState(() {
          status = 'Swapping elements $i and $minIndex';
          boxColors[minIndex] = Colors.red; // Mark the element to be swapped
          boxColors[i] = Colors.red;
        });

        // Swap numbers
        await Future.delayed(Duration(milliseconds: 1600)); // Delay for visualization
        int temp = numbers[i];
        numbers[i] = numbers[minIndex];
        numbers[minIndex] = temp;

        setState(() {
          status = 'Elements swapped!';
        });

        await Future.delayed(Duration(milliseconds: 1600)); // Delay for visualization
      }

      // Mark the sorted elements as green
      setState(() {
        boxColors[i] = Colors.green;
      });
    }

    // Mark the last element as sorted
    setState(() {
      boxColors = List.filled(numbers.length, Colors.green);
      status = 'Elements are sorted!'; // Update status at the end
    });
  }

  void _addNumbers() {
    setState(() {
      numbers = _controllerInput.text
          .split(',')
          .map((str) => int.tryParse(str.trim()) ?? 0)
          .toList();
      boxColors = List.filled(numbers.length, Colors.blue); // Reset colors
      status = '';
      _controllerInput.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 35),
                child: Text(
                  'Selection Sort',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _controllerInput,
                decoration: InputDecoration(
                  labelText: 'Enter numbers separated by commas',
                ),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: _addNumbers,
                child: Text('Add Numbers'),
              ),
              SizedBox(height: 20),
              if (numbers.isNotEmpty) ...[
                Wrap(
                  children: List.generate(numbers.length, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 1000),
                      width: (boxColors[index] == Colors.orangeAccent || boxColors[index] == Colors.red) ? 55 : 50, // Enlarge width for comparing elements
                      height: (boxColors[index] == Colors.orangeAccent || boxColors[index] == Colors.red) ? 55 : 50, // Enlarge height for comparing elements
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: boxColors[index],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        numbers[index].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 20),
                if (status.isNotEmpty)
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                if (numbers.isNotEmpty) ...[
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _sortNumbers,
                        child: Text('Sort'),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 25),
                if (boxColors.every((color) => color == Colors.green))
                  Text(
                    'Sorted Numbers: ${numbers.join(", ")}',
                    style: TextStyle(fontSize: 18),
                  ),
              ],
            ],
          ),
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Text(
                  'Selection Sort Algorithm',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
              SizedBox(height: 25),
              SelectableText(
                '''
for (i = 0; i < n-1; i++) {
    min_idx = i;
    for (j = i+1; j < n; j++) {
        if (arr[j] < arr[min_idx])
            min_idx = j;
    }
    if(min_idx != i)
        swap(&arr[min_idx], &arr[i]);
}
                      ''',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq),
            label: 'Visualization',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.functions),
            label: 'Algorithm',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}