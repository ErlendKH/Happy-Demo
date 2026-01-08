import 'package:flutter/material.dart';

class AttributionScreen extends StatefulWidget {
  const AttributionScreen({super.key});

  @override
  State<AttributionScreen> createState() => _AttributionScreenState();
}

class _AttributionScreenState extends State<AttributionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attribution")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [

            Text(
              "Created by",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Erlend Kyrkjerud Hårtveit"),

            SizedBox(height: 24),

            Text(
              "Affirmations",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Provided by affirmations.dev"),

            SizedBox(height: 24),

            Text(
              "Animations",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Lottie animations by respective creators."),

          ],
        ),
      ),
    );
  }
}