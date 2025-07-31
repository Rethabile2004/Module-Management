//
// Coder                    : Rethabile Eric Siase
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules
//

import 'package:firebase_flutter/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'email_formfield.dart';
import 'password_formfield.dart';

// AuthPage widget handles both login and registration
class AuthPage extends StatefulWidget {
  final bool isLogin; // Determines if the page is for login or registration
  const AuthPage({super.key, required this.isLogin});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>(); // Key for the form
  final _emailController =
      TextEditingController(); // Controller for email input
  final _passwordController =
      TextEditingController(); // Controller for password input
  final _nameController =
      TextEditingController(); // Controller for name input (registration only)
  bool _isLoading = false; // Loading state

  // Method to handle form submission
  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return; // Validate the form

    setState(() => _isLoading = true); // Set loading state

    try {
      final authService = Provider.of<AuthService>(context, listen: false);

      if (widget.isLogin) {
        // Login logic
        await authService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        // Navigate to the main page after successful login
        Navigator.pushReplacementNamed(
          context,
          RouteManager.mainPage,
          arguments: _emailController.text.trim(),
        );
      } else {
        // Registration logic
        await authService.register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
        );
        // Navigate back to the login page after successful registration
        Navigator.pushReplacementNamed(context, RouteManager.loginPage);
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false); // Reset loading state
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset('assets/login.png', width: 310, height: 315),
              if (!widget.isLogin)
                // Name input field for registration
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator:
                      (value) => value!.isEmpty ? 'Required field' : null,
                ),
              const SizedBox(height: 16),
              // Email input field
              EmailFormField(controller: _emailController),
              const SizedBox(height: 16),
              // Password input field
              PasswordFormField(controller: _passwordController),
              const SizedBox(height: 24),
              // Submit button
              ElevatedButton(
                onPressed: _isLoading ? null : () => _submit(context),
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Text(widget.isLogin ? 'Login' : 'Register'),
              ),
              // Toggle between login and registration
              TextButton(
                onPressed:
                    () => Navigator.pushReplacementNamed(
                      context,
                      widget.isLogin
                          ? RouteManager.registrationPage
                          : RouteManager.loginPage,
                    ),
                child: Text(
                  widget.isLogin
                      ? 'Create an account'
                      : 'Already have an account?',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// This code defines an authentication page that allows users to either log in or register.
// It uses a form with validation for email and password inputs, and conditionally shows a name input field for registration.
// The page handles form submission, showing loading indicators and error messages as needed.
