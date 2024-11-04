import 'package:flutter/material.dart';
import '../services/pin_services.dart';

typedef OnCheckPin = void Function(bool isStored, String pin);

class CheckPin extends StatefulWidget {
  const CheckPin({
    required this.onCheckPin,
    super.key,
  });

  final OnCheckPin onCheckPin;

  @override
  State<CheckPin> createState() => _CheckPinState();
}

class _CheckPinState extends State<CheckPin> {
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _validatePin() {
    final hashedPin = hashPin(_pinController.text);
    // Placeholder check, should match hashedPin to stored value.
    widget.onCheckPin(hashedPin.isNotEmpty, _pinController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _pinController,
          decoration: const InputDecoration(labelText: 'Enter PIN'),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _validatePin,
          child: const Text('Validate PIN'),
        ),
      ],
    );
  }
}
