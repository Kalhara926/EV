import 'package:flutter/material.dart';
import 'package:ev_charging_app/screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); // For signup
  bool _isLogin = true; // To toggle between Login and Sign Up
  bool _isLoading = false;
  String? _errorMessage;

  void _submitAuthForm() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous errors
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Basic validation
    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        _errorMessage = 'Please enter a valid email address.';
        _isLoading = false;
      });
      return;
    }
    if (password.isEmpty || password.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters long.';
        _isLoading = false;
      });
      return;
    }

    if (!_isLogin && password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
        _isLoading = false;
      });
      return;
    }

    // Simulate API call for login/signup
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    setState(() {
      _isLoading = false;
    });

    // Simulate success or failure
    if (email == 'yanukasupun@gmail.com' && password == '123456') {
      // In a real app, you'd handle actual authentication response
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (!_isLogin && email.isNotEmpty && password.isNotEmpty) {
      // Simulate successful signup
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Account created successfully! Please login.')),
      );
      setState(() {
        _isLogin = true; // Switch to login after signup
      });
    } else {
      setState(() {
        _errorMessage = 'Invalid credentials. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Sign Up'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/logo.png', height: 150),
              const SizedBox(height: 40),
              Text(
                _isLogin ? 'Welcome Back!' : 'Create Your Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 30),
              if (_errorMessage != null)
                Column(
                  children: [
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              if (!_isLogin) // Only show confirm password for signup
                Column(
                  children: [
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitAuthForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                    _errorMessage = null; // Clear error when toggling
                  });
                },
                child: Text(_isLogin
                    ? 'Don\'t have an account? Sign Up'
                    : 'Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
