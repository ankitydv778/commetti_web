import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/widgets/responsive_widget.dart';
import '../profile_screen.dart';

class WebDashboard extends StatefulWidget {
  const WebDashboard({super.key});

  @override
  State<WebDashboard> createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const _DashboardContent(),
    const ProfileScreen(),
    const _SettingsContent(),
    const _ReportsContent(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode
                  ? AppColors.darkSecondary
                  : Colors.white,
              border: Border(
                right: BorderSide(color: AppColors.lightGrey, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingLarge),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        languageProvider.translate('appName') ?? 'Chit Fund',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),

                // User Info
                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingDefault),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: authProvider.user?.profileImage != null
                            ? NetworkImage(authProvider.user!.profileImage!)
                            : null,
                        child: authProvider.user?.profileImage == null
                            ? Icon(
                                Icons.person,
                                size: 40,
                                color: AppColors.grey,
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        authProvider.user?.name ?? 'User',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : AppColors.black,
                        ),
                      ),
                      Text(
                        authProvider.user?.email ?? '',
                        style: TextStyle(color: AppColors.grey, fontSize: 12),
                      ),
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
                        label:
                            languageProvider.translate('dashboard') ??
                            'Dashboard',
                        isSelected: _selectedIndex == 0,
                        onTap: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                          _pageController.jumpToPage(0);
                        },
                      ),
                      _NavItem(
                        icon: Icons.person,
                        label:
                            languageProvider.translate('profile') ?? 'Profile',
                        isSelected: _selectedIndex == 1,
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                          _pageController.jumpToPage(1);
                        },
                      ),
                      _NavItem(
                        icon: Icons.settings,
                        label:
                            languageProvider.translate('settings') ??
                            'Settings',
                        isSelected: _selectedIndex == 2,
                        onTap: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                          _pageController.jumpToPage(2);
                        },
                      ),
                      _NavItem(
                        icon: Icons.analytics,
                        label:
                            languageProvider.translate('reports') ?? 'Reports',
                        isSelected: _selectedIndex == 3,
                        onTap: () {
                          setState(() {
                            _selectedIndex = 3;
                          });
                          _pageController.jumpToPage(3);
                        },
                      ),
                      _NavItem(
                        icon: Icons.help,
                        label: languageProvider.translate('help') ?? 'Help',
                        isSelected: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                // Theme Toggle
                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingDefault),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            themeProvider.isDarkMode
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            color: AppColors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            themeProvider.isDarkMode
                                ? languageProvider.translate('dark_mode') ??
                                      'Dark'
                                : languageProvider.translate('light_mode') ??
                                      'Light',
                            style: TextStyle(color: AppColors.grey),
                          ),
                        ],
                      ),
                      Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) => themeProvider.toggleTheme(),
                        activeColor: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ),

                // Logout
                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingDefault),
                  child: ElevatedButton.icon(
                    onPressed: () => authProvider.logout(context),
                    icon: const Icon(Icons.logout, size: 20),
                    label: Text(
                      languageProvider.translate('logout') ?? 'Logout',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorColor.withOpacity(0.1),
                      foregroundColor: AppColors.errorColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radiusDefault,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // App Bar
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
                      bottom: BorderSide(color: AppColors.lightGrey, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Row(
                        children: [
                          // Language Selector
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              languageProvider.changeLanguage(value);
                            },
                            itemBuilder: (context) {
                              return languageProvider.supportedLanguages.entries
                                  .map((entry) {
                                    return PopupMenuItem<String>(
                                      value: entry.key,
                                      child: Row(
                                        children: [
                                          Text(
                                            languageProvider.getFlagEmoji(
                                              entry.key,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(entry.value),
                                          if (languageProvider
                                              .isCurrentLanguage(entry.key))
                                            const SizedBox(width: 10),
                                          if (languageProvider
                                              .isCurrentLanguage(entry.key))
                                            const Icon(Icons.check, size: 16),
                                        ],
                                      ),
                                    );
                                  })
                                  .toList();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingDefault,
                                vertical: Dimensions.paddingSmall,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.lightGrey),
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radiusDefault,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(languageProvider.currentFlagEmoji),
                                  const SizedBox(width: 8),
                                  Text(languageProvider.currentLanguageName),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_drop_down, size: 20),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Notifications
                          IconButton(
                            icon: const Icon(Icons.notifications),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 16),

                          // Search
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Page View
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _pages,
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
        return languageProvider.translate('dashboard') ?? 'Dashboard';
      case 1:
        return languageProvider.translate('profile') ?? 'Profile';
      case 2:
        return languageProvider.translate('settings') ?? 'Settings';
      case 3:
        return languageProvider.translate('reports') ?? 'Reports';
      default:
        return '';
    }
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? AppColors.primaryColor
            : themeProvider.isDarkMode
            ? Colors.white70
            : AppColors.grey,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? AppColors.primaryColor
              : themeProvider.isDarkMode
              ? Colors.white70
              : AppColors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: AppColors.primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimensions.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Dimensions.paddingLarge),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageProvider.translate('welcome_message') ??
                      'Welcome to Chit Fund App',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  languageProvider.translate('dashboard_subtitle') ??
                      'Manage your chits efficiently',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingLarge),

          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: Dimensions.paddingLarge,
            mainAxisSpacing: Dimensions.paddingLarge,
            childAspectRatio: 1.5,
            children: [
              _WebStatCard(
                title:
                    languageProvider.translate('total_chits') ?? 'Total Chits',
                value: '17',
                change: '+2 this month',
                icon: Icons.groups,
                color: AppColors.primaryColor,
              ),
              _WebStatCard(
                title:
                    languageProvider.translate('total_investment') ??
                    'Total Investment',
                value: '₹ 2,50,000',
                change: '+12% from last month',
                icon: Icons.trending_up,
                color: AppColors.successColor,
              ),
              _WebStatCard(
                title:
                    languageProvider.translate('total_returns') ??
                    'Total Returns',
                value: '₹ 75,000',
                change: '+8% from last month',
                icon: Icons.attach_money,
                color: AppColors.warningColor,
              ),
              _WebStatCard(
                title:
                    languageProvider.translate('active_members') ??
                    'Active Members',
                value: '48',
                change: '+5 this month',
                icon: Icons.people,
                color: AppColors.infoColor,
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingLarge),

          // Charts and Recent Activity
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _ActivityChart(languageProvider: languageProvider),
              ),
              const SizedBox(width: Dimensions.paddingLarge),
              Expanded(
                flex: 1,
                child: _RecentActivity(languageProvider: languageProvider),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WebStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final Color color;

  const _WebStatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      Dimensions.radiusDefault,
                    ),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Icon(Icons.more_vert, color: Colors.grey),
              ],
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              change,
              style: TextStyle(
                fontSize: 12,
                color: change.contains('+')
                    ? AppColors.successColor
                    : AppColors.errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityChart extends StatelessWidget {
  final LanguageProvider languageProvider;

  const _ActivityChart({required this.languageProvider});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageProvider.translate('activity_overview') ??
                  'Activity Overview',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Dimensions.paddingLarge),
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightGrey),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Center(
                child: Text(
                  languageProvider.translate('chart_placeholder') ??
                      'Chart will be displayed here',
                  style: const TextStyle(color: AppColors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  final LanguageProvider languageProvider;

  const _RecentActivity({required this.languageProvider});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageProvider.translate('recent_activity') ??
                  'Recent Activity',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Dimensions.paddingDefault),
            ...List.generate(5, (index) => _ActivityItem(index: index)),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final int index;

  const _ActivityItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'action': 'Payment Received',
        'details': 'From Chit Group A',
        'time': '10 min ago',
      },
      {
        'action': 'New Member Joined',
        'details': 'Chit Group B',
        'time': '1 hour ago',
      },
      {
        'action': 'Payment Made',
        'details': 'To Chit Group C',
        'time': '2 hours ago',
      },
      {
        'action': 'Chit Started',
        'details': 'Group D - ₹ 50,000',
        'time': '5 hours ago',
      },
      {
        'action': 'Profile Updated',
        'details': 'Changed phone number',
        'time': '1 day ago',
      },
    ];

    final activity = activities[index];

    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingDefault),
      padding: const EdgeInsets.all(Dimensions.paddingDefault),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.successColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['action']!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  activity['details']!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            activity['time']!,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  const _SettingsContent();

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Center(
      child: Text(
        languageProvider.translate('settings') ?? 'Settings Page',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}

class _ReportsContent extends StatelessWidget {
  const _ReportsContent();

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Center(
      child: Text(
        languageProvider.translate('reports') ?? 'Reports Page',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
