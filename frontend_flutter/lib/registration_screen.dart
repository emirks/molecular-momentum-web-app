import 'package:flutter/material.dart';
import 'custom_button.dart';
import 'services/user_service.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink.shade300, Colors.orange.shade300],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                _buildHeader(),
                const SizedBox(height: 30),
                _buildRegistrationForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Join us and start your journey!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            _buildTextField('Full Name', _fullNameController),
            const SizedBox(height: 15),
            _buildTextField('Username', _usernameController),
            const SizedBox(height: 15),
            _buildTextField('Email', _emailController, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 15),
            _buildTextField('Password', _passwordController, obscureText: true),
            const SizedBox(height: 15),
            _buildTextField('Confirm Password', _confirmPasswordController, obscureText: true),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Register',
              onPressed: _register,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Already have an account? Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (label == 'Email' && !_isValidEmail(value)) {
          return 'Please enter a valid email';
        }
        if (label == 'Confirm Password' && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userData = {
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'full_name': _fullNameController.text,
        };

        final registeredUser = await UserService.registerUser(userData);
        print('User registered: $registeredUser');

        // After successful registration, attempt to log in
        final loginSuccess = await AuthService.login(_usernameController.text, _passwordController.text);

        if (loginSuccess) {
          // Fetch user details and set user ID
          final userDetails = await UserService.getCurrentUserDetails();
          if (userDetails != null && userDetails['id'] != null) {
            ApiService.setUserId(userDetails['id']);
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            throw Exception('Failed to get user details after login');
          }
        } else {
          throw Exception('Login failed after registration');
        }
      } catch (e) {
        print('Registration error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }
}
