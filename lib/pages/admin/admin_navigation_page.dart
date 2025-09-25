import 'package:flutter/material.dart';
import 'package:lemon/pages/account_page.dart';
import 'package:lemon/pages/admin/admin_home_page.dart';
import 'package:lemon/pages/admin/admin_new_line_page.dart';
import 'package:lemon/pages/credits_page.dart';
import 'package:lemon/utilities/codes.dart';

class AdminNavigationPage extends StatefulWidget {
  final int initialIndex;
  final String? initialStore;

  const AdminNavigationPage({
    super.key,
    this.initialIndex = 0,
    this.initialStore,
  });

  @override
  State<AdminNavigationPage> createState() => _AdminNavigationPageState();
}

class _AdminNavigationPageState extends State<AdminNavigationPage> {
  late int _selectedIndex;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    pages = [AdminHomePage(), AdminNewLinePage(), AccountPage(), CreditsPage()];
    Codes().setStatus(false);
  }

  void _changeIndex(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return IconButton(
      onPressed: () => _changeIndex(index),
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
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
            _buildNavIcon(Icons.add_rounded, 1),
            _buildNavIcon(Icons.person_rounded, 2),
            _buildNavIcon(Icons.info_outline_rounded, 3),
          ],
        ),
      ),
    );
  }
}
