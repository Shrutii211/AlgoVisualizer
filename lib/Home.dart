import 'package:algovisualizer/GraphOptions.dart';
import 'package:algovisualizer/SortOptions.dart';
import 'package:algovisualizer/TreeOptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'SearchOptions.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {

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
                  title: Text('Algorithm Visualizer', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white
                  )),
                  subtitle: Text('Visualize,Understand,Excel', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white54
                  )),

                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100)
                  )
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 70,
                children: [
                  itemDashboard('Searching', CupertinoIcons.search, Colors.deepOrange,(){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchOptions()));
                  }),
                  itemDashboard('Sorting', CupertinoIcons.sort_down_circle, Colors.green,(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SortOptions()));
                  }),
                  itemDashboard('Graph', CupertinoIcons.graph_square, Colors.purple,(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GraphOptions()));
                  }),
                  itemDashboard('Tree', CupertinoIcons.tree, Colors.brown,(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TreeOptions()));
                  }),
                  itemDashboard('String', CupertinoIcons.book_circle, Colors.indigo,(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                  }),
                  itemDashboard('Greedy', CupertinoIcons.star_circle, Colors.teal,(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }),

                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  itemDashboard(String title, IconData iconData, Color background ,VoidCallback onTap) => GestureDetector(
  onTap: onTap,
  child:Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5
          )
        ]
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
            child: Icon(iconData, color: Colors.white)
        ),
        const SizedBox(height: 8),
        Text(title.toUpperCase(), style: Theme.of(context).textTheme.titleMedium)
      ],
    ),
  ),
  );
}