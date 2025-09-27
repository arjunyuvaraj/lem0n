import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lemon/services/authentication_service.dart';
import 'package:lemon/services/line_service.dart';
import 'package:lemon/utilities/extensions.dart';

class AdminQueuePage extends StatefulWidget {
  const AdminQueuePage({super.key});

  @override
  State<AdminQueuePage> createState() => _AdminQueuePageState();
}

class _AdminQueuePageState extends State<AdminQueuePage> {
  String? selectedLine;

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
            final lineNames = allLines.keys.toList();
            if (lineNames.isEmpty) {
              return const Center(
                child: Text("Something went wrong loading this queue."),
              );
            }

            selectedLine ??= lineNames.first;
            final lineData = allLines[selectedLine];
            if (lineData == null) {
              return const Center(child: Text("This line does not exist."));
            }

            final line = Map<String, dynamic>.from(lineData);
            final int waiting = line['waiting'] ?? 0;
            final List queue = line['queue'] ?? [];
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Viewing Queue".capitalized),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedLine,
                        isExpanded: true,
                        alignment: Alignment.center,
                        icon: const SizedBox.shrink(),
                        items: lineNames.map((name) {
                          return DropdownMenuItem(
                            value: name,
                            alignment: Alignment.center,
                            child: Text(
                              name.capitalized,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.workSans(
                                textStyle: context.text.headlineSmall,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: context.colors.primary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedLine = newValue;
                          });
                        },
                      ),
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
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (context, index) {
                                final userId = queue[index];
                                return FutureBuilder<Map<String, dynamic>>(
                                  future: AuthenticationService()
                                      .getUserDataById(userId),
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

                                    if (snapshot.hasError ||
                                        !snapshot.hasData) {
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
                                    final token =
                                        userData['token'] ?? 'No Token';

                                    return ListTile(
                                      style: ListTileStyle.list,
                                      leading: Text(
                                        token,
                                        style: context.text.headlineSmall!
                                            .copyWith(
                                              fontSize: 17,
                                              letterSpacing: 2,
                                            ),
                                      ),
                                      title: Text(userData['displayName']),
                                      trailing: Text("#${index + 1}"),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
