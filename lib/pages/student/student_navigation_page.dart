import 'package:flutter/material.dart';
import 'package:lemon/pages/account_page.dart';
import 'package:lemon/pages/credits_page.dart';
import 'package:lemon/pages/student/student_line_information_page.dart';
import 'package:lemon/pages/student/student_home_page.dart';
import 'package:lemon/utilities/codes.dart';

class StudentNavigationPage extends StatefulWidget {
  final int initialIndex;
  final String? initialStore;

  const StudentNavigationPage({
    super.key,
    this.initialIndex = 0,
    this.initialStore,
  });

  @override
  StudentNavigationPageState createState() => StudentNavigationPageState();
}

class StudentNavigationPageState extends State<StudentNavigationPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    Codes().setStatus(true);
  }

  /// Public: change the current tab
  void changeIndex(int index) => setState(() => _selectedIndex = index);

  /// Public: switch to a tab and optionally set the store name for the Line page
  void switchTo({required int index, String? store}) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _linePage() {
    return StudentLineInformationPage();
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return IconButton(
      onPressed: () => changeIndex(index),
      icon: Icon(
        icon,
        size: 28,
        color: isSelected
            ? ColorScheme.of(context).primary
            : Colors.grey.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use IndexedStack so non-visible pages keep their state (no big rebuilds)
    final children = <Widget>[
      StudentHomePage(),
      _linePage(),
      AccountPage(),
      CreditsPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IndexedStack(index: _selectedIndex, children: children),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: 24,
          top: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavIcon(Icons.home_rounded, 0),
            _buildNavIcon(Icons.info_outline, 1),
            _buildNavIcon(Icons.person_rounded, 2),
            _buildNavIcon(Icons.copyright_outlined, 3),
          ],
        ),
      ),
    );
  }
}
