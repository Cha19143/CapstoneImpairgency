import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/auth/auth_validators.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'register5_model.dart';
export 'register5_model.dart';

class Register5Widget extends StatefulWidget {
  final Map<String, dynamic> registrationData;

  const Register5Widget({
    super.key,
    this.registrationData = const {},
  });

  static String routeName = 'Register5';
  static String routePath = '/register5';

  @override
  State<Register5Widget> createState() => _Register5WidgetState();
}

class _Register5WidgetState extends State<Register5Widget> {
  late Register5Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  String _errorMessage = '';
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Register5Model());
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // I-extract ang firstName at lastName mula sa email
  Map<String, String> _extractNameFromEmail(String email) {
    // Kunin ang part bago ang '@'
    // example: anna.doe@gmail.com → anna.doe
    // example: annadoe@gmail.com → annadoe
    final localPart = email.split('@').first;

    String firstName = '';
    String lastName = '';

    // Check kung may separator (. o _ o -)
    if (localPart.contains('.')) {
      final parts = localPart.split('.');
      firstName = _capitalize(parts[0]);
      lastName = _capitalize(parts.sublist(1).join(' '));
    } else if (localPart.contains('_')) {
      final parts = localPart.split('_');
      firstName = _capitalize(parts[0]);
      lastName = _capitalize(parts.sublist(1).join(' '));
    } else if (localPart.contains('-')) {
      final parts = localPart.split('-');
      firstName = _capitalize(parts[0]);
      lastName = _capitalize(parts.sublist(1).join(' '));
    } else {
      // Walang separator — buong localPart ang magiging firstName
      firstName = _capitalize(localPart);
      lastName = '';
    }

    return {
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  // I-capitalize ang unang letra
  String _capitalize(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Future<void> _createAccount() async {
    final email = _model.textController1!.text.trim();
    final password = _model.textController2!.text;

    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);

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
      // 1. Gumawa ng account sa Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. I-extract ang firstName at lastName mula sa email
      final nameData = _extractNameFromEmail(email);

      // 3. I-save lahat sa Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        // Mula sa email
        'email': email,
        'firstName': nameData['firstName'],
        'lastName': nameData['lastName'],

        // Mula sa Register1
        'visionType': widget.registrationData['visionType'] ?? '',

        // Mula sa Register2
        'hasDevice': widget.registrationData['hasDevice'] ?? false,

        // Mula sa Register3 (kung may device)
        'deviceId': widget.registrationData['deviceId'] ?? '',

        // Mula sa AddContact
        'contacts': (widget.registrationData['contactName'] != null &&
                widget.registrationData['contactName'] != '')
            ? [
                {
                  'name': widget.registrationData['contactName'],
                  'number': widget.registrationData['contactNumber'],
                }
              ]
            : [],

        // System fields
        'role': 'visually_impaired',
        'createdAt': DateTime.now(),
        'uid': userCredential.user!.uid,
      });

      // 4. Pumunta sa AllSet screen
      context.pushNamed(AllsetWidget.routeName);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = mapFirebaseAuthError(e);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
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
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF0B1F3A),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(75.0),
          child: AppBar(
            backgroundColor: Color(0xFF0A1A3F),
            automaticallyImplyLeading: false,
            title: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: Text(
                'ImpairGency',
                style: FlutterFlowTheme.of(context).titleLarge.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FontWeight.bold,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            centerTitle: false,
            elevation: 2.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Title
                  Text(
                    'Let\'s setup\nyour Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Step 5/5
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Text(
                      'Step 5/5',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  // Progress bar
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: LinearPercentIndicator(
                      percent: 1.0,
                      width: MediaQuery.of(context).size.width - 48,
                      lineHeight: 20.0,
                      animation: true,
                      animateFromLastPercent: true,
                      progressColor: FlutterFlowTheme.of(context).primary,
                      backgroundColor: FlutterFlowTheme.of(context).accent4,
                      center: Text(
                        '100%',
                        style: TextStyle(color: Colors.white),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Set up your Account
                  Row(
                    children: [
                      Text(
                        'Set up your\nAccount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                      SizedBox(width: 50),
                      Image.network(
                        'https://static.vecteezy.com/system/resources/previews/014/440/997/original/speaker-icon-design-in-blue-circle-png.png',
                        width: 75.0,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  // Voice Command Box
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF3E558B),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: Row(
                      children: [
                        Image.network(
                          'https://cdn4.iconfinder.com/data/icons/social-messaging-ui-coloricon-1/21/56-512.png',
                          width: 60.0,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'VOICE COMMAND',
                                style: TextStyle(
                                  color: Color(0xFF3B82F6),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Say "Email" to enter the email address and say "Password" to enter Password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 25),

                  // Email Label
                  Text(
                    'Email Address',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 10),

                  // Email Field
                  TextFormField(
                    controller: _model.textController1,
                    focusNode: _model.textFieldFocusNode1,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).accent1,
                      fontSize: 18.0,
                    ),
                  ),

                  if (_emailError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        _emailError!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.0,
                        ),
                      ),
                    ),

                  SizedBox(height: 20),

                  // Password Label
                  Text(
                    'Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 10),

                  // Password Field
                  TextFormField(
                    controller: _model.textController2,
                    focusNode: _model.textFieldFocusNode2,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).accent1,
                      fontSize: 18.0,
                    ),
                  ),

                  if (_passwordError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        _passwordError!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.0,
                        ),
                      ),
                    ),

                  SizedBox(height: 10),

                  // Error message
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                        ),
                      ),
                    ),

                  SizedBox(height: 20),

                  // Complete Registration Button
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : FFButtonWidget(
                          onPressed: _createAccount,
                          text: 'Complete Registration',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 60.0,
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}