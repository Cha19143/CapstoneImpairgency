import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GuardianRegisterWidget extends StatefulWidget {
  const GuardianRegisterWidget({super.key});

  static String routeName = 'GuardianRegister';
  static String routePath = '/guardianRegister';

  @override
  State<GuardianRegisterWidget> createState() => _GuardianRegisterWidgetState();
}

class _GuardianRegisterWidgetState extends State<GuardianRegisterWidget> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _viEmailController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String _errorMessage = '';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _viEmailController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Basic validation
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please fill in all required fields.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // 1. Create Firebase Auth account
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;

      // 2. Look up VI user by email (if provided)
      String? linkedViUid;
      if (_viEmailController.text.trim().isNotEmpty) {
        final viQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: _viEmailController.text.trim())
            .where('role', isEqualTo: 'visually_impaired')
            .limit(1)
            .get();

        if (viQuery.docs.isNotEmpty) {
          linkedViUid = viQuery.docs.first.id;
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage =
                'No Visually Impaired user found with that email. Please check and try again.';
          });
          // Delete the created auth account since linking failed
          await userCredential.user!.delete();
          return;
        }
      }

      // 3. Save guardian data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'linkedViUserId': linkedViUid ?? '',
        'role': 'guardian',
        'status': 'active',
        'createdAt': DateTime.now(),
      });

      // 4. If linked, update VI user's document with guardian UID
      if (linkedViUid != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(linkedViUid)
            .update({'linkedGuardianId': uid});
      }

      // 5. Navigate to Guardian Dashboard
      if (mounted) {
        context.goNamed(GuardianMainDWidget.routeName);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Registration failed. Please try again.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    String hint = '',
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Container(
      width: double.infinity,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A1A3F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A1A3F),
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
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
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Title
                Text(
                  'GUARDIAN\nREGISTRATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                // First Name
                _buildLabel('FIRST NAME'),
                _buildTextField(_firstNameController, hint: 'Enter First Name'),
                const SizedBox(height: 20),

                // Last Name
                _buildLabel('LAST NAME'),
                _buildTextField(_lastNameController, hint: 'Enter Last Name'),
                const SizedBox(height: 20),

                // Email
                _buildLabel('EMAIL'),
                _buildTextField(
                  _emailController,
                  hint: 'Enter Email',
                  keyboardType: TextInputType.emailAddress,
                  suffixIcon: const Icon(Icons.mail_outline),
                ),
                const SizedBox(height: 20),

                // Password
                _buildLabel('PASSWORD'),
                _buildTextField(
                  _passwordController,
                  hint: 'Enter Password',
                  obscure: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 20),

                // Phone Number
                _buildLabel('PHONE NUMBER'),
                _buildTextField(
                  _phoneController,
                  hint: 'Enter Phone Number',
                  keyboardType: TextInputType.phone,
                  suffixIcon: const Icon(Icons.phone_outlined),
                ),
                const SizedBox(height: 20),

                // VI User Email (link)
                _buildLabel('VISUALLY IMPAIRED USER\'S EMAIL'),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Enter the email of the VI user you want to be linked with.',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ),
                _buildTextField(
                  _viEmailController,
                  hint: 'Enter VI User\'s Email',
                  keyboardType: TextInputType.emailAddress,
                  suffixIcon: const Icon(Icons.link),
                ),
                const SizedBox(height: 20),

                // Error message
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),

                const SizedBox(height: 10),

                // Register Button
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : FFButtonWidget(
                        onPressed: _register,
                        text: 'REGISTER',
                        options: FFButtonOptions(
                          width: 300.0,
                          height: 60.0,
                          color: const Color(0xFF1E3A8A),
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),

                const SizedBox(height: 20),

                // Back to Login
                TextButton(
                  onPressed: () => context.pushNamed(LoginWidget.routeName),
                  child: const Text(
                    'Already have an account? Login here',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}