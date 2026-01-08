import 'package:flutter/material.dart';
import '../data/affirmation_api.dart';

class AffirmationScreen extends StatefulWidget {
  const AffirmationScreen({super.key});

  @override
  State<AffirmationScreen> createState() => _AffirmationScreenState();
}

class _AffirmationScreenState extends State<AffirmationScreen> {
  final List<String> _history = [];
  int _currentIndex = -1;
  bool _isLoading = false;

  String? get currentAffirmation =>
      _currentIndex >= 0 ? _history[_currentIndex] : null;

  @override
  void initState() {
    super.initState();
    nextAffirmation(); // load first affirmation automatically
  }

  Future<void> nextAffirmation() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final text = await fetchAffirmation();

      setState(() {
        // discard forward history if user went back
        if (_currentIndex < _history.length - 1) {
          _history.removeRange(_currentIndex + 1, _history.length);
        }

        _history.add(text);
        _currentIndex++;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void previousAffirmation() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void saveCurrentAffirmation() {
    final text = currentAffirmation;
    if (text == null) return;

    // TODO: call AffirmationRepository.insertAffirmation(text)

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved ✨')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            if (_isLoading)
              const CircularProgressIndicator()
            else
              Text(
                currentAffirmation ??
                    'Take a breath.\nSomething good is coming.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed:
                  _currentIndex > 0 ? previousAffirmation : null,
                ),
                ElevatedButton(
                  onPressed:
                  currentAffirmation != null ? saveCurrentAffirmation : null,
                  child: const Text("Keep"),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: nextAffirmation,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}