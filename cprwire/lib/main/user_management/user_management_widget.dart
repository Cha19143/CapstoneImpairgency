import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'user_management_model.dart';
export 'user_management_model.dart';

class UserManagementWidget extends StatefulWidget {
  const UserManagementWidget({super.key});

  static String routeName = 'UserManagement';
  static String routePath = '/userManagement';

  @override
  State<UserManagementWidget> createState() => _UserManagementWidgetState();
}

class _UserManagementWidgetState extends State<UserManagementWidget> {
  late UserManagementModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedFilter = 'ALL';
  final Map<String, Map<String, dynamic>?> _guardianCache = {};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserManagementModel());
    _model.textController ??= TextEditingController(text: '');
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> _fetchGuardian(String viUserId) async {
    if (_guardianCache.containsKey(viUserId)) {
      return _guardianCache[viUserId];
    }

    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'guardian')
        .where('linkedViUserId', isEqualTo: viUserId)
        .limit(1)
        .get();

    final result = query.docs.isNotEmpty
        ? query.docs.first.data() as Map<String, dynamic>
        : null;

    _guardianCache[viUserId] = result;
    return result;
  }

  Widget _filterButton(String label) {
    final isSelected = _selectedFilter == label;
    return FFButtonWidget(
      onPressed: () {
        setState(() {
          _selectedFilter = label;
          _guardianCache.clear();
        });
      },
      text: label,
      options: FFButtonOptions(
        height: 40,
        color: isSelected
            ? FlutterFlowTheme.of(context).primary
            : FlutterFlowTheme.of(context).secondaryText,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  // VI User card with linked guardian
  Widget _buildVIUserCard(QueryDocumentSnapshot user) {
    final data = user.data() as Map<String, dynamic>;
    final firstName = data['firstName'] ?? 'No First Name';
    final lastName = data['lastName'] ?? '';
    final visionType = data['visionType'] ?? 'No Type';
    final email = data['email'] ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Container(
        width: 370,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF3E558B),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // VI User name
            Text(
              '$firstName $lastName',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            if (email.isNotEmpty)
              Text(
                email,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),

            const SizedBox(height: 6),

            Text(
              'TYPE: ${visionType.toUpperCase()}',
              style: const TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 12),

            // Guardian section
            FutureBuilder<Map<String, dynamic>?>(
              future: _fetchGuardian(user.id),
              builder: (context, guardianSnapshot) {
                if (guardianSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white54,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Loading guardian...',
                          style:
                              TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                final guardian = guardianSnapshot.data;

                if (guardian == null) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.person_off,
                            color: Colors.white38, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'No guardian linked',
                          style:
                              TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                final gFirstName = guardian['firstName'] ?? '';
                final gLastName = guardian['lastName'] ?? '';
                final gPhone = guardian['phoneNumber'] ?? '';
                final gEmail = guardian['email'] ?? '';
                final gStatus = guardian['status'] ?? '';

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A3E6E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.lightBlueAccent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shield_outlined,
                              color: Colors.lightBlueAccent, size: 16),
                          const SizedBox(width: 6),
                          const Text(
                            'GUARDIAN',
                            style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const Spacer(),
                          if (gStatus.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: gStatus == 'active'
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                gStatus.toUpperCase(),
                                style: TextStyle(
                                  color: gStatus == 'active'
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '$gFirstName $gLastName',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      if (gPhone.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone,
                                color: Colors.white54, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              gPhone,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ],

                      if (gEmail.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.email,
                                color: Colors.white54, size: 14),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                gEmail,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),

            // Action buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.circle,
                      color: Colors.green, size: 12),
                  label: const Text('Active'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    context.pushNamed(
                      'EditUserAdmin',
                      queryParameters: {'userId': user.id},
                    );
                  },
                  icon: const Icon(Icons.edit, size: 14),
                  label: const Text('Edit'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete User'),
                        content: const Text(
                            'Are you sure you want to delete this user?'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.id)
                          .delete();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User deleted successfully'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.delete, size: 14),
                  label: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Guardian card
  Widget _buildGuardianCard(QueryDocumentSnapshot guardian) {
    final data = guardian.data() as Map<String, dynamic>;
    final firstName = data['firstName'] ?? 'No First Name';
    final lastName = data['lastName'] ?? '';
    final phone = data['phoneNumber'] ?? '';
    final email = data['email'] ?? '';
    final status = data['status'] ?? '';
    final linkedViUserId = data['linkedViUserId'] ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Container(
        width: 370,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF2A3E6E),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.lightBlueAccent.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Guardian label + status
            Row(
              children: [
                const Icon(Icons.shield_outlined,
                    color: Colors.lightBlueAccent, size: 18),
                const SizedBox(width: 6),
                const Text(
                  'GUARDIAN',
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                if (status.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: status == 'active'
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color:
                            status == 'active' ? Colors.green : Colors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // Guardian name
            Text(
              '$firstName $lastName',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            // Email
            if (email.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.email, color: Colors.white54, size: 15),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      email,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 4),

            // Phone
            if (phone.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.white54, size: 15),
                  const SizedBox(width: 6),
                  Text(
                    phone,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),

            const SizedBox(height: 10),

            // Linked VI user
            if (linkedViUserId.isNotEmpty)
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(linkedViUserId)
                    .get(),
                builder: (context, viSnapshot) {
                  if (viSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text(
                      'Loading linked user...',
                      style:
                          TextStyle(color: Colors.white38, fontSize: 12),
                    );
                  }

                  if (!viSnapshot.hasData || !viSnapshot.data!.exists) {
                    return const Text(
                      'Linked VI user not found',
                      style:
                          TextStyle(color: Colors.white38, fontSize: 12),
                    );
                  }

                  final viData =
                      viSnapshot.data!.data() as Map<String, dynamic>;
                  final viFirst = viData['firstName'] ?? '';
                  final viLast = viData['lastName'] ?? '';
                  final viType = viData['visionType'] ?? '';

                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3E558B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.visibility,
                            color: Colors.lightBlueAccent, size: 15),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'LINKED VI USER',
                                style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$viFirst $viLast',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (viType.isNotEmpty)
                                Text(
                                  viType.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 12),

            // Action buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.circle,
                      color: Colors.green, size: 12),
                  label: const Text('Active'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    context.pushNamed(
                      'EditUserAdmin',
                      queryParameters: {'userId': guardian.id},
                    );
                  },
                  icon: const Icon(Icons.edit, size: 14),
                  label: const Text('Edit'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Guardian'),
                        content: const Text(
                            'Are you sure you want to delete this guardian?'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(guardian.id)
                          .delete();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Guardian deleted successfully'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.delete, size: 14),
                  label: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGuardianFilter = _selectedFilter == 'GUARDIAN';

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF0A1A3F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A1A3F),
          automaticallyImplyLeading: false,
          title: Text(
            'User Management',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                  color: Colors.white,
                  fontSize: 36,
                ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),

                const Text(
                  'Find Active User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: 350,
                  child: TextFormField(
                    controller: _model.textController,
                    focusNode: _model.textFieldFocusNode,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search User',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: const Color(0xFF0A1A3F),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white54),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Filter buttons
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _filterButton('ALL'),
                    _filterButton('BLIND'),
                    _filterButton('VISION LOSS'),
                    _filterButton('GUARDIAN'),
                  ],
                ),

                const SizedBox(height: 10),

                // GUARDIAN filter — separate stream
                if (isGuardianFilter)
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('role', isEqualTo: 'guardian')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      final allGuardians = snapshot.data!.docs;

                      final searchQuery = _model.textController?.text
                              .trim()
                              .toLowerCase() ??
                          '';
                      final guardians = searchQuery.isEmpty
                          ? allGuardians
                          : allGuardians.where((doc) {
                              final data =
                                  doc.data() as Map<String, dynamic>;
                              final firstName = (data['firstName'] ?? '')
                                  .toString()
                                  .toLowerCase();
                              final lastName = (data['lastName'] ?? '')
                                  .toString()
                                  .toLowerCase();
                              return firstName.contains(searchQuery) ||
                                  lastName.contains(searchQuery);
                            }).toList();

                      if (guardians.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            'No guardians found.',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 16),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: guardians.length,
                        itemBuilder: (context, index) =>
                            _buildGuardianCard(guardians[index]),
                      );
                    },
                  ),

                // ALL / BLIND / VISION LOSS filter — VI users stream
                if (!isGuardianFilter)
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('role', isEqualTo: 'visually_impaired')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      final allUsers = snapshot.data!.docs;

                      // Vision type filter
                      final filteredByType = _selectedFilter == 'ALL'
                          ? allUsers
                          : allUsers.where((doc) {
                              final data =
                                  doc.data() as Map<String, dynamic>;
                              final visionType =
                                  (data['visionType'] ?? '')
                                      .toString()
                                      .toLowerCase();
                              if (_selectedFilter == 'BLIND') {
                                return visionType == 'blind';
                              } else if (_selectedFilter == 'VISION LOSS') {
                                return visionType == 'vision_loss';
                              }
                              return true;
                            }).toList();

                      // Search filter
                      final searchQuery = _model.textController?.text
                              .trim()
                              .toLowerCase() ??
                          '';
                      final users = searchQuery.isEmpty
                          ? filteredByType
                          : filteredByType.where((doc) {
                              final data =
                                  doc.data() as Map<String, dynamic>;
                              final firstName = (data['firstName'] ?? '')
                                  .toString()
                                  .toLowerCase();
                              final lastName = (data['lastName'] ?? '')
                                  .toString()
                                  .toLowerCase();
                              return firstName.contains(searchQuery) ||
                                  lastName.contains(searchQuery);
                            }).toList();

                      if (users.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            'No users found.',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 16),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) =>
                            _buildVIUserCard(users[index]),
                      );
                    },
                  ),

                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(AdminadduserWidget.routeName);
                    },
                    text: '',
                    icon: const Icon(Icons.add_circle, size: 70),
                    options: FFButtonOptions(
                      height: 82,
                      color: const Color(0xFF0A1A3F),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(8),
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