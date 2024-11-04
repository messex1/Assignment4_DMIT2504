import '../models/password_account.dart';
import '../utils/encryption_services.dart';
import 'package:flutter/material.dart';

typedef OnSave = void Function({
  required String site,
  required String username,
  required String password,
  String? notes,
});

class AccountDetails extends StatefulWidget {
  const AccountDetails({
    this.account,
    required this.pin,
    required this.onSave,
    super.key,
  });

  final PasswordAccount? account;
  final OnSave onSave;
  final String pin;

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  // Text controllers for site, username, password, and notes
  final _siteController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _notesController = TextEditingController();

  // Optional: form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with decrypted values for existing account
    if (widget.account != null) {
      _siteController.text = decryptText(widget.account!.site);
      _usernameController.text = decryptText(widget.account!.username);
      _passwordController.text = decryptText(widget.account!.password);
      _notesController.text = widget.account!.notes != null
          ? decryptText(widget.account!.notes!)
          : '';
    }
  }

  // Dispose the controllers properly
  @override
  void dispose() {
    _siteController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Builds the Save or Add button
  Widget _buildSaveButton(bool isEditing) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () {
        // Validate input and trigger onSave if valid
        if (_formKey.currentState?.validate() ?? false) {
          widget.onSave(
            site: _siteController.text,
            username: _usernameController.text,
            password: _passwordController.text,
            notes: _notesController.text.isNotEmpty ? _notesController.text : null,
          );
        }
      },
      child: Text(isEditing ? 'Save' : 'Add'),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.account != null;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _siteController,
            decoration: const InputDecoration(labelText: 'Site'),
            validator: (value) =>
                value == null || value.isEmpty ? 'Site is required' : null,
            enabled: !isEditing, // Disable editing for existing accounts
          ),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
            validator: (value) =>
                value == null || value.isEmpty ? 'Username is required' : null,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (value) =>
                value == null || value.isEmpty ? 'Password cannot be empty' : null,
            obscureText: true,
          ),
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Notes (Optional)'),
          ),
          const SizedBox(height: 20),
          _buildSaveButton(isEditing),
        ],
      ),
    );
  }
}
