import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'login_widget.dart' show LoginWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginModel extends FlutterFlowModel<LoginWidget> {
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
