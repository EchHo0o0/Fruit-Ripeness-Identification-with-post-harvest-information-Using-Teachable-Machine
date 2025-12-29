// TODO Implement this library.
// lib/home/send_feedback_screen.dart
import 'package:flutter/material.dart';

class SendFeedbackScreen extends StatefulWidget {
  const SendFeedbackScreen({Key? key}) : super(key: key);

  @override
  State<SendFeedbackScreen> createState() => _SendFeedbackScreenState();
}

class _SendFeedbackScreenState extends State<SendFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final _emailController = TextEditingController();
  String _feedbackType = 'General Comment';

  final List<String> _feedbackTypes = [
    'General Comment',
    'Bug Report',
    'Feature Suggestion',
    'Incorrect Identification',
  ];

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // Here you would implement your logic to send the feedback
      // For example, sending an email or writing to a Firebase database.
      // We will just print it to the console for now.
      print('Feedback Submitted!');
      print('Type: $_feedbackType');
      print('Message: ${_feedbackController.text}');
      print('Email: ${_emailController.text}');

      // Show a confirmation message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for your feedback!'),
        ),
      );

      // Clear the form
      _feedbackController.clear();
      _emailController.clear();
      setState(() {
        _feedbackType = 'General Comment';
      });
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Feedback'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Help us improve the app by sending us your thoughts!',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _feedbackType,
                decoration: const InputDecoration(
                  labelText: 'Feedback Type',
                  border: OutlineInputBorder(),
                ),
                items: _feedbackTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _feedbackType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _feedbackController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Your Feedback',
                  hintText: 'Describe your feedback or bug report...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Your Email (Optional)',
                  hintText: 'you@example.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit Feedback',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
