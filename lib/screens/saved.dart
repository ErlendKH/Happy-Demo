import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/affirmation_item.dart';
import '../data/affirmation_repository.dart';
import '../utils/saved_affirmation_notifier.dart';

enum SavedViewMode { focus, list }

enum SortMode { favorites, newest, oldest, random }

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final _repo = AffirmationRepository();

  List<AffirmationItem> _affirmations = [];
  bool _isLoading = true;

  SavedViewMode _viewMode = SavedViewMode.list;
  SortMode _sortMode = SortMode.newest;

  int _focusIndex = 0;

  @override
  void initState() {
    super.initState();
    _refreshAffirmations();

    savedAffirmationsNotifier.addListener(() {
      _refreshAffirmations();
    });
  }

  @override
  void dispose() {
    savedAffirmationsNotifier.removeListener(() {
      _refreshAffirmations();
    });
    super.dispose();
  }

  Future<void> _refreshAffirmations() async {
    if(kDebugMode){
      print('_refreshAffirmations running');
    }

    final data = await _repo.getAffirmations();

    setState(() {
      _affirmations = data;
      _focusIndex = 0;
      _isLoading = false;
    });
  }

  List<AffirmationItem> _sortedAffirmations() {
    var list = List<AffirmationItem>.from(_affirmations);

    // Handle favorites filter
    if (_sortMode == SortMode.favorites) {
      final favorites = list.where((a) => a.isFavorite).toList();
      if (favorites.isEmpty) {
        // Default to newest if no favorites
        _sortMode = SortMode.newest;
        return list;
      }
      return favorites;
    }

    // Then sort
    switch (_sortMode) {
      case SortMode.newest:
        return list; // already sorted
      case SortMode.oldest:
        return list.reversed.toList();
      case SortMode.random:
        list.shuffle();
        return list;
      case SortMode.favorites:
        return list; // unreachable, handled above
    }
  }

  void _nextFocus(int length) {
    setState(() {
      _focusIndex = (_focusIndex + 1) % length;
    });
  }

  void _prevFocus(int length) {
    setState(() {
      _focusIndex = (_focusIndex - 1 + length) % length;
    });
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    var items = _sortedAffirmations();

    if (items.isEmpty) {
      final text = _sortMode == SortMode.favorites
          ? "No affirmations are favorited."
          : "Your saved affirmations\nwill appear here.";

      return Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    final totalCount = _affirmations.length;
    final favoritesCount = _affirmations.where((a) => a.isFavorite).length;

    // if (_viewMode == SavedViewMode.focus) {
    //   final affirmation = items[_focusIndex % items.length];
    //
    //   return GestureDetector(
    //     onHorizontalDragEnd: (details) {
    //       if (details.primaryVelocity == null) return;
    //       if (details.primaryVelocity! < 0) {
    //         _nextFocus(items.length);
    //       } else {
    //         _prevFocus(items.length);
    //       }
    //     },
    //
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         // Affirmation
    //         Padding(
    //           padding: const EdgeInsets.all(24),
    //           child: Text(
    //             affirmation.text,
    //             style: Theme.of(context).textTheme.headlineSmall,
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //
    //         // Index
    //         Text(
    //           '${_focusIndex + 1} of ${items.length}',
    //           style: Theme.of(context).textTheme.bodySmall,
    //         ),
    //
    //         const SizedBox(height: 24),
    //
    //         // Actions
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             IconButton(
    //               icon: const Icon(Icons.arrow_back),
    //               onPressed: _focusIndex > 0
    //                   ? () => _prevFocus(items.length)
    //                   : null,
    //             ),
    //             IconButton(
    //               icon: Icon(
    //                 affirmation.isFavorite
    //                     ? Icons.favorite
    //                     : Icons.favorite_border,
    //               ),
    //               color: Colors.green,
    //               onPressed: () async {
    //                 await _repo.toggleFavorite(
    //                   affirmation.id,
    //                   !affirmation.isFavorite,
    //                 );
    //                 _refreshAffirmations();
    //               },
    //             ),
    //             IconButton(
    //               icon: const Icon(Icons.delete),
    //               color: Colors.deepOrange,
    //               onPressed: () async {
    //                 await _repo.deleteAffirmation(affirmation.id);
    //                 _refreshAffirmations();
    //               },
    //             ),
    //             IconButton(
    //               icon: const Icon(Icons.arrow_forward),
    //               onPressed: _focusIndex < items.length - 1
    //                   ? () => _nextFocus(items.length)
    //                   : null,
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //
    //   );
    // }
    if (_viewMode == SavedViewMode.focus) {
      final affirmation = items[_focusIndex % items.length];
      final singleItem = items.length == 1;

      return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity == null) return;
          if (details.primaryVelocity! < 0) {
            _nextFocus(items.length);
          } else {
            _prevFocus(items.length);
          }
        },

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            Flexible(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        affirmation.text,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_focusIndex + 1} of ${items.length}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: singleItem ? Colors.grey : null,
                  onPressed: singleItem ? null : () => _prevFocus(items.length),
                ),
                IconButton(
                  icon: Icon(
                    affirmation.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  color: Colors.green,
                  onPressed: () async {
                    await _repo.toggleFavorite(
                      affirmation.id,
                      !affirmation.isFavorite,
                    );
                    _refreshAffirmations();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.deepOrange,
                  onPressed: () async {
                    await _repo.deleteAffirmation(affirmation.id);
                    _refreshAffirmations();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  color: singleItem ? Colors.grey : null,
                  onPressed: singleItem ? null : () => _nextFocus(items.length),
                ),
              ],
            ),

            const Spacer(),
          ],
        ),
      );
    }
    
    // LIST MODE
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Saved: $totalCount | Favorites: $favoritesCount',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final affirmation = items[index];
              return ListTile(
                title: Text(affirmation.text),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        affirmation.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      color: Colors.green,
                      onPressed: () async {
                        await _repo.toggleFavorite(
                          affirmation.id,
                          !affirmation.isFavorite,
                        );
                        _refreshAffirmations();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.deepOrange,
                      onPressed: () async {
                        await _repo.deleteAffirmation(affirmation.id);
                        _refreshAffirmations();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Saved")),
      appBar: AppBar(
        title: const Text("Saved"),
        actions: [
          // View mode toggle
          IconButton(
            icon: Icon(
              _viewMode == SavedViewMode.focus
                  ? Icons.view_list
                  : Icons.center_focus_strong,
            ),
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == SavedViewMode.focus
                    ? SavedViewMode.list
                    : SavedViewMode.focus;
              });
            },
          ),

          PopupMenuButton<SortMode>(
            icon: const Icon(Icons.sort),
            onSelected: (mode) {

              if (mode == SortMode.favorites &&
                  !_affirmations.any((a) => a.isFavorite)) {
                // Show a Snackbar if there are no favorites
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("You currently don't have any favorited affirmations."),
                    duration: Duration(seconds: 2),
                  ),
                );
              }

              setState(() {
                _sortMode = mode;
                _focusIndex = 0; // reset focus
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SortMode.newest,
                child: Row(
                  children: [
                    Text("Newest"),
                    if (_sortMode == SortMode.newest)
                      const Spacer(),
                    if (_sortMode == SortMode.newest)
                      const Icon(Icons.check, color: Colors.green),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SortMode.oldest,
                child: Row(
                  children: [
                    Text("Oldest"),
                    if (_sortMode == SortMode.oldest)
                      const Spacer(),
                    if (_sortMode == SortMode.oldest)
                      const Icon(Icons.check, color: Colors.green),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SortMode.random,
                child: Row(
                  children: [
                    Text("Random"),
                    if (_sortMode == SortMode.random)
                      const Spacer(),
                    if (_sortMode == SortMode.random)
                      const Icon(Icons.check, color: Colors.green),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SortMode.favorites,
                child: Row(
                  children: [
                    Text("Favorites"),
                    if (_sortMode == SortMode.favorites)
                      const Spacer(),
                    if (_sortMode == SortMode.favorites)
                      const Icon(Icons.check, color: Colors.green),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}
