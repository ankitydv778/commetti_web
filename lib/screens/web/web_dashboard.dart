import 'package:committee/core/utils/language_selector.dart';
import 'package:committee/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/responsive_widget.dart';
import '../../core/utils/responsive_layout.dart';
import '../../core/utils/custom_dialog.dart';
import '../profile_screen.dart';

class WebDashboard extends StatefulWidget {
  const WebDashboard({super.key});

  @override
  State<WebDashboard> createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  bool _isSidebarExpanded = true;
  late AnimationController _sidebarController;
  late Animation<double> _sidebarAnimation;

  final List<Widget> _pages = [
    const DashboardContent(),
    const ProfileScreen(),
    const TransactionsContent(),
    const AnalyticsContent(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();

    _sidebarController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _sidebarAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _sidebarController, curve: Curves.easeInOutCubic),
    );

    _sidebarController.forward();
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
      if (_isSidebarExpanded) {
        _sidebarController.forward();
      } else {
        _sidebarController.reverse();
      }
    });
  }

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final result = await CustomDialog.show(
      context: context,
      type: DialogType.confirmation,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      confirmColor: AppColors.errorColor,
    );

    if (result == true) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout(context);
    }
  }

  void _showUserProfileMenu(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'ProfileMenu',
      barrierColor: Colors.black.withOpacity(0.1),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, _, __) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 78, right: 20),
            child: FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.05),
                  end: Offset.zero,
                ).animate(curved),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: themeProvider.isDarkMode
                          ? Colors.grey.shade900
                          : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 40,
                          spreadRadius: 5,
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // HEADER
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            top: 25,
                            left: 25,
                            right: 25,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 42,
                                backgroundColor: Colors.white.withOpacity(0.25),
                                backgroundImage: user?.profileImage != null
                                    ? NetworkImage(user!.profileImage!)
                                    : null,
                                child: user?.profileImage == null
                                    ? const Icon(
                                        Icons.person_rounded,
                                        size: 42,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 14),
                              Text(
                                "Ankit Yadav",
                                // user?.name ?? 'User',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "ankitky778@gmail.com",
                                // user?.email ?? '',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // MENU
                        _ModernMenuItem(
                          icon: Icons.person_outline,
                          title: 'My Profile',
                          onTap: () {
                            Navigator.pop(context);
                            _navigateToPage(1);
                          },
                        ),
                        _ModernMenuItem(
                          icon: Icons.settings_outlined,
                          title: 'Settings',
                          onTap: () {
                            Navigator.pop(context);
                            _navigateToPage(4);
                          },
                        ),
                        _ModernMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 6,
                          ),
                          child: Divider(),
                        ),

                        _ModernMenuItem(
                          icon: Icons.logout_rounded,
                          title: 'Logout',
                          isDestructive: true,
                          onTap: () {
                            Navigator.pop(context);
                            _showLogoutDialog(context);
                          },
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Row(
        children: [
          // Animated Sidebar
          AnimatedBuilder(
            animation: _sidebarAnimation,
            builder: (context, child) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  width: _isSidebarExpanded ? 280 : 80,
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? AppColors.darkSecondary
                        : Colors.white,
                    border: Border(
                      right: BorderSide(
                        color: themeProvider.isDarkMode
                            ? Colors.grey.shade800
                            : AppColors.lightGrey,
                        width: 1,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Logo Section
                      Container(
                        padding: EdgeInsets.all(
                          _isSidebarExpanded
                              ? Dimensions.paddingLarge
                              : Dimensions.paddingDefault,
                        ),
                        child: Row(
                          mainAxisAlignment: _isSidebarExpanded
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                width: _isSidebarExpanded ? 40 : 36,
                                height: _isSidebarExpanded ? 40 : 36,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            if (_isSidebarExpanded) ...[
                              const SizedBox(width: 12),
                              Text(
                                'ChitFund',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Divider(),

                      // Navigation Items
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            _NavItem(
                              icon: Icons.dashboard,
                              label: 'Dashboard',
                              isSelected: _selectedIndex == 0,
                              isExpanded: _isSidebarExpanded,
                              onTap: () => _navigateToPage(0),
                            ),
                            _NavItem(
                              icon: Icons.person,
                              label: 'Profile',
                              isSelected: _selectedIndex == 1,
                              isExpanded: _isSidebarExpanded,
                              onTap: () => _navigateToPage(1),
                            ),
                            _NavItem(
                              icon: Icons.credit_card,
                              label: 'Transactions',
                              isSelected: _selectedIndex == 2,
                              isExpanded: _isSidebarExpanded,
                              onTap: () => _navigateToPage(2),
                            ),
                            _NavItem(
                              icon: Icons.analytics,
                              label: 'Analytics',
                              isSelected: _selectedIndex == 3,
                              isExpanded: _isSidebarExpanded,
                              onTap: () => _navigateToPage(3),
                            ),
                            _NavItem(
                              icon: Icons.settings,
                              label: 'Settings',
                              isSelected: _selectedIndex == 4,
                              isExpanded: _isSidebarExpanded,
                              onTap: () => _navigateToPage(4),
                            ),
                            _NavItem(
                              icon: Icons.help,
                              label: 'Help & Support',
                              isSelected: false,
                              isExpanded: _isSidebarExpanded,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),

                      // Sidebar Toggle Button
                      Container(
                        padding: const EdgeInsets.all(
                          Dimensions.paddingDefault,
                        ),
                        child: Row(
                          mainAxisAlignment: _isSidebarExpanded
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.center,
                          children: [
                            if (_isSidebarExpanded)
                              Row(
                                children: [
                                  Icon(
                                    themeProvider.isDarkMode
                                        ? Icons.dark_mode
                                        : Icons.light_mode,
                                    color: AppColors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    themeProvider.isDarkMode ? 'Dark' : 'Light',
                                    style: TextStyle(color: AppColors.grey),
                                  ),
                                ],
                              ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: IconButton(
                                icon: Icon(
                                  _isSidebarExpanded
                                      ? Icons.chevron_left
                                      : Icons.chevron_right,
                                  color: AppColors.primaryColor,
                                ),
                                onPressed: _toggleSidebar,
                                tooltip: _isSidebarExpanded
                                    ? 'Collapse'
                                    : 'Expand',
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Logout Button
                      Container(
                        padding: const EdgeInsets.all(
                          Dimensions.paddingDefault,
                        ),
                        child: _isSidebarExpanded
                            ? MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: CustomButton(
                                  onPressed: () => _showLogoutDialog(context),
                                  text: 'Logout',
                                  backgroundColor: AppColors.errorColor
                                      .withOpacity(0.1),
                                  foregroundColor: AppColors.errorColor,
                                  icon: Icon(Icons.logout),
                                  isFullWidth: true,
                                ),
                              )
                            : MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.logout,
                                    color: AppColors.errorColor,
                                  ),
                                  onPressed: () => _showLogoutDialog(context),
                                  tooltip: 'Logout',
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top App Bar
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingLarge,
                  ),
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? AppColors.darkSecondary
                        : Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: themeProvider.isDarkMode
                            ? Colors.grey.shade800
                            : AppColors.lightGrey,
                        width: 1,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page Title and Breadcrumb
                      Row(
                        children: [
                          // Hamburger Menu for mobile/tablet
                          if (!ResponsiveLayout.isWeb(context))
                            IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: _toggleSidebar,
                            ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getPageTitle(_selectedIndex, languageProvider),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : AppColors.black,
                                ),
                              ),
                              Text(
                                _getPageSubtitle(
                                  _selectedIndex,
                                  languageProvider,
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Top Right Actions
                      Row(
                        children: [
                          // Search Bar
                          MouseRegion(
                            cursor: SystemMouseCursors.text,
                            child: Container(
                              width: 300,
                              height: 40,
                              decoration: BoxDecoration(
                                color: themeProvider.isDarkMode
                                    ? Colors.grey.shade900
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search,
                                    size: 20,
                                    color: AppColors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search...',
                                        hintStyle: const TextStyle(
                                          color: AppColors.grey,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: TextStyle(
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : AppColors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),

                          // Notifications
                          _NotificationButton(),
                          const SizedBox(width: 20),

                          // Language Selector
                          LanguageSelector(languageProvider: languageProvider),
                          const SizedBox(width: 20),

                          // User Profile Menu
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => _showUserProfileMenu(context),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: themeProvider.isDarkMode
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 12,
                                      color: Colors.black.withOpacity(0.08),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: AppColors.primaryColor
                                          .withOpacity(0.15),
                                      backgroundImage:
                                          authProvider.user?.profileImage !=
                                              null
                                          ? NetworkImage(
                                              authProvider.user!.profileImage!,
                                            )
                                          : null,
                                      child:
                                          authProvider.user?.profileImage ==
                                              null
                                          ? const Icon(
                                              Icons.person_rounded,
                                              size: 18,
                                              color: AppColors.primaryColor,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      Icons.expand_more_rounded,
                                      size: 20,
                                      color: AppColors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Page Content with Animation
                Expanded(
                  child: PageTransitionSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (
                          Widget child,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                        ) {
                          return SharedAxisTransition(
                            animation: animation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: SharedAxisTransitionType.horizontal,
                            child: child,
                          );
                        },
                    child: _pages[_selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle(int index, LanguageProvider languageProvider) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'My Profile';
      case 2:
        return 'Transactions';
      case 3:
        return 'Analytics';
      case 4:
        return 'Settings';
      default:
        return '';
    }
  }

  String _getPageSubtitle(int index, LanguageProvider languageProvider) {
    switch (index) {
      case 0:
        return 'Overview of your chit fund activities';
      case 1:
        return 'Manage your personal information';
      case 2:
        return 'View and manage all transactions';
      case 3:
        return 'Detailed analytics and reports';
      case 4:
        return 'App settings and preferences';
      default:
        return '';
    }
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingDefault,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: isSelected
              ? Border.all(color: AppColors.primaryColor.withOpacity(0.3))
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            hoverColor: AppColors.primaryColor.withOpacity(0.05),
            splashColor: AppColors.primaryColor.withOpacity(0.1),
            child: Container(
              padding: EdgeInsets.all(isExpanded ? 16 : 12),
              child: Row(
                mainAxisAlignment: isExpanded
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isSelected
                        ? AppColors.primaryColor
                        : themeProvider.isDarkMode
                        ? Colors.white70
                        : AppColors.grey,
                    size: isExpanded ? 20 : 22,
                  ),
                  if (isExpanded) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primaryColor
                              : themeProvider.isDarkMode
                              ? Colors.white70
                              : AppColors.grey,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationButton extends StatefulWidget {
  @override
  State<_NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<_NotificationButton> {
  bool _hasNotifications = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: themeProvider.isDarkMode ? Colors.white70 : AppColors.grey,
            onPressed: () {
              // Show notifications
            },
          ),
          if (_hasNotifications)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.errorColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Dashboard Content with Hover Effects
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimensions.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card with Gradient
          MouseRegion(
            cursor: SystemMouseCursors.basic,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingExtraLarge),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.9),
                    AppColors.secondaryColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back! 👋',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Here\'s what\'s happening with your chit funds today.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: CustomButton(
                          onPressed: () {},
                          text: 'View Reports',
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryColor,
                          width: 150,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1),
          ),
          const SizedBox(height: Dimensions.paddingLarge),

          // Stats Overview Section
          Text(
            'Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode ? Colors.white : AppColors.black,
            ),
          ),
          const SizedBox(height: Dimensions.paddingDefault),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: Dimensions.paddingLarge,
            mainAxisSpacing: Dimensions.paddingLarge,
            childAspectRatio: 1.2,
            children: [
              _StatCard(
                title: 'Total Balance',
                value: '₹ 2,50,000',
                change: '+12% from last month',
                icon: Icons.account_balance_wallet,
                color: AppColors.successColor,
                trend: 'up',
                index: 0,
              ),
              _StatCard(
                title: 'Active Chits',
                value: '8',
                change: '+2 this month',
                icon: Icons.groups,
                color: AppColors.primaryColor,
                trend: 'up',
                index: 1,
              ),
              _StatCard(
                title: 'Pending Payments',
                value: '₹ 45,000',
                change: 'Due in 5 days',
                icon: Icons.payment,
                color: AppColors.warningColor,
                trend: 'alert',
                index: 2,
              ),
              _StatCard(
                title: 'Monthly Returns',
                value: '₹ 25,000',
                change: '+8% from last month',
                icon: Icons.trending_up,
                color: AppColors.infoColor,
                trend: 'up',
                index: 3,
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingLarge),

          // Charts and Recent Activity Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column - Charts
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // Performance Chart
                    MouseRegion(
                      cursor: SystemMouseCursors.basic,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radiusLarge,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            Dimensions.paddingLarge,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Performance Overview',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.isDarkMode
                                          ? Colors.white
                                          : AppColors.black,
                                    ),
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Last 6 months',
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Dimensions.paddingLarge),
                              Container(
                                height: 250,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.lightGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radiusDefault,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.analytics,
                                        size: 60,
                                        color: AppColors.grey,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Interactive Chart',
                                        style: TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
                    ),
                    const SizedBox(height: Dimensions.paddingLarge),

                    // Quick Stats
                    MouseRegion(
                      cursor: SystemMouseCursors.basic,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radiusLarge,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            Dimensions.paddingLarge,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quick Stats',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : AppColors.black,
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingLarge),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _QuickStatItem(
                                    title: 'Avg. Investment',
                                    value: '₹ 15,000',
                                    icon: Icons.money,
                                    index: 0,
                                  ),
                                  _QuickStatItem(
                                    title: 'Members',
                                    value: '48',
                                    icon: Icons.people,
                                    index: 1,
                                  ),
                                  _QuickStatItem(
                                    title: 'ROI',
                                    value: '12.5%',
                                    icon: Icons.percent,
                                    index: 2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.1),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Dimensions.paddingLarge),

              // Right Column - Recent Activity
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    // Recent Transactions
                    MouseRegion(
                      cursor: SystemMouseCursors.basic,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radiusLarge,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            Dimensions.paddingLarge,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Recent Transactions',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.isDarkMode
                                          ? Colors.white
                                          : AppColors.black,
                                    ),
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Dimensions.paddingDefault),
                              ...List.generate(
                                5,
                                (index) => _TransactionItem(index: index),
                              ),
                              const SizedBox(height: Dimensions.paddingDefault),
                              Center(
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'View All Transactions',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.1),
                    ),
                    const SizedBox(height: Dimensions.paddingLarge),

                    // Upcoming Payments
                    MouseRegion(
                      cursor: SystemMouseCursors.basic,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radiusLarge,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            Dimensions.paddingLarge,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upcoming Payments',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : AppColors.black,
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingDefault),
                              ...List.generate(
                                3,
                                (index) => _UpcomingPaymentItem(index: index),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(duration: 700.ms).slideX(begin: 0.1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingLarge),

          // Recent Chit Groups
          MouseRegion(
            cursor: SystemMouseCursors.basic,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Chit Groups',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : AppColors.black,
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: CustomButton(
                            onPressed: () {},
                            text: 'Create New Group',
                            width: 180,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingLarge),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      crossAxisSpacing: Dimensions.paddingLarge,
                      mainAxisSpacing: Dimensions.paddingLarge,
                      childAspectRatio: 1.5,
                      children: List.generate(
                        4,
                        (index) => _ChitGroupCard(index: index),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final Color color;
  final String trend;
  final int index;

  const _StatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
    required this.trend,
    required this.index,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Card(
          elevation: _isHovered ? 8 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(_isHovered ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(
                          Dimensions.radiusDefault,
                        ),
                      ),
                      child: Icon(widget.icon, color: widget.color, size: 24),
                    ),
                    if (widget.trend == 'up')
                      const Icon(
                        Icons.trending_up,
                        color: AppColors.successColor,
                        size: 20,
                      )
                    else if (widget.trend == 'alert')
                      const Icon(
                        Icons.warning,
                        color: AppColors.warningColor,
                        size: 20,
                      )
                    else
                      const Icon(
                        Icons.trending_down,
                        color: AppColors.errorColor,
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.change,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.change.contains('+')
                        ? AppColors.successColor
                        : AppColors.warningColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(delay: (100 * widget.index).ms).slideY(begin: 0.1),
    );
  }
}

class _QuickStatItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final int index;

  const _QuickStatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 30),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ).animate().fadeIn(delay: (200 * index).ms).slideY(begin: 0.1),
    );
  }
}

class _TransactionItem extends StatefulWidget {
  final int index;

  const _TransactionItem({required this.index});

  @override
  State<_TransactionItem> createState() => __TransactionItemState();
}

class __TransactionItemState extends State<_TransactionItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {
        'name': 'Chit Group A Payment',
        'amount': '-₹ 5,000',
        'date': 'Today, 10:30 AM',
        'type': 'debit',
      },
      {
        'name': 'Chit Group B Receipt',
        'amount': '+₹ 10,000',
        'date': 'Yesterday, 3:45 PM',
        'type': 'credit',
      },
      {
        'name': 'Monthly Contribution',
        'amount': '-₹ 7,500',
        'date': 'Jan 15, 2:00 PM',
        'type': 'debit',
      },
      {
        'name': 'Interest Received',
        'amount': '+₹ 2,500',
        'date': 'Jan 14, 11:20 AM',
        'type': 'credit',
      },
      {
        'name': 'Group C Payment',
        'amount': '-₹ 8,000',
        'date': 'Jan 13, 4:15 PM',
        'type': 'debit',
      },
    ];

    final transaction = transactions[widget.index];
    final isCredit = transaction['type'] == 'credit';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isHovered
              ? (isCredit
                    ? AppColors.successColor.withOpacity(0.05)
                    : AppColors.errorColor.withOpacity(0.05))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: _isHovered
              ? Border.all(
                  color: isCredit
                      ? AppColors.successColor.withOpacity(0.2)
                      : AppColors.errorColor.withOpacity(0.2),
                )
              : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCredit
                    ? AppColors.successColor.withOpacity(_isHovered ? 0.2 : 0.1)
                    : AppColors.errorColor.withOpacity(_isHovered ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                color: isCredit ? AppColors.successColor : AppColors.errorColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction['name']!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    transaction['date']!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            AnimatedScale(
              scale: _isHovered ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                transaction['amount']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCredit
                      ? AppColors.successColor
                      : AppColors.errorColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (100 * widget.index).ms).slideX(begin: 0.1),
    );
  }
}

class _UpcomingPaymentItem extends StatefulWidget {
  final int index;

  const _UpcomingPaymentItem({required this.index});

  @override
  State<_UpcomingPaymentItem> createState() => __UpcomingPaymentItemState();
}

class __UpcomingPaymentItemState extends State<_UpcomingPaymentItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final payments = [
      {'name': 'Chit Group X', 'amount': '₹ 12,000', 'date': 'Due in 2 days'},
      {'name': 'Group Y Monthly', 'amount': '₹ 8,500', 'date': 'Due in 5 days'},
      {
        'name': 'Special Contribution',
        'amount': '₹ 15,000',
        'date': 'Due in 7 days',
      },
    ];

    final payment = payments[widget.index];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isHovered
              ? Colors.orange.withOpacity(0.1)
              : Colors.orange.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.orange.withOpacity(_isHovered ? 0.3 : 0.2),
            width: _isHovered ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(_isHovered ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Colors.orange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment['name']!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    payment['date']!,
                    style: const TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                ],
              ),
            ),
            AnimatedScale(
              scale: _isHovered ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                payment['amount']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (150 * widget.index).ms).slideX(begin: 0.1),
    );
  }
}

class _ChitGroupCard extends StatefulWidget {
  final int index;

  const _ChitGroupCard({required this.index});

  @override
  State<_ChitGroupCard> createState() => __ChitGroupCardState();
}

class __ChitGroupCardState extends State<_ChitGroupCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final groups = [
      {
        'name': 'Business Group',
        'members': '15/20',
        'amount': '₹ 2,00,000',
        'status': 'Active',
      },
      {
        'name': 'Family Fund',
        'members': '8/12',
        'amount': '₹ 1,00,000',
        'status': 'Active',
      },
      {
        'name': 'Golden Chit',
        'members': '20/20',
        'amount': '₹ 5,00,000',
        'status': 'Completed',
      },
      {
        'name': 'Silver Savings',
        'members': '10/15',
        'amount': '₹ 75,000',
        'status': 'Active',
      },
    ];

    final group = groups[widget.index];
    final isCompleted = group['status'] == 'Completed';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Card(
          elevation: _isHovered ? 6 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.successColor.withOpacity(
                                _isHovered ? 0.2 : 0.1,
                              )
                            : AppColors.primaryColor.withOpacity(
                                _isHovered ? 0.2 : 0.1,
                              ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.groups,
                        color: isCompleted
                            ? AppColors.successColor
                            : AppColors.primaryColor,
                        size: 20,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.successColor.withOpacity(0.1)
                            : AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        group['status']!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isCompleted
                              ? AppColors.successColor
                              : AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  group['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  group['amount']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.people, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      group['members']!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(delay: (200 * widget.index).ms).slideY(begin: 0.1),
    );
  }
}

// Other Page Contents
class TransactionsContent extends StatelessWidget {
  const TransactionsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Transactions Page', style: TextStyle(fontSize: 24)),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.1);
  }
}

class AnalyticsContent extends StatelessWidget {
  const AnalyticsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Analytics Page', style: TextStyle(fontSize: 24)),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.1);
  }
}

class _ModernMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ModernMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDestructive
                  ? AppColors.errorColor
                  : AppColors.primaryColor,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDestructive
                    ? AppColors.errorColor
                    : Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
