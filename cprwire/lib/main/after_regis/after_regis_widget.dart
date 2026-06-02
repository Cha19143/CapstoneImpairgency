import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'after_regis_model.dart';
export 'after_regis_model.dart';

class AfterRegisWidget extends StatefulWidget {
  const AfterRegisWidget({super.key});

  static String routeName = 'AfterRegis';
  static String routePath = '/afterRegis';

  @override
  State<AfterRegisWidget> createState() => _AfterRegisWidgetState();
}

class _AfterRegisWidgetState extends State<AfterRegisWidget> {
  late AfterRegisModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AfterRegisModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF0A1A3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A3F),
        automaticallyImplyLeading: false,
        title: Text(
          'ImpairGency',
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).titleLarge.override(
                font: GoogleFonts.interTight(
                  fontWeight: FontWeight.bold,
                  fontStyle:
                      FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
                color: Colors.white,
                fontSize: 45.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
                fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
              ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 2.0,
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(35.0, 0.0, 35.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    0.0, 50.0, 0.0, 0.0),
                child: Text(
                  'Choose User',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontStyle,
                        ),
                        color:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        fontSize: 45.0,
                        letterSpacing: 0.0,
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .fontStyle,
                      ),
                ),
              ),

              // PARENTS / GUARDIAN button
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    0.0, 50.0, 0.0, 0.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(GuardianRegisterWidget.routeName);
                    },
                    text: 'PARENTS/ GUARDIAN',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 100.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 16.0, 0.0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).accent2,
                      textStyle: FlutterFlowTheme.of(context)
                          .headlineSmall
                          .override(
                            font: GoogleFonts.interTight(
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            fontSize: 25.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .fontStyle,
                          ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),

              // VISUALLY IMPAIRED button
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    0.0, 50.0, 0.0, 0.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(Register1Widget.routeName);
                    },
                    text: 'VISUALLY IMPAIRED PERSON',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 100.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 16.0, 0.0),
                      iconAlignment: IconAlignment.start,
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).success,
                      textStyle: FlutterFlowTheme.of(context)
                          .headlineSmall
                          .override(
                            font: GoogleFonts.interTight(
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            fontSize: 25.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .fontStyle,
                          ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}