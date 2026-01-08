import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:happy_demo/screens/saved.dart';

import 'affirmation.dart';
import 'attribution.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  final _screens = const [
    AffirmationScreen(),
    SavedScreen(),
    AttributionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,

        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Affirmation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Attribution',
          ),
        ],
      ),
    );
  }
}