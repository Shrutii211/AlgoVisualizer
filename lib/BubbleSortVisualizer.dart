import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bubble Sort',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BubbleSortVisualizer(),
    );
  }
}

class BubbleSortVisualizer extends StatefulWidget {
  @override
  _BubbleSortVisualizerState createState() => _BubbleSortVisualizerState();
}

class _BubbleSortVisualizerState extends State<BubbleSortVisualizer>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  List<int> numbers = [];
  List<Color> boxColors = [];
  List<int> swapIndices = [];
  List<int> sortedNumbers = [];
  late AnimationController _controller;
  late Animation<double> _animation;

  TextEditingController _controllerInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
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
      bool swapped = false;
      for (int j = 0; j < numbers.length - i - 1; j++) {
        setState(() {
          boxColors = List.filled(numbers.length, Colors.blue); // Reset colors
          boxColors[j] = Colors.deepOrange; // Highlight current compared pair
          boxColors[j + 1] = Colors.deepOrange;
          status = 'Comparing elements...'; // Update status during comparison
        });

        await Future.delayed(Duration(milliseconds: 1000)); // Delay for visualization

        if (numbers[j] > numbers[j + 1]) {
          setState(() {
            swapIndices = [j, j + 1]; // Mark indices to be swapped
            status = 'Elements swapped!';
          });

          // Swap numbers
          int temp = numbers[j];
          numbers[j] = numbers[j + 1];
          numbers[j + 1] = temp;

          // Animate the swap
          await _controller.forward();
          setState(() {
            swapIndices = [];
          });
          await _controller.reverse();

          swapped = true;
        }
      }
      // mark the sorted elements as green
      setState(() {
        for (int k = 0; k < numbers.length - i - 1; k++) {
          boxColors[k] = Colors.green;
        }
      });

      // If no swaps were made in this pass, the list is already sorted
      if (!swapped) break;

      // Update UI to show iteration number and swapping details
      setState(() {
        numbers = List.from(numbers); // Trigger rebuild
      });
    }

    // All elements are sorted, mark them green
    setState(() {
      sortedNumbers = List.from(numbers); // Copy the sorted numbers to the sortedNumbers list
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
                  'Bubble Sort',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _controllerInput,
                decoration: InputDecoration(
                  labelText: 'Enter comma-separated values',
                  hintText: 'Type here',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: _addNumbers,
                child: Text('Add Numbers'),

                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.cyan,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              if (numbers.isNotEmpty) ...[
                SizedBox(height: 25),
                Wrap(
                  children: List.generate(numbers.length, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 1500),
                      width: (boxColors[index] == Colors.deepOrange) ? 55 : 50, // Enlarge width for comparing elements
                      height: (boxColors[index] == Colors.deepOrange) ? 55 : 50, // Enlarge height for comparing elements
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
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _sortNumbers,
                  child: Text('Sort'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.cyan,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (numbers.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  if (boxColors.every((color) => color == Colors.green))
                    Text(
                      'Sorted Numbers: ${numbers.join(", ")}',
                      style: TextStyle(fontSize: 18),
                    ),
                ],
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
                  'Bubble Sort Algorithm',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ),
              ),
              SizedBox(height: 25),
              SelectableText(
                '''
void bubbleSort(List<int> arr) {
  int n = arr.length;
  for (int i = 0; i < n - 1; i++) {
    for (int j = 0; j < n - i - 1; j++) {
      if (arr[j] > arr[j + 1]) {
        int temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
      }
    }
  }
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
