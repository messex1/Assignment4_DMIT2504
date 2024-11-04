import 'package:flutter/material.dart';
import '../models/password_account.dart';
import '../widgets/account_details.dart';
import '../widgets/check_pin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PasswordAccount? _currentAccount;

  void _onCheckPin(bool isStored, String pin) {
    if (isStored) {
      // Placeholder action for validated PIN
      setState(() {
        _currentAccount = PasswordAccount(
          site: 'example.com',
          username: 'exampleUser',
          password: 'examplePass',
          notes: 'Example notes',
        );
      });
    }
  }

  void _onSaveAccount({
    required String site,
    required String username,
    required String password,
    String? notes,
  }) {
    setState(() {
      _currentAccount = PasswordAccount(
        site: site,
        username: username,
        password: password,
        notes: notes,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _currentAccount == null
            ? CheckPin(onCheckPin: _onCheckPin)
            : AccountDetails(
                account: _currentAccount,
                pin: '1234', // Placeholder pin
                onSave: _onSaveAccount,
              ),
      ),
    );
  }
}
