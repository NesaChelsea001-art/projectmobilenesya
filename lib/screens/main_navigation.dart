import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'crud_screen.dart';
import 'profile_screen.dart';
import 'post_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const Color cream = Color(0xFFF5EFE5);
  static const Color orange = Color(0xFFC87545);
  static const Color darkBrown = Color(0xFF352B25);
  static const Color softBrown = Color(0xFF8A7565);
  static const Color white = Color(0xFFFFFCF7);

  final List<Widget> _screens = const [
    DashboardScreen(),
    CrudScreen(),
    ProfileScreen(),
    PostPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      body: IndexedStack(index: _selectedIndex, children: _screens),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: darkBrown.withOpacity(0.07),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Beranda',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.edit_note_outlined,
                  activeIcon: Icons.edit_note_rounded,
                  label: 'Kelola',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profil',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.newspaper_outlined,
                  activeIcon: Icons.newspaper_rounded,
                  label: 'Berita',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? orange.withOpacity(0.13)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? orange : softBrown,
                  size: 23,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? orange : softBrown,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
