import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'register4_model.dart';
export 'register4_model.dart';

class Register4Widget extends StatefulWidget {
  final Map<String, dynamic> registrationData;

  const Register4Widget({
    super.key,
    this.registrationData = const {},
  });

  static String routeName = 'Register4';
  static String routePath = '/register4';

  @override
  State<Register4Widget> createState() => _Register4WidgetState();
}

class _Register4WidgetState extends State<Register4Widget> {
  late Register4Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Register4Model());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _goToAddContact() {
    // I-pass ang registrationData sa AddContact screen
    context.pushNamed(
      AddcontactWidget.routeName,
      extra: widget.registrationData,
    );
  }

  void _skipContact() {
    // Walang contact — i-pass ang registrationData na walang contact
    final updatedData = {
      ...widget.registrationData,
      'contactName': '',
      'contactNumber': '',
    };

    context.pushNamed(
      Register5Widget.routeName,
      extra: updatedData,
    );
  }

  void _allowContacts() {
    // Allow contacts — same as skip for now, 
    // pwedeng palitan ng actual contacts permission later
    final updatedData = {
      ...widget.registrationData,
      'contactName': '',
      'contactNumber': '',
    };

    context.pushNamed(
      Register5Widget.routeName,
      extra: updatedData,
    );
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
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [

                // Title
                Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(25.0, 10.0, 0.0, 0.0),
                    child: Text(
                      'Let\'s setup\nyour Device',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),

                // Step 4/5
                Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(25.0, 15.0, 0.0, 0.0),
                    child: Text(
                      'Step 4/5',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),

                // Progress bar
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 0.0),
                  child: LinearPercentIndicator(
                    percent: 0.8,
                    width: MediaQuery.of(context).size.width - 20,
                    lineHeight: 20.0,
                    animation: true,
                    animateFromLastPercent: true,
                    progressColor: FlutterFlowTheme.of(context).primary,
                    backgroundColor: FlutterFlowTheme.of(context).accent4,
                    center: Text(
                      '80%',
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),

                // Who should we contact
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 25.0, 0.0, 0.0),
                  child: Row(
                    children: [
                      Text(
                        'Who should\nwe contact in an\nEmergency?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                      SizedBox(width: 30),
                      Image.network(
                        'https://static.vecteezy.com/system/resources/previews/014/440/997/original/speaker-icon-design-in-blue-circle-png.png',
                        width: 75.0,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),

                // Voice Command Box
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                  child: Container(
                    width: 257.8,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF3E558B),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: Row(
                      children: [
                        Image.network(
                          'https://cdn4.iconfinder.com/data/icons/social-messaging-ui-coloricon-1/21/56-512.png',
                          width: 75.0,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'VOICE\nCOMMAND',
                                style: TextStyle(
                                  color: Color(0xFF3B82F6),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Say "allow" to allow contacts, say "manual to add" manually or say "skip" to add contact next time',
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
                ),

                SizedBox(height: 30),

                // Allow access to contacts Button
                FFButtonWidget(
                  onPressed: _allowContacts,
                  text: 'Allow access to contacts',
                  icon: Icon(Icons.arrow_forward_ios, size: 30.0),
                  options: FFButtonOptions(
                    width: 300.0,
                    height: 60.0,
                    color: FlutterFlowTheme.of(context).primary,
                    iconAlignment: IconAlignment.end,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),

                SizedBox(height: 20),

                // Add contact manually Button
                FFButtonWidget(
                  onPressed: _goToAddContact,
                  text: 'Add contact manually',
                  icon: Icon(Icons.person_add_alt_sharp, size: 30.0),
                  options: FFButtonOptions(
                    width: 300.0,
                    height: 60.0,
                    color: FlutterFlowTheme.of(context).primary,
                    iconAlignment: IconAlignment.end,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),

                SizedBox(height: 30),

                // Skip for Now
                GestureDetector(
                  onTap: _skipContact,
                  child: Text(
                    'Skip for Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
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