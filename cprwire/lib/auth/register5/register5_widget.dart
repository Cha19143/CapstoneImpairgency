import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
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

// ==== EmailJS config ====
const String _emailJsServiceId = 'service_n704xxj';
const String _emailJsTemplateId = 'template_k9b5a58';
const String _emailJsPublicKey = '2Y-OPcwJGjqKc7taW';
const String _emailJsPrivateKey = '777y2P-sMM-FTiH5uwahN';

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

  // ==== OTP state ====
  bool _otpSent = false;
  bool _isSendingOtp = false;
  bool _isVerifyingOtp = false;
  String _otpError = '';
  final TextEditingController _otpController = TextEditingController();

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
    _otpController.dispose();
    super.dispose();
  }

  // I-extract ang firstName at lastName mula sa email
  Map<String, String> _extractNameFromEmail(String email) {
    final localPart = email.split('@').first;

    String firstName = '';
    String lastName = '';

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
      firstName = _capitalize(localPart);
      lastName = '';
    }

    return {
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  String _capitalize(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Gumawa ng random 6-digit na code
  String _generateOtpCode() {
    final random = Random();
    final code = 100000 + random.nextInt(900000); // 100000-999999
    return code.toString();
  }

  // Gawing safe na Firestore document ID ang email
  String _sanitizeEmailForDocId(String email) {
    return email.trim().toLowerCase().replaceAll('.', '_dot_').replaceAll('@', '_at_');
  }

  // ==== STEP 1: I-validate, i-generate, i-save, at ipadala ang OTP ====
  Future<void> _sendOtp() async {
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
      _isSendingOtp = true;
      _errorMessage = '';
      _otpError = '';
    });

    try {
      final otpCode = _generateOtpCode();
      final docId = _sanitizeEmailForDocId(email);

      // I-save ang OTP sa Firestore na may timestamp (para sa expiry check)
      await FirebaseFirestore.instance
          .collection('otp_verification')
          .doc(docId)
          .set({
        'email': email,
        'code': otpCode,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      // Ipadala ang OTP sa email gamit ang EmailJS
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': _emailJsServiceId,
          'template_id': _emailJsTemplateId,
          'user_id': _emailJsPublicKey,
          'accessToken': _emailJsPrivateKey,
          'template_params': {
            'email': email,
            'name': 'ImpairGency',
            'otp_code': otpCode,
          },
        }),
      );

      // DEBUG: ipapakita natin muna yung totoong response galing EmailJS
      debugPrint('EmailJS status code: ${response.statusCode}');
      debugPrint('EmailJS response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _otpSent = true;
          _isSendingOtp = false;
        });
      } else {
        setState(() {
          _isSendingOtp = false;
          // DEBUG: pansamantalang ipapakita natin yung totoong error sa screen
          _errorMessage =
              'Failed (${response.statusCode}): ${response.body}';
        });
      }
    } catch (e) {
      debugPrint('EmailJS exception: $e');
      setState(() {
        _isSendingOtp = false;
        // DEBUG: pansamantalang ipapakita natin yung totoong exception sa screen
        _errorMessage = 'Exception: $e';
      });
    }
  }

  // ==== STEP 2: I-verify ang OTP na in-type ng user ====
  Future<void> _verifyOtpAndCreateAccount() async {
    final enteredCode = _otpController.text.trim();

    if (enteredCode.isEmpty) {
      setState(() => _otpError = 'Please enter the verification code.');
      return;
    }

    setState(() {
      _isVerifyingOtp = true;
      _otpError = '';
    });

    try {
      final email = _model.textController1!.text.trim();
      final docId = _sanitizeEmailForDocId(email);

      final otpDoc = await FirebaseFirestore.instance
          .collection('otp_verification')
          .doc(docId)
          .get();

      if (!otpDoc.exists) {
        setState(() {
          _isVerifyingOtp = false;
          _otpError = 'Code expired or not found. Please request a new one.';
        });
        return;
      }

      final data = otpDoc.data()!;
      final savedCode = data['code'] as String;
      final createdAt = data['createdAt'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;
      final fiveMinutesInMs = 5 * 60 * 1000;

      if (now - createdAt > fiveMinutesInMs) {
        setState(() {
          _isVerifyingOtp = false;
          _otpError = 'Code has expired. Please request a new one.';
        });
        return;
      }

      if (enteredCode != savedCode) {
        setState(() {
          _isVerifyingOtp = false;
          _otpError = 'Incorrect code. Please try again.';
        });
        return;
      }

      // Tama ang code — burahin ang OTP doc, tapos gawin na ang account
      await FirebaseFirestore.instance
          .collection('otp_verification')
          .doc(docId)
          .delete();

      setState(() => _isVerifyingOtp = false);
      await _createAccount();
    } catch (e) {
      setState(() {
        _isVerifyingOtp = false;
        _otpError = 'Something went wrong. Please try again.';
      });
    }
  }

  // ==== STEP 3: Gumawa ng account (matapos ma-verify ang OTP) ====
  Future<void> _createAccount() async {
    final email = _model.textController1!.text.trim();
    final password = _model.textController2!.text;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final nameData = _extractNameFromEmail(email);

      // Suportahan ang parehong: multiple contacts (mula sa contact picker)
      // at single contact (mula sa "Add contact manually")
      List<Map<String, dynamic>> contactsList = [];
      final rawContacts = widget.registrationData['contacts'];
      if (rawContacts is List && rawContacts.isNotEmpty) {
        contactsList = rawContacts
            .map((c) => Map<String, dynamic>.from(c as Map))
            .toList();
      } else if (widget.registrationData['contactName'] != null &&
          widget.registrationData['contactName'] != '') {
        contactsList = [
          {
            'name': widget.registrationData['contactName'],
            'number': widget.registrationData['contactNumber'],
          }
        ];
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'firstName': nameData['firstName'],
        'lastName': nameData['lastName'],
        'visionType': widget.registrationData['visionType'] ?? '',
        'hasDevice': widget.registrationData['hasDevice'] ?? false,
        'deviceId': widget.registrationData['deviceId'] ?? '',
        'contacts': contactsList,
        'role': 'visually_impaired',
        'createdAt': DateTime.now(),
        'uid': userCredential.user!.uid,
      });

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
                      color: Colors.white,
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
                  Text(
                    'Let\'s setup\nyour Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                      center: Text('100%', style: TextStyle(color: Colors.white)),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(height: 20),
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

                  // ==== Email/Password fields (naka-disable kapag naipadala na ang OTP) ====
                  Text(
                    'Email Address',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _model.textController1,
                    focusNode: _model.textFieldFocusNode1,
                    enabled: !_otpSent,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  if (_emailError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(_emailError!, style: TextStyle(color: Colors.red, fontSize: 14.0)),
                    ),
                  SizedBox(height: 20),
                  Text(
                    'Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _model.textController2,
                    focusNode: _model.textFieldFocusNode2,
                    enabled: !_otpSent,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  if (_passwordError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(_passwordError!, style: TextStyle(color: Colors.red, fontSize: 14.0)),
                    ),
                  SizedBox(height: 10),
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(_errorMessage, style: TextStyle(color: Colors.red, fontSize: 16.0)),
                    ),
                  SizedBox(height: 20),

                  // ==== OTP section — lumalabas lang matapos maipadala ang code ====
                  if (_otpSent) ...[
                    Text(
                      'Enter Verification Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'We sent a 6-digit code to your email. It expires in 5 minutes.',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        hintText: 'Enter 6-digit code',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        counterText: '',
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    if (_otpError.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(_otpError, style: TextStyle(color: Colors.red, fontSize: 14.0)),
                      ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: _isSendingOtp ? null : _sendOtp,
                      child: Text(
                        'Resend code',
                        style: TextStyle(color: Colors.white70, decoration: TextDecoration.underline),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],

                  // ==== Main action button ====
                  (_isSendingOtp || _isVerifyingOtp || _isLoading)
                      ? Center(child: CircularProgressIndicator(color: Colors.white))
                      : FFButtonWidget(
                          onPressed: _otpSent ? _verifyOtpAndCreateAccount : _sendOtp,
                          text: _otpSent ? 'Verify & Complete Registration' : 'Send Verification Code',
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