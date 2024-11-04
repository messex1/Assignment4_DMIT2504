import 'package:flutter/material.dart';
import '../services/pin_services.dart';

typedef OnCreatePin = void Function(String pin);

class CreatePin extends StatefulWidget {
  const CreatePin({required this.onCreatePin, super.key});

  final OnCreatePin onCreatePin;

  @override
  State<CreatePin> createState() => _CreatePinState();
}

class _CreatePinState extends State<CreatePin> {
  // TODO: create two text controllers for pin and confirm pin
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  String? _errorText;

  // TODO: [OPTIONAL] create a key for the form, _if_ you are going to use form state for validation
  final _formKey = GlobalKey<FormState>(); // Optional form key

  // TODO: properly dispose the controllers
  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _validateAndCreatePin() async {
    final pin = _pinController.text;
    final confirmPin = _confirmPinController.text;

    // TODO: validate input and set error flags accordingly
    if (pin.length < 6 || pin.length > 10) {
      setState(() {
        _errorText = "Pin must be 6-10 digits";
      });
    } else if (pin != confirmPin) {
      setState(() {
        _errorText = "Pin doesn't match";
      });
    } else {
      // TODO: if the fields are valid, store the pin (don't forget to call the onCreatePin callback)
      await storePin(pin); // Store the hashed PIN
      widget.onCreatePin(pin); // Call the callback function with the pin
      Navigator.pop(context); // Close the current screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey, // Optional form key
        child: Column(
          children: [
            const Text('Create a pin to continue', style: TextStyle(fontSize: 20)),
            // TODO: create two text fields for pin and confirm pin;
            // ensure that proper error messages are displayed if there
            // are any errors (see the sample run for the expected output)
            TextField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: 'Pin',
                errorText: _errorText, // Displays error message if any
              ),
              obscureText: true,
              maxLength: 10,
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _confirmPinController,
              decoration: InputDecoration(
                labelText: 'Confirm Pin',
                errorText: _errorText, // Displays error message if any
              ),
              obscureText: true,
              maxLength: 10,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // TODO: validate input and set error flags accordingly
                // TODO: if the fields are valid, store the pin (don't forget to call the onCreatePin callback)
                _validateAndCreatePin(); // Call the validation method
              },
              child: const Text('Create Pin'),
            ),
          ],
        ),
      ),
    );
  }
}
