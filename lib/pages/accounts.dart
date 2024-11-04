import 'package:assignment_04/models/password_account.dart';
import 'package:assignment_04/pages/account.dart';
import 'package:flutter/material.dart';
import '../data/password_account_db_manager.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({required this.pin, required this.dbManager, super.key});

  final PasswordAccountDbManager dbManager;
  final String pin;

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  List<PasswordAccount> _accounts = [];

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  // TODO: use the dbManager to get all accounts, set the state accordingly
  void _loadAccounts() async {
    _accounts = await widget.dbManager.getAllAccounts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountPage(
                pin: widget.pin,
                dbManager: widget.dbManager,
                onSave: (account) {
                  if (account != null) {
                    setState(() {
                      _accounts.add(account);
                    });
                  }
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      // TODO: the password account details should be encrypted; you will need to decrypt the account details before displaying them
      body: _accounts.isNotEmpty
          ? ListView.separated(
              itemCount: _accounts.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final account = _accounts[index];
                return ListTile(
                  title: Text('Site: ${account.site}'),
                  subtitle: Text('Username: ${account.username}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountPage(
                          account: account,
                          pin: widget.pin,
                          dbManager: widget.dbManager,
                          onSave: (returnAccount) {
                            if (returnAccount == null) {
                              setState(() {
                                _accounts.remove(account);
                              });
                            } else {
                              setState(() {
                                final index = _accounts.indexOf(account);
                                _accounts[index] = returnAccount;
                              });
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : const Center(
              child: Text('No accounts found'),
            ),
    );
  }
}
