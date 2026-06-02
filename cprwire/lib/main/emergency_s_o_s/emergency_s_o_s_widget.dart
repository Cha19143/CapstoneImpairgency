import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'emergency_s_o_s_model.dart';

class EmergencySOSWidget extends StatefulWidget {
  const EmergencySOSWidget({super.key});

  static String routeName = 'EmergencySOS';
  static String routePath = '/emergencySOS';

  @override
  State<EmergencySOSWidget> createState() => _EmergencySOSWidgetState();
}

class _EmergencySOSWidgetState extends State<EmergencySOSWidget> {
  late EmergencySOSModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _guardianName = 'GUARDIAN';
  String _guardianNumber = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmergencySOSModel());
    _loadGuardianFromFirestore();
  }

  /// Kunin ang guardian info mula sa Firestore:
  /// users/{uid}.contacts[0].name  at  .number
  Future<void> _loadGuardianFromFirestore() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        setState(() => _isLoading = false);
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!doc.exists) {
        setState(() => _isLoading = false);
        return;
      }

      final data = doc.data();
      final contacts = data?['contacts'] as List<dynamic>?;

      String name = 'GUARDIAN';
      String number = '';

      if (contacts != null && contacts.isNotEmpty) {
        final first = contacts[0] as Map<String, dynamic>;
        name = (first['name'] as String? ?? 'Guardian').toUpperCase();
        number = first['number'] as String? ?? '';
      }

      setState(() {
        _guardianName = name;
        _guardianNumber = number;
        _isLoading = false;
      });

      // Auto-dial kapag may number
      if (number.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 500));
        _makeCall(number);
      }
    } catch (e) {
      debugPrint('Error loading guardian: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _makeCall(String number) async {
    final cleaned = number.replaceAll(RegExp(r'[\s\-]'), '');
    final uri = Uri(scheme: 'tel', path: cleaned);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
        backgroundColor: const Color(0xFF0A1A3F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A1A3F),
          automaticallyImplyLeading: false,
          leading: FFButtonWidget(
            onPressed: () async {
              context.safePop();
            },
            text: '',
            icon: const Icon(Icons.arrow_back_outlined, size: 50.0),
            options: FFButtonOptions(
              height: 40.0,
              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              iconColor: FlutterFlowTheme.of(context).primaryBackground,
              color: const Color(0xFF0A1A3F),
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.interTight(),
                    color: Colors.white,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          title: Align(
            alignment: const AlignmentDirectional(0.0, -1.0),
            child: Text(
              'ImpairGency',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).titleLarge.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                    color: Colors.white,
                    fontSize: 50.0,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: const AlignmentDirectional(0.0, -1.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white))
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 200.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A1A3F),
                              borderRadius: BorderRadius.circular(22.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                width: 2.0,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                'https://cdn-icons-png.freepik.com/512/12058/12058199.png',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 0.0),
                            child: Text(
                              'CALLING $_guardianName',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .headlineLarge
                                  .override(
                                    font: GoogleFonts.interTight(
                                        fontWeight: FontWeight.bold),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    fontSize: 40.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 0.0),
                            child: Text(
                              _guardianNumber.isEmpty
                                  ? 'No number saved'
                                  : _guardianNumber,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600),
                                    color: const Color(0xFF3B82F6),
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),

                          // Dialing indicator
                          if (_guardianNumber.isNotEmpty)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF22c55e),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Dialing...',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(),
                                          color: const Color(0xFF22c55e),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),

                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 100.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                context.pushNamed(MainDashboardWidget.routeName);
                              },
                              text: 'CANCEL',
                              options: FFButtonOptions(
                                width: 300.0,
                                height: 60.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                color: FlutterFlowTheme.of(context).tertiary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      font: GoogleFonts.interTight(),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      fontSize: 30.0,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                context.pushNamed(EmergencySOS2Widget.routeName);
                              },
                              text: 'CALL OTHERS',
                              options: FFButtonOptions(
                                width: 300.0,
                                height: 60.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                color: const Color(0xFF0A1A3F),
                                textStyle: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      font: GoogleFonts.interTight(
                                          fontWeight: FontWeight.bold),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      fontSize: 30.0,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),

                          // Retry call button
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: TextButton(
                              onPressed: () async {
                                if (_guardianNumber.isNotEmpty) {
                                  await _makeCall(_guardianNumber);
                                }
                              },
                              child: Text(
                                _guardianNumber.isEmpty
                                    ? 'No guardian contact saved'
                                    : 'Call Again',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(),
                                      color: Colors.white38,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}