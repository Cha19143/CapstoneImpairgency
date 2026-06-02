import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Register1Widget extends StatefulWidget {
  const Register1Widget({super.key});

  static String routeName = 'Register1';
  static String routePath = '/register1';

  @override
  State<Register1Widget> createState() => _Register1WidgetState();
}

class _Register1WidgetState extends State<Register1Widget> {
  String? _selectedVisionType;

  void _selectAndProceed(String type) {
    setState(() {
      _selectedVisionType = type;
    });

    // I-pass ang visionType sa Register2
    context.pushNamed(
      Register2Widget.routeName,
      extra: {
        'visionType': type, // 'blind' o 'vision_loss'
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFF0B1F3A),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Color(0xFF0A1A3F),
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                GestureDetector(
                  onTap: () => context.safePop(),
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Image.asset(
                      'assets/images/chevron-left-solid.png',
                      width: 40.0,
                      height: 40.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text(
                    'ImpairGency',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            elevation: 1.0,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
                  child: Text(
                    'Let\'s setup your Device',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text(
                    'Step 1/5',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: LinearPercentIndicator(
                    percent: 0.2,
                    width: MediaQuery.of(context).size.width - 40,
                    lineHeight: 30.0,
                    animation: true,
                    animateFromLastPercent: true,
                    progressColor: FlutterFlowTheme.of(context).primary,
                    backgroundColor: FlutterFlowTheme.of(context).accent4,
                    center: Text(
                      '20%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
                  child: Row(
                    children: [
                      Text(
                        'Tell us about \nyour vision',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(width: 10),
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
                      height: 190,
                      decoration: BoxDecoration(
                        color: Color(0xFF3E558B),
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Image.network(
                              'https://cdn4.iconfinder.com/data/icons/social-messaging-ui-coloricon-1/21/56-512.png',
                              width: 70.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'VOICE\nCOMMAND',
                                style: TextStyle(
                                  color: Color(0xFF3B82F6),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Say\n"Blind" or\n"Low Vision"',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: FFButtonWidget(
                    onPressed: () => _selectAndProceed('vision_loss'),
                    text: 'VISION LOSS',
                    icon: Icon(Icons.visibility_off, size: 40.0),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 65.0,
                      color: _selectedVisionType == 'vision_loss'
                          ? Colors.blue.shade800
                          : FlutterFlowTheme.of(context).primary,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: FFButtonWidget(
                    onPressed: () => _selectAndProceed('blind'),
                    text: 'BLIND',
                    icon: Icon(Icons.blind, size: 40.0),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 65.0,
                      color: _selectedVisionType == 'blind'
                          ? Colors.blue.shade800
                          : FlutterFlowTheme.of(context).primary,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 26.0,
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