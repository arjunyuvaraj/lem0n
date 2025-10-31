import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lemon/components/primary_app_button.dart';
import 'package:lemon/components/queue_card.dart';
import 'package:lemon/services/authentication_service.dart';
import 'package:lemon/services/line_service.dart';
import 'package:lemon/services/notification_service.dart';
import 'package:lemon/utilities/extensions.dart';

class AdminServingPage extends StatefulWidget {
  final String lineName;

  const AdminServingPage({super.key, required this.lineName});

  @override
  State<AdminServingPage> createState() => _AdminServingPageState();
}

class _AdminServingPageState extends State<AdminServingPage> {
  /// How many people are initially shown
  final int _visibleCount = 0;

  /// Whether we’ve initialized the first batch
  bool _initialized = false;

  /// Full live queue from Firestore (updated in background)
  List<String> _latestQueue = [];

  /// Queue currently visible on screen
  List<String> _displayedQueue = [];

  /// Simple user data cache to avoid flicker
  final Map<String, Map<String, dynamic>> _userCache = {};

  /// Total waiting count from Firestore
  int _waitingCount = 0;

  @override
  void initState() {
    super.initState();

    // Listen to Firestore stream in background
    LineService().getAllLinesStream().listen((data) {
      if (data == null) return;
      final lineData = data[widget.lineName];
      if (lineData == null) return;

      final List<String> queue = List<String>.from(lineData['queue'] ?? []);
      final int waiting = lineData['waiting'] ?? 0;

      // Update background data but don’t rebuild everything unnecessarily
      setState(() {
        _latestQueue = queue;
        _waitingCount = waiting;

        // Initialize visible queue once on first load
        if (!_initialized && queue.isNotEmpty) {
          _displayedQueue = queue.take(_visibleCount).toList();
          _initialized = true;
        }
      });
    });
  }

  /// Loads the next five people (if available)
  void _loadNextFive() async {
    final nextBatch = _latestQueue
        .skip(_displayedQueue.length)
        .take(5)
        .toList();
    if (nextBatch.isEmpty) return;
    await NotificationService.sendToUsers(
      uids: nextBatch,
      title: "It's your turn!",
      body: "Please check the app for your next task.",
    );
    setState(() {
      _displayedQueue.addAll(nextBatch);
    });
  }

  /// Removes user locally and updates Firestore in background
  void _serveUser(String userId) {
    setState(() {
      _displayedQueue.remove(userId);
      _userCache.remove(userId);
    });
    LineService().removeFromLine(widget.lineName, context, userId);
  }

  /// Builds the header row
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        Expanded(
          child: Text(
            "Viewing ${widget.lineName.capitalized}",
            textAlign: TextAlign.center,
            style: GoogleFonts.workSans(
              textStyle: context.text.headlineSmall,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: context.colors.primary,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  /// Builds a single queue card (cached for performance)
  Widget _buildQueueItem(BuildContext context, int index) {
    final userId = _displayedQueue[index];

    // Use cache if available
    if (_userCache.containsKey(userId)) {
      final userData = _userCache[userId]!;
      return _buildQueueCard(userData, userId, index);
    }

    // Otherwise fetch and cache
    return FutureBuilder<Map<String, dynamic>>(
      future: AuthenticationService().getUserDataById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            leading: const CircularProgressIndicator(),
            title: Text(userId),
            trailing: Text("#${index + 1}"),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return ListTile(
            leading: const Icon(Icons.error, color: Colors.red),
            title: Text(userId),
            trailing: Text("#${index + 1}"),
          );
        }

        final userData = snapshot.data!;
        _userCache[userId] = userData; // 💾 cache it
        return _buildQueueCard(userData, userId, index);
      },
    );
  }

  /// Builds a QueueCard with gesture handling
  Widget _buildQueueCard(
    Map<String, dynamic> userData,
    String userId,
    int index,
  ) {
    final token = userData['token'] ?? 'No Token';
    return GestureDetector(
      onHorizontalDragStart: (_) => _serveUser(userId),
      child: QueueCard(
        index: index,
        token: token,
        userData: userData,
        onTap: () => _serveUser(userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              Text(
                "People Waiting: $_waitingCount",
                style: context.text.titleMedium,
              ),
              const SizedBox(height: 16),

              // Call next five
              PrimaryAppButton(
                label: "Call next five people".capitalized,
                onTap: _loadNextFive,
              ),
              const SizedBox(height: 12),

              // Display list
              Expanded(
                child: _displayedQueue.isEmpty
                    ? const Center(child: Text("No one is in this line."))
                    : ListView.separated(
                        itemCount: _displayedQueue.length,
                        separatorBuilder: (_, _) => const Divider(),
                        itemBuilder: _buildQueueItem,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
