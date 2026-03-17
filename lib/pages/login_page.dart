import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _rememberMe = false;
  bool _isLoading = false;
  bool _isSignUp = false;

  // Password visibility
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  // Role selection
  String _selectedRole = 'Secretary'; // Default value

  void _toggleForm() {
    setState(() {
      _isSignUp = !_isSignUp;
      _usernameController.clear();
      _passwordController.clear();
      _fullnameController.clear();
      _emailController.clear();
      _confirmPasswordController.clear();
      _showPassword = false;
      _showConfirmPassword = false;
      _selectedRole = 'Secretary'; // Reset role
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final user = await AuthService.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home', arguments: user['fullname']);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await AuthService.register(
      fullname: _fullnameController.text.trim(),
      email: _emailController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      role: _selectedRole, // Pass selected role
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Please login.'),
          backgroundColor: Colors.green,
        ),
      );
      _toggleForm();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username or email already taken.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF031273),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            opacity: 0.4,
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 530, vertical: 5),
            child: Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo.png', height: 80, width: 80),
                      const SizedBox(height: 16),
                      const Text(
                        'Brgy Census Management',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF031273)),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        _isSignUp ? 'Create Account' : 'Welcome Back',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF031273)),
                      ),
                      const SizedBox(height: 24),

                      // Full Name
                      if (_isSignUp)
                        TextFormField(
                          controller: _fullnameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            hintText: 'Enter your full name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      if (_isSignUp) const SizedBox(height: 16),

                      // Email
                      if (_isSignUp)
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v!.isEmpty) return 'Required';
                            if (!v.contains('@')) return 'Invalid email';
                            return null;
                          },
                        ),
                      if (_isSignUp) const SizedBox(height: 16),

                      // Role Dropdown (Sign Up only)
                      if (_isSignUp)
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: const InputDecoration(
                            labelText: 'Role',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Secretary', child: Text('Secretary')),
                            DropdownMenuItem(value: 'Captain', child: Text('Captain')),
                          ],
                          onChanged: (value) => setState(() => _selectedRole = value!),
                          validator: (v) => v == null ? 'Please select a role' : null,
                        ),
                      if (_isSignUp) const SizedBox(height: 16),

                      // Username
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: _isSignUp ? 'Username' : 'Username or Email',
                          hintText: _isSignUp ? 'Choose username' : 'Enter username/email',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _showPassword = !_showPassword),
                          ),
                        ),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      if (_isSignUp)
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_showConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                            ),
                          ),
                          validator: (v) {
                            if (v!.isEmpty) return 'Required';
                            if (v != _passwordController.text) return 'Passwords do not match';
                            return null;
                          },
                        ),
                      if (_isSignUp) const SizedBox(height: 16),

                      // Remember Me (Login only)
                      if (!_isSignUp)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(value: _rememberMe, onChanged: (v) => setState(() => _rememberMe = v ?? false)),
                                const Text('Remember Me'),
                              ],
                            ),
                            TextButton(onPressed: () {}, child: const Text('Forgot Password?')),
                          ],
                        ),
                      if (!_isSignUp) const SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : (_isSignUp ? _signUp : _login),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF031273),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(_isSignUp ? 'Sign Up' : 'Login',
                                  style: const TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_isSignUp ? "Already have an account? " : "Don't have an account? "),
                          TextButton(
                            onPressed: _toggleForm,
                            child: Text(
                              _isSignUp ? "Login" : "Sign up",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF031273)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}