import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_user_admin_model.dart';
export 'edit_user_admin_model.dart';

class EditUserAdminWidget extends StatefulWidget {
  final String userId;

  const EditUserAdminWidget({
    super.key,
    required this.userId,
  });

  static String routeName = 'EditUserAdmin';
  static String routePath = '/editUserAdmin';

  @override
  State<EditUserAdminWidget> createState() => _EditUserAdminWidgetState();
}

class _EditUserAdminWidgetState extends State<EditUserAdminWidget> {
  late EditUserAdminModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  bool _isSaving = false;

  // Role of the user being edited
  String _userRole = '';

  // For VI user — guardian email field
  final TextEditingController _guardianEmailController =
      TextEditingController();
  String _linkedGuardianDocId = ''; // doc ID ng guardian na naka-link

  // For guardian — linked VI user email field
  final TextEditingController _linkedViEmailController =
      TextEditingController();
  String _linkedViUserId = ''; // doc ID ng VI user na naka-link

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditUserAdminModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final role = data['role'] ?? '';

        String contactName = '';
        String contactNumber = '';
        if (data['contacts'] != null &&
            (data['contacts'] as List).isNotEmpty) {
          final firstContact = data['contacts'][0];
          contactName = firstContact['name'] ?? '';
          contactNumber = firstContact['number'] ?? '';
        }

        // If VI user — find linked guardian
        if (role == 'visually_impaired') {
          final guardianQuery = await FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'guardian')
              .where('linkedViUserId', isEqualTo: widget.userId)
              .limit(1)
              .get();

