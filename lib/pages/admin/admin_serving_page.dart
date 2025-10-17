import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lemon/components/queue_card.dart';
import 'package:lemon/services/authentication_service.dart';
import 'package:lemon/services/line_service.dart';
import 'package:lemon/utilities/extensions.dart';

/* TODO: Comment and work in progress
- Add the notification feature for the students
- Work on the call feature(add it in LineService)

*/
class AdminServingPage extends StatefulWidget {
  final String lineName;

  const AdminServingPage({super.key, required this.lineName});

  @override
  State<AdminServingPage> createState() => _AdminServingPageState();
}

class _AdminServingPageState extends State<AdminServingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<Map<String, dynamic>?>(
          stream: LineService().getAllLinesStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final allLines = snapshot.data!;
            final lineData = allLines[widget.lineName];

            if (lineData == null) {
              return const Center(child: Text("This line does not exist."));
            }

            final line = Map<String, dynamic>.from(lineData);
            final int waiting = line['waiting'] ?? 0;
            final List queue = line['queue'] ?? [];

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
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
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "People Waiting: $waiting",
                    style: context.text.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: queue.isEmpty
                        ? const Center(child: Text("No one is in this line."))
                        : ListView.separated(
                            itemCount: queue.length,
                            separatorBuilder: (_, _) => const Divider(),
                            itemBuilder: (context, index) {
                              final userId = queue[index];
                              return FutureBuilder<Map<String, dynamic>>(
                                future: AuthenticationService().getUserDataById(
                                  userId,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return ListTile(
                                      leading:
                                          const CircularProgressIndicator(),
                                      title: Text(userId.toString()),
                                      trailing: Text("#${index + 1}"),
                                    );
                                  }

                                  if (snapshot.hasError || !snapshot.hasData) {
                                    return ListTile(
                                      leading: const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                      title: Text(userId.toString()),
                                      trailing: Text("#${index + 1}"),
                                    );
                                  }

                                  final userData = snapshot.data!;
                                  final token = userData['token'] ?? 'No Token';

                                  return GestureDetector(
                                    onHorizontalDragStart: (_) {
                                      LineService().removeFromLine(
                                        widget.lineName,
                                        context,
                                        userId,
                                      );
                                    },
                                    child: QueueCard(
                                      index: index,
                                      token: token,
                                      userData: userData,
                                      onTap: () {
                                        LineService().removeFromLine(
                                          widget.lineName,
                                          context,
                                          userId,
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
