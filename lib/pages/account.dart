import 'package:assignment_04/models/password_account.dart';
import 'package:flutter/material.dart';
import '../data/password_account_db_manager.dart';
import '../widgets/account_details.dart';

typedef OnSave = void Function(PasswordAccount? pa);

class AccountPage extends StatefulWidget {
  const AccountPage({
    this.account,
    required this.pin,
    required this.dbManager,
    required this.onSave,
    super.key,
  });

  final PasswordAccount? account;
  final String pin;
  final PasswordAccountDbManager dbManager;
  final OnSave onSave;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Widget _buildDeleteButton() {
    if (widget.account == null) {
      return const SizedBox.shrink();
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Account'),
              content: const Text('Are you sure you want to delete this account?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    // TODO: delete the account from the database
                    await widget.dbManager.deleteAccount(widget.account!);
                    widget.onSave(null);

                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Account deleted'),
                        ),
                      );
                    }
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      child: const Text('Delete Account'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.account != null
            ? const Text('View Account')
            : const Text('Add Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AccountDetails(
              pin: widget.pin,
              onSave: ({required site, required username, required password, notes}) async {
                final newAccount = PasswordAccount(
                  site: site,
                  username: username,
                  password: password,
                  notes: notes,
                );

                // TODO: if there was an account passed in, update it in the database, otherwise add it to the database
                if (widget.account != null) {
                  await widget.dbManager.updateAccount(newAccount);
                } else {
                  await widget.dbManager.createAccount(newAccount);
                }
                widget.onSave(newAccount);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account saved'),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              account: widget.account,
            ),
            const SizedBox(height: 20),
            _buildDeleteButton(),
          ],
        ),
      ),
    );
  }
}
