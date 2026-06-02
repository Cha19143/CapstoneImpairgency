import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'admin_login_widget.dart' show AdminLoginWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminLoginModel extends FlutterFlowModel<AdminLoginWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for txtf_username widget.
  FocusNode? txtfUsernameFocusNode;
  TextEditingController? txtfUsernameTextController;
  String? Function(BuildContext, String?)? txtfUsernameTextControllerValidator;
  // State field(s) for txtf_Password widget.
  FocusNode? txtfPasswordFocusNode;
  TextEditingController? txtfPasswordTextController;
  String? Function(BuildContext, String?)? txtfPasswordTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    txtfUsernameFocusNode?.dispose();
    txtfUsernameTextController?.dispose();

    txtfPasswordFocusNode?.dispose();
    txtfPasswordTextController?.dispose();
  }
}
