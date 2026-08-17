import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/auth/auth_validators.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String routeName = 'Login';
  static String routePath = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _errorMessage = '';
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final emailError = validateEmail(email);
    final passwordError =
        password.isEmpty ? 'Password is required.' : null;

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
      _errorMessage = '';
    });

    if (emailError != null || passwordError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final role = userDoc.data()?['role'];

      if (role == 'admin') {
        context.pushNamed(AdmindashboardWidget.routeName);
      } else if (role == 'guardian') {
        context.pushNamed(GuardianMainDWidget.routeName);
      } else {
        context.goNamed(MainDashboardWidget.routeName);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = mapFirebaseAuthError(e);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFF0A1A3F),
        appBar: AppBar(
          backgroundColor: Color(0xFF0A1A3F),
          automaticallyImplyLeading: false,
          title: Text(
            'ImpairGency',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                  color: Colors.white,
                  fontSize: 50.0,
                ),
          ),
          elevation: 2.0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://cdn0.iconfinder.com/data/icons/social-messaging-ui-color-shapes-3/3/83-512.png',
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Say your username and password to log in, or use the fields below.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 40),

                // EMAIL
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'EMAIL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: Icon(Icons.mail_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if (_emailError != null)
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _emailError!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ),
                SizedBox(height: 24),

                // PASSWORD
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'PASSWORD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if (_passwordError != null)
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _passwordError!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ),
                SizedBox(height: 10),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      final email = _emailController.text.trim();

                      if (email.isEmpty) {
                        setState(() {
                          _errorMessage = 'Enter your email first.';
                        });
                        return;
                      }

                      final emailFormatError = validateEmail(email);
                      if (emailFormatError != null) {
                        setState(() {
                          _emailError = emailFormatError;
                          _errorMessage = '';
                        });
                        return;
                      }

                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email);

                        setState(() {
                          _errorMessage =
                              'Password reset link sent! Check your email or spam folder.';
                        });
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          _errorMessage = mapFirebaseAuthError(e);
                        });
                      }
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),

                // Error message
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(
                        color: _errorMessage == 'Password reset email sent!'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),

                SizedBox(height: 20),

                // LOGIN Button
                _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : FFButtonWidget(
                        onPressed: _login,
                        text: 'LOGIN',
                        options: FFButtonOptions(
                          width: 300.0,
                          height: 60.0,
                          color: Color(0xFF1E3A8A),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),

                SizedBox(height: 20),

                // Go to Register
                TextButton(
                  onPressed: () {
                    context.pushNamed(AfterRegisWidget.routeName);
                  },
                  child: Text(
                    'Don\'t have an account? Register here',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}