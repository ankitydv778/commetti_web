import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../core/widgets/custom_textfield.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/loading_overlay.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/dimensions.dart';
import '../core/utils/responsive_layout.dart';
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
  final ImagePickerService _imagePicker = ImagePickerService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    await profileProvider.pickProfileImage(context);
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      final languageProvider = Provider.of<LanguageProvider>(
        context,
        listen: false,
      );

      await profileProvider.updateProfile(
        context: context,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        gender: _selectedGender ?? 'Male',
        address: _addressController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final isWeb = ResponsiveLayout.isWeb(context);
    final user = profileProvider.user;

    return LoadingOverlay(
      isLoading: profileProvider.isLoading,
      child: Scaffold(
        appBar: isWeb
            ? null
            : AppBar(
                title: Text(
                  languageProvider.translate('my_profile') ?? 'My Profile',
                ),
                centerTitle: true,
              ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(
            isWeb ? Dimensions.paddingExtraLarge : Dimensions.paddingDefault,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isWeb)
                Text(
                  languageProvider.translate('my_profile') ?? 'My Profile',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (isWeb) const SizedBox(height: Dimensions.paddingLarge),

              // Profile Header
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: isWeb ? 150 : 120,
                          height: isWeb ? 150 : 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: profileProvider.selectedImage != null
                                ? Image.file(
                                    profileProvider.selectedImage!,
                                    fit: BoxFit.cover,
                                  )
                                : user?.profileImage != null
                                ? Image.network(
                                    user!.profileImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: AppColors.lightGrey,
                                        child: Icon(
                                          Icons.person,
                                          size: isWeb ? 60 : 40,
                                          color: AppColors.grey,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: AppColors.lightGrey,
                                    child: Icon(
                                      Icons.person,
                                      size: isWeb ? 60 : 40,
                                      color: AppColors.grey,
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: isWeb ? 40 : 36,
                            height: isWeb ? 40 : 36,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: _pickImage,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingDefault),
                    Text(
                      user?.name ?? 'User',
                      style: TextStyle(
                        fontSize: isWeb ? 24 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user?.email ?? '',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: isWeb ? 16 : 14,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingLarge),
                  ],
                ),
              ),

              // Profile Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Personal Information Section
                    Text(
                      languageProvider.translate('personal_info') ??
                          'Personal Information',
                      style: TextStyle(
                        fontSize: isWeb ? 20 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingLarge),

                    // Name Field
                    CustomTextField(
                      controller: _nameController,
                      labelText:
                          languageProvider.translate('full_name') ??
                          'Full Name',
                      hintText:
                          languageProvider.translate('enter_name') ??
                          'Enter your name',
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AppColors.grey,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return languageProvider.translate('name_required') ??
                              'Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: Dimensions.paddingDefault),

                    // Email Field (Read-only)
                    CustomTextField(
                      controller: _emailController,
                      labelText: languageProvider.translate('email') ?? 'Email',
                      hintText:
                          languageProvider.translate('enter_email') ??
                          'Enter your email',
                      prefixIcon: const Icon(
                        Icons.email,
                        color: AppColors.grey,
                      ),
                      readOnly: true,
                      enabled: false,
                    ),
                    const SizedBox(height: Dimensions.paddingDefault),

                    // Phone Field
                    CustomTextField(
                      controller: _phoneController,
                      labelText:
                          languageProvider.translate('phone') ?? 'Phone Number',
                      hintText:
                          languageProvider.translate('enter_phone') ??
                          'Enter your phone number',
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: AppColors.grey,
                      ),
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
                    ),
                    const SizedBox(height: Dimensions.paddingDefault),

                    // Gender Selection
                    Text(
                      languageProvider.translate('gender') ?? 'Gender',
                      style: TextStyle(
                        fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.isDarkMode
                            ? Colors.white70
                            : AppColors.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text(
                              languageProvider.translate('male') ?? 'Male',
                            ),
                            value: 'Male',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                            dense: true,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text(
                              languageProvider.translate('female') ?? 'Female',
                            ),
                            value: 'Female',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                            dense: true,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text(
                              languageProvider.translate('other') ?? 'Other',
                            ),
                            value: 'Other',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingDefault),

                    // Address Field
                    CustomTextField(
                      controller: _addressController,
                      labelText:
                          languageProvider.translate('address') ?? 'Address',
                      hintText:
                          languageProvider.translate('enter_address') ??
                          'Enter your address',
                      prefixIcon: const Icon(
                        Icons.location_on,
                        color: AppColors.grey,
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return languageProvider.translate(
                                'address_required',
                              ) ??
                              'Address is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: Dimensions.paddingLarge),

                    // Account Information Section
                    Text(
                      languageProvider.translate('account_info') ??
                          'Account Information',
                      style: TextStyle(
                        fontSize: isWeb ? 20 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingLarge),

                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingDefault),
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkMode
                            ? Colors.grey[900]
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(
                          Dimensions.radiusDefault,
                        ),
                      ),
                      child: Column(
                        children: [
                          _InfoRow(
                            label:
                                languageProvider.translate('member_since') ??
                                'Member Since',
                            value: user?.createdAt ?? '2024-01-01',
                          ),
                          const Divider(),
                          _InfoRow(
                            label:
                                languageProvider.translate('account_status') ??
                                'Account Status',
                            value:
                                languageProvider.translate('active') ??
                                'Active',
                            valueColor: AppColors.successColor,
                          ),
                          const Divider(),
                          _InfoRow(
                            label:
                                languageProvider.translate('last_updated') ??
                                'Last Updated',
                            value: user?.updatedAt ?? '2024-01-01',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingExtraLarge),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: _updateProfile,
                            text:
                                languageProvider.translate('save_changes') ??
                                'Save Changes',
                            isLoading: profileProvider.isUpdating,
                          ),
                        ),
                        if (isWeb)
                          const SizedBox(width: Dimensions.paddingDefault),
                        if (isWeb)
                          Expanded(
                            child: CustomButton(
                              onPressed: () {
                                _nameController.text = user?.name ?? '';
                                _phoneController.text = user?.phone ?? '';
                                _addressController.text = user?.address ?? '';
                                _selectedGender = user?.gender;
                              },
                              text:
                                  languageProvider.translate('reset') ??
                                  'Reset',
                              backgroundColor: Colors.transparent,
                              foregroundColor: AppColors.primaryColor,
                              borderColor: AppColors.primaryColor,
                            ),
                          ),
                      ],
                    ),

                    if (!isWeb)
                      const SizedBox(height: Dimensions.paddingDefault),
                    if (!isWeb)
                      CustomButton(
                        onPressed: () {
                          _nameController.text = user?.name ?? '';
                          _phoneController.text = user?.phone ?? '';
                          _addressController.text = user?.address ?? '';
                          _selectedGender = user?.gender;
                        },
                        text: languageProvider.translate('reset') ?? 'Reset',
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.primaryColor,
                        borderColor: AppColors.primaryColor,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: themeProvider.isDarkMode
                  ? Colors.white70
                  : AppColors.darkGrey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color:
                  valueColor ??
                  (themeProvider.isDarkMode ? Colors.white : AppColors.black),
            ),
          ),
        ],
      ),
    );
  }
}
