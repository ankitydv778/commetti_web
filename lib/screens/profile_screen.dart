import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

import '../data/models/user_model.dart';
import '../providers/profile_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../core/widgets/custom_textfield.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/loading_overlay.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/dimensions.dart';
import '../core/utils/responsive_layout.dart';
import '../core/utils/custom_dialog.dart';
import '../core/services/image_picker_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedGender;
  bool _isEditing = false;
  final ImagePickerService _imagePicker = ImagePickerService();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadUserData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    final user = profileProvider.user;

    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
      _addressController.text = user.address ?? '';
      _selectedGender = user.gender;
    }
  }

  Future<void> _pickImage() async {
    final result = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Change Profile Picture',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ImageOption(
                    icon: Iconsax.gallery,
                    label: 'Gallery',
                    color: AppColors.primaryColor,
                    onTap: () {
                      Navigator.pop(context, 'gallery');
                    },
                  ),
                  _ImageOption(
                    icon: Iconsax.camera,
                    label: 'Camera',
                    color: AppColors.secondaryColor,
                    onTap: () {
                      Navigator.pop(context, 'camera');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );

    if (result == 'gallery') {
      await _pickFromGallery();
    } else if (result == 'camera') {
      await _captureFromCamera();
    }
  }

  Future<void> _pickFromGallery() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    await profileProvider.pickProfileImage(context);
  }

  Future<void> _captureFromCamera() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    final image = await _imagePicker.captureImage(
      context: context,
      addWatermark: true,
      watermarkText: 'ChitFund App',
    );

    if (image != null) {
      await profileProvider.uploadProfileImage(context);
    }
  }

  void _toggleEditMode() {
    if (!_isEditing) {
      setState(() {
        _isEditing = true;
      });
    } else {
      _saveChanges();
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      final languageProvider = Provider.of<LanguageProvider>(
        context,
        listen: false,
      );

      bool success = true;
      // bool success = await profileProvider.updateProfile(
      //   context: context,
      //   name: _nameController.text.trim(),
      //   phone: _phoneController.text.trim(),
      //   gender: _selectedGender ?? 'Male',
      //   address: _addressController.text.trim(),
      // );

      if (success) {
        setState(() {
          _isEditing = false;
        });

        // Show success toast
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Profile updated successfully'),
              ],
            ),
            backgroundColor: AppColors.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _resetForm() {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    final user = profileProvider.user;

    _nameController.text = user?.name ?? '';
    _phoneController.text = user?.phone ?? '';
    _addressController.text = user?.address ?? '';
    _selectedGender = user?.gender;

    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final isWeb = ResponsiveLayout.isWeb(context);
    final user = profileProvider.user;

    return LoadingOverlay(
      isLoading: profileProvider.isLoading || profileProvider.isUpdating,
      message: profileProvider.isUpdating
          ? 'Updating profile...'
          : 'Loading...',
      child: Scaffold(
        backgroundColor: isDarkMode
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: isWeb ? 200 : 180,
                floating: false,
                pinned: true,
                backgroundColor: isDarkMode ? AppColors.darkCard : Colors.white,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryColor.withOpacity(0.8),
                          AppColors.primaryColor.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Stack(
                            children: [
                              _buildProfileImage(profileProvider, user, isWeb),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Iconsax.camera,
                                      color: AppColors.primaryColor,
                                      size: 20,
                                    ),
                                    onPressed: _pickImage,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                title: AnimatedOpacity(
                  opacity: innerBoxIsScrolled ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Text(
                    languageProvider.translate('my_profile') ?? 'My Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : AppColors.darkGrey,
                    ),
                  ),
                ),
                actions: [
                  if (innerBoxIsScrolled)
                    IconButton(
                      icon: Icon(
                        _isEditing ? Iconsax.tick_circle : Iconsax.edit_2,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: _toggleEditMode,
                      tooltip: _isEditing ? 'Save Changes' : 'Edit Profile',
                    ),
                ],
              ),
            ];
          },
          body: Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: 20,
                left: isWeb ? 40 : 20,
                right: isWeb ? 40 : 20,
                bottom: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Card
                  _UserInfoCard(
                    name: user?.name ?? 'User',
                    email: user?.email ?? '',
                    isWeb: isWeb,
                  ),
                  SizedBox(height: 24),

                  // Edit/Save Button for Web
                  if (isWeb)
                    Container(
                      margin: EdgeInsets.only(bottom: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (_isEditing)
                            CustomButton(
                              onPressed: _resetForm,
                              text:
                                  languageProvider.translate('cancel') ??
                                  'Cancel',
                              backgroundColor: Colors.transparent,
                              foregroundColor: AppColors.errorColor,
                              borderColor: AppColors.errorColor,
                              width: 120,
                            ).animate().fadeIn(duration: 300.ms),
                          SizedBox(width: 12),
                          CustomButton(
                            onPressed: _toggleEditMode,
                            text: _isEditing
                                ? (languageProvider.translate('save_changes') ??
                                      'Save Changes')
                                : (languageProvider.translate('edit_profile') ??
                                      'Edit Profile'),
                            icon: _isEditing
                                ? Icon(Iconsax.tick_circle, size: 20)
                                : Icon(Iconsax.edit_2, size: 20),
                            width: 180,
                            // gradient: LinearGradient(
                            //   colors: [
                            //     AppColors.primaryColor,
                            //     AppColors.secondaryColor,
                            //   ],
                            // ),
                          ).animate().fadeIn(duration: 300.ms),
                        ],
                      ),
                    ),

                  // Personal Information
                  _SectionHeader(
                    title:
                        languageProvider.translate('personal_info') ??
                        'Personal Information',
                    isWeb: isWeb,
                  ),
                  SizedBox(height: 16),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _isEditing
                        ? _buildEditableForm(languageProvider, themeProvider)
                        : _buildViewMode(user, languageProvider, themeProvider),
                  ),
                  SizedBox(height: 32),

                  // Account Information
                  _SectionHeader(
                    title:
                        languageProvider.translate('account_info') ??
                        'Account Information',
                    isWeb: isWeb,
                  ),
                  SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _AccountInfoTile(
                          icon: Iconsax.calendar,
                          title:
                              languageProvider.translate('member_since') ??
                              'Member Since',
                          value: user?.createdAt ?? '2024-01-01',
                          delay: 100,
                        ),
                        Divider(color: Colors.grey.shade200, height: 24),
                        _AccountInfoTile(
                          icon: Iconsax.refresh,
                          title:
                              languageProvider.translate('last_updated') ??
                              'Last Updated',
                          value: user?.updatedAt ?? '2024-01-01',
                          delay: 200,
                        ),
                        Divider(color: Colors.grey.shade200, height: 24),
                        _AccountInfoTile(
                          icon: Iconsax.shield_tick,
                          title:
                              languageProvider.translate(
                                'verification_status',
                              ) ??
                              'Verification Status',
                          value:
                              languageProvider.translate('verified') ??
                              'Verified',
                          isVerified: true,
                          delay: 300,
                        ),
                      ],
                    ),
                  ),

                  // Mobile Edit Buttons
                  if (!isWeb && _isEditing)
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              onPressed: _resetForm,
                              text:
                                  languageProvider.translate('cancel') ??
                                  'Cancel',
                              backgroundColor: Colors.transparent,
                              foregroundColor: AppColors.errorColor,
                              borderColor: AppColors.errorColor,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              onPressed: _saveChanges,
                              text:
                                  languageProvider.translate('save') ?? 'Save',
                              icon: Icon(Iconsax.tick_circle, size: 20),
                              // gradient: LinearGradient(
                              //   colors: [
                              //     AppColors.primaryColor,
                              //     AppColors.secondaryColor,
                              //   ],
                              // ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: !isWeb && !_isEditing
            ? FloatingActionButton(
                onPressed: _toggleEditMode,
                backgroundColor: AppColors.primaryColor,
                child: Icon(Iconsax.edit_2, color: Colors.white),
              ).animate().scale(delay: 500.ms)
            : null,
      ),
    );
  }

  Widget _buildProfileImage(
    ProfileProvider profileProvider,
    UserModel? user,
    bool isWeb,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      width: isWeb ? 120 : 100,
      height: isWeb ? 120 : 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: profileProvider.selectedImage != null
              ? Image.file(
                  profileProvider.selectedImage!,
                  fit: BoxFit.cover,
                  key: ValueKey('selected'),
                )
              : user?.profileImage != null
              ? Image.network(
                  user!.profileImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildDefaultAvatar(isWeb, isDarkMode);
                  },
                  key: ValueKey('network'),
                )
              : _buildDefaultAvatar(isWeb, isDarkMode),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(bool isWeb, bool isDarkMode) {
    return Container(
      color: AppColors.primaryColor.withOpacity(0.1),
      child: Icon(
        Iconsax.user,
        size: isWeb ? 50 : 40,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildViewMode(
    UserModel? user,
    LanguageProvider languageProvider,
    ThemeProvider themeProvider,
  ) {
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Iconsax.user,
            label: languageProvider.translate('full_name') ?? 'Full Name',
            value: user?.name ?? 'Not set',
            delay: 100,
          ),
          SizedBox(height: 16),
          _InfoRow(
            icon: Iconsax.sms,
            label: languageProvider.translate('email') ?? 'Email',
            value: user?.email ?? 'Not set',
            delay: 200,
          ),
          SizedBox(height: 16),
          _InfoRow(
            icon: Iconsax.call,
            label: languageProvider.translate('phone') ?? 'Phone',
            value: user?.phone ?? 'Not set',
            delay: 300,
          ),
          SizedBox(height: 16),
          _InfoRow(
            icon: Iconsax.profile_2user,
            label: languageProvider.translate('gender') ?? 'Gender',
            value: user?.gender ?? 'Not set',
            delay: 400,
          ),
          SizedBox(height: 16),
          _InfoRow(
            icon: Iconsax.location,
            label: languageProvider.translate('address') ?? 'Address',
            value: user?.address ?? 'Not set',
            delay: 500,
          ),
        ],
      ),
    );
  }

  Widget _buildEditableForm(
    LanguageProvider languageProvider,
    ThemeProvider themeProvider,
  ) {
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _nameController,
              labelText: languageProvider.translate('full_name') ?? 'Full Name',
              hintText:
                  languageProvider.translate('enter_name') ?? 'Enter your name',
              prefixIcon: Icon(Iconsax.user, color: AppColors.grey),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return languageProvider.translate('name_required') ??
                      'Name is required';
                }
                return null;
              },
              //    filled: true,
              fillColor: isDarkMode
                  ? Colors.grey.shade900
                  : Colors.grey.shade50,
            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
            SizedBox(height: 16),

            CustomTextField(
              controller: _emailController,
              labelText: languageProvider.translate('email') ?? 'Email',
              hintText:
                  languageProvider.translate('enter_email') ??
                  'Enter your email',
              prefixIcon: Icon(Iconsax.sms, color: AppColors.grey),
              readOnly: true,
              enabled: false,
              //     filled: true,
              fillColor: isDarkMode
                  ? Colors.grey.shade800
                  : Colors.grey.shade100,
            ),
            SizedBox(height: 16),

            CustomTextField(
              controller: _phoneController,
              labelText: languageProvider.translate('phone') ?? 'Phone Number',
              hintText:
                  languageProvider.translate('enter_phone') ??
                  'Enter your phone number',
              prefixIcon: Icon(Iconsax.call, color: AppColors.grey),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return languageProvider.translate('phone_required') ??
                      'Phone is required';
                }
                if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                  return languageProvider.translate('valid_phone') ??
                      'Enter a valid phone number';
                }
                return null;
              },
              //  filled: true,
              fillColor: isDarkMode
                  ? Colors.grey.shade900
                  : Colors.grey.shade50,
            ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
            SizedBox(height: 16),

            // Gender Selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageProvider.translate('gender') ?? 'Gender',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white70 : AppColors.darkGrey,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _GenderChip(
                        icon: Iconsax.man,
                        label: languageProvider.translate('male') ?? 'Male',
                        isSelected: _selectedGender == 'Male',
                        onTap: () => setState(() => _selectedGender = 'Male'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _GenderChip(
                        icon: Iconsax.woman,
                        label: languageProvider.translate('female') ?? 'Female',
                        isSelected: _selectedGender == 'Female',
                        onTap: () => setState(() => _selectedGender = 'Female'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _GenderChip(
                        icon: Iconsax.profile_2user,
                        label: languageProvider.translate('other') ?? 'Other',
                        isSelected: _selectedGender == 'Other',
                        onTap: () => setState(() => _selectedGender = 'Other'),
                      ),
                    ),
                  ],
                ),
              ],
            ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1),
            SizedBox(height: 16),

            CustomTextField(
              controller: _addressController,
              labelText: languageProvider.translate('address') ?? 'Address',
              hintText:
                  languageProvider.translate('enter_address') ??
                  'Enter your address',
              prefixIcon: Icon(Iconsax.location, color: AppColors.grey),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return languageProvider.translate('address_required') ??
                      'Address is required';
                }
                return null;
              },
              //   filled: true,
              fillColor: isDarkMode
                  ? Colors.grey.shade900
                  : Colors.grey.shade50,
            ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
          ],
        ),
      ),
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  final String name;
  final String email;
  final bool isWeb;

  const _UserInfoCard({
    required this.name,
    required this.email,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: isWeb ? 24 : 20,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? Colors.white : AppColors.darkGrey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: isWeb ? 14 : 12,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.successColor.withOpacity(0.1),
                        AppColors.successColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.successColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Active',
                        style: TextStyle(
                          color: AppColors.successColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isWeb)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.secondaryColor],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.star, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Premium',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isWeb;

  const _SectionHeader({required this.title, required this.isWeb});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.secondaryColor],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: isWeb ? 20 : 18,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : AppColors.darkGrey,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final int delay;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: delay.ms).slideX(begin: -0.1);
  }
}

class _GenderChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(isDarkMode ? 0.3 : 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : isDarkMode
                ? Colors.grey.shade700
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.1),
                    AppColors.secondaryColor.withOpacity(0.05),
                  ],
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryColor : AppColors.grey,
              size: 18,
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? AppColors.primaryColor : AppColors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isVerified;
  final int delay;

  const _AccountInfoTile({
    required this.icon,
    required this.title,
    required this.value,
    this.isVerified = false,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppColors.primaryColor),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : AppColors.darkGrey,
                    ),
                  ),
                  if (isVerified) ...[
                    SizedBox(width: 6),
                    Icon(
                      Iconsax.verify,
                      color: AppColors.successColor,
                      size: 16,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: delay.ms).slideX(begin: 0.1);
  }
}

class _ImageOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ImageOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
