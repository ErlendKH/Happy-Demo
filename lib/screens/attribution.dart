import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
          children: [

            const SizedBox(height: 24),

            Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 0,
                ),
              child: Lottie.asset(
                'assets/lottie/sunrise.json',
                // width: 200,
                // height: 200,
                repeat: true,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Created by",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Erlend Kyrkjerud Hårtveit"),

            const SizedBox(height: 24),

            const Text(
              "Affirmations",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Provided by affirmations.dev"),

            const SizedBox(height: 24),

            const Text(
              "Animations",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Lottie animations by respective creators."),

          ],
        ),
      ),
    );
  }
}