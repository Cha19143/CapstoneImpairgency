import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Register2Widget extends StatefulWidget {
  final Map<String, dynamic> registrationData;

  const Register2Widget({
    super.key,
    this.registrationData = const {},
  });

  static String routeName = 'Register2';
  static String routePath = '/register2';

  @override
  State<Register2Widget> createState() => _Register2WidgetState();
}

class _Register2WidgetState extends State<Register2Widget> {
  String? _selectedDeviceOption;

  void _selectAndProceed(String option) {
    setState(() => _selectedDeviceOption = option);

    // I-update ang registrationData — idagdag ang hasDevice
    final updatedData = {
      ...widget.registrationData,  // lahat ng data mula Register1
      'hasDevice': option == 'has_device', // true o false
    };

    if (option == 'has_device') {
      // May device → Register3
      context.pushNamed(
        Register3Widget.routeName,
        extra: updatedData,
      );
    } else {
      // Walang device → Register4
      context.pushNamed(
        Register4Widget.routeName,
        extra: updatedData,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFF0B1F3A),
        appBar: AppBar(
          backgroundColor: Color(0xFF0A1A3F),
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(
                onTap: () => context.safePop(),
                child: Icon(Icons.chevron_left, color: Colors.white, size: 35),
              ),
              SizedBox(width: 10),
              Text(
                'ImpairGency',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          elevation: 2.0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Text(
                    'Let\'s setup your Device',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Text(
                    'Step 2/5',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: LinearPercentIndicator(
                    percent: 0.4,
                    width: screenWidth - 32,
                    lineHeight: 30.0,
                    animation: true,
                    animateFromLastPercent: true,
                    progressColor: FlutterFlowTheme.of(context).primary,
                    backgroundColor: FlutterFlowTheme.of(context).accent4,
                    center: Text(
                      '40%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 25, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Do you have an \nImpairGency\ndevice?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      Image.network(
                        'https://static.vecteezy.com/system/resources/previews/014/440/997/original/speaker-icon-design-in-blue-circle-png.png',
                        width: 60.0,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Container(
                      width: 260,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF3E558B),
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      child: Row(
                        children: [
                          Image.network(
                            'https://cdn4.iconfinder.com/data/icons/social-messaging-ui-coloricon-1/21/56-512.png',
                            width: 65.0,
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
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Say "I have a device" or "I don\'t have a device"',
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
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: FFButtonWidget(
                    onPressed: () => _selectAndProceed('has_device'),
                    text: 'I have a device',
                    icon: Icon(Icons.check_circle_outline, size: 40.0),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 65.0,
                      color: _selectedDeviceOption == 'has_device'
                          ? Colors.blue.shade800
                          : FlutterFlowTheme.of(context).primary,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 30),
                  child: FFButtonWidget(
                    onPressed: () => _selectAndProceed('no_device'),
                    text: 'I don\'t have a device',
                    icon: Icon(Icons.not_interested_outlined, size: 40.0),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 65.0,
                      color: _selectedDeviceOption == 'no_device'
                          ? Colors.blue.shade800
                          : FlutterFlowTheme.of(context).primary,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}