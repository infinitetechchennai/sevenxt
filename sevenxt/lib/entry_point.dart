import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sevenxt/constants.dart';
import 'package:sevenxt/route/api_service.dart';
import 'package:sevenxt/route/guest_services.dart';
import 'package:sevenxt/route/route_constants.dart';
import 'package:sevenxt/screens/checkout/views/cart_screen.dart';
import 'package:sevenxt/screens/discover/views/discover_screen.dart';
import 'package:sevenxt/screens/home/views/home_screen.dart';
import 'package:sevenxt/screens/profile/views/profile_screen.dart';
import 'package:sevenxt/utils/responsive.dart';

import '/screens/helpers/user_helper.dart';

class EntryPoint extends StatefulWidget {
  final int initialIndex;

  const EntryPoint({super.key, this.initialIndex = 0});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  late int _currentIndex;
  Timer? _approvalTimer;

  final List<Widget> _pages = [
    HomeScreen(),
    DiscoverScreen(),
    CartScreen(isTab: true, showBackButton: false),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    final savedIndex = Hive.box('user_settings')
        .get('last_tab_index', defaultValue: widget.initialIndex);
    _currentIndex = savedIndex;
    _startApprovalPolling();
  }

  void _startApprovalPolling() async {
    final userType = await UserHelper.getUserType();
    if (userType != UserHelper.b2b) return;

    _approvalTimer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      final isApproved = await _checkApproval();

      if (!mounted) return;

      if (isApproved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your B2B account has been approved!')),
        );
        timer.cancel();
      } else {
        Future.delayed(Duration.zero, () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, b2bApprovalPendingRoute);
            timer.cancel();
          }
        });
      }
    });
  }

  Future<bool> _checkApproval() async {
    final authBox = Hive.box('auth');
    try {
      final profile = await ApiService.getUserProfile();
      final status = profile['status']?.toString().toLowerCase() ?? 'pending';
      final isApproved = status == 'approved';
      await authBox.put('is_approved', isApproved);
      return isApproved;
    } catch (e) {
      return authBox.get('is_approved', defaultValue: false);
    }
  }

  @override
  void dispose() {
    _approvalTimer?.cancel();
    super.dispose();
  }

  SvgPicture svgIcon(String src, {Color? color}) {
    return SvgPicture.asset(
      src,
      height: 24,
      colorFilter: ColorFilter.mode(
        color ??
            Theme.of(context).iconTheme.color!.withOpacity(
                  Theme.of(context).brightness == Brightness.dark ? 0.3 : 1,
                ),
        BlendMode.srcIn,
      ),
    );
  }

  /// Navigation items data
  static const _navItems = [
    ('Home', 'assets/icons/Shop.svg'),
    ('Discover', 'assets/icons/Category.svg'),
    ('Cart', 'assets/icons/cart.svg'),
    ('Profile', 'assets/icons/Profile.svg'),
  ];

  Widget _buildSidebar(int selectedIndex, Function(int) onTap, bool isGuest) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 240,
      color: isDark ? const Color(0xFF1C1C25) : Colors.white,
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              "assets/logo/sevenxt.svg",
              height: 60,
              width: 80,
            ),
          ),
          const Divider(height: 1),
          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                final isDisabled =
                    isGuest && (index == 1 || index == 2 || index == 3);
                return _SidebarItem(
                  icon: _navItems[index].$2,
                  label: _navItems[index].$1,
                  isSelected: isSelected,
                  isDisabled: isDisabled,
                  onTap: () {
                    if (!isDisabled) {
                      onTap(index);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: const SizedBox(),
      leadingWidth: 0,
      centerTitle: false,
      title: SvgPicture.asset(
        "assets/logo/sevenxt.svg",
        height: 85,
        width: 120,
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, searchScreenRoute);
          },
          icon: SvgPicture.asset(
            "assets/icons/Search.svg",
            height: 24,
            colorFilter: ColorFilter.mode(
              Theme.of(context).textTheme.bodyLarge!.color!,
              BlendMode.srcIn,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, notificationScreenRoute);
          },
          icon: SvgPicture.asset(
            "assets/icons/notification.svg",
            height: 24,
            colorFilter: ColorFilter.mode(
              Theme.of(context).textTheme.bodyLarge!.color!,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GuestService>(
      builder: (context, guestService, child) {
        final bool isGuest = guestService.isGuest;
        final bool isDesktop = Responsive.isDesktop(context);

        return PopScope(
          canPop: _currentIndex == 0,
          onPopInvoked: (didPop) {
            if (didPop) return;
            setState(() {
              _currentIndex = 0;
            });
          },
          child: Scaffold(
            appBar: isDesktop ? null : _buildAppBar(),
            body: Row(
              children: [
                // Desktop: Sidebar navigation
                if (isDesktop)
                  _buildSidebar(_currentIndex, (index) {
                    if (isGuest && (index == 1 || index == 2 || index == 3)) {
                      Navigator.pushNamed(context, logInScreenRoute);
                    } else if (index != _currentIndex) {
                      setState(() {
                        _currentIndex = index;
                      });
                      Hive.box('user_settings').put('last_tab_index', index);
                    }
                  }, isGuest),

                // Main content
                Expanded(
                  child: Column(
                    children: [
                      // Desktop: Top bar
                      if (isDesktop) _buildAppBar(),
                      // Page content
                      Expanded(
                        child: PageTransitionSwitcher(
                          duration: defaultDuration,
                          transitionBuilder:
                              (child, animation, secondAnimation) {
                            return FadeThroughTransition(
                              animation: animation,
                              secondaryAnimation: secondAnimation,
                              child: child,
                            );
                          },
                          child: _pages[_currentIndex],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Mobile: Bottom navigation
            bottomNavigationBar: isDesktop
                ? null
                : Container(
                    padding: const EdgeInsets.only(top: defaultPadding / 2),
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : const Color(0xFF101015),
                    child: BottomNavigationBar(
                      currentIndex: _currentIndex,
                      onTap: (index) {
                        if (isGuest &&
                            (index == 1 || index == 2 || index == 3)) {
                          Navigator.pushNamed(context, logInScreenRoute);
                        } else if (index != _currentIndex) {
                          setState(() {
                            _currentIndex = index;
                          });
                          Hive.box('user_settings')
                              .put('last_tab_index', _currentIndex);
                        }
                      },
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : const Color(0xFF101015),
                      type: BottomNavigationBarType.fixed,
                      selectedFontSize: 12,
                      selectedItemColor: kPrimaryColor,
                      unselectedItemColor: Colors.transparent,
                      items: [
                        BottomNavigationBarItem(
                          icon: svgIcon("assets/icons/Shop.svg"),
                          activeIcon: svgIcon("assets/icons/Shop.svg",
                              color: kPrimaryColor),
                          label: "Shop",
                        ),
                        BottomNavigationBarItem(
                          icon: svgIcon("assets/icons/Category.svg",
                              color: isGuest ? Colors.grey : null),
                          activeIcon: svgIcon("assets/icons/Category.svg",
                              color: kPrimaryColor),
                          label: "Discover",
                        ),
                        BottomNavigationBarItem(
                          icon: svgIcon("assets/icons/cart.svg",
                              color: isGuest ? Colors.grey : null),
                          activeIcon: svgIcon("assets/icons/cart.svg",
                              color: isGuest ? Colors.grey : kPrimaryColor),
                          label: "Cart",
                        ),
                        BottomNavigationBarItem(
                          icon: svgIcon("assets/icons/Profile.svg",
                              color: isGuest ? Colors.grey : null),
                          activeIcon: svgIcon("assets/icons/Profile.svg",
                              color: isGuest ? Colors.grey : kPrimaryColor),
                          label: "Profile",
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: isSelected ? kPrimaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                SvgPicture.asset(
                  icon,
                  height: 22,
                  width: 22,
                  colorFilter: ColorFilter.mode(
                    isDisabled
                        ? Colors.grey
                        : isSelected
                            ? kPrimaryColor
                            : isDark
                                ? Colors.white70
                                : Colors.black87,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isDisabled
                        ? Colors.grey
                        : isSelected
                            ? kPrimaryColor
                            : isDark
                                ? Colors.white
                                : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
