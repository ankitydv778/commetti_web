import 'package:committee/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../core/widgets/responsive_widget.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/dimensions.dart';
import 'profile_screen.dart';
import 'web/web_dashboard.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return ResponsiveWidget(
      mobile: _MobileDashboard(user: user),
      web: const WebDashboard(),
    );
  }
}

class _MobileDashboard extends StatelessWidget {
  final UserModel? user;

  const _MobileDashboard({this.user});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.translate('dashboard') ?? 'Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
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
                    '${languageProvider.translate('welcome')}, ${user?.name ?? 'User'}!',
                    style: const TextStyle(
                      fontSize: Dimensions.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    languageProvider.translate('dashboard_welcome') ??
                        'Here\'s your financial overview',
                    style: const TextStyle(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingLarge),

            // Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: Dimensions.paddingDefault,
              mainAxisSpacing: Dimensions.paddingDefault,
              childAspectRatio: 1.5,
              children: [
                _StatCard(
                  title:
                      languageProvider.translate('total_balance') ??
                      'Total Balance',
                  value: '₹ 1,25,000',
                  icon: Icons.account_balance_wallet,
                  color: AppColors.successColor,
                ),
                _StatCard(
                  title:
                      languageProvider.translate('active_chits') ??
                      'Active Chits',
                  value: '5',
                  icon: Icons.assignment,
                  color: AppColors.infoColor,
                ),
                _StatCard(
                  title:
                      languageProvider.translate('completed_chits') ??
                      'Completed Chits',
                  value: '12',
                  icon: Icons.check_circle,
                  color: AppColors.warningColor,
                ),
                _StatCard(
                  title:
                      languageProvider.translate('pending_payments') ??
                      'Pending Payments',
                  value: '₹ 25,000',
                  icon: Icons.payment,
                  color: AppColors.errorColor,
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingLarge),

            // Quick Actions
            Text(
              languageProvider.translate('quick_actions') ?? 'Quick Actions',
              style: const TextStyle(
                fontSize: Dimensions.fontSizeMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Dimensions.paddingDefault),
            Wrap(
              spacing: Dimensions.paddingDefault,
              runSpacing: Dimensions.paddingDefault,
              children: [
                _ActionButton(
                  icon: Icons.person,
                  label: languageProvider.translate('profile') ?? 'Profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.add_circle,
                  label: languageProvider.translate('new_chit') ?? 'New Chit',
                  onTap: () {},
                ),
                _ActionButton(
                  icon: Icons.history,
                  label: languageProvider.translate('history') ?? 'History',
                  onTap: () {},
                ),
                _ActionButton(
                  icon: Icons.settings,
                  label: languageProvider.translate('settings') ?? 'Settings',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingLarge),

            // Recent Transactions
            _RecentTransactions(languageProvider: languageProvider),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      Dimensions.radiusDefault,
                    ),
                  ),
                  child: Icon(icon, color: color),
                ),
                const Icon(Icons.more_vert, color: Colors.grey),
              ],
            ),
            const SizedBox(height: Dimensions.paddingDefault),
            Text(
              value,
              style: const TextStyle(
                fontSize: Dimensions.fontSizeLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: Dimensions.fontSizeSmall,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(Dimensions.paddingDefault),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 30),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: Dimensions.fontSizeSmall,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  final LanguageProvider languageProvider;

  const _RecentTransactions({required this.languageProvider});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
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
                Text(
                  languageProvider.translate('recent_transactions') ??
                      'Recent Transactions',
                  style: const TextStyle(
                    fontSize: Dimensions.fontSizeMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    languageProvider.translate('view_all') ?? 'View All',
                    style: const TextStyle(color: AppColors.primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingDefault),
            ...List.generate(3, (index) => _TransactionItem(index: index)),
          ],
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final int index;

  const _TransactionItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {
        'name': 'Chit Group A',
        'amount': '₹ 5,000',
        'type': 'Payment',
        'date': 'Today',
      },
      {
        'name': 'Chit Group B',
        'amount': '₹ 10,000',
        'type': 'Receipt',
        'date': 'Yesterday',
      },
      {
        'name': 'Chit Group C',
        'amount': '₹ 7,500',
        'type': 'Payment',
        'date': '2 days ago',
      },
    ];

    final transaction = transactions[index];

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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: transaction['type'] == 'Receipt'
                  ? AppColors.successColor.withOpacity(0.1)
                  : AppColors.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Icon(
              transaction['type'] == 'Receipt'
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: transaction['type'] == 'Receipt'
                  ? AppColors.successColor
                  : AppColors.errorColor,
            ),
          ),
          const SizedBox(width: Dimensions.paddingDefault),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['name']!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  transaction['date']!,
                  style: const TextStyle(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            transaction['amount']!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: transaction['type'] == 'Receipt'
                  ? AppColors.successColor
                  : AppColors.errorColor,
            ),
          ),
        ],
      ),
    );
  }
}
