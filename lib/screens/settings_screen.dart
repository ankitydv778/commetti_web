import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../providers/auth_provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/dimensions.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/responsive_widget.dart';
import '../core/utils/responsive_layout.dart';
import '../core/utils/custom_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: const MobileSettingsScreen(),
      web: const WebSettingsScreen(),
    );
  }
}

class WebSettingsScreen extends StatefulWidget {
  const WebSettingsScreen({super.key});

  @override
  State<WebSettingsScreen> createState() => _WebSettingsScreenState();
}

class _WebSettingsScreenState extends State<WebSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _autoSync = true;
  String _selectedCurrency = 'INR';
  String _dateFormat = 'DD/MM/YYYY';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final user = authProvider.user;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimensions.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode ? Colors.white : AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your app preferences and account settings',
            style: TextStyle(fontSize: 16, color: AppColors.grey),
          ),
          const SizedBox(height: Dimensions.paddingLarge),

          // Settings Sections in Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: Dimensions.paddingLarge,
            mainAxisSpacing: Dimensions.paddingLarge,
            childAspectRatio: 1.5,
            children: [
              // Account Settings
              MouseRegion(
                cursor: SystemMouseCursors.basic,
                child: _SettingsCard(
                  title: 'Account Settings',
                  icon: Icons.person,
                  color: AppColors.primaryColor,
                  child: Column(
                    children: [
                      _SettingsItem(
                        icon: Icons.person,
                        title: 'Personal Information',
                        subtitle: 'Update your name, email, and phone',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.lock,
                        title: 'Change Password',
                        subtitle: 'Update your login password',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.credit_card,
                        title: 'Payment Methods',
                        subtitle: 'Manage your payment options',
                        onTap: () {},
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1),
              ),

              // App Preferences
              MouseRegion(
                cursor: SystemMouseCursors.basic,
                child: _SettingsCard(
                  title: 'App Preferences',
                  icon: Icons.settings,
                  color: AppColors.infoColor,
                  child: Column(
                    children: [
                      _ThemeSelector(themeProvider: themeProvider),
                      _LanguageSelector(languageProvider: languageProvider),
                      _SettingsItem(
                        icon: Icons.palette,
                        title: 'App Theme',
                        subtitle: 'Customize app colors',
                        onTap: () {},
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
              ),

              // Notifications
              MouseRegion(
                cursor: SystemMouseCursors.basic,
                child: _SettingsCard(
                  title: 'Notifications',
                  icon: Icons.notifications,
                  color: AppColors.warningColor,
                  child: Column(
                    children: [
                      _SwitchSettingsItem(
                        title: 'Enable Notifications',
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                      ),
                      _SwitchSettingsItem(
                        title: 'Email Notifications',
                        value: _emailNotifications,
                        onChanged: (value) {
                          setState(() {
                            _emailNotifications = value;
                          });
                        },
                      ),
                      _SwitchSettingsItem(
                        title: 'Push Notifications',
                        value: _pushNotifications,
                        onChanged: (value) {
                          setState(() {
                            _pushNotifications = value;
                          });
                        },
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
              ),

              // Security & Privacy
              MouseRegion(
                cursor: SystemMouseCursors.basic,
                child: _SettingsCard(
                  title: 'Security & Privacy',
                  icon: Icons.security,
                  color: AppColors.successColor,
                  child: Column(
                    children: [
                      _SettingsItem(
                        icon: Icons.fingerprint,
                        title: 'Biometric Login',
                        subtitle: 'Use fingerprint or face ID',
                        trailing: Switch(value: true, onChanged: (value) {}),
                      ),
                      _SettingsItem(
                        icon: Icons.history,
                        title: 'Login History',
                        subtitle: 'View your login activity',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.privacy_tip,
                        title: 'Privacy Settings',
                        subtitle: 'Manage your data privacy',
                        onTap: () {},
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
              ),

              // Chit Fund Settings
              MouseRegion(
                cursor: SystemMouseCursors.basic,
                child: _SettingsCard(
                  title: 'Chit Fund Settings',
                  icon: Icons.account_balance_wallet,
                  color: AppColors.secondaryColor,
                  child: Column(
                    children: [
                      _DropdownSettingsItem(
                        title: 'Default Currency',
                        value: _selectedCurrency,
                        options: ['INR', 'USD', 'EUR', 'GBP'],
                        onChanged: (value) {
                          setState(() {
                            _selectedCurrency = value!;
                          });
                        },
                      ),
                      _DropdownSettingsItem(
                        title: 'Date Format',
                        value: _dateFormat,
                        options: ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD'],
                        onChanged: (value) {
                          setState(() {
                            _dateFormat = value!;
                          });
                        },
                      ),
                      _SwitchSettingsItem(
                        title: 'Auto Sync Data',
                        value: _autoSync,
                        onChanged: (value) {
                          setState(() {
                            _autoSync = value;
                          });
                        },
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.1),
              ),

              // About & Support
              MouseRegion(
                cursor: SystemMouseCursors.basic,
                child: _SettingsCard(
                  title: 'About & Support',
                  icon: Icons.help,
                  color: AppColors.grey,
                  child: Column(
                    children: [
                      _SettingsItem(
                        icon: Icons.info,
                        title: 'About ChitFund',
                        subtitle: 'App version 1.0.0',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.help_center,
                        title: 'Help Center',
                        subtitle: 'Get help and support',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.description,
                        title: 'Terms & Policies',
                        subtitle: 'Terms of service and privacy policy',
                        onTap: () {},
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingLarge),

          // Danger Zone
          MouseRegion(
            cursor: SystemMouseCursors.basic,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                side: BorderSide(color: AppColors.errorColor.withOpacity(0.2)),
              ),
              color: AppColors.errorColor.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: AppColors.errorColor),
                        const SizedBox(width: 12),
                        Text(
                          'Danger Zone',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.errorColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingDefault),
                    Text(
                      'These actions are irreversible. Please proceed with caution.',
                      style: TextStyle(
                        color: AppColors.errorColor.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingLarge),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () async {
                              final result = await CustomDialog.showConfirmation(
                                context: context,
                                title: 'Delete Account',
                                message:
                                    'Are you sure you want to delete your account? This action cannot be undone.',
                                confirmText: 'Delete Account',
                                cancelText: 'Cancel',
                                confirmColor: AppColors.errorColor,
                              );
                              if (result == true) {
                                // Delete account logic
                              }
                            },
                            text: 'Delete Account',
                            backgroundColor: AppColors.errorColor.withOpacity(
                              0.1,
                            ),
                            foregroundColor: AppColors.errorColor,
                            borderColor: AppColors.errorColor,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingDefault),
                        Expanded(
                          child: CustomButton(
                            onPressed: () async {
                              final result = await CustomDialog.showConfirmation(
                                context: context,
                                title: 'Clear All Data',
                                message:
                                    'This will remove all your chit fund data from this device.',
                                confirmText: 'Clear Data',
                                cancelText: 'Cancel',
                                confirmColor: AppColors.warningColor,
                              );
                              if (result == true) {
                                // Clear data logic
                              }
                            },
                            text: 'Clear All Data',
                            backgroundColor: AppColors.warningColor.withOpacity(
                              0.1,
                            ),
                            foregroundColor: AppColors.warningColor,
                            borderColor: AppColors.warningColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 900.ms).slideY(begin: 0.1),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const _SettingsCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  State<_SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<_SettingsCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Card(
          elevation: _isHovered ? 6 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(widget.icon, color: widget.color),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingDefault),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primaryColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ] else if (onTap != null)
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchSettingsItem extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSettingsItem({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: AppColors.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownSettingsItem extends StatefulWidget {
  final String title;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _DropdownSettingsItem({
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  State<_DropdownSettingsItem> createState() => _DropdownSettingsItemState();
}

class _DropdownSettingsItemState extends State<_DropdownSettingsItem> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              DropdownButton<String>(
                value: widget.value,
                onChanged: widget.onChanged,
                items: widget.options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                underline: Container(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final ThemeProvider themeProvider;

  const _ThemeSelector({required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Theme Mode',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _ThemeOption(
                      icon: Icons.light_mode,
                      title: 'Light',
                      isSelected: themeProvider.isLightMode,
                      onTap: () => themeProvider.setThemeMode(ThemeMode.light),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ThemeOption(
                      icon: Icons.dark_mode,
                      title: 'Dark',
                      isSelected: themeProvider.isDarkMode,
                      onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ThemeOption(
                      icon: Icons.settings,
                      title: 'Auto',
                      isSelected: themeProvider.isAutoMode,
                      onTap: () => themeProvider.setThemeMode(ThemeMode.system),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor.withOpacity(0.1)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primaryColor : Colors.grey,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.primaryColor : Colors.grey,
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

class _LanguageSelector extends StatelessWidget {
  final LanguageProvider languageProvider;

  const _LanguageSelector({required this.languageProvider});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Language',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: languageProvider.supportedLanguages.entries.map((
                  entry,
                ) {
                  final isSelected = languageProvider.isCurrentLanguage(
                    entry.key,
                  );
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => languageProvider.changeLanguage(entry.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor.withOpacity(0.1)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(languageProvider.getFlagEmoji(entry.key)),
                            const SizedBox(width: 8),
                            Text(
                              entry.value,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Mobile Settings Screen
class MobileSettingsScreen extends StatelessWidget {
  const MobileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimensions.paddingDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode ? Colors.white : AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your preferences',
            style: TextStyle(color: AppColors.grey),
          ),
          const SizedBox(height: Dimensions.paddingLarge),

          // Account Section
          _SectionTitle(title: 'Account'),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Column(
              children: [
                _MobileSettingsItem(
                  icon: Icons.person,
                  title: 'Personal Information',
                  subtitle: 'Update your profile details',
                  onTap: () {},
                ),
                _Divider(),
                _MobileSettingsItem(
                  icon: Icons.lock,
                  title: 'Change Password',
                  subtitle: 'Update your login password',
                  onTap: () {},
                ),
                _Divider(),
                _MobileSettingsItem(
                  icon: Icons.credit_card,
                  title: 'Payment Methods',
                  subtitle: 'Manage payment options',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingLarge),

          // App Preferences
          _SectionTitle(title: 'App Preferences'),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Column(
              children: [
                _MobileSettingsItem(
                  icon: Icons.palette,
                  title: 'Theme',
                  subtitle: 'Change app theme',
                  trailing: DropdownButton<ThemeMode>(
                    value: themeProvider.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('System'),
                      ),
                    ],
                    underline: Container(),
                  ),
                ),
                _Divider(),
                _MobileSettingsItem(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'Change app language',
                  trailing: DropdownButton<String>(
                    value: languageProvider.currentLocale.languageCode,
                    onChanged: (value) {
                      if (value != null) {
                        languageProvider.changeLanguage(value);
                      }
                    },
                    items: languageProvider.supportedLanguages.entries.map((
                      entry,
                    ) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    underline: Container(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingLarge),

          // Notifications
          _SectionTitle(title: 'Notifications'),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Column(
              children: [
                _MobileSwitchItem(
                  icon: Icons.notifications,
                  title: 'Push Notifications',
                  value: true,
                  onChanged: (value) {},
                ),
                _Divider(),
                _MobileSwitchItem(
                  icon: Icons.email,
                  title: 'Email Notifications',
                  value: true,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingLarge),

          // Support
          _SectionTitle(title: 'Support'),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Column(
              children: [
                _MobileSettingsItem(
                  icon: Icons.help,
                  title: 'Help Center',
                  subtitle: 'Get help and support',
                  onTap: () {},
                ),
                _Divider(),
                _MobileSettingsItem(
                  icon: Icons.description,
                  title: 'Terms & Policies',
                  subtitle: 'View terms and privacy policy',
                  onTap: () {},
                ),
                _Divider(),
                _MobileSettingsItem(
                  icon: Icons.info,
                  title: 'About',
                  subtitle: 'App version 1.0.0',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingLarge),

          // Danger Zone
          _SectionTitle(title: 'Danger Zone'),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              side: BorderSide(color: AppColors.errorColor.withOpacity(0.2)),
            ),
            color: AppColors.errorColor.withOpacity(0.05),
            child: Column(
              children: [
                _MobileSettingsItem(
                  icon: Icons.delete,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  titleColor: AppColors.errorColor,
                  onTap: () async {
                    final result = await CustomDialog.showConfirmation(
                      context: context,
                      title: 'Delete Account',
                      message:
                          'Are you sure you want to delete your account? This action cannot be undone.',
                      confirmText: 'Delete Account',
                      cancelText: 'Cancel',
                      confirmColor: AppColors.errorColor,
                    );
                    if (result == true) {
                      // Delete account logic
                    }
                  },
                ),
                _Divider(),
                _MobileSettingsItem(
                  icon: Icons.clear_all,
                  title: 'Clear All Data',
                  subtitle: 'Remove all data from this device',
                  titleColor: AppColors.warningColor,
                  onTap: () async {
                    final result = await CustomDialog.showConfirmation(
                      context: context,
                      title: 'Clear All Data',
                      message:
                          'This will remove all your chit fund data from this device.',
                      confirmText: 'Clear Data',
                      cancelText: 'Cancel',
                      confirmColor: AppColors.warningColor,
                    );
                    if (result == true) {
                      // Clear data logic
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingExtraLarge),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGrey,
        ),
      ),
    );
  }
}

class _MobileSettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _MobileSettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.titleColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: titleColor ?? AppColors.primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (onTap != null)
                const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileSwitchItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _MobileSwitchItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1),
    );
  }
}
