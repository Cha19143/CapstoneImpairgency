import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuardianSetupWidget extends StatefulWidget {
  const GuardianSetupWidget({super.key});

  static String routeName = 'GuardianSetup';
  static String routePath = '/guardianSetup';

  @override
  State<GuardianSetupWidget> createState() => _GuardianSetupWidgetState();
}

class _GuardianSetupWidgetState extends State<GuardianSetupWidget> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('guardian_name') ?? '';
      _numberController.text = prefs.getString('guardian_number') ?? '';
    });
  }

  Future<void> _saveGuardian() async {
    if (_nameController.text.trim().isEmpty ||
        _numberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in both name and number.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isSaving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('guardian_name', _nameController.text.trim());
    await prefs.setString('guardian_number', _numberController.text.trim());
    setState(() => _isSaving = false);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Guardian saved!'),
          backgroundColor: Colors.green,
        ),
      );
      // Go directly to SOS after saving
      context.pushNamed(EmergencySOSWidget.routeName);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
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
        backgroundColor: const Color(0xFF0A1A3F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A1A3F),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined,
                size: 40.0, color: Colors.white),
            onPressed: () => context.safePop(),
          ),
          title: Text(
            'ImpairGency',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                  color: Colors.white,
                  fontSize: 45.0,
                  letterSpacing: 0.0,
                ),
          ),
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'SET YOUR GUARDIAN',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                        color: Colors.white,
                        fontSize: 28.0,
                        letterSpacing: 0.0,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your guardian will be called automatically\nwhen you trigger Emergency SOS.',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(),
                        color: Colors.white60,
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                      ),
                ),
                const SizedBox(height: 40),

                // Guardian Name Field
                Text(
                  'Guardian Name',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        color: Colors.white70,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18.0),
                    decoration: const InputDecoration(
                      hintText: 'e.g. Mom, Dad, Sister...',
                      hintStyle: TextStyle(color: Colors.white38),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Guardian Number Field
                Text(
                  'Guardian Phone Number',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        color: Colors.white70,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: TextField(
                    controller: _numberController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9\+\-\s]')),
                    ],
                    style: const TextStyle(
                        color: Color(0xFF3B82F6), fontSize: 20.0),
                    decoration: const InputDecoration(
                      hintText: 'e.g. 0954-123-5679',
                      hintStyle: TextStyle(color: Colors.white38),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 65.0,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveGuardian,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FFFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Color(0xFF0A1A3F))
                        : Text(
                            'SAVE & CALL NOW',
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                      fontWeight: FontWeight.bold),
                                  color: const Color(0xFF0A1A3F),
                                  fontSize: 22.0,
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
    );
  }
}