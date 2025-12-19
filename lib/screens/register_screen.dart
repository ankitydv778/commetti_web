import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../core/widgets/custom_textfield.dart';
import '../core/widgets/custom_button.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/dimensions.dart';
import '../core/utils/responsive_layout.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedGender;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final languageProvider = Provider.of<LanguageProvider>(
        context,
        listen: false,
      );

      bool success = await authProvider.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        gender: _selectedGender ?? 'Male',
        address: _addressController.text.trim(),
        context: context,
      );

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final isWeb = ResponsiveLayout.isWeb(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 800 : double.infinity,
            ),
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo/Title for Mobile
                  if (!isWeb) ...[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        size: 50,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      languageProvider.translate('create_account') ??
                          'Create Account',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      languageProvider.translate('join_chit_fund') ??
                          'Join our chit fund community',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],

                  // Registration Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(isWeb ? 40 : 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (isWeb) ...[
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet,
                                size: 40,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              languageProvider.translate('create_account') ??
                                  'Create Account',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              languageProvider.translate('join_chit_fund') ??
                                  'Join our chit fund community',
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],

                          // Two Column Layout for Web
                          if (isWeb) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      // Name Field
                                      CustomTextField(
                                        controller: _nameController,
                                        labelText:
                                            languageProvider.translate(
                                              'full_name',
                                            ) ??
                                            'Full Name',
                                        hintText:
                                            languageProvider.translate(
                                              'enter_name',
                                            ) ??
                                            'Enter your name',
                                        prefixIcon: const Icon(
                                          Icons.person,
                                          color: AppColors.grey,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return languageProvider.translate(
                                                  'name_required',
                                                ) ??
                                                'Name is required';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),

                                      // Email Field
                                      CustomTextField(
                                        controller: _emailController,
                                        labelText:
                                            languageProvider.translate(
                                              'email',
                                            ) ??
                                            'Email',
                                        hintText:
                                            languageProvider.translate(
                                              'enter_email',
                                            ) ??
                                            'Enter your email',
                                        prefixIcon: const Icon(
                                          Icons.email,
                                          color: AppColors.grey,
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return languageProvider.translate(
                                                  'email_required',
                                                ) ??
                                                'Email is required';
                                          }
                                          if (!RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                          ).hasMatch(value)) {
                                            return languageProvider.translate(
                                                  'valid_email',
                                                ) ??
                                                'Enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),

                                      // Phone Field
                                      CustomTextField(
                                        controller: _phoneController,
                                        labelText:
                                            languageProvider.translate(
                                              'phone',
                                            ) ??
                                            'Phone Number',
                                        hintText:
                                            languageProvider.translate(
                                              'enter_phone',
                                            ) ??
                                            'Enter your phone number',
                                        prefixIcon: const Icon(
                                          Icons.phone,
                                          color: AppColors.grey,
                                        ),
                                        keyboardType: TextInputType.phone,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return languageProvider.translate(
                                                  'phone_required',
                                                ) ??
                                                'Phone is required';
                                          }
                                          if (!RegExp(
                                            r'^[0-9]{10}$',
                                          ).hasMatch(value)) {
                                            return languageProvider.translate(
                                                  'valid_phone',
                                                ) ??
                                                'Enter a valid phone number';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                  child: Column(
                                    children: [
                                      // Password Field
                                      CustomTextField(
                                        controller: _passwordController,
                                        labelText:
                                            languageProvider.translate(
                                              'password',
                                            ) ??
                                            'Password',
                                        hintText:
                                            languageProvider.translate(
                                              'enter_password',
                                            ) ??
                                            'Enter your password',
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color: AppColors.grey,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: AppColors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                        ),
                                        obscureText: _obscurePassword,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return languageProvider.translate(
                                                  'password_required',
                                                ) ??
                                                'Password is required';
                                          }
                                          if (value.length < 6) {
                                            return languageProvider.translate(
                                                  'password_min_length',
                                                ) ??
                                                'Password must be at least 6 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),

                                      // Confirm Password Field
                                      CustomTextField(
                                        controller: _confirmPasswordController,
                                        labelText:
                                            languageProvider.translate(
                                              'confirm_password',
                                            ) ??
                                            'Confirm Password',
                                        hintText:
                                            languageProvider.translate(
                                              'enter_confirm_password',
                                            ) ??
                                            'Confirm your password',
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color: AppColors.grey,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureConfirmPassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: AppColors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureConfirmPassword =
                                                  !_obscureConfirmPassword;
                                            });
                                          },
                                        ),
                                        obscureText: _obscureConfirmPassword,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return languageProvider.translate(
                                                  'confirm_password_required',
                                                ) ??
                                                'Please confirm your password';
                                          }
                                          if (value !=
                                              _passwordController.text) {
                                            return languageProvider.translate(
                                                  'password_not_match',
                                                ) ??
                                                'Passwords do not match';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),

                                      // Gender Selection
                                      _buildGenderField(languageProvider),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Address Field (Full Width)
                            CustomTextField(
                              controller: _addressController,
                              labelText:
                                  languageProvider.translate('address') ??
                                  'Address',
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
                            const SizedBox(height: 30),
                          ] else ...[
                            // Mobile Layout
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
                                  return languageProvider.translate(
                                        'name_required',
                                      ) ??
                                      'Name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Email Field
                            CustomTextField(
                              controller: _emailController,
                              labelText:
                                  languageProvider.translate('email') ??
                                  'Email',
                              hintText:
                                  languageProvider.translate('enter_email') ??
                                  'Enter your email',
                              prefixIcon: const Icon(
                                Icons.email,
                                color: AppColors.grey,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return languageProvider.translate(
                                        'email_required',
                                      ) ??
                                      'Email is required';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return languageProvider.translate(
                                        'valid_email',
                                      ) ??
                                      'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Phone Field
                            CustomTextField(
                              controller: _phoneController,
                              labelText:
                                  languageProvider.translate('phone') ??
                                  'Phone Number',
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
                                  return languageProvider.translate(
                                        'phone_required',
                                      ) ??
                                      'Phone is required';
                                }
                                if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                  return languageProvider.translate(
                                        'valid_phone',
                                      ) ??
                                      'Enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Password Field
                            CustomTextField(
                              controller: _passwordController,
                              labelText:
                                  languageProvider.translate('password') ??
                                  'Password',
                              hintText:
                                  languageProvider.translate(
                                    'enter_password',
                                  ) ??
                                  'Enter your password',
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: AppColors.grey,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              obscureText: _obscurePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return languageProvider.translate(
                                        'password_required',
                                      ) ??
                                      'Password is required';
                                }
                                if (value.length < 6) {
                                  return languageProvider.translate(
                                        'password_min_length',
                                      ) ??
                                      'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Confirm Password Field
                            CustomTextField(
                              controller: _confirmPasswordController,
                              labelText:
                                  languageProvider.translate(
                                    'confirm_password',
                                  ) ??
                                  'Confirm Password',
                              hintText:
                                  languageProvider.translate(
                                    'enter_confirm_password',
                                  ) ??
                                  'Confirm your password',
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: AppColors.grey,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              obscureText: _obscureConfirmPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return languageProvider.translate(
                                        'confirm_password_required',
                                      ) ??
                                      'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return languageProvider.translate(
                                        'password_not_match',
                                      ) ??
                                      'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Gender Selection
                            _buildGenderField(languageProvider),
                            const SizedBox(height: 20),

                            // Address Field
                            CustomTextField(
                              controller: _addressController,
                              labelText:
                                  languageProvider.translate('address') ??
                                  'Address',
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
                            const SizedBox(height: 30),
                          ],

                          // Register Button
                          CustomButton(
                            onPressed: _register,
                            text:
                                languageProvider.translate('register') ??
                                'Register',
                            isLoading: authProvider.isLoading,
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            width: isWeb ? 300 : double.infinity,
                          ),
                          const SizedBox(height: 20),

                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                languageProvider.translate('have_account') ??
                                    'Already have an account?',
                                style: const TextStyle(color: AppColors.grey),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  languageProvider.translate('login') ??
                                      'Login',
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderField(LanguageProvider languageProvider) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: Column(
            children: [
              RadioListTile<String>(
                title: Text(languageProvider.translate('male') ?? 'Male'),
                value: 'Male',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                dense: true,
              ),
              RadioListTile<String>(
                title: Text(languageProvider.translate('female') ?? 'Female'),
                value: 'Female',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                dense: true,
              ),
              RadioListTile<String>(
                title: Text(languageProvider.translate('other') ?? 'Other'),
                value: 'Other',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                dense: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