          if (guardianQuery.docs.isNotEmpty) {
            final guardianData =
                guardianQuery.docs.first.data() as Map<String, dynamic>;
            _linkedGuardianDocId = guardianQuery.docs.first.id;
            _guardianEmailController.text = guardianData['email'] ?? '';
          }
        }

        // If guardian — load linked VI user
        if (role == 'guardian') {
          _linkedViUserId = data['linkedViUserId'] ?? '';
          if (_linkedViUserId.isNotEmpty) {
            final viDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(_linkedViUserId)
                .get();
            if (viDoc.exists) {
              final viData = viDoc.data() as Map<String, dynamic>;
              _linkedViEmailController.text = viData['email'] ?? '';
            }
          }
        }

        setState(() {
          _userRole = role;
          _model.textController1!.text = data['firstName'] ?? '';
          _model.textController2!.text = data['lastName'] ?? '';
          _model.textController3!.text = contactName;
          _model.textController4!.text = contactNumber;

          if (role == 'visually_impaired') {
            _model.dropDownValue =
                data['visionType'] == 'blind' ? 'BLIND' : 'LOW VISION';
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user: $e')),
      );
    }
  }

  Future<void> _saveUser() async {
    setState(() => _isSaving = true);

    try {
      // ── Save VI user ──────────────────────────────────────────────
      if (_userRole == 'visually_impaired') {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({
          'firstName': _model.textController1!.text.trim(),
          'lastName': _model.textController2!.text.trim(),
          'visionType':
              _model.dropDownValue == 'BLIND' ? 'blind' : 'vision_loss',
          'contacts': [
            {
              'name': _model.textController3!.text.trim(),
              'number': _model.textController4!.text.trim(),
            }
          ],
          'updatedAt': DateTime.now(),
        });

        // Update guardian email if changed
        final newGuardianEmail = _guardianEmailController.text.trim();
        if (newGuardianEmail.isNotEmpty) {
          if (_linkedGuardianDocId.isNotEmpty) {
            // Update existing linked guardian
            await FirebaseFirestore.instance
                .collection('users')
                .doc(_linkedGuardianDocId)
                .update({
              'email': newGuardianEmail,
              'updatedAt': DateTime.now(),
            });
          } else {
            // Try to find guardian by email and link them
            final guardianQuery = await FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: 'guardian')
                .where('email', isEqualTo: newGuardianEmail)
                .limit(1)
                .get();

            if (guardianQuery.docs.isNotEmpty) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(guardianQuery.docs.first.id)
                  .update({
                'linkedViUserId': widget.userId,
                'updatedAt': DateTime.now(),
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Guardian email not found. Make sure the guardian has an account.'),
                  backgroundColor: Colors.orange,
                ),
              );
              setState(() => _isSaving = false);
              return;
            }
          }
        }
      }

      // ── Save Guardian ─────────────────────────────────────────────
      if (_userRole == 'guardian') {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({
          'firstName': _model.textController1!.text.trim(),
          'lastName': _model.textController2!.text.trim(),
          'updatedAt': DateTime.now(),
        });

        // Update linked VI user by email if changed
        final newViEmail = _linkedViEmailController.text.trim();
        if (newViEmail.isNotEmpty) {
          if (_linkedViUserId.isNotEmpty) {
            // Update email of existing linked VI user
            await FirebaseFirestore.instance
                .collection('users')
                .doc(_linkedViUserId)
                .update({
              'email': newViEmail,
              'updatedAt': DateTime.now(),
            });
          } else {
            // Try to find VI user by email and link them
            final viQuery = await FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: 'visually_impaired')
                .where('email', isEqualTo: newViEmail)
                .limit(1)
                .get();

            if (viQuery.docs.isNotEmpty) {
              final viDocId = viQuery.docs.first.id;
              // Link guardian to VI user
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userId)
                  .update({
                'linkedViUserId': viDocId,
                'updatedAt': DateTime.now(),
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'VI user email not found. Make sure the user has an account.'),
                  backgroundColor: Colors.orange,
                ),
              );
              setState(() => _isSaving = false);
              return;
            }
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      context.pushNamed('UserManagement');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _guardianEmailController.dispose();
    _linkedViEmailController.dispose();
    _model.dispose();
    super.dispose();
  }

  // Reusable text field decoration
  InputDecoration _fieldDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }

  TextStyle _fieldTextStyle() {
    return TextStyle(color: FlutterFlowTheme.of(context).accent1);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A1A3F),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

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
          title: Text(
            'ImpairGency',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Title
                  Text(
                    'EDIT ${_userRole == 'guardian' ? 'GUARDIAN' : 'USER'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // First Name
                  const Text('First Name',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _model.textController1,
                    focusNode: _model.textFieldFocusNode1,
                    decoration: _fieldDecoration(),
                    style: _fieldTextStyle(),
                  ),

                  const SizedBox(height: 20),

                  // Last Name
                  const Text('Last Name',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _model.textController2,
                    focusNode: _model.textFieldFocusNode2,
                    decoration: _fieldDecoration(),
                    style: _fieldTextStyle(),
                  ),

                  // ── VI User only fields ──────────────────────────
                  if (_userRole == 'visually_impaired') ...[
                    const SizedBox(height: 20),

                    // Vision Type Dropdown
                    const Text('Type of Visual Impairment',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    const SizedBox(height: 8),
                    FlutterFlowDropDown<String>(
                      controller: _model.dropDownValueController ??=
                          FormFieldController<String>(_model.dropDownValue),
                      options: const ['BLIND', 'LOW VISION'],
                      onChanged: (val) =>
                          safeSetState(() => _model.dropDownValue = val),
                      width: double.infinity,
                      height: 50.0,
                      textStyle:
                          FlutterFlowTheme.of(context).titleMedium,
                      hintText: 'Type of Impairment',
                      icon: Icon(Icons.keyboard_arrow_down_rounded,
                          color: FlutterFlowTheme.of(context).secondaryText),
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      elevation: 2.0,
                      borderColor: Colors.transparent,
                      borderWidth: 0.0,
                      borderRadius: 8.0,
                      margin:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                      hidesUnderline: true,
                      isOverButton: false,
                      isSearchable: false,
                      isMultiSelect: false,
                    ),

                    const SizedBox(height: 20),

                    // Emergency Contact
                    const Text('EMERGENCY CONTACT',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),

                    const SizedBox(height: 15),

                    const Text('Name',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _model.textController3,
                      focusNode: _model.textFieldFocusNode3,
                      decoration: _fieldDecoration(),
                      style: _fieldTextStyle(),
                    ),

                    const SizedBox(height: 20),

                    const Text('Contact Number',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _model.textController4,
                      focusNode: _model.textFieldFocusNode4,
                      keyboardType: TextInputType.phone,
                      decoration: _fieldDecoration(),
                      style: _fieldTextStyle(),
                    ),

                    const SizedBox(height: 30),

                    // Guardian Email Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A3E6E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.lightBlueAccent.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.shield_outlined,
                                  color: Colors.lightBlueAccent, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'LINKED GUARDIAN',
                                style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Update the email to change or link a guardian account.',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          const Text('Guardian Email',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _guardianEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _fieldDecoration(),
                            style: _fieldTextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ── Guardian only fields ─────────────────────────
                  if (_userRole == 'guardian') ...[
                    const SizedBox(height: 30),

                    // Linked VI User Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A3E6E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.lightBlueAccent.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.visibility,
                                  color: Colors.lightBlueAccent, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'LINKED VI USER',
                                style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Update the email to change or link a visually impaired user account.',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          const Text('VI User Email',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _linkedViEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _fieldDecoration(),
                            style: _fieldTextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),

                  // Cancel / Save buttons
                  Row(
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () => context.safePop(),
                          text: 'Cancel',
                          options: FFButtonOptions(
                            height: 50.0,
                            color: Colors.grey,
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _isSaving
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white))
                            : FFButtonWidget(
                                onPressed: _saveUser,
                                text: 'Save',
                                options: FFButtonOptions(
                                  height: 50.0,
                                  color: const Color(0xFF3E558B),
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}