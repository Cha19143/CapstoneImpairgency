import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'register3_model.dart';
export 'register3_model.dart';

class Register3Widget extends StatefulWidget {
  final Map<String, dynamic> registrationData;

  const Register3Widget({
    super.key,
    this.registrationData = const {},
  });

  static String routeName = 'Register3';
  static String routePath = '/register3';

  @override
  State<Register3Widget> createState() => _Register3WidgetState();
}

class _Register3WidgetState extends State<Register3Widget> {
  late Register3Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? _generatedDeviceId;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Register3Model());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Auto-generate device ID mula sa Firestore counter
  Future<void> _vibrateAndGenerateDevice() async {
    setState(() => _isGenerating = true);

    try {
      // Kunin ang current device count mula Firestore
      final counterRef = FirebaseFirestore.instance
          .collection('app_counters')
          .doc('device_counter');

      final snapshot = await counterRef.get();

      int currentCount = 0;
      if (snapshot.exists) {
        currentCount = snapshot.data()?['count'] ?? 0;
      }

      // I-increment ang count
      final newCount = currentCount + 1;
      final deviceId = 'Device $newCount';

      // I-save ang bagong count sa Firestore
      await counterRef.set({'count': newCount});

      setState(() {
        _generatedDeviceId = deviceId;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating device ID: $e')),
      );
    }
  }

  void _proceedToRegister4() {
    if (_generatedDeviceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please press Vibrate to Identify first!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // I-update ang registrationData — idagdag ang deviceId
    final updatedData = {
      ...widget.registrationData,
      'deviceId': _generatedDeviceId,
    };

    context.pushNamed(
      Register4Widget.routeName,
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
                    padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 0.0, 0.0),
                    child: Text(
                      'Let\'s setup your\nDevice',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            fontSize: 45.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),

                // Step 3/5
                Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10.0, 15.0, 0.0, 0.0),
                    child: Text(
                      'Step 3/5',
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
                    percent: 0.6,
                    width: MediaQuery.of(context).size.width - 20,
                    lineHeight: 20.0,
                    animation: true,
                    animateFromLastPercent: true,
                    progressColor: FlutterFlowTheme.of(context).primary,
                    backgroundColor: FlutterFlowTheme.of(context).accent4,
                    center: Text(
                      '60%',
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),

                // Confirm your Device
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 25.0, 0.0, 0.0),
                  child: Row(
                    children: [
                      Text(
                        'Confirm your\nDevice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
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

                // Device Found Box — nagbabago depende sa state
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                  child: Container(
                    width: 257.8,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF3E558B),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _generatedDeviceId == null
                              ? 'SEARCHING...'
                              : 'DEVICE FOUND',
                          style: TextStyle(
                            color: Color(0xFF3B82F6),
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _generatedDeviceId == null
                              ? 'Press Vibrate to\nIdentify your device'
                              : 'We found a device',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_generatedDeviceId != null) ...[
                          SizedBox(height: 10),
                          Text(
                            '"ImpairGency\n $_generatedDeviceId"',
                            style: TextStyle(
                              color: Color(0xFF3B82F6),
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // VIBRATE TO IDENTIFY Button
                _isGenerating
                    ? CircularProgressIndicator(color: Colors.white)
                    : FFButtonWidget(
                        onPressed: _vibrateAndGenerateDevice,
                        text: 'VIBRATE TO IDENTIFY',
                        icon: Icon(Icons.vibration_outlined, size: 35.0),
                        options: FFButtonOptions(
                          width: 295.0,
                          height: 80.0,
                          color: Color(0xFF0A1A3F),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),

                SizedBox(height: 20),

                // Voice command box
                Container(
                  width: 282.0,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF0A1A3F),
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(color: Colors.white, width: 2.0),
                  ),
                  child: Row(
                    children: [
                      Image.network(
                        'https://cdn4.iconfinder.com/data/icons/social-messaging-ui-coloricon-1/21/56-512.png',
                        width: 50.0,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Say "Yes" if it\'s your device or "Search again" if not.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // NEXT Button — papunta sa Register4
                FFButtonWidget(
                  onPressed: _proceedToRegister4,
                  text: 'NEXT',
                  icon: Icon(Icons.arrow_forward_ios, size: 25.0),
                  options: FFButtonOptions(
                    width: 295.0,
                    height: 65.0,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
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