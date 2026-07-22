import 'package:bloctestapp/bloc/auth/auth_bloc.dart';
import 'package:bloctestapp/bloc/auth/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isAgreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 450;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Center(
          child: Container(
            width: isDesktop ? 390 : double.infinity,
            height: isDesktop ? 650 : double.infinity,
            margin: isDesktop ? null : EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            decoration: isDesktop
                ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 60,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  )
                : const BoxDecoration(color: Colors.white),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),

                  // Заголовок
                  const Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign up to get started',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 30),

                  // Поле Имя
                  _buildInputField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),

                  // Поле Email
                  _buildInputField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Поле Password
                  _buildInputField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: '••••••••',
                    obscureText: !_isPasswordVisible,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Поле Confirm Password
                  _buildInputField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    obscureText: !_isConfirmPasswordVisible,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Чекбокс согласия с условиями
                  _buildTermsCheckbox(),
                  const SizedBox(height: 20),

                  // Кнопка Sign Up
                  _buildSignUpButton(context),
                  const SizedBox(height: 16),

                  const SizedBox(height: 16),

                  // Уже есть аккаунт
                  _buildSignInRow(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Метод для создания поля ввода
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.grey[600])
                : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFFF8F8FC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0066FF), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _isAgreedToTerms,
            onChanged: (value) {
              setState(() {
                _isAgreedToTerms = value ?? false;
              });
            },
            activeColor: const Color(0xFF0066FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: 'I agree to the ',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              children: [
                TextSpan(
                  text: 'Terms of Service',
                  style: const TextStyle(
                    color: Color(0xFF0066FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: ' and ',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: const TextStyle(
                    color: Color(0xFF0066FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isAgreedToTerms ? () => _handleSignUp(context) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0066FF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        disabledBackgroundColor: Colors.grey[400],
      ),
      child: const Text(
        'Sign Up',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildSignInRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Sign In',
            style: TextStyle(
              color: Color(0xFF0066FF),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSignUp(BuildContext context) {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (name.isEmpty) {
      _showSnackBar(context, 'Please enter your full name', Colors.red);
      return;
    }
    if (email.isEmpty) {
      _showSnackBar(context, 'Please enter your email', Colors.red);
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      _showSnackBar(context, 'Please enter a valid email', Colors.red);
      return;
    }
    if (password.isEmpty) {
      _showSnackBar(context, 'Please enter a password', Colors.red);
      return;
    }

    if (password.length < 6) {
      _showSnackBar(
        context,
        'Password must be at least 6 characters',
        Colors.red,
      );
      return;
    }
    if (!_isAgreedToTerms) {
      _showSnackBar(
        context,
        'Please agree to the Terms of Service',
        Colors.red,
      );
      return;
    }
    print('Sign up with: $name, $email, $password');

    _showSnackBar(context, 'Account created successfully!', Colors.green);
    context.read<AuthBloc>().add(
      SignUpRequested(email: email, password: password, fullName: name),
    );
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
