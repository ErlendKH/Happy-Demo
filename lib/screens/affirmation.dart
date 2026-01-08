import 'package:flutter/material.dart';
import '../data/affirmation_api.dart';
import '../data/affirmation_repository.dart';
import '../utils/saved_affirmation_notifier.dart';

class AffirmationScreen extends StatefulWidget {
  const AffirmationScreen({super.key});

  @override
  State<AffirmationScreen> createState() => _AffirmationScreenState();
}

class _AffirmationScreenState extends State<AffirmationScreen> {
  final _repo = AffirmationRepository();

  final List<String> _history = [];
  int _currentIndex = -1;
  bool _isLoading = false;
  bool _isSaving = false;
  bool _alreadySaved = false;

  String? get currentAffirmation =>
      _currentIndex >= 0 ? _history[_currentIndex] : null;

  @override
  void initState() {
    super.initState();
    nextAffirmation();
  }

  Future<void> nextAffirmation() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      final text = await fetchAffirmation();

      setState(() {
        if (_currentIndex < _history.length - 1) {
          _history.removeRange(_currentIndex + 1, _history.length);
        }
        _history.add(text);
        _currentIndex++;
      });

      await _updateAlreadySaved();

    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> previousAffirmation() async {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
    await _updateAlreadySaved();
  }

  Future<void> _updateAlreadySaved() async {
    final text = currentAffirmation;
    if (text == null) return;

    final saved = await _repo.getAffirmations();
    final isSaved = saved.any((a) => a.text == text);

    setState(() {
      _alreadySaved = isSaved;
    });
  }

  Future<void> saveCurrentAffirmation() async {
    final text = currentAffirmation;
    if (text == null || _isSaving) return;

    setState(() => _isSaving = true);

    await _repo.insertAffirmation(text);

    await _updateAlreadySaved();

    // Notify listeners that a new affirmation was saved
    savedAffirmationsNotifier.value++;

    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saved ✨'),
        duration: Duration(seconds: 2),
      ),
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

                // ElevatedButton(
                //   onPressed: currentAffirmation != null && !_isSaving
                //       ? saveCurrentAffirmation
                //       : null,
                //   child: _isSaving
                //       ? const SizedBox(
                //     width: 16,
                //     height: 16,
                //     child: CircularProgressIndicator(
                //       strokeWidth: 2,
                //       color: Colors.white,
                //     ),
                //   )
                //       : const Text("Keep"),
                // ),
                ElevatedButton(
                  onPressed: currentAffirmation != null && !_isSaving
                      ? () async {
                    if (_alreadySaved) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("You've already saved this affirmation."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    await saveCurrentAffirmation();
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _alreadySaved ? Colors.lightGreen : Colors.white60,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text("Keep"),
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
