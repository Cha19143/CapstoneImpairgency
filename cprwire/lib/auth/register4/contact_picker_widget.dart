import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class ContactPickerWidget extends StatefulWidget {
  const ContactPickerWidget({super.key});

  @override
  State<ContactPickerWidget> createState() => _ContactPickerWidgetState();
}

class _ContactPickerWidgetState extends State<ContactPickerWidget> {
  List<Contact> _allContacts = [];
  List<Contact> _filteredContacts = [];
  final Set<String> _selectedContactIds = {};
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      // Kunin lahat ng contacts na may phone number
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
      );

      // I-filter lang yung mga may kahit isang phone number
      final contactsWithNumbers =
          contacts.where((c) => c.phones.isNotEmpty).toList();

      // I-sort by name
      contactsWithNumbers.sort((a, b) =>
          a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));

      setState(() {
        _allContacts = contactsWithNumbers;
        _filteredContacts = contactsWithNumbers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading contacts: $e')),
        );
      }
    }
  }

  void _filterContacts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredContacts = _allContacts;
      } else {
        _filteredContacts = _allContacts
            .where((c) =>
                c.displayName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleContact(Contact contact) {
    setState(() {
      if (_selectedContactIds.contains(contact.id)) {
        _selectedContactIds.remove(contact.id);
      } else {
        _selectedContactIds.add(contact.id);
      }
    });
  }

  void _confirmSelection() {
    final selected = _allContacts
        .where((c) => _selectedContactIds.contains(c.id))
        .map((c) => {
              'name': c.displayName,
              'number': c.phones.first.number,
            })
        .toList();

    Navigator.of(context).pop(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B1F3A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1A3F),
        title: Text(
          'Select Contacts',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if (_selectedContactIds.isNotEmpty)
            TextButton(
              onPressed: _confirmSelection,
              child: Text(
                'Done (${_selectedContactIds.length})',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: _filterContacts,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search contacts',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Color(0xFF3E558B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                if (_filteredContacts.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? 'No contacts with phone numbers found.'
                            : 'No contacts match "$_searchQuery".',
                        style: TextStyle(color: Colors.white70, fontSize: 16.0),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = _filteredContacts[index];
                        final isSelected =
                            _selectedContactIds.contains(contact.id);
                        final phoneNumber = contact.phones.isNotEmpty
                            ? contact.phones.first.number
                            : '';

                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (_) => _toggleContact(contact),
                          activeColor: FlutterFlowTheme.of(context).primary,
                          checkColor: Colors.white,
                          title: Text(
                            contact.displayName,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            phoneNumber,
                            style: TextStyle(color: Colors.white70),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
                  ),
              ],
            ),
      floatingActionButton: _selectedContactIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _confirmSelection,
              backgroundColor: FlutterFlowTheme.of(context).primary,
              icon: Icon(Icons.check, color: Colors.white),
              label: Text(
                'Add ${_selectedContactIds.length} contact${_selectedContactIds.length > 1 ? 's' : ''}',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }
}
